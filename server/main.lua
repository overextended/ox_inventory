local Drops, Shops = {}, {}

local Inventory = module('inventory')
local Function = module('functions', true)

CreateThread(function()
	repeat Citizen.Wait(50) until GetResourceState('ghmattimysql') == 'started'
	if ESX == nil or SetInterval == nil then return ox.error('Unable to locate dependencies - refer to the documentation') end
	local OneSync = GetConvar('onesync_enabled', false) == 'true'
	local Infinity = GetConvar('onesync_enableInfinity', false) == 'true'
	if not OneSync and not Infinity then return ox.error('OneSync is not enabled on this server - refer to the documentation')
	elseif Infinity then ox.info('Server is running OneSync Infinity') else ox.info('Server is running OneSync Legacy') end
	exports.ghmattimysql:executeSync('DELETE FROM `linden_inventory` WHERE `lastupdated` < (NOW() - INTERVAL '..Config.DBCleanup..') OR `data` = "[]"')
	local result, query = exports.ghmattimysql:executeSync('SELECT * FROM items', {})
	for i=1, #result do
		local i = result[i]
		if Items[i.name] then
			if not query then query = ox.concat("DELETE FROM items WHERE name = '"..i.name.."'")
			else query = ox.concat(query, "OR name='"..i.name.."'") end
		else
			Items[i.name] = {
				name = i.name,
				label = i.label,
				weight = i.weight,
				stack = i.stackable,
				close = i.closeonuse,
				description = i.description
			}
		end
	end
	if query then exports.ghmattimysql:execute(query, {}, function(result) if result and result.affectedRows > 0 then
		ox.info('Removed', result.affectedRows, 'items from the database') end end)
	end
	TriggerEvent('ox_inventory:itemList', Items)
	Wait(1500)
	ox.ready = true
	ox.items = count
	ESX.UsableItemsCallbacks = exports.es_extended:UsableItems()
	local count = 0 for k, v in pairs(Items) do
		if v.consume and ESX.UsableItemsCallbacks[v.name] then ESX.UsableItemsCallbacks[v.name] = nil end
		count += 1
	end
	ox.info('Inventory has fully loaded with '..count..' items')
	collectgarbage('collect') -- clean up from initialisation
	local ignore = {[0] = '?', [`WEAPON_UNARMED`] = 'unarmed', [966099553] = 'shovel'}
	while true do
		Wait(45000)
		local Players = ESX.GetPlayers()
		for i=1, #Players do
			local i = Players[i]
			if not IsPlayerAceAllowed(i, 'command.refresh') then
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
							DropPlayer(i)
						end
					else
						-- weapon doesn't exist; player may be cheating
						ox.warning(inv.name, 'is using an unknown weapon (', hash, ')')
						DropPlayer(i)
					end
				end
			end
			Wait(200)
		end
	end
end)

RegisterNetEvent('ox_inventory:requestPlayerInventory', function()
	local xPlayer, inventory = ESX.GetPlayerFromId(source), {}
	if not Inventory(source) then
		local inventory = xPlayer.getInventory(true)
		if not inventory or not next(inventory) then
			Wait(math.random(0, 1000)) -- slow down queries if resource restarts
			local result = exports.ghmattimysql:scalarSync('SELECT inventory FROM users WHERE identifier = ?', {
				xPlayer.identifier
			})
			if result then inventory = json.decode(result) end
		end
	end
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
				totalWeight += weight
				inventory[i.slot] = {name = i.name, label = item.label, weight = weight, slot = i.slot, count = i.count, description = item.description, metadata = i.metadata, stack = item.stack, close = item.close}
				if money[i.name] then money[i.name] += i.count end
				print(i.name, i.count)
			end
		end
	end
	Inventory.Create(xPlayer.source, xPlayer.name, 'player', Config.PlayerSlots, totalWeight, Config.DefaultWeight, xPlayer.identifier, inventory)
	xPlayer.syncInventory(totalWeight, Config.DefaultWeight, inventory, money)
	TriggerClientEvent('ox_inventory:setPlayerInventory', xPlayer.source, {Drops, xPlayer.name, Config.PlayerSlots, totalWeight, Config.DefaultWeight, inventory, ESX.UsableItemsCallbacks})
end)
