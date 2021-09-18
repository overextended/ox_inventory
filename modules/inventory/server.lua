local M = {}
local Inventories = {}
local Utils <const>, Items <const> = module('utils'), module('items')
setmetatable(M, {
	__call = function(self, arg)
		if arg then
			if arg == 'all' then return Inventories
			elseif Inventories[arg] then return Inventories[arg] else return false end
		end
		return self
	end
})

local Vehicle = {trunk=true, glovebox=true}

local Set = function(inv, k, v)
	inv = Inventories[type(inv) == 'table' and inv.id or inv]
	if type(v) == 'number' then math.floor(v + 0.5) end
	if k == 'open' and v == false then
		if inv.type ~= 'player' then
			if inv.type == 'drop' and not next(inv.items) then
				TriggerClientEvent('ox_inventory:removeDrop', -1, inv.id)
				inv = nil
			else inv.time = os.time(os.date('!*t')) end
		end
	end
	if inv then inv[k] = v end
end

local Get = function(inv, k)
	return Inventories[type(inv) == 'table' and inv.id or inv][k]
end

local Minimal = function(inv)
	inv = Inventories[type(inv) == 'table' and inv.id or inv]
	local inventory, count = {}, 0
	for k, v in pairs(inv.items) do
		if v.name and v.count > 0 then
			count += 1
			inventory[count] = {
				name = v.name,
				count = v.count,
				slot = k,
				metadata = v.metadata
			}
		end
	end
	return inventory
end

M.SyncInventory = function(xPlayer, inv)
	inv = Inventories[type(inv) == 'table' and inv.id or inv]
	local money = {money=0, black_money=0}
	for k, v in pairs(inv.items) do
		if money[v.name] then
			money[v.name] = money[v.name] + v.count
		end
	end
	xPlayer.syncInventory(inv.weight, inv.maxWeight, inv.items, money)
end

M.SetSlot = function(inv, item, count, metadata, slot)
	inv = Inventories[type(inv) == 'table' and inv.id or inv]
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

M.SlotWeight = function(item, slot)
	local weight = item.weight * slot.count
	if not slot.metadata then slot.metadata = {} end
	if item.ammoname then
		local ammo = {
			type = item.ammoname,
			count = slot.metadata.ammo,
			weight = item.weight
		}
		if ammo.count then weight = weight + ammo.weight * ammo.count end
	end
	if slot.metadata.weight then weight = weight + slot.metadata.weight end
	return weight
end

M.Create = function(...)
	local t = {...}
	if #t > 6 then
		local self = {
			id = t[1],
			label = t[2] or id,
			type = t[3],
			slots = t[4],
			weight = t[5],
			maxWeight = t[6],
			owner = t[7],
			items = type(t[8]) == 'table' and t[8] or nil,
			open = false,
			set = Set,
			get = Get,
			minimal = Minimal,
			time = os.time(os.date('!*t'))
		}

		if self.type == 'drop' then self.datastore = true else self.changed = false end

		if not self.items then
			self.items, self.weight, self.datastore = M.Load(self.id, self.type, self.owner)
		end

		Inventories[self.id] = self
		return Inventories[self.id]
	end
end

M.Remove = function(id, type)
	if type == 'drop' then
		TriggerClientEvent('ox_inventory:removeDrop', -1, id)
	end
	Inventories[id] = nil
end

M.Save = function(inv)
	inv = Inventories[type(inv) == 'table' and inv.id or inv]
	local inventory = json.encode(Minimal(inv))
	if inv.type == 'player' then
		exports.oxmysql:executeSync('UPDATE users SET inventory = ? WHERE identifier = ?', {
			inventory, inv.owner
		})
	else
		if Vehicle[inv.type] then
			local plate = inv.id:sub(6)
			if Config.TrimPlate then plate = string.strtrim(plate) end
			exports.oxmysql:executeSync('UPDATE owned_vehicles SET ?? = ? WHERE plate = ?', {
				inv.type,
				inventory,
				plate
			})
		else
			exports.oxmysql:executeSync('INSERT INTO ox_inventory (owner, name, data) VALUES (:owner, :name, :data) ON DUPLICATE KEY UPDATE data = :data', {
				owner = inv.owner or '',
				name = inv.id,
				data = inventory,
			})
		end
		inv.changed = false
	end
end

