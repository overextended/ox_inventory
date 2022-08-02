if not lib then return end

local Inventory = {}
local Inventories = {}
local Stashes = data 'stashes'

local function openStash(data, player)
	local stash = Stashes[data.id] or Inventory.CustomStash[data.id]

	if stash then
		if stash.jobs then stash.groups = stash.jobs end
		if player and stash.groups and not server.hasGroup(player, stash.groups) then return end

		local owner

		if stash.owner then
			if player and (stash.owner == true or data.owner == true) then
				owner = player.owner
			elseif stash.owner then
				owner = stash.owner or data.owner
			end
		end

		local inventory = Inventories[owner and ('%s:%s'):format(stash.name, owner) or stash.name]

		if not inventory then
			inventory = Inventory.Create(stash.name, stash.label or stash.name, 'stash', stash.slots, 0, stash.weight, owner, false, stash.groups)
		end

		return inventory
	else return false end
end

setmetatable(Inventory, {
	__call = function(self, inv, player)
		if not inv then
			return self
		elseif type(inv) == 'table' then
			if inv.items then return inv end
			return openStash(inv, player)
		elseif not Inventories[inv] then
			return openStash({ id = inv }, player)
		end

		return Inventories[inv]
	end
})

exports('Inventory', function(id, owner)
	if not id then return Inventory end
	local type = type(id)

	if type == 'table' or type == 'number' then
		return Inventory(id)
	else
		return Inventory({ id = id, owner = owner })
	end
end)

---@param inv string | number
---@param k string
---@param v any
function Inventory.Set(inv, k, v)
	inv = Inventory(inv)
	if inv then
		if type(v) == 'number' then math.floor(v + 0.5) end

		if k == 'open' and v == false then
			if inv.type ~= 'player' then
				if inv.type == 'otherplayer' then
					inv.type = 'player'
				elseif inv.type == 'drop' and not next(inv.items) then
					return Inventory.Remove(inv.id, inv.type)
				else
					inv.time = os.time()
				end
			end
		elseif k == 'maxWeight' and v < 1000 then
			v *= 1000
		end

		inv[k] = v
	end
end

---@param inv string | number
---@param key string
function Inventory.Get(inv, key)
	inv = Inventory(inv)
	if inv then
		return inv[key]
	end
end

---@param inv string | number
---@return table items table containing minimal inventory data
local function minimal(inv)
	inv = Inventory(inv)
	local inventory, count = {}, 0
	for k, v in pairs(inv.items) do
		if v.name and v.count > 0 then
			count += 1
			inventory[count] = {
				name = v.name,
				count = v.count,
				slot = k,
				metadata = next(v.metadata) and v.metadata or nil
			}
		end
	end
	return inventory
end

---@param inv table
--- Syncs inventory data with the xPlayer object for compatibility with shit resources
function Inventory.SyncInventory(inv)
	local money = table.clone(server.accounts)

	for _, v in pairs(inv.items) do
		if money[v.name] then
			money[v.name] += v.count
		end
	end

	server.GetPlayerFromId(inv.id).syncInventory(inv.weight, inv.maxWeight, inv.items, money)
end

---@param inv string | number
---@param item table item data
---@param count number
---@param metadata any
---@param slot any
function Inventory.SetSlot(inv, item, count, metadata, slot)
	inv = Inventory(inv)
	local currentSlot = inv.items[slot]
	local newCount = currentSlot and currentSlot.count + count or count
	local newWeight = currentSlot and inv.weight - currentSlot.weight or inv.weight

	if currentSlot and newCount < 1 then
		currentSlot = nil
	else
		currentSlot = {name = item.name, label = item.label, weight = item.weight, slot = slot, count = newCount, description = item.description, metadata = metadata, stack = item.stack, close = item.close}
		local slotWeight = Inventory.SlotWeight(item, currentSlot)
		currentSlot.weight = slotWeight
		newWeight += slotWeight
	end

	inv.weight = newWeight
	inv.items[slot] = currentSlot

	if not inv.player then
		inv.changed = true
	end
end

local Items

CreateThread(function()
	Items = server.items

	-- Require "set inventory:weaponmismatch 1" to enable experimental weapon checks.
	-- Maybe need some tweaks, and will definitely need more hashes added to the ignore list.
	-- May even use weaponDamageEvent, depending on performance..
	if GetConvarInt('inventory:weaponmismatch', 0) == 0 then return end

	local ignore = {
		[0] = 1, -- GetSelectedPedWeapon returns 0 when using a firetruk; likely some other cases
		[966099553] = 1, -- I don't know
		[`WEAPON_UNARMED`] = 1,
		[`WEAPON_ANIMAL`] = 1,
		[`WEAPON_COUGAR`] = 1,
	}

	while true do
		Wait(30000)

		for id, inv in pairs(Inventories) do
			if inv.player then
				local hash = GetSelectedPedWeapon(inv.player.ped)

				if not ignore[hash] then
					local currentWeapon = inv.items[inv.weapon]?.name

					if currentWeapon then
						local currentHash = Items(currentWeapon).hash

						if currentHash ~= hash then
							inv.weapon = nil
							print(('Player.%s weapon mismatch (%s). Current weapon: %s (%s)'):format(id, hash, currentWeapon, currentHash))
						end
					else
						print(('Player.%s weapon mismatch (%s)'):format(id, hash, currentWeapon))
					end

					if not inv.weapon then
						TriggerClientEvent('ox_inventory:disarm', id)
					end
				end
			end
		end
	end
end)

---@param item table
---@param slot table
function Inventory.SlotWeight(item, slot)
	local weight = item.weight * slot.count
	if not slot.metadata then slot.metadata = {} end

	if item.ammoname and slot.metadata.ammo then
		weight += (Items(item.ammoname).weight * slot.metadata.ammo)
	end

	if slot.metadata.components then
		for i = 1, #slot.metadata.components do
			weight += Items(slot.metadata.components[i]).weight
		end
	end

	if slot.metadata.weight then
		weight += (slot.metadata.weight * slot.count)
	end

	return weight
end

---@param items table
function Inventory.CalculateWeight(items)
	local weight = 0
	for _, v in pairs(items) do
		local item = Items(v.name)
		if item then
			weight = weight + Inventory.SlotWeight(item, v)
		end
	end
	return weight
end

