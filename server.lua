ESX = nil
local oneSync
local playerInventory = {}
local Stashs = {}
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
	local Player = ESX.GetPlayerFromId(src)
	local data = {name = Player.getName(), inventory = playerInventory[Player.identifier], oneSync = oneSync}
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

GetRandomLicense = function(text)
	if not text then text = 'HSN' end
	local random = math.random(111111,999999)
	local random2 = math.random(111111,999999)
	local license = ('%s%s%s'):format(random, text, random2)
	return license
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
	local Player = ESX.GetPlayerFromIdentifier(identifier)
	if ESXItems[item] ~= nil then
		if item ~= nil and count ~= nil then
			if item:find('WEAPON_') then		
				for i = 1, Config.PlayerSlot do
					if playerInventory[identifier][i] == nil then
						local stacks = false
						if Config.Throwable[item] then
							metadata = {throwable=1}
							stacks = true
						else
							count = 1 
							if metadata == nil then metadata = {} end
							if not metadata.durability then metadata.durability = 100 end
							if not metadata.ammo then metadata.ammo = 0 end
							if not metadata.components then metadata.components = {} end
							if not metadata.ammoweight then metadata.ammoweight = 0 end
							metadata.weaponlicense = GetRandomLicense(metadata.weaponlicense)
							if metadata.registered == 'setname' then metadata.registered = Player.getName() end
						end
						playerInventory[identifier][i] = {name = item ,label = ESXItems[item].label , weight = ESXItems[item].weight, slot = i, count = count, description = ESXItems[item].description, metadata = metadata, stackable = stacks, closeonuse = ESXItems[item].closeonuse} -- because weapon :)
						break
					end
				end
			elseif item:find('identification') then
				count = 1 
				for i = 1, Config.PlayerSlot do
					if playerInventory[identifier][i] == nil then
						if metadata == nil then
							metadata = {}
							metadata.type = Player.getName()
							metadata.description = getPlayerIdentification(Player)
						end
						playerInventory[identifier][i] = {name = item ,label = ESXItems[item].label , weight = ESXItems[item].weight, slot = i, count = count, description = ESXItems[item].description, metadata = metadata, stackable = true, closeonuse = ESXItems[item].closeonuse}
						break
					end
				end
			else
				if metadata and type(metadata) ~= 'table' then metadata = {type = metadata} else metadata = {} end
				if slot then
					playerInventory[identifier][slot] = {name = item ,label = ESXItems[item].label, weight = ESXItems[item].weight, slot = i, count = count, description = ESXItems[item].description, metadata = metadata, stackable = ESXItems[item].stackable, closeonuse = ESXItems[item].closeonuse}
				else
					for i = 1, Config.PlayerSlot do
						if playerInventory[identifier][i] ~= nil and playerInventory[identifier][i].name == item and (not metadata or is_table_equal(metadata, playerInventory[identifier][i].metadata)) then
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
		end
	else
		print('[^2hsn-inventory^0] - item not found')
	end
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
		if metadata and type(metadata) ~= 'table' then metadata = {type = metadata} end
		for i = 1, Config.PlayerSlot do
			if playerInventory[identifier][i] ~= nil and playerInventory[identifier][i].name == item then
				if not metadata or is_table_equal(playerInventory[identifier][i].metadata, metadata) then
					if playerInventory[identifier][i].count > count then
						playerInventory[identifier][i].count = playerInventory[identifier][i].count - count
						ItemNotify(src, item, count, 'Removed')
						break
					elseif playerInventory[identifier][i].count == count then
						playerInventory[identifier][i] = nil
						ItemNotify(src, item, count, 'Removed')
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
	-- do your ban stuff and whatever logging you want to use
end

function ValidateItem(type, xPlayer, fromSlot, toSlot, oldItem, newItem)
	if not fromSlot then reason = 'source slot is empty' else
		if fromSlot.name ~= oldItem.name then reason = 'source slot contains different item' end
		if type ~= 'freeslot' and tonumber(fromSlot.count) - tonumber(newItem.count) < 1 then reason = 'source item count has increased' end
		if tonumber(newItem.count) > (oldItem.count + newItem.count) then reason = 'new item count is higher than source item count' end
	end

	if reason then TriggerBanEvent(xPlayer, reason) return false else return true end
end 

