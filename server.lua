local Inventory = module('inventory')
local Function = module('functions', true)

RegisterNetEvent('equip', function(weapon)
	local inv = Inventory(source)
	inv.weapon = weapon
end)

CreateThread(function()
	repeat Citizen.Wait(100) until GetResourceState('ghmattimysql') == 'started'
	if ESX == nil or SetInterval == nil then return ox.error('Unable to locate dependencies - refer to the documentation') end
	local OneSync = GetConvar('onesync_enabled', false) == 'true'
	local Infinity = GetConvar('onesync_enableInfinity', false) == 'true'
	if not OneSync and not Infinity then return ox.error('OneSync is not enabled on this server - refer to the documentation')
	elseif Infinity then ox.info('Server is running OneSync Infinity') else ox.info('Server is running OneSync Legacy') end
	local items, query = exports.ghmattimysql:executeSync('SELECT * FROM items', {})
	for i=1, #items do
		local i = items[i]
		if not query then query = "DELETE FROM items WHERE name = '"..i.name.."'"
		else query = ox.concat(' ', query, "OR name='"..i.name.."'") end
		Items[i.name] = {
			name = i.name,
			label = i.label,
			weight = i.weight or 0,
			stack = i.stackable or true,
			close = i.closeonuse or true,
			description = i.description or ''
		}
	end
	if query then
		local sql = io.open(GetResourcePath(ox.name):gsub('//', '/')..'/setup/dump.sql', 'a+')
		local file = io.open(GetResourcePath(ox.name):gsub('//', '/')..'/shared/items.lua', 'a+')
		local dump, dump2 = {}, {}
		for i=1, #items do
			local i = items[i]
			table.insert(dump, "('"..i.name.."', ".."'"..i.name.."', "..i.weight.."),\n")
			table.insert(dump2, [[

Items[']]..i.name..[['] = {
	label = ']]..i.label..[[',
	weight = ]]..tonumber(i.weight)..[[,
	stack = ]]..tostring(i.stackable)..[[,
	close = ]]..tostring(i.closeonuse)..[[,
	description = ']]..tostring(i.description)..[['
}
]])
		end
		sql:write(table.concat(dump))
		file:write(table.concat(dump2))
		sql:close()
		file:close()
		exports.ghmattimysql:execute(query, {
		}, function(result)
			if result and result.affectedRows > 0 then
				ox.info('Removed', result.affectedRows, 'items from the database')
			end
		end)
	end
	TriggerEvent('ox_inventory:itemList', Items)
	Wait(1500)
	ox.ready = true
	ox.items = count
	ESX.UsableItemsCallbacks = exports.es_extended:UsableItems()
	local count = 0 for k, v in pairs(Items) do
		if v.consume and ESX.UsableItemsCallbacks[v.name] then ESX.UsableItemsCallbacks[v.name] = nil end
		count = count + 1
	end
	ox.info('Inventory has fully loaded with '..count..' items')
	exports.ghmattimysql:executeSync('DELETE FROM `linden_inventory` WHERE `lastupdated` < (NOW() - INTERVAL '..Config.DBCleanup..') OR `data` = "[]"')
	collectgarbage('collect') -- clean up from initialisation
	local ignore = {[0] = '?', [`WEAPON_UNARMED`] = 'unarmed', [966099553] = 'shovel'}
	while true do
		Wait(45000)
		local Players = ESX.GetPlayers()
		for i=1, #Players do
			local i = Players[i]
			--if not IsPlayerAceAllowed(i, 'command.refresh') then
				local inv, ped = Inventory(i), GetPlayerPed(i)
				local hash, curWeapon = GetSelectedPedWeapon(ped)
				if not ignore[hash] then
					curWeapon = Function.GetWeapon(hash)
					if curWeapon then
						local count = 0
						for k, v in pairs(inv.items) do
							if v.name == curWeapon.name then
								count = 1 break
							end
						end
						if count == 0 then
							-- does not own weapon; player may be cheating
							ox.warning(inv.name, 'is using an invalid weapon (', curWeapon.name, ')')
							--DropPlayer(i)
						end
					else
						-- weapon doesn't exist; player may be cheating
						ox.warning(inv.name, 'is using an unknown weapon (', hash, ')')
						--DropPlayer(i)
					end
				end
			--end
			Wait(200)
		end
	end
end)

RegisterNetEvent('ox_inventory:requestPlayerInventory', function()
	local xPlayer, inventory = ESX.GetPlayerFromId(source)
	Wait(math.random(0, 1000)) -- slow down queries if resource restarts
	local result = exports.ghmattimysql:scalarSync('SELECT inventory FROM users WHERE identifier = ?', {
		xPlayer.identifier
	})
	if result then inventory = json.decode(result) end
	repeat Wait(500) until ox.ready
	TriggerEvent('ox_inventory:setPlayerInventory', xPlayer, inventory)
end)