---@param id string|number
---@param label string|nil
---@param invType string
---@param slots number
---@param weight number
---@param maxWeight number
---@param owner string
---@param items? table
--- This should only be utilised internally!
--- To create a stash, please use `exports.ox_inventory:RegisterStash` instead.
function Inventory.Create(id, label, invType, slots, weight, maxWeight, owner, items, groups)
	if maxWeight then
		local self = {
			id = id,
			label = label or id,
			type = invType,
			slots = slots,
			weight = weight,
			maxWeight = maxWeight,
			owner = owner,
			items = type(items) == 'table' and items,
			open = false,
			set = Inventory.Set,
			get = Inventory.Get,
			minimal = minimal,
			time = os.time(),
			groups = groups,
		}

		if invType == 'drop' then
			self.datastore = true
		else
			self.changed = false

			if invType ~= 'glovebox' and invType ~= 'trunk' then
				self.dbId = id

				if invType ~= 'player' and owner and type(owner) ~= 'boolean' then
					self.id = ('%s:%s'):format(self.id, owner)
				end
			else
				if Ox then
					self.dbId = id
					self.id = (invType == 'glovebox' and 'glove' or invType)..label
				else
					self.dbId = label
				end
			end
		end

		if not items then
			self.items, self.weight, self.datastore = Inventory.Load(self.dbId, invType, owner)
		elseif weight == 0 and next(items) then
			self.weight = Inventory.CalculateWeight(items)
		end

		Inventories[self.id] = self
		return Inventories[self.id]
	end
end

---@param id string|number
---@param type string
function Inventory.Remove(id, type)
	if type == 'drop' then
		TriggerClientEvent('ox_inventory:removeDrop', -1, id)
		Inventory.Drops[id] = nil
	end
	Inventories[id] = nil
end

---Update the internal reference to vehicle stashes. Does not trigger a save or update the database.
---@param oldPlate string
---@param newPlate string
function Inventory.UpdateVehicle(oldPlate, newPlate)
	local trunk = Inventory('trunk'..oldPlate)
	local glove = Inventory('glove'..oldPlate)

	if trunk then
		Inventories[trunk.id] = nil
		trunk.label = newPlate
		trunk.dbId = type(trunk.id) == 'number' and trunk.dbId or newPlate
		trunk.id = 'trunk'..newPlate
		Inventories[trunk.id] = trunk
	end

	if glove then
		Inventories[glove.id] = nil
		glove.label = newPlate
		glove.dbId = type(glove.id) == 'number' and glove.dbId or newPlate
		glove.id = 'glove'..newPlate
		Inventories[glove.id] = glove
	end
end

function Inventory.Save(inv)
	inv = Inventory(inv)

	if inv then
		local items = json.encode(minimal(inv))

		if inv.type == 'player' then
			db.savePlayer(inv.owner, items)
		else
			if inv.type == 'trunk' then
				db.saveTrunk(inv.dbId, items)
			elseif inv.type == 'glovebox' then
				db.saveGlovebox(inv.dbId, items)
			else
				db.saveStash(inv.owner, inv.dbId, items)
			end

			inv.changed = false
		end
	end
end

local function randomItem(loot, items, size)
	local item = loot[math.random(1, size)]
	for i = 1, #items do
		if items[i][1] == item[1] then
			return randomItem(loot, items, size)
		end
	end
	return item
end