RegisterNetEvent('hsn-inventory:server:saveInventoryData')
AddEventHandler('hsn-inventory:server:saveInventoryData',function(data)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	if data ~= nil then
		if data.invid2 and data.invid2 ~= invopened[src].curInventory then TriggerBanEvent(Player, 'secondary inventory id does not match') end
		if data.frominv == data.toinv and (data.frominv == 'Playerinv') then
			if data.type == 'swap' then
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.fromItem)
				playerInventory[Player.identifier][data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
				playerInventory[Player.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable}
			elseif data.type == 'freeslot' then
				if not ValidateItem(data.type, Player, playerInventory[Player.identifier][data.emptyslot],playerInventory[Player.identifier][data.toSlot], data.item, data.item) then return end
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.item)
				playerInventory[Player.identifier][data.emptyslot] = nil
				playerInventory[Player.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
			elseif data.type == 'yarimswap' then
				if not ValidateItem(data.type, Player, playerInventory[Player.identifier][data.fromSlot],playerInventory[Player.identifier][data.toSlot], data.oldslotItem, data.newslotItem) then return end
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.oldslotItem)
				playerInventory[Player.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
				playerInventory[Player.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
			end
		elseif data.frominv == data.toinv and (data.frominv == 'drop') then
			local dropid = data.invid
			if data.type == 'swap' then
				Drops[dropid].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
				Drops[dropid].inventory[data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable,closeonuse = ESXItems[data.fromItem.name].closeonuse}
			elseif data.type == 'freeslot' then
				Drops[dropid].inventory[data.emptyslot] = nil
				Drops[dropid].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
			elseif data.type == 'yarimswap' then
				Drops[dropid].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
				Drops[dropid].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
				ItemNotify(src,data.oldslotItem.name,data.oldslotItem.count,'Removed')
			end
		elseif data.frominv == data.toinv and (data.frominv == 'TargetPlayer') then
			local playerId = string.gsub(data.invid, 'Player', '')
			local targetplayer = ESX.GetPlayerFromId(playerId)
				if playerInventory[targetplayer.identifier] ~= nil then
					if data.type == 'swap' then
						playerInventory[targetplayer.identifier][data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
						playerInventory[targetplayer.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable,closeonuse = ESXItems[data.fromItem.name].closeonuse}
					elseif data.type == 'freeslot' then
						 playerInventory[targetplayer.identifier][data.emptyslot] = nil
						 playerInventory[targetplayer.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
					elseif data.type == 'yarimswap' then
						 playerInventory[targetplayer.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
						 playerInventory[targetplayer.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
					end
					
					TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[Player.identifier])
					TriggerClientEvent('hsn-inventory:client:refreshInventory',targetplayer.source,playerInventory[targetplayer.identifier])
				end
		elseif data.frominv ~= data.toinv and (data.toinv == 'TargetPlayer' and data.frominv == 'Playerinv') then
			local playerId = string.gsub(data.invid, 'Player', '')
			local targetplayer = ESX.GetPlayerFromId(playerId)
			if playerInventory[targetplayer.identifier] ~= nil then
				if data.type == 'swap' then
					if IfInventoryCanCarry(playerInventory[targetplayer.identifier],Config.MaxWeight, (data.toItem.weight * data.toItem.count)) then
						TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.toItem)
						playerInventory[targetplayer.identifier][data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
						playerInventory[Player.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
						ItemNotify(src,data.toItem.name,data.toItem.count,'Removed')
						ItemNotify(src,data.fromItem.name,data.fromItem.count,'Added')
						ItemNotify(targetplayer.source,data.toItem.name,data.toItem.count,'Added')
						ItemNotify(targetplayer.source,data.fromItem.name,data.fromItem.count,'Removed')
						TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[Player.identifier])
						TriggerClientEvent('hsn-inventory:client:refreshInventory',targetplayer.source,playerInventory[targetplayer.identifier])
					else
						TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
					end
				elseif data.type == 'freeslot' then
					if tonumber(GetItemCount(Player.identifier, data.item.name)) < tonumber(data.item.count) then return end -- prevent duping
					if IfInventoryCanCarry(playerInventory[targetplayer.identifier],Config.MaxWeight, (data.item.weight * data.item.count))  then
						TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.item)
						playerInventory[Player.identifier][data.emptyslot] = nil
						playerInventory[targetplayer.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
						ItemNotify(src,data.item.name,data.item.count,'Removed')
						ItemNotify(targetplayer.source,data.item.name,data.item.count,'Added')
						TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[Player.identifier])
						TriggerClientEvent('hsn-inventory:client:refreshInventory',targetplayer.source,playerInventory[targetplayer.identifier])
					else
						TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
					end
				elseif data.type == 'yarimswap' then
					if IfInventoryCanCarry(playerInventory[targetplayer.identifier],Config.MaxWeight, (data.newslotItem.weight * data.newslotItem.count))  then
						TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.newslotItem)
						playerInventory[Player.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
						playerInventory[targetplayer.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
						TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[Player.identifier])
						TriggerClientEvent('hsn-inventory:client:refreshInventory',targetplayer.source,playerInventory[targetplayer.identifier])
					else
						TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
					end
				end
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'Playerinv' and data.frominv == 'TargetPlayer') then
			local playerId = string.gsub(data.invid2, 'Player', '')
			local targetplayer = ESX.GetPlayerFromId(playerId)
			if playerInventory[targetplayer.identifier] ~= nil then
				if data.type == 'swap' then
					if IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.toItem.weight * data.toItem.count)) then
						TriggerClientEvent('hsn-inventory:client:checkweapon',targetplayer.source,data.toItem)
						playerInventory[Player.identifier][data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
						playerInventory[targetplayer.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
						ItemNotify(src,data.toItem.name,data.toItem.count,'Added')
						ItemNotify(src,data.fromItem.name,data.fromItem.count,'Removed')
						ItemNotify(tPlayer.source,data.toItem.name,data.toItem.count,'Removed')
						ItemNotify(tPlayer.source,data.fromItem.name,data.fromItem.count,'Removed')
						TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[Player.identifier])
						TriggerClientEvent('hsn-inventory:client:refreshInventory',targetplayer.source,playerInventory[targetplayer.identifier])
					else
						TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
					end
				elseif data.type == 'freeslot' then
					if tonumber(GetItemCount(targetplayer.identifier, data.item.name)) < tonumber(data.item.count) then return end -- prevent duping
					if IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.item.weight * data.item.count))  then
						TriggerClientEvent('hsn-inventory:client:checkweapon',targetplayer.source,data.item)
						playerInventory[targetplayer.identifier][data.emptyslot] = nil
						playerInventory[Player.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
						ItemNotify(src,data.item.name,data.item.count,'Added')
						ItemNotify(targetplayer.source,data.item.name,data.item.count,'Removed')
						TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[Player.identifier])
						TriggerClientEvent('hsn-inventory:client:refreshInventory',targetplayer.source,playerInventory[targetplayer.identifier])
					else
						TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
					end
				elseif data.type == 'yarimswap' then
					if IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.newslotItem.weight * data.newslotItem.count)) then
						TriggerClientEvent('hsn-inventory:client:checkweapon',targetplayer.source,data.newslotItem)
						playerInventory[targetplayer.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
						playerInventory[Player.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
						TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[Player.identifier])
						TriggerClientEvent('hsn-inventory:client:refreshInventory',targetplayer.source,playerInventory[targetplayer.identifier])
					else
						TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
					end
				end
			end
		elseif data.frominv == data.toinv and (data.frominv == 'stash') then
			local stashId = data.invid
			if data.type == 'swap' then
				Stashs[stashId].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
				Stashs[stashId].inventory[data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
			elseif data.type == 'freeslot' then
				Stashs[stashId].inventory[data.emptyslot] = nil
				Stashs[stashId].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
			elseif data.type == 'yarimswap' then
				Stashs[stashId].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
				Stashs[stashId].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
			end
		elseif data.frominv == data.toinv and (data.frominv == 'trunk') then
			local plate = data.invid
			if data.type == 'swap' then
				Trunks[plate].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
				Trunks[plate].inventory[data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
			elseif data.type == 'freeslot' then
				Trunks[plate].inventory[data.emptyslot] = nil
				Trunks[plate].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
			elseif data.type == 'yarimswap' then
				Trunks[plate].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
				Trunks[plate].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
			end
		elseif data.frominv == data.toinv and (data.frominv == 'glovebox') then
			local plate = data.invid
			if data.type == 'swap' then
				Gloveboxes[plate].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
				Gloveboxes[plate].inventory[data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
			elseif data.type == 'freeslot' then
				Gloveboxes[plate].inventory[data.emptyslot] = nil
				Gloveboxes[plate].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable}
			elseif data.type == 'yarimswap' then
				Gloveboxes[plate].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
				Gloveboxes[plate].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'drop' and data.frominv == 'Playerinv') then
			local dropid = data.invid
			if dropid == nil then
				CreateNewDrop(src,data)
				--TriggerClientEvent('hsn-inventory:client:closeInventory',src,data.invid)
			else
				if data.type == 'swap' then
					TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.toItem)
					Drops[dropid].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
					playerInventory[Player.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
					ItemNotify(src,data.toItem.name,data.toItem.count,'Removed')
					ItemNotify(src,data.fromItem.name,data.fromItem.count,'Added')
				elseif data.type == 'freeslot' then
					if tonumber(GetItemCount(Player.identifier, data.item.name)) < tonumber(data.item.count) then return end -- prevent duping
					TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.item)
					playerInventory[Player.identifier][data.emptyslot] = nil
					Drops[dropid].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
					ItemNotify(src,data.item.name,data.item.count,'Removed')
				elseif data.type == 'yarimswap' then
					TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.newslotItem)
					playerInventory[Player.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
					Drops[dropid].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
				end
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'Playerinv' and data.frominv == 'drop') then
			local dropid = data.invid2
			if data.type == 'swap' then
				if IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.toItem.weight * data.toItem.count)) then
					playerInventory[Player.identifier][data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
					Drops[dropid].inventory[data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
					ItemNotify(src,data.toItem.name,data.toItem.count,'Added')
					ItemNotify(src,data.fromItem.name,data.fromItem.count,'Removed')
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			elseif data.type == 'freeslot' then
				if IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.item.weight * data.item.count))  then
					Drops[dropid].inventory[data.emptyslot] = nil
					playerInventory[Player.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
					ItemNotify(src,data.item.name,data.item.count,'Added')
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			elseif data.type == 'yarimswap' then
				if IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.newslotItem.weight * data.newslotItem.count)) then
					Drops[dropid].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
					playerInventory[Player.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
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
			if data.type == 'swap' then
				ItemNotify(src,data.toItem.name,data.toItem.count,'Removed')
				ItemNotify(src,data.fromItem.name,data.fromItem.count,'Added')
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.toItem)
				Stashs[stashId].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
				playerInventory[Player.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
			elseif data.type == 'freeslot' then
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.item)
				playerInventory[Player.identifier][data.emptyslot] = nil
				Stashs[stashId].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
				ItemNotify(src,data.item.name,data.item.count,'Removed')
			elseif data.type == 'yarimswap' then
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.newslotItem)
				playerInventory[Player.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
				Stashs[stashId].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'trunk' and data.frominv == 'Playerinv') then
			local plate = data.invid
			if data.type == 'swap' then
				ItemNotify(src,data.toItem.name,data.toItem.count,'Removed')
				ItemNotify(src,data.fromItem.name,data.fromItem.count,'Added')
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.toItem)
				Trunks[plate].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
				playerInventory[Player.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
			elseif data.type == 'freeslot' then
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.item)
				ItemNotify(src,data.item.name,data.item.count,'Removed')
				playerInventory[Player.identifier][data.emptyslot] = nil
				Trunks[plate].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
			elseif data.type == 'yarimswap' then
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.newslotItem)
				playerInventory[Player.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
				Trunks[plate].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'Playerinv' and data.frominv == 'trunk') then
			local plate = data.invid2
			if data.type == 'swap' then
				if  IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.toItem.weight * data.toItem.count))  then
					playerInventory[Player.identifier][data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
					Trunks[plate].inventory[data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
					ItemNotify(src,data.toItem.name,data.toItem.count,'Added')
					ItemNotify(src,data.fromItem.name,data.fromItem.count,'Removed')
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			elseif data.type == 'freeslot' then
				if  IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.item.weight * data.item.count))  then	
					Trunks[plate].inventory[data.emptyslot] = nil
					playerInventory[Player.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
					ItemNotify(src,data.item.name,data.item.count,'Added')
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			elseif data.type == 'yarimswap' then
				if  IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.newslotItem.weight * data.newslotItem.count))  then	
					Trunks[plate].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
					playerInventory[Player.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'glovebox' and data.frominv == 'Playerinv') then
			local plate = data.invid
			if data.type == 'swap' then
				ItemNotify(src,data.toItem.name,data.toItem.count,'Removed')
				ItemNotify(src,data.fromItem.name,data.fromItem.count,'Added')
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.toItem)
				Gloveboxes[plate].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
				playerInventory[Player.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
			elseif data.type == 'freeslot' then
				ItemNotify(src,data.item.name,data.item.count,'Removed')
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.item)
				playerInventory[Player.identifier][data.emptyslot] = nil
				Gloveboxes[plate].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
			elseif data.type == 'yarimswap' then
				TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.newslotItem)
				playerInventory[Player.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
				Gloveboxes[plate].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'Playerinv' and data.frominv == 'glovebox') then
			local plate = data.invid2
			if data.type == 'swap' then
				if  IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.toItem.weight * data.toItem.count))  then	
					playerInventory[Player.identifier][data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
					Gloveboxes[plate].inventory[data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
					ItemNotify(src,data.toItem.name,data.toItem.count,'Added')
					ItemNotify(src,data.fromItem.name,data.fromItem.count,'Removed')
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			elseif data.type == 'freeslot' then
				ItemNotify(src,data.item.name,data.item.count,'Added')
				if IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.item.weight * data.item.count)) then
					Gloveboxes[plate].inventory[data.emptyslot] = nil
					playerInventory[Player.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			elseif data.type == 'yarimswap' then
				if  IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.oldslotItem.weight * data.oldslotItem.count))  then	
					Gloveboxes[plate].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
					playerInventory[Player.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'Playerinv' and data.frominv == 'stash') then
			local stashId = data.invid2
			if data.type == 'swap' then
				if IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.toItem.weight * data.toItem.count)) then
					ItemNotify(src,data.toItem.name,data.toItem.count,'Added')
					ItemNotify(src,data.fromItem.name,data.fromItem.count,'Removed')
					playerInventory[Player.identifier][data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
					Stashs[stashId].inventory[data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			elseif data.type == 'freeslot' then
				if IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.item.weight * data.item.count)) then
					Stashs[stashId].inventory[data.emptyslot] = nil
					playerInventory[Player.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
					ItemNotify(src,data.item.name,data.item.count,'Added')
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			elseif data.type == 'yarimswap' then
				if IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.newslotItem.weight * data.newslotItem.count)) then
					Stashs[stashId].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
					playerInventory[Player.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'Playerinv' and data.frominv == 'shop') then
			if data.type == 'swap' then
				return TriggerClientEvent('hsn-inventory:notification',src,'You can not return your items',2)
			elseif data.type == 'freeslot' then
				if IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.item.weight * data.item.count)) then
					local money = Player.getMoney()
					if money and not data.item.price then TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[Player.identifier]) return end
					if (money >= (data.item.price * data.item.count)) then
						Player.removeMoney(data.item.price * data.item.count)
						ItemNotify(src,data.item.name,data.item.count,'Added')
						if data.item.name:find('WEAPON_') then
							if Config.Throwable[data.item.name] then
								metadata = {throwable=1}
								data.item.stackable = true
							else
								if not data.item.metadata then data.item.metadata = {} end
								data.item.metadata.weaponlicense = GetRandomLicense(data.item.metadata.weaponlicense)
								if data.item.metadata.registered == 'setname' then data.item.metadata.registered = Player.getName() end
								if not data.item.metadata.components then data.item.metadata.components = {} end
								data.item.metadata.ammo = 0
								data.item.metadata.ammoweight = 0
								data.item.metadata.durability = 100
							end
						elseif data.item.name:find('identification') then
							data.item.metadata = {}
							data.item.metadata.type = Player.getName()
							data.item.metadata.description = getPlayerIdentification(Player)
						end
							playerInventory[Player.identifier][data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
							TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[Player.identifier])
					else
						TriggerClientEvent('hsn-inventory:notification',src,'You can not afford this item ('..data.item.price * data.item.count..'$)',2)
						TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[Player.identifier])
					end
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			elseif data.type == 'yarimswap' then
				local money = Player.getMoney()
				if IfInventoryCanCarry(playerInventory[Player.identifier],Config.MaxWeight, (data.newslotItem.weight * data.newslotItem.count)) then
					if money and not data.newslotItem.price then TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[Player.identifier]) return end
					if (money >= (data.newslotItem.price *  data.newslotItem.count)) then
						if data.newslotItem.name:find('WEAPON_') then
							if Config.Throwable[data.newslotItem.name] then
								metadata = {throwable=1}
								data.item.stackable = true
							else
								if not data.newslotItem.metadata then data.newslotItem.metadata = {} end
								if data.newslotItem.metadata.registered == 'setname' then data.newslotItem.metadata.registered = Player.getName() end
								data.newslotItem.metadata.weaponlicense = GetRandomLicense(data.newslotItem.metadata.weaponlicense)
								if not data.newslotItem.metadata.components then data.newslotItem.metadata.components = {} end
								data.newslotItem.metadata.ammo = 0
								data.newslotItem.metadata.ammoweight = 0
								data.newslotItem.metadata.durability = 100
							end
						elseif data.newslotItem.name:find('identification') then
							data.newslotItem.metadata = {}
							data.newslotItem.metadata.type = Player.getName()
							data.newslotItem.metadata.description = getPlayerIdentification(Player)
						end
						Player.removeMoney(data.newslotItem.price *  data.newslotItem.count)
						playerInventory[Player.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
						ItemNotify(src,data.newslotItem.name,data.newslotItem.count,'Added')
					else
						Citizen.Wait(5)
						TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[Player.identifier])
						TriggerClientEvent('hsn-inventory:notification',src,'You can not afford this item ('..data.newslotItem.price *  data.newslotItem.count..'$)',2)
					end
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not carry this item',2)
				end
			end
		elseif data.frominv ~= data.toinv and (data.toinv == 'shop' and data.frominv == 'Playerinv') then
			TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[Player.identifier])
			return TriggerClientEvent('hsn-inventory:notification',src,'You can not return your items',2)
		end

