local callbackTimer = {}
local M = module('utils', true)

M.AwaitServerCallback = function(event, ...)
	local time = GetGameTimer()
	if (callbackTimer?[event] or 0) > time then return false end
	callbackTimer[event] = time + 200
	event = ('cb:%s'):format(event)
	TriggerServerEvent('ox:TriggerServerCallback', event, ...)
	local p = promise.new()
	event = RegisterNetEvent(event, function(...)
		p:resolve({...})
		RemoveEventHandler(event)
	end)
	return table.unpack(Citizen.Await(p))
end

M.TriggerServerCallback = function(event, cb, timer, ...)
	if timer then
		local time = GetGameTimer()
		if (callbackTimer?[timer] or 0) > time then return false end
		callbackTimer[timer] = time + timer
	end
	event = ('cb:%s'):format(event)
	TriggerServerEvent('ox:TriggerServerCallback', event, ...)
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