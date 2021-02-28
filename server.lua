ESX = nil
local playerInventory = {}
local Stashs = {}
local Drops = {}
local ESXItems = {}
local Shops = {}
local invopened = {}
local openedinventories = {}
local Gloveboxes = {}
local Trunks = {}
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

print( ('^1[%s]^2 is starting..^7'):format('hsn-inventory') )
exports.ghmattimysql:ready(function()
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
                print( ('^1[%s]^3 Item `%s` is missing from your database! Item has been created with placeholder data.^7'):format('hsn-inventory', k) )
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
    end)
    print( ('^1[%s]^2 Items have been created!^7'):format('hsn-inventory') )
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

GetItemsSlot = function(inventory, name)
    local returnData = {}
    for k,v in pairs(inventory) do
        if v.name == name then
            table.insert(returnData,v)
        end
    end
    return returnData
end

GetItemCount = function(identifier, item)
    local count = 0
    for i,j in pairs(playerInventory[identifier]) do
        if (j.name == item) then
            count = count + j.count
        end
    end
    return count
end

AddPlayerInventory = function(identifier, item, count, slot, metadata)
    if playerInventory[identifier] == nil then
        playerInventory[identifier] = {}
    end
    local xPlayer = ESX.GetPlayerFromIdentifier(identifier)
    if ESXItems[item] ~= nil then
        if item ~= nil and count ~= nil then
            if item:find('WEAPON_') then
                count = 1 
                for i = 1, Config.PlayerSlot do
                    if playerInventory[identifier][i] == nil then
                        if metadata == nil then
                            metadata = {}
                            metadata.durability = 100
                            metadata.ammo = 0
                            metadata.components = {}
                        end
                        metadata.weaponlicense = GetRandomLicense(metadata.weaponlicense)
                        if metadata.registered == 'setname' then metadata.registered = xPlayer.getName() end
                        playerInventory[identifier][i] = {name = item ,label = ESXItems[item].label , weight = ESXItems[item].weight, slot = i, count = count, description = ESXItems[item].description, metadata = metadata or {}, stackable = false, closeonuse = ESXItems[item].closeonuse} -- because weapon :)
                        break
                    end
                end
            elseif item:find('identification') then
                count = 1 
                for i = 1, Config.PlayerSlot do
                    if playerInventory[identifier][i] == nil then
                        if metadata == nil then
                            metadata = {}
                            metadata.description = getPlayerIdentification(xPlayer)
                        end
                            playerInventory[identifier][i] = {name = item ,label = ESXItems[item].label , weight = ESXItems[item].weight, slot = i, count = count, description = ESXItems[item].description, metadata = metadata or {}, stackable = false, closeonuse = ESXItems[item].closeonuse}
                        break
                    end
                end
            else
                if slot ~= nil then
                    playerInventory[identifier][slot] = {name = item ,label = ESXItems[item].label, weight = ESXItems[item].weight, slot = i, count = count, description = ESXItems[item].description, metadata = metadata or {}, stackable = ESXItems[item].stackable, closeonuse = ESXItems[item].closeonuse}
                else
                    for i = 1, Config.PlayerSlot do
                        if playerInventory[identifier][i] ~= nil and playerInventory[identifier][i].name == item then
                            playerInventory[identifier][i] = {name = item ,label = ESXItems[item].label, weight = ESXItems[item].weight, slot = i, count = playerInventory[identifier][i].count + count, description = ESXItems[item].description, metadata = metadata or {}, stackable = ESXItems[item].stackable, closeonuse = ESXItems[item].closeonuse}
                            break
                        else
                            if playerInventory[identifier][i] == nil then
                                playerInventory[identifier][i] = {name = item ,label = ESXItems[item].label, weight = ESXItems[item].weight, slot = i, count =  count, description = ESXItems[item].description, metadata = metadata or {}, stackable = ESXItems[item].stackable, closeonuse = ESXItems[item].closeonuse}
                                break
                            end
                        end
                    end
                end
            end
        end
    else
        print("[^2hsn-inventory^0] - item not found")
    end
end

RemovePlayerInventory = function(identifier,item, count, slot, metadata)
    if ESXItems[item] ~= nil then
        for i = 1, Config.PlayerSlot do
            if playerInventory[identifier][i] ~= nil and playerInventory[identifier][i].name == item then
                playerInventory[identifier][i].count = tonumber(playerInventory[identifier][i].count)
                if playerInventory[identifier][i].count > count then
                    playerInventory[identifier][i].count = playerInventory[identifier][i].count - count
                    break
                elseif playerInventory[identifier][i].count == count then
                    playerInventory[identifier][i] = nil
                    break
                elseif playerInventory[identifier][i].count < count then
                    local slots = GetItemsSlot(playerInventory[identifier], item)
                    for i,j in pairs(slots) do
                        if j ~= nil then
                            j.count = tonumber(j.count)
                            if j.count - count < 0 then
                                local tempCount = playerInventory[identifier][j.slot].count
                                playerInventory[identifier][j.slot] = nil
                                count = count - tempCount
                            elseif j.count - count > 0 then
                                playerInventory[identifier][j.slot].count = playerInventory[identifier][j.slot] - count
                            elseif j.count - count == 0 then
                                playerInventory[identifier][j.slot] = nil
                            end
                        end
                    end
                    break
                end
            end
        end
    end
end

RandomDropId = function()
    local random = math.random(11111,99999)
    return random
end

RegisterNetEvent("inventory:isShopOpen")
AddEventHandler("inventory:isShopOpen",function(state)
    local state = state
    if state == false then
        shopOpen = false
    elseif state == true then
        shopOpen = true
    end
    return shopOpen        
end)

