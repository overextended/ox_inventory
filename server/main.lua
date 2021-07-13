ESX.Players = {} -- Clear this table when restarting the inventory
Drops = {}
Inventories = {}
Datastore = {}
Shops = {}
Opened = {}
Status = {'starting', ''}

AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	deferrals.defer()
	Citizen.Wait(1000)
	if Status ~= 'ready' then
		deferrals.done('Inventory system has not yet loaded')
	else
		deferrals.done()
	end
end)

local failed = function(msg)
	Status[1], Status[2] = 'error', msg
end

local message = function(msg, colour)
	local type
	if colour == 1 then type = 'error' elseif colour == 2 then type = 'success' else colour, type = 3, 'warning' end
	print(('^%s[%s]^7 %s'):format(colour, type, msg))
end

Citizen.CreateThread(function()
	if ESX == nil then failed('You are not running a compatible version of ESX - refer to the documentation') end
	local OneSync = GetConvar('onesync_enabled', false) == 'true'
	local Infinity = GetConvar('onesync_enableInfinity', false) == 'true'
	if not OneSync and not Infinity then failed('OneSync is not enabled on this server - refer to the documentation')
	elseif Infinity then message('Server is running OneSync Infinity', 2) elseif OneSync then message('Server is running OneSync Legacy', 2) end

	if Status[1] == 'error' then
		Citizen.Wait(3000)
		message(Status[2], 1)
		print('https://thelindat.github.io/linden_inventory')
		return
	end
	if Config.ItemList then
		Citizen.Wait(3000) print('')
		message('Items are now expected to be stored in ^5`shared/items.lua`^0, with the database optional', 3)
		message('You must enter ^1`dumpitems`^0 to remove inventory items from the database', 3)
		message('Type ^1`dumpitems all`^0 if you would like to convert the database entirely\n', 3)
		while Config.ItemList do Citizen.Wait(1000) end print('')
		message('Due to changes to the way items are being handled you may need to update events! Please refer to the release post for 1.7.0', 3)
		message('All weapons, ammo, components, and items registered with the inventory have been removed from the database', 3)
		message('Restart your server to ensure items load correctly', 3)
		return
	end
	
	while GetResourceState('ghmattimysql') ~= 'started' do Citizen.Wait(0) end
	exports.ghmattimysql:execute('DELETE FROM `linden_inventory` WHERE `lastupdated` < (NOW() - INTERVAL '..Config.DBCleanup..') OR `data` = "[]"')
	---------------------
	Citizen.Wait(150)
	if Status[1] ~= 'error' then
		local count = 0
		local result = exports.ghmattimysql:executeSync('SELECT * FROM items', {})
		local query = false
		for k,v in ipairs(result) do
			if Items[v.name] then
				if not query then
					query = "DELETE FROM `items` WHERE name='"..v.name.."'"
				else
					query = query.. " OR name='"..v.name.."'"
				end
			else
				count = count + 1
				Items[v.name] = {
					name = v.name,
					label = v.label,
					weight = v.weight,
					stack = v.stackable,
					close = v.closeonuse,
					description = v.description
				}
			end
		end
		if query then exports.ghmattimysql:execute(query) end
		message('Loaded '..count..' additional items from the database', 2)
		TriggerEvent('linden_inventory:loaded', Items)
		Citizen.Wait(1000)
		ESX.UsableItemsCallbacks = exports['es_extended']:getSharedObject().UsableItemsCallbacks
		for k,v in pairs(ESX.UsableItemsCallbacks) do
			ESX.UsableItemsCallbacks[k] = true
		end
		message('Inventory setup is complete', 2)
		Status = 'ready'
	end	
end)

Citizen.CreateThread(function()
	local ignore = {[0] = '?', [966099553] = 'shovel'}
	while true do		
		Citizen.Wait(30000)
		for invId, data in pairs(Inventories) do
			if type(invId) == 'number' and not IsPlayerAceAllowed(data.id, 'command.save') then
				local ped = GetPlayerPed(data.id)
				if ped then
					local hash, curWeapon = GetSelectedPedWeapon(ped)
					if hash ~= `WEAPON_UNARMED` and not ignore[hash] then
						curWeapon = ESX.GetWeaponFromHash(hash)
						if curWeapon then
							if Items[curWeapon.name] then
								local item = getInventoryItem(xPlayer, curWeapon.name)
								if item.count == 0 then
									TriggerClientEvent('linden_inventory:clearWeapons', data.id)
									print( ('^1[warning]^3 ['..data.id..'] '..GetPlayerName(data.id)..' may be cheating (using '..curWeapon.name..' but does not have any)^7'):format(data.id, GetPlayerName(data.id)) )
								end
							else
								local xPlayer = ESX.GetPlayerFromId(data.id)
								TriggerBanEvent(xPlayer, 'using an invalid weapon ("'..curWeapon.name..'")')
							end
						else
							print('^1[warning]^3 ['..data.id..'] '..GetPlayerName(data.id)..' may be cheating (unknown weapon '..hash..')^7')
						end
					end
				end
			end
			Citizen.Wait(200)
		end
	end
end)

