GetItems = function()
	while Status ~= 'ready' do Citizen.Wait(500) end
	return Items
end
exports('Items', GetItems)
-- Items = exports.linden_inventory:Items()

GetPlayerIdentification = function(xPlayer)
	local sex, identifier = xPlayer.get('sex')
	if sex == 'm' then sex = _U('male') elseif sex == 'f' then sex = _U('female') end
	return ('Sex: %s | DOB: %s'):format( sex, xPlayer.get('dateofbirth') )
end

GenerateText = function(numLetters)
	local blacklist = {'POL', 'EMS'}
	::begin::
	local totTxt = ""
	for i = 1,numLetters do
		totTxt = totTxt..string.char(math.random(65,90))
	end
	if blacklist[totTxt] then goto begin else return totTxt end
end

GenerateSerial = function(text)
	if not text then text = GenerateText(3) elseif string.len(text) > 3 then return text end
	local random = math.random(100000,999999)
	local random2 = math.random(100000,999999)
	local serial = ('%s%s%s'):format(random, text, random2)
	return serial
end

RandomDropId = function()
	while true do
		local random = math.random(100000,999999)
		if not Drops[random] then return random end
		Citizen.Wait(0)
	end
end

setMetadata = function(metadata)
	local data = metadata
	if data == nil then data = {}
	elseif type(data) == 'string' then return { type = data } end
	return data
end

TriggerBanEvent = function(xPlayer, reason)
	print( ('^1[warning]^3 [%s] %s has attempted to cheat (%s)^7'):format(xPlayer.source, GetPlayerName(xPlayer.source), reason) )
	TriggerClientEvent('linden_inventory:closeInventory', xPlayer.source)
	-- do your ban stuff and whatever logging you want to use
	-- only trigger bans when it is guaranteed to be cheating and not desync
end

ValidateItem = function(type, xPlayer, fromSlot, toSlot, fromItem, toItem)
	local reason
	if not fromSlot then reason = 'source slot is empty' else
		if toSlot then
			if type == 'freeslot' and fromItem.count == fromSlot.count and toItem.count == toSlot.count then	
				reason = 'item count mismatch'
			elseif type == 'split' and (fromSlot.count - fromItem.count) + (toSlot.count - toItem.count) ~= 0 then
				reason = 'item count mismatch'
			end
			if fromSlot.name ~= toItem.name or toSlot.name ~= fromItem.name then
				reason = 'item name mismatch'
			end
		else
			if fromSlot.count - fromItem.count > fromSlot.count then
				reason = 'item count mismatch'
			end
			if fromSlot.name ~= toItem.name then
				reason = 'item name mismatch'
			end
		end
	end

	if reason then
		print( ('[%s] %s failed item validation (type: %s, reason: %s)\nfromSlot: %s\ntoSlot: %s\nfromItem: %s\ntoItem: %s'):format(xPlayer.source, GetPlayerName(xPlayer.source), type, reason, json.encode(fromSlot), json.encode(toSlot), json.encode(fromItem), json.encode(toItem)) )
		-- failed validation can be caused by desync, so don't autoban for it
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = '(Desync) '..reason })
		TriggerClientEvent("linden_inventory:closeInventory", xPlayer.source)
		TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source])
		return false
	else return true end
end 

ItemNotify = function(xPlayer, item, count, slot, type)
	local xItem = Items[item.name]
	if xPlayer and xItem then
		if type == 'removed' and item.name == 'radio' and xPlayer.getInventoryItem('radio').count <= 1 then
			--TriggerClientEvent('turnoffradio', xPlayer.source)
		end
		TriggerClientEvent('linden_inventory:itemNotify', xPlayer.source, item, count, slot, type)
	end
end

CreateNewDrop = function(xPlayer, data)
	if data.type ~= 'create' then
		local playerPed = GetPlayerPed(xPlayer.source)
		local playerCoords = GetEntityCoords(playerPed)
		local invid = RandomDropId()
		local invid2 = xPlayer.source
		Drops[invid] = {
			id = invid,
			inventory = {},
			slots = Config.PlayerSlots,
			coords = playerCoords,
			type = 'drop'
		}
		if data.type == 'freeslot' then
			if ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.emptyslot], Drops[invid].inventory[data.toSlot], data.item, data.item) == true then
				local count = Inventories[invid2].inventory[data.emptyslot].count
				ItemNotify(xPlayer, data.item, count, data.emptyslot, 'removed')
				Inventories[invid2].inventory[data.emptyslot] = nil
				Drops[invid].inventory[data.toSlot] = {name = data.item.name, label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stack = data.item.stack, close = Items[data.item.name].close}
				if Config.Logs then CreateLog(xPlayer.source, false, 'has dropped '..data.item.count..'x '..data.item.name..' in '..invid, 'drop') end
				Opened[xPlayer.source] = nil
				TriggerClientEvent('linden_inventory:createDrop', -1, Drops[invid], xPlayer.source)
			end
		elseif data.type == 'split' then
			if ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.fromSlot], Drops[invid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) == true then
				ItemNotify(xPlayer, data.newslotItem, data.newslotItem.count, data.fromSlot, 'removed')
				Inventories[invid2].inventory[data.fromSlot] = {name = data.oldslotItem.name, label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stack = data.oldslotItem.stack, close = Items[data.oldslotItem.name].close}
				Drops[invid].inventory[data.toSlot] = {name = data.newslotItem.name, label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stack = data.newslotItem.stack, close = Items[data.newslotItem.name].close}
				if Config.Logs then CreateLog(xPlayer.source, false, 'has dropped '..data.newslotItem.count..'x '..data.newslotItem.name,' in '..invid, 'drop') end
				Opened[xPlayer.source] = nil
				TriggerClientEvent('linden_inventory:createDrop', -1, Drops[invid], xPlayer.source)
			end
		end
	else -- Use this to allow the server to create drops
		local invid = data.label..'-'..RandomDropId()
		Drops[invid] = {
			id = invid,
			inventory = {},
			slots = #data.inventory+4,
			coords = data.coords,
			type = 'drop'
		}
		for k,v in pairs(data.inventory) do
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
				Drops[invid].inventory[k] = {name = v.name , label = xItem.label, weight = weight, slot = v.slot, count = v.count, description = xItem.description, metadata = v.metadata, stack = xItem.stack,  close = xItem.close}
			end
		end
		TriggerClientEvent('linden_inventory:createDrop', -1, Drops[invid])
	end