RegisterNetEvent("hsn-inventory:server:saveInventoryData")
AddEventHandler("hsn-inventory:server:saveInventoryData",function(data)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if data ~= nil then
        
        if data.frominv == data.toinv and (data.frominv == 'Playerinv') and not shopOpen then
            if data.type == 'swap' and not shopOpen then
                TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.fromItem)
                playerInventory[Player.identifier][data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
                playerInventory[Player.identifier][data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable}
            elseif data.type == 'freeslot' and not shopOpen then
                TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.item)
                playerInventory[Player.identifier][data.emptyslot] = nil
                playerInventory[Player.identifier][data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
            elseif data.type == 'yarimswap' and not shopOpen then
                TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.oldslotItem)
                playerInventory[Player.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
                playerInventory[Player.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
            end
        elseif data.frominv == data.toinv and (data.frominv == "drop") then
            local dropid = data.invid
            if data.type == 'swap' then
                Drops[dropid].inventory[data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
                Drops[dropid].inventory[data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable,closeonuse = ESXItems[data.fromItem.name].closeonuse}
            elseif data.type == 'freeslot' then
                Drops[dropid].inventory[data.emptyslot] = nil
                Drops[dropid].inventory[data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
            elseif data.type == 'yarimswap' then
                Drops[dropid].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
                Drops[dropid].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
            end
        elseif data.frominv == data.toinv and (data.frominv == "TargetPlayer") then
            local targetplayer = tPlayer
                if playerInventory[targetplayer.identifier] ~= nil then
                    if data.type == 'swap' then
                        playerInventory[targetplayer.identifier][data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
                        playerInventory[targetplayer.identifier][data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable,closeonuse = ESXItems[data.fromItem.name].closeonuse}
                    elseif data.type == 'freeslot' then
                         playerInventory[targetplayer.identifier][data.emptyslot] = nil
                         playerInventory[targetplayer.identifier][data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
                    elseif data.type == 'yarimswap' then
                         playerInventory[targetplayer.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
                         playerInventory[targetplayer.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
                    end
                end
        elseif data.frominv ~= data.toinv and (data.toinv == "TargetPlayer" and data.frominv == 'Playerinv') then
            local targetplayer = tPlayer
            if playerInventory[targetplayer.identifier] ~= nil then
                if data.type == 'swap' then
                    if IfInventoryCanCarry(playerInventory[targetplayer.identifier],ESX.GetConfig().MaxWeight, (data.toItem.weight * data.toItem.count)) then
                        TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.toItem)
                        playerInventory[targetplayer.identifier][data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
                        playerInventory[Player.identifier][data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
                        TriggerEvent("hsn-inventory:onRemoveInventoryItem",src,data.toItem.name,data.toItem.count)
                        TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.fromItem.name,data.fromItem.count)
                        TriggerEvent("hsn-inventory:onAddInventoryItem",targetplayer.source,data.toItem.name,data.toItem.count)
                        TriggerEvent("hsn-inventory:onRemoveInventoryItem",targetplayer.source,data.fromItem.name,data.fromItem.count)
                    else
                        TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                    end
                elseif data.type == 'freeslot' then
                    if IfInventoryCanCarry(playerInventory[targetplayer.identifier],ESX.GetConfig().MaxWeight, (data.item.weight * data.item.count))  then
                        TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.item)
                        playerInventory[Player.identifier][data.emptyslot] = nil
                        playerInventory[targetplayer.identifier][data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
                        TriggerEvent("hsn-inventory:onRemoveInventoryItem",src,data.item.name,data.item.count)
                        TriggerEvent("hsn-inventory:onAddInventoryItem",targetplayer.source,data.item.name,data.item.count)
                    else
                        TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                    end
                elseif data.type == 'yarimswap' then
                    if IfInventoryCanCarry(playerInventory[targetplayer.identifier],ESX.GetConfig().MaxWeight, (data.item.weight * data.item.count))  then
                        TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.newslotItem)
                        playerInventory[Player.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
                        playerInventory[targetplayer.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
                    else
                        TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                    end
                end
            end
        elseif data.frominv ~= data.toinv and (data.toinv == 'Playerinv' and data.frominv == 'TargetPlayer') then
            local targetplayer = tPlayer
            if playerInventory[targetplayer.identifier] ~= nil then
                if data.type == 'swap' then
                    if IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.toItem.weight * data.toItem.count)) then
                        TriggerClientEvent("hsn-inventory:client:checkweapon",targetplayer.source,data.toItem)
                        playerInventory[Player.identifier][data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
                        playerInventory[targetplayer.identifier][data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
                        TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.toItem.name,data.toItem.count)
                        TriggerEvent("hsn-inventory:onRemoveInventoryItem",src,data.fromItem.name,data.fromItem.count)
                        TriggerEvent("hsn-inventory:RemoveAddInventoryItem",src,data.toItem.name,data.toItem.count)
                        TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.fromItem.name,data.fromItem.count)
                    else
                        TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                    end
                elseif data.type == 'freeslot' then
                    if IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.item.weight * data.item.count))  then
                        TriggerClientEvent("hsn-inventory:client:checkweapon",targetplayer.source,data.item)
                        playerInventory[targetplayer.identifier][data.emptyslot] = nil
                        playerInventory[Player.identifier][data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
                        TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.item.name,data.item.count)
                        TriggerEvent("hsn-inventory:onRemoveInventoryItem",targetplayer.source,data.item.name,data.item.count)
                    else
                        TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                    end
                elseif data.type == 'yarimswap' then
                    if IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.newslotItem.weight * data.newslotItem.count)) then
                        TriggerClientEvent("hsn-inventory:client:checkweapon",targetplayer.source,data.newslotItem)
                        playerInventory[targetplayer.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
                        playerInventory[Player.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
                    else
                        TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                    end
                end
            end
        elseif data.frominv == data.toinv and (data.frominv == "stash") then
            local stashId = data.invid
            if data.type == 'swap' then
                Stashs[stashId].inventory[data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
                Stashs[stashId].inventory[data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
            elseif data.type == 'freeslot' then
                Stashs[stashId].inventory[data.emptyslot] = nil
                Stashs[stashId].inventory[data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
            elseif data.type == 'yarimswap' then
                Stashs[stashId].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
                Stashs[stashId].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
            end
        elseif data.frominv == data.toinv and (data.frominv == "trunk") then
            local plate = data.invid
            if data.type == 'swap' then
                Trunks[plate].inventory[data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
                Trunks[plate].inventory[data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
            elseif data.type == 'freeslot' then
                Trunks[plate].inventory[data.emptyslot] = nil
                Trunks[plate].inventory[data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
            elseif data.type == 'yarimswap' then
                Trunks[plate].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
                Trunks[plate].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
            end
        elseif data.frominv == data.toinv and (data.frominv == "glovebox") then
            local plate = data.invid
            if data.type == 'swap' then
                Gloveboxes[plate].inventory[data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
                Gloveboxes[plate].inventory[data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
            elseif data.type == 'freeslot' then
                Gloveboxes[plate].inventory[data.emptyslot] = nil
                Gloveboxes[plate].inventory[data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable}
            elseif data.type == 'yarimswap' then
                Gloveboxes[plate].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
                Gloveboxes[plate].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
            end
        elseif data.frominv ~= data.toinv and (data.toinv == "drop" and data.frominv == 'Playerinv') then
            local dropid = data.invid
            if dropid == nil then
                CreateNewDrop(src,data)
                TriggerClientEvent("hsn-inventory:client:closeInventory",src,data.invid)
            else
                if data.type == 'swap' then
                    TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.toItem)
                    Drops[dropid].inventory[data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
                    playerInventory[Player.identifier][data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
                    TriggerEvent("hsn-inventory:onRemoveInventoryItem",src,data.toItem.name,data.toItem.count)
                    TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.fromItem.name,data.fromItem.count)
                elseif data.type == 'freeslot' then
                    TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.item)
                    playerInventory[Player.identifier][data.emptyslot] = nil
                    Drops[dropid].inventory[data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
                    TriggerEvent("hsn-inventory:onRemoveInventoryItem",src,data.item.name,data.item.count)
                elseif data.type == 'yarimswap' then
                    TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.newslotItem)
                    playerInventory[Player.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
                    Drops[dropid].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
                end
            end
        elseif data.frominv ~= data.toinv and (data.toinv == 'Playerinv' and data.frominv == 'drop') then
            local dropid = data.invid2
            if data.type == 'swap' then
                if IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.toItem.weight * data.toItem.count)) then
                    playerInventory[Player.identifier][data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
                    Drops[dropid].inventory[data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
                    TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.toItem.name,data.toItem.count)
                    TriggerEvent("hsn-inventory:onRemoveInventoryItem",src,data.fromItem.name,data.fromItem.count)
                else
                    TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                end
            elseif data.type == 'freeslot' then
                if IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.item.weight * data.item.count))  then
                    Drops[dropid].inventory[data.emptyslot] = nil
                    playerInventory[Player.identifier][data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
                    TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.item.name,data.item.count)
                else
                    TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                end
            elseif data.type == 'yarimswap' then
                if IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.newslotItem.weight * data.newslotItem.count)) then
                    Drops[dropid].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
                    playerInventory[Player.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
                else
                    TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                end
            end
            if next(Drops[dropid].inventory) == nil then
                TriggerClientEvent("hsn-inventory:client:removeDrop",-1,dropid)
                TriggerClientEvent("hsn-inventory:client:closeInventory",src,dropid) -- 
            end
        elseif data.frominv ~= data.toinv and (data.toinv == "stash" and data.frominv == 'Playerinv') then
            local stashId = data.invid
            if data.type == 'swap' then
                TriggerEvent("hsn-inventory:onRemoveInventoryItem",src,data.toItem.name,data.toItem.count)
                TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.fromItem.name,data.fromItem.count)
                TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.toItem)
                Stashs[stashId].inventory[data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
                playerInventory[Player.identifier][data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
            elseif data.type == 'freeslot' then
                TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.item)
                playerInventory[Player.identifier][data.emptyslot] = nil
                Stashs[stashId].inventory[data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
                TriggerEvent("hsn-inventory:onRemoveInventoryItem",src,data.item.name,data.item.count)
            elseif data.type == 'yarimswap' then
                TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.newslotItem)
                playerInventory[Player.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
                Stashs[stashId].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
            end
        elseif data.frominv ~= data.toinv and (data.toinv == "trunk" and data.frominv == "Playerinv") then
            local plate = data.invid
            if data.type == 'swap' then
                TriggerEvent("hsn-inventory:onRemoveInventoryItem",src,data.toItem.name,data.toItem.count)
                TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.fromItem.name,data.fromItem.count)
                TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.toItem)
                Trunks[plate].inventory[data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
                playerInventory[Player.identifier][data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
            elseif data.type == 'freeslot' then
                TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.item)
                TriggerEvent("hsn-inventory:onRemoveInventoryItem",src,data.item.name,data.item.count)
                playerInventory[Player.identifier][data.emptyslot] = nil
                Trunks[plate].inventory[data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
            elseif data.type == 'yarimswap' then
                TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.newslotItem)
                playerInventory[Player.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
                Trunks[plate].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
            end
        elseif data.frominv ~= data.toinv and (data.toinv == "Playerinv" and data.frominv == "trunk") then
            local plate = data.invid2
            if data.type == 'swap' then
                if  IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.toItem.weight * data.toItem.count))  then
                    playerInventory[Player.identifier][data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
                    Trunks[plate].inventory[data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
                    TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.toItem.name,data.toItem.count)
                    TriggerEvent("hsn-inventory:onRemoveInventoryItem",src,data.fromItem.name,data.fromItem.count)
                else
                    TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                end
            elseif data.type == 'freeslot' then
                if  IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.item.weight * data.item.count))  then    
                    Trunks[plate].inventory[data.emptyslot] = nil
                    playerInventory[Player.identifier][data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
                    TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.item.name,data.item.count)
                else
                    TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                end
            elseif data.type == 'yarimswap' then
                if  IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.newslotItem.weight * data.newslotItem.count))  then    
                    Trunks[plate].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
                    playerInventory[Player.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
                else
                    TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                end
            end
        elseif data.frominv ~= data.toinv and (data.toinv == "glovebox" and data.frominv == "Playerinv") then
            local plate = data.invid
            if data.type == 'swap' then
                TriggerEvent("hsn-inventory:onRemoveInventoryItem",src,data.toItem.name,data.toItem.count)
                TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.fromItem.name,data.fromItem.count)
                TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.toItem)
                Gloveboxes[plate].inventory[data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
                playerInventory[Player.identifier][data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
            elseif data.type == 'freeslot' then
                TriggerEvent("hsn-inventory:onRemoveInventoryItem",src,data.item.name,data.item.count)
                TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.item)
                playerInventory[Player.identifier][data.emptyslot] = nil
                Gloveboxes[plate].inventory[data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
            elseif data.type == 'yarimswap' then
                TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.newslotItem)
                playerInventory[Player.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
                Gloveboxes[plate].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
            end
        elseif data.frominv ~= data.toinv and (data.toinv == "Playerinv" and data.frominv == "glovebox") then
            local plate = data.invid2
            if data.type == 'swap' then
                if  IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.toItem.weight * data.toItem.count))  then    
                    playerInventory[Player.identifier][data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
                    Gloveboxes[plate].inventory[data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
                    TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.toItem.name,data.toItem.count)
                    TriggerEvent("hsn-inventory:onRemoveInventoryItem",src,data.fromItem.name,data.fromItem.count)
                else
                    TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                end
            elseif data.type == 'freeslot' then
                TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.item.name,data.item.count)
                if IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.item.weight * data.item.count)) then
                    Gloveboxes[plate].inventory[data.emptyslot] = nil
                    playerInventory[Player.identifier][data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
                else
                    TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                end
            elseif data.type == 'yarimswap' then
                if  IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.oldslotItem.weight * data.oldslotItem.count))  then    
                    Gloveboxes[plate].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
                    playerInventory[Player.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
                else
                    TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                end
            end
        elseif data.frominv ~= data.toinv and (data.toinv == "Playerinv" and data.frominv == 'stash') then
            local stashId = data.invid2
            if data.type == 'swap' then
                if IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.toItem.weight * data.toItem.count)) then
                    TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.toItem.name,data.toItem.count)
                    TriggerEvent("hsn-inventory:onRemoveInventoryItem",src,data.fromItem.name,data.fromItem.count)
                    playerInventory[Player.identifier][data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
                    Stashs[stashId].inventory[data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
                else
                    TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                end
            elseif data.type == 'freeslot' then
                if IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.item.weight * data.item.count)) then
                    Stashs[stashId].inventory[data.emptyslot] = nil
                    playerInventory[Player.identifier][data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
                    TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.item.name,data.item.count)
                else
                    TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                end
            elseif data.type == 'yarimswap' then
                if IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.newslotItem.weight * data.newslotItem.count)) then
                    Stashs[stashId].inventory[data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
                    playerInventory[Player.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
                else
                    TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                end
            end
        elseif data.frominv ~= data.toinv and (data.toinv == "Playerinv" and data.frominv == 'shop') then
            if data.type == 'swap' then
                return TriggerClientEvent("hsn-inventory:notification",src,'You can not return your items',2)
            elseif data.type == 'freeslot' then
                if IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.item.weight * data.item.count)) then
                    local money = Player.getMoney()
                    if (money >= (data.item.price * data.item.count)) then
                        Player.removeMoney(data.item.price * data.item.count)
                        TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.item.name,data.item.count)
                        if data.item.name:find('WEAPON_') then
                            if not data.item.metadata then data.item.metadata = {} end
                            data.item.metadata.weaponlicense = GetRandomLicense(data.item.metadata.weaponlicense)
                            if data.item.metadata.registered == 'setname' then data.item.metadata.registered = Player.getName() end
                            if not data.item.metadata.components then data.item.metadata.components = {} end
                            data.item.metadata.ammo = 0
                            data.item.metadata.durability = 100
                        elseif data.item.name:find('identification') then
                            data.item.metadata = {}
                            data.item.metadata.description = getPlayerIdentification(Player)
                        end
                            playerInventory[Player.identifier][data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
                            TriggerClientEvent("hsn-inventory:client:refreshInventory",src,playerInventory[Player.identifier])
                    else
                        TriggerClientEvent("hsn-inventory:notification",src,'You can not afford this item ('..data.item.price * data.item.count..'$)',2)
                        TriggerClientEvent("hsn-inventory:client:refreshInventory",src,playerInventory[Player.identifier])
                    end
                else
                    TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                end
            elseif data.type == 'yarimswap' then
                local money = Player.getMoney()
                if IfInventoryCanCarry(playerInventory[Player.identifier],ESX.GetConfig().MaxWeight, (data.newslotItem.weight * data.newslotItem.count)) then
                    if (money >= (data.newslotItem.price *  data.newslotItem.count)) then
                        if data.newslotItem.name:find('WEAPON_') then
                            if not data.newslotItem.metadata then data.newslotItem.metadata = {} end
                            if data.newslotItem.metadata.registered == 'setname' then data.newslotItem.metadata.registered = Player.getName() end
                            data.newslotItem.metadata.weaponlicense = GetRandomLicense(data.newslotItem.metadata.weaponlicense)
                            if not data.newslotItem.metadata.components then data.newslotItem.metadata.components = {} end
                            data.newslotItem.metadata.ammo = 0
                            data.newslotItem.metadata.durability = 100
                        elseif data.newslotItem.name:find('identification') then
                            data.newslotItem.metadata = {}
                            data.newslotItem.metadata.description = getPlayerIdentification(Player)
                        end
                        Player.removeMoney(data.newslotItem.price *  data.newslotItem.count)
                        playerInventory[Player.identifier][data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
                        TriggerEvent("hsn-inventory:onAddInventoryItem",src,data.newslotItem.name,data.newslotItem.count)
                    else
                        Citizen.Wait(5)
                        TriggerClientEvent("hsn-inventory:client:refreshInventory",src,playerInventory[Player.identifier])
                        TriggerClientEvent("hsn-inventory:notification",src,'You can not afford this item ('..data.newslotItem.price *  data.newslotItem.count..'$)',2)
                    end
                else
                    TriggerClientEvent("hsn-inventory:notification",src,"You can not carry this item",2)
                end
            end
        elseif data.frominv ~= data.toinv and (data.toinv == "shop" and data.frominv == 'Playerinv') then
            TriggerClientEvent("hsn-inventory:client:refreshInventory",src,playerInventory[Player.identifier])
            return TriggerClientEvent("hsn-inventory:notification",src,'You can not return your items',2)
        end
        -- Sync ESX money with hsn-inventory
        local money = exports["hsn-inventory"]:getItemCount(src,'money')
        Player.setMoney(money)
        local blackmoney = exports["hsn-inventory"]:getItemCount(src,'black_money')
        Player.setAccountMoney('black_money', blackmoney)
    end
end)




CreateNewDrop = function(source,data)
    local src = source
    local dropid = RandomDropId()
    local Player = ESX.GetPlayerFromId(src)
    Drops[dropid] = {}
    Drops[dropid].inventory = {}
    Drops[dropid].name = dropid
    Drops[dropid].slots = 50
    if data.type == 'swap' then
        TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.toItem)
        Drops[dropid].inventory[data.toslot] = {name = data.toItem.name ,label = data.toItem.label, weight = data.toItem.weight, slot = data.toslot, count = data.toItem.count, description = data.toItem.description, metadata = data.toItem.metadata, stackable = data.toItem.stackable, closeonuse = ESXItems[data.toItem.name].closeonuse}
        playerInventory[Player.identifier][data.fromslot] = {name = data.fromItem.name ,label = data.fromItem.label, weight = data.fromItem.weight, slot = data.fromslot, count = data.fromItem.count, description = data.fromItem.description, metadata = data.fromItem.metadata, stackable = data.fromItem.stackable, closeonuse = ESXItems[data.fromItem.name].closeonuse}
    elseif data.type == 'freeslot' then
        TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.item)
        playerInventory[Player.identifier][data.emptyslot] = nil
        Drops[dropid].inventory[data.toslot] = {name = data.item.name ,label = data.item.label, weight = data.item.weight, slot = data.toslot, count = data.item.count, description = data.item.description, metadata = data.item.metadata, stackable = data.item.stackable, closeonuse = ESXItems[data.item.name].closeonuse}
        TriggerEvent("hsn-inventory:onRemoveInventoryItem",src,data.item.name,data.item.count)
    elseif data.type == 'yarimswap' then
        TriggerClientEvent("hsn-inventory:client:checkweapon",src,data.newslotItem)
        playerInventory[Player.identifier][data.fromSlot] = {name = data.oldslotItem.name ,label = data.oldslotItem.label, weight = data.oldslotItem.weight, slot = data.fromSlot, count = data.oldslotItem.count, description = data.oldslotItem.description, metadata = data.oldslotItem.metadata, stackable = data.oldslotItem.stackable, closeonuse = ESXItems[data.oldslotItem.name].closeonuse}
        Drops[dropid].inventory[data.toSlot] = {name = data.newslotItem.name ,label = data.newslotItem.label, weight = data.newslotItem.weight, slot = data.toSlot, count = data.newslotItem.count, description = data.newslotItem.description, metadata = data.newslotItem.metadata, stackable = data.newslotItem.stackable, closeonuse = ESXItems[data.newslotItem.name].closeonuse}
    end
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    TriggerClientEvent("hsn-inventory:Client:addnewDrop", -1, coords, dropid)
end