ESX.RegisterServerCallback('linden_inventory:setup', function(source, cb)
	local src = source
	local loop = 0
	while true do
		if Status == 'ready' then break end
		loop = loop + 1
		if loop == 8 then return end
		Citizen.Wait(500)
	end
	local xPlayer = ESX.GetPlayerFromId(src)
	if not Inventories[xPlayer.source] then
		local result = exports.ghmattimysql:scalarSync('SELECT inventory FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		})
		if result then
			TriggerEvent('linden_inventory:setPlayerInventory', xPlayer, json.decode(result))
			while not Inventories[xPlayer.source] do Citizen.Wait(100) end
		end
	end
	local data = {
		drops = Drops,
		usables = ESX.UsableItemsCallbacks,
		name = Inventories[xPlayer.source].name,
		inventory = Inventories[xPlayer.source].inventory,
		weight = Inventories[xPlayer.source].weight,
	}
	cb(data)
end)

AddEventHandler('linden_inventory:setPlayerInventory', function(xPlayer, data, cb)
	while Status ~= 'ready' do Citizen.Wait(200) end
	local inventory, totalWeight = {}, 0
	if data and next(data) then
		for k, v in pairs(data) do
			if type(v) == 'number' then break end
			local xItem = Items[v.name]
			if xItem then
				local weight
				if xItem.ammoname then
					local ammo = {}
					ammo.type = xItem.ammoname
					ammo.count = v.metadata.ammo
					ammo.weight = Items[ammo.type].weight
					weight = xItem.weight + (ammo.weight * ammo.count)
				else weight = xItem.weight end
				if not v.metadata then v.metadata = {} end
				if v.metadata.weight then weight = weight + v.metadata.weight end
				totalWeight = totalWeight + weight
				inventory[v.slot] = {name = v.name, label = xItem.label, weight = weight, slot = v.slot, count = v.count, description = xItem.description, metadata = v.metadata, stack = xItem.stack}
			end
		end
	end
	inventory = CreateInventory(xPlayer.source, xPlayer.name, 'player', Config.PlayerSlots, totalWeight, DefaultWeight, xPlayer.source, inventory)
	inventory.set('identifier', xPlayer.identifier)
	Inventories[xPlayer.source] = inventory
	local money = getInventoryItem(xPlayer, 'money').count
	local dirty = getInventoryItem(xPlayer, 'black_money').count
	xPlayer.syncInventory(money, dirty, Inventories[xPlayer.source].inventory, totalWeight, DefaultWeight)
	if type(cb) ~= "number" then cb(true) end
end)

AddEventHandler('linden_inventory:clearPlayerInventory', function(xPlayer)
	if type(xPlayer) ~= 'table' then xPlayer = ESX.GetPlayerFromId(xPlayer) end
	if xPlayer then
		Inventories[xPlayer.source].inventory = {}
		Inventories[xPlayer.source].weight = 0
		syncInventory(xPlayer)
		if Opened[xPlayer.source] then TriggerClientEvent('linden_inventory:closeInventory', Opened[xPlayer.source].invid) end
	TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source], true)
	end
end)

AddEventHandler('linden_inventory:confiscatePlayerInventory', function(xPlayer)
	if type(xPlayer) ~= 'table' then xPlayer = ESX.GetPlayerFromId(xPlayer) end
	if Inventories[xPlayer.source] then
		local inventory = json.encode(getPlayerInventory(xPlayer, true))
		exports.ghmattimysql:execute('REPLACE INTO `linden_inventory` (name, data) VALUES (@name, @data)', {
			['@name'] = xPlayer.getIdentifier(),
			['@data'] = inventory
		}, function (rowsChanged)
			TriggerEvent('linden_inventory:clearPlayerInventory', xPlayer)
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = _U('items_confiscated') })
		end)
	end
end)

AddEventHandler('linden_inventory:recoverPlayerInventory', function(xPlayer)
	if type(xPlayer) ~= 'table' then xPlayer = ESX.GetPlayerFromId(xPlayer) end
	if Inventories[xPlayer.source] then
		local result = exports.ghmattimysql:scalarSync('SELECT data FROM `linden_inventory` WHERE name = @name', { ['@name'] = xPlayer.getIdentifier() })
		if result ~= nil then
			exports.ghmattimysql:execute('DELETE FROM `linden_inventory` WHERE name = @name', { ['@name'] = xPlayer.getIdentifier() })
			local Inventory = json.decode(result)
			for k,v in pairs(Inventory) do
				if v.metadata == nil then v.metadata = {} end
				local weight = Items[v.name].weight
				if v.metadata.weight then weight = weight + v.metadata.weight end
				Inventories[xPlayer.source].inventory[v.slot] = {name = v.name ,label = Items[v.name].label, weight = weight, slot = v.slot, count = v.count, description = Items[v.name].description, metadata = v.metadata, stack = Items[v.name].stack}
			end
			syncInventory(xPlayer)	
			if Opened[xPlayer.source] then TriggerClientEvent('linden_inventory:closeInventory', Opened[xPlayer.source].invid)
				TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source])
			end
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = _U('items_returned') })
		end
	end
end)


RegisterNetEvent('linden_inventory:openInventory')
AddEventHandler('linden_inventory:openInventory', function(invType, data, player)
	local xPlayer
	if player then xPlayer = player else xPlayer = ESX.GetPlayerFromId(source) end
	if not data then
		if not Opened[xPlayer.source] then
			Opened[xPlayer.source] = {invid = xPlayer.source, type = 'Playerinv'}
			Inventories[xPlayer.source].set('open', xPlayer.source)
			TriggerClientEvent('linden_inventory:openInventory',  xPlayer.source, Inventories[xPlayer.source])
		end
	else
		if invType ~= 'bag' and Opened[xPlayer.source] then return end
		if invType == 'drop' then
			if Drops[data] ~= nil and Opened[data] == nil and #(Drops[data].coords - GetEntityCoords(GetPlayerPed(xPlayer.source))) <= 2 then
				Opened[xPlayer.source] = {invid = data, type = 'drop'}
				Opened[data] = xPlayer.source
				Inventories[xPlayer.source].set('open', xPlayer.source)
				TriggerClientEvent('linden_inventory:openInventory', xPlayer.source, Inventories[xPlayer.source], Drops[data])
			end
		elseif data then
			if invType == 'shop' then
				local shop = Config.Shops[data]
				if (not shop.job or shop.job == xPlayer.job.name) and (not shop.grade or shop.grade <= xPlayer.job.grade) then
					local srcCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
					if #(shop.coords - srcCoords) <= 10 then
						if shop.currency and type(shop.currency) == 'string' and shop.currency ~= 'money' and shop.currency ~= 'black_money' then
							local item = Items[shop.currency]
							shop.currency = {name=item.name, label=item.label}
						end
						Shops[data] = {
							id = data,
							type = 'shop',
							name = shop.name or shop.type.name,
							coords = shop.coords,
							job = shop.job,
							inventory = SetupShopItems(data),
							slots = #shop.store.inventory,
							currency = shop.currency
						}
						Opened[xPlayer.source] = {invid = xPlayer.source, type = 'Playerinv'}
						Inventories[xPlayer.source].set('open', xPlayer.source)
						TriggerClientEvent('linden_inventory:openInventory', xPlayer.source, Inventories[xPlayer.source], Shops[data])
					end
				end
			elseif data.owner then
				if data.owner == true then data.owner = xPlayer.identifier end
				local id = data.id..'-'..data.owner
				if not Inventories[id] then
					if not data.maxWeight then data.maxWeight = data.slots*8000 end
					Inventories[id] = CreateInventory(
						id,								-- id
						data.label,						-- name
						invType,						-- type
						data.slots,						-- slots
						0,								-- weight
						data.maxWeight,					-- maxWeight
						data.owner,						-- owner
						GetInventory(id, invType, data.owner)	-- inventory
					)
					if data.coords then Inventories[id].set('coords', data.coords) end
				end
				if CheckOpenable(xPlayer, id, data.coords) then
					Inventories[id].set('open', xPlayer.source)
					Opened[xPlayer.source] = {invid = id, type = invType}
					Inventories[xPlayer.source].set('open', xPlayer.source)
					TriggerClientEvent('linden_inventory:openInventory', xPlayer.source, Inventories[xPlayer.source], Inventories[id])
				end
			else
				local id = data.id
				if invType == 'bag' then Opened[xPlayer.source] = nil end
				if invType == 'dumpster' then id = NetworkGetEntityFromNetworkId(id) end
				if not Inventories[id] then
					if invType == 'dumpster' then SetEntityDistanceCullingRadius(id, 5000.0) end
					if not data.maxWeight then
						local maxWeight = {glovebox = 4000, trunk = 6000, bag = 1000}
						data.maxWeight = data.slots*(maxWeight[invType] or 8000)
					end
					Inventories[id] = CreateInventory(
						id,								-- id
						data.label,						-- name
						invType,						-- type
						data.slots,						-- slots
						0,								-- weight
						data.maxWeight,					-- maxWeight
						data.owner,						-- owner
						GetInventory(id, invType, data.owner)	-- inventory
					)
					if data.coords then Inventories[id].set('coords', data.coords) end
					if data.job then Inventories[id].set('job', data.job) end
					if data.grade then Inventories[id].set('grade', data.grade) end
					if data.slot then Inventories[id].set('slot', data.slot) end
				end
				if CheckOpenable(xPlayer, id, data.coords) then
					Inventories[id].set('open', xPlayer.source)
					Opened[xPlayer.source] = {invid = id, type = invType}
					Inventories[xPlayer.source].set('open', xPlayer.source)
					TriggerClientEvent('linden_inventory:openInventory', xPlayer.source, Inventories[xPlayer.source], Inventories[id])
				end
			end
		end
	end
end)

