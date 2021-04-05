ESX = nil
local oneSync
local playerInventory = {}
local Stashes = {}
local Drops = {}
local ESXItems = {}
local Shops = {}
local invopened = {}
local openedinventories = {}
local Gloveboxes = {}
local Trunks = {}
local notready = true
if GetConvar('onesync_enableInfinity', false) == 'true' or GetConvar('onesync_enabled', false) == 'true' then oneSync = true end

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('hsn-inventory:getData',function(source, cb)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local data = {name = xPlayer.getName(), inventory = playerInventory[xPlayer.identifier], oneSync = oneSync}
	cb(data)
end)

exports.ghmattimysql:ready(function()
	local placeholder = ('^1[hsn-inventory]^3 Item `%s` is missing from your database! Item has been created with placeholder data.^7')
	--local placeholder = ("	('%s', '%s', 5, 0, 1, 1, 1, null),")
	exports.ghmattimysql:execute('SELECT * FROM items', {}, function(result)
		for k,v in ipairs(result) do
			ESXItems[v.name] = {
				name = v.name,
				label = v.label,
				weight = v.weight,
				stackable = v.stackable,
				description = v.description,
				closeonuse = v.closeonuse
			}
		end
		for k,v in pairs(Config.ItemList) do
			if not ESXItems[k] then
				if not k:find('at_') then print( placeholder:format(k) ) end
				ESXItems[k] = {
					name = k,
					label = k,
					weight = 1,
					stackable = 1,
					description = 'Item is not loaded in SQL',
					closeonuse = 1
				}
			end
		end
		for k,v in pairs(Config.DurabilityDecreaseAmount) do
			if not ESXItems[k] then
				print( placeholder:format(k) )
				ESXItems[k] = {
					name = k,
					label = k,
					weight = 1,
					stackable = 1,
					description = 'Item is not loaded in SQL',
					closeonuse = 0
				}
			end
		end
		for k,v in pairs(Config.Ammos) do
			if not ESXItems[k] then
				print( placeholder:format(k) )
				ESXItems[k] = {
					name = k,
					label = k,
					weight = 1,
					stackable = 1,
					description = 'Item is not loaded in SQL',
					closeonuse = 0
				}
			end
		end
		print('^1[hsn-inventory]^2 Items have been created!^7')
		if not oneSync then print('^1[hsn-inventory]^3 OneSync is not enabled, some features may not work - please enable OneSync Legacy or Infinity^7') end
		notready = nil
	end)
end)

IfInventoryCanCarry = function(inventory, maxweight, newWeight)
	newWeight = tonumber(newWeight)
	local weight = 0
	local returnData = false
	if inventory ~= nil then
		for k, v in pairs(inventory) do
			weight = weight + (v.weight * v.count)
		end
		if weight + newWeight <= maxweight then
			returnData = true
		end
	end
	return returnData
end

function doText(numLetters)
	local blacklist = {'POL', 'EMS'}
	::begin::
    local totTxt = ""
    for i = 1,numLetters do
        totTxt = totTxt..string.char(math.random(65,90))
    end
	if blacklist[totTxt] then goto begin else return totTxt end
end

GetRandomSerial = function(text)
	if not text then text = doText(3) end
	local random = math.random(111111,999999)
	local random2 = math.random(111111,999999)
	local serial = ('%s%s%s'):format(random, text, random2)
	return serial
end

GetItemsSlot = function(inventory, name, metadata)
	local returnData = {}
	for k,v in pairs(inventory) do
		if v.name == name then
			table.insert(returnData,v)
		end
	end
	return returnData
end


GetItemCount = function(identifier, item, metadata)
	local count = 0
	metadata = setMetadata(metadata)
	for i,j in pairs(playerInventory[identifier]) do
		if (j.name == item) and (not metadata or is_table_equal(metadata, j.metadata)) then
			count = count + j.count
		end
	end
	return count
end

AddPlayerInventory = function(identifier, item, count, slot, metadata)
	if playerInventory[identifier] == nil then
		playerInventory[identifier] = {}
	end
	count = tonumber(count)
	local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
	if ESXItems[item] ~= nil then
		if item ~= nil and count ~= nil then
			if item:find('WEAPON_') then		
				for i = 1, Config.PlayerSlot do
					if playerInventory[identifier][i] == nil then
						local stacks = false
						if Config.Throwable[item] then
							metadata = {throwable=1}
							stacks = true
						elseif Config.Melee[item] or Config.Miscellaneous[item] then
							count = 1 
							metadata = {}
							stacks = false
							if not metadata.durability then metadata.durability = 100 end
						elseif Config.Miscellaneous[item] then
							count = 1
							stacks = false
							if not metadata.durability then metadata.durability = 100 end
						else
							count = 1 
							if type(metadata) ~= 'table' then metadata = {} end
							if not metadata.durability then metadata.durability = 100 end
							if not metadata.ammo then metadata.ammo = 0 end
							if not metadata.components then metadata.components = {} end
							if not metadata.ammoweight then metadata.ammoweight = 0 end
							metadata.serial = GetRandomSerial(metadata.serial)
							if metadata.registered == 'setname' then metadata.registered = xPlayer.getName() end
						end
						playerInventory[identifier][i] = {name = item ,label = ESXItems[item].label , weight = ESXItems[item].weight, slot = i, count = count, description = ESXItems[item].description, metadata = metadata, stackable = stacks, closeonuse = ESXItems[item].closeonuse} -- because weapon :)
						break
					end
				end
			elseif item:find('identification') then
				count = 1 
				for i = 1, Config.PlayerSlot do
					if playerInventory[identifier][i] == nil then
						metadata = {}
						metadata.type = xPlayer.getName()
						metadata.description = getPlayerIdentification(xPlayer)
						playerInventory[identifier][i] = {name = item ,label = ESXItems[item].label , weight = ESXItems[item].weight, slot = i, count = count, description = ESXItems[item].description, metadata = metadata, stackable = true, closeonuse = ESXItems[item].closeonuse}
						break
					end
				end
			else
				if metadata == 'setname' then metadata = {description = xPlayer.getName()} else metadata = setMetadata(metadata) end
				if slot then
					playerInventory[identifier][slot] = {name = item ,label = ESXItems[item].label, weight = ESXItems[item].weight, slot = i, count = count, description = ESXItems[item].description, metadata = metadata, stackable = ESXItems[item].stackable, closeonuse = ESXItems[item].closeonuse}
				else
					for i = 1, Config.PlayerSlot do
						if playerInventory[identifier][i] ~= nil and playerInventory[identifier][i].name == item and (is_table_equal(metadata, playerInventory[identifier][i].metadata)) then
							playerInventory[identifier][i] = {name = item ,label = ESXItems[item].label, weight = ESXItems[item].weight, slot = i, count = playerInventory[identifier][i].count + count, description = ESXItems[item].description, metadata = metadata, stackable = ESXItems[item].stackable, closeonuse = ESXItems[item].closeonuse}
							break
						else
							if playerInventory[identifier][i] == nil then
								playerInventory[identifier][i] = {name = item ,label = ESXItems[item].label, weight = ESXItems[item].weight, slot = i, count =  count, description = ESXItems[item].description, metadata = metadata, stackable = ESXItems[item].stackable, closeonuse = ESXItems[item].closeonuse}
								break
							end
						end
					end
				end
			end
			TriggerClientEvent('hsn-inventory:client:refreshInventory',xPlayer.source,playerInventory[xPlayer.identifier])
		end
	else
		print('[^2hsn-inventory^0] - item not found')
	end
end

function setMetadata(metadata)
	local data = metadata
	if data == nil then return {}
	elseif type(data) == 'string' then return { type = data } end
	return data
end

function is_table_equal(t1,t2,ignore_mt)
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

RemovePlayerInventory = function(src, identifier, item, count, slot, metadata)
	count = tonumber(count)
	if ESXItems[item] ~= nil then
		if slot then metadata = nil elseif metadata then metadata = setMetadata(metadata) end
		local weapon = false
		if item:find('WEAPON_') then weapon = true end
		for i = 1, Config.PlayerSlot do
			if playerInventory[identifier][i] ~= nil and playerInventory[identifier][i].name == item then
				if not metadata or is_table_equal(playerInventory[identifier][i].metadata, metadata) then
					if playerInventory[identifier][i].count > count then
						playerInventory[identifier][i].count = playerInventory[identifier][i].count - count
						ItemNotify(src, item, count, 'Removed')
						if weapon then TriggerClientEvent('hsn-inventory:client:checkweapon',src,playerInventory[xPlayer.identifier][i]) end
						break
					elseif playerInventory[identifier][i].count == count and (not durability or durability == playerInventory[identifier][i].metadata.durability) then
						playerInventory[identifier][i] = nil
						ItemNotify(src, item, count, 'Removed')
						if weapon then TriggerClientEvent('hsn-inventory:client:checkweapon',src,playerInventory[xPlayer.identifier][i]) end
						break
					elseif playerInventory[identifier][i].count < count then
						local slots = GetItemsSlot(playerInventory[identifier], item, metadata)
						local tempCount = 0
						for i,j in pairs(slots) do
							if j ~= nil and (not metadata or is_table_equal(metadata, playerInventory[identifier][j.slot].metadata)) then
								j.count = tonumber(j.count)
								if j.count - count < 0 then
									tempCount = playerInventory[identifier][j.slot].count
									playerInventory[identifier][j.slot] = nil
									count = count - tempCount
								elseif j.count - count > 0 then
									playerInventory[identifier][j.slot].count = playerInventory[identifier][j.slot].count - count
								elseif j.count - count == 0 then
									playerInventory[identifier][j.slot] = nil
								end
							end
						end
						totalCount = count + tempCount
						ItemNotify(src, item, totalCount, 'Removed')
						break
					end
				end
			end
		end
	end
