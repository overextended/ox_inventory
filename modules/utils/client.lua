if not lib then return end

local Utils = {}

function Utils.PlayAnim(wait, dict, name, blendIn, blendOut, duration, flag, rate, lockX, lockY, lockZ)
    lib.requestAnimDict(dict)
    TaskPlayAnim(cache.ped, dict, name, blendIn, blendOut, duration, flag, rate, lockX, lockY, lockZ)
    RemoveAnimDict(dict)

    if wait > 0 then Wait(wait) end
end

function Utils.PlayAnimAdvanced(wait, dict, name, posX, posY, posZ, rotX, rotY, rotZ, blendIn, blendOut, duration, flag,
                                time)
    lib.requestAnimDict(dict)
    TaskPlayAnimAdvanced(cache.ped, dict, name, posX, posY, posZ, rotX, rotY, rotZ, blendIn, blendOut, duration, flag,
        time, 0, 0)
    RemoveAnimDict(dict)

    if wait > 0 then Wait(wait) end
end

---@param flag number
---@param destination? vector3
---@param size? number
---@return number | false
---@return number?
function Utils.Raycast(flag, destination, size)
    local playerCoords = GetEntityCoords(cache.ped)
    destination = destination or GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 2.2, -0.25)
    local rayHandle = StartShapeTestCapsule(playerCoords.x, playerCoords.y, playerCoords.z + 0.5, destination.x,
        destination.y, destination.z, size or 2.2, flag or 30, cache.ped, 4)
    while true do
        Wait(0)
        local result, _, coords, _, entityHit = GetShapeTestResult(rayHandle)
        if result ~= 1 then
            -- DrawLine(playerCoords.x, playerCoords.y, playerCoords.z + 0.5, destination.x, destination.y, destination.z, 0, 0, 255, 255)
            -- DrawLine(playerCoords.x, playerCoords.y, playerCoords.z + 0.5, coords.x, coords.y, coords.z, 255, 0, 0, 255)
            local entityType
            if entityHit then entityType = GetEntityType(entityHit) end
            if entityHit and entityType ~= 0 then
                return entityHit, entityType
            end
            return false
        end
    end
end

function Utils.GetClosestPlayer()
    local players = GetActivePlayers()
    local playerCoords = GetEntityCoords(cache.ped)
    local targetDistance, targetId, targetPed

    for i = 1, #players do
        local player = players[i]

        if player ~= cache.playerId then
            local ped = GetPlayerPed(player)
            local distance = #(playerCoords - GetEntityCoords(ped))

            if distance < (targetDistance or 2) then
                targetDistance = distance
                targetId = player
                targetPed = ped
            end
        end
    end

    return targetId, targetPed
end

-- Replace ox_inventory notify with ox_lib (backwards compatibility)
function Utils.Notify(data)
    data.description = data.text
    data.text = nil
    lib.notify(data)
end

RegisterNetEvent('ox_inventory:notify', Utils.Notify)
exports('notify', Utils.Notify)

function Utils.ItemNotify(data)
    if not client.itemnotify then
        return
    end

    SendNUIMessage({ action = 'itemNotify', data = data })
end

RegisterNetEvent('ox_inventory:itemNotify', Utils.ItemNotify)

---@deprecated
function Utils.DeleteObject(obj)
    SetEntityAsMissionEntity(obj, false, true)
    DeleteObject(obj)
end

function Utils.DeleteEntity(entity)
    if DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, false, true)
        DeleteEntity(entity)
    end
end

local rewardTypes = 1 << 0 | 1 << 1 | 1 << 2 | 1 << 3 | 1 << 7 | 1 << 10

-- Enables the weapon wheel, but disables the use of inventory weapons.
-- Mostly used for weaponised vehicles, though could be called for "minigames"
function Utils.WeaponWheel(state)
    if client.disableweapons then state = true end
    if state == nil then state = EnableWeaponWheel end

    EnableWeaponWheel = state
    SetWeaponsNoAutoswap(not state)
    SetWeaponsNoAutoreload(not state)

    if client.suppresspickups then
        -- CLEAR_PICKUP_REWARD_TYPE_SUPPRESSION | SUPPRESS_PICKUP_REWARD_TYPE
        return state and N_0x762db2d380b48d04(rewardTypes) or N_0xf92099527db8e2a7(rewardTypes, true)
    end
end

exports('weaponWheel', Utils.WeaponWheel)

function Utils.CreateBlip(settings, coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, settings.id)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, settings.scale)
    SetBlipColour(blip, settings.colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName(settings.name)
    EndTextCommandSetBlipName(blip)

    return blip
end

---Takes OxTargetBoxZone or legacy zone data (PolyZone) and creates a zone.
---@param data OxTargetBoxZone | { length: number, minZ: number, maxZ: number, loc: vector3, heading: number, width: number, distance: number }
---@param options? OxTargetOption[]
---@return number
function Utils.CreateBoxZone(data, options)
    if data.length then
        local height = math.abs(data.maxZ - data.minZ)
        local z = data.loc.z + math.abs(data.minZ - data.maxZ) / 2
        data.coords = vec3(data.loc.x, data.loc.y, z)
        data.size = vec3(data.width, data.length, height)
        data.rotation = data.heading
        data.loc = nil
        data.heading = nil
        data.length = nil
        data.width = nil
        data.maxZ = nil
        data.minZ = nil
    end

    if not data.options and options then
        local distance = data.distance or 2.0

        for k, v in pairs(options) do
            if not v.distance then
                v.distance = distance
            end
        end

        data.options = options
    end

    return exports.ox_target:addBoxZone(data)
end

local hasTextUi

---@param point CPoint
function Utils.nearbyMarker(point)
    DrawMarker(2, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15,
        ---@diagnostic disable-next-line: param-type-mismatch
        point.marker[1], point.marker[2], point.marker[3], 222, false, false, 0, true, false, false, false)

    if point.isClosest and point.currentDistance < 1.2 then
        if not hasTextUi then
            hasTextUi = point
            lib.showTextUI(point.prompt.message, point.prompt.options)
        end

        if IsControlJustReleased(0, 38) then
            CreateThread(function()
                if point.inv == 'policeevidence' then
                    client.openInventory('policeevidence')
                elseif point.inv == 'crafting' then
                    client.openInventory('crafting', { id = point.benchid, index = point.index })
                else
                    client.openInventory(point.inv or 'drop', { id = point.invId, type = point.type })
                end
            end)
        end
    elseif hasTextUi == point then
        hasTextUi = nil
        lib.hideTextUI()
    end
end

return Utils
