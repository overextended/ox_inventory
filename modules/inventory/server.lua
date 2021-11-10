local M = {}
local Inventories = {}

setmetatable(M, {
	__call = function(self, arg)
		if arg then
			if Inventories[arg] then return Inventories[arg] else return nil end
		end
		return self
	end
})

local Vehicle = {.trunk, .glovebox}

---@param inv any
---@param k string key to set
---@param v any value to assign
local Set = function(inv, k, v)
	if type(inv) ~= 'table' then inv = Inventories[inv] end
	if inv then
		if type(v) == 'number' then math.floor(v + 0.5) end
		if k == 'open' and v == false then
			if inv.type ~= 'player' then
				if inv.type == 'otherplayer' then
					inv.type = 'player'
				elseif inv.type == 'drop' and not next(inv.items) then
					return M.Remove(inv.id, inv.type)
				else inv.time = os.time() end
			end
		end
		inv[k] = v
	end
end

---@param inv any
---@param k string key to return
local Get = function(inv, k)
	if type(inv) ~= 'table' then inv = Inventories[inv] end
	return inv[k]
end

---@param inv any
---@return table items table containing minimal inventory data
local Minimal = function(inv)
	if type(inv) ~= 'table' then inv = Inventories[inv] end
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

---@param xPlayer table
---@param inv any
--- Syncs inventory data with the xPlayer object for compatibility with shit resources
M.SyncInventory = function(xPlayer, inv)
	if type(inv) ~= 'table' then inv = Inventories[inv] end
	local money = {money=0, black_money=0}
	for _, v in pairs(inv.items) do
		if money[v.name] then
			money[v.name] = money[v.name] + v.count
		end
	end
	xPlayer.syncInventory(inv.weight, inv.maxWeight, inv.items, money)
end

---@param inv any
---@param item table item data
---@param count integer
---@param metadata any
---@param slot any
M.SetSlot = function(inv, item, count, metadata, slot)
	if type(inv) ~= 'table' then inv = Inventories[inv] end
	local currentSlot = inv.items[slot]
	local newCount = currentSlot and currentSlot.count + count or count
	if currentSlot and newCount < 1 then
		count = currentSlot.count
		inv.items[slot] = nil
	else
		inv.items[slot] = {name = item.name, label = item.label, weight = item.weight, slot = slot, count = newCount, description = item.description, metadata = metadata, stack = item.stack, close = item.close}
		inv.items[slot].weight = M.SlotWeight(item, inv.items[slot])
	end
end

---@module 'modules.items.server'
local Items <const> = include 'items'

---@param item table
---@param slot table
M.SlotWeight = function(item, slot)
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
M.CalculateWeight = function(items)
	local weight = 0
	for _, v in pairs(items) do
		local item = Items(v.name)
		if item then
			weight = weight + M.SlotWeight(item, v)
		end
	end
	return weight
end

---@param id string|integer
---@param label string
---@param invType string
---@param slots integer
---@param weight integer
---@param maxWeight integer
---@param owner string
---@param items? table
--- This should only be utilised internally!
--- To create a stash, please use `exports.ox_inventory:CreateStash` instead.
M.Create = function(id, label, invType, slots, weight, maxWeight, owner, items)
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
			set = Set,
			get = Get,
			minimal = Minimal,
			time = os.time()
		}

		if self.type == 'drop' then
			self.datastore = true
		else
			self.changed = false
		end

		if not self.items then
			self.items, self.weight, self.datastore = M.Load(self.id, self.type, self.owner)
		elseif self.weight == 0 and next(self.items) then
			self.weight = M.CalculateWeight(self.items)
		end

		Inventories[self.id] = self
		return Inventories[self.id]
	end
end

---@param id string|integer
---@param type string
M.Remove = function(id, type)
	if type == 'drop' then TriggerClientEvent('ox_inventory:removeDrop', -1, id) end
	Inventories[id] = nil
end