end

RandomDropId = function()
	while true do
		local random = math.random(11111,99999)
		if not Drops[random] then return random end
		Citizen.Wait(5)
	end
end

function TriggerBanEvent(xPlayer, reason)
	print( ('^1[hsn-inventory]^3 [%s] %s has attempted to cheat in items (%s)^7'):format(xPlayer.source, GetPlayerName(xPlayer.source), reason) )
	TriggerClientEvent("hsn-inventory:client:closeInventory",xPlayer.source,invopened[xPlayer.source].curInventory)
	-- do your ban stuff and whatever logging you want to use
	-- only trigger bans when it is guaranteed to be cheating and not desync
end

function ValidateItem(type, xPlayer, fromSlot, toSlot, fromItem, toItem)
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
		TriggerClientEvent('hsn-inventory:notification',xPlayer.source,'Inventory has been refreshed (desync)',2)
		if invopened[xPlayer.source] then
			TriggerClientEvent("hsn-inventory:client:closeInventory",xPlayer.source,invopened[xPlayer.source].curInventory)
		else
			TriggerClientEvent("hsn-inventory:client:closeInventory",xPlayer.source,nil)
		end
		return false
	else return true end
end 

RegisterNetEvent('hsn-inventory:server:saveInventoryData')
AddEventHandler('hsn-inventory:server:saveInventoryData',function(data)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if data ~= nil then
		if data.frominv == data.toinv and (data.frominv == 'Playerinv') then
			if data.type == 'swap' then
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.fromItem)
				if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.fromSlot], playerInventory[xPlayer.identifier][data.toSlot], data.fromItem, data.toItem) then return end
				playerInventory[xPlayer.identifier][data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
				playerInventory[xPlayer.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable}
			elseif data.type == 'freeslot' then
				if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.emptyslot],playerInventory[xPlayer.identifier][data.toSlot], data.item, data.item) then return end
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.item)
				playerInventory[xPlayer.identifier][data.emptyslot] = nil
				playerInventory[xPlayer.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
			elseif data.type == 'split' then
				if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.fromSlot],playerInventory[xPlayer.identifier][data.toSlot], data.oldslotItem, data.newslotItem) then return end
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.oldslotItem)
				playerInventory[xPlayer.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
				playerInventory[xPlayer.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
			end
		elseif data.frominv == data.toinv and (data.frominv == 'drop') then
			local dropid = data.invid
			if not Drops[dropid] then TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[xPlayer.identifier]) return end
			if data.type == 'swap' then
				if not ValidateItem(data.type, xPlayer, Drops[dropid].inventory[data.fromSlot], Drops[dropid].inventory[data.toSlot], data.fromItem, data.toItem) then return end
				Drops[dropid].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
				Drops[dropid].inventory[data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable,closeonuse = ESXItems[data.fromItem.name].closeonuse}
			elseif data.type == 'freeslot' then
				if not ValidateItem(data.type, xPlayer, Drops[dropid].inventory[data.emptyslot], Drops[dropid].inventory[data.toSlot], data.item, data.item) then return end
				Drops[dropid].inventory[data.emptyslot] = nil
				Drops[dropid].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
			elseif data.type == 'split' then
				if not ValidateItem(data.type, xPlayer, Drops[dropid].inventory[data.fromSlot],Drops[dropid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) then return end
				Drops[dropid].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
				Drops[dropid].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
			end
		elseif data.frominv == data.toinv and (data.frominv == 'TargetPlayer') then
			local playerId = string.gsub(data.invid, 'Player', '')
			local xTarget = ESX.GetPlayerFromId(playerId)
				if xTarget and playerInventory[xTarget.identifier] ~= nil then
					if data.type == 'swap' then
						if not ValidateItem(data.type, xPlayer, playerInventory[xTarget.identifier][data.fromSlot], playerInventory[xTarget.identifier][data.toSlot], data.fromItem, data.toItem) then return end
						playerInventory[xTarget.identifier][data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
						playerInventory[xTarget.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable,closeonuse = ESXItems[data.fromItem.name].closeonuse}
					elseif data.type == 'freeslot' then
						if not ValidateItem(data.type, xPlayer, playerInventory[xTarget.identifier][data.emptyslot],playerInventory[xTarget.identifier][data.toSlot], data.item, data.item) then return end
						playerInventory[xTarget.identifier][data.emptyslot] = nil
						playerInventory[xTarget.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
					elseif data.type == 'split' then
						if not ValidateItem(data.type, xPlayer, playerInventory[xTarget.identifier][data.fromSlot],playerInventory[xTarget.identifier][data.toSlot], data.oldslotItem, data.newslotItem) then return end
						playerInventory[xTarget.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
						playerInventory[xTarget.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
					end
					TriggerClientEvent('hsn-inventory:client:refreshInventory',xTarget.source,playerInventory[xTarget.identifier])
				end
		elseif data.frominv ~= data.toinv and (data.toinv == 'TargetPlayer' and data.frominv == 'Playerinv') then
			local playerId = string.gsub(data.invid, 'Player', '')
			local xTarget = ESX.GetPlayerFromId(playerId)
			if xTarget and playerInventory[xTarget.identifier] ~= nil then
				if data.type == 'swap' then
					if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.fromSlot], playerInventory[xTarget.identifier][data.toSlot], data.fromItem, data.toItem) then return end
					if IfInventoryCanCarry(playerInventory[xTarget.identifier],Config.MaxWeight, (data.toItem.weight * data.toItem.count)) then
						TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.toItem)
						playerInventory[xTarget.identifier][data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
						playerInventory[xPlayer.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
						ItemNotify(src,data.toItem.name,data.toItem.count,'Removed', data.invid)
						ItemNotify(src,data.fromItem.name,data.fromItem.count,'Added', data.invid)
						ItemNotify(xTarget.source,data.toItem.name,data.toItem.count,'Added', 'Player'..src)
						ItemNotify(xTarget.source,data.fromItem.name,data.fromItem.count,'Removed', 'Player'..src)
						TriggerClientEvent('hsn-inventory:client:refreshInventory',xTarget.source,playerInventory[xTarget.identifier])
					else
						TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
					end
				elseif data.type == 'freeslot' then
					if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.emptyslot],playerInventory[xTarget.identifier][data.toSlot], data.item, data.item) then return end
					if IfInventoryCanCarry(playerInventory[xTarget.identifier],Config.MaxWeight, (data.item.weight * data.item.count))  then
						TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.item)
						local count = playerInventory[xPlayer.identifier][data.emptyslot].count
						playerInventory[xPlayer.identifier][data.emptyslot] = nil
						playerInventory[xTarget.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
						ItemNotify(src,data.item.name,count,'Removed', data.invid)
						ItemNotify(xTarget.source,data.item.name,count,'Added', 'Player'..src)
						TriggerClientEvent('hsn-inventory:client:refreshInventory',xTarget.source,playerInventory[xTarget.identifier])
					else
						TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
					end
				elseif data.type == 'split' then
					if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.fromSlot],playerInventory[xTarget.identifier][data.toSlot], data.oldslotItem, data.newslotItem) then return end
					if IfInventoryCanCarry(playerInventory[xTarget.identifier],Config.MaxWeight, (data.newslotItem.weight * data.newslotItem.count))  then
						TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.newslotItem)
						playerInventory[xPlayer.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
						playerInventory[xTarget.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
						ItemNotify(src,data.newslotItem.name,data.newslotItem.count,'Removed', data.invid)
						ItemNotify(xTarget.source,data.newslotItem.name,data.newslotItem.count,'Added', 'Player'..src)
						TriggerClientEvent('hsn-inventory:client:refreshInventory',xTarget.source,playerInventory[xTarget.identifier])
					else
						TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
					end
				end
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'Playerinv' and data.frominv == 'TargetPlayer') then
			local playerId = string.gsub(data.invid2, 'Player', '')
			local xTarget = ESX.GetPlayerFromId(playerId)
			if xTarget and playerInventory[xTarget.identifier] ~= nil then
				if data.type == 'swap' then
					if not ValidateItem(data.type, xPlayer, playerInventory[xTarget.identifier][data.fromSlot], playerInventory[xPlayer.identifier][data.toSlot], data.fromItem, data.toItem) then return end
					if IfInventoryCanCarry(playerInventory[xPlayer.identifier],Config.MaxWeight, (data.toItem.weight * data.toItem.count)) then
						TriggerClientEvent('hsn-inventory:client:checkweapon',xTarget.source,data.toItem)
						playerInventory[xPlayer.identifier][data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
						playerInventory[xTarget.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
						ItemNotify(src,data.toItem.name,data.toItem.count,'Added', data.invid2)
						ItemNotify(src,data.fromItem.name,data.fromItem.count,'Removed', data.invid2)
						ItemNotify(xTarget.source,data.toItem.name,data.toItem.count,'Removed', 'Player'..src)
						ItemNotify(xTarget.source,data.fromItem.name,data.fromItem.count,'Removed', 'Player'..src)
						TriggerClientEvent('hsn-inventory:client:refreshInventory',xTarget.source,playerInventory[xTarget.identifier])
					else
						TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
					end
				elseif data.type == 'freeslot' then
					if not ValidateItem(data.type, xPlayer, playerInventory[xTarget.identifier][data.emptyslot],playerInventory[xPlayer.identifier][data.toSlot], data.item, data.item) then return end
					if IfInventoryCanCarry(playerInventory[xPlayer.identifier],Config.MaxWeight, (data.item.weight * data.item.count))  then
						TriggerClientEvent('hsn-inventory:client:checkweapon',xTarget.source,data.item)
						local count = playerInventory[xTarget.identifier][data.emptyslot].count
						playerInventory[xTarget.identifier][data.emptyslot] = nil
						playerInventory[xPlayer.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
						ItemNotify(src,data.item.name,count,'Added',data.invid2)
						ItemNotify(xTarget.source,data.item.name,count,'Removed','Player'..src)
						TriggerClientEvent('hsn-inventory:client:refreshInventory',xTarget.source,playerInventory[xTarget.identifier])
					else
						TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
					end
				elseif data.type == 'split' then
					if not ValidateItem(data.type, xPlayer, playerInventory[xTarget.identifier][data.fromSlot],playerInventory[xPlayer.identifier][data.toSlot], data.oldslotItem, data.newslotItem) then return end
					if IfInventoryCanCarry(playerInventory[xPlayer.identifier],Config.MaxWeight, (data.newslotItem.weight * data.newslotItem.count)) then
						TriggerClientEvent('hsn-inventory:client:checkweapon',xTarget.source,data.newslotItem)
						playerInventory[xTarget.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
						playerInventory[xPlayer.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
						ItemNotify(src,data.newslotItem.name,data.newslotItem.count,'Added',data.invid2)
						ItemNotify(xTarget.source,data.newslotItem.name,data.newslotItem.count,'Removed','Player'..src)
						TriggerClientEvent('hsn-inventory:client:refreshInventory',xTarget.source,playerInventory[xTarget.identifier])
					else
						TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
					end
				end
			end
		elseif data.frominv == data.toinv and (data.frominv == 'stash') then
			local stashId = data.invid
			if not Stashes[stashId] then TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[xPlayer.identifier]) return end
			if data.type == 'swap' then
				if not ValidateItem(data.type, xPlayer, Stashes[stashId].inventory[data.fromSlot], Stashes[stashId].inventory[data.toSlot], data.fromItem, data.toItem) then return end
				Stashes[stashId].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
				Stashes[stashId].inventory[data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
			elseif data.type == 'freeslot' then
				if not ValidateItem(data.type, xPlayer, Stashes[stashId].inventory[data.emptyslot],Stashes[stashId].inventory[data.toSlot], data.item, data.item) then return end
				Stashes[stashId].inventory[data.emptyslot] = nil
				Stashes[stashId].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
			elseif data.type == 'split' then
				if not ValidateItem(data.type, xPlayer, Stashes[stashId].inventory[data.fromSlot],Stashes[stashId].inventory[data.toSlot], data.oldslotItem, data.newslotItem) then return end
				Stashes[stashId].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
				Stashes[stashId].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
			end
		elseif data.frominv == data.toinv and (data.frominv == 'trunk') then
			local plate = data.invid
			if not Trunks[plate] then TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[xPlayer.identifier]) return end
			if data.type == 'swap' then
				if not ValidateItem(data.type, xPlayer, Trunks[plate].inventory[data.fromSlot], Trunks[plate].inventory[data.toSlot], data.fromItem, data.toItem) then return end
				Trunks[plate].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
				Trunks[plate].inventory[data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
			elseif data.type == 'freeslot' then
				if not ValidateItem(data.type, xPlayer, Trunks[plate].inventory[data.emptyslot],Trunks[plate].inventory[data.toSlot], data.item, data.item) then return end
				Trunks[plate].inventory[data.emptyslot] = nil
				Trunks[plate].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
			elseif data.type == 'split' then
				if not ValidateItem(data.type, xPlayer, Trunks[plate].inventory[data.fromSlot],Trunks[plate].inventory[data.toSlot], data.oldslotItem, data.newslotItem) then return end
				Trunks[plate].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
				Trunks[plate].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
			end
		elseif data.frominv == data.toinv and (data.frominv == 'glovebox') then
			local plate = data.invid
			if not Gloveboxes[plate] then TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[xPlayer.identifier]) return end
			if data.type == 'swap' then
				if not ValidateItem(data.type, xPlayer, Gloveboxes[plate].inventory[data.fromSlot], Gloveboxes[plate].inventory[data.toSlot], data.fromItem, data.toItem) then return end
				Gloveboxes[plate].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
				Gloveboxes[plate].inventory[data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
			elseif data.type == 'freeslot' then
				if not ValidateItem(data.type, xPlayer, Gloveboxes[plate].inventory[data.emptyslot],Gloveboxes[plate].inventory[data.toSlot], data.item, data.item) then return end
				Gloveboxes[plate].inventory[data.emptyslot] = nil
				Gloveboxes[plate].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable}
			elseif data.type == 'split' then
				if not ValidateItem(data.type, xPlayer, Gloveboxes[plate].inventory[data.fromSlot],Gloveboxes[plate].inventory[data.toSlot], data.oldslotItem, data.newslotItem) then return end
				Gloveboxes[plate].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
				Gloveboxes[plate].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'drop' and data.frominv == 'Playerinv') then
			local dropid = data.invid
			if dropid == nil then
				CreateNewDrop(src,data)
			elseif Drops[dropid] then
				if data.type == 'swap' then
					if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.fromSlot], Drops[dropid].inventory[data.toSlot], data.fromItem, data.toItem) then return end
					TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.toItem)
					Drops[dropid].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
					playerInventory[xPlayer.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
					ItemNotify(src,data.toItem.name,data.toItem.count,'Removed', 'Drop '..dropid)
					ItemNotify(src,data.fromItem.name,data.fromItem.count,'Added', 'Drop '..dropid)
				elseif data.type == 'freeslot' then
					if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.emptyslot], Drops[dropid].inventory[data.toSlot], data.item, data.item) then return end
					TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.item)
					local count = playerInventory[xPlayer.identifier][data.emptyslot].count
					playerInventory[xPlayer.identifier][data.emptyslot] = nil
					Drops[dropid].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
					ItemNotify(src,data.item.name,count,'Removed', 'Drop '..dropid)
				elseif data.type == 'split' then
					if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.fromSlot], Drops[dropid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) then return end
					TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.newslotItem)
					playerInventory[xPlayer.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
					Drops[dropid].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
					ItemNotify(src,data.newslotItem.name,data.newslotItem.count,'Removed', 'Drop '..dropid)
				end
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'Playerinv' and data.frominv == 'drop') then
			local dropid = data.invid2
			if not Drops[dropid] then TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[xPlayer.identifier]) return end
			if data.type == 'swap' then
				if not ValidateItem(data.type, xPlayer, Drops[dropid].inventory[data.fromSlot], playerInventory[xPlayer.identifier][data.toSlot], data.fromItem, data.toItem) then return end
				if IfInventoryCanCarry(playerInventory[xPlayer.identifier],Config.MaxWeight, (data.toItem.weight * data.toItem.count)) then
					playerInventory[xPlayer.identifier][data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
					Drops[dropid].inventory[data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
					ItemNotify(src,data.toItem.name,data.toItem.count,'Added', 'Drop '..dropid)
					ItemNotify(src,data.fromItem.name,data.fromItem.count,'Removed', 'Drop '..dropid)
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			elseif data.type == 'freeslot' then
				if not ValidateItem(data.type, xPlayer, Drops[dropid].inventory[data.emptyslot],playerInventory[xPlayer.identifier][data.toSlot], data.item, data.item) then return end
				if IfInventoryCanCarry(playerInventory[xPlayer.identifier],Config.MaxWeight, (data.item.weight * data.item.count)) then
					Drops[dropid].inventory[data.emptyslot] = nil
					playerInventory[xPlayer.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
					ItemNotify(src,data.item.name,data.item.count,'Added', 'Drop '..dropid)
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			elseif data.type == 'split' then
				if not ValidateItem(data.type, xPlayer, Drops[dropid].inventory[data.fromSlot],playerInventory[xPlayer.identifier][data.toSlot], data.oldslotItem, data.newslotItem) then return end
				if IfInventoryCanCarry(playerInventory[xPlayer.identifier],Config.MaxWeight, (data.newslotItem.weight * data.newslotItem.count)) then
					Drops[dropid].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
					playerInventory[xPlayer.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
					ItemNotify(src,data.newslotItem.name,data.newslotItem.count,'Added', 'Drop '..dropid)
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			end
			if next(Drops[dropid].inventory) == nil then
				TriggerClientEvent('hsn-inventory:client:removeDrop',-1, dropid)
				TriggerClientEvent("hsn-inventory:client:closeInventory",src,dropid)
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'stash' and data.frominv == 'Playerinv') then
			local stashId = data.invid
			if not Stashes[stashId] then TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[xPlayer.identifier]) return end
			if data.type == 'swap' then
				if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.fromSlot], Stashes[stashId].inventory[data.toSlot], data.fromItem, data.toItem) then return end
				ItemNotify(src,data.toItem.name,data.toItem.count,'Removed', 'Stash '..stashId)
				ItemNotify(src,data.fromItem.name,data.fromItem.count,'Added', 'Stash '..stashId)
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.toItem)
				Stashes[stashId].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
				playerInventory[xPlayer.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
			elseif data.type == 'freeslot' then
				if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.emptyslot], Stashes[stashId].inventory[data.toSlot], data.item, data.item) then return end
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.item)
				local count = playerInventory[xPlayer.identifier][data.emptyslot].count
				playerInventory[xPlayer.identifier][data.emptyslot] = nil
				Stashes[stashId].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
				ItemNotify(src,data.item.name,count,'Removed', 'Stash '..stashId)
			elseif data.type == 'split' then
				if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.fromSlot], Stashes[stashId].inventory[data.toSlot], data.oldslotItem, data.newslotItem) then return end
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.newslotItem)
				playerInventory[xPlayer.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
				Stashes[stashId].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
				ItemNotify(src,data.newslotItem.name,data.newslotItem.count,'Removed', 'Stash '..stashId)
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'trunk' and data.frominv == 'Playerinv') then
			local plate = data.invid
			if not Trunks[plate] then TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[xPlayer.identifier]) return end
			if data.type == 'swap' then
				if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.fromSlot], Trunks[plate].inventory[data.toSlot], data.fromItem, data.toItem) then return end
				ItemNotify(src,data.toItem.name,data.toItem.count,'Removed', 'Trunk '..plate)
				ItemNotify(src,data.fromItem.name,data.fromItem.count,'Added', 'Trunk '..plate)
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.toItem)
				Trunks[plate].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
				playerInventory[xPlayer.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
			elseif data.type == 'freeslot' then
				if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.emptyslot], Trunks[plate].inventory[data.toSlot], data.item, data.item) then return end
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.item)
				local count = playerInventory[xPlayer.identifier][data.emptyslot].count
				playerInventory[xPlayer.identifier][data.emptyslot] = nil
				Trunks[plate].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
				ItemNotify(src,data.item.name,count,'Removed', 'Trunk '..plate)
			elseif data.type == 'split' then
				if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.fromSlot], Trunks[plate].inventory[data.toSlot], data.oldslotItem, data.newslotItem) then return end
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.newslotItem)
				playerInventory[xPlayer.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
				Trunks[plate].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
				ItemNotify(src,data.newslotItem.name,data.newslotItem.count,'Removed', 'Trunk '..plate)
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'Playerinv' and data.frominv == 'trunk') then
			local plate = data.invid2
			if not Trunks[plate] then TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[xPlayer.identifier]) return end
			if data.type == 'swap' then
				if not ValidateItem(data.type, xPlayer, Trunks[plate].inventory[data.fromSlot], playerInventory[xPlayer.identifier][data.toSlot], data.fromItem, data.toItem) then return end
				if IfInventoryCanCarry(playerInventory[xPlayer.identifier],Config.MaxWeight, (data.toItem.weight * data.toItem.count))  then
					playerInventory[xPlayer.identifier][data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
					Trunks[plate].inventory[data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
					ItemNotify(src,data.toItem.name,data.toItem.count,'Added', 'Trunk '..plate)
					ItemNotify(src,data.fromItem.name,data.fromItem.count,'Removed', 'Trunk '..plate)
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end	
			elseif data.type == 'freeslot' then
				if not ValidateItem(data.type, xPlayer, Trunks[plate].inventory[data.emptyslot], playerInventory[xPlayer.identifier][data.toSlot], data.item, data.item) then return end
				if IfInventoryCanCarry(playerInventory[xPlayer.identifier],Config.MaxWeight, (data.item.weight * data.item.count))  then	
					local count = Trunks[plate].inventory[data.emptyslot].count
					Trunks[plate].inventory[data.emptyslot] = nil
					playerInventory[xPlayer.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
					ItemNotify(src,data.item.name,count,'Added', 'Trunk '..plate)
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			elseif data.type == 'split' then
				if not ValidateItem(data.type, xPlayer, Trunks[plate].inventory[data.fromSlot], playerInventory[xPlayer.identifier][data.toSlot], data.oldslotItem, data.newslotItem) then return end
				if IfInventoryCanCarry(playerInventory[xPlayer.identifier],Config.MaxWeight, (data.newslotItem.weight * data.newslotItem.count))  then	
					Trunks[plate].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
					playerInventory[xPlayer.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
					ItemNotify(src,data.newslotItem.name,data.newslotItem.count,'Added', 'Trunk '..plate)
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'glovebox' and data.frominv == 'Playerinv') then
			local plate = data.invid
			if not Gloveboxes[plate] then TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[xPlayer.identifier]) return end
			if data.type == 'swap' then
				if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.fromSlot], Gloveboxes[plate].inventory[data.toSlot], data.fromItem, data.toItem) then return end
				ItemNotify(src,data.toItem.name,data.toItem.count,'Removed', plate)
				ItemNotify(src,data.fromItem.name,data.fromItem.count,'Added', plate)
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.toItem)
				Gloveboxes[plate].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
				playerInventory[xPlayer.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
			elseif data.type == 'freeslot' then
				if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.emptyslot], Gloveboxes[plate].inventory[data.toSlot], data.item, data.item) then return end
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.item)
				local count = playerInventory[xPlayer.identifier][data.emptyslot].count
				playerInventory[xPlayer.identifier][data.emptyslot] = nil
				Gloveboxes[plate].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
				ItemNotify(src,data.item.name,count,'Removed', plate)
			elseif data.type == 'split' then
				if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.fromSlot], Gloveboxes[plate].inventory[data.toSlot], data.oldslotItem, data.newslotItem) then return end
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.newslotItem)
				playerInventory[xPlayer.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
				Gloveboxes[plate].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
				ItemNotify(src,data.newslotItem.name,data.newslotItem.count,'Removed', plate)
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'Playerinv' and data.frominv == 'glovebox') then
			local plate = data.invid2
			if not Gloveboxes[plate] then TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[xPlayer.identifier]) return end
			if data.type == 'swap' then
				if not ValidateItem(data.type, xPlayer, Gloveboxes[plate].inventory[data.fromSlot], playerInventory[xPlayer.identifier][data.toSlot], data.fromItem, data.toItem) then return end
				if IfInventoryCanCarry(playerInventory[xPlayer.identifier],Config.MaxWeight, (data.toItem.weight * data.toItem.count))  then
					playerInventory[xPlayer.identifier][data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
					Gloveboxes[plate].inventory[data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
					ItemNotify(src,data.toItem.name,data.toItem.count,'Added', 'Trunk '..plate)
					ItemNotify(src,data.fromItem.name,data.fromItem.count,'Removed', 'Trunk '..plate)
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end	
			elseif data.type == 'freeslot' then
				if not ValidateItem(data.type, xPlayer, Gloveboxes[plate].inventory[data.emptyslot], playerInventory[xPlayer.identifier][data.toSlot], data.item, data.item) then return end
				if IfInventoryCanCarry(playerInventory[xPlayer.identifier],Config.MaxWeight, (data.item.weight * data.item.count))  then	
					local count = Gloveboxes[plate].inventory[data.emptyslot].count
					Gloveboxes[plate].inventory[data.emptyslot] = nil
					playerInventory[xPlayer.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
					ItemNotify(src,data.item.name,count,'Added', 'Trunk '..plate)
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			elseif data.type == 'split' then
				if not ValidateItem(data.type, xPlayer, Gloveboxes[plate].inventory[data.fromSlot], playerInventory[xPlayer.identifier][data.toSlot], data.oldslotItem, data.newslotItem) then return end
				if IfInventoryCanCarry(playerInventory[xPlayer.identifier],Config.MaxWeight, (data.newslotItem.weight * data.newslotItem.count))  then	
					Gloveboxes[plate].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
					playerInventory[xPlayer.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
					ItemNotify(src,data.newslotItem.name,data.newslotItem.count,'Added', 'Trunk '..plate)
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'Playerinv' and data.frominv == 'stash') then
			local stashId = data.invid2
			if not Stashes[stashId] then TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[xPlayer.identifier]) return end
			if data.type == 'swap' then
				if not ValidateItem(data.type, xPlayer, Stashes[stashId].inventory[data.fromSlot], playerInventory[xPlayer.identifier][data.toSlot], data.fromItem, data.toItem) then return end
				if IfInventoryCanCarry(playerInventory[xPlayer.identifier],Config.MaxWeight, (data.toItem.weight * data.toItem.count)) then
					ItemNotify(src,data.toItem.name,data.toItem.count,'Added', 'Stash '..stashId)
					ItemNotify(src,data.fromItem.name,data.fromItem.count,'Removed', 'Stash '..stashId)
					playerInventory[xPlayer.identifier][data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
					Stashes[stashId].inventory[data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			elseif data.type == 'freeslot' then
				if not ValidateItem(data.type, xPlayer, Stashes[stashId].inventory[data.emptyslot], playerInventory[xPlayer.identifier][data.toSlot], data.item, data.item) then return end
				if IfInventoryCanCarry(playerInventory[xPlayer.identifier],Config.MaxWeight, (data.item.weight * data.item.count)) then
					Stashes[stashId].inventory[data.emptyslot] = nil
					playerInventory[xPlayer.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
					ItemNotify(src,data.item.name,data.item.count,'Added', 'Stash '..stashId)
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			elseif data.type == 'split' then
				if not ValidateItem(data.type, xPlayer, Stashes[stashId].inventory[data.fromSlot], playerInventory[xPlayer.identifier][data.toSlot], data.oldslotItem, data.newslotItem) then return end
				if IfInventoryCanCarry(playerInventory[xPlayer.identifier],Config.MaxWeight, (data.newslotItem.weight * data.newslotItem.count)) then
					Stashes[stashId].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
					playerInventory[xPlayer.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
					ItemNotify(src,data.newslotItem.name,data.newslotItem.count,'Added', 'Stash '..stashId)
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			end
		end
	end
end) 

RegisterNetEvent('hsn-inventory:buyItem')
AddEventHandler('hsn-inventory:buyItem', function(info)
	local src = source
	local data = info.data
	local location = info.location
	local xPlayer = ESX.GetPlayerFromId(src)
	local money, currency, item = nil, nil, {}
	if info.count ~= nil then info.count = tonumber(info.count) else info.count = 0 end
	local count = ESX.Round(info.count)
	local checkShop = Config.Shops[location].inventory[data.slot]

	if checkShop.grade and checkShop.grade > xPlayer.job.grade then
		TriggerClientEvent('hsn-inventory:notification',src,'You can not purchase this item',2)
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
			item = ESXItems[shopCurrency]
			currency = item.label
			money = xPlayer.getInventoryItem(item.name).count
		end

		if checkShop.name ~= data.name then
			TriggerBanEvent(xPlayer, 'tried to buy '..data.name..' but slot contains '..checkShop.name)
		elseif (checkShop.price * count) ~= data.price then
			TriggerBanEvent(xPlayer, 'tried to buy '..ESX.Math.GroupDigits(count)..'x '..data.name..' for '..ESX.Math.GroupDigits(data.price)..' '..currency..'(actual cost is '..ESX.Math.GroupDigits(ESX.Round(checkShop.price * count))..')')
		end

		if IfInventoryCanCarry(playerInventory[xPlayer.identifier], Config.MaxWeight, (data.weight * count)) then
			if data.price then
				if money >= data.price then
					local cost
					if currency == 'bank' or currency:find('money') then cost = '$'..ESX.Math.GroupDigits(data.price)..' currency' else cost = ESX.Math.GroupDigits(data.price)..'x '..currency end
					if currency == 'bank' then
						xPlayer.removeAccountMoney('bank', data.price)
					else
						RemovePlayerInventory(src, xPlayer.identifier, item.name, data.price)
					end
					AddPlayerInventory(xPlayer.identifier, data.name, count, nil, data.metadata)
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
					TriggerClientEvent('hsn-inventory:notification',src,'You can not afford that (missing '..missing..')',2)
				end
			end
		else
			TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
		end
	else
		TriggerClientEvent('hsn-inventory:notification',src,'You must select an amount to buy',2)
	end
end)

CreateNewDrop = function(source,data)
	local src = source
	local ped = GetPlayerPed(src)
	local coords = GetEntityCoords(ped)
	local dropid = RandomDropId()
	local xPlayer = ESX.GetPlayerFromId(src)
	Drops[dropid] = {}
	Drops[dropid].inventory = {}
	Drops[dropid].name = dropid
	Drops[dropid].slots = 51		
	if data.type == 'swap' then
		if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.fromSlot], Drops[dropid].inventory[data.toSlot], data.fromItem, data.toItem) then return end
		TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.toItem)
		Drops[dropid].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
		playerInventory[xPlayer.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
		ItemNotify(src,data.toItem.name,data.toItem.count,'Removed', 'Drop '..dropid)
		ItemNotify(src,data.fromItem.name,data.fromItem.count,'Added', 'Drop '..dropid)
	elseif data.type == 'freeslot' then
		if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.emptyslot], Drops[dropid].inventory[data.toSlot], data.item, data.item) then return end
		TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.item)
		playerInventory[xPlayer.identifier][data.emptyslot] = nil
		Drops[dropid].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
		ItemNotify(src,data.item.name,data.item.count,'Removed', 'Drop '..dropid)
	elseif data.type == 'split' then
		if not ValidateItem(data.type, xPlayer, playerInventory[xPlayer.identifier][data.fromSlot], Drops[dropid].inventory[data.toSlot], data.oldslotItem, data.newslotItem) then return end
		TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.newslotItem)
		playerInventory[xPlayer.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
		Drops[dropid].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
		ItemNotify(src,data.newslotItem.name,data.newslotItem.count,'Removed', 'Drop '..dropid)
	end
	if not oneSync then coords = src end -- Support not using OneSync
	TriggerClientEvent('hsn-inventory:Client:addnewDrop', -1, coords, dropid, src)
	Citizen.Wait(10)
	TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[xPlayer.identifier])