-- Override the default ESX command (only works on ESX 1.2+ and EXM)
ESX.RegisterCommand({'giveitem', 'additem'}, 'admin', function(xPlayer, args, showError)
	args.playerId.addInventoryItem(args.item, args.count)
end, true, {help = 'give an item to a player', validate = true, arguments = {
	{name = 'playerId', help = 'player id', type = 'player'},
	{name = 'item', help = 'item name', type = 'string'},
	{name = 'count', help = 'item count', type = 'number'}
}})

--[[    Use this command instead for ESX 1.1
RegisterCommand("addItem",function(source,args)
    if source == 0 then
        return
    end
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if Player.getGroup() == "superadmin" or Player.getGroup() == "admin" then
        local tPlayerId = tonumber(args[1])
        local item = args[2]
        local count = tonumber(args[3])
        local tPlayer = ESX.GetPlayerFromId(tPlayerId)
        if tPlayer == nil then
            return
        end
        tPlayer.addInventoryItem(item, count)
    end
end)
]]

RegisterCommand("fixinv", function(source, args, rawCommand)
    local Player = ESX.GetPlayerFromId(source)
    TriggerClientEvent("hsn-inventory:client:refreshInventory",source,playerInventory[Player.identifier])
end)

RegisterServerEvent("hsn-inventory:server:refreshInventory")
AddEventHandler("hsn-inventory:server:refreshInventory",function()
    local Player = ESX.GetPlayerFromId(source)
    TriggerClientEvent("hsn-inventory:client:refreshInventory",source,playerInventory[Player.identifier])
end)

