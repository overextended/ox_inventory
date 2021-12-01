local M = {}

function M.PlayAnim(wait, dict, name, blendIn, blendOut, duration, flag, rate, lockX, lockY, lockZ)
	RequestAnimDict(dict)
	CreateThread(function()
		repeat Wait(0) until HasAnimDictLoaded(dict)
		TaskPlayAnim(ESX.PlayerData.ped, dict, name, blendIn, blendOut, duration, flag, rate, lockX, lockY, lockZ)
		Wait(wait)
		if wait > 0 then ClearPedSecondaryTask(ESX.PlayerData.ped) end
		RemoveAnimDict(dict)
	end)
end

function M.PlayAnimAdvanced(wait, dict, name, posX, posY, posZ, rotX, rotY, rotZ, animEnter, animExit, duration, flag, time)
	RequestAnimDict(dict)
	CreateThread(function()
		repeat Wait(0) until HasAnimDictLoaded(dict)
		TaskPlayAnimAdvanced(ESX.PlayerData.ped, dict, name, posX, posY, posZ, rotX, rotY, rotZ, animEnter, animExit, duration, flag, time, 0, 0)
		Wait(wait)
		if wait > 0 then ClearPedSecondaryTask(ESX.PlayerData.ped) end
		RemoveAnimDict(dict)
	end)
end

function M.Raycast()
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

function M.GetClosestPlayer()
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