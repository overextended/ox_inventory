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
	if not text then text = GenerateText(3) end
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
	if data == nil then return {}
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
		-- currently have a bug where moving items around while also adding/removing items can result in client-sided item duplication
		-- item validation should not be used to ban until all bugs are dealt with
		-- for now, close inventory and refresh items
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = '(Desync) Inventory was refreshed' })
		TriggerClientEvent("linden_inventory:closeInventory", xPlayer.source)
		return false
	else return true end
end 

ItemNotify = function(xPlayer, item, count, type, invid)
	local xItem = Items[item]
	local notification
	if count > 0 then
		notification = ('%s %sx'):format(type, count)
		if Config.Logs then
			-- todo
		end
		if item:find('money') then SyncAccounts(xPlayer, item) end
	else notification = 'Used' end
	TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source], xItem, notification )
end

SyncAccounts = function(xPlayer, name)
	local account = xPlayer.getAccount(name)
	account.money = getInventoryItem(xPlayer, name).count
	xPlayer.setAccount(account)
	xPlayer.triggerEvent('esx:setAccountMoney', account)
end

AddPlayerInventory = function(xPlayer, item, count, metadata, slot)
	local xItem = Items[item]
	if xPlayer and xItem and count > 0 then
		if slot then slot = getPlayerSlot(xPlayer, slot) end
		local toSlot, existing
		if slot == nil then
			for i=1, Config.PlayerSlots do
				if xItem.stackable == 1 and Inventories[xPlayer.source].inventory[i] and Inventories[xPlayer.source].inventory[i].name == item then toSlot = i existing = true break
				elseif Inventories[xPlayer.source].inventory[i] == nil then toSlot = i existing = false break end
			end
			slot = toSlot
		end
		if item:find('WEAPON_') then
			xItem.stackable = false
			if Config.Throwable[item] then
				metadata = {throwable=1}
				xItem.stackable = true
			elseif Config.Melee[item] or Config.Miscellaneous[item] then
				count = 1
				metadata = {}
				if not metadata.durability then metadata.durability = 100 end
			else
				count = 1
				if type(metadata) ~= 'table' then metadata = {} end
				if not metadata.durability then metadata.durability = 100 end
				if xItem.ammoType then metadata.ammo = 0 end
				if not metadata.components then metadata.components = {} end
				metadata.serial = GenerateSerial(metadata.serial)
				if metadata.registered == true then metadata.registered = xPlayer.getName() end
			end
			Inventories[xPlayer.source].inventory[slot] = {name = item, label = xItem.label, weight = xItem.weight, slot = slot, count = count, description = xItem.description, metadata = metadata, stackable = xItem.stackable, closeonuse = true}
			if xItem.ammoType thenInventories[xPlayer.source].inventory[slot].ammoType = xItem.ammoType end
			Inventories[xPlayer.source].weight = Inventories[xPlayer.source].weight + (xItem.weight * count)
			return ItemNotify(xPlayer, item, count, 'Added')
		elseif item:find('identification') then
			count = 1
			metadata = {}
			metadata.type = xPlayer.getName()
			metadata.description = GetPlayerIdentification(xPlayer)
			local added = count
			if existing then count = Inventories[xPlayer.source].inventory[slot].count + count end
			Inventories[xPlayer.source].inventory[slot] = {name = item, label = xItem.label, weight = xItem.weight, slot = slot, count = count, description = xItem.description, metadata = metadata, stackable = xItem.stackable, closeonuse = true}
			Inventories[xPlayer.source].weight = Inventories[xPlayer.source].weight + (xItem.weight * count)
			return ItemNotify(xPlayer, item, added, 'Added')
		else
			if metadata == 'setname' then metadata = {description = xPlayer.getName()} else metadata = setMetadata(metadata) end
			local added = count
			if existing then count = Inventories[xPlayer.source].inventory[slot].count + count end
			Inventories[xPlayer.source].inventory[slot] = {name = item, label = xItem.label, weight = xItem.weight, slot = slot, count = count, description = xItem.description, metadata = metadata, stackable = xItem.stackable, closeonuse = xItem.closeonuse}
			Inventories[xPlayer.source].weight = Inventories[xPlayer.source].weight + (xItem.weight * count)
			return ItemNotify(xPlayer, item, added, 'Added')
		end
	end
end

