ESX = nil
Items = {}
Usables = {}
Players = {}
Drops = {}
Inventories = {}
Datastore = {}
Shops = {}
Opened = {}
Status = {'starting', ''}


local failed = function(msg)
	Status[1], Status[2] = 'error', msg
end

local message = function(msg, colour)
	local type
	if colour == 1 then type = 'error' elseif colour == 2 then type = 'success' else colour, type = 3, 'warning' end
	print(('^%s[%s]^7 %s'):format(colour, type, msg))
end

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	if ESX == nil then failed('Unable to retrieve ESX object') end
	local OneSync = GetConvar('onesync_enabled', false) == 'true'
	local Infinity = GetConvar('onesync_enableInfinity', false) == 'true'
	if not OneSync and not Infinity then failed('Unable to initialise, OneSync is not enabled on this server')
	elseif Infinity then message('Server is running OneSync Infinity', 2) elseif OneSync then message('Server is running OneSync Legacy', 2) end
	while true do
		Citizen.Wait(125)
		if Status[1] ~= 'starting' then
			break
		end
	end
	if Status[1] == 'error' then message(Status[2], 1) return end
	while (Status[1] == 'loaded') do Citizen.Wait(125) if Status[1] == 'ready' then break end end
	message('Inventory setup is complete', 2)
	if Config.Logs and GetResourceState(Config.Logs) ~= 'started' then
		logsResource = Config.Logs
		message('Logs have been disabled, ^3`'..logsResource..'`^7 is not running', 3)
		Config.Logs = false
	end
end)

exports.ghmattimysql:ready(function()
	while GetResourceState('linden_inventory') ~= 'started' do
		Citizen.Wait(0)
	end
	if Status[1] ~= 'error' then
		local result = exports.ghmattimysql:executeSync('SELECT * FROM items', {})
		if result then
			for k, v in pairs(result) do
				Items[v.name] = {
					name = v.name,
					label = v.label,
					weight = v.weight,
					stackable = v.stackable,
					description = v.description,
					closeonuse = v.closeonuse
				}
				if ESX.UsableItemsCallbacks[v.name] ~= nil and not Config.ItemList[v.name] then Usables[v.name] = true end
				if v.name:find('WEAPON') then local AmmoType = GetAmmoType(v.name) if AmmoType then Items[v.name].ammoType = AmmoType end end
			end
			message('Created '..#(result)..' items', 2)
			Status[1] = 'loaded'
			local count = 0
			for k,v in pairs(Config.ItemList) do
				if not Items[k] then
					--print (' ('..k..', '..k..', 115, 1, 1, 1, NULL), ')
					count = count + 1
					for k, v in pairs(result) do
						Items[k] = {
							name = k,
							label = k,
							weight = 0,
							stackable = 1,
							description = 'Item not added to database',
							closeonuse = 1
						}
					end
				end
			end
			if count > 0 then message('Created '..count..' dummy items', 2) end
		else
			failed('Unable to retrieve items from the database')
		end
		if #ESX.GetPlayers() == 0 then Status[1] = 'ready' end
	end
end)

ESX.RegisterServerCallback('linden_inventory:setup', function(source, cb)
	local src = source
	local loop = 0
	while true do
		if Status[1] == 'ready' then break end
		loop = loop + 1
		if loop == 50 then return end
		Citizen.Wait(100)
	end
	local xPlayer = ESX.GetPlayerFromId(src)
	if xPlayer.get('linventory') ~= true then
		local result = exports.ghmattimysql:scalarSync('SELECT inventory FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.getIdentifier()
		})
		if result ~= nil then
			TriggerEvent('linden_inventory:setPlayerInventory', xPlayer, json.decode(result))
			while xPlayer.get('linventory') ~= true do Citizen.Wait(100) end
		else
			DropPlayer(xPlayer.source, 'there was an issue loading your inventory')
		end
	end
	Inventories[xPlayer.source].name = xPlayer.getName()
	local data = {drops = Drops, name = Inventories[xPlayer.source].name, inventory = Inventories[xPlayer.source].inventory, usables = Usables }
	cb(data)
	Citizen.Wait(100)
	updateWeight(xPlayer, true)	
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		if ESX == nil then return end
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			xPlayer.set('linventory', false)
		end
		while true do Citizen.Wait(100) if Status[1] == 'loaded' then break end end
		Status[1] = 'ready'
	elseif resourceName == logsResource then
		message('Logs have been enabled', 2)
		logsResource, Config.Logs = nil, logsResource
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		if ESX == nil or Status[1] ~= 'ready' then return end
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			local identifier = xPlayer.getIdentifier()
			local inventory = json.encode(getInventory(Inventories[xPlayer.source]))
			exports.ghmattimysql:execute('UPDATE `users` SET `inventory` = @inventory WHERE identifier = @identifier', {
				['@inventory'] = inventory,
				['@identifier'] = identifier
			})
		end
	elseif resourceName == Config.Logs then
		logsResource = Config.Logs
		message('Logs have been disabled, ^3`'..logsResource..'`^7 is not running', 3)
		Config.Logs = false
	end
end)

AddEventHandler('linden_inventory:setPlayerInventory', function(xPlayer, data)
	local invid = xPlayer.source
	Inventories[invid] = {
		id = xPlayer.source,
		identifier = xPlayer.getIdentifier(),
		type = 'Playerinv',
		slots = Config.PlayerSlots,
		maxWeight = Config.PlayerWeight,
		weight = 0,
		inventory = {}
	}
	if data and next(data) then
		for k, v in pairs(data) do
			if type(v) == 'number' then break end
			local xItem = Items[v.name]
			if xItem then
				local weight
				if xItem.ammoType then
					local ammo = {}
					ammo.type = xItem.ammoType
					ammo.count = v.metadata.ammo
					ammo.weight = Items[ammo.type].weight
					weight = xItem.weight + (ammo.weight * ammo.count)
				else weight = xItem.weight end
				if not v.metadata then v.metadata = {} end
				Inventories[invid].inventory[v.slot] = {name = v.name, label = xItem.label, weight = weight, slot = v.slot, count = v.count, description = xItem.description, metadata = v.metadata, stackable = xItem.stackable}
				if xItem.ammoType then Inventories[invid].inventory[v.slot].ammoType = xItem.ammoType end
			end
		end
	end
	xPlayer.set('linventory', true)
end)

