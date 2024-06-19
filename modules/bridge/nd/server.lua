if not lib.checkDependency('ND_Core', '2.0.0', true) then return end

local Inventory = require 'modules.inventory.server'
NDCore = {}

lib.load('@ND_Core.init')

AddEventHandler("ND:characterUnloaded", server.playerDropped)

local function reorderGroups(groups)
    groups = groups or {}
    for group, info in pairs(groups) do
        groups[group] = info.rank
    end
    return groups
end

local function setCharacterInventory(character)
    character.identifier = character.id
    character.name = ("%s %s"):format(character.firstname, character.lastname)
    character.dateofbirth = character.dob
    character.sex = character.gender
    character.groups = reorderGroups(character.groups)
    server.setPlayerInventory(character, character.inventory)
    Inventory.SetItem(character.source, "money", character.cash)
end

SetTimeout(500, function()
    server.GetPlayerFromId = NDCore.getPlayer
    for _, character in pairs(NDCore.getPlayers()) do
        setCharacterInventory(character)
    end
end)

-- Accounts that need to be synced with physical items
server.accounts = {
    money = 0
}

AddEventHandler("ND:characterLoaded", function(character)
    if not character then return end
    setCharacterInventory(character)
end)

AddEventHandler("ND:moneyChange", function(src, account, amount, changeType, reason)
    if account ~= "cash" then return end
    local item = Inventory.GetItemCount(src, 'money')
    Inventory.SetItem(src, "money", changeType == "set" and amount or changeType == "remove" and item - amount or changeType == "add" and item + amount)
end)

AddEventHandler("ND:updateCharacter", function(character)
    local inventory = Inventory(character.source)
	if not inventory then return end
	inventory.player.groups = reorderGroups(character.groups)
end)

---@diagnostic disable-next-line: duplicate-set-field
function server.syncInventory(inv)
    local accounts = Inventory.GetAccountItemCounts(inv)

    if accounts then
        local player = NDCore.getPlayer(inv.id)
        player.setData("cash", accounts.money)
    end
end

---@diagnostic disable-next-line: duplicate-set-field
function server.setPlayerData(player)
    return {
        source = player.source,
        identifier = player.id,
        name = ("%s %s"):format(player.firstname, player.lastname),
        groups = player.groups,
        sex = player.gender,
        dateofbirth = player.dob
    }
end

---@diagnostic disable-next-line: duplicate-set-field
function server.hasLicense(inv, license)
    local player = NDCore.getPlayer(inv.id)
    if not player then return end

    local licenses = player.getMetadata("licenses") or {}
    for i=1, #licenses do
        local characterLicense = licenses[i]
        if characterLicense.type == license and characterLicense.status == "valid" then
            return characterLicense.type
        end
    end
end

---@diagnostic disable-next-line: duplicate-set-field
function server.buyLicense(inv, license)
	if server.hasLicense(inv, license.name) then
		return false, "already_have"
	elseif Inventory.GetItemCount(inv, 'money') < license.price then
		return false, "can_not_afford"
	end

	Inventory.RemoveItem(inv, "money", license.price)
    local player = NDCore.getPlayer(inv.id)
    player.createLicense("weapon")
	return true, "have_purchased"
end

---@diagnostic disable-next-line: duplicate-set-field
function server.isPlayerBoss(playerId, group)
    local player = NDCore.getPlayer(playerId)
    if not player then return end

    local groupInfo = player.getGroup(group)
	return groupInfo and groupInfo.isBoss
end

---@param entityId number
---@return number | string
---@diagnostic disable-next-line: duplicate-set-field
function server.getOwnedVehicleId(entityId)
    return NDCore.getVehicle(entityId)?.id
end
