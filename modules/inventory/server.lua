local M = {}
local Inventories = {}
local Utils, Items = module('utils', true), module('items')
local metatable = setmetatable(M, {
	__call = function(self, arg)
		if arg then
			if arg == 'all' then return Inventories
			elseif Inventories[arg] then return Inventories[arg] else return false end
		end
		return self
	end
})

local Vehicle = {trunk=true, glovebox=true}

local SetMetadata = function(metadata)
	local metadata = metadata == nil and {} or type(metadata) == 'string' and {type=metadata} or metadata
	return metadata
end

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

local GetPlayer = function(inv)
	return ESX.GetPlayerFromId(inv.id)
end

local Minimal = function(inv)
	inv = Inventories[type(inv) == 'table' and inv.id or inv]
	local inventory, count = {}, 0
	for k, v in pairs(inv.items) do
		if v.name and v.count > 0 then
			count = count + 1
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

local Weight = function(inv)
	inv = Inventories[type(inv) == 'table' and inv.id or inv].items
	local weight = 0
	for k, v in pairs(inv) do
		weight = weight + (v.weight * v.count)
		if v.metadata.weight then weight = weight + v.metadata.weight or 0 end
	end
	inv.weight = math.floor(weight + 0.5)
	return inv.weight
end

local GenerateText = function(num)
	local str
	repeat
		str = {}
		for i=1, num do
			str[i] = string.char(math.random(65, 90))
		end
		str = ox.concat('', table.unpack(str))
		Wait(5)
	until str ~= 'POL' and str ~= 'EMS'
	return str
end

local GenerateSerial = function(text)
	if not text then GenerateText(3)
	elseif text:len() > 3 then return text end
	return ('%s%s%s'):format(math.random(100000,999999), text, math.random(100000,999999))
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
		weight = weight + ammo.weight * ammo.count
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
			minimal = Minimal
		}

		if self.type == 'player' then self.player = GetPlayer
		else self.changed, self.time = false, os.time(os.date('!*t')) end

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
		if inv.owner then
			exports.oxmysql:executeSync('INSERT INTO ox_inventory (name, data, owner) VALUES (:name, :data, :owner) ON DUPLICATE KEY UPDATE data = :data', {
				['name'] = inv.id,
				['data'] = inventory,
				['owner'] = inv.owner
			})
		elseif Vehicle[inv.type] then
			local plate = inv.id:sub(6)
			if Config.TrimPlate then plate = ox.trim(plate) end
			exports.oxmysql:executeSync('UPDATE owned_vehicles SET '..inv.type..' = ? WHERE plate = "'..plate..'"', {
				inventory
			})
		else
			exports.oxmysql:executeSync('INSERT INTO ox_inventory (name, data) VALUES (:name, :data) ON DUPLICATE KEY UPDATE data = :data', {
				['name'] = inv.id,
				['data'] = inventory
			})
		end
		inv.changed = false
	end
end

M.Load = function(id, inv, owner)
	local returnData, weight, result, datastore = {}, 0
	local isVehicle = Vehicle[inv]
	if id and inv then
		if isVehicle then
			local plate = id:sub(6)
			if Config.TrimPlate then plate = ox.trim(plate) end
			result = exports.oxmysql:singleSync('SELECT '..inv..' FROM owned_vehicles WHERE plate = ?', {
				plate
			})
			if result then result = json.decode(result[inv])
			else
				if Config.RandomLoot then result = GenerateDatastore(id, inv) end
				datastore = true
			end
		elseif owner then
			result = exports.oxmysql:scalarSync('SELECT data FROM ox_inventory WHERE name = ? AND owner = ?', {
				id, owner
			})
			if result then result = json.decode(result) end
		elseif inv == 'dumpster' then
			if Config.RandomLoot then result = GenerateDatastore(id, inv) end
			datastore = true
		else
			result = exports.oxmysql:scalarSync('SELECT data FROM ox_inventory WHERE name = ?', {
				id
			})
			if result then result = json.decode(result) end
		end
	end
	if result then
		for k, v in pairs(result) do
			local item = Items(v.name)
			if item then
				weight = M.SlotWeight(item, v)
				returnData[v.slot] = {name = item.name, label = item.label, weight = weight, slot = v.slot, count = v.count, description = item.description, metadata = v.metadata, stack = item.stack, close = item.close}
			end
		end
	end
	return returnData, weight, datastore
end

