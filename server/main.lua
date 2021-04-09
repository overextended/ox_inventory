ESX = nil
Items = {}
Players = {}
PlayerInventory = {}
Drops = {}
Inventories = {}
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


if GetConvar('onesync_enableInfinity', false) ~= 'true' and GetConvar('onesync_enabled', false) ~= 'true' then
	failed('Unable to initialise, OneSync is not enabled on this server')
end

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	if ESX == nil then failed('Unable to retrieve ESX object') end
	while true do
		Citizen.Wait(125)
		if Status[1] ~= 'starting' then
			break
		end
	end
	if Status[1] == 'error' then message(Status[2], 2) return end
	while (Status[1] == 'loaded') do Citizen.Wait(125) if Status[1] == 'ready' then break end end
	message('Inventory setup is complete', 2)
end)

exports.ghmattimysql:ready(function()
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
				if v.name:find('WEAPON') then local AmmoType = GetAmmoType(v.name) if AmmoType then Items[v.name].ammoType = AmmoType end end
			end
			message('Created '..#(result)..' items', 2)
			Status[1] = 'loaded'
		else
			failed('Unable to retrieve items from the database')
		end
		if #ESX.GetPlayers() == 0 then Status[1] = 'ready' end
	end
end)

ESX.RegisterServerCallback('linden_inventory:setup',function(source, cb)
	local src = source
	local loop = 0
	while true do
		if Status[1] == 'ready' then break end
		loop = loop + 1
		if loop == 10 then return end
		Citizen.Wait(100)
	end
	local data = {drops = Drops, name = Inventories['Player-'..src].name, playerID = src }
	cb(data)
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		if ESX == nil then return end
		local xPlayers = ESX.GetPlayers()
		while true do Citizen.Wait(100) if Status[1] == 'loaded' then break end end
		local query = 'SELECT identifier, inventory FROM users WHERE'
		for i=1, #xPlayers, 1 do
			local identifier = ESX.GetPlayerFromId(xPlayers[i]).identifier
			query = query..' identifier LIKE '..identifier..' OR'
		end
		if #xPlayers > 0 then
			exports.ghmattimysql:execute(query:sub(0, -3), function(results)
				for k, v in ipairs(results) do
					local xPlayer = ESX.GetPlayerFromIdentifier(v.identifier)
					TriggerEvent('linden_inventory:setPlayerInventory', xPlayer, json.decode(v.inventory))
				end
				TriggerClientEvent('linden_inventory:forceStart', -1)
				if #xPlayers > 1 then message('Created inventories for '..#(results)..' active players', 2) else message('Created inventory for 1 active player', 2) end
				Status[1] = 'ready'
			end)
		end
	end
end)

RegisterCommand('closeallinv', function(source, args, rawCommand)
	if source then return end
	TriggerClientEvent("linden_inventory:closeInventory", -1)
end, true)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		if ESX == nil or Status[1] ~= 'ready' then return end
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			local identifier = xPlayer.identifier
			local inventory = json.encode(getInventory(Inventories['Player-'..xPlayer.source]))
			exports.ghmattimysql:execute('UPDATE `users` SET `inventory` = @inventory WHERE identifier = @identifier', {
				['@inventory'] = inventory,
				['@identifier'] = identifier
			})
		end
	end
end)

AddEventHandler('linden_inventory:setPlayerInventory', function(xPlayer, data)
	local invid = 'Player-'..xPlayer.source
	Inventories[invid] = {
		id = xPlayer.source,
		name = xPlayer.getName(),
		identifier = xPlayer.getIdentifier(),
		type = 'Playerinv',
		slots = Config.PlayerSlots,
		maxWeight = Config.PlayerWeight,
		weight = 0,
		inventory = {}
	}
	if data and next(data) then
		for k, v in pairs(data) do
			local xItem = Items[v.name]
			if xItem then
				local weight
				if v.metadata.ammo then
					local ammo = {}
					ammo.type = xItem.ammoType
					ammo.count = v.metadata.ammo
					ammo.weight = Items[ammo.type].weight
					weight = xItem.weight + (ammo.weight * ammo.count)
				else weight = xItem.weight end
				Inventories[invid].inventory[v.slot] = {name = v.name, label = xItem.label, weight = weight, slot = v.slot, count = v.count, description = xItem.description, metadata = v.metadata, stackable = xItem.stackable}
			end
		end
	end
	updateWeight(xPlayer)
end)