RegisterNetEvent('linden_inventory:openTargetInventory')
AddEventHandler('linden_inventory:openTargetInventory', function(targetId)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(targetId)
	if source ~= targetId and xTarget and xPlayer and Inventories[xTarget.source].get('open') == false then
		local targetCoords = GetEntityCoords(GetPlayerPed(xTarget.source))
		local playerCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
		if #(playerCoords - targetCoords) <= 3 then
			Inventories[xTarget.source].set('open', xPlayer.source)
			Opened[xPlayer.source] = {invid = xTarget.source, type = 'player'}
			Opened[xTarget.source] = {invid = xPlayer.source, type = 'player'}
			TriggerClientEvent('linden_inventory:openInventory', xPlayer.source, Inventories[xPlayer.source], Inventories[xTarget.source])
		end
	end
end)

RegisterNetEvent('linden_inventory:giveStash')
AddEventHandler('linden_inventory:giveStash', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer and data.item then
		if not data.metadata then data.metadata = {} end
		local item = getInventoryItem(xPlayer, data.item, data.metadata)
		if item.count >= data.count then
			local id = data.name
			
			if data.coords then
				local srcCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
				if #(data.coords - srcCoords) > 10 then return false end
			end

			if not Inventories[id] then
				if not data.maxWeight then
					data.maxWeight = data.slots*8000
				end
				Inventories[id] = CreateInventory(
					id,								-- id
					data.label,						-- name
					type,							-- type
					data.slots,						-- slots
					0,								-- weight
					data.maxWeight,					-- maxWeight
					data.owner,						-- owner
					GetInventory(id, 'stash', data.owner)	-- inventory
				)
				if data.coords then Inventories[id].set('coords', data.coords) end
			end
			if Inventories[id].open then TriggerClientEvent('linden_inventory:closeInventory', Inventories[id].open) end

			local xItem, slot, existing = Items[data.item]
			for i=1, data.slots do
				if xItem.stack and Inventories[id].inventory[i] and Inventories[id].inventory[i].name == data.item and func.matchtables(Inventories[id].inventory[i].metadata, data.metadata) then slot = i existing = true break
				elseif not slot and Inventories[id].inventory[i] == nil then slot = i existing = false end
			end

			if existing then
				Inventories[id].inventory[slot].count = Inventories[id].inventory[slot].count + data.count
			else
				local weight = xItem.weight
				if data.metadata.weight then weight = weight + data.metadata.weight end
				Inventories[id].inventory[slot] = {name = xItem.name, label = xItem.label, weight = weight, slot = slot, count = data.count, description = xItem.description, metadata = data.metadata, stack = xItem.stack, close = xItem.close}
			end

			removeInventoryItem(xPlayer, data.item, data.count, data.metadata)

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
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = _U('item_unauthorised') })
			return
		end
	
		if Config.WeaponsLicense and checkShop.license then
			local hasLicense = exports.ghmattimysql:scalarSync('SELECT 1 FROM user_licenses WHERE type = @type AND owner = @owner', {
				['@type'] = checkShop.license,
				['@owner'] = xPlayer.identifier
			})
			if not hasLicense then
				TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = _U('item_unlicensed') })
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
				money = getInventoryItem(xPlayer, item.name).count
			end
		elseif shopCurrency == 'money' or shopCurrency == 'black_money' then
			item.name = 'money'
			currency = Items[item.name].label
			money = getInventoryItem(xPlayer, item.name).count
		else
			item = Items[shopCurrency.name]
			currency = item.label
			money = getInventoryItem(xPlayer, shopCurrency.name).count
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
					local xItem = Items[data.name]
					if xItem.server and xItem.server.onpurchase then
						local wait = true
						TriggerEvent(xItem.server.onpurchase, xPlayer, xItem, data, Config.Shops[location], function(result, metadata)
							if result then
								if metadata then data.metadata = metadata end
								wait = false
							end
						end)
						local timeout = 100
						while wait do
							Citizen.Wait(10)
							timeout = timeout - 1
							if timeout == 0 then return end
						end
					end
					addInventoryItem(xPlayer, data.name, count, data.metadata, false)
					if Config.Shops[location].job then
						if Config.Logs then CreateLog(xPlayer.source, false, ('bought %sx %s from %s for %s'):format(ESX.Math.GroupDigits(count), data.label, shopName, cost), 'shop') end
					end
				else
					local missing = ''
					if currency == 'bank' or item.name:find('money') then missing = '$' end
					missing = missing..ESX.Math.GroupDigits(ESX.Round(data.price - money))..' '..currency
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = _U('cannot_afford', missing) })
				end
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = _U('cannot_carry') })
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
			else
				invid = data.invid
				if data.toinv == 'player' then xTarget, targetId = ESX.GetPlayerFromId(data.invid), data.invid end
			end
			if data.frominv == 'drop' or data.toinv == 'drop' then
				if data.type == 'swap' then
					if ValidateItem(data.type, xPlayer, Drops[invid].inventory[data.fromSlot], Drops[invid].inventory[data.toSlot], data.fromItem, data.toItem) == true then
						Drops[invid].inventory[data.toSlot] = {name = data.toItem.name, label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stack = data.toItem.stack, close = Items[data.toItem.name].close}
						Drops[invid].inventory[data.fromSlot] = {name = data.fromItem.name, label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stack = data.fromItem.stack, close = Items[data.fromItem.name].close}
					end
				elseif data.type == 'freeslot' then
					if ValidateItem(data.type, xPlayer, Drops[invid].inventory[data.emptyslot], Drops[invid].inventory[data.toSlot], data.item, data.item) == true then
						Drops[invid].inventory[data.emptyslot] = nil
						Drops[invid].inventory[data.toSlot] = {name = data.item.name, label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stack = data.item.stack, close = Items[data.item.name].close}
					end
				elseif data.type == 'split' then
					if ValidateItem(data.type, xPlayer, Drops[invid].inventory[data.fromSlot], Drops[invid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) == true then
						Drops[invid].inventory[data.fromSlot] = {name = data.oldslotItem.name, label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stack = data.oldslotItem.stack, close = Items[data.oldslotItem.name].close}
						Drops[invid].inventory[data.toSlot] = {name = data.newslotItem.name, label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stack = data.newslotItem.stack, close = Items[data.newslotItem.name].close}
					end
				end
			else
				if data.type == 'swap' then
					if ValidateItem(data.type, xPlayer, Inventories[invid].inventory[data.fromSlot], Inventories[invid].inventory[data.toSlot], data.fromItem, data.toItem) == true then
						Inventories[invid].inventory[data.toSlot] = {name = data.toItem.name, label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stack = data.toItem.stack, close = Items[data.toItem.name].close}
						Inventories[invid].inventory[data.fromSlot] = {name = data.fromItem.name, label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stack = data.fromItem.stack, close = Items[data.fromItem.name].close}
						if invid ~= xPlayer.source and invid ~= xTarget.source then Inventories[invid].set('changed', true) end
						TriggerClientEvent('linden_inventory:update', xPlayer.source, {data.toSlot, Inventories[invid].inventory[data.toSlot], data.fromSlot, Inventories[invid].inventory[data.fromSlot]})
					end
				elseif data.type == 'freeslot' then
					if ValidateItem(data.type, xPlayer, Inventories[invid].inventory[data.emptyslot], Inventories[invid].inventory[data.toSlot], data.item, data.item) == true then
						Inventories[invid].inventory[data.emptyslot] = nil
						Inventories[invid].inventory[data.toSlot] = {name = data.item.name, label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stack = data.item.stack, close = Items[data.item.name].close}
						if invid ~= xPlayer.source and invid ~= xTarget.source then Inventories[invid].set('changed', true) end
						TriggerClientEvent('linden_inventory:update', xPlayer.source, {data.toSlot, Inventories[invid].inventory[data.toSlot], data.emptyslot, Inventories[invid].inventory[data.emptyslot]})
					end
				elseif data.type == 'split' then
					if ValidateItem(data.type, xPlayer, Inventories[invid].inventory[data.fromSlot], Inventories[invid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) == true then
						Inventories[invid].inventory[data.fromSlot] = {name = data.oldslotItem.name, label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stack = data.oldslotItem.stack, close = Items[data.oldslotItem.name].close}
						Inventories[invid].inventory[data.toSlot] = {name = data.newslotItem.name, label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stack = data.newslotItem.stack, close = Items[data.newslotItem.name].close}
						if invid ~= xPlayer.source and invid ~= xTarget.source then Inventories[invid].set('changed', true) end
						TriggerClientEvent('linden_inventory:update', xPlayer.source, {data.toSlot, Inventories[invid].inventory[data.toSlot], data.fromSlot, Inventories[invid].inventory[data.fromSlot]})
					end
				end
			end
		elseif data.frominv ~= data.toinv then
			if data.toinv == 'drop' and not Drops[data.invid] then
				CreateNewDrop(xPlayer, data)
				return
			end
			if data.frominv == 'Playerinv' then
				if data.toinv == 'player' then xTarget, targetId = ESX.GetPlayerFromId(data.invid), data.invid end
				invid = data.invid
				invid2 = xPlayer.source
			elseif data.toinv == 'Playerinv' then
				if data.frominv == 'player' then xTarget, targetId = ESX.GetPlayerFromId(data.invid2), data.invid2 end
				invid2 = data.invid2
				invid = xPlayer.source
			end
			if data.frominv == 'drop' or data.toinv == 'drop' then
				local dropid
				if data.frominv == 'Playerinv' then
					dropid = invid
					if data.type == 'swap' then
						if ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.fromSlot], Drops[dropid].inventory[data.toSlot], data.fromItem, data.toItem) == true then
							ItemNotify(xPlayer, data.toItem, data.toItem.count, data.fromSlot, 'removed')
							ItemNotify(xPlayer, data.fromItem, data.fromItem.count, data.toSlot, 'added')
							Drops[dropid].inventory[data.toSlot] = {name = data.toItem.name, label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stack = data.toItem.stack, close = Items[data.toItem.name].close}
							Inventories[invid2].inventory[data.fromSlot] = {name = data.fromItem.name, label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stack = data.fromItem.stack, close = Items[data.fromItem.name].close}
							if Config.Logs then CreateLog(xPlayer.source, false, 'has swapped '..data.toItem.count..'x '..data.toItem.name..' for '..data.fromItem.count..'x '..data.fromItem.name..' in'..dropid, 'drop') end
							TriggerClientEvent('linden_inventory:update', xPlayer.source, {data.fromSlot, Inventories[invid2].inventory[data.fromSlot]})
						end
					elseif data.type == 'freeslot' then
						if ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.emptyslot], Drops[dropid].inventory[data.toSlot], data.item, data.item) == true then
							local count = Inventories[invid2].inventory[data.emptyslot].count
							ItemNotify(xPlayer, data.item, count, data.emptyslot, 'removed')
							Inventories[invid2].inventory[data.emptyslot] = nil
							Drops[dropid].inventory[data.toSlot] = {name = data.item.name, label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stack = data.item.stack, close = Items[data.item.name].close}
							if Config.Logs then CreateLog(xPlayer.source, false, 'has stored '..count..'x '..data.item.name..' in'..dropid, 'drop') end
							TriggerClientEvent('linden_inventory:update', xPlayer.source, {data.emptyslot, nil})
						end
					elseif data.type == 'split' then
						if ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.fromSlot], Drops[dropid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) == true then
							ItemNotify(xPlayer, data.newslotItem, data.newslotItem.count, data.fromSlot, 'removed')
							Inventories[invid2].inventory[data.fromSlot] = {name = data.oldslotItem.name, label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stack = data.oldslotItem.stack, close = Items[data.oldslotItem.name].close}
							Drops[dropid].inventory[data.toSlot] = {name = data.newslotItem.name, label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stack = data.newslotItem.stack, close = Items[data.newslotItem.name].close}
							if Config.Logs then CreateLog(xPlayer.source, false, 'has stored '..data.newslotItem.count..'x '..data.newslotItem.name..' in'..dropid, 'drop') end
							TriggerClientEvent('linden_inventory:update', xPlayer.source, {data.fromSlot, Inventories[invid2].inventory[data.fromSlot]})
						end
					end
				elseif data.toinv == 'Playerinv' then
					dropid = invid2
					if data.type == 'swap' then
						if ValidateItem(data.type, xPlayer, Drops[dropid].inventory[data.fromSlot], Inventories[invid].inventory[data.toSlot], data.fromItem, data.toItem) == true then
							ItemNotify(xPlayer, data.toItem, data.toItem.count, data.toSlot, 'added')
							ItemNotify(xPlayer, data.fromItem, data.fromItem.count, data.fromSlot, 'removed')
							Inventories[invid].inventory[data.toSlot] = {name = data.toItem.name, label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stack = data.toItem.stack, close = Items[data.toItem.name].close}
							Drops[dropid].inventory[data.fromSlot] = {name = data.fromItem.name, label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stack = data.fromItem.stack, close = Items[data.fromItem.name].close}
							if Config.Logs then CreateLog(xPlayer.source, false, 'has swapped '..data.fromItem.count..'x '..data.fromItem.name..' for '..data.toItem.count..'x '..data.toItem.name.. 'in'..dropid, 'drop') end
							TriggerClientEvent('linden_inventory:update', xPlayer.source, {data.toSlot, Inventories[invid].inventory[data.toSlot]})
						end
					elseif data.type == 'freeslot' then
						if ValidateItem(data.type, xPlayer, Drops[dropid].inventory[data.emptyslot], Inventories[invid].inventory[data.toSlot], data.item, data.item) == true then
							local count = Drops[dropid].inventory[data.emptyslot].count
							ItemNotify(xPlayer, data.item, count, data.toSlot, 'added')
							Drops[dropid].inventory[data.emptyslot] = nil
							Inventories[invid].inventory[data.toSlot] = {name = data.item.name, label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stack = data.item.stack, close = Items[data.item.name].close}
							if Config.Logs then CreateLog(xPlayer.source, false, 'has taken '..count..'x '..data.item.name..' from'..dropid, 'drop') end
							TriggerClientEvent('linden_inventory:update', xPlayer.source, {data.toSlot, Inventories[invid].inventory[data.toSlot]})
						end
					elseif data.type == 'split' then
						if ValidateItem(data.type, xPlayer, Drops[dropid].inventory[data.fromSlot], Inventories[invid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) == true then
							ItemNotify(xPlayer, data.newslotItem, data.toSlot, false, 'added')
							Drops[dropid].inventory[data.fromSlot] = {name = data.oldslotItem.name, label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stack = data.oldslotItem.stack, close = Items[data.oldslotItem.name].close}
							Inventories[invid].inventory[data.toSlot] = {name = data.newslotItem.name, label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stack = data.newslotItem.stack, close = Items[data.newslotItem.name].close}
							if Config.Logs then CreateLog(xPlayer.source, false, 'has taken '..data.newslotItem.count..'x '..data.newslotItem.name..' from'..dropid, 'drop') end
							TriggerClientEvent('linden_inventory:update', xPlayer.source, {data.toSlot, Inventories[invid].inventory[data.toSlot]})
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
							ItemNotify(xPlayer, data.toItem, data.toItem.count, data.toSlot, 'added', data.type)
							ItemNotify(xPlayer, data.fromItem, data.fromItem.count, data.fromSlot, 'removed', data.type)
							if targetId then
								ItemNotify(xTarget, data.toItem, data.toItem.count, data.toSlot, 'removed', data.type)
								ItemNotify(xTarget, data.fromItem, data.fromItem.count, data.fromSlot, 'added', data.type)
								if Config.Logs then
									CreateLog(xPlayer.source, xTarget.source, 'has given '..data.fromItem.count..'x '..data.fromItem.name..' to', data.toinv)
									CreateLog(xPlayer.source, xTarget.source, 'has taken '..data.toItem.count..'x '..data.toItem.name..' from', data.frominv)
								end
							else
								if Config.Logs then
									CreateLog(xPlayer.source, false, 'has stored '..data.fromItem.count..'x '..data.fromItem.name..' in '..invid2, data.toinv)
									CreateLog(xPlayer.source, false, 'has taken '..data.toItem.count..'x '..data.toItem.name..' from '..invid2, data.frominv)
								end
							end
						elseif invid2 == xPlayer.source then
							ItemNotify(xPlayer, data.toItem, data.toItem.count, data.toSlot, 'removed', data.type)
							ItemNotify(xPlayer, data.fromItem, data.fromItem.count, data.fromSlot, 'added', data.type)
							if targetId then
								ItemNotify(xTarget, data.toItem, data.toItem.count, data.toSlot, 'added', data.type)
								ItemNotify(xTarget, data.fromItem, data.fromItem.count, data.fromSlot, 'removed', data.type)
								if Config.Logs then
									CreateLog(xPlayer.source, xTarget.source, 'has given '..data.fromItem.count..'x '..data.fromItem.name..' to', data.toinv)
									CreateLog(xPlayer.source, xTarget.source, 'has taken '..data.toItem.count..'x '..data.toItem.name..' from', data.frominv)
								end
							else
								if Config.Logs then
									CreateLog(xPlayer.source, false, 'has stored '..data.fromItem.count..'x '..data.fromItem.name..' in '..invid, data.toinv)
									CreateLog(xPlayer.source, false, 'has taken '..data.toItem.count..'x '..data.toItem.name..' from '..invid, data.frominv)
								end
							end
						end
						Inventories[invid].inventory[data.toSlot] = {name = data.toItem.name, label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stack = data.toItem.stack, close = Items[data.toItem.name].close}
						Inventories[invid2].inventory[data.fromSlot] = {name = data.fromItem.name, label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stack = data.fromItem.stack, close = Items[data.fromItem.name].close}
						if invid ~= xPlayer.source and invid ~= xTarget.source then Inventories[invid].set('changed', true) end if invid2 ~= xPlayer.source and invid2 ~= xTarget.source then Inventories[invid2].set('changed', true) end
						if invid == xPlayer.source then -- to self inventory
							TriggerClientEvent('linden_inventory:update', xPlayer.source, {data.toSlot, Inventories[invid].inventory[data.toSlot]})
							if targetId then TriggerClientEvent('linden_inventory:update', xTarget.source, {data.fromSlot, Inventories[invid2].inventory[data.fromSlot]}) end
						else
							TriggerClientEvent('linden_inventory:update', xPlayer.source, {data.fromSlot, Inventories[invid2].inventory[data.fromSlot]})
							if targetId then TriggerClientEvent('linden_inventory:update', xTarget.source, {data.toSlot, Inventories[invid].inventory[data.toSlot]}) end
						end
					end
				elseif data.type == 'freeslot' then
					if ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.emptyslot], Inventories[invid].inventory[data.toSlot], data.item, data.item) == true then
						local count = Inventories[invid2].inventory[data.emptyslot].count
						if invid == xPlayer.source then
							ItemNotify(xPlayer, data.item, count, data.toSlot, 'added')
							if targetId then
								ItemNotify(xTarget, data.item, count, data.emptyslot, 'removed')
								if Config.Logs then CreateLog(xPlayer.source, xTarget.source, 'has taken '..count..'x '..data.item.name..' from', data.frominv) end
							else
								if Config.Logs then CreateLog(xPlayer.source, false, 'has taken '..count..'x '..data.item.name..' from '..invid2, data.frominv) end
							end
						elseif invid2 == xPlayer.source then
							ItemNotify(xPlayer, data.item, count, data.emptyslot, 'removed')
							if targetId then
								ItemNotify(xTarget, data.item, count, data.toSlot, 'added')
								if Config.Logs then CreateLog(xPlayer.source, false, 'has given '..count..'x '..data.item.name..' to', data.toinv) end
							else
								if Config.Logs then CreateLog(xPlayer.source, false, 'has stored '..count..'x '..data.item.name..' in '..invid, data.toinv) end
							end
						end
						Inventories[invid2].inventory[data.emptyslot] = nil
						Inventories[invid].inventory[data.toSlot] = {name = data.item.name, label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stack = data.item.stack, close = Items[data.item.name].close}
						if invid ~= xPlayer.source and invid ~= xTarget.source then Inventories[invid].set('changed', true) end if invid2 ~= xPlayer.source and invid2 ~= xTarget.source then Inventories[invid2].set('changed', true) end
						if invid == xPlayer.source then -- to self inventory
							TriggerClientEvent('linden_inventory:update', xPlayer.source, {data.toSlot, Inventories[invid].inventory[data.toSlot]})
							if targetId then TriggerClientEvent('linden_inventory:update', xTarget.source, {data.emptyslot, Inventories[invid2].inventory[data.emptyslot]}) end
						else
							TriggerClientEvent('linden_inventory:update', xPlayer.source, {data.emptyslot, Inventories[invid2].inventory[data.emptyslot]})
							if targetId then TriggerClientEvent('linden_inventory:update', xTarget.source, {data.toSlot, Inventories[invid].inventory[data.toSlot]}) end
						end
					end
				elseif data.type == 'split' then
					if ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.fromSlot], Inventories[invid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) == true then
						if invid == xPlayer.source then
							ItemNotify(xPlayer, data.newslotItem, data.newslotItem.count, data.toSlot, 'added')
							if targetId then
								ItemNotify(xTarget, data.newslotItem, data.newslotItem.count, data.fromSlot, 'removed')
								if Config.Logs then CreateLog(xPlayer.source, xTarget.source, 'has taken '..data.newslotItem.count..'x '..data.newslotItem.name..' from', data.frominv) end	
							else
								if Config.Logs then CreateLog(xPlayer.source, false, 'has taken '..data.newslotItem.count..'x '..data.newslotItem.name..' from '..invid2, data.frominv) end	
							end
						elseif invid2 == xPlayer.source then
							ItemNotify(xPlayer, data.newslotItem, data.newslotItem.count, data.fromSlot, 'removed')
							if targetId then
								ItemNotify(xTarget, data.newslotItem, data.toSlot, false, 'added')
								if Config.Logs then CreateLog(xPlayer.source, xTarget.source, 'has given '..data.newslotItem.count..'x '..data.newslotItem.name..' to', data.toinv) end	
							else
								if Config.Logs then CreateLog(xPlayer.source, false, 'has stored '..data.newslotItem.count..'x '..data.newslotItem.name..' in '..invid, data.toinv) end	
							end
						end
						Inventories[invid2].inventory[data.fromSlot] = {name = data.oldslotItem.name, label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stack = data.oldslotItem.stack, close = Items[data.oldslotItem.name].close}
						Inventories[invid].inventory[data.toSlot] = {name = data.newslotItem.name, label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stack = data.newslotItem.stack, close = Items[data.newslotItem.name].close}
						if invid ~= xPlayer.source and invid ~= xTarget.source then Inventories[invid].set('changed', true) end if invid2 ~= xPlayer.source and invid2 ~= xTarget.source then Inventories[invid2].set('changed', true) end
						if invid == xPlayer.source then -- to self inventory
							TriggerClientEvent('linden_inventory:update', xPlayer.source, {data.toSlot, Inventories[invid].inventory[data.toSlot]})
							if targetId then TriggerClientEvent('linden_inventory:update', xTarget.source, {data.fromSlot, Inventories[invid2].inventory[data.fromSlot]}) end
						else
							TriggerClientEvent('linden_inventory:update', xPlayer.source, {data.fromSlot, Inventories[invid2].inventory[data.fromSlot]})
							if targetId then TriggerClientEvent('linden_inventory:update', xTarget.source, {data.toSlot, Inventories[invid].inventory[data.toSlot]}) end
						end
					end
				end
			end
		end
	end