--[[		-- we'll clean this up later
		for k, v in pairs(Config.Accounts) do
			MoneySync(src, v)
		end]]

	end
end) 

RegisterServerEvent('hsn-inventory:buyItem')
AddEventHandler('hsn-inventory:buyItem', function(info)
	local src = source
	local data = info.data
	local location = info.location
	local xPlayer = ESX.GetPlayerFromId(src)
	local money = xPlayer.getMoney()
	local count = tonumber(info.count)
	local checkShop = Config.Shops[location].inventory[data.slot]
	if count > 0 then
		if data.name:find('WEAPON_') then count = 1 end
		data.price = data.price * count

		if checkShop.name ~= data.name then
			TriggerBanEvent(xPlayer, 'tried to buy '..data.name..' but slot contains '..checkShop.name)
		elseif (checkShop.price * count) ~= data.price then
			TriggerBanEvent(xPlayer, 'tried to buy '..count..'x '..data.name..' for $'..data.price..(', actual cost is $'..(checkShop.price * count)))
		end

		if IfInventoryCanCarry(playerInventory[xPlayer.identifier], Config.MaxWeight, (data.weight * count)) then
			if data.price then
				if money >= data.price then
					exports.linden_logs:log(self.source, ('%s (%s) has added $%s to %s (total: $%s)'):format(self.name, self.identifier, money, accountName, newMoney))
					RemovePlayerInventory(src, xPlayer.identifier, 'money', data.price)
					AddPlayerInventory(xPlayer.identifier, data.name, count, nil, data.metadata)
					TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[xPlayer.identifier])
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not afford that (missing $'..(data.price - money)..')',2)
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
	local Player = ESX.GetPlayerFromId(src)
	Drops[dropid] = {}
	Drops[dropid].inventory = {}
	Drops[dropid].name = dropid
	Drops[dropid].slots = 51
	if data.type == 'swap' then
		TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.toItem)
		Drops[dropid].inventory[data.toSlot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toSlot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
		playerInventory[Player.identifier][data.fromSlot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromSlot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
	elseif data.type == 'freeslot' then
		TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.item)
		playerInventory[Player.identifier][data.emptyslot] = nil
		Drops[dropid].inventory[data.toSlot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toSlot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
		ItemNotify(src,data.item.name,data.item.count,'Removed')
	elseif data.type == 'yarimswap' then
		TriggerClientEvent('hsn-inventory:client:checkweapon',src,data.newslotItem)
		playerInventory[Player.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
		Drops[dropid].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
	end
	if not oneSync then coords = src end -- Support not using OneSync
	TriggerClientEvent('hsn-inventory:Client:addnewDrop', -1, coords, dropid, src)
	--TriggerClientEvent('hsn-inventory:client:openInventory',src,playerInventory[Player.identifier],Drops[dropid])
end

RegisterCommand('fixinv', function(source, args, rawCommand)
	local Player = ESX.GetPlayerFromId(source)
	TriggerClientEvent('hsn-inventory:client:refreshInventory',source,playerInventory[Player.identifier])
end)

RegisterServerEvent('hsn-inventory:server:refreshInventory')
AddEventHandler('hsn-inventory:server:refreshInventory',function()
	if notready then return end
	local Player = ESX.GetPlayerFromId(source)
	TriggerClientEvent('hsn-inventory:client:refreshInventory',source,playerInventory[Player.identifier])
end)

RegisterServerEvent('hsn-inventory:server:openInventory')
AddEventHandler('hsn-inventory:server:openInventory',function(data, coords)
	if notready then return end
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	if data ~= nil then
		if data.type == 'drop' then
			if Drops[data.id] ~= nil then
				if checkOpenable(src,data.id,data.coords) then
					TriggerClientEvent('hsn-inventory:client:openInventory',src,playerInventory[Player.identifier],Drops[data.id])
				end
			else
				if checkOpenable(src, 'Player'..src, GetEntityCoords(GetPlayerPed(src))) then
					TriggerClientEvent('hsn-inventory:client:openInventory',src,playerInventory[Player.identifier])
				else
					TriggerClientEvent('hsn-inventory:notification',src,'You can not open this inventory',2)
				end
			end
		elseif data.type == 'shop' then
			Shops[data.id.name] = {}
			Shops[data.id.name].inventory = SetupShopItems(data.id)
			Shops[data.id.name].name = data.index
			Shops[data.id.name].type = 'shop'
			Shops[data.id.name].slots = #Shops[data.id.name].inventory + 1
			Shops[data.id.name].coords = data.id.coords
			if not data.id.job or data.id.job == Player.job.name then
				if data.id.license then
					TriggerEvent('esx_license:checkLicense', src, data.id.license, function(haslicense)
						if haslicense then
							TriggerClientEvent('hsn-inventory:client:openInventory',src,playerInventory[Player.identifier],Shops[data.id.name])
						else
							TriggerClientEvent('hsn-inventory:notification',src,'You do not have a '..data.id.license..' license',2)
						end
					end)
				else
					TriggerClientEvent('hsn-inventory:client:openInventory',src,playerInventory[Player.identifier],Shops[data.id.name])
				end
			end
		elseif data.type == 'glovebox' then
			if checkOpenable(src,data.id) then
				Gloveboxes[data.id] = {}
				Gloveboxes[data.id].inventory =  GetItems(data.id)
				Gloveboxes[data.id].name = data.id
				Gloveboxes[data.id].type = 'glovebox'
				Gloveboxes[data.id].slots = data.slots
				TriggerClientEvent('hsn-inventory:client:openInventory',src,playerInventory[Player.identifier],Gloveboxes[data.id])
			end
		elseif data.type == 'trunk' then
			if checkOpenable(src,data.id) then
				Trunks[data.id] = {}
				Trunks[data.id].inventory =  GetItems(data.id)
				Trunks[data.id].name = data.id
				Trunks[data.id].type = 'trunk'
				Trunks[data.id].slots = data.slots
				TriggerClientEvent('hsn-inventory:client:openInventory',src,playerInventory[Player.identifier],Trunks[data.id])
			end
		end
	end
end)

RegisterServerEvent('hsn-inventory:server:OpenStash')
AddEventHandler('hsn-inventory:server:OpenStash',function(stash)
	OpenStash(source, stash)
end)

OpenStash = function(source, stash)
	if notready then return end
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	if Stashs[stash.id.name] == nil then
		Stashs[stash.id.name] = {}
		Stashs[stash.id.name].inventory = GetItems(stash.id.name)
		Stashs[stash.id.name].name = stash.id.name
		Stashs[stash.id.name].type = 'stash'
		Stashs[stash.id.name].slots = stash.id.slots
		Stash[stash.id.coords].coords = stash.id.coords
	end
	if checkOpenable(src,stash.id.name,stash.id.coords) then
		if not stash.id.job or stash.id.job == Player.job.name then
			TriggerClientEvent('hsn-inventory:client:openInventory',src,playerInventory[Player.identifier], Stashs[stash.id.name])
		end
	else
		TriggerClientEvent('hsn-inventory:notification',src,'You can not open this inventory',2)
	end
end

RegisterServerEvent('hsn-inventory:server:openTargetInventory')
AddEventHandler('hsn-inventory:server:openTargetInventory',function(TargetId)
	if notready then return end
	local Player = ESX.GetPlayerFromId(source)
	local tPlayer = ESX.GetPlayerFromId(TargetId)
	if source == TargetId then tPlayer = nil end -- Don't allow source and targetid to match
	if tPlayer and Player then
		if playerInventory[tPlayer.identifier] == nil then
			playerInventory[tPlayer.identifier] = {}
		end
		if checkOpenable(source, 'Player'..TargetId, GetEntityCoords(GetPlayerPed(TargetId))) then
			local data = {}
			data.name = 'Player'..TargetId -- do not touch
			data.type = 'TargetPlayer'
			data.slots = Config.PlayerSlot
			data.inventory = playerInventory[tPlayer.identifier]
			TriggerClientEvent('hsn-inventory:client:openInventory',source,playerInventory[Player.identifier], data)
		end
	end
end)

RegisterServerEvent('hsn-inventory:server:saveInventory')
AddEventHandler('hsn-inventory:server:saveInventory',function(data)
	if notready then return end
	SaveItems(data.type,data.invid)
end)

checkOpenable = function(source,id,coords)
	local src = source
	local returnData = false

	if oneSync and coords then
		local srcCoords = GetEntityCoords(GetPlayerPed(src))
		if #(vector3(coords.x, coords.y, coords.z) - srcCoords) > 5 then return false end
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
	local result = exports.ghmattimysql:executeSync('SELECT data FROM hsn_inventory WHERE name = @name', {
		['@name'] = id
	})
	if result[1] ~= nil then
		if result[1].data ~= nil then
			local Inventory = json.decode(result[1].data)
			for k,v in pairs(Inventory) do
				if v.metadata == nil then v.metadata = {} end
				returnData[v.slot] = {name = v.name ,label = ESXItems[v.name].label, weight = ESXItems[v.name].weight, slot = v.slot, count = v.count, description = ESXItems[v.name].description, metadata = v.metadata, stackable = ESXItems[v.name].stackable}
			end
		end
	end
	return returnData

end

GetInventory = function(inventory)
	local returnData = {}
	for k,v in pairs(inventory) do
		returnData[k] = {
			name = v.name,
			count = v.count,
			metadata = v.metadata,
			slot = k
		} 
	end
	return returnData
end

SaveItems = function(type,id)
	if type == 'stash' then
		local result = exports.ghmattimysql:executeSync('SELECT data FROM hsn_inventory WHERE name = @name', {
			['@name'] = id
		})
		if result[1] == nil then
			local inventory = GetInventory(Stashs[id].inventory)
			exports.ghmattimysql:execute('INSERT INTO hsn_inventory (name, data) VALUES (@name, @data)', {
				['@name'] = id,
				['@data'] = json.encode(inventory)
			})
		else
			local inventory = GetInventory(Stashs[id].inventory)
			exports.ghmattimysql:execute('UPDATE hsn_inventory SET data = @data WHERE name = @name', {
				['@data'] = json.encode(inventory),
				['@name'] = id
			})
		end
	elseif type == 'glovebox' then
		local result = exports.ghmattimysql:executeSync('SELECT data FROM hsn_inventory WHERE name = @name', {
			['@name'] = id
		})
		if result[1] == nil then
			local inventory = GetInventory(Gloveboxes[id].inventory)
			exports.ghmattimysql:execute('INSERT INTO hsn_inventory (name, data) VALUES (@name, @data)', {
				['@name'] = id,
				['@data'] = json.encode(inventory)
			})
		else
			local inventory = GetInventory(Gloveboxes[id].inventory)
			exports.ghmattimysql:execute('UPDATE hsn_inventory SET data = @data WHERE name = @name', {
				['@data'] = json.encode(inventory),
				['@name'] = id
			})
		end
	elseif type == 'trunk' then
		local result = exports.ghmattimysql:executeSync('SELECT data FROM hsn_inventory WHERE name = @name', {
			['@name'] = id
		})
		if result[1] == nil then
			local inventory = GetInventory(Trunks[id].inventory)
			exports.ghmattimysql:execute('INSERT INTO hsn_inventory (name, data) VALUES (@name, @data)', {
				['@name'] = id,
				['@data'] = json.encode(inventory)
			})
		else
			local inventory = GetInventory(Trunks[id].inventory)
			exports.ghmattimysql:execute('UPDATE hsn_inventory SET data = @data WHERE name = @name', {
				['@data'] = json.encode(inventory),
				['@name'] = id
			})
		end
	end
end



RegisterServerEvent('hsn-inventory:setcurrentInventory')
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

RegisterServerEvent('hsn-inventory:removecurrentInventory')
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
			print('^1[hsn-inventory]^1 One player left the game when his inventory open and inventory saved ^1[DUPE Alert]^1 ')
		end
	end
	for k,v in pairs(openedinventories) do
		if openedinventories[k].owner == src then
			openedinventories[k] = nil -- :)
			break
		end 
	end
end)

ItemNotify = function(source, item, count, type)
	count = tonumber(count)
	if count > 0 then TriggerClientEvent('hsn-inventory:client:addItemNotify',source,ESXItems[item], ('%s %sx'):format(type, count))
	else TriggerClientEvent('hsn-inventory:client:addItemNotify',source,ESXItems[item],'Used') end
end

--[[MoneySync = function(source, item)
	local Player = ESX.GetPlayerFromId(source)
	local getAccount = Player.getAccount(item)
	local itemCount = getItemCount(source, item)
	local newCount = itemCount - getAccount.money
	if getAccount.money < itemCount then
		Player.addAccountMoney(item, math.abs(newCount))
	elseif getAccount.money > itemCount then
		Player.removeAccountMoney(item, math.abs(newCount))
	end
end]]

RegisterServerEvent('hsn-inventory:server:useItem')
AddEventHandler('hsn-inventory:server:useItem',function(item)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	if playerInventory[Player.identifier][item.slot] ~= nil and playerInventory[Player.identifier][item.slot].name ~= nil then
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
				TriggerClientEvent('hsn-inventory:addAmmo',src,weps,playerInventory[Player.identifier][item.slot])
				return
			end
			useItem(src, playerInventory[Player.identifier][item.slot])
		end
	end
end)


RegisterServerEvent('hsn-inventory:server:reloadWeapon')
AddEventHandler('hsn-inventory:server:reloadWeapon',function(weapon)
	local Player = ESX.GetPlayerFromId(source)
	local ammo = {}
	ammo.name = weapon.ammotype
	ammo.count = getItemCount(source,ammo.name)
	if ammo.count > 0 then TriggerClientEvent('hsn-inventory:addAmmo',source,weapon.item.name,ammo)
	else
		playerInventory[Player.identifier][slot].metadata.ammo = 0
	end
end)

RegisterServerEvent('hsn-inventory:server:useItemfromSlot')
AddEventHandler('hsn-inventory:server:useItemfromSlot',function(slot)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	if playerInventory[Player.identifier] ~= nil then
		if playerInventory[Player.identifier][slot] == nil then
			return
		end
		if playerInventory[Player.identifier][slot] ~= nil and playerInventory[Player.identifier][slot].name ~= nil then
			if playerInventory[Player.identifier][slot].name:find('WEAPON_') then
				if playerInventory[Player.identifier][slot].metadata.durability ~= nil then
					if playerInventory[Player.identifier][slot].metadata.durability > 0 then
						TriggerClientEvent('hsn-inventory:client:weapon',src,playerInventory[Player.identifier][slot])
					else
						TriggerClientEvent('hsn-inventory:notification',src,'This weapon is broken',2)
					end
				elseif Config.Throwable[playerInventory[Player.identifier][slot].name] then
					TriggerClientEvent('hsn-inventory:client:weapon',src,playerInventory[Player.identifier][slot])
				end
			else
				if playerInventory[Player.identifier][slot].name:find('ammo') then
					local weps = Config.Ammos[playerInventory[Player.identifier][slot].name]
					TriggerClientEvent('hsn-inventory:addAmmo',src,weps,playerInventory[Player.identifier][slot])
					return
				end
				useItem(src, playerInventory[Player.identifier][slot])
			end
		end
	end
end)


RegisterServerEvent('hsn-inventory:server:decreasedurability')
AddEventHandler('hsn-inventory:server:decreasedurability',function(source, slot, weapon, ammo)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	local decreaseamount = 0
	if type(slot) == 'number' then
		if playerInventory[Player.identifier][slot] ~= nil then
			if playerInventory[Player.identifier][slot].metadata.durability ~= nil then
				if playerInventory[Player.identifier][slot].metadata.durability <= 0 then
					TriggerClientEvent('hsn-inventory:client:checkweapon',src,playerInventory[Player.identifier][slot])
					TriggerClientEvent('hsn-inventory:notification',src,'This weapon is broken',2)
					return
				end
				if Config.DurabilityDecreaseAmount[playerInventory[Player.identifier][slot].name] == nil then
					decreaseamount = 0.5 * (ammo / 15)
				elseif Config.DurabilityDecreaseAmount[playerInventory[Player.identifier][slot].name] then
					decreaseamount = Config.DurabilityDecreaseAmount[playerInventory[Player.identifier][slot].name] * (ammo / 15)
				else
					decreaseamount = amount * (ammo / 15)
				end
				playerInventory[Player.identifier][slot].metadata.durability = playerInventory[Player.identifier][slot].metadata.durability - decreaseamount
				if playerInventory[Player.identifier][slot].metadata.durability == 0 then
					--TriggerServerEvent('hsn-inventory:server:removeItem', src, data.item, 1)
				end
			end
			TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[Player.identifier])
		end
	end
end)