end

RegisterNetEvent('hsn-inventory:server:refreshInventory')
AddEventHandler('hsn-inventory:server:refreshInventory',function()
	if notready then return end
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('hsn-inventory:client:refreshInventory',source,playerInventory[xPlayer.identifier])
end)

RegisterNetEvent('hsn-inventory:server:openInventory')
AddEventHandler('hsn-inventory:server:openInventory',function(data, coords)
	if notready then return end
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if data ~= nil then
		if invopened[src] then TriggerEvent("hsn-inventory:removecurrentInventory", invopened[src].curInventory) Citizen.Wait(100) end
		Citizen.Wait(500)
		if data.type == 'drop' then
			if Drops[data.id] ~= nil then
				if checkOpenable(src,data.id,data.coords) then
					TriggerClientEvent('hsn-inventory:client:openInventory',src,playerInventory[xPlayer.identifier],Drops[data.id])
				end
			else
				if checkOpenable(src, 'Player'..src, GetEntityCoords(GetPlayerPed(src))) then
					TriggerClientEvent('hsn-inventory:client:openInventory',src,playerInventory[xPlayer.identifier])
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not open this inventory',2)
				end
			end
		elseif data.type == 'shop' then
			Shops[data.id.name] = {}
			Shops[data.id.name].inventory = SetupShopItems(data.id)
			Shops[data.id.name].name = data.id.name
			Shops[data.id.name].id = data.index
			Shops[data.id.name].type = 'shop'
			Shops[data.id.name].slots = #Shops[data.id.name].inventory + 1
			Shops[data.id.name].coords = data.id.coords
			Shops[data.id.name].currency = Config.Shops[data.index].currency
			if not data.id.job or data.id.job == xPlayer.job.name then
				if data.id.license then
					TriggerEvent('esx_license:checkLicense', src, data.id.license, function(haslicense)
						if haslicense then
							TriggerClientEvent('hsn-inventory:client:openInventory',src,playerInventory[xPlayer.identifier],Shops[data.id.name])
						else
							TriggerClientEvent('hsn-inventory:notification',src,'You do not have a '..data.id.license..' license',2)
						end
					end)
				else
					TriggerClientEvent('hsn-inventory:client:openInventory',src,playerInventory[xPlayer.identifier],Shops[data.id.name])
				end
			end
		elseif data.type == 'glovebox' then
			if checkOpenable(src,data.id) then
				Gloveboxes[data.id] = {}
				Gloveboxes[data.id].inventory =  GetItems(data.id)
				Gloveboxes[data.id].name = data.id
				Gloveboxes[data.id].type = 'glovebox'
				Gloveboxes[data.id].slots = data.slots
				TriggerClientEvent('hsn-inventory:client:openInventory',src,playerInventory[xPlayer.identifier],Gloveboxes[data.id])
			end
		elseif data.type == 'trunk' then
			if checkOpenable(src,data.id) then
				Trunks[data.id] = {}
				Trunks[data.id].inventory =  GetItems(data.id)
				Trunks[data.id].name = data.id
				Trunks[data.id].type = 'trunk'
				Trunks[data.id].slots = data.slots
				TriggerClientEvent('hsn-inventory:client:openInventory',src,playerInventory[xPlayer.identifier],Trunks[data.id])
			end
		end
	end
end)

