PlayerData = {
    job = {
        name = 'unemployed',
        label = 'Unemployed',
        grade = 0,
        grade_label = ''
    },
    inventory = {},
    weight = 0,
    dead = false,
    ped = PlayerPedId(),
    cuffed = false,
    loaded = false
}

function client.setPlayerData(key, value)
    PlayerData[key] = value
    OnPlayerData(key, value)
end

function client.isPolice()
    return shared.police[PlayerData.job.name] ~= nil
end

local Utils = client.utils

if shared.framework == 'esx' then
    local ESX = exports.es_extended:getSharedObject()

    PlayerData.dead = PlayerData.dead
    PlayerData.job = PlayerData.job

    ESX = {
        SetPlayerData = ESX.SetPlayerData,
		PlayerLoaded = ESX.PlayerLoaded
    }

    function client.setPlayerData(key, value)
        PlayerData[key] = value
        ESX.SetPlayerData(key, value)
    end

    AddEventHandler('esx:setPlayerData', function(key, value)
        if GetInvokingResource() == 'es_extended' then
            PlayerData[key] = value
            OnPlayerData(key, value)
        end
    end)

    RegisterNetEvent('esx_policejob:handcuff', function()
        PlayerData.cuffed = not PlayerData.cuffed
        LocalPlayer.state:set('busy', PlayerData.cuffed, false)
        if PlayerData.cuffed then
            currentWeapon = Utils.Disarm(currentWeapon)
            if invOpen then TriggerEvent('ox_inventory:closeInventory') end
        end
    end)

    RegisterNetEvent('esx_policejob:unrestrain', function()
        PlayerData.cuffed = false
        LocalPlayer.state:set('busy', PlayerData.cuffed, false)
    end)

	if ESX.PlayerLoaded then
		TriggerServerEvent('ox_inventory:requestPlayerInventory')
	end

end