M.GetItem = function(inv, item, metadata)
	if item then item = Utils.Copy(item)
		local inv, count = Inventories[type(inv) == 'table' and inv.id or inv].items, 0
		if inv then
			metadata = not metadata and false or type(metadata) == 'string' and {type=metadata} or metadata
			for k, v in pairs(inv) do
				if v and v.name == item.name and (not metadata or Utils.TableContains(v.metadata or {}, metadata)) then
					count = count + v.count
				end
			end
		end
		item.count = count
		return item
	end
	return
end

M.SwapSlots = function(inventory, slot)
	local fromSlot = inventory[1].items[slot[1]] and Utils.Copy(inventory[1].items[slot[1]]) or nil
	local toSlot = inventory[2].items[slot[2]] and Utils.Copy(inventory[2].items[slot[2]]) or nil
	if fromSlot then fromSlot.slot = slot[2] end
	if toSlot then toSlot.slot = slot[1] end
	inventory[1].items[slot[1]], inventory[2].items[slot[2]] = toSlot, fromSlot
	return fromSlot, toSlot
end

M.SetItem = function(inv, item, count, metadata)
	local item, inv = Items(item), Inventories[type(inv) == 'table' and inv.id or inv]
	if item and count >= 0 then
		local itemCount = M.GetItem(inv, item.name, metadata).count
		if count > itemCount then
			count = count - itemCount
			M.AddItem(inv, item.name, count, metadata)
		else
			itemcount = count - count
			M.RemoveItem(inv, item.name, count, metadata)
		end
	end
end

M.AddItem = function(inv, item, count, metadata, slot)
	local item, inv = Items(item), Inventories[type(inv) == 'table' and inv.id or inv]
	count = math.floor(count + 0.5)
	if item and inv and count > 0 then
		local xPlayer = inv.type == 'player' and inv:player() or false
		local isWeapon = item.name:find('WEAPON_')
		if isWeapon == nil then metadata = SetMetadata(metadata) elseif metadata == 'setname' then metadata = {description = xPlayer.name} end
		local existing = false
		if slot then
			local slotItem = inv.items[slot]
			if not slotItem or item.stack and slotItem and slotItem.name == item.name and Utils.MatchTables(slotItem.metadata, metadata) then
				existing = nil
			end
		end
		if existing == false then
			local items, toSlot = inv.items
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
		if isWeapon then
			if not item.ammoname then
				metadata = {}
				if not item.throwable then count, metadata.durability = 1, 100 end
			else
				count = 1
				if type(metadata) ~= 'table' then metadata = {} end
				if not metadata.durability then metadata.durability = 100 end
				if item.ammoname then metadata.ammo = 0 end
				if not metadata.components then metadata.components = {} end
				if metadata.registered ~= false then
					metadata.registered = xPlayer.name
					metadata.serial = GenerateSerial(metadata.serial)
				end
			end
			M.SetSlot(inv, item, count, metadata, slot)
		else
			if item.name:find('identification') then
				count = 1
				if next(metadata) == nil then
					metadata = {}
					metadata.type = xPlayer.name
					metadata.description = ('Sex: %s\nDate of birth: %s'):format((xPlayer.variables.sex or xPlayer.sex) and ox.locale('male') or ox.locale('female'), xPlayer.variables.dateofbirth or xPlayer.dateofbirth)
				end
			elseif item.name:find('paperbag') then
				count = 1
				metadata = {}
				metadata.container = GenerateText(3)..os.time(os.date('!*t'))
			end
			M.SetSlot(inv, item, count, metadata, slot)
		end
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
		emptySlots = emptySlots - 1
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
		local xPlayer = inv.type == 'player' and inv:player() or false
		metadata = SetMetadata(metadata)
		local slotItem = inv.items[slot] or false
		local itemSlots, totalCount = GetItemSlots(inv, item, metadata)
		if count > totalCount then count = totalCount end
		local removed, total, slots = 0, count, {}
		if slot and itemSlots[slot] then
			local newCount = M.SetSlot(inv, item, -count, metadata, slot)
			removed = count-newCount
			slots[#slots+1] = inv.items[k] or k
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
			local array = {}
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
		local itemSlots, totalCount, emptySlots = GetItemSlots(inv, item, SetMetadata(metadata))
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

TriggerEvent('ox_inventory:loadInventory', M)

exports('Inventory', function(arg)
	if arg then
		if Inventories[arg] then return Inventories[arg] else return false end
	end
	return M
end)

return M