RegisterNetEvent('hsn-inventory:server:OpenStash')
AddEventHandler('hsn-inventory:server:OpenStash',function(stash)
	OpenStash(source, stash)
end)

OpenStash = function(source, stash)
	if notready then return end
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if invopened[src] then TriggerEvent("hsn-inventory:removecurrentInventory", invopened[src].curInventory) Citizen.Wait(100) end
	if Stashes[stash.id.name] == nil then
		Stashes[stash.id.name] = {}
		Stashes[stash.id.name].inventory = GetItems(stash.id.name)
		Stashes[stash.id.name].name = stash.id.name
		Stashes[stash.id.name].type = 'stash'
		Stashes[stash.id.name].slots = stash.id.slots
		Stashes[stash.id.name].coords = stash.id.coords
	end
	if checkOpenable(src,stash.id.name,stash.id.coords) then
		if not stash.id.job or stash.id.job == xPlayer.job.name then
			TriggerClientEvent('hsn-inventory:client:openInventory',src,playerInventory[xPlayer.identifier], Stashes[stash.id.name])
		end
	else
		TriggerClientEvent('hsn-inventory:notification',src,'You can not open this inventory',2)
	end
end

RegisterNetEvent('hsn-inventory:server:openTargetInventory')
AddEventHandler('hsn-inventory:server:openTargetInventory',function(TargetId)
	if notready then return end
	local xPlayer = ESX.GetPlayerFromId(source)
	local tPlayer = ESX.GetPlayerFromId(TargetId)
	if source == TargetId then tPlayer = nil end -- Don't allow source and targetid to match
	if tPlayer and xPlayer then
		if playerInventory[tPlayer.identifier] == nil then
			playerInventory[tPlayer.identifier] = {}
		end
		if invopened[src] then TriggerEvent("hsn-inventory:removecurrentInventory", invopened[source].curInventory) Citizen.Wait(100) end
		if checkOpenable(source, 'Player'..TargetId, GetEntityCoords(GetPlayerPed(TargetId))) then
			local data = {}
			data.name = 'Player'..TargetId -- do not touch
			data.type = 'TargetPlayer'
			data.slots = Config.PlayerSlot
			data.inventory = playerInventory[tPlayer.identifier]
			TriggerClientEvent('hsn-inventory:client:openInventory',source,playerInventory[xPlayer.identifier], data)
		end
	end
end)

