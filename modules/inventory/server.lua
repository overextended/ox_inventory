local M = {}
local Inventories = {}
local Function = module('utils', true)
local Items = module('items')
local metatable = setmetatable(M, {
	__call = function(self, ...)
		if #({...}) == 1 then
			local inventory = Inventories[...]
			if inventory then return inventory else return false end
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
		if inv.type == 'drop' then
			if not next(inv.items) then
				TriggerClientEvent('ox_inventory:removeDrop', -1, inv.id)
				Inventories[inv.id] = nil
			end
		else
			if inv.type ~= 'player' and inv.timeout == false then
				inv.timer()
			end
		end
	end
	inv[k] = v
end

local Get = function(inv, k)
	return Inventories[type(inv) == 'table' and inv.id or inv][k]
end

local Timer = function(inv)
	inv = Inventories[type(inv) == 'table' and inv.id or inv]
	inv.set('timeout', true)
	SetTimeout(30000, function()
		if inv.open == false then
			if inv.datastore then
				if not next(inv.items) then Inventories[inv.id] = nil end
			elseif inv.changed then M.Save(inv) else Inventories[inv.id] = nil end
		end
		if Inventories[inv.id] then inv.set('timeout', false) end
	end)
end

local GetPlayer = function(inv)
	return ESX.GetPlayerFromId(inv.id)
end

local Minimal = function(inv)
	inv = Inventories[type(inv) == 'table' and inv.id or inv]
	local inventory, count = {}, 0
	for k, v in pairs(inv.id) do
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

M.SyncInventory = function(xPlayer, inv, items)
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
		if v.metadata then weight = weight + v.metadata.weight or 0 end
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
			name = t[2] or id,
			type = t[3],
			slots = t[4],
			weight = t[5],
			maxWeight = t[6],
			owner = t[7],
			items = t[8] or {},
			open = false,
			set = Set,
			get = Get,
			timer = Timer,
			minimal = Minimal
		}

		if self.type == 'player' then self.player = GetPlayer
		else self.changed = false
		self.timeout = false end
		
		Inventories[self.id] = self
	end
	return
end

M.Save = function(inv)
	print('saving', inv.id)
	inv = Inventories[type(inv) == 'table' and inv.id or inv]
	if inv.owner then
		if inv.type == 'player' then
			exports.ghmattimysql:execute('UPDATE users SET inventory = ? WHERE identifier = ?', {
				json.encode(Minimal(inv)), inv.owner
			})
		elseif Vehicle[inv.type] then
			local plate = inv.id:match("-(.*)")
			if Config.TrimPlate then plate = string.strtrim(plate) end
			exports.ghmattimysql:scalar('SELECT 1 from owned_vehicles WHERE plate = ?', {
				plate
			}, function(result)
				if result then
					exports.ghmattimysql:execute('INSERT INTO owned_vehicles (@type) VALUES (@inventory) ON DUPLICATE KEY UPDATE @type = @inventory', {
						['@type'] = inv.type,
						['@inventory'] = json.encode(Minimal(inv))
					})
				end
			end)
		else
			exports.ghmattimysql:execute('INSERT INTO linden_inventory (name, data, owner) VALUES (@name, @data, @owner) ON DUPLICATE KEY UPDATE data = @data', {
				['@name'] = inv.id,
				['@data'] = json.encode(Minimal(inv)),
				['@owner'] = ''
			})
		end
	else
		exports.ghmattimysql:execute('INSERT INTO linden_inventory (name, data, owner) VALUES (@name, @data, @owner) ON DUPLICATE KEY UPDATE data = @data', {
			['@name'] = inv.id,
			['@data'] = json.encode(Minimal(inv)),
			['@owner'] = ''
		})
	end
	Inventories[inv.id] = nil
end

M.Load = function(id, inv, owner)
	local returnData, result = {}
	local isVehicle = Vehicle[inv]
	if id and inv then
		if isVehicle then
			local plate = id:match("-(.*)")
			if Config.TrimPlate then plate = string.strtrim(plate) end
			local vehicle = exports.ghmattimysql:executeSync('SELECT owner, plate, trunk, glovebox FROM owned_vehicles WHERE plate = ?', {
				plate
			})
			if vehicle[1] then
				result = vehicle
			else
				if Config.RandomLoot then result = GenerateDatastore(id, inv) else result = {} end
			end
		elseif owner then
			result = exports.ghmattimysql:scalarSync('SELECT data FROM linden_inventory WHERE name = ? AND owner = ?', {
				id, owner
			})
		elseif inv == 'dumpster' then
			if Config.RandomLoot then result = GenerateDatastore(id, inv) else result = {} end
		else
			result = exports.ghmattimysql:scalarSync('SELECT data FROM linden_inventory WHERE name = ?', {
				id
			})
		end
	end

	if result then
		local Inventory
		if isVehicle then Inventory = json.decode(result[1].data)
		else Inventory = json.decode(result) end
		for k, v in pairs(Inventory) do
			local item = Items(v.name)
			if item then
				returnData[v.slot] = {name = item.name, label = item.label, weight = M.SlotWeight(item, v), slot = v.slot, count = v.count, description = item.description, metadata = v.metadata, stack = item.stack, close = item.close}
			end
		end
	end
	return returnData
end

M.GetItem = function(inv, item, metadata)
	local item = Items(item)
	if item then item = table.clone(item)
		local inv, count = Inventories[type(inv) == 'table' and inv.id or inv].items, 0
		if inventory then
			metadata = not metadata and false or type(metadata) == 'string' and {type=metadata} or metadata
			for k, v in pairs(inv) do
				if not metadata or Utils.TableContains(v.metadata or {}, metadata) then
					count = count + v.count
				end
			end
		end
		if metadata then item.metadata = metadata end
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
			local inv, toSlot = inv.items
			for i=1, Config.PlayerSlots do
				local slotItem = inv[i]
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
					metadata.description = ('Sex: %s\nDate of birth: %s'):format((xPlayer.variables.sex or xPlayer.sex) and _U('male') or _U('female'), xPlayer.variables.dateofbirth or xPlayer.dateofbirth)
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
			M.SyncInventory(xPlayer, inv, {[slot] = inv.items[slot]})
			TriggerClientEvent('ox_inventory:updateInventory', xPlayer.source, {{item = inv.items[slot], inventory = inv.type}}, {left=inv.weight, right=inv.open and Inventories[inv.open].weight}, item.name, count, false)
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
			M.SyncInventory(xPlayer, inv, slots)
			local array = {}
			for k, v in pairs(slots) do
				if type(v) == 'number' then
					array[k] = {item = {slot=v}, inventory = inv.type}
				else
					array[k] = {item = v, inventory = inv.type}
				end
			end
			TriggerClientEvent('ox_inventory:updateInventory', xPlayer.source, array, {left=inv.weight, right=inv.open and Inventories[inv.open].weight}, item.name, true)
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

return M