AddEventHandler('linden_inventory:clearPlayerInventory', function(xPlayer)
	if type(xPlayer) ~= 'table' then xPlayer = ESX.GetPlayerFromId(xPlayer) end
	for k,v in pairs(Inventories['Player-'..xPlayer.source].inventory) do
		RemovePlayerInventory(xPlayer.source, xPlayer.identifier, v.name, v.count, k, v.metadata)
	end
end)

RegisterNetEvent('linden_inventory:openInventory')
AddEventHandler('linden_inventory:openInventory',function(data, player)
	if data then
		local xPlayer
		if player then xPlayer = player else xPlayer = ESX.GetPlayerFromId(source) end
		if Opened[xPlayer.source] then
			return TriggerClientEvent('linden_inventory:closeInventory', xPlayer.source)
		end
		if data.type == 'drop' then
			if Drops[data.drop.id] ~= nil then
				Drops[data.drop.id] = {
					id = data.drop.id,
					coords = data.id.coords,
				}
				if CheckOpenable(xPlayer, data.drop.id, data.drop.coords) then
					Opened[xPlayer.source] = {invid = 'data.drop.id', type = 'drop'}
					TriggerClientEvent('linden_inventory:openInventory', xPlayer.source, Inventories['Player-'..xPlayer.source], Drops[id])
				end
			else
				Opened[xPlayer.source] = {invid = xPlayer.source, type = 'Playerinv'}
				TriggerClientEvent('linden_inventory:openInventory',  xPlayer.source, Inventories['Player-'..xPlayer.source])
			end
		elseif data.type == 'shop' then
			local id = data.id
			local shop = Config.Shops[id]
			Shops[id] = {
				id = id,
				type = 'shop',
				name = shop.name,
				coords = shop.coords,
				job = shop.job,
				inventory = SetupShopItems(id),
				slots = #shop.store.inventory + 1,
				currency = shop.currency
			}
			if (not Shops[id].job or Shops[id].job == xPlayer.job.name) then
				local srcCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
				if #(shop.coords - srcCoords) <= 2 then
					Opened[xPlayer.source] = {invid = xPlayer.source, type = 'Playerinv'}
					TriggerClientEvent('linden_inventory:openInventory', xPlayer.source, Inventories['Player-'..xPlayer.source], Shops[id])
				end
			end
		elseif data.type == 'glovebox' or data.type == 'trunk' or data.type == 'stash' then
			local id = data.id
			Inventories[id] = {
				name = id,
				type = data.type,
				slots = data.slots,
				coords = data.coords,
				inventory = GetItems(id)
			}
			if CheckOpenable(xPlayer, id, data.coords) then
				Opened[xPlayer.source] = {invid = id, type = data.type}
				TriggerClientEvent('linden_inventory:openInventory', xPlayer.source, Inventories['Player-'..xPlayer.source], Inventories[id])
			end
		end
	end
end)

RegisterNetEvent('linden_inventory:openTargetInventory')
AddEventHandler('linden_inventory:openTargetInventory',function(targetId)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(targetId)
	if source == TargetId then tTarget = nil end
	if xTarget and xPlayer then
		if CheckOpenable(source, 'Player'..targetId, GetEntityCoords(GetPlayerPed(targetId))) then
			local data = {}
			data.name = 'Player'..targetId
			data.type = 'TargetPlayer'
			data.slots = Config.PlayerSlots
			data.inventory = Inventories[xTarget.source]
			if Opened[xTarget.source] then TriggerClientEvent('linden_inventory:closeInventory', xTarget.source) end
			TriggerClientEvent('linden_inventory:openInventory', xPlayer.source, Inventories['Player-'..xPlayer.source], data)
		end
	end
end)