RegisterServerEvent('hsn-inventory:server:addweaponAmmo')
AddEventHandler('hsn-inventory:server:addweaponAmmo',function(slot,weapon,ammo,totalAmmo,removeAmmo,newAmmo)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	if playerInventory[Player.identifier][slot] ~= nil then
		if playerInventory[Player.identifier][slot].metadata.ammo ~= nil then
			local ammoweight = ESXItems[ammo].weight
			playerInventory[Player.identifier][slot].metadata.ammo = newAmmo
			playerInventory[Player.identifier][slot].metadata.ammoweight = 0 --[[(newAmmo * ammoweight)]]
			--playerInventory[Player.identifier][slot].weight = ESXItems[weapon.name].weight + (newAmmo * ammoweight) disable ammo weight for now
			RemovePlayerInventory(src,Player.identifier,ammo,removeAmmo)
		end
	end
	TriggerEvent('hsn-inventory:server:decreasedurability',src, slot,weapon,removeAmmo)
end)


RegisterServerEvent('hsn-inventory:server:updateWeapon')
AddEventHandler('hsn-inventory:server:updateWeapon',function(slot, item)
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	if playerInventory[Player.identifier][slot] ~= nil then
		if playerInventory[Player.identifier][slot].metadata ~= nil then
			playerInventory[Player.identifier][slot].metadata = item.metadata
			TriggerClientEvent('hsn-inventory:client:refreshInventory',src,playerInventory[Player.identifier])
		end
	end
end)