AddEventHandler('linden_inventory:clearPlayerInventory', function(xPlayer)
	if type(xPlayer) ~= 'table' then xPlayer = ESX.GetPlayerFromId(xPlayer) end
	if xPlayer then
		Inventories[xPlayer.source].inventory = {}
		Inventories[xPlayer.source].weight = 0
		local accounts = {'money', 'black_money'}
		for i=1, #accounts do
			local account = xPlayer.getAccount(accounts[i])
			account.money = 0
			xPlayer.setAccount(account)
			xPlayer.triggerEvent('esx:setAccountMoney', account)
		end
		if Opened[xPlayer.source] then TriggerClientEvent('linden_inventory:closeInventory', Opened[xPlayer.source].invid)
		TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source])
		end
	end
end)

AddEventHandler('linden_inventory:confiscatePlayerInventory', function(xPlayer)
	if type(xPlayer) ~= 'table' then xPlayer = ESX.GetPlayerFromId(xPlayer) end
	if xPlayer.get('linventory') then
		local inventory = json.encode(getPlayerInventory(xPlayer))
		exports.ghmattimysql:execute('REPLACE INTO linden_inventory (name, data) VALUES (@name, @data)', {
			['@name'] = xPlayer.getIdentifier(),
			['@data'] = inventory
		}, function (rowsChanged)
			TriggerEvent('linden_inventory:clearPlayerInventory', xPlayer)
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Your items have been confiscated' })
		end)
	end
end)

AddEventHandler('linden_inventory:recoverPlayerInventory', function(xPlayer)
	if type(xPlayer) ~= 'table' then xPlayer = ESX.GetPlayerFromId(xPlayer) end
	if xPlayer.get('linventory') then
		local result = exports.ghmattimysql:scalarSync('SELECT data FROM linden_inventory WHERE name = @name', { ['@name'] = xPlayer.getIdentifier() })
		if result ~= nil then
			exports.ghmattimysql:execute('DELETE FROM linden_inventory WHERE name = @name', { ['@name'] = xPlayer.getIdentifier() })
			local Inventory = json.decode(result)
			for k,v in pairs(Inventory) do
				if v.metadata == nil then v.metadata = {} end
				Inventories[xPlayer.source].inventory[v.slot] = {name = v.name ,label = Items[v.name].label, weight = Items[v.name].weight, slot = v.slot, count = v.count, description = Items[v.name].description, metadata = v.metadata, stackable = Items[v.name].stackable}
			end
			updateWeight(xPlayer)	
			if Opened[xPlayer.source] then TriggerClientEvent('linden_inventory:closeInventory', Opened[xPlayer.source].invid)
				TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source])
			end
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Your items have been returned' })
		end
	end
end)


RegisterNetEvent('linden_inventory:openInventory')
AddEventHandler('linden_inventory:openInventory', function(data, player)
	if data then
		local xPlayer
		if player then xPlayer = player else xPlayer = ESX.GetPlayerFromId(source) end
		if data.type ~= 'drop' and Opened[xPlayer.source] then return end
		if data.type == 'drop' then
			local invid = data.drop
			if Drops[invid] ~= nil and CheckOpenable(xPlayer, Drops[invid].name, Drops[invid].coords) then
				Opened[xPlayer.source] = {invid = invid, type = 'drop'}
				TriggerClientEvent('linden_inventory:openInventory', xPlayer.source, Inventories[xPlayer.source], Drops[invid])
			else
				Opened[xPlayer.source] = {invid = xPlayer.source, type = 'Playerinv'}
				TriggerClientEvent('linden_inventory:openInventory',  xPlayer.source, Inventories[xPlayer.source])
			end
		elseif data.type == 'shop' then
			local id = data.id
			local shop = Config.Shops[id]
			Shops[id] = {
				id = id,
				type = 'shop',
				name = shop.name or shop.type.name,
				coords = shop.coords,
				job = shop.job,
				inventory = SetupShopItems(id),
				slots = #shop.store.inventory,
				currency = shop.currency
			}
			if (not Shops[id].job or Shops[id].job == xPlayer.job.name) then
				local srcCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
				if #(shop.coords - srcCoords) <= 2 then
					Opened[xPlayer.source] = {invid = xPlayer.source, type = 'Playerinv'}
					TriggerClientEvent('linden_inventory:openInventory', xPlayer.source, Inventories[xPlayer.source], Shops[id])
				end
			end
		elseif data.type == 'glovebox' or data.type == 'trunk' or (data.type == 'stash' and not data.owner) then
			local id = data.id
			if not data.maxWeight then data.maxWeight = data.slots*8000 end
			Inventories[id] = {
				name = id,
				type = data.type,
				slots = data.slots,
				coords = data.coords,
				maxWeight = data.maxWeight,
				inventory = GetItems(id, data.type)
			}
			if CheckOpenable(xPlayer, id, data.coords) then
				Opened[xPlayer.source] = {invid = id, type = data.type}
				TriggerClientEvent('linden_inventory:openInventory', xPlayer.source, Inventories[xPlayer.source], Inventories[id])
			end
		elseif data.owner then
			if data.owner == true then data.owner = xPlayer.identifier end
			local id = data.id..'-'..data.owner
			if not data.maxWeight then data.maxWeight = data.slots*8000 end
			Inventories[id] = {
				name = id,
				owner = data.owner,
				type = data.type,
				slots = data.slots,
				coords = data.coords,
				maxWeight = data.maxWeight,
				inventory = GetItems(id, data.type, data.owner)
			}
			if CheckOpenable(xPlayer, id, data.coords) then
				Opened[xPlayer.source] = {invid = id, type = data.type}
				TriggerClientEvent('linden_inventory:openInventory', xPlayer.source, Inventories[xPlayer.source], Inventories[id])
			end
		end
	end
end)

