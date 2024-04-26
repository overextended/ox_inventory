if not lib.checkDependency('ND_Core', '2.0.0', true) then return end

NDCore = {}

lib.load('@ND_Core.init')

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
    client.setPlayerData("groups", reorderGroups(player.groups))
end)

RegisterNetEvent("ND:characterLoaded", function(character)
    client.setPlayerData("groups", reorderGroups(character.groups))
end)

RegisterNetEvent("ND:updateCharacter", function(character)
    client.setPlayerData("groups", reorderGroups(character.groups))
end)

---@diagnostic disable-next-line: duplicate-set-field
function client.setPlayerStatus(values)
    if GetResourceState("ND_Status") ~= "started" then return end

    local status = exports["ND_Status"]

    for name, value in pairs(values) do

        if value > 100 or value < -100 then
            value = value * 0.0001
        end

        status:changeStatus(name, value)
    end
end