end)

RegisterNetEvent('linden_inventory:saveInventory')
AddEventHandler('linden_inventory:saveInventory', function(data)
	local src = source
	local invid
	local xPlayer = ESX.GetPlayerFromId(src)
	if data.type == 'drop' and data.invid then
		invid = data.invid
		Opened[invid] = nil
	elseif data.type == 'player' then
		invid = data.invid
		syncInventory(ESX.GetPlayerFromId(invid), false, data.weight, data.slot)
		Opened[invid] = nil
		Inventories[invid].set('open', false)
	elseif data.type ~= 'shop' and Inventories[data.invid] then
		invid = data.invid
		Inventories[invid].set('open', false)
	end
	if xPlayer then
		syncInventory(xPlayer, false, data.weight, data.slot)
		TriggerClientEvent('linden_inventory:refreshInventory', src, Inventories[src])
	end
	Opened[src] = nil
	Inventories[xPlayer.source].set('open', false)
end)

AddEventHandler('esx:playerDropped', function(playerid)
	local data = Opened[playerid]
	if Inventories[playerid] and data then
		if data.type == 'player' then
			local invid = Opened[playerid].invid
			syncInventory(ESX.GetPlayerFromId(invid))
			Opened[invid] = nil
		elseif data.type ~= 'shop' and data.type ~= 'drop' and Inventories[data.invid] then
			Inventories[data.invid].set('open', false)
		elseif data.invid then Opened[data.invid] = nil end
		Opened[playerid] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local playerid = source
	if Inventories[playerid] then
		SetTimeout(1000, function()	
			Inventories[playerid] = nil
		end)
	end
end)

