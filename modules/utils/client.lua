local Utils = {}

function Utils.PlayAnim(wait, dict, name, blendIn, blendOut, duration, flag, rate, lockX, lockY, lockZ)
	lib:requestAnimDict(dict)
	CreateThread(function()
		TaskPlayAnim(PlayerData.ped, dict, name, blendIn, blendOut, duration, flag, rate, lockX, lockY, lockZ)
		Wait(wait)
		if wait > 0 then ClearPedSecondaryTask(PlayerData.ped) end
	end)
end

function Utils.PlayAnimAdvanced(wait, dict, name, posX, posY, posZ, rotX, rotY, rotZ, animEnter, animExit, duration, flag, time)
	lib:requestAnimDict(dict)
	CreateThread(function()
		TaskPlayAnimAdvanced(PlayerData.ped, dict, name, posX, posY, posZ, rotX, rotY, rotZ, animEnter, animExit, duration, flag, time, 0, 0)
		Wait(wait)
		if wait > 0 then ClearPedSecondaryTask(PlayerData.ped) end
	end)
end

function Utils.Raycast()
	local playerCoords = GetEntityCoords(PlayerData.ped)
	local plyOffset = GetOffsetFromEntityInWorldCoords(PlayerData.ped, 0.0, 2.2, -0.05)
	local rayHandle = StartShapeTestCapsule(playerCoords.x, playerCoords.y, playerCoords.z, plyOffset.x, plyOffset.y, plyOffset.z, 2.2, 30, PlayerData.ped)
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

function Utils.GetClosestPlayer()
	local closestPlayer, playerId, playerCoords = vec3(10, 0, 0), PlayerId(), GetEntityCoords(PlayerData.ped)
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

function Utils.Notify(data) SendNUIMessage({ action = 'showNotif', data = data }) end
function Utils.ItemNotify(data) SendNUIMessage({action = 'itemNotify', data = data}) end
RegisterNetEvent('ox_inventory:notify', Utils.Notify)
exports('notify', Utils.Notify)

function Utils.Disarm(currentWeapon, newSlot)
	SetWeaponsNoAutoswap(1)
	SetWeaponsNoAutoreload(1)
	SetPedCanSwitchWeapon(PlayerData.ped, 0)
	SetPedEnableWeaponBlocking(PlayerData.ped, 1)

	if currentWeapon then
		local ammo = currentWeapon.ammo and GetAmmoInPedWeapon(PlayerData.ped, currentWeapon.hash)
		SetPedAmmo(PlayerData.ped, currentWeapon.hash, 0)

		if newSlot ~= -1 then
			ClearPedSecondaryTask(PlayerData.ped)
			local sleep = (PlayerData.job.name == 'police' and GetWeapontypeGroup(currentWeapon.hash) == 416676503) and 450 or 1400
			local coords = GetEntityCoords(PlayerData.ped, true)
			Utils.PlayAnimAdvanced(sleep, (sleep == 450 and 'reaction@intimidation@cop@unarmed' or 'reaction@intimidation@1h'), 'outro', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(PlayerData.ped), 8.0, 3.0, -1, 50, 0)
			Wait(sleep)
			Utils.ItemNotify({item = currentWeapon.name, text = ox.locale('holstered')})
		end

		RemoveWeaponFromPed(PlayerData.ped, currentWeapon.hash)

		if newSlot ~= false then
			TriggerServerEvent('ox_inventory:updateWeapon', ammo and 'ammo' or 'melee', ammo or currentWeapon.melee, newSlot)
		end

		TriggerEvent('ox_inventory:currentWeapon')
	end
end

function Utils.ClearWeapons(currentWeapon)
	Utils.Disarm(currentWeapon, -1)
	RemoveAllPedWeapons(PlayerData.ped, true)
	if ox.parachute then
		local chute = `GADGET_PARACHUTE`
		GiveWeaponToPed(PlayerData.ped, chute, 0, true, false)
		SetPedGadget(PlayerData.ped, chute, true)
	end
end

function Utils.DeleteObject(obj)
	SetEntityAsMissionEntity(obj, false, true)
	DeleteObject(obj)
end

client.utils = Utils