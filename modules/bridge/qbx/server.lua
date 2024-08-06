assert(lib.checkDependency('qbx_vehicles', '1.2.0'), 'qbx_vehicles v1.2.0 or higher is required')
local Inventory = require 'modules.inventory.server'
local QBX = exports.qbx_core

AddEventHandler('qbx_core:server:playerLoggedOut', server.playerDropped)

AddEventHandler('qbx_core:server:onGroupUpdate', function(source, groupName, groupGrade)
    local inventory = Inventory(source)
    if not inventory then return end
    inventory.player.groups[groupName] = not groupGrade and nil or groupGrade
end)

local function setupPlayer(playerData)
    playerData.inventory = playerData.items
    playerData.identifier = playerData.citizenid
    playerData.name = ('%s %s'):format(playerData.charinfo.firstname, playerData.charinfo.lastname)
    server.setPlayerInventory(playerData)

    Inventory.SetItem(playerData.source, 'money', playerData.money.cash)
end
exports('SetupQBXPlayer', setupPlayer)
SetTimeout(500, function()
    server.GetPlayerFromId = QBX.GetPlayer

    for _, playerData in pairs(QBX.GetPlayersData()) do setupPlayer(playerData) end
end)
function server.UseItem(source, itemName, data)
    local cb = exports.qbx_core:CanUseItem(itemName)
    return cb and cb(source, data)
end
end)
---@diagnostic disable-next-line: duplicate-set-field
function server.setPlayerData(player)
    return {
        source = player.source,
        name = ('%s %s'):format(player.charinfo.firstname, player.charinfo.lastname),
        groups = player.groups,
        sex = player.charinfo.gender,
        dateofbirth = player.charinfo.birthdate,
        job = player.job.name,
        gang = player.gang.name,
    }
end

---@diagnostic disable-next-line: duplicate-set-field
function server.syncInventory(inv)
    local accounts = Inventory.GetAccountItemCounts(inv)

    if accounts then
        local player = server.GetPlayerFromId(inv.id)
        player.Functions.SetPlayerData('items', inv.items)

        if accounts.money and accounts.money ~= player.Functions.GetMoney('cash') then
            player.Functions.SetMoney('cash', accounts.money, "Sync money with inventory")
        end
    end
end

---@diagnostic disable-next-line: duplicate-set-field
function server.hasLicense(inv, license)
    local player = server.GetPlayerFromId(inv.id)
    return player and player.PlayerData.metadata.licences[license]
end

---@diagnostic disable-next-line: duplicate-set-field
function server.buyLicense(inv, license)
    local player = server.GetPlayerFromId(inv.id)
    if not player then return end

    if player.PlayerData.metadata.licences[license.name] then
        return false, 'already_have'
    elseif Inventory.GetItem(inv, 'money', false, true) < license.price then
        return false, 'can_not_afford'
    end

    Inventory.RemoveItem(inv, 'money', license.price)
    player.PlayerData.metadata.licences[license.name] = true
    player.Functions.SetMetaData('licences', player.PlayerData.metadata.licences)

    return true, 'have_purchased'
end
---@diagnostic disable-next-line: duplicate-set-field
function server.isPlayerBoss(playerId, group, grade)
    return QBX:IsPlayerBoss(playerId, group, grade)
end

---@param entityId number
---@return number | string
---@diagnostic disable-next-line: duplicate-set-field
function server.getOwnedVehicleId(entityId)
  return Entity(entityId).vehicleid or exports.qbx_vehicles:GetVehicleIdByPlate(GetVehicleNumberPlateText(entityId)) or GetVehicleNumberPlateText(entityId)
end