local function randomLoot(loot)
	local items = {}

	if loot then
		local size = #loot
		for i = 1, math.random(0, 3) do
			if i > size then return items end
			local item = randomItem(loot, items, size)
			if math.random(1, 100) <= (item[4] or 80) then
				local count = math.random(item[2], item[3])
				if count > 0 then
					items[#items+1] = {item[1], count}
				end
			end
		end
	end

	return items
end

---@param inv string | number
---@param invType string
---@param items? table
---@return table returnData, number totalWeight, boolean true
local function generateItems(inv, invType, items)
	if items == nil then
		if invType == 'dumpster' then
			items = randomLoot(server.dumpsterloot)
		elseif invType == 'vehicle' then
			items = randomLoot(server.vehicleloot)
		end
	end

	local returnData, totalWeight = table.create(#items, 0), 0
	for i = 1, #items do
		local v = items[i]
		local item = Items(v[1])
		if not item then
			shared.warning('unable to generate', v[1], 'item does not exist')
		else
			local metadata, count = Items.Metadata(inv, item, v[3] or {}, v[2])
			local weight = Inventory.SlotWeight(item, {count=count, metadata=metadata})
			totalWeight = totalWeight + weight
			returnData[i] = {name = item.name, label = item.label, weight = weight, slot = i, count = count, description = item.description, metadata = metadata, stack = item.stack, close = item.close}
		end
	end

	return returnData, totalWeight, true
end

---@param id string|number
---@param invType string
---@param owner string
function Inventory.Load(id, invType, owner)
	local datastore, result

	if id and invType then
		if invType == 'dumpster' then
			if server.randomloot then
				return generateItems(id, invType)
			else
				datastore = true
			end
		elseif invType == 'trunk' or invType == 'glovebox' then
			result = invType == 'trunk' and db.loadTrunk(id) or db.loadGlovebox(id)

			if not result then
				if server.randomloot then
					return generateItems(id, 'vehicle')
				else
					datastore = true
				end
			else result = result[invType] end
		else
			result = db.loadStash(owner or '', id)
		end
	end

	local returnData, weight = {}, 0

	if result and type(result) == 'string' then
		result = json.decode(result)
	end

	if result then
		local ostime = os.time()

		for _, v in pairs(result) do
			local item = Items(v.name)
			if item then
				if v.metadata then
					v.metadata = Items.CheckMetadata(v.metadata, item, v.name, ostime)
				end

				local slotWeight = Inventory.SlotWeight(item, v)
				weight += slotWeight
				returnData[v.slot] = {name = item.name, label = item.label, weight = slotWeight, slot = v.slot, count = v.count, description = item.description, metadata = v.metadata or {}, stack = item.stack, close = item.close}
			end
		end
	end

	return returnData, weight, datastore
end

local table = lib.table

---@param inv string | number
---@param item table | string
---@param metadata? any
---@param returnsCount? boolean
---@return table|number
function Inventory.GetItem(inv, item, metadata, returnsCount)
	if type(item) ~= 'table' then item = Items(item) end

	if item then
		item = returnsCount and item or table.clone(item)
		inv = Inventory(inv)
		local count = 0

		if inv then
			local ostime = os.time()

			if type(metadata) ~= 'table' then
				metadata = metadata and { type = metadata or nil }
			end

			for _, v in pairs(inv.items) do
				if v and v.name == item.name and (not metadata or table.contains(v.metadata, metadata)) then
					count += v.count
					local durability = v.metadata.durability

					if durability and durability > 100 and ostime >= durability then
						v.metadata.durability = 0
					end
				end
			end
		end

		if returnsCount then return count else
			item.count = count
			return item
		end
	end
end
exports('GetItem', Inventory.GetItem)

---@param fromInventory any
---@param toInventory any
---@param slot1 number
---@param slot2 number
function Inventory.SwapSlots(fromInventory, toInventory, slot1, slot2)
	local fromSlot = fromInventory.items[slot1] and table.clone(fromInventory.items[slot1]) or nil
	local toSlot = toInventory.items[slot2] and table.clone(toInventory.items[slot2]) or nil
	if fromSlot then fromSlot.slot = slot2 end
	if toSlot then toSlot.slot = slot1 end
	fromInventory.items[slot1], toInventory.items[slot2] = toSlot, fromSlot
	return fromSlot, toSlot
end
exports('SwapSlots', Inventory.SwapSlots)

function Inventory.ContainerWeight(container, metaWeight, playerInventory)
	playerInventory.weight -= container.weight
	container.weight = Items(container.name).weight
	container.weight += metaWeight
	container.metadata.weight = metaWeight
	playerInventory.weight += container.weight
end

---@param inv string | number
---@param item table | string
---@param count number
---@param metadata? table
function Inventory.SetItem(inv, item, count, metadata)
	if type(item) ~= 'table' then item = Items(item) end
	if item and count >= 0 then
		inv = Inventory(inv)
		if inv then
			local itemCount = Inventory.GetItem(inv, item.name, metadata, true)
			if count > itemCount then
				count -= itemCount
				Inventory.AddItem(inv, item.name, count, metadata)
			elseif count <= itemCount then
				itemCount -= count
				Inventory.RemoveItem(inv, item.name, itemCount, metadata)
			end
		end
	end
end

---@param inv string | number
---@return table item
function Inventory.GetCurrentWeapon(inv)
	inv = Inventory(inv)

	if inv?.player then
		local weapon = inv.items[inv.weapon]

		if weapon and Items(weapon.name).weapon then
			return weapon
		end

		inv.weapon = nil
	end
end
exports('GetCurrentWeapon', Inventory.GetCurrentWeapon)

---@param inv string | number
---@param slot number
---@return table? item
function Inventory.GetSlot(inv, slot)
	inv = Inventory(inv)

	if inv then
		slot = inv.items[slot]
		local durability = slot?.metadata.durability

		if durability and durability > 100 and os.time() >= durability then
			slot.metadata.durability = 0
		end

		return slot
	end
end
exports('GetSlot', Inventory.GetSlot)

---@param inv string | number
---@param slot number
---@return table item
function Inventory.SetDurability(inv, slot, durability)
	inv = Inventory(inv)

	if inv then
		slot = inv.items[slot]

		if slot then
			slot.metadata.durability = durability

			if inv.type == 'player' then
				if shared.framework == 'esx' then Inventory.SyncInventory(inv) end
				TriggerClientEvent('ox_inventory:updateSlots', inv.id, {{item = slot, inventory = inv.type}}, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight})
			end
		end
	end
end
exports('SetDurability', Inventory.SetDurability)

---@param inv string | number
---@param slot number
---@param metadata table
function Inventory.SetMetadata(inv, slot, metadata)
	inv = Inventory(inv)
	slot = type(slot) == 'number' and (inv and inv.items[slot])
	if inv and slot then
		if inv then
			slot.metadata = type(metadata) == 'table' and metadata or { type = metadata or nil }

			if metadata.weight then
				inv.weight -= slot.weight
				slot.weight = Inventory.SlotWeight(Items(slot.name), slot)
				inv.weight += slot.weight
			end

			if inv.type == 'player' then
				if shared.framework == 'esx' then Inventory.SyncInventory(inv) end
				TriggerClientEvent('ox_inventory:updateSlots', inv.id, {{item = slot, inventory = inv.type}}, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight})
			end
		end
	end
end
exports('SetMetadata', Inventory.SetMetadata)

---@param inv string | number
---@param item table | string
---@param count number
---@param metadata? table | string
---@param slot number
---@param cb function
-- todo: add parameter checks to remove need for nil args
-- todo: add callback with several reasons for failure
-- ```
-- exports.ox_inventory:AddItem(1, 'bread', 4, nil, nil, function(success, reason)
-- if not success then
-- 	if reason == 'overburdened' then
-- 		TriggerClientEvent('ox_lib:notify', source, { type = 'error', description= shared.locale('cannot_carry', count, data.label) })
-- 	end
-- end
-- ```
function Inventory.AddItem(inv, item, count, metadata, slot, cb)
	if type(item) ~= 'table' then item = Items(item) end
	if type(inv) ~= 'table' then inv = Inventory(inv) end
	count = math.floor(count + 0.5)
	local success, resp

	if item then
		if inv then
			metadata, count = Items.Metadata(inv.id, item, metadata or {}, count)
			local existing = false

			if slot then
				local slotItem = inv.items[slot]
				if not slotItem or item.stack and slotItem and slotItem.name == item.name and table.matches(slotItem.metadata, metadata) then
					existing = nil
				end
			end

			if existing == false then
				local items, toSlot = inv.items, nil
				for i = 1, shared.playerslots do
					local slotItem = items[i]
					if item.stack and slotItem ~= nil and slotItem.name == item.name and table.matches(slotItem.metadata, metadata) then
						toSlot, existing = i, true break
					elseif not toSlot and slotItem == nil then
						toSlot = i
					end
				end
				slot = toSlot
			end

			if slot then
				Inventory.SetSlot(inv, item, count, metadata, slot)

				if cb then
					success = true
					resp = inv.items[slot]
				end

				if inv.type == 'player' then
					if shared.framework == 'esx' then Inventory.SyncInventory(inv) end
					TriggerClientEvent('ox_inventory:updateSlots', inv.id, {{item = inv.items[slot], inventory = inv.type}}, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight}, count, false)
				end
			else
				resp = cb and 'inventory_full'
			end
		else
			resp = cb and 'invalid_inventory'
		end
	else
		resp = cb and 'invalid_item'
	end

	if cb then cb(success, resp) end
end
exports('AddItem', Inventory.AddItem)

