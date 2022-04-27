if not lib then return end

local Inventar = {}
local Inventories = {}
local Stashes = data 'stashes'

local function OtevritSkrys(data, player)
	local stash = Stashes[data.id] or Inventar.CustomStash[data.id]

	if stash then
		if stash.jobs then stash.groups = stash.jobs end
		if player and stash.groups and not server.maSkupinu(player, stash.groups) then return end

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
			inventory = Inventar.Vytvorit(stash.name, stash.label or stash.name, 'stash', stash.slots, 0, stash.weight, owner, false, stash.groups)
		end

		return inventory
	else return false end
end

setmetatable(Inventar, {
	__call = function(self, inv, player)
		if not inv then
			return self
		elseif type(inv) == 'table' then
			if inv.items then return inv end
			return OtevritSkrys(inv, player)
		elseif not Inventories[inv] then
			return OtevritSkrys({ id = inv }, player)
		end

		return Inventories[inv]
	end
})

exports('Inventory', function(id, owner)
	if not id then return Inventar end
	local type = type(id)

	if type == 'table' or type == 'number' then
		return Inventar(id)
	else
		return Inventar({ id = id, owner = owner })
	end
end)

---@param inv string | number
---@param k string
---@param v any
function Inventar.Nastavit(inv, k, v)
	inv = Inventar(inv)
	if inv then
		if type(v) == 'number' then math.floor(v + 0.5) end

		if k == 'open' and v == false then
			if inv.type ~= 'player' then
				if inv.type == 'otherplayer' then
					inv.type = 'player'
				elseif inv.type == 'drop' and not next(inv.items) then
					return Inventar.Remove(inv.id, inv.type)
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
function Inventar.Ziskat(inv, key)
	inv = Inventar(inv)
	if inv then
		return inv[key]
	end
end

---@param inv string | number
---@return table items table containing minimalne inventory data
local function minimalne(inv)
	inv = Inventar(inv)
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
function Inventar.SynchronizovatInventar(inv)
	local money = table.clone(server.accounts)

	for _, v in pairs(inv.items) do
		if money[v.name] then
			money[v.name] += v.count
		end
	end

	server.GetPlayerFromId(inv.id).syncInventar(inv.weight, inv.maxWeight, inv.items, money)
end

---@param inv string | number
---@param item table item data
---@param count number
---@param metadata any
---@param slot any
function Inventar.NastavitSlot(inv, item, count, metadata, slot)
	inv = Inventar(inv)
	local currentSlot = inv.items[slot]
	local newCount = currentSlot and currentSlot.count + count or count

	if currentSlot and newCount < 1 then
		count = currentSlot.count
		inv.items[slot] = nil
	else
		inv.items[slot] = {name = Polozka.name, label = Polozka.label, weight = Polozka.weight, slot = slot, count = newCount, description = Polozka.description, metadata = metadata, stack = Polozka.stack, close = Polozka.close}
		inv.items[slot].weight = Inventar.SlotVaha(item, inv.items[slot])
	end

	if not inv.player then
		inv.changed = true
	end
end

local Items
CreateThread(function() Items = server.items end)

---@param item table
---@param slot table
function Inventar.SlotVaha(item, slot)
	local weight = Polozka.weight * slot.count
	if not slot.metadata then slot.metadata = {} end

	if Polozka.ammoname and slot.metadata.ammo then
		weight += (Items(Polozka.ammoname).weight * slot.metadata.ammo)
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
function Inventar.VypocitatVahu(items)
	local weight = 0
	for _, v in pairs(items) do
		local item = Items(v.name)
		if item then
			weight = weight + Inventar.SlotVaha(item, v)
		end
	end
	return weight
end

---@param id string|number
---@param label string
---@param invType string
---@param slots number
---@param weight number
---@param maxWeight number
---@param owner string
---@param items? table
--- This should only be utilised internally!
--- To create a stash, please use `exports.ox_inventory:RegistrovatSkrys` instead.
function Inventar.Vytvorit(id, label, invType, slots, weight, maxWeight, owner, items, groups)
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
			set = Inventar.Nastavit,
			get = Inventar.Ziskat,
			minimalne = minimalne,
			time = os.time(),
			groups = groups,
		}

		if self.type == 'drop' then
			self.datastore = true
		else
			self.changed = false
			self.dbId = self.id

			if self.type ~= 'player' and self.owner and type(self.owner) ~= 'boolean' then
				self.id = ('%s:%s'):format(self.id, self.owner)
			end
		end

		if not self.items then
			self.items, self.weight, self.datastore = Inventar.Nacist(self.dbId, self.type, self.owner)
		elseif self.weight == 0 and next(self.items) then
			self.weight = Inventar.VypocitatVahu(self.items)
		end

		Inventories[self.id] = self
		return Inventories[self.id]
	end
end

---@param id string|number
---@param type string
function Inventar.Odstranit(id, type)
	if type == 'drop' then
		TriggerClientEvent('ox_inventory:removeDrop', -1, id)
		Inventar.Drops[id] = nil
	end
	Inventories[id] = nil
end

function Inventar.ZiskatPlateFromId(id)
	if shared.trimplate then
		return string.strtrim(id:sub(6))
	end

	return id:sub(6)
end

function Inventar.Save(inv)
	inv = Inventar(inv)
	local inventory = json.encode(minimalne(inv))

	if inv.type == 'player' then
		MySQL:ulozitHrace(inv.owner, inventory)
	else
		if inv.type == 'trunk' then
			MySQL:ulozitKufr(Inventar.ZiskatPlateFromId(inv.id), inventory)
		elseif inv.type == 'glovebox' then
			MySQL:ulozitKaslik(Inventar.ZiskatPlateFromId(inv.id), inventory)
		else
			MySQL:ulozitSkrys(inv.owner, inv.dbId, inventory)
		end
		inv.changed = false
	end
