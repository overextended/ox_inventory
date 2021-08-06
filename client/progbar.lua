--[[
    Example:
    StartProgress({
        duration = 5000,
        label = "Doing something",
        useWhileDead = false,
        canCancel = true,
        disableControls = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true
        },
        anim = {
            dict = "missheistdockssetup1clipboard@base",
            name = "base",
            flag = 49,
            -- Optional: scenario = "PROP_HUMAN_BUM_BIN" // works only if dict is not defined
        },
        prop = {
            model = "p_amb_clipboard_01",
            bone = 18905,
            coords = { x = 0.10, y = 0.02, z = 0.08 },
            rotation = { x = -80.0, y = 0.0, z = 0.0 },
        },
        propTwo = {
            model = "prop_pencil_01",
            bone = 58866,
            coords = { x = 0.12, y = 0.0, z = 0.001 },
            rotation = { x = -150.0, y = 0.0, z = 0.0 }            
        }
    }, function(cancelled)
        if not cancelled then
            -- stuff
        else
            -- cancelled stuff
        end
    end)
--]]

local isDoingAction = false
local canCancel = false

local anim = false
local scenario = false
local hasProp = false
local hasPropTwo = false
local progressCallback

function StartProgress(options, completed)
    local playerPed = PlayerPedId()

    progressCallback = completed

    if not IsEntityDead(playerPed) or options.useWhileDead then
        if not isDoingAction then
            isDoingAction = true
            wasCancelled = false
            anim = false
            hasProp = false
            hasPropTwo = false

            canCancel = options.canCancel

            SendNUIMessage({
                action = "startProgress",
                data = {
                    text = options.label,
                    duration = options.duration
                }
            })

            if options.anim then
                if options.anim.dict then
                    RequestAnimDict(options.anim.dict)

                    while not HasAnimDictLoaded(options.anim.dict) do
                        Citizen.Wait(5)
                    end

                    if options.anim.flag == nil then options.anim.flag = 1 end
                    TaskPlayAnim(playerPed, options.anim.dict, options.anim.name, 3.0, 1.0, -1, options.anim.flag, 0, false, false, false)
                    anim = true
                end

                if options.anim.scenario and not options.anim.dict then
                    print(options.anim.scenario)
                    TaskStartScenarioInPlace(playerPed, options.anim.scenario, 0, true)
                    scenario = true
                end

                RemoveAnimDict(options.anim.dict)
            end

            if options.prop ~= nil and not hasProp then
                local model = options.prop.model

                RequestModel(model)

                local modelHash = GetHashKey(model)
                while not HasModelLoaded(modelHash) do
                    Citizen.Wait(5)
                end

                local pCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)
                local modelSpawn = CreateObject(modelHash, pCoords.x, pCoords.y, pCoords.z, true, true, true)

                local netid = ObjToNet(modelSpawn)
                SetNetworkIdExistsOnAllMachines(netid, true)
                NetworkSetNetworkIdDynamic(netid, true)
                SetNetworkIdCanMigrate(netid, false)

                
                if options.prop.bone == nil then
                    options.prop.bone = 60309
                end
                
                if options.prop.coords == nil then
                    options.prop.coords = { x = 0.0, y = 0.0, z = 0.0 }
                end
                
                if options.prop.rotation == nil then
                    options.prop.rotation = { x = 0.0, y = 0.0, z = 0.0 }
                end
                
                AttachEntityToEntity(modelSpawn, playerPed, GetPedBoneIndex(playerPed, options.prop.bone), options.prop.coords.x, options.prop.coords.y, options.prop.coords.z, options.prop.rotation.x, options.prop.rotation.y, options.prop.rotation.z, 1, 1, 0, 1, 0, 1)
                prop_net = netid
                
                SetModelAsNoLongerNeeded(model)

                hasProp = true
            end

            if options.propTwo ~= nil then
                local model = options.propTwo.model

                RequestModel(model)

                local modelHash = GetHashKey(model)
                while not HasModelLoaded(modelHash) do
                    Citizen.Wait(0)
                end

                local pCoords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0)
                local modelSpawn = CreateObject(modelHash, pCoords.x, pCoords.y, pCoords.z, true, true, true)

                local netid = ObjToNet(modelSpawn)
                SetNetworkIdExistsOnAllMachines(netid, true)
                NetworkSetNetworkIdDynamic(netid, true)
                SetNetworkIdCanMigrate(netid, false)
                if options.propTwo.bone == nil then
                    options.propTwo.bone = 60309
                end

                if options.propTwo.coords == nil then
                    options.propTwo.coords = { x = 0.0, y = 0.0, z = 0.0 }
                end

                if options.propTwo.rotation == nil then
                    options.propTwo.rotation = { x = 0.0, y = 0.0, z = 0.0 }
                end

                AttachEntityToEntity(modelSpawn, playerPed, GetPedBoneIndex(playerPed, options.propTwo.bone), options.propTwo.coords.x, options.propTwo.coords.y, options.propTwo.coords.z, options.propTwo.rotation.x, options.propTwo.rotation.y, options.propTwo.rotation.z, 1, 1, 0, 1, 0, 1)
                propTwo_net = netid

                SetModelAsNoLongerNeeded(model)

                hasPropTwo = true
            end

            if options.disableControls then
                DisableMovement(options.disableControls)
            end
        end
    end