RegisterNetEvent('linden_inventory:openTargetInventory')
AddEventHandler('linden_inventory:openTargetInventory', function(targetId)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(targetId)
	if source ~= targetId and xTarget and xPlayer then
		if CheckOpenable(xPlayer, xTarget.source, GetEntityCoords(GetPlayerPed(targetId))) then
			local TargetPlayer = Inventories[xTarget.source]
			local data = {
				id = xTarget.source,
				name = 'Player '..xTarget.source,
				type = 'TargetPlayer',
				slots = TargetPlayer.slots,
				maxWeight = TargetPlayer.maxWeight,
				weight = TargetPlayer.weight,
				inventory = TargetPlayer.inventory
			}
			TriggerClientEvent('linden_inventory:openInventory',  xPlayer.source, Inventories[xPlayer.source], data)
			Opened[xPlayer.source] = {invid = xTarget.source, type = data.type}
			Opened[xTarget.source] = {invid = xPlayer.source, type = data.type}
		end
	end
end)

RegisterNetEvent('linden_inventory:buyItem')
AddEventHandler('linden_inventory:buyItem', function(info)
	local xPlayer = ESX.GetPlayerFromId(source)
	if info.count > 0 then
		local data = info.data
		local location = info.location
		local money, currency, item = nil, nil, {}
		local count = info.count
		local checkShop = Config.Shops[location].store.inventory[data.slot]

		if checkShop.grade and checkShop.grade > xPlayer.job.grade then
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'You are not authorised to purchase this item' })
			return
		end
	
		if Config.WeaponsLicense and checkShop.license then
			local hasLicense = exports.ghmattimysql:scalarSync('SELECT * FROM user_licenses WHERE type = @type AND owner = @owner', {
				['@type'] = checkShop.license,
				['@owner'] = xPlayer.identifier
			})
			if not hasLicense then
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'You are not licensed to purchase this item' })
				return
			end
		end

		if data.name:find('WEAPON_') then count = 1 end

		local shopCurrency = Config.Shops[location].currency
		data.price = data.price * count
		if not shopCurrency or shopCurrency == 'bank' then
			currency = 'bank'
			money = xPlayer.getAccount('bank').money
			if not shopCurrency and money < data.price then
				item.name = 'money'
				currency = 'Money'
				money = xPlayer.getInventoryItem(item.name).count
			end
		else
			item = Items[shopCurrency]
			currency = item.label
			money = xPlayer.getInventoryItem(item.name).count
		end

		if checkShop.name ~= data.name then
			TriggerBanEvent(xPlayer, 'tried to buy '..data.name..' but slot contains '..checkShop.name)
		elseif (checkShop.price * count) ~= data.price then
			TriggerBanEvent(xPlayer, 'tried to buy '..ESX.Math.GroupDigits(count)..'x '..data.name..' for '..ESX.Math.GroupDigits(data.price)..' '..currency..'(actual cost is '..ESX.Math.GroupDigits(ESX.Round(checkShop.price * count))..')')
		end

		if canCarryItem(xPlayer, data.name, count) then
			if data.price then
				if money >= data.price then
					local shopName = Config.Shops[location].name or Config.Shops[location].type.name
					local cost
					if currency == 'bank' or currency:find('money') then cost = '$'..ESX.Math.GroupDigits(data.price)..' '..currency else cost = ESX.Math.GroupDigits(data.price)..'x '..currency end
					if currency == 'bank' then
						xPlayer.removeAccountMoney('bank', data.price)
					else
						removeInventoryItem(xPlayer, item.name, data.price)
					end
					addInventoryItem(xPlayer, data.name, count, data.metadata, false)
					if Config.Logs then exports.linden_logs:log(xPlayer, false, ('bought %sx %s from %s for %s'):format(ESX.Math.GroupDigits(count), data.label, shopName, cost), 'items') end
				else
					local missing
					if currency == 'bank' or item.name == 'money' then
						missing = '$'..ESX.Math.GroupDigits(ESX.Round(data.price - money)).. ' '..currency
					elseif item.name == 'black_money' then
						missing = '$'..ESX.Math.GroupDigits(ESX.Round(data.price - money)).. ' '..string.lower(item.label)
					else
						missing = ''..ESX.Math.GroupDigits(ESX.Round(data.price - money))..' '..currency
					end
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'You can not afford that (missing '..missing..')' })
				end
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'You can not carry this item' })
		end
	end
end)