RegisterServerEvent("hsn-inventory:server:openInventory")
AddEventHandler("hsn-inventory:server:openInventory",function(data)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if data ~= nil then
        if data.type == 'drop' then
            if Drops[data.id] ~= nil then
                if checkOpenable(src,data.id) then
                    TriggerClientEvent("hsn-inventory:client:openInventory",src,playerInventory[Player.identifier],Drops[data.id])
                end
            else
                TriggerClientEvent("hsn-inventory:client:openInventory",src,playerInventory[Player.identifier])
            end
        elseif data.type == 'shop' then
            Shops[data.id.name] = {}
            Shops[data.id.name].inventory = SetupShopItems(data.id)
            Shops[data.id.name].name = data.id.name or 'Shop'
            Shops[data.id.name].type = 'shop'
            Shops[data.id.name].slots = #Shops[data.id.name].inventory + 1
            if not data.id.job or data.id.job == Player.job.name then
                TriggerClientEvent("hsn-inventory:client:openInventory",src,playerInventory[Player.identifier],Shops[data.id.name])
            end
        elseif data.type == "glovebox" then
            if checkOpenable(src,data.id) then
                Gloveboxes[data.id] = {}
                Gloveboxes[data.id].inventory =  GetItems(data.id)
                Gloveboxes[data.id].name = data.id
                Gloveboxes[data.id].type = 'glovebox'
                Gloveboxes[data.id].slots = 100
                TriggerClientEvent("hsn-inventory:client:openInventory",src,playerInventory[Player.identifier],Gloveboxes[data.id])
            end
        elseif data.type == "trunk" then
            if checkOpenable(src,data.id) then
                Trunks[data.id] = {}
                Trunks[data.id].inventory =  GetItems(data.id)
                Trunks[data.id].name = data.id
                Trunks[data.id].type = 'trunk'
                Trunks[data.id].slots = 100
                TriggerClientEvent("hsn-inventory:client:openInventory",src,playerInventory[Player.identifier],Trunks[data.id])
            end
        end
    else
        TriggerClientEvent("hsn-inventory:client:openInventory",src,playerInventory[Player.identifier])
    end
end)