end

local function nahodnaPolozka(loot, items, size)
	local item = loot[math.random(1, size)]
	for i = 1, #items do
		if items[i][1] == item[1] then
			return nahodnaPolozka(loot, items, size)
		end
	end
	return item
end

local function nahodnaKorist(loot)
	local items = {}
	local size = #loot
	for i = 1, math.random(0, 3) do
		if i > size then return items end
		local item = nahodnaPolozka(loot, items, size)
		if math.random(1, 100) <= (item[4] or 80) then
			local count = math.random(item[2], item[3])
			if count > 0 then
				items[#items+1] = {item[1], count}
			end
		end
	end
	return items
end

---@param inv string | number
---@param invType string
---@param items? table
---@return table returnData, number totalWeight, boolean true
local function generovatPolozky(inv, invType, items)
	if items == nil then
		if invType == 'dumpster' then
			items = nahodnaKorist(server.dumpsterloot)
		elseif invType == 'vehicle' then
			items = nahodnaKorist(server.vehicleloot)
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
			local weight = Inventar.SlotVaha(item, {count=count, metadata=metadata})
			totalWeight = totalWeight + weight
			returnData[i] = {name = Polozka.name, label = Polozka.label, weight = weight, slot = i, count = count, description = Polozka.description, metadata = metadata, stack = Polozka.stack, close = Polozka.close}
		end
	end

	return returnData, totalWeight, true
end

---@param id string|number
---@param invType string
---@param owner string
function Inventar.Nacist(id, invType, owner)
	local datastore, result

	if id and invType then
		if invType == 'dumpster' then
			if server.nahodnaKorist then
				return generovatPolozky(id, invType)
			else
				datastore = true
			end
		elseif invType == 'trunk' or invType == 'glovebox' then
			result = invType == 'trunk' and MySQL:nacistKufr( Inventar.ZiskatPlateFromId(id) ) or MySQL:nacistKaslik( Inventar.ZiskatPlateFromId(id) )

			if not result then
				if server.nahodnaKorist then
					return generovatPolozky(id, 'vehicle')
				else
					datastore = true
				end
			else result = result[invType] end
		else
			result = MySQL:nacistSkrys(owner or '', id)
		end
	end

	local returnData, weight = {}, 0

	if result then
		result = json.decode(result)
		for _, v in pairs(result) do
			local item = Items(v.name)
			if item then
				if v.metadata then
					v.metadata = Items.CheckMetadata(v.metadata, item, v.name)
				end

				local slotWeight = Inventar.SlotVaha(item, v)
				weight += slotWeight
				returnData[v.slot] = {name = Polozka.name, label = Polozka.label, weight = slotWeight, slot = v.slot, count = v.count, description = Polozka.description, metadata = v.metadata or {}, stack = Polozka.stack, close = Polozka.close}
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
function Inventar.ZiskatPolozku(inv, item, metadata, returnsCount)
	if type(item) ~= 'table' then item = Items(item) end

	if item then item = returnsCount and item or table.clone(item)
		inv = Inventar(inv)
		local count = 0

		if inv then
			metadata = not metadata and false or type(metadata) == 'string' and {type=metadata} or metadata
			for _, v in pairs(inv.items) do
				if v and v.name == Polozka.name and (not metadata or table.contains(v.metadata, metadata)) then
					count += v.count
				end
			end
		end

		if returnsCount then return count else
			Polozka.count = count
			return item
		end
	end
end
exports('ZiskatPolozku', Inventar.ZiskatPolozku)

---@param fromInventory any
---@param toInventory any
---@param slot1 number
---@param slot2 number
function Inventar.VymenteSloty(fromInventory, toInventory, slot1, slot2)
	local fromSlot = fromInventar.items[slot1] and table.clone(fromInventar.items[slot1]) or nil
	local toSlot = toInventar.items[slot2] and table.clone(toInventar.items[slot2]) or nil
	if fromSlot then fromSlot.slot = slot2 end
	if toSlot then toSlot.slot = slot1 end
	fromInventar.items[slot1], toInventar.items[slot2] = toSlot, fromSlot
	return fromSlot, toSlot
end
exports('SwapSlots', Inventar.VymenteSloty)

function Inventar.HmotnostNadoby(container, metaWeight, playerInventory)
	playerInventar.weight -= container.weight
	container.weight = Items(container.name).weight
	container.weight += metaWeight
	container.metadata.weight = metaWeight
	playerInventar.weight += container.weight
end

---@param inv string | number
---@param item table | string
---@param count number
---@param metadata? table
function Inventar.NastavitPolozka(inv, item, count, metadata)
	if type(item) ~= 'table' then item = Items(item) end
	if item and count >= 0 then
		inv = Inventar(inv)
		if inv then
			local itemCount = Inventar.ZiskatPolozku(inv, Polozka.name, metadata, true)
			if count > itemCount then
				count -= itemCount
				Inventar.PridatPolozku(inv, Polozka.name, count, metadata)
			elseif count <= itemCount then
				itemCount -= count
				Inventar.OstranitPolozku(inv, Polozka.name, itemCount, metadata)
			end
		end
	end
end

---@param inv string | number
---@return table item
function Inventar.ZiskatAktualniZbran(inv)
	inv = Inventar(inv)

	if inv?.player then
		local weapon = inv.items[inv.weapon]

		if weapon and Items(weapon.name).weapon then
			return weapon
		end

		inv.weapon = nil
	end
end
exports('GetCurrentWeapon', Inventar.ZiskatAktualniZbran)

---@param inv string | number
---@param slot number
---@return table item
function Inventar.ZiskatSlot(inv, slot)
	inv = Inventar(inv)

	if inv then
		return inv.items[slot]
	end
end
exports('GetSlot', Inventar.ZiskatSlot)

---@param inv string | number
---@param slot number
---@return table item
function Inventar.NastavitTrvanlivost(inv, slot, durability)
	inv = Inventar(inv)

	if inv then
		slot = inv.items[slot]

		if slot then
			slot.metadata.durability = durability

			if inv.type == 'player' then
				if shared.framework == 'esx' then Inventar.SynchronizovatInventar(inv) end
				TriggerClientEvent('ox_inventory:aktualizovatSloty', inv.id, {{item = slot, inventory = inv.type}}, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight})
			end
		end
	end
