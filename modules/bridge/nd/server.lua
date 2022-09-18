local playerDropped = ...
local Inventory
local NDCore

CreateThread(function()
	Inventory = server.inventory
end)

AddEventHandler("ND:characterUnloaded", playerDropped)

SetTimeout(500, function()
    NDCore = exports["ND_Core"]:GetCoreObject()
    server.GetPlayerFromId = NDCore.Functions.GetPlayer
    for _, character in pairs(NDCore.Functions.GetPlayers()) do
        character.identifier = character.id
        character.name = tostring(character.firstName) .. " " .. tostring(character.lastName)
        character.dateofbirth = character.dob
        character.sex = character.gender
        local groups = {}
        for group, info in pairs(character.groups) do
            groups[group] = info.lvl
        end
        character.groups = groups
        server.setPlayerInventory(character, character.inventory)
        Inventory.SetItem(character.source, "money", character.cash)
    end
end)

-- Accounts that need to be synced with physical items
server.accounts = {
    money = 0
}

RegisterNetEvent("ND:characterLoaded", function(character)
    if not character then return end
    character.identifier = character.id
    character.name = tostring(character.firstName) .. " " .. tostring(character.lastName)
    character.dateofbirth = character.dob
    character.sex = character.gender
    local groups = {}
    for group, info in pairs(character.groups) do
        groups[group] = info.lvl
    end
    character.groups = groups
    server.setPlayerInventory(character, character.inventory)
    Inventory.SetItem(character.source, "money", character.cash)
end)

RegisterNetEvent("ND:moneyChange", function(player, account, amount, changeType)
    if account ~= "cash" then return end
    local item = Inventory.GetItem(player, "money", nil, true)
    Inventory.SetItem(player, "money", changeType == "set" and amount or changeType == "remove" and item - amount or changeType == "add" and item + amount)
end)

function server.syncInventory(inv)
    local money = table.clone(server.accounts)
    
    for _, v in pairs(inv.items) do
        if money[v.name] then
            money[v.name] += v.count
        end
    end
    
    if money then
        NDCore.Functions.SetPlayerData(inv.id, "cash", money.money)
    end
end

function server.setPlayerData(player)
    local groups = {}
    for group, info in pairs(player.groups) do
        groups[group] = info.lvl
    end

    return {
        source = player.source,
        identifier = player.id,
        name = player.firstName .. " " .. player.lastName,
        groups = groups,
        sex = player.gender,
        dateofbirth = player.dob,
        job = player.job
    }
end

function server.buyLicense(inv, license)
    local player = server.GetPlayerFromId(source)
    if not player then return end

    if player.PlayerData.metadata.licences.weapon then
        return false, "has_weapon_license"
    elseif Inventory.GetItem(inv, "money", false, true) < license.price then
        return false, "poor_weapon_license"
    end

    Inventory.RemoveItem(inv, "money", license.price)
    player.PlayerData.metadata.licences.weapon = true
    NDCore.Functions.SetPlayerData(player.source, "licences", player.PlayerData.metadata.licences)

    return true, "bought_weapon_license"
end
