local Inventory = {}
local Inventories = {}

setmetatable(Inventory, {
	__call = function(self, arg)
		if arg then
			local inventory = Inventories[arg]
			return inventory and inventory or type(arg) == 'table' and arg
		end
		return self
	end
})

---@param inv any
---@param k string
---@param v any
local function set(inv, k, v)
	inv = Inventory(inv)
	if inv then
		if type(v) == 'number' then math.floor(v + 0.5) end
		if k == 'open' and v == false then
			if inv.type ~= 'player' then
				if inv.type == 'otherplayer' then
					inv.type = 'player'
				elseif inv.type == 'drop' and not next(inv.items) then
					return Inventory.Remove(inv.id, inv.type)
				else inv.time = os.time() end
			end
		end
		inv[k] = v
	end
end

---@param inv any
---@param key string
local function get(inv, key)
	inv = Inventory(inv)
	if inv then
		return inv[key]
	end
end

---@param inv any
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
	local money = { money = 0, black_money = 0}

	for _, v in pairs(inv.items) do
		if money[v.name] then
			money[v.name] = money[v.name] + v.count
		end
	end

	ox.GetPlayerFromId(inv.id).syncInventory(inv.weight, inv.maxWeight, inv.items, money)
end

---@param inv any
---@param item table item data
---@param count number
---@param metadata any
---@param slot any
function Inventory.SetSlot(inv, item, count, metadata, slot)
	inv = Inventory(inv)
	local currentSlot = inv.items[slot]
	local newCount = currentSlot and currentSlot.count + count or count
	if currentSlot and newCount < 1 then
		count = currentSlot.count
		inv.items[slot] = nil
	else
		inv.items[slot] = {name = item.name, label = item.label, weight = item.weight, slot = slot, count = newCount, description = item.description, metadata = metadata, stack = item.stack, close = item.close}
		inv.items[slot].weight = Inventory.SlotWeight(item, inv.items[slot])
	end
end

local Items
CreateThread(function() Items = server.items end)

---@param item table
---@param slot table
function Inventory.SlotWeight(item, slot)
	local weight = item.weight * slot.count
	if not slot.metadata then slot.metadata = {} end
	if item.ammoname then
		local ammo = {
			type = item.ammoname,
			count = slot.metadata.ammo,
			weight = Items(item.ammoname).weight
		}
		if ammo.count then weight = weight + ammo.weight * ammo.count end
	end
	if slot.metadata.weight then weight = weight + slot.metadata.weight end
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
---@param label string
---@param invType string
---@param slots number
---@param weight number
---@param maxWeight number
---@param owner string
---@param items? table
--- This should only be utilised internally!
--- To create a stash, please use `exports.ox_inventory:RegisterStash` instead.
function Inventory.Create(id, label, invType, slots, weight, maxWeight, owner, items)
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
			set = set,
			get = get,
			minimal = minimal,
			time = os.time()
		}

		if self.type == 'drop' then
			self.datastore = true
		else
			self.changed = false
		end

		if not self.items then
			self.items, self.weight, self.datastore = Inventory.Load(self.id, self.type, self.owner)
		elseif self.weight == 0 and next(self.items) then
			self.weight = Inventory.CalculateWeight(self.items)
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

function Inventory.Save(inv)
	inv = Inventory(inv)
	local inventory = json.encode(minimal(inv))
	if inv.type == 'player' then
		MySQL.Sync.execute('UPDATE users SET inventory = ? WHERE identifier = ?', { inventory, inv.owner })
	else
		if inv.type == 'trunk' or inv.type == 'glovebox' then
			local plate = inv.id:sub(6)
			if ox.playerslots then plate = string.strtrim(plate) end
			MySQL.Sync.execute('UPDATE owned_vehicles SET ?? = ? WHERE plate = ?', { inv.type, inventory, plate })
		else
			MySQL.Sync.execute('INSERT INTO ox_inventory (owner, name, data) VALUES (:owner, :name, :data) ON DUPLICATE KEY UPDATE data = :data', {
				owner = inv.owner or '', name = inv.id, data = inventory,
			})
		end
		inv.changed = false
	end
end

