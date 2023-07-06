local playerDropped = ...
local Inventory = require 'modules.inventory.server'
local NDCore

AddEventHandler("ND:characterUnloaded", playerDropped)

RegisterNetEvent("ND:jobChanged", function(source, job, lastJob)
    local inventory = Inventory(source)
	if not inventory then return end
	inventory.player.groups[lastJob.name] = nil
	inventory.player.groups[job.name] = job.rank
end)

local function reorderGroups(groups)
    groups = groups or {}
    for group, info in pairs(groups) do
        groups[group] = info.rank
    end
    return groups
end

SetTimeout(500, function()
    NDCore = exports["ND_Core"]:GetCoreObject()
    server.GetPlayerFromId = NDCore.Functions.GetPlayer
    for _, character in pairs(NDCore.Functions.GetPlayers()) do
        character.identifier = character.id
        character.name = ("%s %s"):format(character.firstName, character.lastName)
        character.dateofbirth = character.dob
        character.sex = character.gender
        character.groups = reorderGroups(character.data.groups)
        server.setPlayerInventory(character, character.inventory)
        Inventory.SetItem(character.source, "money", character.cash)
    end
end)

RegisterNetEvent("ND:characterLoaded", function(character)
    if not character then return end
    character.identifier = character.id
    character.name = ("%s %s"):format(character.firstName, character.lastName)
    character.dateofbirth = character.dob
    character.sex = character.gender

    local groups = reorderGroups(character.data.groups)
    server.setPlayerInventory(character, character.inventory)
    Inventory.SetItem(character.source, "money", character.cash)
end)

RegisterNetEvent("ND:moneyChange", function(player, account, amount, changeType)
    if account ~= "cash" then return end
    local item = Inventory.GetItem(player, "money", nil, true)
    Inventory.SetItem(player, "money", changeType == "set" and amount or changeType == "remove" and item - amount or changeType == "add" and item + amount)
end)

---@diagnostic disable-next-line: duplicate-set-field
function server.syncInventory(inv)
    local accounts = Inventory.GetAccountItemCounts(inv)

    if accounts then
        local character = NDCore.Functions.GetPlayer(inv.id)
        NDCore.Functions.SetPlayerData(character.id, "cash", accounts.money)
    end
end

---@diagnostic disable-next-line: duplicate-set-field
function server.setPlayerData(player)
    return {
        source = player.source,
        identifier = player.id,
        name = ("%s %s"):format(player.firstName, player.lastName),
        groups = player.data.groups,
        sex = player.gender,
        dateofbirth = player.dob,
        job = player.job
    }
end

---@diagnostic disable-next-line: duplicate-set-field
function server.hasLicense(inv, license)
    local character = NDCore.Functions.GetPlayer(inv.id)
    if not character or not character.data.licences then return end

    for _, characterLicense in pairs(character.data.licences) do
        if characterLicense.type == license and characterLicense.status == "valid" then
            return characterLicense.type
        end
    end
end

---@diagnostic disable-next-line: duplicate-set-field
function server.buyLicense(inv, license)
	if server.hasLicense(inv, license.name) then
		return false, "already_have"
	elseif Inventory.GetItem(inv, "money", false, true) < license.price then
		return false, "can_not_afford"
	end

	Inventory.RemoveItem(inv, "money", license.price)
	NDCore.Functions.CreatePlayerLicense(inv.owner, "weapon")
	return true, "have_purchased"
end