end
exports('SetDurability', Inventar.NastavitTrvanlivost)

---@param inv string | number
---@param slot number
---@param metadata table
function Inventar.NastavitMetadata(inv, slot, metadata)
	inv = Inventar(inv)
	slot = type(slot) == 'number' and (inv and inv.items[slot])
	if inv and slot then
		if inv then
			slot.metadata = type(metadata) == 'table' and metadata or {type = metadata}

			if metadata.weight then
				inv.weight -= slot.weight
				slot.weight = Inventar.SlotVaha(Items(slot.name), slot)
				inv.weight += slot.weight
			end

			if inv.type == 'player' then
				if shared.framework == 'esx' then Inventar.SynchronizovatInventar(inv) end
				TriggerClientEvent('ox_inventory:aktualizovatSloty', inv.id, {{item = slot, inventory = inv.type}}, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight})
			end
		end
	end
end
exports('SetMetadata', Inventar.NastavitMetadata)

---@param inv string | number
---@param item table | string
---@param count number
---@param metadata? table | string
---@param slot number
---@param cb function
-- todo: add parameter checks to remove need for nil args
-- todo: add callback with several reasons for failure
-- ```
-- exports.ox_inventory:AddPolozka(1, 'bread', 4, nil, nil, function(success, reason)
-- if not success then
-- 	if reason == 'overburdened' then
-- 		TriggerClientEvent('ox_lib:notify', source, { type = 'error', description= shared.locale('cannot_carry', count, data.label) })
-- 	end
-- end
-- ```
function Inventar.PridatPolozku(inv, item, count, metadata, slot, cb)
	if type(item) ~= 'table' then item = Items(item) end
	if type(inv) ~= 'table' then inv = Inventar(inv) end
	count = math.floor(count + 0.5)
	local success, resp

	if item then
		if inv then
			metadata, count = Items.Metadata(inv.id, item, metadata or {}, count)
			local existing = false

			if slot then
				local slotItem = inv.items[slot]
				if not slotItem or Polozka.stack and slotItem and slotPolozka.name == Polozka.name and table.matches(slotPolozka.metadata, metadata) then
					existing = nil
				end
			end

			if existing == false then
				local items, toSlot = inv.items, nil
				for i = 1, shared.playerslots do
					local slotItem = items[i]
					if Polozka.stack and slotItem ~= nil and slotPolozka.name == Polozka.name and table.matches(slotPolozka.metadata, metadata) then
						toSlot, existing = i, true break
					elseif not toSlot and slotItem == nil then
						toSlot = i
					end
				end
				slot = toSlot
			end

			if slot then
				Inventar.NastavitSlot(inv, item, count, metadata, slot)
				inv.weight = inv.weight + (Polozka.weight + (metadata?.weight or 0)) * count

				if cb then
					success = true
					resp = inv.items[slot]
				end

				if inv.type == 'player' then
					if shared.framework == 'esx' then Inventar.SynchronizovatInventar(inv) end
					TriggerClientEvent('ox_inventory:aktualizovatSloty', inv.id, {{item = inv.items[slot], inventory = inv.type}}, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight}, count, false)
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
exports('AddItem', Inventar.PridatPolozku)

---@param inv string | number
---@param search string|number slots|1, count|2
---@param items table | string
---@param metadata? table | string
function Inventar.Vyhledat(inv, search, items, metadata)
	if items then
		inv = Inventar(inv)
		if inv then
			inv = inv.items

			if search == 'slots' then search = 1 elseif search == 'count' then search = 2 end
			if type(items) == 'string' then items = {items} end
			if type(metadata) == 'string' then metadata = {type=metadata} end

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
exports('Search', Inventar.Vyhledat)

---@param inv string | number
---@param item table | string
---@param metadata? table
function Inventar.ZiskatSlotyPolozek(inv, item, metadata)
	inv = Inventar(inv)
	local totalCount, slots, emptySlots = 0, {}, inv.slots
	for k, v in pairs(inv.items) do
		emptySlots -= 1
		if v.name == Polozka.name then
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
exports('ZiskatPolozkuSlots', Inventar.ZiskatSlotyPolozek)