RegisterNetEvent('linden_inventory:saveInventoryData')
AddEventHandler('linden_inventory:saveInventoryData', function(data)
	local xPlayer, xTarget, targetId = ESX.GetPlayerFromId(source), {}
	if data then
		local playerinv, invid, invid2 = xPlayer.source
		if data.frominv == data.toinv then
			if data.frominv == 'Playerinv' then
				invid = playerinv
			elseif data.frominv == 'TargetPlayer' then
				targetId = string.gsub(data.invid, 'Player ', '')
				xTarget = ESX.GetPlayerFromId(tonumber(targetId))
				invid = xTarget.source
			else
				invid = data.invid
			end
			if data.frominv == nil or data.frominv == 'drop' or data.toinv == 'drop' then
				if data.type == 'swap' then
					if ValidateItem(data.type, xPlayer, Drops[invid].inventory[data.fromSlot], Drops[invid].inventory[data.toSlot], data.fromItem, data.toItem) == true then
						Drops[invid].inventory[data.toSlot] = {name = data.toItem.name, label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = Items[data.toItem.name].closeonuse}
						Drops[invid].inventory[data.fromSlot] = {name = data.fromItem.name, label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = Items[data.fromItem.name].closeonuse}
					end
				elseif data.type == 'freeslot' then
					if ValidateItem(data.type, xPlayer, Drops[invid].inventory[data.emptyslot], Drops[invid].inventory[data.toSlot], data.item, data.item) == true then
						Drops[invid].inventory[data.emptyslot] = nil
						Drops[invid].inventory[data.toSlot] = {name = data.item.name, label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = Items[data.item.name].closeonuse}
					end
				elseif data.type == 'split' then
					if ValidateItem(data.type, xPlayer, Drops[invid].inventory[data.fromSlot], Drops[invid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) == true then
						Drops[invid].inventory[data.fromSlot] = {name = data.oldslotItem.name, label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = Items[data.oldslotItem.name].closeonuse}
						Drops[invid].inventory[data.toSlot] = {name = data.newslotItem.name, label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = Items[data.newslotItem.name].closeonuse}
					end
				end
			else		
				if data.type == 'swap' then
					if ValidateItem(data.type, xPlayer, Inventories[invid].inventory[data.fromSlot], Inventories[invid].inventory[data.toSlot], data.fromItem, data.toItem) == true then
						Inventories[invid].inventory[data.toSlot] = {name = data.toItem.name, label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = Items[data.toItem.name].closeonuse}
						Inventories[invid].inventory[data.fromSlot] = {name = data.fromItem.name, label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = Items[data.fromItem.name].closeonuse}
						if invid ~= xPlayer.source and invid ~= xTarget.source then Inventories[invid].changed = true end
					end
				elseif data.type == 'freeslot' then
					if ValidateItem(data.type, xPlayer, Inventories[invid].inventory[data.emptyslot], Inventories[invid].inventory[data.toSlot], data.item, data.item) == true then
						Inventories[invid].inventory[data.emptyslot] = nil
						Inventories[invid].inventory[data.toSlot] = {name = data.item.name, label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = Items[data.item.name].closeonuse}
						if invid ~= xPlayer.source and invid ~= xTarget.source then Inventories[invid].changed = true end
					end
				elseif data.type == 'split' then
					if ValidateItem(data.type, xPlayer, Inventories[invid].inventory[data.fromSlot], Inventories[invid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) == true then
						Inventories[invid].inventory[data.fromSlot] = {name = data.oldslotItem.name, label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = Items[data.oldslotItem.name].closeonuse}
						Inventories[invid].inventory[data.toSlot] = {name = data.newslotItem.name, label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = Items[data.newslotItem.name].closeonuse}
						if invid ~= xPlayer.source and invid ~= xTarget.source then Inventories[invid].changed = true end
					end
				end
			end
		elseif data.frominv ~= data.toinv then
			if data.toinv == 'drop' and not Drops[data.invid] then
				CreateNewDrop(xPlayer, data)
				return
			end
			if data.frominv == 'Playerinv' then
				if data.toinv == 'TargetPlayer' then
					targetId = string.gsub(data.invid, 'Player ', '')
					xTarget = ESX.GetPlayerFromId(tonumber(targetId))
					invid = xTarget.source
				else
					invid = data.invid
				end
				invid2 = xPlayer.source
			elseif data.toinv == 'Playerinv' then
				if data.frominv == 'TargetPlayer' then
					targetId = string.gsub(data.invid2, 'Player ', '')
					xTarget = ESX.GetPlayerFromId(tonumber(targetId))
					invid2 = xTarget.source
				else
					invid2 = data.invid2
				end
				invid = xPlayer.source
			end
			if data.frominv == nil or data.frominv == 'drop' or data.toinv == 'drop' then
				local dropid
				if data.frominv == 'Playerinv' then
					dropid = invid
					if data.type == 'swap' then
						if ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.fromSlot], Drops[dropid].inventory[data.toSlot], data.fromItem, data.toItem) == true then
							ItemNotify(xPlayer, data.toItem, data.toItem.count, data.fromSlot, 'Removed')
							ItemNotify(xPlayer, data.fromItem, data.fromItem.count, data.toSlot, 'Added')
							Drops[dropid].inventory[data.toSlot] = {name = data.toItem.name, label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = Items[data.toItem.name].closeonuse}
							Inventories[invid2].inventory[data.fromSlot] = {name = data.fromItem.name, label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = Items[data.fromItem.name].closeonuse}
							if Config.Logs then
								exports.linden_logs:log(xPlayer, false, 'has swapped '..data.toItem.count..'x '..data.toItem.name..' for '..data.fromItem.count..'x '..data.fromItem.name..' in drop-'..dropid, 'items')
							end
						end
					elseif data.type == 'freeslot' then
						if ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.emptyslot], Drops[dropid].inventory[data.toSlot], data.item, data.item) == true then
							local count = Inventories[invid2].inventory[data.emptyslot].count
							ItemNotify(xPlayer, data.item, count, data.emptyslot, 'Removed')
							Inventories[invid2].inventory[data.emptyslot] = nil
							Drops[dropid].inventory[data.toSlot] = {name = data.item.name, label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = Items[data.item.name].closeonuse}
							if Config.Logs then
								exports.linden_logs:log(xPlayer, false, 'has stored '..count..'x '..data.item.name..' in drop-'..dropid, 'items')
							end
						end
					elseif data.type == 'split' then
						if ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.fromSlot], Drops[dropid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) == true then
							ItemNotify(xPlayer, data.newslotItem, data.newslotItem.count, data.fromSlot, 'Removed')
							Inventories[invid2].inventory[data.fromSlot] = {name = data.oldslotItem.name, label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = Items[data.oldslotItem.name].closeonuse}
							Drops[dropid].inventory[data.toSlot] = {name = data.newslotItem.name, label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = Items[data.newslotItem.name].closeonuse}
							if Config.Logs then
								exports.linden_logs:log(xPlayer, false, 'has stored '..data.newslotItem.count..'x '..data.newslotItem.name..' in drop-'..dropid, 'items')
							end
						end
					end
				elseif data.toinv == 'Playerinv' then
					dropid = invid2
					if data.type == 'swap' then
						if ValidateItem(data.type, xPlayer, Drops[dropid].inventory[data.fromSlot], Inventories[invid].inventory[data.toSlot], data.fromItem, data.toItem) == true then
							ItemNotify(xPlayer, data.toItem, data.toItem.count, data.toSlot, 'Added')
							ItemNotify(xPlayer, data.fromItem, data.fromItem.count, data.fromSlot, 'Removed')
							Inventories[invid].inventory[data.toSlot] = {name = data.toItem.name, label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = Items[data.toItem.name].closeonuse}
							Drops[dropid].inventory[data.fromSlot] = {name = data.fromItem.name, label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = Items[data.fromItem.name].closeonuse}
							if Config.Logs then
								exports.linden_logs:log(xPlayer, false, 'has swapped '..data.fromItem.count..'x '..data.fromItem.name..' for '..data.toItem.count..'x '..data.toItem.name.. 'in drop-'..dropid, 'items')
							end
						end
					elseif data.type == 'freeslot' then
						if ValidateItem(data.type, xPlayer, Drops[dropid].inventory[data.emptyslot], Inventories[invid].inventory[data.toSlot], data.item, data.item) == true then
							local count = Drops[dropid].inventory[data.emptyslot].count
							ItemNotify(xPlayer, data.item, count, data.toSlot, 'Added')
							Drops[dropid].inventory[data.emptyslot] = nil
							Inventories[invid].inventory[data.toSlot] = {name = data.item.name, label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = Items[data.item.name].closeonuse}
							if Config.Logs then
								exports.linden_logs:log(xPlayer, false, 'has taken '..count..'x '..data.item.name..' from drop-'..dropid, 'items')
							end
						end
					elseif data.type == 'split' then
						if ValidateItem(data.type, xPlayer, Drops[dropid].inventory[data.fromSlot], Inventories[invid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) == true then
							ItemNotify(xPlayer, data.newslotItem, data.toSlot, false, 'Added')
							Drops[dropid].inventory[data.fromSlot] = {name = data.oldslotItem.name, label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = Items[data.oldslotItem.name].closeonuse}
							Inventories[invid].inventory[data.toSlot] = {name = data.newslotItem.name, label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = Items[data.newslotItem.name].closeonuse}
							if Config.Logs then
								exports.linden_logs:log(xPlayer, false, 'has taken '..data.newslotItem.count..'x '..data.newslotItem.name..' from drop-'..dropid, 'items')
							end
						end
					end
				end
				if next(Drops[dropid].inventory) == nil then
					TriggerClientEvent('linden_inventory:removeDrop', -1, dropid, xPlayer.source)
					Drops[dropid] = nil
				end
			else
				if data.type == 'swap' then
					if ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.fromSlot], Inventories[invid].inventory[data.toSlot], data.fromItem, data.toItem) == true then
						if invid == xPlayer.source then
							ItemNotify(xPlayer, data.toItem, data.toItem.count, data.toSlot, 'Added')
							ItemNotify(xPlayer, data.fromItem, data.fromItem.count, data.fromSlot, 'Removed')
							if targetId then
								ItemNotify(xTarget, data.toItem, data.toItem.count, data.toSlot, 'Removed')
								ItemNotify(xTarget, data.fromItem, data.fromItem.count, data.fromSlot, 'Added')
								if Config.Logs then
									exports.linden_logs:log(xPlayer, xTarget, 'has given '..data.fromItem.count..'x '..data.fromItem.name..' to', 'items')
									exports.linden_logs:log(xPlayer, xTarget, 'has taken '..data.toItem.count..'x '..data.toItem.name..' from', 'items')
								end
							else
								if Config.Logs then
									exports.linden_logs:log(xPlayer, false, 'has stored '..data.fromItem.count..'x '..data.fromItem.name..' in '..invid2, 'items')
									exports.linden_logs:log(xPlayer, false, 'has taken '..data.toItem.count..'x '..data.toItem.name..' from '..invid2, 'items')
								end
							end
						elseif invid2 == xPlayer.source then
							ItemNotify(xPlayer, data.toItem, data.toItem.count, data.toSlot, 'Removed')
							ItemNotify(xPlayer, data.fromItem, data.fromItem.count, data.fromSlot, 'Added')
							if targetId then
								ItemNotify(xTarget, data.toItem, data.toItem.count, data.toSlot, 'Added')
								ItemNotify(xTarget, data.fromItem, data.fromItem.count, data.fromSlot, 'Removed')
								if Config.Logs then
									exports.linden_logs:log(xPlayer, xTarget, 'has given '..data.fromItem.count..'x '..data.fromItem.name..' to', 'items')
									exports.linden_logs:log(xPlayer, xTarget, 'has taken '..data.toItem.count..'x '..data.toItem.name..' from', 'items')
								end
							else
								if Config.Logs then
									exports.linden_logs:log(xPlayer, false, 'has stored '..data.fromItem.count..'x '..data.fromItem.name..' in '..invid, 'items')
									exports.linden_logs:log(xPlayer, false, 'has taken '..data.toItem.count..'x '..data.toItem.name..' from '..invid, 'items')
								end
							end
						end
						Inventories[invid].inventory[data.toSlot] = {name = data.toItem.name, label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = Items[data.toItem.name].closeonuse}
						Inventories[invid2].inventory[data.fromSlot] = {name = data.fromItem.name, label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = Items[data.fromItem.name].closeonuse}
						if invid ~= xPlayer.source and invid ~= xTarget.source then Inventories[invid].changed = true end if invid2 ~= xPlayer.source and invid2 ~= xTarget.source then Inventories[invid2].changed = true end
					end
				elseif data.type == 'freeslot' then
					if ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.emptyslot], Inventories[invid].inventory[data.toSlot], data.item, data.item) == true then
						local count = Inventories[invid2].inventory[data.emptyslot].count
						if invid == xPlayer.source then
							ItemNotify(xPlayer, data.item, count, data.toSlot, 'Added')
							if targetId then
								ItemNotify(xTarget, data.item, count, data.emptyslot, 'Removed')
								if Config.Logs then
									exports.linden_logs:log(xPlayer, xTarget, 'has taken '..count..'x '..data.item.name..' from', 'items')
								end
							else
								if Config.Logs then
									exports.linden_logs:log(xPlayer, false, 'has taken '..count..'x '..data.item.name..' from '..invid2, 'items')
								end
							end
						elseif invid2 == xPlayer.source then
							ItemNotify(xPlayer, data.item, count, data.emptyslot, 'Removed')
							if targetId then
								ItemNotify(xTarget, data.item, count, data.toSlot, 'Added')
								if Config.Logs then
									exports.linden_logs:log(xPlayer, false, 'has given '..count..'x '..data.item.name..' to', 'items')
								end
							else
								if Config.Logs then
									exports.linden_logs:log(xPlayer, false, 'has stored '..count..'x '..data.item.name..' in '..invid, 'items')
								end
							end
						end
						Inventories[invid2].inventory[data.emptyslot] = nil
						Inventories[invid].inventory[data.toSlot] = {name = data.item.name, label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = Items[data.item.name].closeonuse}
						if invid ~= xPlayer.source and invid ~= xTarget.source then Inventories[invid].changed = true end if invid2 ~= xPlayer.source and invid2 ~= xTarget.source then Inventories[invid2].changed = true end
					end
				elseif data.type == 'split' then
					if ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.fromSlot], Inventories[invid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) == true then
						if invid == xPlayer.source then
							ItemNotify(xPlayer, data.newslotItem, data.newslotItem.count, data.toSlot, 'Added')
							if targetId then
								ItemNotify(xTarget, data.newslotItem, data.newslotItem.count, data.fromSlot, 'Removed')
								if Config.Logs then
									exports.linden_logs:log(xPlayer, xTarget, 'has taken '..data.newslotItem.count..'x '..data.newslotItem.name..' from', 'items')
								end	
							else
								if Config.Logs then
									exports.linden_logs:log(xPlayer, false, 'has taken '..data.newslotItem.count..'x '..data.newslotItem.name..' from '..invid2, 'items')
								end	
							end
						elseif invid2 == xPlayer.source then
							ItemNotify(xPlayer, data.newslotItem, data.newslotItem.count, data.fromSlot, 'Removed')
							if targetId then
								ItemNotify(xTarget, data.newslotItem, data.toSlot, false, 'Added')
								if Config.Logs then
									exports.linden_logs:log(xPlayer, xTarget, 'has given '..data.newslotItem.count..'x '..data.newslotItem.name..' to', 'items')
								end	
							else
								if Config.Logs then
									exports.linden_logs:log(xPlayer, false, 'has stored '..data.newslotItem.count..'x '..data.newslotItem.name..' in '..invid, 'items')
								end	
							end
						end
						Inventories[invid2].inventory[data.fromSlot] = {name = data.oldslotItem.name, label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = Items[data.oldslotItem.name].closeonuse}
						Inventories[invid].inventory[data.toSlot] = {name = data.newslotItem.name, label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = Items[data.newslotItem.name].closeonuse}
					end
					if invid ~= xPlayer.source and invid ~= xTarget.source then Inventories[invid].changed = true end if invid2 ~= xPlayer.source and invid2 ~= xTarget.source then Inventories[invid2].changed = true end
				end
			end
		end
	end