RemovePlayerInventory = function(xPlayer, item, count, metadata, slot)
	local xItem = Items[item]
	if xPlayer and xItem and count > 0 then
		metadata = setMetadata(metadata)
		if slot and Inventories[xPlayer.source].inventory[slot].count == count then
			Inventories[xPlayer.source].inventory[slot] = nil
			Inventories[xPlayer.source].weight = Inventories[xPlayer.source].weight - (xItem.weight * count)
			ItemNotify(xPlayer, item, count, 'Removed')
		elseif slot and Inventories[xPlayer.source].inventory[slot].count > count then
			Inventories[xPlayer.source].inventory[slot] = {name = item, label = xItem.label, weight = xItem.weight, slot = slot, count = count, description = xItem.description, metadata = metadata, stackable = xItem.stackable, closeonuse = xItem.closeonuse}
			Inventories[xPlayer.source].weight = Inventories[xPlayer.source].weight - (xItem.weight * count)
			ItemNotify(xPlayer, item, count, 'Removed')
		else
			local itemSlots = getInventoryItemSlots(xPlayer, item, metadata)
			if itemSlots then
				if count > itemSlots.total then count = itemSlots.total end
				local removed, total = 0, count
				for k, v in pairs(itemSlots.slot) do -- k = slot, v = count
					if removed < total then
						if v == count then
							removed = total
							Inventories[xPlayer.source].inventory[k] = nil
						elseif v > count then
							removed = total
							count = v - count
							Inventories[xPlayer.source].inventory[k] = {name = item, label = xItem.label, weight = xItem.weight, slot = k, count = count, description = xItem.description, metadata = metadata, stackable = xItem.stackable, closeonuse = xItem.closeonuse}
						else -- v < count
							removed = v
							count = count - v
							Inventories[xPlayer.source].inventory[k] = nil
						end
					end
				end
				Inventories[xPlayer.source].weight = Inventories[xPlayer.source].weight + (xItem.weight * removed)
				ItemNotify(xPlayer, item, removed, 'Removed')
			end
		end
	end
end

CreateNewDrop = function(xPlayer, data)
	local playerPed = GetPlayerPed(xPlayer.source)
	local playerCoords = GetEntityCoords(playerPed)
	local invid = RandomDropId()
	local invid2 = xPlayer.source
	Drops[invid] = {
		name = invid,
		inventory = {},
		slots = 51,
		coords = playerCoords
	}
	if data.type == 'swap' then
		if not ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.fromSlot], Drops[invid].inventory[data.toSlot], data.fromItem, data.toItem) then return end
		Drops[invid].inventory[data.toSlot] = {name = data.toItem.name, label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = Items[data.toItem.name].closeonuse}
		Inventories[invid2].inventory[data.fromSlot] = {name = data.fromItem.name, label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = Items[data.fromItem.name].closeonuse}
		ItemNotify(xPlayer, data.toItem.name, data.toItem.count, 'Removed', invid)
		ItemNotify(xPlayer, data.fromItem.name, data.fromItem.count, 'Added', invid)
	elseif data.type == 'freeslot' then
		if not ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.emptyslot], Drops[invid].inventory[data.toSlot], data.item, data.item) then return end
		local count = Inventories[invid2].inventory[data.emptyslot].count
		Inventories[invid2].inventory[data.emptyslot] = nil
		Drops[invid].inventory[data.toSlot] = {name = data.item.name, label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = Items[data.item.name].closeonuse}
		ItemNotify(xPlayer, data.item.name, count, 'Removed', invid)
	elseif data.type == 'split' then
		if not ValidateItem(data.type, xPlayer, Inventories[invid2].inventory[data.fromSlot], Drops[invid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) then return end
		Inventories[invid2].inventory[data.fromSlot] = {name = data.oldslotItem.name, label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = Items[data.oldslotItem.name].closeonuse}
		Drops[invid].inventory[data.toSlot] = {name = data.newslotItem.name, label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = Items[data.newslotItem.name].closeonuse}
		ItemNotify(xPlayer, data.newslotItem.name, data.newslotItem.count, 'Removed', invid)
	end
	TriggerClientEvent('linden_inventory:createDrop', -1, Drops[invid], xPlayer.source)
end

--[[local randomPrice = function(price)
	local random = math.random(95,107)
	return math.floor((random / 100) * price + 0.5)
end]]

local SetupShops = function()
	for k,v in pairs(Config.Shops) do
		--[[for i=1, #inventory do
			inventory[i].price = randomPrice(inventory[i].price)
		end]]
		v.store = v.type or Config.General
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

SaveItems = function(type,id)
	if id and (type == 'stash' or type == 'trunk' or type == 'glovebox') then
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
end

GetItems = function(id)
	local returnData = {}
	local result = exports.ghmattimysql:scalarSync('SELECT data FROM linden_inventory WHERE name = @name', {
		['@name'] = id
	})
	if result ~= nil then
		local Inventory = json.decode(result)
		for k,v in pairs(Inventory) do
			if v.metadata == nil then v.metadata = {} end
			returnData[v.slot] = {name = v.name ,label = Items[v.name].label, weight = Items[v.name].weight, slot = v.slot, count = v.count, description = Items[v.name].description, metadata = v.metadata, stackable = Items[v.name].stackable}
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

GetPlayerIdentification = function(xPlayer)
	return ('Sex: %s | DOB: %s (%s)'):format( xPlayer.get('sex'), xPlayer.get('dateofbirth'), xPlayer.getIdentifier() )
end

ValidateString = function(item)
	item = string.lower(item)
	if item:find('weapon_') then item = string.upper(item) end
	local xItem = Items[item]
	if xItem then return xItem.name end
end

UseItem = function(xPlayer, item)
	if Config.ItemList[item.name] then
		if next(Config.ItemList[item.name]) == nil then return end
		TriggerClientEvent('linden_inventory:useItem', xPlayer.source, item)
	elseif ESX.UsableItemsCallbacks[item.name] ~= nil then
		TriggerEvent('esx:useItem', xPlayer.source, item.name)
	elseif type(item) ~= 'table' then
		TriggerEvent('esx:useItem', xPlayer.source, item)
	end
end
