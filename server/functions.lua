GetPlayerIdentification = function(xPlayer)
	local sex, identifier = xPlayer.get('sex')
	if sex == 'm' then sex = 'Male' elseif sex == 'f' then sex = 'Female' end
	if Config.ShowIdentifierID then identifier = ' ('..xPlayer.getIdentifier()..')' else identifier = '' end
	return ('Sex: %s | DOB: %s%s'):format( sex, xPlayer.get('dateofbirth'), identifier )
end

is_table_equal = function(t1,t2,ignore_mt)
	local ty1 = type(t1)
	local ty2 = type(t2)
	if ty1 ~= ty2 then return false end
	-- non-table types can be directly compared
	if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
	-- as well as tables which have the metamethod __eq
	local mt = getmetatable(t1)
	if not ignore_mt and mt and mt.__eq then return t1 == t2 end
	for k1,v1 in pairs(t1) do
	   local v2 = t2[k1]
	   if v2 == nil or not is_table_equal(v1,v2) then return false end
	end
	for k2,v2 in pairs(t2) do
	   local v1 = t1[k2]
	   if v1 == nil or not is_table_equal(v1,v2) then return false end
	end
	return true
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

getInventory = function(inventory)
	local returnData = {}
	if inventory.inventory then
		local items = 0
		for k, v in pairs(inventory.inventory) do
			if v.count > 0 then
				items = items + 1
				returnData[items] = {
					name = v.name,
					count = v.count,
					metadata = v.metadata,
					slot = k
				}
			end
		end
	end
	return returnData
end

TriggerBanEvent = function(xPlayer, reason)
	print( ('^1[warning]^3 [%s] %s has attempted to cheat (%s)^7'):format(xPlayer.source, GetPlayerName(xPlayer.source), reason) )
	TriggerClientEvent('linden_inventory:closeInventory', xPlayer.source)
	-- do your ban stuff and whatever logging you want to use
	-- only trigger bans when it is guaranteed to be cheating and not desync
	if Config.Logs then exports.linden_logs:log(xPlayer, false, reason, 'ban') end
end

ValidateItem = function(type, xPlayer, fromSlot, toSlot, fromItem, toItem)
	local reason
	if not fromSlot then reason = 'source slot is empty' else
		if type ~= 'swap' and fromSlot.name ~= fromItem.name then reason = 'source slot contains different item' end
		if type == 'split' and tonumber(fromSlot.count) - tonumber(toItem.count) < 1 then reason = 'source item count has increased' end
		if tonumber(toItem.count) > (fromItem.count + toItem.count) then reason = 'new item count is higher than source item count' end
	end

	if reason then
		print( ('[%s] %s failed item validation (type: %s, fromSlot: %s, toSlot: %s, fromItem: %s, toItem: %s, reason: %s)'):format(xPlayer.source, GetPlayerName(xPlayer.source), type, fromSlot, toSlot, fromItem, toItem, reason) )
		-- failed validation can be caused by desync, so don't autoban for it
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = '(Desync) '..reason })
		TriggerClientEvent("linden_inventory:closeInventory", xPlayer.source)
		TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source])
		return false
	else return true end
end 

ItemNotify = function(xPlayer, item, count, slot, type)
	local player = Inventories[xPlayer.source]
	if Items[item.name] then TriggerClientEvent('linden_inventory:itemNotify', xPlayer.source, item, count, slot, type) end
end

SyncAccounts = function(xPlayer, name)
	local account = xPlayer.getAccount(name)
	account.money = getInventoryItem(xPlayer, name).count
	xPlayer.setAccount(account)
	xPlayer.triggerEvent('esx:setAccountMoney', account)
end

CreateNewDrop = function(xPlayer, data)
	local playerPed = GetPlayerPed(xPlayer.source)
	local playerCoords = GetEntityCoords(playerPed)
	local invid = RandomDropId()
	local invid2 = xPlayer.source
	Drops[invid] = {
		name = invid,
		inventory = {},
		slots = Config.PlayerSlots,
		coords = playerCoords,
		type = 'drop'
	}
	if data.type == 'freeslot' then
		if ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.emptyslot], Drops[invid].inventory[data.toSlot], data.item, data.item) == true then
			local count = Inventories[invid2].inventory[data.emptyslot].count
			ItemNotify(xPlayer, data.item, count, data.emptyslot, 'Removed')
			Inventories[invid2].inventory[data.emptyslot] = nil
			Drops[invid].inventory[data.toSlot] = {name = data.item.name, label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = Items[data.item.name].closeonuse}
			if Config.Logs then
				exports.linden_logs:log(xPlayer, false, 'has dropped '..data.item.count..'x '..data.item.name..' in drop-'..invid, 'items')
			end
			Opened[xPlayer.source] = nil
			TriggerClientEvent('linden_inventory:createDrop', -1, Drops[invid], xPlayer.source)
		end
	elseif data.type == 'split' then
		if ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.fromSlot], Drops[invid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) == true then
			ItemNotify(xPlayer, data.newslotItem, data.newslotItem.count, data.fromSlot, 'Removed')
			Inventories[invid2].inventory[data.fromSlot] = {name = data.oldslotItem.name, label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = Items[data.oldslotItem.name].closeonuse}
			Drops[invid].inventory[data.toSlot] = {name = data.newslotItem.name, label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = Items[data.newslotItem.name].closeonuse}
			if Config.Logs then
				exports.linden_logs:log(xPlayer, false, 'has dropped '..data.newslotItem.count..'x '..data.newslotItem.name,' in drop-'..invid, 'items')
			end
			Opened[xPlayer.source] = nil
			TriggerClientEvent('linden_inventory:createDrop', -1, Drops[invid], xPlayer.source)
		end
	end