RegisterNetEvent('hsn-inventory:server:saveInventory')
AddEventHandler('hsn-inventory:server:saveInventory',function(data)
	if notready then return end
	SaveItems(data.type,data.invid)
end)

checkOpenable = function(source,id,coords)
	local src = source
	local returnData = false

	if oneSync and coords then
		local srcCoords = GetEntityCoords(GetPlayerPed(src))
		if #(vector3(coords.x, coords.y, coords.z) - srcCoords) > 2 then return false end
	end

	if openedinventories[id] == nil then
		openedinventories[id] = {}
		openedinventories[id].opened = true
		openedinventories[id].owner = src
		returnData = true
	end
	return returnData
end

SetupShopItems = function(shopid)
	local inventory = {}
	for k,v in pairs(shopid.inventory) do
		if ESXItems[v.name] ~= nil then
			if v.metadata == nil then v.metadata = {} end
			inventory[k] = {name = v.name ,label = ESXItems[v.name].label, weight = ESXItems[v.name].weight, slot = k, count = v.count, description = ESXItems[v.name].description, metadata = v.metadata, stackable = ESXItems[v.name].stackable,price = v.price}
		else
			print('^1[hsn-inventory]^1 Item Not Found Check config.lua/Config.Shops and your items table^7')
		end
	end
	return inventory
