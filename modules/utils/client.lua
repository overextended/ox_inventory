local ServerCallbacks = {}
local M = module('utils', true)

local CallbackTimer = function(event, delay)
	local time = GetGameTimer()
	if (ServerCallbacks[event] or 0) > time then
		return false
	end
	ServerCallbacks[event] = time + delay
end

M.AwaitServerCallback = function(event, ...)
	CallbackTimer(event, 200)
	event = 'cb:'..event
	TriggerServerEvent('ox_inventory:ServerCallback', event, ...)
	local p = promise.new()
	event = RegisterNetEvent(event, function(...)
		p:resolve({...})
		RemoveEventHandler(event)
	end)
	return table.unpack(Citizen.Await(p))
end

M.TriggerServerCallback = function(event, cb, timer, ...)
	if timer then CallbackTimer(event, timer) end
	event = 'cb:'..event
	TriggerServerEvent('ox_inventory:ServerCallback', event, ...)
	event = RegisterNetEvent(event, function(...)
		cb(...)
		RemoveEventHandler(event)
	end)
end

M.PlayAnim = function(wait, dict, name, blendIn, blendOut, duration, flag, rate, lockX, lockY, lockZ)
	RequestAnimDict(dict)
	CreateThread(function()
		repeat Wait(0) until HasAnimDictLoaded(dict)
		TaskPlayAnim(ESX.PlayerData.ped, dict, name, blendIn, blendOut, duration, flag, rate, lockX, lockY, lockZ)
		Wait(wait)
		if wait > 0 then ClearPedSecondaryTask(ESX.PlayerData.ped) end
		RemoveAnimDict(dict)
	end)
end

M.PlayAnimAdvanced = function(wait, dict, name, posX, posY, posZ, rotX, rotY, rotZ, animEnter, animExit, duration, flag, time)
	RequestAnimDict(dict)
	CreateThread(function()
		repeat Wait(0) until HasAnimDictLoaded(dict)
		TaskPlayAnimAdvanced(ESX.PlayerData.ped, dict, name, posX, posY, posZ, rotX, rotY, rotZ, animEnter, animExit, duration, flag, time, 0, 0)
		Wait(wait)
		if wait > 0 then ClearPedSecondaryTask(ESX.PlayerData.ped) end
		RemoveAnimDict(dict)
	end)
end

M.Raycast = function()
	local playerCoords = GetEntityCoords(ESX.PlayerData.ped)
	local plyOffset = GetOffsetFromEntityInWorldCoords(ESX.PlayerData.ped, 0.0, 3.0, -0.05)
	local rayHandle = StartShapeTestLosProbe(playerCoords.x, playerCoords.y, playerCoords.z, plyOffset.x, plyOffset.y, plyOffset.z, 30, ESX.PlayerData.ped)
	while true do
		Wait(0)
		local result, _, _, _, entityHit = GetShapeTestResult(rayHandle)
		if result ~= 1 then
			local entityType
			if entityHit then entityType = GetEntityType(entityHit) end
			if entityHit and entityType ~= 0 then
				return entityHit, entityType
			end
			return false
		end
	end
end

M.GetClosestPlayer = function()
	local closestPlayer, playerId, playerCoords = vec3(10, 0, 0), PlayerId(), GetEntityCoords(ESX.PlayerData.ped)
	local coords
	for k, player in pairs(GetActivePlayers()) do
		if player ~= playerId then
			local ped = GetPlayerPed(player)
			coords = GetEntityCoords(ped)
			local distance = #(playerCoords - coords)
			if distance < closestPlayer.x then
				closestPlayer = vec3(distance, player, ped)
			end
		end
	end
	return closestPlayer, coords
end

return M