RegisterNetEvent('linden_inventory:buyItem')
AddEventHandler('linden_inventory:buyItem', function(info)
	local xPlayer = ESX.GetPlayerFromId(source)
	local data = info.data
	local location = info.location
	local money, currency, item = nil, nil, {}
	if info.count ~= nil then info.count = tonumber(info.count) else info.count = 0 end
	local count = ESX.Round(info.count)
	local checkShop = Config.Shops[location].store.inventory[data.slot]

	if checkShop.grade and checkShop.grade > xPlayer.job.grade then
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'You are not authorised to purchase this item' })
		return
	end

	if count > 0 then
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
					local cost
					if currency == 'bank' or currency:find('money') then cost = '$'..ESX.Math.GroupDigits(data.price)..' currency' else cost = ESX.Math.GroupDigits(data.price)..'x '..currency end
					if currency == 'bank' then
						xPlayer.removeAccountMoney('bank', data.price)
					else
						RemovePlayerInventory(xPlayer, item.name, data.price)
					end
					AddPlayerInventory(xPlayer, data.name, count, data.metadata, nil)
					if Config.Logs then exports.linden_logs:log(xPlayer.source, ('%s (%s) bought %sx %s from %s for %s'):format(xPlayer.name, xPlayer.identifier, ESX.Math.GroupDigits(count), data.label, Config.Shops[location].name, cost), 'test') end
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
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'You must select an amount to buy' })
	end
end)

RegisterNetEvent('linden_inventory:saveInventoryData')
AddEventHandler('linden_inventory:saveInventoryData',function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	if data then
		local inv = {['stash']=true, ['trunk']=true, ['glovebox']=true, ['drop']=true, ['TargetPlayer']=true}
		local playerinv, invid = 'Player-'..xPlayer.source
		if data.frominv == data.toinv then
			if data.frominv == 'Playerinv' then
				invid = playerinv
			elseif data.frominv == 'TargetPlayer' then
				local targetId = string.gsub(data.invid, 'Player', '')
				local xTarget = ESX.GetPlayerFromId(playerId)
				invid = 'Player-'..xTarget.source
			elseif inv[data.frominv] then
				invid = data.invid
			end
			if Inventories[invid] then
				if data.frominv == 'drop' and not Drops[invid] then TriggerClientEvent('linden_inventory:removeDrop', xPlayer.source, invid) return end
				if data.type == 'swap' then
					if not ValidateItem(data.type, xPlayer, Inventories[invid].inventory[data.fromSlot], Inventories[invid].inventory[data.toSlot], data.fromItem, data.toItem) then return end
					Inventories[invid].inventory[data.toSlot] = {name = data.toItem.name, label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = Items[data.toItem.name].closeonuse}
					Inventories[invid].inventory[data.fromSlot] = {name = data.fromItem.name, label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = Items[data.fromItem.name].closeonuse}
				elseif data.type == 'freeslot' then
					if not ValidateItem(data.type, xPlayer, Inventories[invid].inventory[data.emptyslot], Inventories[invid].inventory[data.toSlot], data.item, data.item) then return end
					Inventories[invid].inventory[data.emptyslot] = nil
					Inventories[invid].inventory[data.toSlot] = {name = data.item.name, label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = Items[data.item.name].closeonuse}
				elseif data.type == 'split' then
					if not ValidateItem(data.type, xPlayer, Inventories[invid].inventory[data.fromSlot], Inventories[invid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) then return end
					Inventories[invid].inventory[data.fromSlot] = {name = data.oldslotItem.name, label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = Items[data.oldslotItem.name].closeonuse}
					Inventories[invid].inventory[data.toSlot] = {name = data.newslotItem.name, label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = Items[data.newslotItem.name].closeonuse}
				end
				Inventories[invid].changed = true
			else
				if not Inventories[invid] then TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories['Player-'..xPlayer.source]) return end
			end
		elseif data.frominv ~= data.toinv then
			if data.frominv == 'Playerinv' and inv[data.toinv] then
				playerinv = 'Player-'..xPlayer.source
				if data.frominv == 'Playerinv' then
					invid = data.invid
					invid2 = playerinv
				elseif data.frominv == 'TargetPlayer' then
					local targetId = string.gsub(data.invid, 'Player', '')
					local xTarget = ESX.GetPlayerFromId(playerId)
					invid = 'Player-'..xTarget.source
					invid2 = playerinv
				elseif inv[data.frominv] then
					invid = data.invid
					invid2 = playerinv
				end
			elseif data.toinv == 'Playerinv' and inv[data.frominv] then
				playerinv = 'Player-'..xPlayer.source
				if data.to == 'Playerinv' then
					invid = playerinv
					invid2 = data.invid2
				elseif data.frominv == 'TargetPlayer' then
					local targetId = string.gsub(data.invid2, 'Player', '')
					local xTarget = ESX.GetPlayerFromId(playerId)
					invid = playerinv
					invid2 = 'Player-'..xTarget.source
				elseif inv[data.frominv] then
					invid = playerinv
					invid2 = data.invid2
				end
			end
			if not Inventories[invid] then TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories['Player-'..xPlayer.source]) return end
			if data.type == 'swap' then
				if not ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.fromSlot], Inventories[invid].inventory[data.toSlot], data.fromItem, data.toItem) then return end
				Inventories[invid].inventory[data.toSlot] = {name = data.toItem.name, label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = Items[data.toItem.name].closeonuse}
				Inventories[invid2].inventory[data.fromSlot] = {name = data.fromItem.name, label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = Items[data.fromItem.name].closeonuse}
				ItemNotify(xPlayer, data.toItem.name, data.toItem.count, 'Removed', invid)
				ItemNotify(xPlayer, data.fromItem.name, data.fromItem.count, 'Added', invid)
			elseif data.type == 'freeslot' then
				if not ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.emptyslot], Inventories[invid].inventory[data.toSlot], data.item, data.item) then return end
				local count = Inventories[invid2].inventory[data.emptyslot].count
				Inventories[invid2].inventory[data.emptyslot] = nil
				Inventories[invid].inventory[data.toSlot] = {name = data.item.name, label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = Items[data.item.name].closeonuse}
				ItemNotify(xPlayer, data.item.name, count, 'Removed', invid)
			elseif data.type == 'split' then
				if not ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.fromSlot], Inventories[invid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) then return end
				Inventories[invid2].inventory[data.fromSlot] = {name = data.oldslotItem.name, label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = Items[data.oldslotItem.name].closeonuse}
				Inventories[invid].inventory[data.toSlot] = {name = data.newslotItem.name, label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = Items[data.newslotItem.name].closeonuse}
				ItemNotify(xPlayer, data.newslotItem.name, data.newslotItem.count, 'Removed', invid)
			end
			if invid ~= playerinv then Inventories[invid].changed = true end
			if invid2 ~= playerinv then Inventories[invid2].changed = true end
		end
	end
