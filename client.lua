local Blips, Drops, Usables, cancelled, weaponTimer = {}, {}, {}, false, 0
local playerId, playerPed, invOpen, usingWeapon, playerCoords, currentWeapon, currentDrop
local plyState = LocalPlayer.state

local Function = module('functions', true)

Disarm = function()
	SetWeaponsNoAutoswap(1)
	SetWeaponsNoAutoreload(1)
	SetPedCanSwitchWeapon(playerPed, 0)
	SetPedEnableWeaponBlocking(playerPed, 1)
	if currentWeapon then
		local ammo = GetAmmoInPedWeapon(playerPed, currentWeapon.hash)
		SetPedAmmo(playerPed, currentWeapon.hash, 0)
		if currentWeapon.metadata.components then
			for k, v in pairs(currentWeapon.metadata.components) do
				local hash = ESX.GetWeaponComponent(currrentWeapon.name, v).hash
				if hash then RemoveWeaponComponentFromPed(playerPed, currentWeapon.hash, hash) end
			end
		end
		RemoveWeaponFromPed(playerPed, currentWeapon.hash)
		TriggerServerEvent('ox_inventory:updateWeapon', currentWeapon, ammo)
		TriggerEvent('ox_inventory:currentWeapon', nil)
	end
end
RegisterNetEvent('ox_inventory:disarm', Disarm)

local ClearWeapons = function()
	Disarm()
	for k, v in pairs(Weapons) do
		SetPedAmmo(playerPed, v.hash, 0)
	end
	RemoveAllPedWeapons(playerPed, true)
	if parachute then
		local chute = `GADGET_PARACHUTE`
		GiveWeaponToPed(playerPed, chute, 0, true, false)
		SetPedGadget(playerPed, chute, true)
	end
end
RegisterNetEvent('ox_inventory:clearWeapons', ClearWeapons)

OnPlayerData = function(key, val)
	if key == 'dead' and val then Disarm()
		TriggerEvent('ox_inventory:closeInventory')
	elseif key == 'ped' then playerPed = val end
	SetPedCanSwitchWeapon(playerPed, 0)
	SetPedEnableWeaponBlocking(playerPed, 1)
end

local Hotkey = function(slot)
	if ESX.PlayerLoaded and not invOpen and ESX.PlayerData.inventory[slot] then
		TriggerEvent('ox_inventory:useItem', ESX.PlayerData.inventory[slot])
	end
end

local CanOpenInventory = function()
	return ESX.PlayerLoaded and not isBusy and weaponTimer < 50 and not ESX.PlayerData.dead and not isCuffed and not IsPauseMenuActive() and not IsPedFatallyInjured(playerPed, 1)
end

local CanOpenTarget = function(ped)
	return IsPedFatallyInjured(ped)
	or IsEntityPlayingAnim(ped, 'random@mugging3', 'handsup_standing_base', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_enter', 3)
	or IsEntityPlayingAnim(ped, 'dead', 'dead_a', 3)
	or IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3)
end

local Raycast = function()
	local plyOffset = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 3.0, -0.05)
	local ret, hit, coords, surfacenormal, entity = GetShapeTestResult(StartShapeTestRay(playerCoords.x, playerCoords.y, playerCoords.z, plyOffset.x, plyOffset.y, plyOffset.z, -1, playerPed, 0))
	local type = GetEntityType(entity)
	if hit and type ~= 0 then return hit, coords, entity, type else	return false end
end

local Notify = function(data) SendNUIMessage({ action = 'showNotif', data = data }) end
RegisterNetEvent('ox_inventory:Notify', Notify)

local CloseInventory = function(options)
	if invOpen then
		if options ~= false then SendNUIMessage({ message = 'close', }) end
		TriggerScreenblurFadeOut(0)
		if options.trunk then
			local animDict = 'anim@heists@fleeca_bank@scope_out@return_case'
			local anim = 'trevor_action'
			RequestAnimDict(animDict)
			while not HasAnimDictLoaded(animDict) do
				Citizen.Wait(100)
			end
			ClearPedTasks(playerPed)
			Citizen.Wait(100)
			TaskPlayAnimAdvanced(playerPed, animDict, anim, GetEntityCoords(playerPed, true), 0, 0, GetEntityHeading(playerPed), 2.0, 2.0, 1000, 49, 0.25, 0, 0)
			Citizen.Wait(900)
			ClearPedTasks(playerPed)
			SetVehicleDoorShut(entity, open, false)
		end
		SetNuiFocusAdvanced(false, false)
		invOpen, currentInventory, currentDrop = false, nil, nil
	end
end
RegisterNetEvent('linden_inventory:closeInventory', CloseInventory)