M.Save = function(inv)
	if type(inv) ~= 'table' then inv = Inventories[inv] end
	local inventory = json.encode(Minimal(inv))
	if inv.type == 'player' then
		exports.oxmysql:updateSync('UPDATE users SET inventory = ? WHERE identifier = ?', { inventory, inv.owner })
	else
		if Vehicle[inv.type] then
			local plate = inv.id:sub(6)
			if Config.TrimPlate then plate = string.strtrim(plate) end
			exports.oxmysql:updateSync('UPDATE owned_vehicles SET ?? = ? WHERE plate = ?', { inv.type, inventory, plate })
		else
			exports.oxmysql:updateSync('INSERT INTO ox_inventory (owner, name, data) VALUES (:owner, :name, :data) ON DUPLICATE KEY UPDATE data = :data', {
				owner = inv.owner or '', name = inv.id, data = inventory,
			})
		end
		inv.changed = false
	end
end

---@param loot table
local RandomLoot = function(loot)
	local max, items = #loot, {}
	for i=1, math.random(1,3) do
		if math.random(math.floor(Config.LootChance/i), 100) then
			local randomItem = loot[math.random(1, max)]
			local count = math.random(randomItem[2], randomItem[3])
			if count > 0 then items[#items+1] = {randomItem[1], count} end
		end
	end
	return items
end

---@param id string|integer
---@param invType string
---@param items? table
---@return table returnData, integer totalWeight, boolean true
local GenerateItems = function(id, invType, items)
	if items == nil then
		if invType == 'dumpster' then
			items = RandomLoot(Config.DumpsterLoot)
		else
			items = RandomLoot(Config.Loot)
		end
	end
	local returnData, totalWeight = table.create(#items, 0), 0
	local xPlayer = type(id) == 'integer' and ESX.GetPlayerFromId(id) or false
	for i=1, #items do
		local v = items[i]
		local item = Items(v[1])
		local metadata, count = Items.Metadata(xPlayer, item, v[3] or {}, v[2])
		local weight = M.SlotWeight(item, {count=count, metadata=metadata})
		totalWeight = totalWeight + weight
		returnData[i] = {name = item.name, label = item.label, weight = weight, slot = i, count = count, description = item.description, metadata = metadata, stack = item.stack, close = item.close}
	end
	return returnData, totalWeight, true
end

---@param id string|integer
---@param invType string
---@param owner string
M.Load = function(id, invType, owner)
	local isVehicle, datastore, result = Vehicle[invType], nil, nil
	if id and invType then
		if isVehicle then
			local plate = id:sub(6)
			if Config.TrimPlate then plate = string.strtrim(plate) end
			result = exports.oxmysql:singleSync('SELECT ?? FROM owned_vehicles WHERE plate = ?', { invType, plate })
			if result then result = json.decode(result[invType])
			elseif Config.RandomLoot then return GenerateItems(id, invType)
			else datastore = true end
		elseif owner then
			result = exports.oxmysql:scalarSync('SELECT data FROM ox_inventory WHERE owner = ? AND name = ?', { owner, id })
			if result then result = json.decode(result) end
		elseif invType == 'dumpster' then
			if Config.RandomLoot then return GenerateItems(id, invType) else datastore = true end
		else
			result = exports.oxmysql:scalarSync('SELECT data FROM ox_inventory WHERE owner = ? AND name = ?', { '', id })
			if result then result = json.decode(result) end
		end
	end
	local returnData, weight = {}, 0
	if result then
		for _, v in pairs(result) do
			local item = Items(v.name)
			if item then
				weight = M.SlotWeight(item, v)
				returnData[v.slot] = {name = item.name, label = item.label, weight = weight, slot = v.slot, count = v.count, description = item.description, metadata = v.metadata or {}, stack = item.stack, close = item.close}
			end
		end
	end
	return returnData, weight, datastore
end

local Utils <const> = include 'utils'

---@param inv any
---@param item table|string
---@param metadata? any
---@param returnsCount? boolean
---@return table|integer
M.GetItem = function(inv, item, metadata, returnsCount)
	item = type(item) == 'table' and item or Items(item)
	if type(item) ~= 'table' then item = Items(item) end
	if item then item = returnsCount and item or table.clone(item)
		if type(inv) ~= 'table' then inv = Inventories[inv] end
		local count = 0
		if inv then
			metadata = not metadata and false or type(metadata) == 'string' and {type=metadata} or metadata
			for _, v in pairs(inv.items) do
				if v and v.name == item.name and (not metadata or Utils.TableContains(v.metadata, metadata)) then
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

---@param fromInventory table
---@param toInventory table
---@param slot1 integer
---@param slot2 integer
M.SwapSlots = function(fromInventory, toInventory, slot1, slot2)
	local fromSlot = fromInventory.items[slot1] and table.clone(fromInventory.items[slot1]) or nil
	local toSlot = toInventory.items[slot2] and table.clone(toInventory.items[slot2]) or nil
	if fromSlot then fromSlot.slot = slot2 end
	if toSlot then toSlot.slot = slot1 end
	fromInventory.items[slot1], toInventory.items[slot2] = toSlot, fromSlot
	return fromSlot, toSlot
end

---@param inv any
---@param item table|string
---@param count integer
---@param metadata? table
M.SetItem = function(inv, item, count, metadata)
	if type(item) ~= 'table' then item = Items(item) end
	if item and count >= 0 then
		if type(inv) ~= 'table' then inv = Inventories[inv] end
		if inv then
			local itemCount = M.GetItem(inv, item.name, metadata, true)
			if count > itemCount then
				count = count - itemCount
				M.AddItem(inv, item.name, count, metadata)
			elseif count < itemCount then
				itemCount = count - count
				M.RemoveItem(inv, item.name, count, metadata)
			end
		end
	end
end

---@param inv any
---@param slot integer
---@param metadata table
M.SetMetadata = function(inv, slot, metadata)
	if type(inv) ~= 'table' then inv = Inventories[inv] end
	slot = type(slot) == 'number' and (inv and inv.items[slot])
	if inv and slot then
		if inv then
			local xPlayer = inv.type == 'player' and ESX.GetPlayerFromId(inv.id)
			slot.metadata = type(metadata) == 'table' and metadata or {type = metadata}
			if metadata.weight then
				inv.weight -= slot.weight
				slot.weight = M.SlotWeight(Items(item), slot)
				inv.weight += slot.weight
			end
			if xPlayer then
				M.SyncInventory(xPlayer, inv)
				TriggerClientEvent('ox_inventory:updateInventory', xPlayer.source, {{item = slot, inventory = inv.type}}, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight})
			end
		end
	end
end

---@param inv any
---@param item table|string
---@param count integer
---@param metadata? table|string
---@param slot integer
M.AddItem = function(inv, item, count, metadata, slot)
	if type(item) ~= 'table' then item = Items(item) end
	if type(inv) ~= 'table' then inv = Inventories[inv] end
	count = math.floor(count + 0.5)
	if item and inv and count > 0 then
		local xPlayer = inv.type == 'player' and ESX.GetPlayerFromId(inv.id) or false
		local existing = false
		if slot then
			local slotItem = inv.items[slot]
			if not slotItem or item.stack and slotItem and slotItem.name == item.name and Utils.MatchTables(slotItem.metadata, metadata) then
				existing = nil
			end
		end
		if existing == false then
			local items, toSlot = inv.items, nil
			for i=1, Config.PlayerSlots do
				local slotItem = items[i]
				if item.stack and slotItem ~= nil and slotItem.name == item.name and Utils.MatchTables(slotItem.metadata, metadata) then
					toSlot, existing = i, true break
				elseif not toSlot and slotItem == nil then
					toSlot = i
				end
			end
			slot = toSlot
		end
		metadata, count = Items.Metadata(xPlayer, item, metadata or {}, count)
		M.SetSlot(inv, item, count, metadata, slot)
		inv.weight = inv.weight + (item.weight + (metadata?.weight or 0)) * count
		if xPlayer then
			M.SyncInventory(xPlayer, inv)
			TriggerClientEvent('ox_inventory:updateInventory', xPlayer.source, {{item = inv.items[slot], inventory = inv.type}}, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight}, count, false)
		end
	end