end

GetItems = function(id)
	local returnData = {}
	local result = exports.ghmattimysql:scalarSync('SELECT data FROM hsn_inventory WHERE name = @name', {
		['@name'] = id
	})
	if result ~= nil then
		local Inventory = json.decode(result)
		for k,v in pairs(Inventory) do
			if v.metadata == nil then v.metadata = {} end
			returnData[v.slot] = {name = v.name ,label = ESXItems[v.name].label, weight = ESXItems[v.name].weight, slot = v.slot, count = v.count, description = ESXItems[v.name].description, metadata = v.metadata, stackable = ESXItems[v.name].stackable}
		end
	end
	return returnData
end

GetInventory = function(inventory)
	local returnData = {}
	if inventory ~= nil then
		for k,v in pairs(inventory) do
			returnData[k] = {
				name = v.name,
				count = v.count,
				metadata = v.metadata,
				slot = k
			} 
		end
	end
	return returnData
end

SaveItems = function(type,id)
	if id then
		if type == "stash" then
			local inventory = json.encode(GetInventory(Stashes[id].inventory))
			local result = exports.ghmattimysql:scalarSync('SELECT data FROM hsn_inventory WHERE name = @name', {
				['@name'] = id
			})
			if result then
				exports.ghmattimysql:execute('UPDATE hsn_inventory SET data = @data WHERE name = @name', {
					['@data'] = inventory,
					['@name'] = id
				})
			elseif inventory ~= '[]' then
				exports.ghmattimysql:execute('INSERT INTO hsn_inventory (name, data) VALUES (@name, @data)', {
					['@name'] = id,
					['@data'] = inventory
				})
			end
		elseif type == "trunk" then
			local inventory = json.encode(GetInventory(Trunks[id].inventory))
			local result = exports.ghmattimysql:scalarSync('SELECT data FROM hsn_inventory WHERE name = @name', {
				['@name'] = id
			})
			if result then
				exports.ghmattimysql:execute('UPDATE hsn_inventory SET data = @data WHERE name = @name', {
					['@data'] = inventory,
					['@name'] = id
				})
			elseif inventory ~= '[]' then
				exports.ghmattimysql:execute('INSERT INTO hsn_inventory (name, data) VALUES (@name, @data)', {
					['@name'] = id,
					['@data'] = inventory
				})
			end
		elseif type == "glovebox" then
			local inventory = json.encode(GetInventory(Gloveboxes[id].inventory))
			local result = exports.ghmattimysql:scalarSync('SELECT data FROM hsn_inventory WHERE name = @name', {
				['@name'] = id
			})
			if result then
				exports.ghmattimysql:execute('UPDATE hsn_inventory SET data = @data WHERE name = @name', {
					['@data'] = inventory,
					['@name'] = id
				})
			elseif inventory ~= '[]' then
				exports.ghmattimysql:execute('INSERT INTO hsn_inventory (name, data) VALUES (@name, @data)', {
					['@name'] = id,
					['@data'] = inventory
				})
			end
		end
	end
end

RegisterNetEvent('hsn-inventory:setcurrentInventory')
AddEventHandler('hsn-inventory:setcurrentInventory',function(other)
	local src = source
	local id = 'Player'..src
	openedinventories[id] = {}
	openedinventories[id].opened = true
	openedinventories[id].owner = src
	if other ~= nil then
		invopened[src] = {
			curInventory = other.name,
			type = other.type,
			invopened = true
		}
	end
end)

RegisterNetEvent('hsn-inventory:removecurrentInventory')
AddEventHandler('hsn-inventory:removecurrentInventory',function(name)
	local src = source
	if invopened[src] ~= nil then
		invopened[src] = nil
	end
	if openedinventories[name] ~= nil then
		openedinventories[name] = nil
	end
	if openedinventories['Player'..src] ~= nil then
		openedinventories['Player'..src] = nil
	end
end)


AddEventHandler('playerDropped', function(reason) --  https://github.com/CylexVII <3
	local src = source
	if invopened[src] ~= nil then
		if invopened[src].curInventory ~= nil and invopened[src].invopened then
			SaveItems(invopened[src].type,invopened[src].curInventory)
			invopened[src] = nil
			print('^1[hsn-inventory]^1 One player left the game when his inventory open and inventory saved ^1[DUPE Alert]^7')
		end
	end
	for k,v in pairs(openedinventories) do
		if openedinventories[k].owner == src then
			openedinventories[k] = nil -- :)
			break
		end 
	end
end)

function SyncAccount(xPlayer, item, count)
	local account = {}
	account.name = item
	account.money = count or xPlayer.getAccount(item).money
	TriggerClientEvent('esx:setAccountMoney', xPlayer.source, account)
end

ItemNotify = function(source, item, count, type, id)
	local xPlayer = ESX.GetPlayerFromId(source)
	count = tonumber(count)
	if count > 0 then
		TriggerClientEvent('hsn-inventory:client:addItemNotify',source,ESXItems[item], ('%s %sx'):format(type, count))
		if item:find('money') then SyncAccount(xPlayer, item) end
		if Config.Logs then
			if id then id = '('..id..')' else id = '' end
			exports.linden_logs:log(xPlayer.source, ('%s (%s) has %s %sx %s %s'):format(xPlayer.name, xPlayer.identifier, string.lower(type), ESX.Math.GroupDigits(count), ESXItems[item].label, id), 'test')
		end
	else TriggerClientEvent('hsn-inventory:client:addItemNotify',source,ESXItems[item],'Used') end
end

RegisterNetEvent('hsn-inventory:server:useItem')
AddEventHandler('hsn-inventory:server:useItem',function(item)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if playerInventory[xPlayer.identifier][item.slot] ~= nil and playerInventory[xPlayer.identifier][item.slot].name ~= nil then
		if item.name:find('WEAPON_') then
			if item.metadata.durability ~= nil then
				if item.metadata.durability > 0 then 
					TriggerClientEvent('hsn-inventory:client:weapon',src,item)
				else
					TriggerClientEvent('hsn-inventory:notification',src,'This weapon is broken',2)
				end
			elseif Config.Throwable[item] then
				TriggerClientEvent('hsn-inventory:client:weapon',src,item)
			end
		else
			if item.name:find('ammo') then
				local weps = Config.Ammos[item.name]
				TriggerClientEvent('hsn-inventory:addAmmo',src,weps,playerInventory[xPlayer.identifier][item.slot])
				return
			end
			useItem(src, playerInventory[xPlayer.identifier][item.slot])
		end
	end
end)


RegisterNetEvent('hsn-inventory:server:reloadWeapon')
AddEventHandler('hsn-inventory:server:reloadWeapon',function(weapon)
	local xPlayer = ESX.GetPlayerFromId(source)
	local ammo = {}
	ammo.name = weapon.ammotype
	ammo.count = getItemCount(source,ammo.name)
	if ammo.count then playerInventory[xPlayer.identifier][weapon.item.slot].metadata.ammo = 0
		if ammo.count > 0 then TriggerClientEvent('hsn-inventory:addAmmo',source, weapon.item.name,ammo) end
	end
end)

RegisterNetEvent('hsn-inventory:server:useItemfromSlot')
AddEventHandler('hsn-inventory:server:useItemfromSlot',function(slot)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if playerInventory[xPlayer.identifier] ~= nil then
		if playerInventory[xPlayer.identifier][slot] == nil then
			return
		end
		if playerInventory[xPlayer.identifier][slot] ~= nil and playerInventory[xPlayer.identifier][slot].name ~= nil then
			if playerInventory[xPlayer.identifier][slot].name:find('WEAPON_') then
				if playerInventory[xPlayer.identifier][slot].metadata.durability ~= nil then
					if playerInventory[xPlayer.identifier][slot].metadata.durability > 0 then
						TriggerClientEvent('hsn-inventory:client:weapon',src,playerInventory[xPlayer.identifier][slot])
					else
						TriggerClientEvent('hsn-inventory:notification',src,'This weapon is broken',2)
					end
				elseif Config.Throwable[playerInventory[xPlayer.identifier][slot].name] then
					TriggerClientEvent('hsn-inventory:client:weapon',src,playerInventory[xPlayer.identifier][slot])
				end
			else
				if playerInventory[xPlayer.identifier][slot].name:find('ammo') then
					local weps = Config.Ammos[playerInventory[xPlayer.identifier][slot].name]
					TriggerClientEvent('hsn-inventory:addAmmo',src,weps,playerInventory[xPlayer.identifier][slot])
					return
				end
				useItem(src, playerInventory[xPlayer.identifier][slot])
			end
		end
	end
end)


