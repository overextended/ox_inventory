GetPlayerIdentification = function(xPlayer)
	local sex, identifier = xPlayer.get('sex')
	if sex == 'm' then sex = _U('male') elseif sex == 'f' then sex = _U('female') end
	return ('Sex: %s | DOB: %s'):format( sex, xPlayer.get('dateofbirth') )
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
	local xItem = Items[item.name]
	if xPlayer and xItem then
		if type == 'removed' and item.name == 'radio' and xPlayer.getInventoryItem('radio').count <= 1 then
			--TriggerClientEvent('turnoffradio', xPlayer.source)
		end
		TriggerClientEvent('linden_inventory:itemNotify', xPlayer.source, item, count, slot, type)
	end
end

SyncAccounts = function(xPlayer, name)
	local account = xPlayer.getAccount(name)
	account.money = getInventoryItem(xPlayer, name).count
	xPlayer.setAccount(account)
	xPlayer.triggerEvent('esx:setAccountMoney', account)
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
				Drops[invid].inventory[data.toSlot] = {name = data.item.name, label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = Items[data.item.name].closeonuse}
				if Config.Logs then
					exports.linden_logs:log(xPlayer, false, 'has dropped '..data.item.count..'x '..data.item.name..' in drop-'..invid, 'items')
				end
				Opened[xPlayer.source] = nil
				TriggerClientEvent('linden_inventory:createDrop', -1, Drops[invid], xPlayer.source)
			end
		elseif data.type == 'split' then
			if ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.fromSlot], Drops[invid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) == true then
				ItemNotify(xPlayer, data.newslotItem, data.newslotItem.count, data.fromSlot, 'removed')
				Inventories[invid2].inventory[data.fromSlot] = {name = data.oldslotItem.name, label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = Items[data.oldslotItem.name].closeonuse}
				Drops[invid].inventory[data.toSlot] = {name = data.newslotItem.name, label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = Items[data.newslotItem.name].closeonuse}
				if Config.Logs then
					exports.linden_logs:log(xPlayer, false, 'has dropped '..data.newslotItem.count..'x '..data.newslotItem.name,' in drop-'..invid, 'items')
				end
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
				if v.metadata == nil then v.metadata = {} end
				Drops[invid].inventory[k] = {name = v.name , label = xItem.label, weight = xItem.weight, slot = v.slot, count = v.count, description = xItem.description, metadata = v.metadata, stackable = xItem.stackable,  closeonuse = xItem.closeonuse}
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
			inventory[k] = {name = v.name, label = xItem.label, weight = xItem.weight, slot = k, count = v.count, description = xItem.description, metadata = v.metadata, stackable = xItem.stackable, price = v.price}
		end
	end
	return inventory
end

SaveItems = function(type, id, owner, inventory)
	if type and id then
		if owner then
			if inventory then
				exports.ghmattimysql:execute('INSERT INTO linden_inventory (name, data, owner) VALUES (@name, @data, @owner) ON DUPLICATE KEY UPDATE data = @data', {
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
					if Config.TrimPlate then plate = ESX.Math.Trim(plate) end
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
				exports.ghmattimysql:execute('INSERT INTO linden_inventory (name, data, owner) VALUES (@name, @data, @owner) ON DUPLICATE KEY UPDATE data = @data', {
					['@name'] = id,
					['@data'] = inventory,
					['@owner'] = ''
				})
			end
		end
		Inventories[id] = nil
	end
end

GetItems = function(id, inv, owner)
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
					if Config.TrimPlate then plate = ESX.Math.Trim(plate) end
					local owned = exports.ghmattimysql:scalarSync('SELECT `plate` FROM `owned_vehicles` WHERE plate = @plate', {
						['@plate'] = plate
					})
					if owned == nil then
						if Config.RandomLoot then Datastore[id] = GenerateDatastore(inv) else Datastore[id] = {} end
						return Datastore[id]
					else
						result = exports.ghmattimysql:scalarSync('SELECT data FROM linden_inventory WHERE name = @name', {
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
				if Items[v.name] then
					if v.metadata == nil then v.metadata = {} end
					returnData[v.slot] = {name = v.name , label = Items[v.name].label, weight = Items[v.name].weight, slot = v.slot, count = v.count, description = Items[v.name].description, metadata = v.metadata, stackable = Items[v.name].stackable, closeonuse = Items[v.name].closeonuse}
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
