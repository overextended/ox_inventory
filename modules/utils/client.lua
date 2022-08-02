local Utils = {}

function Utils.PlayAnim(wait, dict, name, blendIn, blendOut, duration, flag, rate, lockX, lockY, lockZ)
	lib.requestAnimDict(dict)
	CreateThread(function()
		TaskPlayAnim(cache.ped, dict, name, blendIn, blendOut, duration, flag, rate, lockX, lockY, lockZ)
		Wait(wait)
		if wait > 0 then ClearPedSecondaryTask(cache.ped) end
	end)
end

function Utils.PlayAnimAdvanced(wait, dict, name, posX, posY, posZ, rotX, rotY, rotZ, animEnter, animExit, duration, flag, time)
	lib.requestAnimDict(dict)
	CreateThread(function()
		TaskPlayAnimAdvanced(cache.ped, dict, name, posX, posY, posZ, rotX, rotY, rotZ, animEnter, animExit, duration, flag, time, 0, 0)
		Wait(wait)
		if wait > 0 then ClearPedSecondaryTask(cache.ped) end
	end)
end

function Utils.Raycast(flag)
	local playerCoords = GetEntityCoords(cache.ped)
	local plyOffset = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 2.2, -0.25)
	local rayHandle = StartShapeTestCapsule(playerCoords.x, playerCoords.y, playerCoords.z + 0.5, plyOffset.x, plyOffset.y, plyOffset.z, 2.2, flag or 30, cache.ped)
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

function Utils.ItemNotify(data) SendNUIMessage({action = 'itemNotify', data = data}) end

function Utils.Disarm(currentWeapon, skipAnim)
	if source == '' then
		TriggerServerEvent('ox_inventory:updateWeapon')
	end

	if currentWeapon then
		SetPedAmmo(cache.ped, currentWeapon.hash, 0)

		if not skipAnim then
			ClearPedSecondaryTask(cache.ped)

			local sleep = (client.hasGroup(shared.police) and (GetWeapontypeGroup(currentWeapon.hash) == 416676503 or GetWeapontypeGroup(currentWeapon.hash) == 690389602)) and 450 or 1400
			local coords = GetEntityCoords(cache.ped, true)

			if currentWeapon.hash == `WEAPON_SWITCHBLADE` then
				Utils.PlayAnimAdvanced(sleep, 'anim@melee@switchblade@holster', 'holster', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(cache.ped), 8.0, 3.0, -1, 48, 0)
				Wait(600)
			else
				Utils.PlayAnimAdvanced(sleep, (sleep == 450 and 'reaction@intimidation@cop@unarmed' or 'reaction@intimidation@1h'), 'outro', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(cache.ped), 8.0, 3.0, -1, 50, 0)
				Wait(sleep)
			end
		end

		Utils.ItemNotify({currentWeapon.metadata.label or currentWeapon.label, currentWeapon.metadata.image or currentWeapon.name, shared.locale('holstered')})
		TriggerEvent('ox_inventory:currentWeapon')
	end

	Utils.WeaponWheel()
	RemoveAllPedWeapons(cache.ped, true)
end

function Utils.ClearWeapons(currentWeapon)
	Utils.Disarm(currentWeapon)

	if client.parachute then
		local chute = `GADGET_PARACHUTE`
		GiveWeaponToPed(cache.ped, chute, 0, true, false)
		SetPedGadget(cache.ped, chute, true)
	end
end

function Utils.DeleteObject(obj)
	SetEntityAsMissionEntity(obj, false, true)
	DeleteObject(obj)
end

-- Enables the weapon wheel, but disables the use of inventory items
-- Mostly used for weaponised vehicles, though could be called for "minigames"
function Utils.WeaponWheel(state)
	if state == nil then state = client.weaponWheel end

	client.weaponWheel = state
	SetWeaponsNoAutoswap(not state)
	SetWeaponsNoAutoreload(not state)
	SetPedCanSwitchWeapon(cache.ped, state)
	SetPedEnableWeaponBlocking(cache.ped, not state)
end
exports('weaponWheel', Utils.WeaponWheel)

client.utils = Utils