end)


RegisterNetEvent('linden_inventory:saveInventory')
AddEventHandler('linden_inventory:saveInventory', function(data)
	local src = source
	if Inventories[src] then
		local xPlayer = ESX.GetPlayerFromId(src)
		if data.type == 'TargetPlayer' then
			local invid = Opened[src].invid
			updateWeight(ESX.GetPlayerFromId(invid))
			Opened[invid] = nil
		elseif data.type ~= 'shop' and data.type ~= 'drop' and Inventories[data.invid] then
			if Inventories[data.invid].changed then	SaveItems(data.type, data.invid, Inventories[data.invid].owner) end
			Inventories[data.invid] = nil
			Opened[data.invid] = nil
		elseif data.invid then Opened[data.invid] = nil end
		if xPlayer then
			Opened[src] = nil
			updateWeight(xPlayer)
			TriggerClientEvent('linden_inventory:refreshInventory', src, Inventories[src])
		end
	end
end)

AddEventHandler('esx:playerDropped', function(playerid)
	local data = Opened[playerid]
	if Inventories[playerid] and data then
		if data.type == 'TargetPlayer' then
			local invid = Opened[playerid].invid
			updateWeight(ESX.GetPlayerFromId(invid))
			Opened[invid] = nil
		elseif data.type ~= 'shop' and data.type ~= 'drop' and Inventories[data.invid] and Inventories[data.invid].changed then
			SaveItems(data.type, data.invid, Inventories[data.invid].owner)
			Inventories[data.invid].changed = false
		elseif data.invid then Opened[data.invid] = nil end
		Opened[playerid] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local playerid = source
	if Inventories[playerid] then
		ESX.SetTimeout(2000, function()	
			Inventories[playerid] = nil
		end)
	end
end)

