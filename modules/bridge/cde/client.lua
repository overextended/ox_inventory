if not lib.checkDependency('cde-core', '0.1.0', true) then return end

RegisterNetEvent('cde-core:client:playerUnloaded', client.onLogout)

local function setPoliceGroups(list)
    if type(list) ~= 'table' or #list == 0 then return end
    for name in pairs(shared.police) do shared.police[name] = nil end
    for i = 1, #list do shared.police[list[i]] = 0 end
end

setPoliceGroups(GlobalState['cde:lawGroups'])
AddStateBagChangeHandler('cde:lawGroups', 'global', function(_, _, value) setPoliceGroups(value) end)

SetTimeout(500, function()
    local player = exports['cde-core']:GetPlayerData()
    if not player then return end
    client.setPlayerData('groups', player.groups)
end)

RegisterNetEvent('cde-core:client:playerLoaded', function(player)
    client.setPlayerData('groups', player.groups)
end)

RegisterNetEvent('cde-core:client:groupsChanged', function(groups)
    client.setPlayerData('groups', groups)
end)