end
exports('CreateNewDrop', CreateNewDrop)

local randomPrice = function(price)
	local random = math.random(95,107)
	return math.floor((random / 100) * price + 0.5)
end

local SetupShops = function()
	for k,v in pairs(Config.Shops) do
		v.store = v.type or Config.General
		if Config.RandomPrices then
			local inventory = v.store.inventory
			for i=1, #inventory do
				inventory[i].price = randomPrice(inventory[i].price)
			end
		end
	end
end
SetupShops()

SetupShopItems = function(shop)
	local inventory = {}
	for k, v in pairs(Config.Shops[shop].store.inventory) do
		local xItem = Items[v.name]
		if xItem then
			if v.metadata == nil then v.metadata = {} end
			inventory[k] = {name = v.name, label = xItem.label, weight = xItem.weight, slot = k, count = v.count, description = xItem.description, metadata = v.metadata, stack = xItem.stack, price = v.price}
		end
	end
	return inventory
end

SaveItems = function(type, id, owner, inventory)
	if type and id then
		if owner then
			if inventory then
				exports.ghmattimysql:execute('INSERT INTO `linden_inventory` (name, data, owner) VALUES (@name, @data, @owner) ON DUPLICATE KEY UPDATE data = @data', {
					['@name'] = id,
					['@data'] = inventory,
					['@owner'] = owner
				})
			end
		else
			if type == 'trunk' or type == 'glovebox' then
				if Datastore[id] then
					Datastore[id] = Inventories[id].inventory
				else
					local plate = string.match(id, "-(.*)")
					if Config.TrimPlate then plate = func.trim(plate) end
					local result = exports.ghmattimysql:scalarSync('SELECT `owner` from `owned_vehicles` WHERE `plate` = @plate', {
						['@plate'] = plate
					})
					if result then
						if inventory then
							exports.ghmattimysql:execute('INSERT INTO `linden_inventory` (name, data, owner) VALUES (@name, @data, @owner) ON DUPLICATE KEY UPDATE data = @data', {
								['@name'] = id,
								['@data'] = inventory,
								['@owner'] = result
							})
						end
					else
						if not Datastore[plate] then Datastore[plate] = {trunk = {}, glovebox = {}} end
						Datastore[plate][type] = Inventories[id].inventory
					end
				end
			elseif type == 'dumpster' then
				Datastore[id] = Inventories[id].inventory
			else
				exports.ghmattimysql:execute('INSERT INTO `linden_inventory` (name, data, owner) VALUES (@name, @data, @owner) ON DUPLICATE KEY UPDATE data = @data', {
					['@name'] = id,
					['@data'] = inventory,
					['@owner'] = ''
				})
			end
		end
	end
end

GetInventory = function(id, inv, owner)
	local returnData, result = {}
	if id and inv then
		if owner then
			result = exports.ghmattimysql:scalarSync('SELECT `data` FROM `linden_inventory` WHERE `name` = @name AND owner = @owner', {
				['@name'] = id,
				['@owner'] = owner
			})
		else
			if inv == 'trunk' or inv == 'glovebox' then
				local data = Datastore[id]
				if data then
					return data
				else
					local plate = string.match(id, "-(.*)")
					if Config.TrimPlate then plate = func.trim(plate) end
					local owned = exports.ghmattimysql:scalarSync('SELECT `plate` FROM `owned_vehicles` WHERE plate = @plate', {
						['@plate'] = plate
					})
					if owned == nil then
						if Config.RandomLoot then Datastore[id] = GenerateDatastore(inv) else Datastore[id] = {} end
						return Datastore[id]
					else
						result = exports.ghmattimysql:scalarSync('SELECT data FROM `linden_inventory` WHERE name = @name', {
							['@name'] = id
						})
					end
				end
			elseif inv == 'dumpster' then
				if Datastore[id] then return Datastore[id] else
					if Config.RandomLoot then Datastore[id] = GenerateDatastore(inv) else Datastore[id] = {} end
					return Datastore[id]
				end
			else
				result = exports.ghmattimysql:scalarSync('SELECT `data` FROM `linden_inventory` WHERE name = @name', {
					['@name'] = id
				})
			end
		end

		if result ~= nil then
			local Inventory = json.decode(result)
			for k,v in pairs(Inventory) do
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
					returnData[v.slot] = {name = v.name , label = xItem.label, weight = weight, slot = v.slot, count = v.count, description = xItem.description, metadata = v.metadata, stack = xItem.stack, close = xItem.close}
				end
			end
		end
	end
	return returnData
end

CheckOpenable = function(xPlayer, id, coords)
	if coords then
		local srcCoords = GetEntityCoords(GetPlayerPed(xPlayer.source))
		if #(coords - srcCoords) > 2 then return false end
	end
	if Inventories[id].open == false then
		Inventories[id].open = xPlayer.source
		return true
	else
		return false
	end
end

ValidateString = function(item)
	item = string.lower(item)
	if item:find('weapon_') then item = string.upper(item) end
	local xItem = Items[item]
	if xItem then return xItem.name end
end
