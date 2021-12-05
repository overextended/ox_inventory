local Utils = {}

function Utils.PlayAnim(wait, dict, name, blendIn, blendOut, duration, flag, rate, lockX, lockY, lockZ)
	lib:requestAnimDict(dict)
	CreateThread(function()
		TaskPlayAnim(ESX.PlayerData.ped, dict, name, blendIn, blendOut, duration, flag, rate, lockX, lockY, lockZ)
		Wait(wait)
		if wait > 0 then ClearPedSecondaryTask(ESX.PlayerData.ped) end
	end)
end

function Utils.PlayAnimAdvanced(wait, dict, name, posX, posY, posZ, rotX, rotY, rotZ, animEnter, animExit, duration, flag, time)
	lib:requestAnimDict(dict)
	CreateThread(function()
		TaskPlayAnimAdvanced(ESX.PlayerData.ped, dict, name, posX, posY, posZ, rotX, rotY, rotZ, animEnter, animExit, duration, flag, time, 0, 0)
		Wait(wait)
		if wait > 0 then ClearPedSecondaryTask(ESX.PlayerData.ped) end
	end)
end

function Utils.Raycast()
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

function Utils.GetClosestPlayer()
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

function Utils.Notify(data) SendNUIMessage({ action = 'showNotif', data = data }) end
function Utils.ItemNotify(data) SendNUIMessage({action = 'itemNotify', data = data}) end
RegisterNetEvent('ox_inventory:notify', Utils.Notify)
exports('notify', Utils.Notify)

function Utils.Disarm(currentWeapon, newSlot)
	SetWeaponsNoAutoswap(1)
	SetWeaponsNoAutoreload(1)
	SetPedCanSwitchWeapon(ESX.PlayerData.ped, 0)
	SetPedEnableWeaponBlocking(ESX.PlayerData.ped, 1)

	if currentWeapon then
		local ammo = currentWeapon.ammo and GetAmmoInPedWeapon(ESX.PlayerData.ped, currentWeapon.hash)
		SetPedAmmo(ESX.PlayerData.ped, currentWeapon.hash, 0)
		ClearPedSecondaryTask(ESX.PlayerData.ped)

		if newSlot ~= -1 then
			local sleep = (ESX.PlayerData.job.name == 'police' and GetWeapontypeGroup(currentWeapon.hash) == 416676503) and 450 or 1400
			local coords = GetEntityCoords(ESX.PlayerData.ped, true)
			Utils.PlayAnimAdvanced(sleep, (sleep == 450 and 'reaction@intimidation@cop@unarmed' or 'reaction@intimidation@1h'), 'outro', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(ESX.PlayerData.ped), 8.0, 3.0, -1, 50, 0)
			Wait(sleep)
			Utils.ItemNotify({item = currentWeapon.name, text = ox.locale('holstered')})
		end

		RemoveWeaponFromPed(ESX.PlayerData.ped, currentWeapon.hash)

		if newSlot ~= false then
			TriggerServerEvent('ox_inventory:updateWeapon', ammo and 'ammo' or 'melee', ammo or currentWeapon.melee, newSlot)
		end

		Utils.SetWeapon()
	end
end

function Utils.SetWeapon(weapon, hash, ammo, text)
	weapon = weapon and {
		hash = hash,
		ammo = ammo,
		name = weapon.name,
		slot = weapon.slot,
		label = weapon.label,
		metadata = weapon.metadata,
		throwable = weapon.throwable,
		melee = (not weapon.throwable and not ammo) and 0,
		timer = 0
	}
	TriggerEvent('ox_inventory:currentWeapon', weapon)
	if text then
		Utils.ItemNotify({item = weapon.name, text = ox.locale(text)})
	end
end

function Utils.ClearWeapons(currentWeapon)
	Utils.Disarm(currentWeapon, -1)
	RemoveAllPedWeapons(ESX.PlayerData.ped, true)
	if ox.parachute then
		local chute = `GADGET_PARACHUTE`
		GiveWeaponToPed(ESX.PlayerData.ped, chute, 0, true, false)
		SetPedGadget(ESX.PlayerData.ped, chute, true)
	end
end

client.utils = Utils