local OpenInventory = function(inv, data)
	if not invOpen then
		if not isBusy or not CanOpenInventory() then
			local time = GetGameTimer()
			invOpen = true
			ox.TriggerServerCallback('ox_inventory:openInventory', function(left, right)
				SendNUIMessage({
					action = 'setupInventory',
					data = {
						playerInventory = {
							id = playerName,
							slots = left.slots,
							weight = left.weight,
							maxWeight = left.maxWeight,
							items = ESX.PlayerData.inventory
						},
						rightInventory = {
							id = right.id,
							type = right.type,
							slots = right.slots,
							weight = right.weight,
							maxWeight = right.maxWeight,
							items = right.items
						},
						job = ESX.PlayerData.job
					}
				})
			end, inv, data)
		else Notify({type = 'error', text = _U('inventory_cannot_open'), duration = 2500}) end
	else TriggerEvent('ox_inventory:closeInventory') end
end

RegisterNetEvent('ox_inventory:setPlayerInventory', function(data)
	playerId, invOpen, usingWeapon, currentWeapon, currentDrop = GetPlayerServerId(PlayerId()), false, false, nil, nil
	ClearWeapons()
	Drops, playerName, ESX.PlayerData.inventory, ESX.Items = data[1], data[2], data[6], data[7]
	ESX.SetPlayerData('inventory', ESX.PlayerData.inventory)
	ESX.SetPlayerData('weight', data[4])
	Notify({text = _U('inventory_setup'), duration = 2500})
	if next(Blips) then
		for k, v in pairs(Blips) do
			RemoveBlip(v)
		end
		Blips = {}
	end
	for k, v in pairs(Config.Shops) do
		if not v.type then v.type = Config.General end
		if v.type and v.type.blip and (not v.job or v.job == ESX.PlayerData.job.name) then
			local data = v.type
			Blips[k] = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
			SetBlipSprite(Blips[k], data.blip.id)
			SetBlipDisplay(Blips[k], 4)
			SetBlipScale(Blips[k], data.blip.scale)
			SetBlipColour(Blips[k], data.blip.colour)
			SetBlipAsShortRange(Blips[k], true)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(data.name)
			EndTextCommandSetBlipName(Blips[k])
		end
	end
	RegisterKeyMapping('inv', 'Open player inventory~', 'keyboard', Config.Keys[1])
	RegisterKeyMapping('inv2', 'Open secondary inventory~', 'keyboard', Config.Keys[2])
	RegisterKeyMapping('hotbar', 'Display inventory hotbar~', 'keyboard', Config.Keys[3])
	RegisterKeyMapping('reload', 'Reload weapon~', 'keyboard', 'r')
	for i=1, 5 do
		RegisterCommand('hotkey'..i, function() Hotkey(i) end)
		RegisterKeyMapping('hotkey'..i, 'Use hotbar item '..i..'~', 'keyboard', i)
	end
	playerCoords = GetEntityCoords(playerPed)
	local nuiFocus = false
	SetInterval(1, 5, function()
		if nuiFocus == false and invOpen then
			nuiFocus = true
			SetNuiFocus(true, true)
			SetNuiFocusKeepInput(true)
			TriggerScreenblurFadeIn(0)
		elseif nuiFocus == true and not invOpen then
			SetNuiFocus(false, false)
			SetNuiFocusKeepInput(false)
			TriggerScreenblurFadeOut(0)
		elseif nuiFocus and not currentInventory then
			DisableAllControlActions(0)
			EnableControlAction(0, 30, true)
			EnableControlAction(0, 31, true)
		end
	end)
end)

AddEventHandler('onResourceStop', function(resourceName)
	if ox.name == resourceName then
		if parachute then ESX.Game.DeleteObject(parachute) end
		if invOpen then
			SetNuiFocus(false, false)
			SetNuiFocusKeepInput(false)
			TriggerScreenblurFadeOut(0)
		end
	end
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:onPlayerLogout', function()
	if parachute then ESX.Game.DeleteObject(parachute) parachute = false end
	TriggerEvent('ox_inventory:closeInventory')
	ESX.PlayerLoaded = false
	ClearInterval(1)
	ClearInterval(2)
	Disarm()
end)

RegisterNetEvent('esx_policejob:handcuff', function()
	isCuffed = not isCuffed
	if isCuffed then Disarm() TriggerEvent('ox_inventory:closeInventory') end
end)

RegisterNetEvent('esx_policejob:unrestrain', function()
	isCuffed = false
	TriggerEvent('ox_inventory:closeInventory')
end)

RegisterCommand('inv', function()
	local property = false
	TriggerEvent('ox_inventory:getProperty', function(data) property = data end)
	if property then return OpenInventory('stash', property) end
	if IsPedInAnyVehicle(playerPed, false) then currentDrop = nil end
	if currentDrop then OpenInventory('drop', currentDrop.id)
	else OpenInventory() end
end)