RegisterServerEvent("hsn-inventory:server:openStash")
AddEventHandler("hsn-inventory:server:openStash",function(stash)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if Stashs[stash.id.name] == nil then
        Stashs[stash.id.name] = {}
        Stashs[stash.id.name].inventory = GetItems(stash.id.name)
        Stashs[stash.id.name].name = stash.id.name
        Stashs[stash.id.name].type = 'stash'
        Stashs[stash.id.name].slots = stash.slots
    end
    if checkOpenable(src,stash.id.name,stash.id.coords) then
        if not stash.id.job or stash.id.job == Player.job.name then
            TriggerClientEvent("hsn-inventory:client:openInventory",src,playerInventory[Player.identifier], Stashs[stash.id.name])
        end
    else
        TriggerClientEvent("hsn-inventory:notification",src,'You can not open this inventory',2)
    end
end)


RegisterServerEvent("hsn-inventory:server:openTargetInventory")
AddEventHandler("hsn-inventory:server:openTargetInventory",function(TargetId)
    local Player = ESX.GetPlayerFromId(source)
    if not source == TargetId then tPlayer = ESX.GetPlayerFromId(TargetId) end -- Don't allow source and targetid to match
    if playerInventory[tPlayer.identifier] == nil then
        playerInventory[tPlayer.identifier] = {}
    end
    if tPlayer and Player then
        if checkOpenable(source,'Player'..TargetId,GetEntityCoords(GetPlayerPed(TargetId))) then
            local data = {}
            data.name = 'Player'..TargetId -- do not touch
            data.type = "TargetPlayer"
            data.slots = Config.PlayerSlot
            data.inventory = playerInventory[tPlayer.identifier]
            TriggerClientEvent("hsn-inventory:client:openInventory",source,playerInventory[Player.identifier], data)
        end
    end
end)