--[[ Example to remove an item with a specific metadata.type
RegisterCommand("remove", function(source, args, rawCommand)
	local Player = ESX.GetPlayerFromId(source)
	Player.removeInventoryItem(args[1], 1, args[2])
end)]]


--[[ Example to retrieve items and count from player inventory
	RegisterCommand("itemcount", function(source, args, rawCommand)
	local Player = ESX.GetPlayerFromId(source)
	for k, v in pairs(playerInventory[Player.identifier]) do
		print(  ('[%s] %s %s'):format(k, v.name, v.count)  )
	end
end)]]

RegisterNetEvent('hsn-inventory:client:removeItem')
AddEventHandler('hsn-inventory:client:removeItem',function(item, count, metadata)
	removeItem(source, item, count, metadata)
end)

removeItem = function(src, item, count, metadata)
	if item == nil then
		return
	end
	local Player = ESX.GetPlayerFromId(src)
	if count == nil then
		count = 1
	end
	RemovePlayerInventory(src,Player.identifier, item, count, nil, metadata)
end

addItem = function(src, item, count, metadata)
	if item == nil then
		return
	end
	local Player = ESX.GetPlayerFromId(src)
	if count == nil then
		count = 1
	end
	if playerInventory[Player.identifier] == nil then
		playerInventory[Player.identifier]  = {}
	end
	AddPlayerInventory(Player.identifier, item, count, nil, metadata)
	ItemNotify(src, item, count, 'Added')