---@param loot table
local function randomLoot(loot)
	local max, items = #loot, {}
	for i=1, math.random(1,3) do
		if math.random(math.floor(ox.lootchance/i), 100) then
			local randomItem = loot[math.random(1, max)]
			local count = math.random(randomItem[2], randomItem[3])
			if count > 0 then items[#items+1] = {randomItem[1], count} end
		end
	end
	return items
end

---@param inv string|number
---@param invType string
---@param items? table
---@return table returnData, number totalWeight, boolean true
local function generateItems(inv, invType, items)
	if items == nil then
		if invType == 'dumpster' then
			items = randomLoot(ox.dumpsterloot)
		else
			items = randomLoot(ox.loottable)
		end
	end

	local returnData, totalWeight = table.create(#items, 0), 0
	for i=1, #items do
		local v = items[i]
		local item = Items(v[1])
		local metadata, count = Items.Metadata(inv, item, v[3] or {}, v[2])
		local weight = Inventory.SlotWeight(item, {count=count, metadata=metadata})
		totalWeight = totalWeight + weight
		returnData[i] = {name = item.name, label = item.label, weight = weight, slot = i, count = count, description = item.description, metadata = metadata, stack = item.stack, close = item.close}
	end

	return returnData, totalWeight, true
end

---@param id string|number
---@param invType string
---@param owner string
function Inventory.Load(id, invType, owner)
	local isVehicle, datastore, result = (invType == 'trunk' or invType == 'glovebox'), nil, nil

	if id and invType then
		if isVehicle then
			local plate = id:sub(6)
			if ox.playerslots then plate = string.strtrim(plate) end
			result = MySQL.Sync.fetchSingle('SELECT ?? FROM owned_vehicles WHERE plate = ?', { invType, plate })
			if result then result = json.decode(result[invType])
			elseif ox.randomloot then return generateItems(id, invType)
			else datastore = true end
		elseif owner then
			result = MySQL.Sync.prepare('SELECT data FROM ox_inventory WHERE owner = ? AND name = ?', { owner, id })
			if result then result = json.decode(result) end
		elseif invType == 'dumpster' then
			if ox.randomloot then return generateItems(id, invType) else datastore = true end
		else
			result = MySQL.Sync.prepare('SELECT data FROM ox_inventory WHERE owner = ? AND name = ?', { '', id })
			if result then result = json.decode(result) end
		end
	end

	local returnData, weight = {}, 0
	if result then
		for _, v in pairs(result) do
			local item = Items(v.name)
			if item then
				local slotWeight = Inventory.SlotWeight(item, v)
				weight += slotWeight
				returnData[v.slot] = {name = item.name, label = item.label, weight = slotWeight, slot = v.slot, count = v.count, description = item.description, metadata = v.metadata or {}, stack = item.stack, close = item.close}
			end
		end
	end
	return returnData, weight, datastore
end

local table = import 'table'

---@param inv any
---@param item table|string
---@param metadata? any
---@param returnsCount? boolean
---@return table|number
function Inventory.GetItem(inv, item, metadata, returnsCount)
	item = type(item) == 'table' and item or Items(item)
	if type(item) ~= 'table' then item = Items(item) end
	if item then item = returnsCount and item or table.clone(item)
		inv = Inventory(inv)
		local count = 0
		if inv then
			metadata = not metadata and false or type(metadata) == 'string' and {type=metadata} or metadata
			for _, v in pairs(inv.items) do
				if v and v.name == item.name and (not metadata or table.contains(v.metadata, metadata)) then
					count += v.count
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

---@param fromInventory table
---@param toInventory table
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

function Inventory.ContainerWeight(container, metaWeight)
	container.weight = Items(container.name).weight
	container.weight += metaWeight
	container.metadata.weight = metaWeight
end

---@param inv any
---@param item table|string
---@param count number
---@param metadata? table
function Inventory.SetItem(inv, item, count, metadata)
	if type(item) ~= 'table' then item = Items(item) end
	if item and count >= 0 then
		inv = Inventory(inv)
		if inv then
			local itemCount = Inventory.GetItem(inv, item.name, metadata, true)
			if count > itemCount then
				count = count - itemCount
				Inventory.AddItem(inv, item.name, count, metadata)
			elseif count < itemCount then
				itemCount = count - count
				Inventory.RemoveItem(inv, item.name, count, metadata)
			end
		end
	end
end

---@param inv any
---@param slot number
---@param metadata table
function Inventory.SetMetadata(inv, slot, metadata)
	inv = Inventory(inv)
	slot = type(slot) == 'number' and (inv and inv.items[slot])
	if inv and slot then
		if inv then
			slot.metadata = type(metadata) == 'table' and metadata or {type = metadata}

			if metadata.weight then
				inv.weight -= slot.weight
				slot.weight = Inventory.SlotWeight(Items(item), slot)
				inv.weight += slot.weight
			end

			if inv.type == 'player' then
				if ox.esx then Inventory.SyncInventory(inv) end
				TriggerClientEvent('ox_inventory:updateInventory', inv.id, {{item = slot, inventory = inv.type}}, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight})
			end
		end
	end
end
exports('SetMetadata', Inventory.SetMetadata)

---@param inv any
---@param item table|string
---@param count number
---@param metadata? table|string
---@param slot number
---@param cb function
-- todo: add parameter checks to remove need for nil args
-- todo: add callback with several reasons for failure
-- ```
-- exports.ox_inventory:AddItem(1, 'bread', 4, nil, nil, function(success, reason)
-- if not success then
-- 	if reason == 'overburdened' then
-- 		TriggerClientEvent('ox_inventory:notify', source, {type = 'error', text = ox.locale('cannot_carry', count, data.label), duration = 2500})
-- 	end
-- end
-- ```
function Inventory.AddItem(inv, item, count, metadata, slot, cb)
	if type(item) ~= 'table' then item = Items(item) end
	inv = Inventory(inv)
	count = math.floor(count + 0.5)
	local success, reason = false, nil
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
				for i=1, ox.playerslots do
					local slotItem = items[i]
					if item.stack and slotItem ~= nil and slotItem.name == item.name and table.matches(slotItem.metadata, metadata) then
						toSlot, existing = i, true break
					elseif not toSlot and slotItem == nil then
						toSlot = i
					end
				end
				slot = toSlot
			end

			Inventory.SetSlot(inv, item, count, metadata, slot)
			inv.weight = inv.weight + (item.weight + (metadata?.weight or 0)) * count

			if inv.type == 'player' then
				if ox.esx then Inventory.SyncInventory(inv) end
				TriggerClientEvent('ox_inventory:updateInventory', inv.id, {{item = inv.items[slot], inventory = inv.type}}, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight}, count, false)
			end
		else
			success = false
			reason = 'invalid_inventory'
		end
	else
		success = false
		reason = 'invalid_item'
	end
	if cb then cb(success, reason) end