RegisterNetEvent('linden_inventory:devtool')
AddEventHandler('linden_inventory:devtool', function()
	if not IsPlayerAceAllowed(source, 'command.refresh') then
		print( ('^1[warning]^3 [%s] %s was kicked for opening nui_devtools^7'):format(source, GetPlayerName(source)) )
		if Config.Logs then xPlayer = ESX.GetPlayerFromId(source)
			exports.linden_logs:log(xPlayer, false, 'kicked for opening nui_devtools', 'kick')
		end
		DropPlayer(source, 'foxtrot-uniform-charlie-kilo')
	end
end)

RegisterNetEvent('linden_inventory:giveItem')
AddEventHandler('linden_inventory:giveItem', function(data, target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	local xItem = xPlayer.getInventoryItem(data.item.name, data.item.metadata)
	if data.amount > xItem.count then
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'You do not have enough '..data.item.label })
	else
		if canCarryItem(xTarget, data.item.name, data.amount, data.item.metadata) then
			removeInventoryItem(xPlayer, data.item.name, data.amount, data.item.metadata, data.item.slot)
			addInventoryItem(xTarget, data.item.name, data.amount, data.item.metadata)
			exports.linden_logs:log(xPlayer, xTarget, 'has given '..data.item.count..'x '..data.item.name..' to', 'items')
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'Target can not carry '..data.amount..'x '..data.item.label })
		end
	end
end)

RegisterNetEvent('linden_inventory:reloadWeapon')
AddEventHandler('linden_inventory:reloadWeapon', function(weapon)
	local xPlayer = ESX.GetPlayerFromId(source)
	local ammo = Items[weapon.ammoType]
	ammo.count = getInventoryItem(xPlayer, ammo.name).count
	if ammo.count then Inventories[xPlayer.source].inventory[weapon.slot].metadata.ammo = 0
		if ammo.count > 0 then TriggerClientEvent('linden_inventory:addAmmo', xPlayer.source, ammo) end
	end
end)