end

getItemCount = function(src, item, metadata)
	if item == nil then
		return
	end
	local Player = ESX.GetPlayerFromId(src)
	if playerInventory[Player.identifier] == nil then
		return
	end
	local ItemCount = GetItemCount(Player.identifier, item, metadata)
	return ItemCount
end

getItem = function(src, item, metadata)
	if item == nil then
		return
	end
	local Player = ESX.GetPlayerFromId(src)
	if playerInventory[Player.identifier] == nil then
		return
	end
	local inventory = playerInventory[Player.identifier]
	local xItem = ESXItems[item]
	if not xItem then print('^1[hsn-inventory]^3 Item '.. item ..' does not exist^7') end
	if type(metadata) ~= 'table' then metadata = {type = metadata} end
	xItem.metadata = metadata
	xItem.count = 0
	for k, v in pairs(inventory) do
		if v.name == item and (v.metadata and is_table_equal(v.metadata, metadata)) then
			xItem.count = xItem.count + v.count
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
	local Player = ESX.GetPlayerFromId(src)
	if playerInventory[Player.identifier] == nil then
		return returnData
	end
	local inventory = playerInventory[Player.identifier]
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
		if not next(Config.ItemList[item.name]) then return end
		TriggerClientEvent('hsn-inventory:useItem', src, item)
	elseif ESX.UsableItemsCallbacks[item.name] ~= nil then
		TriggerEvent('esx:useItem', src, item.name)
	end