RegisterNetEvent('hsn-inventory:server:decreasedurability')
AddEventHandler('hsn-inventory:server:decreasedurability',function(source, item, ammo)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local decreaseamount = 0
	if type(slot) == 'number' then
		if playerInventory[xPlayer.identifier][item.slot] ~= nil then
			if playerInventory[xPlayer.identifier][item.slot].metadata.durability ~= nil then
				if playerInventory[xPlayer.identifier][item.slot].metadata.durability <= 0 then
					TriggerClientEvent('hsn-inventory:client:checkweapon',src,playerInventory[xPlayer.identifier][item.slot])
					TriggerClientEvent('hsn-inventory:notification',src,'This weapon is broken',2)
					if playerInventory[xPlayer.identifier][item.slot].name:find('WEAPON_FIREEXTINGUISHER') or playerInventory[xPlayer.identifier][item.slot].name:find('WEAPON_PETROLCAN') then
						RemovePlayerInventory(src,xPlayer.identifier, playerInventory[xPlayer.identifier][item.slot].name, 1, item.slot)
					end
					return
				end
				if Config.DurabilityDecreaseAmount[playerInventory[xPlayer.identifier][slot].name] == nil then
					decreaseamount = 0.5 * (ammo / 15)
				elseif Config.DurabilityDecreaseAmount[playerInventory[xPlayer.identifier][slot].name] then
					decreaseamount = Config.DurabilityDecreaseAmount[playerInventory[xPlayer.identifier][slot].name] * (ammo / 15)
				else
					decreaseamount = amount * (ammo / 15)
				end
				playerInventory[xPlayer.identifier][slot].metadata.durability = playerInventory[xPlayer.identifier][slot].metadata.durability - decreaseamount
			end
			TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[xPlayer.identifier])
		end
	end
end)

RegisterNetEvent('hsn-inventory:server:addweaponAmmo')
AddEventHandler('hsn-inventory:server:addweaponAmmo',function(item,ammo,totalAmmo,removeAmmo,newAmmo)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if playerInventory[xPlayer.identifier][item.slot] ~= nil then
		if playerInventory[xPlayer.identifier][item.slot].metadata.ammo ~= nil then
			local ammoweight = ESXItems[ammo].weight
			playerInventory[xPlayer.identifier][item.slot].metadata.ammo = newAmmo
			playerInventory[xPlayer.identifier][item.slot].metadata.ammoweight = 0 --[[(newAmmo * ammoweight)]]
			--playerInventory[xPlayer.identifier][slot].weight = ESXItems[weapon.name].weight + (newAmmo * ammoweight) disable ammo weight for now
			RemovePlayerInventory(src,xPlayer.identifier,ammo,removeAmmo)
		end
	end
	TriggerEvent('hsn-inventory:server:decreasedurability',src,item,removeAmmo)
end)


RegisterNetEvent('hsn-inventory:server:updateWeapon')
AddEventHandler('hsn-inventory:server:updateWeapon',function(item)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if playerInventory[xPlayer.identifier][item.slot] ~= nil then
		if playerInventory[xPlayer.identifier][item.slot].metadata ~= nil then
			playerInventory[xPlayer.identifier][item.slot].metadata = item.metadata
			TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[xPlayer.identifier])
			TriggerClientEvent('hsn-inventory:client:updateWeapon', src, playerInventory[xPlayer.identifier][item.slot].metadata)
		end
	end
end)

--[[ Example to remove an item with a specific metadata.type
RegisterCommand("remove", function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	Player.removeInventoryItem(args[1], 1, args[2])
end)]]

--[[ Example to retrieve items and count from player inventory
	RegisterCommand("itemcount", function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	for k, v in pairs(playerInventory[xPlayer.identifier]) do
		print(  ('[%s] %s %s'):format(k, v.name, v.count)  )
	end
end)]]

RegisterNetEvent('hsn-inventory:client:removeItem')
AddEventHandler('hsn-inventory:client:removeItem',function(item, count, metadata, slot)
	removeItem(source, item, count, metadata, slot)
end)

RegisterNetEvent('hsn-inventory:devtool')
AddEventHandler('hsn-inventory:devtool', function()
	if not IsPlayerAceAllowed(source, 'command.refresh') then
		print( ('^1[hsn-inventory]^3 [%s] %s was kicked for opening nui_devtools^7'):format(source, GetPlayerName(source)) )
		if Config.Logs then xPlayer = ESX.GetPlayerFromId(source)
			exports.linden_logs:log(xPlayer.source, ('%s (%s) was kicked for opening nui_devtools'):format(xPlayer.name, xPlayer.identifier), 'test')
		end
		-- Trigger a ban or kick for the player
		DropPlayer(source, 'foxtrot-uniform-charlie-kilo')
	end
end)

removeItem = function(src, item, count, metadata, slot)
	if item == nil then
		return
	end
	local xPlayer = ESX.GetPlayerFromId(src)
	if count == nil then
		count = 1
	end
	RemovePlayerInventory(src,xPlayer.identifier, item, count, slot, metadata)
end

addItem = function(src, item, count, metadata)
	if item == nil then
		return
	end
	local xPlayer = ESX.GetPlayerFromId(src)
	if count == nil then
		count = 1
	end
	if playerInventory[xPlayer.identifier] == nil then
		playerInventory[xPlayer.identifier]  = {}
	end
	AddPlayerInventory(xPlayer.identifier, item, count, nil, metadata)
	ItemNotify(src, item, count, 'Added')
end

getItemCount = function(src, item, metadata)
	if item == nil then
		return
	end
	local xPlayer = ESX.GetPlayerFromId(src)
	if playerInventory[xPlayer.identifier] == nil then
		return
	end
	local ItemCount = GetItemCount(xPlayer.identifier, item, metadata)
	return ItemCount
end

getItem = function(src, item, metadata)
	if item == nil then
		return
	end
	local xPlayer = ESX.GetPlayerFromId(src)
	if playerInventory[xPlayer.identifier] == nil then
		return
	end
	local inventory = playerInventory[xPlayer.identifier]
	local xItem = ESXItems[item]
	if not xItem then print('^1[hsn-inventory]^3 Item '.. item ..' does not exist^7') end
	metadata = setMetadata(metadata)
	xItem.metadata = metadata
	xItem.count = 0
	for k, v in pairs(inventory) do
		if v.name == item then
			if metadata and not v.metadata then v.metadata = {} end
			if is_table_equal(v.metadata, metadata) then
				xItem.count = xItem.count + v.count
			end
		end
	end
	return xItem
end

canCarryItem = function(src, item, count)
	if item == nil then
		return
	end
	local weight = 0
	local newWeight = (ESXItems[item].weight * count)
	local returnData = false
	local xPlayer = ESX.GetPlayerFromId(src)
	if playerInventory[xPlayer.identifier] == nil then
		return returnData
	end
	local inventory = playerInventory[xPlayer.identifier]
	for k, v in pairs(inventory) do
		weight = weight + (v.weight * v.count)
	end
	if weight + newWeight <= Config.MaxWeight then
		returnData = true
	end
	return returnData
end


useItem = function(src, item)
	if item == nil then
		return
	end
	if Config.ItemList[item.name] then
		if next(Config.ItemList[item.name]) == nil then return end
		TriggerClientEvent('hsn-inventory:useItem', src, item)
	elseif ESX.UsableItemsCallbacks[item.name] ~= nil then
		TriggerEvent('esx:useItem', src, item.name)
	elseif type(item) ~= 'table' then
		TriggerEvent('esx:useItem', src, item)
	end
end

ESX.RegisterServerCallback('hsn-inventory:getItemCount',function(source, cb, item)
	if item == nil then
		return
	end
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if playerInventory[xPlayer.identifier] == nil then
		return
	end
	local ItemCount = GetItemCount(xPlayer.identifier, item)
	cb(tonumber(ItemCount))
end)

ESX.RegisterServerCallback('hsn-inventory:getItem',function(source, cb, item, metadata)
	if item == nil then
		return
	end
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if playerInventory[xPlayer.identifier] == nil then
		return
	end
	local xItem = getItem(source, item, metadata)
	cb(xItem)
end)

ESX.RegisterServerCallback('hsn-inventory:getPlayerInventory',function(source,cb,playerId)
	local xTarget = ESX.GetPlayerFromId(playerId)
	if playerInventory[xTarget.identifier] == nil then
		playerInventory[xTarget.identifier] = {}
	end
	cb(playerInventory[xTarget.identifier])
end)