end)


RegisterNetEvent('linden_inventory:saveInventory')
AddEventHandler('linden_inventory:saveInventory',function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	updateWeight(xPlayer)
	if Opened[xPlayer.source].invid == data.invid then
		if Inventories[data.invid].changed then
			SaveItems(data.type, data.invid)
			Inventories[data.invid].changed = false
		end
		Opened[data.invid] = nil
	end
	Opened[xPlayer.source] = nil
end)

AddEventHandler('playerDropped', function()
	local src = source
	if Opened[src] then
		local data = Opened[src]
		if Inventories[data.invid].changed then
			SaveItems(data.type, data.invid)
			Inventories[data.invid].changed = false
			print('player left with inventory open and saved')
		end
		Opened[data.invid] = nil
	end
	Opened[src] = nil
end)

RegisterNetEvent('linden_inventory:devtool')
AddEventHandler('linden_inventory:devtool', function()
	if not IsPlayerAceAllowed(source, 'command.refresh') then
		print( ('^1[warning]^3 [%s] %s was kicked for opening nui_devtools^7'):format(source, GetPlayerName(source)) )
		if Config.Logs then xPlayer = ESX.GetPlayerFromId(source)
			exports.linden_logs:log(xPlayer.source, ('%s (%s) was kicked for opening nui_devtools'):format(xPlayer.name, xPlayer.identifier), 'test')
		end
		-- Trigger a ban or kick for the player
		DropPlayer(source, 'foxtrot-uniform-charlie-kilo')
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
	TriggerEvent('linden_inventory:openInventory', {type = 'stash', id = data.name, slots = data.slots, coords = data.coords, job = data.job  }, xPlayer)
end

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
