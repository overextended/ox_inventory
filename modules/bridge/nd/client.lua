local NDCore = lib.load('@ND_Core.init')

if lib.checkDependency('ND_Core', '2.0.0', true) then return end

RegisterNetEvent("ND:characterUnloaded", client.onLogout)

local function reorderGroups(groups)
    groups = groups or {}
    for group, info in pairs(groups) do
        groups[group] = info.rank
    end
    return groups
end

SetTimeout(500, function()
	local player = NDCore.getPlayer()
    if not player then return end
    local groups = reorderGroups(player.groups)
    OnPlayerData("groups", groups)
end)

RegisterNetEvent("ND:setCharacter", function(character)
    local groups = reorderGroups(character.groups)
    OnPlayerData("groups", groups)
end)

RegisterNetEvent("ND:updateCharacter", function(character)
    PlayerData.dead = character.metadata.dead
    OnPlayerData("dead", PlayerData.dead)
end)

---@diagnostic disable-next-line: duplicate-set-field
function client.setPlayerStatus(values)
    if GetResourceState("ND_Status") ~= "started" then return end
	for name, value in pairs(values) do
        if value == 0 then
            exports["ND_Status"]:setStatus(name, value)
        else
            exports["ND_Status"]:changeStatus(name, value)
        end
    end
end