RegisterServerEvent("hsn-inventory:server:saveInventory")
AddEventHandler("hsn-inventory:server:saveInventory",function(data)
    SaveItems(data.type,data.invid)
end)

checkOpenable = function(source,id,coords)
    local src = source
    local returnData = false

    if coords then
        local srcCoords = GetEntityCoords(GetPlayerPed(src))
        if #(coords - srcCoords) > 5 then return false end
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
            inventory[k] = {name = v.name ,label = ESXItems[v.name].label, weight = ESXItems[v.name].weight, slot = k, count = v.count, description = ESXItems[v.name].description, metadata = v.metadata or {}, stackable = ESXItems[v.name].stackable,price = v.price}
        else
            print("^1[hsn-inventory]^1 Item Not Found Check config.lua/Config.Shops and your items table^7")
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
                returnData[v.slot] = {name = v.name ,label = ESXItems[v.name].label, weight = ESXItems[v.name].weight, slot = v.slot, count = v.count, description = ESXItems[v.name].description, metadata = v.metadata or {}, stackable = ESXItems[v.name].stackable}
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
    if type == "stash" then
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
    elseif type == "glovebox" then
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
    elseif type == "trunk" then
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



RegisterServerEvent("hsn-inventory:setcurrentInventory")
AddEventHandler("hsn-inventory:setcurrentInventory",function(other)
    local src = source
    if other ~= nil then
        invopened[src] = {
            curInventory = other.name,
            type = other.type,
            invopened = true
        }
    end
end)

RegisterServerEvent("hsn-inventory:removecurrentInventory")
AddEventHandler("hsn-inventory:removecurrentInventory",function(name)
    local src = source
    if invopened[src] ~= nil then
        invopened[src] = nil
    end
    if openedinventories[name] ~= nil then
        openedinventories[name] = nil
    end
end)


AddEventHandler('playerDropped', function(reason) --  https://github.com/CylexVII <3
    local src = source
    if invopened[src] ~= nil then
        if invopened[src].curInventory ~= nil and invopened[src].invopened then
            SaveItems(invopened[src].type,invopened[src].curInventory)
            invopened[src] = nil
            print("^1[hsn-inventory]^1 One player left the game when his inventory open and inventory saved ^1[DUPE Alert]^1 ")
        end
    end
    for k,v in pairs(openedinventories) do
        if openedinventories[k].owner == src then
            openedinventories[k] = nil -- :)
            break
        end 
    end
end)

RegisterNetEvent("hsn-inventory:onAddInventoryItem")
AddEventHandler("hsn-inventory:onAddInventoryItem",function(source,item,count)
    TriggerClientEvent("hsn-inventory:client:addItemNotify",source,ESXItems[item],'Added '..count..'x')
end)

RegisterNetEvent("hsn-inventory:onRemoveInventoryItem")
AddEventHandler("hsn-inventory:onRemoveInventoryItem",function(source,item,count)
    TriggerClientEvent("hsn-inventory:client:addItemNotify",source,ESXItems[item],'Removed '..count..'x')
end)