---@param inv string | number
---@param item table | string
---@param count number
---@param metadata? table | string
---@param slot number
function Inventar.OstranitPolozku(inv, item, count, metadata, slot)
	if type(item) ~= 'table' then item = Items(item) end
	count = math.floor(count + 0.5)
	if item and count > 0 then
		inv = Inventar(inv)

		if metadata ~= nil then
			metadata = type(metadata) == 'string' and {type=metadata} or metadata
		end

		local itemSlots, totalCount = Inventar.ZiskatSlotyPolozek(inv, item, metadata)
		if count > totalCount then count = totalCount end
		local removed, total, slots = 0, count, {}
		if slot and itemSlots[slot] then
			removed = count
			Inventar.NastavitSlot(inv, item, -count, metadata, slot)
			slots[#slots+1] = inv.items[slot] or slot
		elseif itemSlots and totalCount > 0 then
			for k, v in pairs(itemSlots) do
				if removed < total then
					if v == count then
						removed = total
						inv.items[k] = nil
						slots[#slots+1] = inv.items[k] or k
					elseif v > count then
						Inventar.NastavitSlot(inv, item, -count, metadata, k)
						slots[#slots+1] = inv.items[k] or k
						removed = total
						count = v - count
					else
						removed = removed + v
						count = count - v
						inv.items[k] = nil
						slots[#slots+1] = k
					end
				else break end
			end
		end

		inv.weight = inv.weight - (Polozka.weight + (metadata?.weight or 0)) * removed
		if removed > 0 and inv.type == 'player' then
			if shared.framework == 'esx' then Inventar.SynchronizovatInventar(inv) end
			local array = table.create(#slots, 0)

			for k, v in pairs(slots) do
				if type(v) == 'number' then
					array[k] = {item = {slot = v, label = metadata?.label or Polozka.label, name = metadata?.image or Polozka.name}, inventory = inv.type}
				else
					array[k] = {item = v, inventory = inv.type}
				end
			end

			TriggerClientEvent('ox_inventory:aktualizovatSloty', inv.id, array, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight}, removed, true)
		end
	end
end
exports('RemoveItem', Inventar.OstranitPolozku)

---@param inv string | number
---@param item table | string
---@param count number
---@param metadata? table | string
function Inventar.MuzeNestPolozku(inv, item, count, metadata)
	if type(item) ~= 'table' then item = Items(item) end
	if item then
		inv = Inventar(inv)
		local itemSlots, totalCount, emptySlots = Inventar.ZiskatSlotyPolozek(inv, item, metadata == nil and {} or type(metadata) == 'string' and {type=metadata} or metadata)

		if next(itemSlots) or emptySlots > 0 then
			if Polozka.weight == 0 then return true end
			if count == nil then count = 1 end
			local newWeight = inv.weight + (Polozka.weight * count)

			if newWeight > inv.maxWeight then
				TriggerClientEvent('ox_lib:notify', inv.id, { type = 'error', description = shared.locale('cannot_carry') })
				return false
			end

			return true
		end
	end
end
exports('MuzeNestPolozku', Inventar.MuzeNestPolozku)

---@param inv string | number
---@param item table | string
function Inventar.MuzeNestPocet(inv, item)
    if type(item) ~= 'table' then item = Items(item) end
    if item then
        inv = Inventar(inv)
            local availableWeight = inv.maxWeight - inv.weight
            local canHold = math.floor(availableWeight / Polozka.weight)
            return canHold
    end
end
exports('MuzeNestPocet', Inventar.MuzeNestPocet)

---@param inv string | number
---@param firstItem string
---@param firstItemCount number
---@param testItem string
---@param testItemCount number
function Inventar.MuzeProhoditPolozky(inv, firstItem, firstItemCount, testItem, testItemCount)
	inv = Inventar(inv)
	local firstItemData = Inventar.ZiskatPolozku(inv, firstItem)
	local testItemData = Inventar.ZiskatPolozku(inv, testItem)
	if firstItemData.count >= firstItemCount then
		local weightWithoutFirst = inv.weight - (firstItemData.weight * firstItemCount)
		local weightWithTest = weightWithoutFirst + (testItemData.weight * testItemCount)
		return weightWithTest <= inv.maxWeight
	end
end
exports('MuzeProhoditPolozky', Inventar.MuzeProhoditPolozky)

RegisterServerEvent('ox_inventory:odstranitPolozku', function(name, count, metadata, slot, used)
	local inv = Inventar(source)

	if used then
		slot = inv.items[inv.usingItem]
		Inventar.OstranitPolozku(source, slot.name, count, slot.metadata, slot.slot)
		local item = Items(slot.name)

		if item?.cb then
			Polozka.cb('usedItem', item, inv, slot.slot)
		end
	else
		Inventar.OstranitPolozku(source, name, count, metadata, slot)
	end

	inv.usingItem = nil
end)

Inventar.Drops = {}

local function generateDropId()
	local drop
	repeat
		drop = math.random(100000, 999999)
		Wait(0)
	until not Inventories[drop]
	return drop
end

local function VlastniPad(prefix, items, coords, slots, maxWeight, instance)
	local drop = generateDropId()
	local inventory = Inventar.Vytvorit(drop, prefix..' '..drop, 'drop', slots or shared.playerslots, 0, maxWeight or shared.playerweight, false)
	local items, weight = generovatPolozky(inventory, 'drop', items)
	
	Inventar.items = items
	Inventar.weight = weight
	Inventar.coords = coords
	Inventar.Drops[drop] = {coords = Inventar.coords, instance = instance}
	TriggerClientEvent('ox_inventory:vytvoritPad', -1, drop, Inventar.Drops[drop], Inventar.open and source)
end
AddEventHandler('ox_inventory:vlastniPad', VlastniPad)
exports('VlastniPad', VlastniPad)

local Log = server.logs

local function shoditPolozku(source, data)
	local playerInventory = Inventar(source)
	local fromData = playerInventar.items[data.fromSlot]

	if not fromData then return end
	if data.count > fromData.count then data.count = fromData.count end

	local toData = table.clone(fromData)
	toData.slot = data.toSlot
	toData.count = data.count
	fromData.count -= data.count
	fromData.weight = Inventar.SlotVaha(Items(fromData.name), fromData)
	toData.weight = Inventar.SlotVaha(Items(toData.name), toData)

	if fromData.count < 1 then fromData = nil end

	playerInventar.weight -= toData.weight
	local slot = data.fromSlot
	local items = { [slot] = fromData or false }
	playerInventar.items[slot] = fromData

	if slot == playerInventar.weapon then
		playerInventar.weapon = nil
	end

	local dropId = generateDropId()
	local inventory = Inventar.Vytvorit(dropId, 'Drop '..dropId, 'drop', shared.playerslots, toData.weight, shared.playerweight, false, {[data.toSlot] = toData})
	local coords = GetEntityCoords(GetPlayerPed(source))
	Inventar.coords = vec3(coords.x, coords.y, coords.z-0.2)
	Inventar.Drops[dropId] = {coords = Inventar.coords, instance = data.instance}

	TriggerClientEvent('ox_inventory:vytvoritPad', -1, dropId, Inventar.Drops[dropId], playerInventar.open and source, slot)

	Log(('%sx %s transferred from %s to %s'):format(data.count, toData.name, playerInventar.label, dropId),
		playerInventar.owner,
		'swapSlots', playerInventar.owner, dropId
	)

	if shared.framework == 'esx' then Inventar.SynchronizovatInventar(playerInventory) end

	return true, { weight = playerInventar.weight, items = items }
end

lib.callback.register('ox_inventory:swapItems', function(source, data)
	-- TODO: requires re-re-re-refactor and helper functions to reduce repetition
	if data.count > 0 and data.toType ~= 'shop' then
		if data.toType == 'newdrop' then
			return shoditPolozku(source, data)
		else
			local playerInventory = Inventar(source)
			local toInventory = (data.toType == 'player' and playerInventory) or Inventar(playerInventar.open)
			local fromInventory = (data.fromType == 'player' and playerInventory) or Inventar(playerInventar.open)

			if not fromInventory then
				Wait(0)
				fromInventory = (data.fromType == 'player' and playerInventory) or Inventar(playerInventar.open)
			end

			local sameInventory = fromInventar.id == toInventar.id or false

			if fromInventar.type == 'policeevidence' and not sameInventory then
				local group, rank = server.maSkupinu(toInventory, shared.police)

				if not group then return end

				if server.evidencegrade > rank then
					return TriggerClientEvent('ox_lib:notify', source, { type = 'error', description = shared.locale('evidence_cannot_take') })
				end
			end

			if toInventory and fromInventory and (fromInventar.id ~= toInventar.id or data.fromSlot ~= data.toSlot) then
				local fromData = fromInventar.items[data.fromSlot]

				if fromData and (not fromData.metadata.container or fromData.metadata.container and toInventar.type ~= 'container') then
					if data.count > fromData.count then data.count = fromData.count end
					local toData = toInventar.items[data.toSlot]
					local container = (not sameInventory and playerInventar.containerSlot) and (fromInventar.type == 'container' and fromInventory or toInventory)
					local containerItem = container and playerInventar.items[playerInventar.containerSlot]

					if toData and ((toData.name ~= fromData.name) or not toData.stack or (not table.matches(toData.metadata, fromData.metadata))) then
						-- Swap items
						local toWeight = not sameInventory and (toInventar.weight - toData.weight + fromData.weight)
						local fromWeight = not sameInventory and (fromInventar.weight + toData.weight - fromData.weight)

						if not sameInventory then
							if fromInventar.type == 'container' or (toWeight <= toInventar.maxWeight and fromWeight <= fromInventar.maxWeight) then
								fromInventar.weight = fromWeight
								toInventar.weight = toWeight

								if container then
									local toContainer = toInventar.type == 'container'
									local whitelist = Items.containers[containerPolozka.name]?.whitelist
									local blacklist = Items.containers[containerPolozka.name]?.blacklist
									local checkItem = toContainer and fromData.name or toData.name

									if (whitelist and not whitelist[checkItem]) or (blacklist and blacklist[checkItem]) then
										return
									end

									Inventar.HmotnostNadoby(containerItem, toContainer and toWeight or fromWeight, playerInventory)
								end

								toData, fromData = Inventar.VymenteSloty(fromInventory, toInventory, data.fromSlot, data.toSlot)

								Log(('%sx %s transferred from %s to %s for %sx %s'):format(fromData.count, fromData.name, fromInventar.owner and fromInventar.label or fromInventar.id, toInventar.owner and toInventar.label or toInventar.id, toData.count, toData.name),
									playerInventar.owner,
									'swapSlots', fromInventar.owner or fromInventar.id, toInventar.owner or toInventar.id
								)

							else return end
						else toData, fromData = Inventar.VymenteSloty(fromInventory, toInventory, data.fromSlot, data.toSlot) end

					elseif toData and toData.name == fromData.name and table.matches(toData.metadata, fromData.metadata) then
						-- Stack items
						toData.count += data.count
						fromData.count -= data.count
						local toSlotWeight = Inventar.SlotVaha(Items(toData.name), toData)
						local totalWeight = toInventar.weight - toData.weight + toSlotWeight

						if fromInventar.type == 'container' or sameInventory or totalWeight <= toInventar.maxWeight then
							local fromSlotWeight = Inventar.SlotVaha(Items(fromData.name), fromData)
							toData.weight = toSlotWeight
							if not sameInventory then
								fromInventar.weight = fromInventar.weight - fromData.weight + fromSlotWeight
								toInventar.weight = totalWeight

								if container then
									Inventar.HmotnostNadoby(containerItem, toInventar.type == 'container' and toInventar.weight or fromInventar.weight, playerInventory)
								end

								Log(('%sx %s transferred from %s to %s'):format(data.count, fromData.name, fromInventar.owner and fromInventar.label or fromInventar.id, toInventar.owner and toInventar.label or toInventar.id),
									playerInventar.owner,
									'swapSlots', fromInventar.owner or fromInventar.id, toInventar.owner or toInventar.id
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
						toData.weight = Inventar.SlotVaha(Items(toData.name), toData)
						if fromInventar.type == 'container' or sameInventory or (toInventar.weight + toData.weight <= toInventar.maxWeight) then
							if not sameInventory then

								local toContainer = toInventar.type == 'container'
								if container then
									if toContainer and containerItem then
										local whitelist = Items.containers[containerPolozka.name]?.whitelist
										local blacklist = Items.containers[containerPolozka.name]?.blacklist

										if (whitelist and not whitelist[fromData.name]) or (blacklist and blacklist[fromData.name]) then
											return
										end
									end
								end

								fromInventar.weight -= toData.weight
								toInventar.weight += toData.weight

								if container then
									Inventar.HmotnostNadoby(containerItem, toContainer and toInventar.weight or fromInventar.weight, playerInventory)
								end

								Log(('%sx %s transferred from %s to %s'):format(data.count, fromData.name, fromInventar.owner and fromInventar.label or fromInventar.id, toInventar.owner and toInventar.label or toInventar.id),
									playerInventar.owner,
									'swapSlots', fromInventar.owner or fromInventar.id, toInventar.owner or toInventar.id
								)

							end

							fromData.count -= data.count
							fromData.weight = Inventar.SlotVaha(Items(fromData.name), fromData)
						else return end
					end

					if fromData.count < 1 then fromData = nil end

					local items = {}

					if fromInventar.type == 'player' then
						items[data.fromSlot] = fromData or false
						if toInventar.type == 'container' then
							items[playerInventar.containerSlot] = containerItem
						end
					end

					if toInventar.type == 'player' then
						items[data.toSlot] = toData or false
						if fromInventar.type == 'container' then
							items[playerInventar.containerSlot] = containerItem
						end
					end

					fromInventar.items[data.fromSlot] = fromData
					toInventar.items[data.toSlot] = toData

					if fromInventar.changed ~= nil then fromInventar.changed = true end
					if toInventar.changed ~= nil then toInventar.changed = true end

					if sameInventory and fromInventar.type == 'otherplayer' then
						TriggerClientEvent('ox_inventory:aktualizovatSloty', fromInventar.id,{
							{
								item = fromInventar.items[data.toSlot] or {slot=data.toSlot},
								inventory = fromInventar.type
							},
							{
								item = fromInventar.items[data.fromSlot] or {slot=data.fromSlot},
								inventory = fromInventar.type
							}
						}, { left = fromInventar.weight })

					elseif toInventar.type == 'otherplayer' then
						TriggerClientEvent('ox_inventory:aktualizovatSloty', toInventar.id,{
							{
								item = toInventar.items[data.toSlot] or {slot=data.toSlot},
								inventory = toInventar.type
							}
						}, { left = toInventar.weight })

					elseif fromInventar.type == 'otherplayer' then
						TriggerClientEvent('ox_inventory:aktualizovatSloty', fromInventar.id,{
							{
								item = fromInventar.items[data.fromSlot] or {slot=data.fromSlot},
								inventory = fromInventar.type
							}
						}, { left = fromInventar.weight })
					end

					local resp

					if next(items) then
						resp = { weight = playerInventar.weight, items = items }
						if shared.framework == 'esx' and fromInventar.type == 'player' or fromInventar.type == 'otherplayer' then
							Inventar.SynchronizovatInventar(fromInventory)
						end
						if shared.framework == 'esx' and not sameInventory and (toInventar.type == 'player' or toInventar.type == 'otherplayer') then
							Inventar.SynchronizovatInventar(toInventory)
						end
					end

					local weaponSlot

					if toInventar.weapon == data.toSlot then
						if not sameInventory then
							toInventar.weapon = nil
							TriggerClientEvent('ox_inventory:Odzbrojit', toInventar.id)
						else
							weaponSlot = data.fromSlot
							toInventar.weapon = weaponSlot
						end
					end

					if fromInventar.weapon == data.fromSlot then
						if not sameInventory then
							fromInventar.weapon = nil
							TriggerClientEvent('ox_inventory:Odzbrojit', fromInventar.id)
						elseif not weaponSlot then
							weaponSlot = data.toSlot
							fromInventar.weapon = weaponSlot
						end
					end

					return container and containerPolozka.weight or true, resp, weaponSlot
				end
			end
		end
	end
end)

function Inventar.Zabavit(source)
	local inv = Inventories[source]
	if inv?.player then
		MySQL:ulozitSkrys(inv.owner, inv.owner, json.encode(minimalne(inv)))
		table.wipe(inv.items)
		inv.weight = 0
		TriggerClientEvent('ox_inventory:inventoryConfiscated', inv.id)
		if shared.framework == 'esx' then Inventar.SynchronizovatInventar(inv) end
	end
end
exports('ZabavitInventar', Inventar.Zabavit)

function Inventar.Vratit(source)
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
							local weight = Inventar.SlotVaha(item, i)
							totalWeight = totalWeight + weight
							inventory[i.slot] = {name = i.name, label = Polozka.label, weight = weight, slot = i.slot, count = i.count, description = Polozka.description, metadata = i.metadata, stack = Polozka.stack, close = Polozka.close}
						end
					end
				end

				inv.weight = totalWeight
				inv.items = inventory

				if shared.framework == 'esx' then Inventar.SynchronizovatInventar(inv) end
				TriggerClientEvent('ox_inventory:inventoryReturned', source, {inventory, totalWeight})
			end
		end)
	end
end
exports('VratitInventar', Inventar.Vratit)

---@param inv string | number
---@param keep nil
--- todo: support the keep argument, allowing users to define a list of item "types" to keep
--- i.e. {'money', 'weapons'} would keep money and weapons, but remove ammo, attachments, and other items
function Inventar.Vycistit(inv, keep)
	inv = Inventar(inv)
	if inv then
		if not keep then
			table.wipe(inv.items)
			inv.weight = 0
			if inv.player then
				TriggerClientEvent('ox_inventory:inventoryConfiscated', inv.id)
				if shared.framework == 'esx' then Inventar.SynchronizovatInventar(inv) end
				inv.weapon = nil
			end
		end
	end
end
exports('VycistitInventar', Inventar.Vycistit)

local function hracSpadl(source)
	local inv = Inventar(source)
	if inv then
		local openInventory = inv.open and Inventories[inv.open]
		if openInventory then
			otevritInventar.open = false
		end
		Inventories[source] = nil
	end
end

if shared.framework == 'esx' then
	AddEventHandler('esx:playerDropped', hracSpadl)

	AddEventHandler('esx:setJob', function(source, job)
		local inventory = Inventories[source]
		if inventory then
			Inventar.player.groups[job.name] = job.grade
		end
	end)
else
	AddEventHandler('playerDropped', function()
		hracSpadl(source)
	end)

	AddEventHandler('ox_groups:setGroup', function(source, group, rank)
		local inventory = Inventories[source]
		if inventory then
			Inventar.player.groups[group] = rank
		end
	end)
end

local function pripravitUlozeni(inv)
	inv.changed = false

	if inv.type == 'trunk' then
		return 1, { json.encode(minimalne(inv)), Inventar.ZiskatPlateFromId(inv.id) }
	elseif inv.type == 'glovebox' then
		return 2, { json.encode(minimalne(inv)), Inventar.ZiskatPlateFromId(inv.id) }
	else
		return 3, { inv.owner or '', inv.dbId, json.encode(minimalne(inv)) }
	end
end

SetInterval(function()
	local time = os.time()
	local parameters = { {}, {}, {} }
	local size = { 0, 0, 0 }

	for _, inv in pairs(Inventories) do
		if not inv.player and not inv.open then
			if not inv.datastore and inv.changed then
				local i, data = pripravitUlozeni(inv)
				size[i] += 1
				parameters[i][size[i]] = data
			end

			if (inv.datastore or inv.owner) and time - inv.time >= 3000 then
				Inventar.Odstranit(inv.id, inv.type)
			end
		end
	end

	MySQL:ulozitInventare(parameters[1], parameters[2], parameters[3])
end, 600000)

local function ulozitInventare(lock)
	local parameters = { {}, {}, {} }
	local size = { 0, 0, 0 }
	Inventar.Lock = lock or nil

	TriggerClientEvent('ox_inventory:zavritInventar', -1, true)

	for _, inv in pairs(Inventories) do
		if not inv.player and not inv.datastore and inv.changed then
			local i, data = pripravitUlozeni(inv)
			size[i] += 1
			parameters[i][size[i]] = data
		end
	end

	MySQL:ulozitInventare(parameters[1], parameters[2], parameters[3])
end

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if eventData.secondsRemaining == 60 then
		SetTimeout(50000, function()
			ulozitInventare(true)
		end)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == shared.resource then
		ulozitInventare(true)
	end
end)

RegisterServerEvent('ox_inventory:zavritInventar', function()
	local inventory = Inventories[source]
	if inventory?.open then
		if type(Inventar.open) ~= 'boolean' then
			local secondary = Inventories[Inventar.open]
			if secondary then
				secondary:set('open', false)
			end
		end
		inventory:set('open', false)
		Inventar.containerSlot = nil
	end
end)

RegisterServerEvent('ox_inventory:darovatPolozku', function(slot, target, count)
	local fromInventory = Inventories[source]
	local toInventory = Inventories[target]
	if count <= 0 then count = 1 end
	if toInventar.type == 'player' then
		local data = fromInventar.items[slot]
		local item = Items(data.name)
		if not toInventar.open and Inventar.MuzeNestPolozku(toInventory, item, count, data.metadata) then
			if data and data.count >= count then
				Inventar.OstranitPolozku(fromInventory, item, count, data.metadata, slot)
				Inventar.PridatPolozku(toInventory, item, count, data.metadata)

				Log(('%s gave %sx %s to %s'):format(fromInventar.label, count, data.name, toInventar.label),
					fromInventar.owner,
					'giveItem', toInventar.owner
				)

			end
		else
			TriggerClientEvent('ox_lib:notify', source, { type = 'error', description = shared.locale('cannot_give', count, data.label) })
		end
	end
end)

RegisterServerEvent('ox_inventory:aktualizovatZbran', function(action, value, slot)
	local inventory = Inventories[source]
	local syncInventory = false
	local type = type(value)

	if type == 'table' and action == 'component' then
		local item = Inventar.items[value.slot]
		if item then
			if Polozka.metadata.components then
				for k, v in pairs(Polozka.metadata.components) do
					if v == value.component then
						table.remove(Polozka.metadata.components, k)
						Inventar.PridatPolozku(inventory, value.component, 1)
						return TriggerClientEvent('ox_inventory:aktualizovatSloty', source, {{item = item}}, {left=Inventar.weight})
					end
				end
			end
		end
	else
		if not slot then slot = Inventar.weapon end
		local weapon = Inventar.items[slot]

		if weapon and weapon.metadata then
			local item = Items(weapon.name)

			if not Polozka.weapon then
				Inventar.weapon = nil
				return
			end

			if action == 'load' and weapon.metadata.durability > 0 then
				local ammo = Items(weapon.name).ammoname
				local diff = value - weapon.metadata.ammo
				Inventar.OstranitPolozku(inventory, ammo, diff)
				weapon.metadata.ammo = value
				weapon.weight = Inventar.SlotVaha(item, weapon)
				syncInventory = true
			elseif action == 'throw' then
				Inventar.OstranitPolozku(inventory, weapon.name, 1, weapon.metadata, weapon.slot)
			elseif action == 'component' then
				if type == 'number' then
					Inventar.PridatPolozku(inventory, weapon.metadata.components[value], 1)
					table.remove(weapon.metadata.components, value)
					weapon.weight = Inventar.SlotVaha(item, weapon)
				elseif type == 'string' then
					local component = Inventar.items[tonumber(value)]
					Inventar.OstranitPolozku(inventory, component.name, 1)
					table.insert(weapon.metadata.components, component.name)
					weapon.weight = Inventar.SlotVaha(item, weapon)
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
					weapon.weight = Inventar.SlotVaha(item, weapon)
				end
				syncInventory = true
			elseif action == 'melee' and value > 0 then
				weapon.metadata.durability = weapon.metadata.durability - ((Items(weapon.name).durability or 1) * value)
				syncInventory = true
			end

			if shared.framework == 'esx' and syncInventory then
				Inventar.SynchronizovatInventar(inventory)
			end

			if action ~= 'throw' then TriggerClientEvent('ox_inventory:aktualizovatSloty', source, {{item = weapon}}, {left=Inventar.weight}) end

			if weapon.metadata.durability and weapon.metadata.durability < 1 and action ~= 'load' and action ~= 'component' then
				TriggerClientEvent('ox_inventory:Odzbrojit', source)
			end
		end
	end
end)

lib.addCommand('group.admin', {'additem', 'giveitem'}, function(source, args)
	args.item = Items(args.item)
	if args.item and args.count > 0 then
		Inventar.PridatPolozku(args.target, args.Polozka.name, args.count, args.metatype)
		local inventory = Inventories[args.target]
		source = Inventories[source] or {label = 'console', owner = 'console'}

		Log(('%s gave %sx %s to %s'):format(source.label, args.count, args.Polozka.name, Inventar.label),
			source.owner,
			'admin', Inventar.owner
		)

	end
end, {'target:number', 'item:string', 'count:number', 'metatype:?string'})

lib.addCommand('group.admin', 'removeitem', function(source, args)
	args.item = Items(args.item)
	if args.item and args.count > 0 then
		Inventar.OstranitPolozku(args.target, args.Polozka.name, args.count, args.metaType)
		local inventory = Inventories[args.target]
		source = Inventories[source] or {label = 'console', owner = 'console'}

		Log(('%s took %sx %s from %s'):format(source.label, args.count, args.Polozka.name, Inventar.label),
			source.owner,
			'admin', Inventar.owner
		)

	end
end, {'target:number', 'item:string', 'count:number', 'metatype:?string'})

lib.addCommand('group.admin', 'setitem', function(source, args)
	args.item = Items(args.item)
	if args.item and args.count >= 0 then
		Inventar.NastavitPolozka(args.target, args.Polozka.name, args.count, args.metaType)
		local inventory = Inventories[args.target]
		source = Inventories[source] or {label = 'console', owner = 'console'}

		Log(('%s set %s\' %s count to %sx'):format(source.label, Inventar.label, args.Polozka.name, args.count),
			source.owner,
			'admin', Inventar.owner
		)

	end
end, {'target:number', 'item:string', 'count:number', 'metatype:?string'})

lib.addCommand(false, 'clearevidence', function(source, args)
	local inventory = Inventories[source]
	local hasPermission = false

	if shared.framework == 'esx' then
		-- todo: make it work
	else
		local group, rank = server.maSkupinu(inventory, shared.police)
		if group and rank == GlobalState.groups[group] then hasPermission = true end
	end

	if hasPermission then
		MySQL.query('DELETE FROM ox_inventory WHERE name = ?', {('evidence-%s'):format(args.evidence)})
	end
end, {'evidence:number'})

lib.addCommand('group.admin', 'takeinv', function(source, args)
	Inventar.Zabavit(args.target)
end, {'target:number'})

lib.addCommand('group.admin', 'returninv', function(source, args)
	Inventar.Vratit(args.target)
end, {'target:number'})

lib.addCommand('group.admin', 'clearinv', function(source, args)
	Inventar.Vycistit(args.target)
end, {'target:number'})

lib.addCommand('group.admin', 'saveinv', function(source, args)
	ulozitInventare(args[1] == 1 or args[1] == 'true')
end)

lib.addCommand('group.admin', 'viewinv', function(source, args)
	local inventory = Inventories[args.target] or Inventories[tonumber(args.target)]
	TriggerClientEvent('ox_inventory:viewInventory', source, inventory)
end, {'target'})

Inventar.accounts = server.accounts

TriggerEvent('ox_inventory:loadInventory', Inventory)

--- Takes traditional item data and updates it to support ox_inventory, i.e.\
--- ```
--- Old: [{"cola":1, "bread":3}]
--- New: [{"slot":1,"name":"cola","count":1}, {"slot":2,"name":"bread","count":3}]
---```
local function PrevestPolozky(playerId, items)
	if type(items) == 'table' then
		local returnData, totalWeight = table.create(#items, 0), 0
		local slot = 0

		for name, count in pairs(items) do
			local item = Items(name)
			local metadata = Items.Metadata(playerId, item, false, count)
			local weight = Inventar.SlotVaha(item, {count=count, metadata=metadata})
			totalWeight = totalWeight + weight
			slot += 1
			returnData[slot] = {name = Polozka.name, label = Polozka.label, weight = weight, slot = slot, count = count, description = Polozka.description, metadata = metadata, stack = Polozka.stack, close = Polozka.close}
		end

		return returnData, totalWeight
	end
end
exports('PrevestPolozky', PrevestPolozky)

Inventar.CustomStash = table.create(0, 0)
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
local function RegistrovatSkrys(name, label, slots, maxWeight, owner, groups, coords)
	if type(name) == 'string' then
		if not Inventar.CustomStash[name] then
			Inventar.CustomStash[name] = {
				name = name,
				label = label,
				owner = owner,
				slots = slots,
				weight = maxWeight,
				groups = groups,
				coords = coords
			}
		end
	else
		error(('received %s for stash name (expected string)'):format(type(name)))
	end
end
exports('RegistrovatSkrys', RegistrovatSkrys)

server.inventory = Inventar