AddEventHandler('ox_inventory:setPlayerInventory', function(xPlayer, data)
	local money, inventory, totalWeight = {money=0, black_money=0}, {}, 0
	if data and next(data) then
		for i=1, #data do
			local i = data[i]
			if type(i) == 'number' then break end
			local item = Items[i.name]
			if item then
				local weight = Inventory.SlotWeight(item, i)
				totalWeight = totalWeight + weight
				inventory[i.slot] = {name = i.name, label = item.label, weight = weight, slot = i.slot, count = i.count, description = item.description, metadata = i.metadata, stack = item.stack, close = item.close}
				if money[i.name] then money[i.name] = money[i.name] + i.count end
			end
		end
	end
	Inventory.Create(xPlayer.source, xPlayer.name, 'player', Config.PlayerSlots, totalWeight, Config.DefaultWeight, xPlayer.identifier, inventory)
	xPlayer.syncInventory(totalWeight, Config.DefaultWeight, inventory, money)
	TriggerClientEvent('ox_inventory:setPlayerInventory', xPlayer.source, {Drops, xPlayer.name, Config.PlayerSlots, totalWeight, Config.DefaultWeight, inventory, ESX.UsableItemsCallbacks})
end)

ox.RegisterServerCallback('ox_inventory:openInventory', function(source, cb, inv, data) 
	local left, right = Inventory(source)
	if data then
		--Inventory.Create(data.id, data.label or data.id, inv, 20, 0, 2000, data.owner, {})
	else
		--[[if not Inventory('test') then Inventory.Create('test', 'Drop 6969', 'drop', Config.PlayerSlots, 0, Config.DefaultWeight, false, {}) end
		right = Inventory('test')
		right.open = source
		left.open = right.id]]
	end
	cb(left)
end)

ox.RegisterServerCallback('ox_inventory:swapItems', function(source, cb, data)
	if data.count > 0 then
		local playerInventory, items, ret = Inventory(source) or false, {}
		if data.toType == 'newdrop' then
			cb(0)
			return print('new drop')
		else
			local toInventory = data.toType == 'player' and playerInventory or Inventory(playerInventory.open)
			local fromInventory = data.fromType == 'player' and playerInventory or Inventory(playerInventory.open)
			local fromSlot, toSlot = fromInventory.items[data.fromSlot], toInventory.items[data.toSlot]
			if fromSlot then
				if data.count > fromSlot.count then data.count = fromSlot.count end
				
				if toSlot and toSlot.name == fromSlot.name then
					fromSlot.count = fromSlot.count - data.count
					toSlot.count = toSlot.count + data.count
				elseif toSlot and ((toSlot.name ~= fromSlot.name) or (not Function.MatchTables(toSlot.metadata, fromSlot.metadata))) then
					toSlot, fromSlot = Inventory.SwapSlots({fromInventory, toInventory}, {data.fromSlot, data.toSlot})
				elseif data.count <= fromSlot.count then
					fromSlot.count = fromSlot.count - data.count
					toSlot = Function.Copy(fromSlot)
					toSlot.count = data.count
					toSlot.slot = data.toSlot
				else
					return print('swapItems', data.fromType, data.fromSlot, 'to', data.toType, data.toSlot)
				end

				if fromSlot.count < 1 then fromSlot = nil end
				if data.fromType == 'player' then items[data.fromSlot] = fromSlot or false end
				if data.toType == 'player' then items[data.toSlot] = toSlot or false end
				if next(items) then
					ret = {weight=playerInventory.weight, items=items}
					Inventory.SyncInventory(ESX.GetPlayerFromId(source), playerInventory, items)
				end
				fromInventory.items[data.fromSlot], toInventory.items[data.toSlot] = fromSlot, toSlot
				return cb(1, ret)
			end
		end
	end
	cb(0)
end)

local ValidateString = function(item)
	item = string.lower(item)
	if item:find('weapon_') then item = string.upper(item) end
	local valid = Items[item]
	if valid then return valid.name else return ox.error('Invalid item name! '..item..' does not exist') end
end


ESX.RegisterCommand({'giveitem', 'additem'}, 'admin', function(xPlayer, args, showError)
	args.item = ValidateString(args.item)
	if args.item then Inventory.AddItem(args.player.source, args.item, args.count, args.type or {}) end
end, true, {help = 'give an item to a player', validate = false, arguments = {
	{name = 'player', help = 'player id', type = 'player'},
	{name = 'item', help = 'item name', type = 'string'},
	{name = 'count', help = 'item count', type = 'number'},
	{name = 'type', help = 'item metadata type', type='any'}
}})

ESX.RegisterCommand('removeitem', 'admin', function(xPlayer, args, showError)
	args.item = ValidateString(args.item)
	if args.item then Inventory.RemoveItem(args.player.source, args.item, args.count, args.type or {}) end
end, true, {help = 'remove an item from a player', validate = false, arguments = {
	{name = 'player', help = 'player id', type = 'player'},
	{name = 'item', help = 'item name', type = 'string'},
	{name = 'count', help = 'item count', type = 'number'},
	{name = 'type', help = 'item metadata type', type='any'}
}})