RegisterNetEvent('linden_inventory:giveItem')
AddEventHandler('linden_inventory:giveItem', function(data, target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	local xItem = getInventoryItem(xPlayer, data.item.name, data.item.metadata)
	if data.amount > xItem.count then
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = _U('item_not_enough', data.item.label) })
	else
		if canCarryItem(xTarget, data.item.name, data.amount, data.item.metadata) then
			removeInventoryItem(xPlayer, data.item.name, data.amount, data.item.metadata, data.item.slot)
			addInventoryItem(xTarget, data.item.name, data.amount, data.item.metadata)
			if Config.Logs then CreateLog(xPlayer.source, xTarget.source, 'has given '..data.amount..'x '..data.item.name..' to', 'player') end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = _U('cannot_carry_other') })
		end
	end
end)

RegisterNetEvent('linden_inventory:reloadWeapon')
AddEventHandler('linden_inventory:reloadWeapon', function(weapon)
	local xPlayer = ESX.GetPlayerFromId(source)
	if Inventories[xPlayer.source].inventory[weapon.slot] then
		local ammo = Items[Items[weapon.name].ammoname]
		ammo.count = getInventoryItem(xPlayer, ammo.name).count
		if ammo.count > 0 then TriggerClientEvent('linden_inventory:addAmmo', xPlayer.source, ammo) end
	else TriggerClientEvent('linden_inventory:clearWeapons', xPlayer.source) end
end)