end

---@param inv any
---@param search integer '1: return all slots; 2: return total count'
---@param item table|string
---@param metadata? table|string
M.Search = function(inv, search, item, metadata)
	inv = type(inv) ~= 'table' and Inventories[inv]?.items or inv.items
	if inv then
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
					if not metadata or Utils.TableContains(v.metadata, metadata) then
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

---@param inv any
---@param item table|string
---@param metadata? table
local GetItemSlots = function(inv, item, metadata)
	if type(inv) ~= 'table' then inv = Inventories[inv] end
	local totalCount, slots, emptySlots = 0, {}, inv.slots
	for k, v in pairs(inv.items) do
		emptySlots -= 1
		if v.name == item.name then
			if metadata and v.metadata == nil then
				v.metadata = {}
			end
			if not metadata or Utils.MatchTables(v.metadata, metadata) then
				totalCount = totalCount + v.count
				slots[k] = v.count
			end
		end
	end
	return slots, totalCount, emptySlots
end

---@param inv any
---@param item table|string
---@param count integer
---@param metadata? table|string
---@param slot integer
M.RemoveItem = function(inv, item, count, metadata, slot)
	if type(item) ~= 'table' then item = Items(item) end
	count = math.floor(count + 0.5)
	if item and count > 0 then
		if type(inv) ~= 'table' then inv = Inventories[inv] end
		local xPlayer = inv.type == 'player' and ESX.GetPlayerFromId(inv.id) or false
		if metadata ~= nil then
			metadata = type(metadata) == 'string' and {type=metadata} or metadata
		end
		local itemSlots, totalCount = GetItemSlots(inv, item, metadata)
		if count > totalCount then count = totalCount end
		local removed, total, slots = 0, count, {}
		if slot and itemSlots[slot] then
			removed = count
			M.SetSlot(inv, item, -count, metadata, slot)
			slots[#slots+1] = inv.items[slot] or slot
		elseif itemSlots and totalCount > 0 then
			for k, v in pairs(itemSlots) do
				if removed < total then
					if v == count then
						removed = total
						inv.items[k] = nil
						slots[#slots+1] = inv.items[k] or k
					elseif v > count then
						M.SetSlot(inv, item, -count, metadata, k)
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
		if removed > 0 and xPlayer then
			M.SyncInventory(xPlayer, inv)
			local array = table.create(#slots, 0)
			for k, v in pairs(slots) do
				if type(v) == 'number' then
					array[k] = {item = {slot = v, name = item.name}, inventory = inv.type}
				else
					array[k] = {item = v, inventory = inv.type}
				end
			end
			TriggerClientEvent('ox_inventory:updateInventory', xPlayer.source, array, {left=inv.weight, right=inv.open and Inventories[inv.open]?.weight}, removed, true)
		end
	end
end

---@param inv any
---@param item table|string
---@param count integer
---@param metadata? table|string
M.CanCarryItem = function(inv, item, count, metadata)
	if type(item) ~= 'table' then item = Items(item) end
	if item then
		if type(inv) ~= 'table' then inv = Inventories[inv] end
		local itemSlots, _, emptySlots = GetItemSlots(inv, item, metadata == nil and {} or type(metadata) == 'string' and {type=metadata} or metadata)
		if #itemSlots > 0 or emptySlots > 0 then
			if item.weight == 0 then return true end
			if count == nil then count = 1 end
			local newWeight = inv.weight + (item.weight * count)
			return newWeight <= inv.maxWeight
		end
	end
end

---@param inv any
---@param firstItem string
---@param firstItemCount integer
---@param testItem string
---@param testItemCount integer
M.CanSwapItem = function(inv, firstItem, firstItemCount, testItem, testItemCount)
	local firstItemData = M.GetItem(inv, firstItem)
	local testItemData = M.GetItem(inv, testItem)
	if firstItemData.count >= firstItemCount then
		local weightWithoutFirst = inv.weight - (firstItemData.weight * firstItemCount)
		local weightWithTest = weightWithoutFirst + (testItemData.weight * testItemCount)
		return weightWithTest <= inv.maxWeight
	end
	return false
end

RegisterServerEvent('ox_inventory:removeItem', function(name, count, metadata, slot, used)
	local inventory = Inventories[source]

	if inventory.items[slot].name == name and inventory.items[slot].name:find('at_') and inventory.weapon then
		local weapon = inventory.items[inventory.weapon]
		table.insert(weapon.metadata.components, item)
	end

	M.RemoveItem(source, name, count, metadata, slot)

	if used then
		if Items[name] then
			Items[name](Items(name), 'use', inventory, slot)
		end
	end
end)

local GenerateDropId = function()
	local drop
	repeat
		drop = math.random(100000, 999999)
		Wait(0)
	until not Inventories[drop]
	return drop
end

M.Drops = {}
AddEventHandler('ox_inventory:createDrop', function(source, slot, toSlot, cb)
	local drop = GenerateDropId()
	local inventory = M.Create(drop, 'Drop '..drop, 'drop', Config.PlayerSlots, toSlot.weight, Config.DefaultWeight, false, {[slot] = table.clone(toSlot)})
	local coords = GetEntityCoords(GetPlayerPed(source))
	inventory.coords = coords
	M.Drops[drop] = inventory.coords
	cb(drop, coords)
end)

AddEventHandler('ox_inventory:customDrop', function(prefix, items, coords, slots, maxWeight)
	local drop = GenerateDropId()
	local items, weight = GenerateItems(drop, 'drop', items)
	local inventory = M.Create(drop, prefix..' '..drop, 'drop', slots or Config.PlayerSlots, weight, maxWeight or Config.DefaultWeight, false, items)
	inventory.coords = coords
	M.Drops[drop] = inventory.coords
	TriggerClientEvent('ox_inventory:createDrop', -1, {drop, coords}, inventory.open and source)
end)

AddEventHandler('ox_inventory:confiscatePlayerInventory', function(xPlayer)
	xPlayer = type(xPlayer) == 'table' and xPlayer or ESX.GetPlayerFromId(xPlayer)
	local inv = xPlayer and Inventories[xPlayer.source]
	if inv then
		local inventory = json.encode(Minimal(inv))
		exports.oxmysql:update('INSERT INTO ox_inventory (owner, name, data) VALUES (:owner, :name, :data) ON DUPLICATE KEY UPDATE data = :data', {
			owner = inv.owner,
			name = inv.owner,
			data = inventory,
		}, function (result)
			if result > 0 then
				inv.items = {}
				inv.weight = 0
				TriggerClientEvent('ox_inventory:inventoryConfiscated', inv.id)
				M.SyncInventory(xPlayer, inv)
			end
		end)
	end
end)

AddEventHandler('ox_inventory:returnPlayerInventory', function(xPlayer)
	xPlayer = type(xPlayer) == 'table' and xPlayer or ESX.GetPlayerFromId(xPlayer)
	local inv = xPlayer and Inventories[xPlayer.source]
	if inv then
		exports.oxmysql:scalar('SELECT data FROM ox_inventory WHERE name = ?', { inv.owner }, function(data)
			if data then
				exports.oxmysql:execute('DELETE FROM ox_inventory WHERE name = ?', { inv.owner })
				data = json.decode(data)
				local money, inventory, totalWeight = {money=0, black_money=0}, {}, 0
				if data and next(data) then
					for i=1, #data do
						local i = data[i]
						if type(i) == 'number' then break end
						local item = Items(i.name)
						if item then
							local weight = M.SlotWeight(item, i)
							totalWeight = totalWeight + weight
							inventory[i.slot] = {name = i.name, label = item.label, weight = weight, slot = i.slot, count = i.count, description = item.description, metadata = i.metadata, stack = item.stack, close = item.close}
							if money[i.name] then money[i.name] = money[i.name] + i.count end
						end
					end
				end
				inv.weight = totalWeight
				inv.items = inventory
				xPlayer.syncInventory(totalWeight, inv.maxWeight, inventory, money)
				TriggerClientEvent('ox_inventory:inventoryReturned', xPlayer.source, {inventory, totalWeight})
			end
		end)
	end
end)

AddEventHandler('ox_inventory:clearPlayerInventory', function(xPlayer)
	xPlayer = type(xPlayer) == 'table' and xPlayer or ESX.GetPlayerFromId(xPlayer)
	local inv = xPlayer and Inventories[xPlayer.source]
	if inv then
		inv.items = {}
		inv.weight = 0
		TriggerClientEvent('ox_inventory:inventoryConfiscated', inv.id)
		M.SyncInventory(xPlayer, inv)
	end
end)

AddEventHandler('esx:playerDropped', function(playerId)
	if Inventories[playerId] then
		local openInventory = Inventories[playerId].open
		if Inventories[openInventory]?.open == playerId then Inventories[openInventory].open = false end
		Inventories[playerId] = nil
	end
end)

AddEventHandler('esx:setJob', function(playerId, job)
	Inventories[playerId].job = job
end)

local SaveInventories = function()
	local time = os.time()
	for id, inv in pairs(Inventories) do
		if inv.type ~= 'player' and not inv.open then
			if inv.datastore == nil and inv.changed then
				M.Save(inv)
			end
			if time - inv.time >= 3000 then
				M.Remove(id, inv.type)
			end
		end
	end
end

SetInterval(1, 600000, SaveInventories)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if eventData.secondsRemaining == 60 then
		SetTimeout(50000, SaveInventories)
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == ox.name then
		SaveInventories()
	end
end)

RegisterServerEvent('ox_inventory:giveItem', function(slot, target, count)
	local fromInventory = Inventories[source]
	local toInventory = Inventories[target]
	if count <= 0 then count = 1 end
	if toInventory.type == 'player' then
		local data = fromInventory.items[slot]
		local item = Items(data.name)
		if not toInventory.open and M.CanCarryItem(toInventory, item, count, data.metadata) then
			if data and data.count >= count then
				M.RemoveItem(fromInventory, item, count, data.metadata, slot)
				M.AddItem(toInventory, item, count, data.metadata)
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
			M.RemoveItem(inventory, ammo, diff)
			weapon.metadata.ammo = value
			syncInventory = true
		elseif action == 'throw' then
			M.RemoveItem(inventory, weapon.name, 1, weapon.metadata, weapon.slot)
		elseif action == 'component' then
			local type = type(value)
			if type == 'number' then
				M.AddItem(inventory, weapon.metadata.components[value], 1)
				table.remove(weapon.metadata.components, value)
			elseif type == 'string' then
				table.insert(weapon.metadata.components, component)
			end
			syncInventory = true
		elseif action == 'ammo' then
			if value < weapon.metadata.ammo then
				local durability = Items(weapon.name).durability * math.abs(weapon.metadata.ammo - value)
				weapon.metadata.ammo = value
				weapon.metadata.durability = weapon.metadata.durability - durability
			end
			syncInventory = true
		elseif action == 'melee' and value > 0 then
			weapon.metadata.durability = weapon.metadata.durability - ((Items(weapon.name).durability or 1) * value)
			syncInventory = true
		end
		if syncInventory then M.SyncInventory(ESX.GetPlayerFromId(inventory.id), inventory) end
		if action ~= 'throw' then TriggerClientEvent('ox_inventory:updateInventory', source, {{item = weapon}}, {left=inventory.weight}) end
		if weapon.metadata?.durability <= 0 and action ~= 'load' and action ~= 'component' then
			TriggerClientEvent('ox_inventory:disarm', source, false)
		end
	end
end)

local Log <const> = include 'logs'

ESX.RegisterCommand({'giveitem', 'additem'}, 'admin', function(xPlayer, args, showError)
	args.item = Items(args.item)
	if args.item and args.count then
		M.AddItem(args.player.source, args.item.name, args.count, args.type)
		local inventory = Inventories[args.player.source]

		Log(
			('%s [%s] - %s'):format(xPlayer.name, xPlayer.source, xPlayer.identifier),
			('%s [%s] - %s'):format(inventory.label, inventory.id, inventory.owner),
			('Given %s %s by an admin'):format(args.count, args.item.name)
		)
	end
end, true, {help = 'give an item to a player', validate = false, arguments = {
	{name = 'player', help = 'player id', type = 'player'},
	{name = 'item', help = 'item name', type = 'string'},
	{name = 'count', help = 'item count', type = 'number'},
	{name = 'type', help = 'item metadata type', type='any'}
}})

ESX.RegisterCommand('removeitem', 'admin', function(xPlayer, args, showError)
	args.item = Items(args.item)
	if args.item and args.count then
		M.RemoveItem(args.player.source, args.item.name, args.count, args.type)
		local inventory = Inventories[args.player.source]

		Log(
			('%s [%s] - %s'):format(xPlayer.name, xPlayer.source, xPlayer.identifier),
			('%s [%s] - %s'):format(inventory.label, inventory.id, inventory.owner),
			('%s %s removed by an admin'):format(args.count, args.item.name)
		)
	end
end, true, {help = 'remove an item from a player', validate = false, arguments = {
	{name = 'player', help = 'player id', type = 'player'},
	{name = 'item', help = 'item name', type = 'string'},
	{name = 'count', help = 'item count', type = 'number'},
	{name = 'type', help = 'item metadata type', type='any'}
}})

ESX.RegisterCommand('setitem', 'admin', function(xPlayer, args, showError)
	args.item = Items(args.item)
	if args.item then
		M.SetItem(args.player.source, args.item.name, args.count, args.type)
		local inventory = Inventories[args.player.source]

		Log(
			('%s [%s] - %s'):format(xPlayer.name, xPlayer.source, xPlayer.identifier),
			('%s [%s] - %s'):format(inventory.label, inventory.id, inventory.owner),
			('%s count set to %s by an admin'):format(args.count, args.item.name)
		)
	end
end, true, {help = 'give an item to a player', validate = false, arguments = {
	{name = 'player', help = 'player id', type = 'player'},
	{name = 'item', help = 'item name', type = 'string'},
	{name = 'count', help = 'item count', type = 'number'},
	{name = 'type', help = 'item metadata type', type='any'}
}})

ESX.RegisterCommand('clearevidence', 'user', function(xPlayer, args, showError)
	if xPlayer.job.name == 'police' and xPlayer.job.grade_name == 'boss' then
		local id = 'evidence-'..args.evidence
		exports.oxmysql:executeSync('DELETE FROM ox_inventory WHERE name = ?', {id})
	end
end, true, {help = 'clear police evidence', validate = true, arguments = {
	{name = 'evidence', help = 'locker number', type = 'number'}
}})

ESX.RegisterCommand('confinv', 'admin', function(xPlayer, args, showError)
	TriggerEvent('ox_inventory:confiscatePlayerInventory', args.playerId)
end, true, {help = 'Confiscates items from a player', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'},
}})

ESX.RegisterCommand('returninv', 'admin', function(xPlayer, args, showError)
	TriggerEvent('ox_inventory:returnPlayerInventory', args.playerId)
end, true, {help = 'Returns confiscated items to a player', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'},
}})

