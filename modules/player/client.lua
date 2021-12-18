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

function ox.SetPlayerData(key, value)
    PlayerData[key] = value
    OnPlayerData(key, value)
end

local Utils = client.utils

do
    if ox.esx then
        local ESX = exports['es_extended']:getSharedObject()

        PlayerData.dead = PlayerData.dead
        PlayerData.inventory = PlayerData.inventory
        PlayerData.weight = PlayerData.weight
        PlayerData.ped = PlayerData.ped
        PlayerData.job = PlayerData.job
        PlayerData.loaded = ESX.PlayerLoaded

        ESX = {
            SetPlayerData = ESX.SetPlayerData,
        }

        function ox.SetPlayerData(key, value)
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
                Utils.Disarm(currentWeapon, -1)
                if invOpen then TriggerEvent('ox_inventory:closeInventory') end
            end
        end)

        RegisterNetEvent('esx_policejob:unrestrain', function()
            PlayerData.cuffed = false
            LocalPlayer.state:set('busy', PlayerData.cuffed, false)
        end)
    end
end