RegisterNetEvent('linden_inventory:decreaseDurability')
AddEventHandler('linden_inventory:decreaseDurability', function(slot, item, ammo, xPlayer)
	local xPlayer = xPlayer or ESX.GetPlayerFromId(source)
	local decreaseamount = 0
	if type(slot) == 'number' then
		if Inventories[xPlayer.source].inventory[slot] ~= nil then
			local xItem = Items[Inventories[xPlayer.source].inventory[slot].name]
			if Inventories[xPlayer.source].inventory[slot].metadata.durability ~= nil then
				if Inventories[xPlayer.source].inventory[slot].metadata.durability <= 0 then
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = _U('weapon_broken') })
					if Inventories[xPlayer.source].inventory[slot].name:find('WEAPON_FIREEXTINGUISHER') then
						removeInventoryItem(xPlayer, Inventories[xPlayer.source].inventory[slot].name, 1, false, slot)
					end
					return
				end
				if xItem.durability == nil then
					decreaseamount = ammo / 8
				else
					decreaseamount = xItem.durability * (ammo / 7)
				end
				Inventories[xPlayer.source].inventory[slot].metadata.durability = Inventories[xPlayer.source].inventory[slot].metadata.durability - ESX.Round(decreaseamount, 2)
				if Inventories[xPlayer.source].inventory[slot].metadata.durability <= 0 then
					Inventories[xPlayer.source].inventory[slot].metadata.durability = 0
					Inventories[xPlayer.source].inventory[slot].metadata.ammo = 0
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = _U('weapon_broken') })
					TriggerClientEvent('linden_inventory:updateWeapon', xPlayer.source, Inventories[xPlayer.source].inventory[slot].metadata)
					addInventoryItem(xPlayer, xItem.ammoname, ammo)
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
			local ammo = Items[Items[item.name].ammoname]
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
	if xPlayer and Inventories[xPlayer.source].inventory[item.slot] ~= nil then
		if Inventories[xPlayer.source].inventory[item.slot].metadata.ammo ~= nil then
			if not type then
				local ammo = Items[Items[item.name].ammoname]
				ammo.count = Inventories[xPlayer.source].inventory[item.slot].metadata.ammo
				local ammoDiff = ammo.count - item.metadata.ammo
				ammo.addweight = (ammo.count * ammo.weight)
				Inventories[xPlayer.source].inventory[item.slot].metadata.ammo = ammo.count - ammoDiff
				Inventories[xPlayer.source].inventory[item.slot].weight = Items[item.name].weight + ammo.addweight
				TriggerEvent('linden_inventory:decreaseDurability', item.slot, item.name, ammoDiff, xPlayer)
			else Inventories[xPlayer.source].inventory[item.slot].metadata = item.metadata end
			if Opened[xPlayer.source] or not ammo then TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source]) end
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
		if xItem.name:find('WEAPON_') then
			if xItem.throwable then TriggerClientEvent('linden_inventory:weapon', xPlayer.source, Inventories[xPlayer.source].inventory[slot])
			elseif metadata.durability > 0 then TriggerClientEvent('linden_inventory:weapon', xPlayer.source, Inventories[xPlayer.source].inventory[slot])
			else TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = _U('weapon_broken') }) end
			cb(false)
		elseif xItem.name:find('ammo-') then
			TriggerClientEvent('linden_inventory:addAmmo', xPlayer.source, Inventories[xPlayer.source].inventory[slot])
			cb(false)
		else
			local consume = Items[xItem.name].consume
			if consume then
				if xItem.count >= consume then
					cb(xItem)
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = _U('item_not_enough', xItem.label) })
					cb(false)
				end
			end
		end
	end