end

ESX.RegisterServerCallback('hsn-inventory:getItemCount',function(source, cb, item)
	if item == nil then
		return
	end
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	if playerInventory[Player.identifier] == nil then
		return
	end
	local ItemCount = GetItemCount(Player.identifier, item)
	cb(tonumber(ItemCount))
end)

ESX.RegisterServerCallback('hsn-inventory:getItem',function(source, cb, item, metadata)
	if item == nil then
		return
	end
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	if playerInventory[Player.identifier] == nil then
		return
	end
	local xItem = getItem(source, item, metadata)
	cb(xItem)
end)

ESX.RegisterServerCallback('hsn-inventory:getPlayerInventory',function(source,cb,playerId)
	local TargetPlayer = ESX.GetPlayerFromId(playerId)
	if playerInventory[TargetPlayer.identifier] == nil then
		playerInventory[TargetPlayer.identifier] = {}
	end
	cb(playerInventory[TargetPlayer.identifier])
end)



 ESX.RegisterServerCallback('hsn-inventory:server:gethottbarItems',function(source,cb)
	 local src = source
	 local Player = ESX.GetPlayerFromId(src)
	 if playerInventory[Player.identifier] == nil then
		 playerInventory[Player.identifier] = {}
	 end
	 local cbData = {
		 [1] = playerInventory[Player.identifier][1],
		 [2] = playerInventory[Player.identifier][2],
		 [3] = playerInventory[Player.identifier][3],
		 [4] = playerInventory[Player.identifier][4],
		 [5] = playerInventory[Player.identifier][5]
	 }
	 cb(cbData)
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
	playerInventory[identifier] = {}
	local returnData = {}
	local loop = 0

	if Config.ConvertToHSN then
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
						v.metadata.weaponlicense = GetRandomLicense()

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
	end

	local getAccounts = true
	for k,v in pairs(inventory) do
		if tonumber(v) ~= nil then -- Convert old inventory data to new format
			
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
				v.metadata.weaponlicense = GetRandomLicense()
			end
		end
		v.count = tonumber(v.count)
		if getAccounts and v.name:find('money') then getAccounts = false end
		if v.metadata and v.metadata.ammoweight then weight = v.metadata.ammoweight + ESXItems[v.name].weight else weight = tonumber(ESXItems[v.name].weight) end
		if not v.metadata or (v.metadata and next(v.metadata) == nil) then v.metadata = {} end
		playerInventory[identifier][v.slot] = {name = v.name ,label = ESXItems[v.name].label, weight = tonumber(weight), slot = v.slot, count = v.count, description = ESXItems[v.name].description, metadata = v.metadata, stackable = ESXItems[v.name].stackable}
	end

	
	if Config.ConvertToHSN and getAccounts then
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
			end
		end)
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		local Players = ESX.GetPlayers()
		for i=1, #Players, 1 do
			local Player = ESX.GetPlayerFromId(Players[i])
			local inventory = {}
			inventory = json.encode(GetInventory(playerInventory[Player.identifier]))
			exports.ghmattimysql:execute('UPDATE `users` SET inventory = @inventory WHERE identifier = @identifier', {
				['@inventory'] = inventory,
				['@identifier'] = Player.identifier
			})
		end
	end
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() == resourceName) then
		while notready do Citizen.Wait(50) end
		Citizen.Wait(50)
		local Players = ESX.GetPlayers()
		for k,v in pairs(Players) do
			local Player = ESX.GetPlayerFromId(v)
			playerInventory[Player.identifier] = {}
			exports.ghmattimysql:execute('SELECT inventory FROM users WHERE identifier = @identifier', {
				['@identifier'] = Player.identifier
			}, function(result)
				local inventory = {}
				if result[1].inventory and result[1].inventory ~= '' then
					inventory = json.decode(result[1].inventory)
				end
				TriggerEvent('hsn-inventory:setplayerInventory', Player.identifier, inventory)
			end)
		end
	end