M.GenerateItems = function(id, invType, items)
	local returnData, totalWeight = table.create(#items, 0), 0
	if next(items) == nil then
		-- todo: random loot generation
	end
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

M.Load = function(id, invType, owner)
	local isVehicle, datastore, result = Vehicle[invType], nil, nil
	if id and invType then
		if isVehicle then
			local plate = id:sub(6)
			if Config.TrimPlate then plate = string.strtrim(plate) end
			result = exports.oxmysql:singleSync('SELECT ?? FROM owned_vehicles WHERE plate = ?', {
				invType, plate
			})
			if result then result = json.decode(result[invType])
			else
				if Config.RandomLoot then return GenerateItems(id, invType)else datastore = true end
			end
		elseif owner then
			result = exports.oxmysql:scalarSync('SELECT data FROM ox_inventory WHERE owner = ? AND name = ?', {
				id, owner
			})
			if result then result = json.decode(result) end
		elseif invType == 'dumpster' then
			if Config.RandomLoot then return GenerateItems(id, invType) else datastore = true end
		else
			result = exports.oxmysql:scalarSync('SELECT data FROM ox_inventory WHERE owner = ? AND name = ?', {
				'', id
			})
			if result then result = json.decode(result) end
		end
	end
	local returnData, weight = {}, 0
	if result then
		for _, v in pairs(result) do
			local item = Items(v.name)
			if item then
				weight = M.SlotWeight(item, v)
				returnData[v.slot] = {name = item.name, label = item.label, weight = weight, slot = v.slot, count = v.count, description = item.description, metadata = v.metadata, stack = item.stack, close = item.close}
			end
		end
	end
	return returnData, weight, datastore
end

M.GetItem = function(inv, item, metadata, returnsCount)
	item = type(item) == 'table' and item or Items(item)
	if item then item = returnsCount and item or table.clone(item)
		inv = Inventories[type(inv) == 'table' and inv.id or inv].items
		local count = 0
		if inv then
			metadata = not metadata and false or type(metadata) == 'string' and {type=metadata} or metadata
			for _, v in pairs(inv) do
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
	return
end

M.SwapSlots = function(inventory, slot)
	local fromSlot = inventory[1].items[slot[1]] and table.clone(inventory[1].items[slot[1]]) or nil
	local toSlot = inventory[2].items[slot[2]] and table.clone(inventory[2].items[slot[2]]) or nil
	if fromSlot then fromSlot.slot = slot[2] end
	if toSlot then toSlot.slot = slot[1] end
	inventory[1].items[slot[1]], inventory[2].items[slot[2]] = toSlot, fromSlot
	return fromSlot, toSlot
end

M.SetItem = function(inv, item, count, metadata)
	item, inv = Items(item), Inventories[type(inv) == 'table' and inv.id or inv]
	if item and count >= 0 then
		local itemCount = M.GetItem(inv, item.name, metadata, true)
		if count > itemCount then
			count = count - itemCount
			M.AddItem(inv, item.name, count, metadata)
		else
			itemCount = count - count
			M.RemoveItem(inv, item.name, count, metadata)
		end
	end
end

M.AddItem = function(inv, item, count, metadata, slot)
	item, inv = Items(item), Inventories[type(inv) == 'table' and inv.id or inv]
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
		inv.weight = inv.weight + (item.weight + (metadata.weight or 0)) * count
		if xPlayer then
			M.SyncInventory(xPlayer, inv)
			TriggerClientEvent('ox_inventory:updateInventory', xPlayer.source, {{item = inv.items[slot], inventory = inv.type}}, {left=inv.weight, right=(inv.open and not inv.open:find('shop')) and Inventories[inv.open].weight}, item.name, count, false)
		end
	end
end

local GetItemSlots = function(inv, item, metadata)
	inv = Inventories[type(inv) == 'table' and inv.id or inv]
	local totalCount, slots, emptySlots = 0, {}, inv.slots
	for k, v in pairs(inv.items) do
		emptySlots -= 1
		if v.name == item.name then
			if not v.metadata then v.metadata = {} end
			if not metadata or Utils.MatchTables(v.metadata, metadata) then
				totalCount = totalCount + v.count
				slots[k] = v.count
			end
		end
	end
	return slots, totalCount, emptySlots
end

M.RemoveItem = function(inv, item, count, metadata, slot)
	local item, inv = Items(item), Inventories[type(inv) == 'table' and inv.id or inv]
	count = math.floor(count + 0.5)
	if item and inv and count > 0 then
		local xPlayer = inv.type == 'player' and ESX.GetPlayerFromId(inv.id) or false
		metadata = metadata == nil and {} or type(metadata) == 'string' and {type=metadata} or metadata
		local slotItem = inv.items[slot] or false
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
		inv.weight = inv.weight - (item.weight + (metadata.weight or 0)) * removed
		if removed > 0 and xPlayer then
			M.SyncInventory(xPlayer, inv)
			local array = table.create(#slots, 0)
			for k, v in pairs(slots) do
				if type(v) == 'number' then
					array[k] = {item = {slot=v}, inventory = inv.type}
				else
					array[k] = {item = v, inventory = inv.type}
				end
			end
			TriggerClientEvent('ox_inventory:updateInventory', xPlayer.source, array, {left=inv.weight, right=(inv.open and not inv.open:find('shop')) and Inventories[inv.open].weight}, item.name, removed, true)
		end
	end
end

M.CanCarryItem = function(inv, item, count, metadata)
	local item, inv = Items(item), Inventories[type(inv) == 'table' and inv.id or inv]
	if item and inv then
		local freeSlot = false
		local itemSlots, totalCount, emptySlots = GetItemSlots(inv, item, metadata == nil and {} or type(metadata) == 'string' and {type=metadata} or metadata)
		if #itemSlots > 0 or emptySlots > 0 then
			if item.weight == 0 then return true end
			if count == nil then count = 1 end
			local newWeight = inv.weight + (item.weight * count)
			return newWeight <= inv.maxWeight
		end
	end
end

M.CanSwapItem = function(inv, firstItem, firstItemCount, testItem, testItemCount)
	local firstItemData = GetItem(inv, firstItem)
	local testItemData = GetItem(inv, testItem)
	if firstItemData.count >= firstItemCount then
		local weightWithoutFirst = inv.weight - (firstItemData.weight * firstItemCount)
		local weightWithTest = weightWithoutFirst + (testItemData.weight * testItemCount)
		return weightWithTest <= inv.maxWeight
	end
	return false
end

RegisterServerEvent('ox_inventory:removeItem', function(item, count, metadata, slot)
	local inventory = Inventories[source]
	if inventory.items[slot].name == item and inventory.items[slot].name:find('at_') and inventory.weapon then
		local weapon = inventory.items[inventory.weapon]
		table.insert(weapon.metadata.components, item)
	end
	M.RemoveItem(source, item, count, metadata, slot)
end)

local GenerateDropId = function()
	local drop
	repeat
		drop = math.random(100000, 999999)
		Wait(5)
	until not Inventories[drop]
	return drop
end

AddEventHandler('ox_inventory:createDrop', function(source, slot, toSlot, cb)
	local drop = GenerateDropId()
	M.Create(drop, 'Drop '..drop, 'drop', Config.PlayerSlots, 0, Config.DefaultWeight, false, {[slot] = table.clone(toSlot)})
	local coords = GetEntityCoords(GetPlayerPed(source))
	Inventories[drop].coords = coords
	cb(drop, coords)
end)

AddEventHandler('ox_inventory:customDrop', function(prefix, items, coords, slots, maxWeight)
	local drop = GenerateDropId()
	local items, weight = M.GenerateItems(drop, 'drop', items)
	M.Create(drop, prefix..' '..drop, 'drop', slots or Config.PlayerSlots, weight, maxWeight or Config.DefaultWeight, false, items)
	Inventories[drop].coords = coords
	TriggerClientEvent('ox_inventory:createDrop', -1, {drop, coords}, source)
end)

AddEventHandler('ox_inventory:confiscatePlayerInventory', function(xPlayer)
	xPlayer = type(xPlayer) == 'table' and xPlayer or ESX.GetPlayerFromId(xPlayer)
	local inv = xPlayer and Inventories[xPlayer.source]
	if inv then
		local inventory = json.encode(Minimal(inv))
		exports.oxmysql:execute('INSERT INTO ox_inventory (owner, name, data) VALUES (:owner, :name, :data) ON DUPLICATE KEY UPDATE data = :data', {
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
		exports.oxmysql:scalar('SELECT data FROM ox_inventory WHERE name = ?', {
			inv.owner
		}, function(data)
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

ESX.RegisterCommand({'giveitem', 'additem'}, 'admin', function(xPlayer, args, showError)
	args.item = Items(args.item)
	if args.item then M.AddItem(args.player.source, args.item.name, args.count, args.type or {}) end
end, true, {help = 'give an item to a player', validate = false, arguments = {
	{name = 'player', help = 'player id', type = 'player'},
	{name = 'item', help = 'item name', type = 'string'},
	{name = 'count', help = 'item count', type = 'number'},
	{name = 'type', help = 'item metadata type', type='any'}
}})

ESX.RegisterCommand('removeitem', 'admin', function(xPlayer, args, showError)
	args.item = Items(args.item)
	if args.item then M.RemoveItem(args.player.source, args.item.name, args.count, args.type or {}) end
end, true, {help = 'remove an item from a player', validate = false, arguments = {
	{name = 'player', help = 'player id', type = 'player'},
	{name = 'item', help = 'item name', type = 'string'},
	{name = 'count', help = 'item count', type = 'number'},
	{name = 'type', help = 'item metadata type', type='any'}
}})

ESX.RegisterCommand('setitem', 'admin', function(xPlayer, args, showError)
	args.item = Items(args.item)
	if args.item then M.SetItem(args.player.source, args.item.name, args.count, args.type or {}) end
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

ESX.RegisterCommand('saveinv', 'admin', function(xPlayer, args, showError)
	local time = os.time(os.date('!*t'))
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
		if Inventories[arg] then return Inventories[arg] else return false end
	end
	return M
end)

return M