RegisterNetEvent('linden_inventory:decreaseDurability')
AddEventHandler('linden_inventory:decreaseDurability', function(slot, item, ammo, xPlayer)
	local xPlayer = xPlayer or ESX.GetPlayerFromId(source)
	local decreaseamount = 0
	if type(slot) == 'number' then
		if Inventories[xPlayer.source].inventory[slot] ~= nil then
			if Inventories[xPlayer.source].inventory[slot].metadata.durability ~= nil then
				if Inventories[xPlayer.source].inventory[slot].metadata.durability <= 0 then
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'This weapon is broken' })
					if Inventories[xPlayer.source].inventory[slot].name:find('WEAPON_FIREEXTINGUISHER') then
						removeInventoryItem(xPlayer, Inventories[xPlayer.source].inventory[slot].name, 1, false, slot)
					end
					return
				end
				if Config.DurabilityDecrease[Inventories[xPlayer.source].inventory[slot].name] == nil then
					decreaseamount = ammo / 10
				elseif Config.DurabilityDecrease[Inventories[xPlayer.source].inventory[slot].name] then
					decreaseamount = Config.DurabilityDecrease[Inventories[xPlayer.source].inventory[slot].name] * (ammo / 8)
				else
					decreaseamount = amount * (ammo / 8)
				end
				Inventories[xPlayer.source].inventory[slot].metadata.durability = Inventories[xPlayer.source].inventory[slot].metadata.durability - ESX.Round(decreaseamount, 2)
				if Inventories[xPlayer.source].inventory[slot].metadata.durability <= 0 then
					Inventories[xPlayer.source].inventory[slot].metadata.durability = 0
					Inventories[xPlayer.source].inventory[slot].metadata.ammo = 0
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'This weapon is broken' })
					TriggerClientEvent('linden_inventory:updateWeapon', xPlayer.source, Inventories[xPlayer.source].inventory[slot].metadata)
					addInventoryItem(xPlayer, Inventories[xPlayer.source].inventory[slot].ammoType, ammo)
				else
					TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source])
					TriggerClientEvent('linden_inventory:updateWeapon', xPlayer.source, Inventories[xPlayer.source].inventory[slot].metadata)
				end
			end
		end
	end
end)

RegisterNetEvent('linden_inventory:addweaponAmmo')
AddEventHandler('linden_inventory:addweaponAmmo', function(item, curAmmo, newAmmo)
	local xPlayer = ESX.GetPlayerFromId(source)
	if Inventories[xPlayer.source].inventory[item.slot] ~= nil then
		if Inventories[xPlayer.source].inventory[item.slot].metadata.ammo ~= nil then
			local ammo = Items[item.ammoType]
			local count = newAmmo
			local addweight = (count * ammo.weight)
			local removeAmmo = newAmmo - curAmmo
			Inventories[xPlayer.source].inventory[item.slot].metadata.ammo = count
			Inventories[xPlayer.source].inventory[item.slot].weight = Items[item.name].weight + addweight
			removeInventoryItem(xPlayer, ammo.name, removeAmmo)
		end
	end
end)


RegisterNetEvent('linden_inventory:updateWeapon')
AddEventHandler('linden_inventory:updateWeapon', function(item, type)
	local xPlayer = ESX.GetPlayerFromId(source)
	if Inventories[xPlayer.source].inventory[item.slot] ~= nil then
		if Inventories[xPlayer.source].inventory[item.slot].metadata.ammo ~= nil then
			local lastAmmo = Inventories[xPlayer.source].inventory[item.slot].metadata.ammo
			Inventories[xPlayer.source].inventory[item.slot].metadata = item.metadata
			if not type and item.ammoType then
				local ammo = Items[item.ammoType]
				local newAmmo = item.metadata.ammo
				local ammoDiff = lastAmmo - newAmmo
				ammo.count = Inventories[xPlayer.source].inventory[item.slot].metadata.ammo
				ammo.addweight = (ammo.count * ammo.weight)
				Inventories[xPlayer.source].inventory[item.slot].weight = Items[item.name].weight + ammo.addweight
				TriggerEvent('linden_inventory:decreaseDurability', item.slot, item.name, ammoDiff, xPlayer)
			end
			if Opened[xPlayer.source] or not ammo then TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source], Inventories[xPlayer.source].inventory[item.slot].metadata) end
			TriggerClientEvent('linden_inventory:updateWeapon', xPlayer.source, Inventories[xPlayer.source].inventory[item.slot].metadata)
		else
			if type == 'throw' then
				removeInventoryItem(xPlayer, item.name, 1, item.metadata, item.slot)
			elseif type == 'melee' then
				TriggerEvent('linden_inventory:decreaseDurability', item.slot, item.name, 1, xPlayer)
			else
				Inventories[xPlayer.source].inventory[item.slot].metadata.durability = item.metadata.durability
				if Opened[xPlayer.source] then TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source]) end
				TriggerClientEvent('linden_inventory:updateWeapon', xPlayer.source, Inventories[xPlayer.source].inventory[item.slot].metadata)
			end
		end
	end
end)

RegisterNetEvent('linden_inventory:removeItem')
AddEventHandler('linden_inventory:removeItem', function(item, count, metadata, slot)
	local xPlayer = ESX.GetPlayerFromId(source)
	removeInventoryItem(xPlayer, item, count, metadata, slot)
end)

ESX.RegisterServerCallback('linden_inventory:getItem', function(source, cb, item, metadata)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = getInventoryItem(xPlayer, item, metadata)
	cb(xItem)
end)

ESX.RegisterServerCallback('linden_inventory:getItemCount', function(source, cb, item, metadata)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = getInventoryItem(xPlayer, item, metadata)
	cb(xItem.count)
end)

ESX.RegisterServerCallback('linden_inventory:getPlayerData',function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if Inventories[xPlayer.source] then
		cb(Inventories[xPlayer.source])
	end
end)

ESX.RegisterServerCallback('linden_inventory:getOtherPlayerData',function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)
	if Inventories[xPlayer.source] then
		cb(Inventories[xPlayer.source])
	end
end)