---@param inv string | number
---@param search string|number slots|1, count|2
---@param items table | string
---@param metadata? table | string
function Inventory.Search(inv, search, items, metadata)
	if items then
		inv = Inventory(inv)
		if inv then
			inv = inv.items

			if search == 'slots' then search = 1 elseif search == 'count' then search = 2 end
			if type(items) == 'string' then items = {items} end

			if type(metadata) ~= 'table' then
				metadata = metadata and { type = metadata or nil }
			end

			local itemCount = #items
			local returnData = {}

			for i = 1, itemCount do
				local item = string.lower(items[i])
				if item:sub(0, 7) == 'weapon_' then item = string.upper(item) end

				if search == 1 then
					returnData[item] = {}
				elseif search == 2 then
					returnData[item] = 0
				end

				for _, v in pairs(inv) do
					if v.name == item then
						if not v.metadata then v.metadata = {} end

						if not metadata or table.contains(v.metadata, metadata) then
							if search == 1 then
								returnData[item][#returnData[item]+1] = inv[v.slot]
							elseif search == 2 then
								returnData[item] += v.count
							end
						end
					end
				end
			end

			if next(returnData) then return itemCount == 1 and returnData[items[1]] or returnData end
		end
	end

	return false
end
exports('Search', Inventory.Search)

---@param inv string | number
---@param item table | string
---@param metadata? table
function Inventory.GetItemSlots(inv, item, metadata)
	inv = Inventory(inv)
	local totalCount, slots, emptySlots = 0, {}, inv.slots
	for k, v in pairs(inv.items) do
		emptySlots -= 1
		if v.name == item.name then
			if metadata and v.metadata == nil then
				v.metadata = {}
			end
			if not metadata or table.matches(v.metadata, metadata) then
				totalCount = totalCount + v.count
				slots[k] = v.count
			end
		end
	end
	return slots, totalCount, emptySlots
end
exports('GetItemSlots', Inventory.GetItemSlots)

---@param inv string | number
---@param item table | string
---@param count number
---@param metadata? table | string
---@param slot number
function Inventory.RemoveItem(inv, item, count, metadata, slot)
	if type(item) ~= 'table' then item = Items(item) end
	count = math.floor(count + 0.5)
	if item and count > 0 then
		inv = Inventory(inv)

		if type(metadata) ~= 'table' then
			metadata = metadata and { type = metadata or nil }
		end

		local itemSlots, totalCount = Inventory.GetItemSlots(inv, item, metadata)
		if count > totalCount then count = totalCount end
		local removed, total, slots = 0, count, {}
		if slot and itemSlots[slot] then
			removed = count
			Inventory.SetSlot(inv, item, -count, inv.items[slot].metadata, slot)
			slots[#slots+1] = inv.items[slot] or slot
		elseif itemSlots and totalCount > 0 then
			for k, v in pairs(itemSlots) do
				if removed < total then
					if v == count then
						removed = total
						inv.weight -= inv.items[k].weight
						inv.items[k] = nil
						slots[#slots+1] = inv.items[k] or k
					elseif v > count then
						Inventory.SetSlot(inv, item, -count, inv.items[k].metadata, k)
						slots[#slots+1] = inv.items[k] or k
						removed = total
						count = v - count
					else
						removed = removed + v
						count = count - v
						inv.weight -= inv.items[k].weight
						inv.items[k] = nil
						slots[#slots+1] = k
					end
				else break end
			end
		end

		if removed > 0 and inv.type == 'player' then
			if shared.framework == 'esx' then Inventory.SyncInventory(inv) end
			local array = table.create(#slots, 0)

			for k, v in pairs(slots) do
				array[k] = {item = type(v) == 'number' and { slot = v } or v, inventory = inv.type}
			end

			TriggerClientEvent('ox_inventory:updateSlots', inv.id, array, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight}, removed, true)
		end
	end
end
exports('RemoveItem', Inventory.RemoveItem)

---@param inv string | number
---@param item table | string
---@param count number
---@param metadata? table | string
function Inventory.CanCarryItem(inv, item, count, metadata)
	if type(item) ~= 'table' then item = Items(item) end
	if item then
		inv = Inventory(inv)
		local itemSlots, totalCount, emptySlots = Inventory.GetItemSlots(inv, item, type(metadata) == 'table' and metadata or { type = metadata or nil })
		local weight = metadata?.weight or item.weight

		if next(itemSlots) or emptySlots > 0 then
			if weight == 0 then return true end
			if count == nil then count = 1 end
			local newWeight = inv.weight + (weight * count)

			if newWeight > inv.maxWeight then
				TriggerClientEvent('ox_lib:notify', inv.id, { type = 'error', description = shared.locale('cannot_carry') })
				return false
			end

			return true
		end
	end
end
exports('CanCarryItem', Inventory.CanCarryItem)

---@param inv string | number
---@param item table | string
function Inventory.CanCarryAmount(inv, item)
    if type(item) ~= 'table' then item = Items(item) end
    if item then
        inv = Inventory(inv)
            local availableWeight = inv.maxWeight - inv.weight
            local canHold = math.floor(availableWeight / item.weight)
            return canHold
    end
end
exports('CanCarryAmount', Inventory.CanCarryAmount)

---@param inv string | number
---@param firstItem string
---@param firstItemCount number
---@param testItem string
---@param testItemCount number
function Inventory.CanSwapItem(inv, firstItem, firstItemCount, testItem, testItemCount)
	inv = Inventory(inv)
	local firstItemData = Inventory.GetItem(inv, firstItem)
	local testItemData = Inventory.GetItem(inv, testItem)
	if firstItemData.count >= firstItemCount then
		local weightWithoutFirst = inv.weight - (firstItemData.weight * firstItemCount)
		local weightWithTest = weightWithoutFirst + (testItemData.weight * testItemCount)
		return weightWithTest <= inv.maxWeight
	end
end
exports('CanSwapItem', Inventory.CanSwapItem)

RegisterServerEvent('ox_inventory:removeItem', function(name, count, metadata, slot, used)
	local inv = Inventory(source)

	if used then
		slot = inv.items[inv.usingItem]
		Inventory.RemoveItem(source, slot.name, count, slot.metadata, slot.slot)
		local item = Items(slot.name)

		if item?.cb then
			item.cb('usedItem', item, inv, slot.slot)
		end
	else
		Inventory.RemoveItem(source, name, count, metadata, slot)
	end

	inv.usingItem = nil
end)

Inventory.Drops = {}

local function generateDropId()
	local drop
	repeat
		drop = math.random(100000, 999999)
		Wait(0)
	until not Inventories[drop]
	return drop
end

local function CustomDrop(prefix, items, coords, slots, maxWeight, instance)
	local drop = generateDropId()
	local inventory = Inventory.Create(drop, prefix..' '..drop, 'drop', slots or shared.playerslots, 0, maxWeight or shared.playerweight, false)
	local items, weight = generateItems(inventory, 'drop', items)

	inventory.items = items
	inventory.weight = weight
	inventory.coords = coords
	Inventory.Drops[drop] = {coords = inventory.coords, instance = instance}
	TriggerClientEvent('ox_inventory:createDrop', -1, drop, Inventory.Drops[drop], inventory.open and source)
end
AddEventHandler('ox_inventory:customDrop', CustomDrop)
exports('CustomDrop', CustomDrop)

local Log = server.logs

local function dropItem(source, data)
	local playerInventory = Inventory(source)
	local fromData = playerInventory.items[data.fromSlot]

	if not fromData then return end
	if data.count > fromData.count then data.count = fromData.count end

	local toData = table.clone(fromData)
	toData.slot = data.toSlot
	toData.count = data.count
	fromData.count -= data.count
	fromData.weight = Inventory.SlotWeight(Items(fromData.name), fromData)
	toData.weight = Inventory.SlotWeight(Items(toData.name), toData)

	if fromData.count < 1 then fromData = nil end

	playerInventory.weight -= toData.weight
	local slot = data.fromSlot
	local items = { [slot] = fromData or false }
	playerInventory.items[slot] = fromData

	if slot == playerInventory.weapon then
		playerInventory.weapon = nil
	end

	local dropId = generateDropId()
	local inventory = Inventory.Create(dropId, 'Drop '..dropId, 'drop', shared.playerslots, toData.weight, shared.playerweight, false, {[data.toSlot] = toData})
	local coords = GetEntityCoords(GetPlayerPed(source))
	inventory.coords = vec3(coords.x, coords.y, coords.z-0.2)
	Inventory.Drops[dropId] = {coords = inventory.coords, instance = data.instance}

	TriggerClientEvent('ox_inventory:createDrop', -1, dropId, Inventory.Drops[dropId], playerInventory.open and source, slot)

	Log(('%sx %s transferred from %s to %s'):format(data.count, toData.name, playerInventory.label, dropId),
		playerInventory.owner,
		'swapSlots', playerInventory.owner, dropId
	)

	if shared.framework == 'esx' then Inventory.SyncInventory(playerInventory) end

	return true, { weight = playerInventory.weight, items = items }
end

lib.callback.register('ox_inventory:swapItems', function(source, data)
	-- TODO: requires re-re-re-refactor and helper functions to reduce repetition
	if data.count > 0 and data.toType ~= 'shop' then
		if data.toType == 'newdrop' then
			return dropItem(source, data)
		else
			local playerInventory = Inventory(source)
			local toInventory = (data.toType == 'player' and playerInventory) or Inventory(playerInventory.open)
			local fromInventory = (data.fromType == 'player' and playerInventory) or Inventory(playerInventory.open)

			if not fromInventory then
				Wait(0)
				fromInventory = (data.fromType == 'player' and playerInventory) or Inventory(playerInventory.open)

				if not fromInventory then
					return shared.warning('Unknown error occured during swapItems\n', json.encode(data, {indent = true}))
				end
			end

			local sameInventory = fromInventory.id == toInventory.id
			local toData = toInventory.items[data.toSlot]

			if not sameInventory and (fromInventory.type == 'policeevidence' or (toInventory.type == 'policeevidence' and toData)) then
				local group, rank = server.hasGroup(playerInventory, shared.police)

				if not group or server.evidencegrade > rank then
					return TriggerClientEvent('ox_lib:notify', source, { type = 'error', description = shared.locale('evidence_cannot_take') })
				end
			end

			if toInventory and fromInventory and (fromInventory.id ~= toInventory.id or data.fromSlot ~= data.toSlot) then
				local fromData = fromInventory.items[data.fromSlot]

				if fromData and (not fromData.metadata.container or fromData.metadata.container and toInventory.type ~= 'container') then
					if data.count > fromData.count then data.count = fromData.count end

					local container = (not sameInventory and playerInventory.containerSlot) and (fromInventory.type == 'container' and fromInventory or toInventory)
					local containerItem = container and playerInventory.items[playerInventory.containerSlot]

					if toData and ((toData.name ~= fromData.name) or not toData.stack or (not table.matches(toData.metadata, fromData.metadata))) then
						-- Swap items
						local toWeight = not sameInventory and (toInventory.weight - toData.weight + fromData.weight)
						local fromWeight = not sameInventory and (fromInventory.weight + toData.weight - fromData.weight)

						if not sameInventory then
							if fromInventory.type == 'container' or (toWeight <= toInventory.maxWeight and fromWeight <= fromInventory.maxWeight) then
								fromInventory.weight = fromWeight
								toInventory.weight = toWeight

								if container then
									local toContainer = toInventory.type == 'container'
									local whitelist = Items.containers[containerItem.name]?.whitelist
									local blacklist = Items.containers[containerItem.name]?.blacklist
									local checkItem = toContainer and fromData.name or toData.name

									if (whitelist and not whitelist[checkItem]) or (blacklist and blacklist[checkItem]) then
										return
									end

									Inventory.ContainerWeight(containerItem, toContainer and toWeight or fromWeight, playerInventory)
								end

								toData, fromData = Inventory.SwapSlots(fromInventory, toInventory, data.fromSlot, data.toSlot)

								Log(('%sx %s transferred from %s to %s for %sx %s'):format(fromData.count, fromData.name, fromInventory.owner and fromInventory.label or fromInventory.id, toInventory.owner and toInventory.label or toInventory.id, toData.count, toData.name),
									playerInventory.owner,
									'swapSlots', fromInventory.owner or fromInventory.id, toInventory.owner or toInventory.id
								)

							else return end
						else toData, fromData = Inventory.SwapSlots(fromInventory, toInventory, data.fromSlot, data.toSlot) end

					elseif toData and toData.name == fromData.name and table.matches(toData.metadata, fromData.metadata) then
						-- Stack items
						toData.count += data.count
						fromData.count -= data.count
						local toSlotWeight = Inventory.SlotWeight(Items(toData.name), toData)
						local totalWeight = toInventory.weight - toData.weight + toSlotWeight

						if fromInventory.type == 'container' or sameInventory or totalWeight <= toInventory.maxWeight then
							local fromSlotWeight = Inventory.SlotWeight(Items(fromData.name), fromData)
							toData.weight = toSlotWeight
							if not sameInventory then
								fromInventory.weight = fromInventory.weight - fromData.weight + fromSlotWeight
								toInventory.weight = totalWeight

								if container then
									Inventory.ContainerWeight(containerItem, toInventory.type == 'container' and toInventory.weight or fromInventory.weight, playerInventory)
								end

								Log(('%sx %s transferred from %s to %s'):format(data.count, fromData.name, fromInventory.owner and fromInventory.label or fromInventory.id, toInventory.owner and toInventory.label or toInventory.id),
									playerInventory.owner,
									'swapSlots', fromInventory.owner or fromInventory.id, toInventory.owner or toInventory.id
								)

							end
							fromData.weight = fromSlotWeight
						else
							toData.count -= data.count
							fromData.count += data.count
							return
						end
					elseif data.count <= fromData.count then
						-- Move item to an empty slot
						toData = table.clone(fromData)
						toData.count = data.count
						toData.slot = data.toSlot
						toData.weight = Inventory.SlotWeight(Items(toData.name), toData)

						if fromInventory.type == 'container' or sameInventory or (toInventory.weight + toData.weight <= toInventory.maxWeight) then
							if not sameInventory then
								local toContainer = toInventory.type == 'container'
								if container then
									if toContainer and containerItem then
										local whitelist = Items.containers[containerItem.name]?.whitelist
										local blacklist = Items.containers[containerItem.name]?.blacklist

										if (whitelist and not whitelist[fromData.name]) or (blacklist and blacklist[fromData.name]) then
											return
										end
									end
								end

								fromInventory.weight -= toData.weight
								toInventory.weight += toData.weight

								if container then
									Inventory.ContainerWeight(containerItem, toContainer and toInventory.weight or fromInventory.weight, playerInventory)
								end

								Log(('%sx %s transferred from %s to %s'):format(data.count, fromData.name, fromInventory.owner and fromInventory.label or fromInventory.id, toInventory.owner and toInventory.label or toInventory.id),
									playerInventory.owner,
									'swapSlots', fromInventory.owner or fromInventory.id, toInventory.owner or toInventory.id
								)

							end

							fromData.count -= data.count
							fromData.weight = Inventory.SlotWeight(Items(fromData.name), fromData)

							if fromData.count > 0 then
								toData.metadata = table.clone(toData.metadata)
							end

						else return end
					end

					if fromData.count < 1 then fromData = nil end

					local items = {}

					if fromInventory.type == 'player' then
						items[data.fromSlot] = fromData or false
						if toInventory.type == 'container' then
							items[playerInventory.containerSlot] = containerItem
						end
					end

					if toInventory.type == 'player' then
						items[data.toSlot] = toData or false
						if fromInventory.type == 'container' then
							items[playerInventory.containerSlot] = containerItem
						end
					end

					fromInventory.items[data.fromSlot] = fromData
					toInventory.items[data.toSlot] = toData

					if fromInventory.changed ~= nil then fromInventory.changed = true end
					if toInventory.changed ~= nil then toInventory.changed = true end

					if sameInventory and fromInventory.type == 'otherplayer' then
						TriggerClientEvent('ox_inventory:updateSlots', fromInventory.id,{
							{
								item = fromInventory.items[data.toSlot] or {slot=data.toSlot},
								inventory = fromInventory.type
							},
							{
								item = fromInventory.items[data.fromSlot] or {slot=data.fromSlot},
								inventory = fromInventory.type
							}
						}, { left = fromInventory.weight })

					elseif toInventory.type == 'otherplayer' then
						TriggerClientEvent('ox_inventory:updateSlots', toInventory.id,{
							{
								item = toInventory.items[data.toSlot] or {slot=data.toSlot},
								inventory = toInventory.type
							}
						}, { left = toInventory.weight })

					elseif fromInventory.type == 'otherplayer' then
						TriggerClientEvent('ox_inventory:updateSlots', fromInventory.id,{
							{
								item = fromInventory.items[data.fromSlot] or {slot=data.fromSlot},
								inventory = fromInventory.type
							}
						}, { left = fromInventory.weight })
					end

					local resp

					if next(items) then
						resp = { weight = playerInventory.weight, items = items }

						if shared.framework == 'esx' then
							if fromInventory.player then
								Inventory.SyncInventory(fromInventory)
							end

							if toInventory.player and not sameInventory then
								Inventory.SyncInventory(toInventory)
							end
						end
					end

					local weaponSlot

					if toInventory.weapon == data.toSlot then
						if not sameInventory then
							toInventory.weapon = nil
							TriggerClientEvent('ox_inventory:disarm', toInventory.id)
						else
							weaponSlot = data.fromSlot
							toInventory.weapon = weaponSlot
						end
					end

					if fromInventory.weapon == data.fromSlot then
						if not sameInventory then
							fromInventory.weapon = nil
							TriggerClientEvent('ox_inventory:disarm', fromInventory.id)
						elseif not weaponSlot then
							weaponSlot = data.toSlot
							fromInventory.weapon = weaponSlot
						end
					end

					return container and containerItem.weight or true, resp, weaponSlot
				end
			end
		end
	end
end)

function Inventory.Confiscate(source)
	local inv = Inventories[source]
	if inv?.player then
		db.saveStash(inv.owner, inv.owner, json.encode(minimal(inv)))
		table.wipe(inv.items)
		inv.weight = 0
		TriggerClientEvent('ox_inventory:inventoryConfiscated', inv.id)
		if shared.framework == 'esx' then Inventory.SyncInventory(inv) end
	end
end
exports('ConfiscateInventory', Inventory.Confiscate)

function Inventory.Return(source)
	local inv = Inventories[source]
	if inv?.player then
		MySQL.scalar('SELECT data FROM ox_inventory WHERE name = ?', { inv.owner }, function(data)
			if data then
				MySQL.query('DELETE FROM ox_inventory WHERE name = ?', { inv.owner })
				data = json.decode(data)
				local inventory, totalWeight = {}, 0

				if data and next(data) then
					for i = 1, #data do
						local i = data[i]
						if type(i) == 'number' then break end
						local item = Items(i.name)
						if item then
							local weight = Inventory.SlotWeight(item, i)
							totalWeight = totalWeight + weight
							inventory[i.slot] = {name = i.name, label = item.label, weight = weight, slot = i.slot, count = i.count, description = item.description, metadata = i.metadata, stack = item.stack, close = item.close}
						end
					end
				end

				inv.weight = totalWeight
				inv.items = inventory

				if shared.framework == 'esx' then Inventory.SyncInventory(inv) end
				TriggerClientEvent('ox_inventory:inventoryReturned', source, {inventory, totalWeight})
			end
		end)
	end
end
exports('ReturnInventory', Inventory.Return)

---@param inv string | number
---@param keep nil
--- todo: support the keep argument, allowing users to define a list of item "types" to keep
--- i.e. {'money', 'weapons'} would keep money and weapons, but remove ammo, attachments, and other items
function Inventory.Clear(inv, keep)
	inv = Inventory(inv)
	if inv then
		if not keep then
			table.wipe(inv.items)
			inv.weight = 0
			if inv.player then
				TriggerClientEvent('ox_inventory:inventoryConfiscated', inv.id)
				if shared.framework == 'esx' then Inventory.SyncInventory(inv) end
				inv.weapon = nil
			end
		end
	end
end
exports('ClearInventory', Inventory.Clear)

local function playerDropped(source)
	local inv = Inventory(source)
	if inv then
		local openInventory = inv.open and Inventories[inv.open]
		if openInventory then
			openInventory.open = false
		end
		Inventories[source] = nil
	end
end

if shared.framework == 'ox' then
	AddEventHandler('ox:playerLogout', playerDropped)

	AddEventHandler('ox:setGroup', function(source, name, grade)
		local inventory = Inventories[source]
		if inventory then
			inventory.player.groups[name] = grade
		end
	end)
elseif shared.framework == 'esx' then
	AddEventHandler('esx:playerDropped', playerDropped)

	AddEventHandler('esx:setJob', function(source, job)
		local inventory = Inventories[source]
		if inventory then
			inventory.player.groups[job.name] = job.grade
		end
	end)
else
	AddEventHandler('playerDropped', function()
		playerDropped(source)
	end)
end

local function prepareSave(inv)
	inv.changed = false

	if inv.type == 'trunk' then
		return 1, { json.encode(minimal(inv)), inv.dbId }
	elseif inv.type == 'glovebox' then
		return 2, { json.encode(minimal(inv)), inv.dbId }
	else
		return 3, { inv.owner or '', inv.dbId, json.encode(minimal(inv)) }
	end
end

SetInterval(function()
	local time = os.time()
	local parameters = { {}, {}, {} }
	local size = { 0, 0, 0 }

	for _, inv in pairs(Inventories) do
		if not inv.player and not inv.open then
			if not inv.datastore and inv.changed then
				local i, data = prepareSave(inv)
				size[i] += 1
				parameters[i][size[i]] = data
			end

			if (inv.datastore or inv.owner) and time - inv.time >= 3000 then
				Inventory.Remove(inv.id, inv.type)
			end
		end
	end

	db.saveInventories(parameters[1], parameters[2], parameters[3])
end, 600000)

local function saveInventories(lock)
	local parameters = { {}, {}, {} }
	local size = { 0, 0, 0 }
	Inventory.Lock = lock or nil

	TriggerClientEvent('ox_inventory:closeInventory', -1, true)

	for _, inv in pairs(Inventories) do
		if not inv.player and not inv.datastore and inv.changed then
			local i, data = prepareSave(inv)
			size[i] += 1
			parameters[i][size[i]] = data
		end
	end

	db.saveInventories(parameters[1], parameters[2], parameters[3])
end

AddEventHandler('playerDropped', function()
	if GetNumPlayerIndices() == 0 then
		saveInventories()
	end
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if eventData.secondsRemaining == 60 then
		SetTimeout(50000, function()
			saveInventories(true)
		end)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == shared.resource then
		saveInventories(true)
	end
end)

RegisterServerEvent('ox_inventory:closeInventory', function()
	local inventory = Inventories[source]
	if inventory?.open then
		if type(inventory.open) ~= 'boolean' then
			local secondary = Inventories[inventory.open]
			if secondary then
				secondary:set('open', false)
			end
		end
		inventory:set('open', false)
		inventory.containerSlot = nil
	end
end)

RegisterServerEvent('ox_inventory:giveItem', function(slot, target, count)
	local fromInventory = Inventories[source]
	local toInventory = Inventories[target]
	if count <= 0 then count = 1 end
	if toInventory.type == 'player' then
		local data = fromInventory.items[slot]
		local item = Items(data.name)
		if not toInventory.open and Inventory.CanCarryItem(toInventory, item, count, data.metadata) then
			if data and data.count >= count then
				Inventory.RemoveItem(fromInventory, item, count, data.metadata, slot)
				Inventory.AddItem(toInventory, item, count, data.metadata)

				Log(('%s gave %sx %s to %s'):format(fromInventory.label, count, data.name, toInventory.label),
					fromInventory.owner,
					'giveItem', toInventory.owner
				)

			end
		else
			TriggerClientEvent('ox_lib:notify', source, { type = 'error', description = shared.locale('cannot_give', count, data.label) })
		end
	end
end)

RegisterServerEvent('ox_inventory:updateWeapon', function(action, value, slot)
	local inventory = Inventories[source]

	if not inventory then return end

	if not action then
		inventory.weapon = nil
		return
	end

	local syncInventory = false
	local type = type(value)

	if type == 'table' and action == 'component' then
		local item = inventory.items[value.slot]
		if item then
			if item.metadata.components then
				for k, v in pairs(item.metadata.components) do
					if v == value.component then
						table.remove(item.metadata.components, k)
						Inventory.AddItem(inventory, value.component, 1)
						return TriggerClientEvent('ox_inventory:updateSlots', source, {{item = item}}, {left=inventory.weight})
					end
				end
			end
		end
	else
		if not slot then slot = inventory.weapon end
		local weapon = inventory.items[slot]

		if weapon and weapon.metadata then
			local item = Items(weapon.name)

			if not item.weapon then
				inventory.weapon = nil
				return
			end

			if action == 'load' and weapon.metadata.durability > 0 then
				local ammo = Items(weapon.name).ammoname
				local diff = value - weapon.metadata.ammo
				Inventory.RemoveItem(inventory, ammo, diff)
				weapon.metadata.ammo = value
				weapon.weight = Inventory.SlotWeight(item, weapon)
				syncInventory = true
			elseif action == 'throw' then
				Inventory.RemoveItem(inventory, weapon.name, 1, weapon.metadata, weapon.slot)
			elseif action == 'component' then
				if type == 'number' then
					Inventory.AddItem(inventory, weapon.metadata.components[value], 1)
					table.remove(weapon.metadata.components, value)
					weapon.weight = Inventory.SlotWeight(item, weapon)
				elseif type == 'string' then
					local component = inventory.items[tonumber(value)]
					Inventory.RemoveItem(inventory, component.name, 1)
					table.insert(weapon.metadata.components, component.name)
					weapon.weight = Inventory.SlotWeight(item, weapon)
				end
				syncInventory = true
			elseif action == 'ammo' then
				if weapon.hash == `WEAPON_FIREEXTINGUISHER` or weapon.hash == `WEAPON_PETROLCAN` then
					weapon.metadata.durability = math.floor(value)
					weapon.metadata.ammo = weapon.metadata.durability
				elseif value < weapon.metadata.ammo then
					local durability = Items(weapon.name).durability * math.abs((weapon.metadata.ammo or 0.1) - value)
					weapon.metadata.ammo = value
					weapon.metadata.durability = weapon.metadata.durability - durability
					weapon.weight = Inventory.SlotWeight(item, weapon)
				end
				syncInventory = true
			elseif action == 'melee' and value > 0 then
				weapon.metadata.durability = weapon.metadata.durability - ((Items(weapon.name).durability or 1) * value)
				syncInventory = true
			end

			if shared.framework == 'esx' and syncInventory then
				Inventory.SyncInventory(inventory)
			end

			if action ~= 'throw' then TriggerClientEvent('ox_inventory:updateSlots', source, {{item = weapon}}, {left=inventory.weight}) end

			if weapon.metadata.durability and weapon.metadata.durability < 1 and action ~= 'load' and action ~= 'component' then
				TriggerClientEvent('ox_inventory:disarm', source)
			end
		end
	end
end)

lib.addCommand('group.admin', {'additem', 'giveitem'}, function(source, args)
	args.item = Items(args.item)
	if args.item and args.count > 0 then
		local metadata = args.metatype and { type = tonumber(args.metatype) or args.metatype }
		Inventory.AddItem(args.target, args.item.name, args.count, metadata)

		local inventory = Inventories[args.target]
		source = Inventories[source] or {label = 'console', owner = 'console'}

		Log(('%s gave %sx %s to %s'):format(source.label, args.count, args.item.name, inventory.label),
			source.owner,
			'admin', inventory.owner
		)

	end
end, {'target:number', 'item:string', 'count:number', 'metatype'})

lib.addCommand('group.admin', 'removeitem', function(source, args)
	args.item = Items(args.item)
	if args.item and args.count > 0 then
		local metadata = args.metatype and { type = tonumber(args.metatype) or args.metatype }
		Inventory.RemoveItem(args.target, args.item.name, args.count, metadata)

		local inventory = Inventories[args.target]
		source = Inventories[source] or {label = 'console', owner = 'console'}

		Log(('%s took %sx %s from %s'):format(source.label, args.count, args.item.name, inventory.label),
			source.owner,
			'admin', inventory.owner
		)

	end
end, {'target:number', 'item:string', 'count:number', 'metatype'})

lib.addCommand('group.admin', 'setitem', function(source, args)
	args.item = Items(args.item)
	if args.item and args.count >= 0 then
		Inventory.SetItem(args.target, args.item.name, args.count, args.metaType)
		local inventory = Inventories[args.target]
		source = Inventories[source] or {label = 'console', owner = 'console'}

		Log(('%s set %s\' %s count to %sx'):format(source.label, inventory.label, args.item.name, args.count),
			source.owner,
			'admin', inventory.owner
		)

	end
end, {'target:number', 'item:string', 'count:number', 'metatype:?string'})

lib.addCommand(false, 'clearevidence', function(source, args)
	local inventory = Inventories[source]
	local hasPermission = false

	if shared.framework == 'esx' then
		-- todo: make it work
	else
		local group, rank = server.hasGroup(inventory, shared.police)
		if group and rank == GlobalState.groups[group] then hasPermission = true end
	end

	if hasPermission then
		MySQL.query('DELETE FROM ox_inventory WHERE name = ?', {('evidence-%s'):format(args.evidence)})
	end
end, {'evidence:number'})

lib.addCommand('group.admin', 'takeinv', function(source, args)
	Inventory.Confiscate(args.target)
end, {'target:number'})

lib.addCommand('group.admin', 'returninv', function(source, args)
	Inventory.Return(args.target)
end, {'target:number'})

lib.addCommand('group.admin', 'clearinv', function(source, args)
	Inventory.Clear(args.target)
end, {'target:number'})

lib.addCommand('group.admin', 'saveinv', function(source, args)
	saveInventories(args[1] == 1 or args[1] == 'true')
end)

lib.addCommand('group.admin', 'viewinv', function(source, args)
	local inventory = Inventories[args.target] or Inventories[tonumber(args.target)]
	TriggerClientEvent('ox_inventory:viewInventory', source, inventory)
end, {'target'})

Inventory.accounts = server.accounts

TriggerEvent('ox_inventory:loadInventory', Inventory)

--- Takes traditional item data and updates it to support ox_inventory, i.e.\
--- ```
--- Old: [{"cola":1, "bread":3}]
--- New: [{"slot":1,"name":"cola","count":1}, {"slot":2,"name":"bread","count":3}]
---```
local function ConvertItems(playerId, items)
	if type(items) == 'table' then
		local returnData, totalWeight = table.create(#items, 0), 0
		local slot = 0

		for name, count in pairs(items) do
			local item = Items(name)
			local metadata = Items.Metadata(playerId, item, false, count)
			local weight = Inventory.SlotWeight(item, {count=count, metadata=metadata})
			totalWeight = totalWeight + weight
			slot += 1
			returnData[slot] = {name = item.name, label = item.label, weight = weight, slot = slot, count = count, description = item.description, metadata = metadata, stack = item.stack, close = item.close}
		end

		return returnData, totalWeight
	end
end
exports('ConvertItems', ConvertItems)

Inventory.CustomStash = table.create(0, 0)
---@param name string stash identifier when loading from the database
---@param label string display name when inventory is open
---@param slots number
---@param maxWeight number
---@param owner string|boolean|nil
---@param groups table
--- For simple integration with other resources that want to create valid stashes.
--- This needs to be triggered before a player can open a stash.
--- ```
--- Owner sets the stash permissions.
--- string: can only access the stash linked to the owner (usually player identifier)
--- true: each player has a unique stash, but can request other player's stashes
--- nil: always shared
---
--- groups: { ['police'] = 0 }
--- ```
local function RegisterStash(name, label, slots, maxWeight, owner, groups, coords)
	if type(name) ~= 'string' then
		error(('received %s for stash name (expected string)'):format(type(name)))
	end

	if not slots then
		error(('received %s for stash slots (expected number)'):format(slots))
	end

	if not maxWeight then
		error(('received %s for stash maxWeight (expected number)'):format(maxWeight))
	end

	if coords then
		local typeof = type(coords)
		if typeof ~= 'vector3' then
			if typeof == 'table' then
				coords = vec3(coords.x or coords[1], coords.y or coords[2], coords.z or coords[3])
			else
				error(('received %s for stash coords (expected vector3)'):format(typeof))
			end
		end
	end

	if Inventory.CustomStash[name] then
		print(('overwriting stash %s with new settings'):format(name))
	end

	Inventory.CustomStash[name] = {
		name = name,
		label = label,
		owner = owner,
		slots = slots,
		weight = maxWeight,
		groups = groups,
		coords = coords
	}
end
exports('RegisterStash', RegisterStash)

server.inventory = Inventory