end
exports('AddItem', Inventory.AddItem)

---@param inv any
---@param search number '1: return all slots; 2: return total count'
---@param item table|string
---@param metadata? table|string
function Inventory.Search(inv, search, item, metadata)
	inv = Inventory(inv)
	if inv then
		inv = inv.items
		if type(item) == 'string' then item = {item} end
		if type(metadata) == 'string' then metadata = {type=metadata} end
		local items = #item
		local returnData = {}
		for i=1, items do
			local item = Items(item[i])?.name
			if search == 1 then returnData[item] = {}
			elseif search == 2 then returnData[item] = 0 end
			for _, v in pairs(inv) do
				if v.name == item then
					if not v.metadata then v.metadata = {} end
					if not metadata or table.contains(v.metadata, metadata) then
						if search == 1 then returnData[item][#returnData[item]+1] = inv[v.slot]
						elseif search == 2 then
							returnData[item] += v.count
						end
					end
				end
			end
		end
		if next(returnData) then return items == 1 and returnData[item[1]] or returnData end
	end
	return false
end
exports('Search', Inventory.Search)

---@param inv any
---@param item table|string
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

---@param inv any
---@param item table|string
---@param count number
---@param metadata? table|string
---@param slot number
function Inventory.RemoveItem(inv, item, count, metadata, slot)
	if type(item) ~= 'table' then item = Items(item) end
	count = math.floor(count + 0.5)
	if item and count > 0 then
		inv = Inventory(inv)

		if metadata ~= nil then
			metadata = type(metadata) == 'string' and {type=metadata} or metadata
		end

		local itemSlots, totalCount = Inventory.GetItemSlots(inv, item, metadata)
		if count > totalCount then count = totalCount end
		local removed, total, slots = 0, count, {}
		if slot and itemSlots[slot] then
			removed = count
			Inventory.SetSlot(inv, item, -count, metadata, slot)
			slots[#slots+1] = inv.items[slot] or slot
		elseif itemSlots and totalCount > 0 then
			for k, v in pairs(itemSlots) do
				if removed < total then
					if v == count then
						removed = total
						inv.items[k] = nil
						slots[#slots+1] = inv.items[k] or k
					elseif v > count then
						Inventory.SetSlot(inv, item, -count, metadata, k)
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

		inv.weight = inv.weight - (item.weight + (metadata?.weight or 0)) * removed
		if removed > 0 and inv.type == 'player' then
			if ox.esx then Inventory.SyncInventory(inv) end
			local array = table.create(#slots, 0)

			for k, v in pairs(slots) do
				if type(v) == 'number' then
					array[k] = {item = {slot = v, name = item.name}, inventory = inv.type}
				else
					array[k] = {item = v, inventory = inv.type}
				end
			end

			TriggerClientEvent('ox_inventory:updateInventory', inv.id, array, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight}, removed, true)
		end
	end
end
exports('RemoveItem', Inventory.RemoveItem)

---@param inv any
---@param item table|string
---@param count number
---@param metadata? table|string
function Inventory.CanCarryItem(inv, item, count, metadata)
	if type(item) ~= 'table' then item = Items(item) end
	if item then
		inv = Inventory(inv)
		local itemSlots, totalCount, emptySlots = Inventory.GetItemSlots(inv, item, metadata == nil and {} or type(metadata) == 'string' and {type=metadata} or metadata)

		if #itemSlots > 0 or emptySlots > 0 then
			if inv.type == 'player' and item.limit and (totalCount + count) > item.limit then return false end
			if item.weight == 0 then return true end
			if count == nil then count = 1 end
			local newWeight = inv.weight + (item.weight * count)
			return newWeight <= inv.maxWeight
		end

	end
end
exports('CanCarryItem', Inventory.CanCarryItem)

---@param inv any
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
	return false
end
exports('CanSwapItem', Inventory.CanSwapItem)

RegisterServerEvent('ox_inventory:removeItem', function(name, count, metadata, slot, used)
	local inv = Inventory(source)

	if inv.items[slot].name == name and inv.items[slot].name:find('at_') and inv.weapon then
		local weapon = inv.items[inv.weapon]
		table.insert(weapon.metadata.components, name)
	end

	Inventory.RemoveItem(source, name, count, metadata, slot)

	if used then
		if Items[name] then
			Items[name]('usedItem', Items(name), inv, slot)
		end
	end
end)

local function generateDropId()
	local drop
	repeat
		drop = math.random(100000, 999999)
		Wait(0)
	until not Inventories[drop]
	return drop
end

Inventory.Drops = {}
function Inventory.CreateDrop(source, slot, toSlot, cb)
	local drop = generateDropId()
	local inventory = Inventory.Create(drop, 'Drop '..drop, 'drop', ox.playerslots, toSlot.weight, ox.playerweight, false, {[slot] = table.clone(toSlot)})
	local coords = GetEntityCoords(GetPlayerPed(source))
	inventory.coords = vec3(coords.x, coords.y, coords.z-0.2)
	Inventory.Drops[drop] = inventory.coords
	cb(drop, coords)
end
AddEventHandler('ox_inventory:createDrop', CreateDrop)

local function customDrop(prefix, items, coords, slots, maxWeight)
	local drop = generateDropId()
	local items, weight = generateItems(drop, 'drop', items)
	local inventory = Inventory.Create(drop, prefix..' '..drop, 'drop', slots or ox.playerslots, weight, maxWeight or ox.playerweight, false, items)
	inventory.coords = coords
	Inventory.Drops[drop] = inventory.coords
	TriggerClientEvent('ox_inventory:createDrop', -1, {drop, coords}, inventory.open and source)
end
AddEventHandler('ox_inventory:customDrop', customDrop)
exports('CustomDrop', CustomDrop)

function Inventory.Confiscate(source)
	local inv = Inventories[source]
	if inv?.player then
		local inventory = json.encode(minimal(inv))
		MySQL.Async.execute('INSERT INTO ox_inventory (owner, name, data) VALUES (:owner, :name, :data) ON DUPLICATE KEY UPDATE data = :data', {
			owner = inv.owner,
			name = inv.owner,
			data = inventory,
		}, function (result)
			if result > 0 then
				table.wipe(inv.items)
				inv.weight = 0
				TriggerClientEvent('ox_inventory:inventoryConfiscated', inv.id)
				if ox.esx then Inventory.SyncInventory(inv) end
			end
		end)
	end
end
exports('ConfiscateInventory', Inventory.Confiscate)

AddEventHandler('ox_inventory:confiscatePlayerInventory', function(source)
	ox.warning('ox_inventory:confiscatePlayerInventory is deprecated! Use `exports.ox_inventory:ConfiscateInventory(id)` instead')
	Inventory.Confiscate(source)
end)

function Inventory.Return(source)
	local inv = Inventories[source]
	if inv?.player then
		MySQL.Async.fetchScalar('SELECT data FROM ox_inventory WHERE name = ?', { inv.owner }, function(data)
			if data then
				MySQL.Async.fetchAll('DELETE FROM ox_inventory WHERE name = ?', { inv.owner })
				data = json.decode(data)
				local money, inventory, totalWeight = {money=0, black_money=0}, {}, 0

				if data and next(data) then
					for i=1, #data do
						local i = data[i]
						if type(i) == 'number' then break end
						local item = Items(i.name)
						if item then
							local weight = Inventory.SlotWeight(item, i)
							totalWeight = totalWeight + weight
							inventory[i.slot] = {name = i.name, label = item.label, weight = weight, slot = i.slot, count = i.count, description = item.description, metadata = i.metadata, stack = item.stack, close = item.close}
							if money[i.name] then money[i.name] = money[i.name] + i.count end
						end
					end
				end

				inv.weight = totalWeight
				inv.items = inventory

				if ox.esx then Inventory.SyncInventory(inv) end
				TriggerClientEvent('ox_inventory:inventoryReturned', source, {inventory, totalWeight})
			end
		end)
	end
end
exports('ReturnInventory', Inventory.Return)

AddEventHandler('ox_inventory:returnPlayerInventory', function(source)
	ox.warning('ox_inventory:returnPlayerInventory is deprecated! Use `exports.ox_inventory:ReturnInventory(id)` instead')
	Inventory.Return(source)
end)

---@param inv any
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
				if ox.esx then Inventory.SyncInventory(inv) end
			end
		end
	end
end
exports('ClearInventory', Inventory.Clear)

AddEventHandler('ox_inventory:clearPlayerInventory', function(source)
	ox.warning('ox_inventory:clearPlayerInventory is deprecated! Use `exports.ox_inventory:ClearInventory(id)` instead')
	Inventory.Wipe(source)
end)

AddEventHandler('esx:playerDropped', function(source)
	local inv = Inventory(source)
	if inv then
		if inv.open and Inventories[inv.open]?.open == source then
			Inventories[openInventory].open = false
		end
		Inventories[source] = nil
	end
end)

AddEventHandler('esx:setJob', function(source, job)
	Inventories[source].player.job = job
end)

local function saveInventories()
	local time = os.time()
	for id, inv in pairs(Inventories) do
		if inv.type ~= 'player' and not inv.open then
			if inv.datastore == nil and inv.changed then
				Inventory.Save(inv)
			end
			if time - inv.time >= 3000 then
				Inventory.Remove(id, inv.type)
			end
		end
	end
end

SetInterval(saveInventories, 600000)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if eventData.secondsRemaining == 60 then
		SetTimeout(50000, saveInventories)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == ox.resource then
		saveInventories()
	end
end)

RegisterServerEvent('ox_inventory:closeInventory', function()
	local inventory = Inventories[source]
	if inventory?.open then
		if type(inventory.open) ~= 'boolean' then
			local secondary = Inventories[inventory.open]
			if secondary then
				secondary:set('open', false)
				if secondary.type == 'container' then
					inventory.containerSlot = nil
				end
			end
		end
		inventory:set('open', false)
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
			end
		else
			TriggerClientEvent('ox_inventory:notify', source, {type = 'error', text = ox.locale('cannot_give', count, data.label), duration = 2500})
		end
	end
end)

RegisterServerEvent('ox_inventory:updateWeapon', function(action, value, slot)
	local inventory = Inventories[source]
	if not slot then slot = inventory.weapon end
	local weapon = inventory.items[slot]
	local syncInventory = false
	if weapon and weapon.metadata then
		if action == 'load' and weapon.metadata?.durability > 0 then
			local ammo = Items(weapon.name).ammoname
			local diff = value - weapon.metadata.ammo
			Inventory.RemoveItem(inventory, ammo, diff)
			weapon.metadata.ammo = value
			syncInventory = true
		elseif action == 'throw' then
			Inventory.RemoveItem(inventory, weapon.name, 1, weapon.metadata, weapon.slot)
		elseif action == 'component' then
			local type = type(value)
			if type == 'number' then
				Inventory.AddItem(inventory, weapon.metadata.components[value], 1)
				table.remove(weapon.metadata.components, value)
			elseif type == 'string' then
				table.insert(weapon.metadata.components, value)
			end
			syncInventory = true
		elseif action == 'ammo' then
			if weapon.name == 'WEAPON_FIREEXTINGUISHER' or weapon.name == 'WEAPON_PETROLCAN' then
				weapon.metadata.durability = value
				weapon.metadata.ammo = weapon.metadata.durability
			elseif value < weapon.metadata.ammo then
				local durability = Items(weapon.name).durability * math.abs((weapon.metadata.ammo or 0.1) - value)
				weapon.metadata.ammo = value
				weapon.metadata.durability = weapon.metadata.durability - durability
			end
			syncInventory = true
		elseif action == 'melee' and value > 0 then
			weapon.metadata.durability = weapon.metadata.durability - ((Items(weapon.name).durability or 1) * value)
			syncInventory = true
		end

		if ox.esx and syncInventory then
			Inventory.SyncInventory(inventory)
		end

		if action ~= 'throw' then TriggerClientEvent('ox_inventory:updateInventory', source, {{item = weapon}}, {left=inventory.weight}) end
		if weapon.metadata?.durability <= 0 and action ~= 'load' and action ~= 'component' then
			TriggerClientEvent('ox_inventory:disarm', source, false)
		end
	end
end)

local Log = server.logs

local function AddCommand(group, name, callback, arguments)
	if type(name) == 'table' then
		for i=1, #name do
			AddCommand(group, name[i], callback, arguments)
		end
	else
		if not group then group = 'builtin.everyone' end

		RegisterCommand(name, function(source, args)
			if arguments then
				for i=1, #arguments do
					local arg, argType = string.strsplit(':', arguments[i])
					local value = args[i]

					if arg == 'target' and value == 'me' then value = source end

					if argType then
						if argType == 'number' then value = tonumber(value) end
						assert(type(value) == argType or argType:find('?'), ('command.%s expected <%s> for argument %s (%s), received %s'):format(name, argType, i, arg, type(value)))
					end

					args[arg] = value
					args[i] = nil
				end
			end
			callback(tonumber(source), args)
		end, group and true)

		name = ('command.%s'):format(name)
		if not IsPrincipalAceAllowed(group, name) then ExecuteCommand(('add_ace %s %s allow'):format(group, name)) end
	end
end

AddCommand('ox_inventory', {'additem', 'giveitem'}, function(source, args)
	args.item = Items(args.item)
	if args.item and args.count > 0 then
		Inventory.AddItem(args.target, args.item.name, args.count, args.metaType)
		local inventory = Inventories[args.target]
		source = Inventories[source]
		Log(
			('%s [%s] - %s'):format(source.label, source.id, source.owner),
			('%s [%s] - %s'):format(inventory.label, inventory.id, inventory.owner),
			('Given %s %s by an admin'):format(args.count, args.item.name)
		)
	end
end, {'target:number', 'item:string', 'count:number', 'metatype:?string'})

AddCommand('ox_inventory', 'removeitem', function(source, args)
	args.item = Items(args.item)
	if args.item and args.count > 0 then
		Inventory.RemoveItem(args.target, args.item.name, args.count, args.metaType)
		local inventory = Inventories[args.target]
		source = Inventories[source]
		Log(
			('%s [%s] - %s'):format(source.label, source.id, source.owner),
			('%s [%s] - %s'):format(inventory.label, inventory.id, inventory.owner),
			('%s %s removed by an admin'):format(args.count, args.item.name)
		)
	end
end, {'target:number', 'item:string', 'count:number', 'metatype:?string'})

AddCommand('ox_inventory', 'setitem', function(source, args)
	args.item = Items(args.item)
	if args.item and args.count > 0 then
		Inventory.SetItem(args.target, args.item.name, args.count, args.metaType)
		local inventory = Inventories[args.target]
		source = Inventories[source]
		Log(
			('%s [%s] - %s'):format(source.label, source.id, source.owner),
			('%s [%s] - %s'):format(inventory.label, inventory.id, inventory.owner),
			('%s count set to %s by an admin'):format(args.count, args.item.name)
		)
	end
end, {'target:number', 'item:string', 'count:number', 'metatype:?string'})

AddCommand(false, 'clearevidence', function(source, args)
	local inventory = Inventories[source]
	if inventory.player.job.name == 'police' and inventory.player.job.grade_name == 'boss' then
		MySQL.Async.fetchAll('DELETE FROM ox_inventory WHERE name = ?', {('evidence-%s'):format(args.evidence)})
	end
end, {'evidence:number'})

AddCommand('ox_inventory', 'takeinv', function(source, args)
	Inventory.Confiscate(args.target)
end, {'target:number'})

AddCommand('ox_inventory', 'returninv', function(source, args)
	Inventory.Return(args.target)
end, {'target:number'})

AddCommand('ox_inventory', 'clearinv', function(source, args)
	Inventory.Clear(args.target)
end, {'target:number'})

AddCommand('ox_inventory', 'saveinv', function(source, args)
	local time = os.time()
	for id, inv in pairs(Inventories) do
		if inv.type ~= 'player' then
			if inv.type ~= 'drop' and inv.datastore == nil then
				Inventory.Save(inv)
			end
			if time - inv.time >= 3000 then
				Inventory.Remove(id, inv.type)
			end
		end
	end
end)

AddCommand('ox_inventory', 'viewinv', function(source, args)
	local inventory = Inventories[args.target] or Inventories[tonumber(args.target)]
	TriggerClientEvent('ox_inventory:viewInventory', source, inventory)
end, {'target'})

TriggerEvent('ox_inventory:loadInventory', Inventory)

exports('Inventory', function(arg)
	if arg then
		if Inventories[arg] then return Inventories[arg] else return nil end
	end
	return Inventory
end)

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
		return returnData, weight
	end
end
exports('ConvertItems', ConvertItems)

Inventory.CustomStash = table.create(0, 0)
---@param id string|number stash identifier when loading from the database
---@param label string display name when inventory is open
---@param slots number
---@param maxWeight number
---@param owner string|boolean|nil
---@param jobs table
--- For simple integration with other resources that want to create valid stashes.  
--- This needs to be triggered before a player can open a stash.
--- ```
--- Owner sets the stash permissions.
--- string: can only access the stash linked to the owner (usually player identifier)
--- true: each player has a unique stash, but can request other player's stashes
--- nil: always shared
---
--- Jobs: { ['police'] = 0 }
--- ```
local function RegisterStash(id, label, slots, maxWeight, owner, jobs)

	if not Inventory.CustomStash[id] then
		Inventory.CustomStash[id] = {
			name = id,
			label = label,
			owner = owner,
			slots = slots,
			weight = maxWeight,
			jobs = jobs
		}
	end

end
exports('RegisterStash', RegisterStash)

server.inventory = Inventory