ESX.RegisterCommand('clearinv', 'admin', function(xPlayer, args, showError)
	TriggerEvent('ox_inventory:clearPlayerInventory', args.playerId)
end, true, {help = 'Returns confiscated items to a player', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'},
}})

ESX.RegisterCommand('saveinv', 'admin', function(xPlayer, args, showError)
	local time = os.time()
	for id, inv in pairs(Inventories) do
		if inv.type ~= 'player' then
			if inv.type ~= 'drop' and inv.datastore == nil then
				M.Save(inv)
			end
			if time - inv.time >= 3000 then
				M.Remove(id, inv.type)
			end
		end
	end
end, true, {help = 'Save all inventories', validate = true, arguments = {}})

TriggerEvent('ox_inventory:loadInventory', M)

exports('Inventory', function(arg)
	if arg then
		if Inventories[arg] then return Inventories[arg] else return nil end
	end
	return M
end)

--- Takes traditional item data and updates it to support ox_inventory, i.e.\
--- ```lua
--- Old: {"cola":1, "bread":3}\
--- New: [{"slot":1,"name":"cola","count":1}, {"slot":2,"name":"bread","count":3}]
---```
local ConvertItems = function(playerId, items)
	if type(items) == 'table' then
		local returnData, totalWeight = table.create(#items, 0), 0
		local xPlayer = ESX.GetPlayerFromId(playerId)
		local slot = 0
		for name, count in pairs(items) do
			local item = Items(name)
			local metadata = Items.Metadata(xPlayer, item, false, count)
			local weight = M.SlotWeight(item, {count=count, metadata=metadata})
			totalWeight = totalWeight + weight
			slot += 1
			returnData[slot] = {name = item.name, label = item.label, weight = weight, slot = slot, count = count, description = item.description, metadata = metadata, stack = item.stack, close = item.close}
		end
		return returnData, weight
	end
end
exports('ConvertItems', ConvertItems)

M.CustomStash = table.create(0, 0)
--- For simple integration with other resources that want to create stashes.\
--- Accepts items using ox_inventory or traditional data formats.\
--- Items should only be sent when creating the stash for the first time, otherwise leave it empty and the data will be loaded from the database.
local CreateStash = function(id, label, slots, maxWeight, owner, items)
	local weight = 0
	if items then
		local firstItem = next(items)
		if firstItem and not firstItem.slot then
			items, weight = ConvertItems(items)
		end
	end

	-- Allows the stash to be requested by clients.
	if not M.CustomStash[id] then
		M.CustomStash[id] = {
			name = id,
			label = label,
			owner = owner and true,
			slots = slots,
			weight = maxWeight
		}
	end

	M.Create(id, label, 'stash', slots, weight, maxWeight, owner, items)
end
exports('CreateStash', CreateStash)

return M