end

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
			inventory[k] = {name = v.name, label = xItem.label, weight = xItem.weight, slot = k, count = v.count, description = xItem.description, metadata = v.metadata, stackable = xItem.stackable, price = v.price}
		end
	end
	return inventory
end

---	delete all vehicles from `linden_inventory` table where name exists more than once and owner is null (temporary)
RegisterCommand('cleanvehicles', function(source, args, rawCommand)
	if source > 0 then return end
	
	local result = exports.ghmattimysql:executeSync('SELECT name, owner FROM linden_inventory group by name having count(*) >= 2', {})
	if result then
		for k,v in pairs(result) do
			exports.ghmattimysql:scalarSync('DELETE FROM linden_inventory WHERE owner IS NULL AND name = @name', {['@name'] = v.name})
		end
	end

end, true)
---
SaveItems = function(type,id,owner)
	if id and owner == nil and (type == 'stash' or type == 'trunk' or type == 'glovebox') then
		if type ~= 'stash' then
			local plate = string.match(id, "-(.*)")
			local owner
			if Datastore[plate] then owner = false else
				local result = exports.ghmattimysql:scalarSync('SELECT owner FROM owned_vehicles WHERE plate = @plate', {
					['@plate'] = plate
				})
				if result then owner = result end
			end
			if not owner then
				if not Datastore[plate] then Datastore[plate] = {trunk = {}, glovebox = {}} end
				Datastore[plate][type] = Inventories[id].inventory
				return
			else
				local inventory = json.encode(getInventory(Inventories[id]))
				local result = exports.ghmattimysql:executeSync('SELECT * FROM linden_inventory WHERE name = @name LIMIT 1', {
					['@name'] = id
				})
				if result[1] then
					if result[1].data ~= inventory then
						exports.ghmattimysql:execute('UPDATE linden_inventory SET data = @data, owner = @owner WHERE id = @id', {
							['@id'] = result[1].id,
							['@owner'] = owner,
							['@data'] = inventory
						})
					end
				elseif inventory ~= '[]' then
					exports.ghmattimysql:execute('INSERT INTO linden_inventory (name, data, owner) VALUES (@name, @data, @owner)', {
						['@name'] = id,
						['@data'] = inventory,
						['@owner'] = owner
					})
				end
			end
		else	-- Unowned stash
			local inventory = json.encode(getInventory(Inventories[id]))
			local result = exports.ghmattimysql:scalarSync('SELECT data FROM linden_inventory WHERE name = @name', {
				['@name'] = id
			})
			if result then
				if result ~= inventory then
					exports.ghmattimysql:execute('UPDATE linden_inventory SET data = @data WHERE name = @name', {
						['@data'] = inventory,
						['@name'] = id
					})
				end
			elseif inventory ~= '[]' then
				exports.ghmattimysql:execute('INSERT INTO linden_inventory (name, data) VALUES (@name, @data)', {
					['@name'] = id,
					['@data'] = inventory
				})
			end
		end
	elseif id and owner then
		local inventory = json.encode(getInventory(Inventories[id]))
		local result = exports.ghmattimysql:executeSync('SELECT * FROM linden_inventory WHERE name = @name AND owner = @owner LIMIT 1', {
			['@name'] = id,
			['@owner'] = owner
		})
		if result[1] then
			if result[1].data ~= inventory then
				exports.ghmattimysql:execute('UPDATE linden_inventory SET data = @data WHERE id = @id', {
					['@id'] = result[1].id,
					['@data'] = inventory,
				})
			end
		elseif inventory ~= '[]' then
			exports.ghmattimysql:execute('INSERT INTO linden_inventory (name, data, owner) VALUES (@name, @data, @owner)', {
				['@name'] = id,
				['@data'] = inventory,
				['@owner'] = owner
			})
		end
	end
end

GetItems = function(id, type, owner)
	local returnData = {}
	local result
	if not owner then
		if type == 'trunk' or type == 'glovebox' then
			local plate = string.match(id, "-(.*)")
			local result = exports.ghmattimysql:scalarSync('SELECT plate, owner FROM owned_vehicles WHERE plate = @plate', {
				['@plate'] = plate
			})
			if result == nil then
				if not Datastore[plate] then
					Datastore[plate] = {trunk = {}, glovebox = {}}
					--- Temporary! Clean up vehicles with no owners
					local result = exports.ghmattimysql:scalarSync('SELECT id FROM linden_inventory WHERE name = @name', {
						['@name'] = id
					})
					if result then
						exports.ghmattimysql:scalarSync('DELETE FROM linden_inventory WHERE id = @id', {
							['@id'] = result
						})
					end
					----------------------------------------------
				end
				return Datastore[plate][type]
			end
		end
		result = exports.ghmattimysql:scalarSync('SELECT data FROM linden_inventory WHERE name = @name', {
			['@name'] = id
		})
	else
		result = exports.ghmattimysql:scalarSync('SELECT data FROM linden_inventory WHERE name = @name AND owner = @owner', {
			['@name'] = id,
			['@owner'] = owner
		})
	end
	if result ~= nil then
		local Inventory = json.decode(result)
		for k,v in pairs(Inventory) do
			if Items[v.name] then
				if v.metadata == nil then v.metadata = {} end
				returnData[v.slot] = {name = v.name , label = Items[v.name].label, weight = Items[v.name].weight, slot = v.slot, count = v.count, description = Items[v.name].description, metadata = v.metadata, stackable = Items[v.name].stackable}
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
	if Opened[id] == nil then
		Opened[id] = xPlayer.source
		return true
	end
	return false
end

ValidateString = function(item)
	item = string.lower(item)
	if item:find('weapon_') then item = string.upper(item) end
	local xItem = Items[item]
	if xItem then return xItem.name end
end