end)

RegisterNetEvent('linden_inventory:removeItem')
AddEventHandler('linden_inventory:removeItem', function(item, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local consume = Items[item.name].consume
	if consume == 0 then consume = count end
	removeInventoryItem(xPlayer, item.name, consume, item.metadata, item.slot)
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

local OpenStash = function(xPlayer, data, custom)
	local type = custom or 'stash'
	TriggerEvent('linden_inventory:openInventory', type, {owner = data.owner, id = data.name or data.id, label = data.label, slots = data.slots, coords = data.coords, job = data.job, grade = data.grade }, xPlayer)
end
exports('OpenStash', OpenStash)

ESX.RegisterCommand('evidence', 'user', function(xPlayer, args, showError)
	if xPlayer.job.name == 'police' then
		local stash = {id = 'evidence-'..args.evidence, label = 'Police Evidence (#'..args.evidence..')', slots = Config.PlayerSlots, job = 'police', coords = Config.PoliceEvidence, grade = 2}
		OpenStash(xPlayer, stash)
	end
end, true, {help = 'open police evidence', validate = true, arguments = {
	{name = 'evidence', help = 'number', type = 'number'}
}})

ESX.RegisterCommand('clearevidence', 'user', function(xPlayer, args, showError)
	if xPlayer.job.name == 'police' and xPlayer.job.grade_name == 'boss' then
		local id = 'evidence-'..args.evidence
		exports.ghmattimysql:execute('DELETE FROM `linden_inventory` WHERE name = @name', {
			['@name'] = id
		})
	end
end, true, {help = 'clear police evidence', validate = true, arguments = {
	{name = 'evidence', help = 'number', type = 'number'}
}})

-- Confiscate inventory Command/Event
ESX.RegisterCommand('confinv', 'superadmin', function(xPlayer, args, showError)
	TriggerEvent('linden_inventory:confiscatePlayerInventory', args.playerId)
end, true, {help = 'Confiscate an Inventory', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'},
}})

-- Return Confiscated inventory Command/Event
ESX.RegisterCommand('returninv', 'superadmin', function(xPlayer, args, showError)
	TriggerEvent('linden_inventory:recoverPlayerInventory', args.playerId)
end, true, {help = 'Return a Confiscated an Inventory', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'},
}})