end)


function getPlayerIdentification(xPlayer)
	return ('Sex: %s | Height: %s<br>DOB: %s (%s)'):format( xPlayer.get('sex'), xPlayer.get('height'), xPlayer.get('dateofbirth'), xPlayer.getIdentifier() )
end


function ValidateString(item)
	item = string.lower(item)
	if item:find('weapon_') then item = string.upper(item) end
	return item -- ESXItems[item]
end

-- Override the default ESX commands
ESX.RegisterCommand({'giveitem', 'additem'}, 'admin', function(xPlayer, args, showError)
	args.playerId.addInventoryItem(ValidateString(args.item), args.count, args.type)
end, true, {help = 'give an item to a player', validate = false, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'},
	{name = 'item', help = 'item name', type = 'item'},
	{name = 'count', help = 'item count', type = 'number'},
	{name = 'type', help = 'item metadata type', type='any'}
}})

ESX.RegisterCommand('removeitem', 'admin', function(xPlayer, args, showError)
	if notready then return end
	args.playerId.removeInventoryItem(ValidateString(args.item), args.count, args.type)
end, true, {help = 'remove an item from a player', validate = false, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'},
	{name = 'item', help = 'item name', type = 'item'},
	{name = 'count', help = 'item count', type = 'number'},
	{name = 'type', help = 'item metadata type', type='any'}
}})

ESX.RegisterCommand({'removeinventory', 'clearinventory'}, 'admin', function(xPlayer, args, showError)
	if notready then return end
	local Player = args.playerId
	local inventory = GetInventory(playerInventory[Player.identifier])
	for k,v in pairs(inventory) do
		RemovePlayerInventory(Player.source, Player.identifier, v.name, v.count, k, v.metadata)
	end
end, true, {help = 'clear a player\'s inventory', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'}
}})

ESX.RegisterCommand({'giveaccountmoney', 'givemoney'}, 'admin', function(xPlayer, args, showError)
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

ESX.RegisterCommand({'removeaccountmoney', 'removemoney'}, 'admin', function(xPlayer, args, showError)
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

ESX.RegisterCommand({'setaccountmoney', 'setmoney'}, 'admin', function(xPlayer, args, showError)
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
	{name = 'evidence', help = 'evidence #', type = 'number'}
}})