RegisterCommand('inv2', function()
	if not invOpen then
		if isBusy then return Notify({type = 'error', text = _U('inventory_cannot_open'), duration = 2500})
		elseif currentInventory then TriggerEvent('ox_inventory:closeInventory')
		else
			if not CanOpenInventory() then return Notify({type = 'error', text = _U('inventory_cannot_open'), duration = 2500}) end
			if IsPedInAnyVehicle(playerPed, false) then
				local vehicle = GetVehiclePedIsIn(playerPed, false)
				if NetworkGetEntityIsNetworked(vehicle) then
					local plate = Config.TrimPlate and string.strtrim(GetVehicleNumberPlateText(vehicle)) or GetVehicleNumberPlateText(vehicle)
					local class = GetVehicleClass(vehicle)
					OpenGloveBox(plate, class)
					Wait(100)
					while true do
						Wait(100)
						if not invOpen then break
						elseif not IsPedInAnyVehicle(playerPed, false) then
							TriggerEvent('ox_inventory:closeInventory')
							break
						end
					end
				end
			else
				local result, coords, entity, type = Raycast()
				if not result then return end
				local vehicle, position
				if not Config.qtarget then
					if type == 2 then vehicle, position = entity, GetEntityCoords(entity)
					elseif type == 3 and Function.CheckTable(Config.Dumpsters, GetEntityModel(entity)) then
						if not IsEntityAMissionEntity(object) then 
							SetEntityAsMissionEntity(object) 
							NetworkRegisterEntityAsNetworked(object) 
							local netId = NetworkGetNetworkIdFromEntity(object) 
							SetNetworkIdExistsOnAllMachines(netId, true) 
							SetNetworkIdCanMigrate(netId, true) 
							NetworkSetNetworkIdDynamic(false)
						end
						OpenDumpster({ id = NetworkGetNetworkIdFromEntity(object), label = 'Dumpster', slots = 15})	
					end
				elseif result and type == 2 then
					vehicle, position = entity, GetEntityCoords(entity)
				else return end
				local closeToVehicle, lastVehicle = false, nil
				local class = GetVehicleClass(vehicle)
				if vehicle and Config.Trunks[class] and #(playerCoords - position) < 6 and NetworkGetEntityIsNetworked(vehicle) then
					local locked = GetVehicleDoorLockStatus(vehicle)
					if locked == 0 or locked == 1 then
						local vehHash = GetEntityModel(vehicle)
						local checkVehicle = Config.VehicleStorage[vehHash]
						local open, vehBone
						if checkVehicle == 1 then open, vehBone = 4, GetEntityBoneIndexByName(vehicle, 'bonnet')
						elseif checkVehicle == nil then open, vehBone = 5, GetEntityBoneIndexByName(vehicle, 'boot') elseif checkVehicle == 2 then open, vehBone = 5, GetEntityBoneIndexByName(vehicle, 'boot') else --[[no vehicle nearby]] return end
						if vehBone == -1 then vehBone = GetEntityBoneIndexByName(vehicle, 'platelight') end
						position = GetWorldPositionOfEntityBone(vehicle, vehBone)
						local distance = #(playerCoords - position)
						local closeToVehicle = distance < 2 and (open == 5 and (checkVehicle == nil and true or 2) or open == 4)
						if closeToVehicle then
							local plate = Config.TrimPlate and string.strtrim(GetVehicleNumberPlateText(vehicle)) or GetVehicleNumberPlateText(vehicle)
							TaskTurnPedToFaceCoord(playerPed, position)
							lastVehicle = vehicle
							OpenTrunk(plate, class)
							local timeout = 20
							repeat Wait(50)
								timeout -= 1
							until (currentInventory and currentInventory.type == 'trunk') or timeout == 0
							if timeout == 0 then
								closeToVehicle, lastVehicle = false, nil
								return
							end
							SetVehicleDoorOpen(vehicle, open, false, false)
							Wait(200)
							ox.playAnim(100, 'anim@heists@prison_heiststation@cop_reactions', 'cop_b_idle', 3.0, 3.0, -1, 49, 0, 0, 0, 0)
							while true do
								Wait(50)
								if closeToVehicle and invOpen then
									local position = GetWorldPositionOfEntityBone(vehicle, vehBone)
									local playerCoords = GetEntityCoords(playerPed)
									if #(playerCoords - position) >= 2 or not DoesEntityExist(vehicle) then
										break
									else TaskTurnPedToFaceCoord(playerPed, position) end
								else break end
								if lastVehicle then TriggerEvent('ox_inventory:closeInventory', 'trunk', lastVehicle) end
								return
							end
						end
					else Notify({type = 'error', text = _U('vehicle_locked'), duration = 2500}) end
				end
			end
		end
	end
end)

RegisterNUICallback('notification', function(data)
	if data.type == 2 then data.type = 'error' else data.type = 'inform' end
	Notify({type = data.type, text = _U(data.message), duration = 2500})
end)

RegisterNUICallback('useItem', function(data, cb)
	if data.inv == 'Playerinv' then TriggerEvent('ox_inventory:useItem', data.item) end
end)

RegisterNUICallback('exit',function(data, cb)
	TriggerServerEvent('ox_inventory:saveInventory', ESX.PlayerData.inventory)
	TriggerEvent('ox_inventory:closeInventory', false)
	cb({})
end)


if ESX.PlayerLoaded then TriggerServerEvent('ox_inventory:requestPlayerInventory') end