ESX.RegisterServerCallback('hsn-inventory:server:gethottbarItems',function(source,cb)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	if playerInventory[xPlayer.identifier] == nil then
		playerInventory[xPlayer.identifier] = {}
	end
	local cbData = {
		[1] = playerInventory[xPlayer.identifier][1],
		[2] = playerInventory[xPlayer.identifier][2],
		[3] = playerInventory[xPlayer.identifier][3],
		[4] = playerInventory[xPlayer.identifier][4],
		[5] = playerInventory[xPlayer.identifier][5]
	}
	cb(cbData)
end)

ESX.RegisterServerCallback('hsn-inventory:buyLicense', function(source, cb)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	if xPlayer.getMoney() >= Config.WeaponsLicensePrice then
		xPlayer.removeMoney(Config.WeaponsLicensePrice)

		TriggerEvent('esx_license:addLicense', src, 'weapon', function()
			cb(true)
		end)
	else
		cb(false)
	end
end)

RegisterNetEvent('hsn-inventory:getplayerInventory')
AddEventHandler('hsn-inventory:getplayerInventory',function(cb,identifier)
	if playerInventory[identifier] == nil then
		playerInventory[identifier] = {}
	end
	if cb then
		cb(GetInventory(playerInventory[identifier]))
	end
end)


RegisterNetEvent('hsn-inventory:setplayerInventory')
AddEventHandler('hsn-inventory:setplayerInventory',function(identifier,inventory)
	xPlayer = ESX.GetPlayerFromIdentifier(identifier)
	if not xPlayer then return end
	local id = 'Player'..xPlayer.source
	openedinventories[id] = nil
	playerInventory[identifier] = {}
	local returnData = {}
	local loop = 0
	local convert
	for k,v in pairs(inventory) do
		if Config.ConvertToHSN and type(v) == 'number' then -- Convert old inventory data to new format
			loop = loop + 1
			local count = v
			v = { slot = loop, name = k, count = count }
			if k:find('WEAPON_') then
				v.count = 1
				v.metadata = {}
				v.metadata.durability = 100
				v.metadata.ammo = 0
				v.metadata.components = {}
				v.metadata.ammoweight = 0
				v.metadata.serial = GetRandomSerial()
			end
			if convert ~= true then convert = true end
		end
		if ESXItems[v.name] then
			v.count = tonumber(v.count)
			if v.metadata and v.metadata.ammoweight then weight = v.metadata.ammoweight + ESXItems[v.name].weight else weight = tonumber(ESXItems[v.name].weight) end
			if not v.metadata or (type(v.metadata == 'table') and next(v.metadata) == nil) then v.metadata = {} end
			playerInventory[identifier][v.slot] = {name = v.name ,label = ESXItems[v.name].label, weight = tonumber(weight), slot = v.slot, count = v.count, description = ESXItems[v.name].description, metadata = v.metadata, stackable = ESXItems[v.name].stackable}
			if v.name:find('money') then Citizen.CreateThread(function()
				Citizen.Wait(500)
				SyncAccount(xPlayer, v.name, v.count) end)
			end
		end
	end

	if Config.ConvertToHSN and convert then
		-- Convert old loadout data to items
		exports.ghmattimysql:execute('SELECT loadout FROM users WHERE identifier = @identifier', {
			['@identifier'] = identifier
		}, function(result)
			local loadout = {}
			if result[1].loadout ~= nil and result[1].loadout ~= '[]' and result[1].loadout ~= '' then
				loadout = json.decode(result[1].loadout)
				for k,v in pairs(loadout) do
					loop = loop + 1
					local weapon
					if v.name then
						weapon = v.name
					else
						weapon = k
					end

					if weapon then
						v = { slot = loop, name = weapon, count = 1 }
						v.metadata = {}
						v.metadata.durability = 100
						v.metadata.ammo = 0
						v.metadata.components = {}
						v.metadata.ammoweight = 0
						v.metadata.serial = GetRandomSerial()

						v.count = tonumber(v.count)
						if v.metadata and v.metadata.ammoweight then weight = v.metadata.ammoweight + ESXItems[v.name].weight else weight = tonumber(ESXItems[v.name].weight) end
						playerInventory[identifier][v.slot] = {name = v.name ,label = ESXItems[v.name].label, weight = tonumber(weight), slot = v.slot, count = v.count, description = ESXItems[v.name].description, metadata = v.metadata, stackable = ESXItems[v.name].stackable}
					end
				end
				exports.ghmattimysql:execute('UPDATE `users` SET loadout = NULL WHERE identifier = @identifier', {
					['@identifier'] = identifier
				})
			end
		end)
		-- Convert old account data to items
		exports.ghmattimysql:execute('SELECT accounts FROM users WHERE identifier = @identifier', {
			['@identifier'] = identifier
		}, function(result)
			local accounts = {}
			if result[1].accounts and result[1].accounts ~= '[]' and result[1].accounts ~= '' then
				accounts = json.decode(result[1].accounts)
				local bank
				for k,v in pairs(accounts) do
					if k ~= 'bank' then
						if tonumber(v) ~= nil then
							loop = loop + 1
							local count = v
							v = { slot = loop, name = k, count = count }	
						end
						v.count = tonumber(v.count)
						if v.count > 0 then
							playerInventory[identifier][v.slot] = {name = v.name ,label = ESXItems[v.name].label, weight = ESXItems[v.name].weight, slot = v.slot, count = v.count, description = ESXItems[v.name].description, metadata = v.metadata, stackable = ESXItems[v.name].stackable}
						end
					else bank = '{"bank":'..v..'}' end
				end
				exports.ghmattimysql:execute('UPDATE `users` SET accounts = @bank WHERE identifier = @identifier', {
					['@identifier'] = identifier,
					['@bank'] = bank
				})
				xPlayer.setAccountMoney('bank', bank)
			end
		end)
	end
end)

RegisterCommand('closeallinv', function(source, args, rawCommand)
	if source then return end
	TriggerClientEvent("hsn-inventory:client:closeInventory", -1)
end, true)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		local xPlayers = ESX.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			local inventory = {}
			inventory = json.encode(GetInventory(playerInventory[xPlayer.identifier]))
			exports.ghmattimysql:execute('UPDATE `users` SET inventory = @inventory WHERE identifier = @identifier', {
				['@inventory'] = inventory,
				['@identifier'] = xPlayer.identifier
			})
		end
	end
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		while notready do Citizen.Wait(50) end
		Citizen.Wait(50)
		local xPlayers = ESX.GetPlayers()
		for k,v in pairs(xPlayers) do
			local xPlayer = ESX.GetPlayerFromId(v)
			playerInventory[xPlayer.identifier] = {}
			exports.ghmattimysql:scalar('SELECT inventory FROM users WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier
			}, function(result)
				local inventory = {}
				if result and result ~= '' then
					inventory = json.decode(result)
				end
				TriggerEvent('hsn-inventory:setplayerInventory', xPlayer.identifier, inventory)
			end)
		end
	end
end)


function getPlayerIdentification(xPlayer)
	return ('Sex: %s | DOB: %s (%s)'):format( xPlayer.get('sex'), xPlayer.get('dateofbirth'), xPlayer.getIdentifier() )
end

AddEventHandler('hsn-inventory:clearPlayerInventory', function(xPlayer)
	if type(xPlayer) ~= 'table' then xPlayer = ESX.GetPlayerFromId(xPlayer) end
	local inventory = GetInventory(playerInventory[xPlayer.identifier])
	for k,v in pairs(inventory) do
		RemovePlayerInventory(xPlayer.source, xPlayer.identifier, v.name, v.count, k, v.metadata)
	end
end)


function ValidateString(item)
	item = string.lower(item)
	if item:find('weapon_') then item = string.upper(item) end
	local xItem = ESXItems[item]
	if xItem then return xItem.name end
end

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
	if notready then return end
	args.playerId.removeInventoryItem(ValidateString(args.item), args.count, args.type)
end, true, {help = 'remove an item from a player', validate = false, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'},
	{name = 'item', help = 'item name', type = 'string'},
	{name = 'count', help = 'item count', type = 'number'},
	{name = 'type', help = 'item metadata type', type='any'}
}})

ESX.RegisterCommand({'removeinventory', 'clearinventory'}, 'superadmin', function(xPlayer, args, showError)
	if notready then return end
	TriggerEvent('hsn-inventory:clearPlayerInventory', args.playerId)
end, true, {help = 'clear a player\'s inventory', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'}
}})

ESX.RegisterCommand({'giveaccountmoney', 'givemoney'}, 'superadmin', function(xPlayer, args, showError)
	if notready then return end
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
	if notready then return end
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
	if notready then return end
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

ESX.RegisterCommand('evidence', 'user', function(xPlayer, args, showError)
	if notready then return end
	if xPlayer.job.name == 'police' then
		local boxID = args.evidence
		local stash = { name = ('evidence-%s'):format(boxID), slots = 31, job = 'police', coords = Config.PoliceEvidence }
		OpenStash(xPlayer.source, {id = stash, slots = stash.slots, type = 'stash'})
	end
end, true, {help = 'open police evidence', validate = true, arguments = {
	{name = 'evidence', help = 'number', type = 'number'}
}})

ESX.RegisterCommand('clearevidence', 'user', function(xPlayer, args, showError)
	if notready then return end
	if xPlayer.job.name == 'police' and xPlayer.job.grade_name == 'boss' then
		local id = 'evidence-'..args.evidence
		Stashes[id] = nil
		exports.ghmattimysql:execute('DELETE FROM hsn_inventory WHERE name = @name', {
			['@name'] = id
		})
	end
end, true, {help = 'clear police evidence', validate = true, arguments = {
	{name = 'evidence', help = 'number', type = 'number'}
}})