RegisterServerEvent("hsn-inventory:server:useItem")
AddEventHandler("hsn-inventory:server:useItem",function(item,slot)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if playerInventory[Player.identifier][item.slot] ~= nil and playerInventory[Player.identifier][item.slot].name ~= nil then
        if item.name:find("WEAPON_") then
            if item.metadata.durability ~= nil then
                if item.metadata.durability > 0 then 
                    TriggerClientEvent("hsn-inventory:client:weapon",src,item)
                else
                    TriggerClientEvent("hsn-inventory:notification",src,'This weapon is broken',2)
                end
            end
        else
            if item.name:find("hsn") then
                local weps = Config.Ammos[item.name]
                TriggerClientEvent("hsn-inventory:addAmmo",src,weps,item.name)
                return
            end
            Player.useItem(item)
        end
    end
end)

RegisterServerEvent("hsn-inventory:server:useItemfromSlot")
AddEventHandler("hsn-inventory:server:useItemfromSlot",function(slot)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if playerInventory[Player.identifier] ~= nil then
        if playerInventory[Player.identifier][slot] == nil then
            return
        end
        if playerInventory[Player.identifier][slot] ~= nil and playerInventory[Player.identifier][slot].name ~= nil then
            if playerInventory[Player.identifier][slot].name:find("WEAPON_") then
                if playerInventory[Player.identifier][slot].metadata.durability > 0 then
                    TriggerClientEvent("hsn-inventory:client:weapon",src,playerInventory[Player.identifier][slot])
                    --TriggerClientEvent("hsn-inventory:client:addItemNotify",source,ESXItems[playerInventory[Player.identifier][slot].name],1,'use')
                else
                    TriggerClientEvent("hsn-inventory:notification",src,'This weapon is broken',2)
                end
            else
                if playerInventory[Player.identifier][slot].name:find("hsn") then
                    local weps = Config.Ammos[playerInventory[Player.identifier][slot].name]
                    TriggerClientEvent("hsn-inventory:addAmmo",src,weps,playerInventory[Player.identifier][slot].name)
                    return
                end
                Player.useItem(playerInventory[Player.identifier][slot])
                --TriggerClientEvent("hsn-inventory:client:addItemNotify",source,ESXItems[playerInventory[Player.identifier][slot].name],'Used 1x')
            end
        end
    end
end)


RegisterServerEvent("hsn-inventory:server:decreasedurability")
AddEventHandler("hsn-inventory:server:decreasedurability",function(slot, amount)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    local decreaseamount = 0
    if type(slot) == "number" then
        if playerInventory[Player.identifier][slot] ~= nil then
            if playerInventory[Player.identifier][slot].metadata.durability ~= nil then
                if  playerInventory[Player.identifier][slot].metadata.durability <= 0 then
                    TriggerClientEvent("hsn-inventory:client:checkweapon",src,playerInventory[Player.identifier][slot])
                    TriggerClientEvent("hsn-inventory:notification",src,'This weapon is broken',2)
                    return
                end
                if Config.DurabilityDecreaseAmount[playerInventory[Player.identifier][slot].name] == nil and not amount then
                    decreaseamount = 0.5
                elseif Config.DurabilityDecreaseAmount[playerInventory[Player.identifier][slot].name] then
                    decreaseamount = Config.DurabilityDecreaseAmount[playerInventory[Player.identifier][slot].name]
                else
                    decreaseamount = amount
                end
                playerInventory[Player.identifier][slot].metadata.durability = playerInventory[Player.identifier][slot].metadata.durability - decreaseamount
                if playerInventory[Player.identifier][slot].metadata.durability == 0 then
                    TriggerServerEvent('hsn-inventory:server:removeItem', src, data.item, 1)
                end
            end
            if playerInventory[Player.identifier][slot].metadata.ammo ~= nil then
                playerInventory[Player.identifier][slot].metadata.ammo = playerInventory[Player.identifier][slot].metadata.ammo - 1
            end
        end
    end
end)




RegisterServerEvent("hsn-inventory:server:addweaponAmmo")
AddEventHandler("hsn-inventory:server:addweaponAmmo",function(slot,count)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if  playerInventory[Player.identifier][slot] ~= nil then
        if playerInventory[Player.identifier][slot].metadata.ammo ~= nil then
            playerInventory[Player.identifier][slot].metadata.ammo = playerInventory[Player.identifier][slot].metadata.ammo + count
        end
    end
end)

RegisterServerEvent("hsn-inventory:server:removeItem")
AddEventHandler("hsn-inventory:server:removeItem",function(source, item, count)
    if count == 0 then return end
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if item == nil then
        return
    end
    if count == nil then
        count = 1
    end
    TriggerClientEvent("hsn-inventory:client:addItemNotify",src,ESXItems[item],'Removed '..count..'x')
    RemovePlayerInventory(Player.identifier,item,count)
end)

RegisterServerEvent("hsn-inventory:server:addItem")
AddEventHandler("hsn-inventory:server:addItem",function(src, item, count)
    local Player = ESX.GetPlayerFromId(src)
    if item == nil then
        return
    end
    if count == nil then
        count = 1
    end
    if playerInventory[Player.identifier] == nil then
        playerInventory[Player.identifier]  = {}
    end
    AddPlayerInventory(Player.identifier, item, count)
    TriggerClientEvent("hsn-inventory:client:addItemNotify",src,ESXItems[item],'Added '..count..'x')
end)

RegisterServerEvent("hsn-inventory:client:removeItem")
AddEventHandler("hsn-inventory:client:removeItem",function(item, count)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    Player.removeInventoryItem(item, count)
end)

RegisterServerEvent("hsn-inventory:client:addItem")
AddEventHandler("hsn-inventory:client:addItem",function(item, count)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if item == nil then
        return
    end
    if count == nil then
        count = 1
    end
    if playerInventory[Player.identifier] == nil then
        playerInventory[Player.identifier]  = {}
    end
    AddPlayerInventory(Player.identifier, item, count)
    TriggerClientEvent("hsn-inventory:client:addItemNotify",src,ESXItems[item],'Added '..count..'x')
end)

exports("removeItem", function(src, item, count)
    local Player = ESX.GetPlayerFromId(src)
    if item == nil then
        return
    end
    if count == nil then
        count = 1
    end
    RemovePlayerInventory(Player.identifier,item,count)
    TriggerClientEvent("hsn-inventory:client:addItemNotify",src,ESXItems[item],'Removed '..count..'x')
end)