ESX.RegisterServerCallback('linden_inventory:buyLicense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= Config.WeaponsLicensePrice then
		xPlayer.removeMoney(Config.WeaponsLicensePrice)
		TriggerEvent('esx_license:addLicense', xPlayer.source, 'weapon', function()
			cb(true)
		end)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('linden_inventory:usingItem', function(source, cb, item, slot, metadata, isESX)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = getInventoryItem(xPlayer, item, metadata, slot)
	if isESX and xItem.count > 0 then
		ESX.UseItem(xPlayer.source, xItem.name)
		cb(false)
	elseif xItem.count > 0 then
		if xItem.name:find('WEAPON_') and metadata.durability then
			if metadata.durability > 0 then TriggerClientEvent('linden_inventory:weapon', xPlayer.source, Inventories[xPlayer.source].inventory[slot])
			else TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'This weapon is broken' }) end
			cb(false)
		elseif Config.Throwable[xItem.name] then
			TriggerClientEvent('linden_inventory:weapon', xPlayer.source, Inventories[xPlayer.source].inventory[slot])
			cb(false)
		elseif xItem.name:find('ammo-') then
			TriggerClientEvent('linden_inventory:addAmmo', xPlayer.source, Inventories[xPlayer.source].inventory[slot])
			cb(false)
		else
			local cItem = Config.ItemList[xItem.name]
			if cItem then
				if not cItem.consume or xItem.count >= cItem.consume then
					cb(xItem)
					if cItem.useTime then
						ESX.SetTimeout(cItem.useTime, function()
							removeInventoryItem(xPlayer, item, cItem.consume or 1, metadata, slot)
						end)
					else removeInventoryItem(xPlayer, item, cItem.consume or 1, metadata, slot) end
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'You do not have enough '..xItem.label })
					cb(false)
				end
			end
		end
	end
end)

-- Override the default ESX commands
ESX.RegisterCommand({'giveitem', 'additem'}, 'superadmin', function(xPlayer, args, showError)
	args.playerId.addInventoryItem(ValidateString(args.item), args.count, args.type)
end, true, {help = 'give an item to a player', validate = false, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'},
	{name = 'item', help = 'item name', type = 'string'},
	{name = 'count', help = 'item count', type = 'number'},
	{name = 'type', help = 'item metadata type', type='any'}
}})

ESX.RegisterCommand('removeitem', 'superadmin', function(xPlayer, args, showError)
	args.playerId.removeInventoryItem(ValidateString(args.item), args.count, args.type)
end, true, {help = 'remove an item from a player', validate = false, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'},
	{name = 'item', help = 'item name', type = 'string'},
	{name = 'count', help = 'item count', type = 'number'},
	{name = 'type', help = 'item metadata type', type='any'}
}})

ESX.RegisterCommand({'removeinventory', 'clearinventory'}, 'superadmin', function(xPlayer, args, showError)
	TriggerEvent('linden_inventory:clearPlayerInventory', args.playerId)
end, true, {help = 'clear a player\'s inventory', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'}
}})

ESX.RegisterCommand({'giveaccountmoney', 'givemoney'}, 'superadmin', function(xPlayer, args, showError)
	local getAccount = args.playerId.getAccount(args.account)
	if getAccount then
		args.playerId.addAccountMoney(args.account, args.amount)
	else
		showError('invalid account name')
	end
end, true, {help = 'give account money', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'},
	{name = 'account', help = 'valid account name', type = 'string'},
	{name = 'amount', help = 'amount to add', type = 'number'}
}})

ESX.RegisterCommand({'removeaccountmoney', 'removemoney'}, 'superadmin', function(xPlayer, args, showError)
	local getAccount = args.playerId.getAccount(args.account)
	if getAccount.money - args.amount < 0 then args.amount = getAccount.money end
	if getAccount then
		args.playerId.removeAccountMoney(args.account, args.amount)
	else
		showError('invalid account name')
	end
end, true, {help = 'remove account money', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'},
	{name = 'account', help = 'valid account name', type = 'string'},
	{name = 'amount', help = 'amount to remove', type = 'number'}
}})

ESX.RegisterCommand({'setaccountmoney', 'setmoney'}, 'superadmin', function(xPlayer, args, showError)
	local getAccount = args.playerId.getAccount(args.account)
	if getAccount then
		args.playerId.setAccountMoney(args.account, args.amount)
	else
		showError('invalid account name')
	end
end, true, {help = 'set account money', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'},
	{name = 'account', help = 'valid account name', type = 'string'},
	{name = 'amount', help = 'amount to set', type = 'number'}
}})

OpenStash = function(xPlayer, data)
	TriggerEvent('linden_inventory:openInventory', {type = 'stash', owner = data.owner, id = data.name, slots = data.slots, coords = data.coords, job = data.job  }, xPlayer)
end
exports('OpenStash', OpenStash)

ESX.RegisterCommand('evidence', 'user', function(xPlayer, args, showError)
	if xPlayer.job.name == 'police' then
		local stash = {name = 'evidence-'..args.evidence, slots = Config.PlayerSlots, job = 'police', coords = Config.PoliceEvidence}
		OpenStash(xPlayer, stash)
	end
end, true, {help = 'open police evidence', validate = true, arguments = {
	{name = 'evidence', help = 'number', type = 'number'}
}})

ESX.RegisterCommand('clearevidence', 'user', function(xPlayer, args, showError)
	if xPlayer.job.name == 'police' and xPlayer.job.grade_name == 'boss' then
		local id = 'evidence-'..args.evidence
		Stashes[id] = nil
		exports.ghmattimysql:execute('DELETE FROM linden_inventory WHERE name = @name', {
			['@name'] = id
		})
	end
end, true, {help = 'clear police evidence', validate = true, arguments = {
	{name = 'evidence', help = 'number', type = 'number'}
}})


-- Close all inventories before restarting to be safe
RegisterCommand('closeallinv', function(source, args, rawCommand)
	if source > 0 then return end
	TriggerClientEvent("linden_inventory:closeInventory", -1)
end, true)


--Example commands
RegisterCommand('conf', function(source, args, rawCommand)
	TriggerEvent('linden_inventory:confiscatePlayerInventory', source)
end, true)

RegisterCommand('return', function(source, args, rawCommand)
	TriggerEvent('linden_inventory:recoverPlayerInventory', source)
end, true)

RegisterCommand('maxweight', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(args[1])
	if xPlayer then
		setMaxWeight(xPlayer, tonumber(args[2]))
	end
end, true)