-- Always run this command before restarting the inventory
ESX.RegisterCommand('saveinv', 'superadmin', function(xPlayer, args, showError)
	TriggerClientEvent("linden_inventory:closeInventory", -1)
	for k,v in pairs(Inventories) do
		v.save()
		v.set('timeout', false)
	end
	Opened = {}
end, true, {help = 'Save all inventory data', validate = true, arguments = {}})

RegisterCommand('maxweight', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(args[1])
	if xPlayer then
		setMaxWeight(xPlayer, tonumber(args[2]))
	end
end, true)



-- Item dumping; it's a damn mess, but it's my mess
if Config.ItemList then
	RegisterCommand('dumpitems', function(source, args, rawCommand)
		if source == 0 then
			message('Clearing inventory items from the `items` table and building a new config - please wait', 3)
			local itemDump = {}
			local query
			local result = exports.ghmattimysql:executeSync('SELECT * FROM items', {})
			for k, v in pairs(result) do
				if v.name:find('WEAPON') or v.name:find('ammo-') then
					if not query then
						query = "DELETE FROM items WHERE name='"..v.name.."'"
					else query = query.. " OR name='"..v.name.."'" end
				elseif args[1] == 'all' or Config.ItemList[tostring(v.name)] or v.name:find('money') or v.name:find('identification') or v.name:find('GADGET_') then
					local item = Config.ItemList[v.name] or {}

					if not query then
						query = "DELETE FROM items WHERE name='"..v.name.."'"
					else query = query.. " OR name='"..v.name.."'" end

					if not v.name:find('at_') then
						local description = v.description and '\ndescription = '..v.description..',' or '\n'
						local status, defined = ''
						if item.hunger or item.thirst or item.drunk or item.stress then
							status = '			status = {'
							if item.hunger then status = status..' hunger = '..item.hunger..',' end
							if item.thirst then status = status..' thirst = '..item.thirst..',' end
							if item.stress then status = status..' stress = '..item.stress..',' end
							if item.drunk then status = status..' drunk = '..item.drunk..',' end
							status = status:sub(1, -2)..' },\n' defined = true
						end
						local anim = ''
						if item.anim then
							local bone = item.bone and ', bone = '..item.bone  or ''
							local flag = item.flags and ', flag = '..item.flags or ''
							local extra = bone .. flag
							anim = "			anim = { dict = '"..item.animDict.."', clip = '"..item.anim.."'" .. extra .." },\n" defined = true
						end
						local prop = ''
						if item.model then
							local coords = "{ x = "..item.coords.x..", y = "..item.coords.x..", y = "..item.coords.z.." }"
							local rotation = "{ x = "..item.rotation.x..", y = "..item.rotation.x..", y = "..item.rotation.z.." }"
							prop = "			prop = { model = '"..item.model.."', pos = "..coords..", rot = "..rotation.."  },\n"
							defined = true
						end
						local disable = ''
						if item.disableMove then disable = '			disable = { move = false },\n' defined = true end 
						local consume = ''
						if item.consume and item.consume ~= 1 then consume = '			consume = '..item.consume..',\n' defined = true end
						local usetime = ''
						if item.useTime then usetime = '			usetime = '..item.useTime..',\n' defined = true end
						local event = ''
						if item.event then event = '			event = true,\n' defined = true end
						local client = '}\n'
						if defined then client = '\n'..status .. anim .. prop .. disable .. usetime .. event..'		}\n' end

	table.insert(itemDump, [[
		[']]..v.name..[['] = {
			label = ']]..v.label..[[',
			weight = ]]..tonumber(v.weight)..[[,
			stack = ]]..tostring(not not v.stackable)..[[,
			close = ]]..tostring(not not v.closeonuse)..[[,]]..consume..description .. [[
			server = {},
			client = {]]..client..[[
		},

	]])
					end
				end
			end
			Citizen.Wait(100)
			if next(itemDump) then
				message('Converted '..#itemDump..' items to the new data format', 2)
				SaveResourceFile(Config.Resource, "shared/items.lua", "Items = {\n\n"..table.concat(itemDump).."}\n", -1)
				Config.ItemList = false
				exports.ghmattimysql:execute(query)
			else
				message('Failed to convert any items', 1)
			end
		end
	end, true)
end