end

function DisableMovement(disableControls)
    Citizen.CreateThread(function()
        while isDoingAction do
            Citizen.Wait(0)
            if disableControls.disableMouse then
                DisableControlAction(0, 1, true) -- LookLeftRight
                DisableControlAction(0, 2, true) -- LookUpDown
                DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
            end
        
            if disableControls.disableMovement then
                DisableControlAction(0, 30, true) -- disable left/right
                DisableControlAction(0, 31, true) -- disable forward/back
                DisableControlAction(0, 36, true) -- INPUT_DUCK
                DisableControlAction(0, 21, true) -- disable sprint
            end
        
            if disableControls.disableCarMovement then
                DisableControlAction(0, 63, true) -- veh turn left
                DisableControlAction(0, 64, true) -- veh turn right
                DisableControlAction(0, 71, true) -- veh forward
                DisableControlAction(0, 72, true) -- veh backwards
                DisableControlAction(0, 75, true) -- disable exit vehicle
            end
        
            if disableControls.disableCombat then
                DisablePlayerFiring(PlayerId(), true) -- Disable weapon firing
                DisableControlAction(0, 24, true) -- disable attack
                DisableControlAction(0, 25, true) -- disable aim
                DisableControlAction(1, 37, true) -- disable weapon select
                DisableControlAction(0, 47, true) -- disable weapon
                DisableControlAction(0, 58, true) -- disable weapon
                DisableControlAction(0, 140, true) -- disable melee
                DisableControlAction(0, 141, true) -- disable melee
                DisableControlAction(0, 142, true) -- disable melee
                DisableControlAction(0, 143, true) -- disable melee
                DisableControlAction(0, 263, true) -- disable melee
                DisableControlAction(0, 264, true) -- disable melee
                DisableControlAction(0, 257, true) -- disable melee
            end
        end
    end)
end

function Completed()
    isDoingAction = false
    progressCallback(wasCancelled)
    PlayerReset()
    DisableMovement(false)
end

function Cancelled()
    isDoingAction = false
    wasCancelled = true
    progressCallback(wasCancelled)
    PlayerReset()
    DisableMovement(false)
    SendNUIMessage({
        action = 'cancelProgress',
    })
end

function PlayerReset()
    local playerPed = PlayerPedId()

    if anim or scenario then
        ClearPedTasks(playerPed)
        anim = false
        scenario = false
    end

    if prop_net and NetToObj(prop_net) ~= 0 and NetToObj(prop_net) ~= nil then
        DetachEntity(NetToObj(prop_net), 1, 1)
        DeleteEntity(NetToObj(prop_net))
        prop_net = nil
    end
    if propTwo_net and NetToObj(propTwo_net) ~= 0 and NetToObj(propTwo_net) ~= nil then
        DetachEntity(NetToObj(propTwo_net), 1, 1)
        DeleteEntity(NetToObj(propTwo_net))
        propTwo_net = nil
    end

end

RegisterNetEvent('ox_inventory:CancelProgress')
AddEventHandler('ox_inventory:CancelProgress', function()
    ExecuteCommand('progcancel')
end)

RegisterNetEvent('ox_inventory:StartProgress')
AddEventHandler('ox_inventory:StartProgress', function(options, completed)
    StartProgress(options, completed)
end)

RegisterNUICallback('ox_inventory:ProgressComplete', function(_, cb)
    Completed()
    cb({})
end)

RegisterCommand('progcancel', function()
    if isDoingAction and canCancel then
        Cancelled()
    end
end)

RegisterKeyMapping('progcancel', 'Cancel a progress task', 'keyboard', 'DELETE')