exports("addItem", function(src, item, count, metadata)
    local Player = ESX.GetPlayerFromId(src)
    if item == nil then
        return
    end
    if count == nil then
        count = 1
    end
    if playerInventory[Player.identifier] == nil then
        playerInventory[Player.identifier]  = {}
    end
    AddPlayerInventory(Player.identifier, item, count, nil, metadata)
    TriggerClientEvent("hsn-inventory:client:addItemNotify",src,ESXItems[item],'Added '..count..'x')
end)

exports("getItemCount",function(src, item)
    local Player = ESX.GetPlayerFromId(src)
    if playerInventory[Player.identifier] == nil then
        return
    end
    local ItemCount = GetItemCount(Player.identifier, item)
    return ItemCount
end)

exports("getItem",function(src, item)
    local Player = ESX.GetPlayerFromId(src)
    if playerInventory[Player.identifier] == nil then
        return
    end
    local ESXItem = ESXItems[item]
    ESXItem.count = GetItemCount(Player.identifier, item)
    return ESXItem
end)

exports('useItem', function(src, item)
    if Config.ItemList[item.name] then
        if not next(Config.ItemList[item.name]) then return end
        TriggerClientEvent('hsn-inventory:useItem', src, item)
    elseif ESX.UsableItemsCallbacks[item.name] ~= nil then
        TriggerEvent("esx:useItem", src, item.name)
    end
end)

--[[ Example to retrieve items and count from player inventory
    RegisterCommand("getitems", function(source, args, rawCommand)
    local Player = ESX.GetPlayerFromId(source)
    for k, v in pairs(ESXItems) do
        v.count = GetItemCount(Player.identifier, v.name)
        if v.count > 0 then print(v.name.. ' ' ..v.count) end
    end
end)]]

RegisterNetEvent("hsn-inventory:server:getItemCount")
AddEventHandler("hsn-inventory:server:getItemCount",function(source,cb,item)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if playerInventory[Player.identifier] == nil then
        return
    end
    local ItemCount = GetItemCount(Player.identifier, item)
    if cb then
        cb(tonumber(ItemCount))
    end
end)




ESX.RegisterServerCallback("hsn-inventory:getItemCount",function(source, cb, item)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if playerInventory[Player.identifier] == nil then
        return
    end
    local ItemCount = GetItemCount(Player.identifier, item)
    cb(tonumber(ItemCount))
end)

ESX.RegisterServerCallback("hsn-inventory:getItem",function(source, cb, item)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if playerInventory[Player.identifier] == nil then
        return
    end
    local ESXItem = ESXItems[item]
    ESXItem.count = GetItemCount(Player.identifier, item)
    cb(ESXItem)
end)



ESX.RegisterServerCallback("hsn-inventory:getPlayerInventory",function(source,cb,playerId)
    local TargetPlayer = ESX.GetPlayerFromId(playerId)
    if playerInventory[TargetPlayer.identifier] == nil then
        playerInventory[TargetPlayer.identifier] = {}
    end
    cb(playerInventory[TargetPlayer.identifier])
end)



-- ESX.RegisterServerCallback("hsn-inventory:server:gethottbarItems",function(source,cb)
--     local src = source
--     local Player = ESX.GetPlayerFromId(src)
--     if playerInventory[Player.identifier] == nil then
--         playerInventory[Player.identifier] = {}
--     end
--     local cbData = {
--         [1] = playerInventory[Player.identifier][1],
--         [2] = playerInventory[Player.identifier][2],
--         [3] = playerInventory[Player.identifier][3],
--         [4] = playerInventory[Player.identifier][4],
--         [5] = playerInventory[Player.identifier][5]
--     }
--     cb(cbData)
-- end)

RegisterNetEvent("hsn-inventory:getplayerInventory")
AddEventHandler("hsn-inventory:getplayerInventory",function(cb,identifier)
    if playerInventory[identifier] == nil then
        playerInventory[identifier] = {}
    end
    if cb then
        cb(GetInventory(playerInventory[identifier]))
    end
end)


RegisterNetEvent("hsn-inventory:setplayerInventory")
AddEventHandler("hsn-inventory:setplayerInventory",function(identifier,inventory)
    playerInventory[identifier] = {}
    local returnData = {}
    for k,v in pairs (inventory) do
        playerInventory[identifier][v.slot] = {name = v.name ,label = ESXItems[v.name].label, weight = ESXItems[v.name].weight, slot = v.slot, count = v.count, description = ESXItems[v.name].description, metadata = v.metadata or {}, stackable = ESXItems[v.name].stackable}
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        local Players = ESX.GetPlayers()
        for k,v in pairs(Players) do
            local Player = ESX.GetPlayerFromId(v)
            local inventory = {}
            inventory = json.encode(GetInventory(playerInventory[Player.identifier]))
                exports.ghmattimysql:execute('UPDATE users SET inventory = @inventory WHERE identifier = @identifier', {
                    ['@inventory'] = inventory,
                    ['@identifier'] = Player.identifier
                })
        end
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        Citizen.Wait(100)
        local Players = ESX.GetPlayers()
        for k,v in pairs(Players) do
            local Player = ESX.GetPlayerFromId(v)
            playerInventory[Player.identifier] = {}
            exports.ghmattimysql:ready(function()
                exports.ghmattimysql:execute('SELECT inventory FROM users WHERE identifier = @identifier', {
                    ['@identifier'] = Player.identifier
                }, function(result)
                    local inventory = {}
                    if result[1].inventory and result[1].inventory ~= '' then
                        inventory = json.decode(result[1].inventory)
                    end
                    TriggerEvent('hsn-inventory:setplayerInventory', Player.identifier, inventory)
                end)
            end)

        end
    end
end)


function getPlayerIdentification(xPlayer)
    return ('Name: %s | Sex: %s | Height: %s<br>DOB: %s (%s)'):format( xPlayer.getName(), xPlayer.get('sex'), xPlayer.get('height'), xPlayer.get('dateofbirth'), xPlayer.getIdentifier() )
end
