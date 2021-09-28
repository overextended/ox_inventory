local ServerCallbacks = {}
local M = module('utils', true)

local CallbackTimer = function(event, delay)
	local time = GetGameTimer()
	if (ServerCallbacks?[event] or 0) > time then
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

M.PlayAnim = function(wait, ...)
	local args = {...}
	RequestAnimDict(args[1])
	CreateThread(function()
		repeat Wait(0) until HasAnimDictLoaded(args[1])
		TaskPlayAnim(ESX.PlayerData.ped, table.unpack(args))
		Wait(wait)
		ClearPedSecondaryTask(ESX.PlayerData.ped)
		RemoveAnimDict(args[1])
	end)
end

M.PlayAnimAdvanced = function(wait, ...)
	local args = {...}
	RequestAnimDict(args[1])
	CreateThread(function()
		repeat Wait(0) until HasAnimDictLoaded(args[1])
		TaskPlayAnimAdvanced(ESX.PlayerData.ped, table.unpack(args))
		Wait(wait)
		if wait > 0 then ClearPedSecondaryTask(ESX.PlayerData.ped) end
		RemoveAnimDict(args[1])
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

return M