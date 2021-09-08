local Stashes, Vehicles = data('stashes'), data('vehicles')
local Items, Weapons = table.unpack(module('items'))
local Utils, Progress, Shops = module('utils'), module('progress'), module('shops')

local Blips, Drops, nearbyMarkers, cancelled, invOpen = {}, {}, {}, false, false
local playerId, playerCoords, invOpen, currentWeapon, currentMarker
local plyState, isBusy = LocalPlayer.state, false

local SetBusy = function(state)
	isBusy = state
	plyState:set('isBusy', state, false)
end
exports('SetBusy', SetBusy)

local SetWeapon = function(weapon, hash, ammo)
	currentWeapon = weapon and {name=weapon.name, slot=weapon.slot, label=weapon.label, metadata=weapon.metadata, hash=hash, ammo=ammo, throwable=weapon.throwable} or nil
	TriggerEvent('ox_inventory:currentWeapon', currentWeapon)
	if currentWeapon then currentWeapon.timer = 0 end
	SetDisableAmbientMeleeMove(playerId, true)
end

local Notify = function(data) SendNUIMessage({ action = 'showNotif', data = data }) end
RegisterNetEvent('ox_inventory:Notify', Notify)
exports('Notify', Notify)

local CanOpenInventory = function()
	return ESX.PlayerLoaded and invOpen ~= nil and isBusy == false and not ESX.PlayerData.dead and not isCuffed and not IsPauseMenuActive() and not IsPedFatallyInjured(ESX.PlayerData.ped, 1) and (not currentWeapon or currentWeapon.timer == 0)
end

local CanOpenTarget = function(ped)
	return IsPedFatallyInjured(ped)
	or IsEntityPlayingAnim(ped, 'random@mugging3', 'handsup_standing_base', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_enter', 3)
	or IsEntityPlayingAnim(ped, 'dead', 'dead_a', 3)
	or IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3)
end

local Disarm = function(newSlot)
	SetWeaponsNoAutoswap(1)
	SetWeaponsNoAutoreload(1)
	SetPedCanSwitchWeapon(ESX.PlayerData.ped, 0)
	SetPedEnableWeaponBlocking(ESX.PlayerData.ped, 1)
	if currentWeapon then
		local ammo = GetAmmoInPedWeapon(ESX.PlayerData.ped, currentWeapon.hash)
		SetPedAmmo(ESX.PlayerData.ped, currentWeapon.hash, 0)
		if currentWeapon.metadata.components then
			for k, v in pairs(currentWeapon.metadata.components) do
				local hash = ESX.GetWeaponComponent(currrentWeapon.name, v).hash
				if hash then RemoveWeaponComponentFromPed(ESX.PlayerData.ped, currentWeapon.hash, hash) end
			end
		end
		ClearPedSecondaryTask(ESX.PlayerData.ped)
		local sleep = (ESX.PlayerData.job.name == 'police' and GetWeapontypeGroup(currentWeapon.hash) == 416676503) and 450 or 1400
		Utils.PlayAnimAdvanced(sleep, sleep == 450 and 'reaction@intimidation@cop@unarmed' or 'reaction@intimidation@1h', 'outro', GetEntityCoords(ESX.PlayerData.ped, true), 0, 0, GetEntityHeading(ESX.PlayerData.ped), 8.0, 3.0, -1, 50, 0, 0, 0)
		Wait(sleep)
		RemoveWeaponFromPed(ESX.PlayerData.ped, currentWeapon.hash)
		TriggerServerEvent('ox_inventory:updateWeapon', 'disarm', ammo, newSlot)
		SetWeapon()
	end
end
RegisterNetEvent('ox_inventory:disarm', Disarm)

local ClearWeapons = function()
	Disarm()
	for k, v in pairs(Weapons) do
		SetPedAmmo(ESX.PlayerData.ped, k, 0)
	end
	RemoveAllPedWeapons(ESX.PlayerData.ped, true)
	if ox.parachute then
		local chute = `GADGET_ox.parachute`
		GiveWeaponToPed(ESX.PlayerData.ped, chute, 0, true, false)
		SetPedGadget(ESX.PlayerData.ped, chute, true)
	end
end
RegisterNetEvent('ox_inventory:clearWeapons', ClearWeapons)

local OpenInventory = function(inv, data)
	if CanOpenInventory() then
		local left, right
		if inv == 'shop' and invOpen == false then
			left, right = ox.TriggerServerCallback('ox_inventory:openShop', inv, data)
		elseif invOpen == false or inv == 'drop' or inv == 'container' then
			left, right = ox.TriggerServerCallback('ox_inventory:openInventory', inv, data)
		end
		if left then
			if not IsPedInAnyVehicle(ESX.PlayerData.ped, false) then Utils.PlayAnim(1000, 'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0) end
			invOpen = true
			SetInterval(1, 100)
			SetNuiFocus(true, true)
			SetNuiFocusKeepInput(true)
			TriggerScreenblurFadeIn(0)
			currentInventory = right or {id='', type='newdrop', slots=left.slots, weight=0, maxWeight=30000, items={}}
			left.items = ESX.PlayerData.inventory
			SendNUIMessage({
				action = 'setupInventory',
				data = {
					leftInventory = left,
					rightInventory = currentInventory,
					job = {
						grade = ESX.PlayerData.job.grade,
						grade_label = ESX.PlayerData.job.grade_label,
						name = ESX.PlayerData.job.name
					}
				}
			})
		else return TriggerEvent('ox_inventory:closeInventory') end
	else Notify({type = 'error', text = ox.locale('inventory_cannot_open'), duration = 2500}) end
end

local UseSlot = function(slot)
	if ESX.PlayerLoaded and isBusy == false and not Progress.Active then
		local item = ESX.PlayerData.inventory[slot]
		local data = item and Items[item.name]
		if item and data.usable then
			if item.metadata.container then
				OpenInventory('container', item.slot)
			elseif data.client and data.client.event then
				TriggerEvent(data.client.event, data, {name = item.name, slot = item.slot, metadata = item.metadata})
			elseif data.effect then
				data:effect({name = item.name, slot = item.slot, metadata = item.metadata})
			else
				data.slot = slot
				if item.name:find('WEAPON_') then
					TriggerEvent('ox_inventory:item', data, function(data)
						if data then
							local data = Items[item.name]
							if data.throwable then item.throwable = true end
							ClearPedSecondaryTask(ESX.PlayerData.ped)
							if currentWeapon then
								Disarm(data.slot)
							end
							local sleep = (ESX.PlayerData.job.name == 'police' and GetWeapontypeGroup(data.hash) == 416676503) and 400 or 1200
							Utils.PlayAnimAdvanced(sleep*2, sleep == 400 and 'reaction@intimidation@cop@unarmed' or 'reaction@intimidation@1h', 'intro', GetEntityCoords(ESX.PlayerData.ped, true), 0, 0, GetEntityHeading(ESX.PlayerData.ped), 8.0, 3.0, -1, 50, 1, 0, 0)
							Wait(sleep)
							GiveWeaponToPed(ESX.PlayerData.ped, data.hash, 0, true, false)
							SetCurrentPedWeapon(ESX.PlayerData.ped, data.hash)
							SetPedCurrentWeaponVisible(ESX.PlayerData.ped, true, false, false, false)
							SetAmmoInClip(ESX.PlayerData.ped, data.hash, item.metadata.ammo or 1)
							SetWeapon(item, data.hash, data.ammoname)
							Wait(sleep)
							ClearPedSecondaryTask(ESX.PlayerData.ped)
						end
					end)
				elseif currentWeapon then
					if item.name:find('ammo-') then
						local maxAmmo = GetWeaponClipSize(currentWeapon.hash)
						local currentAmmo = GetAmmoInPedWeapon(ESX.PlayerData.ped, currentWeapon.hash)
						if currentAmmo ~= maxAmmo and currentAmmo < maxAmmo then
							TriggerEvent('ox_inventory:item', data, function(data)
								if data then
									if data.name == currentWeapon.ammo then
										local missingAmmo = 0
										local newAmmo = 0
										missingAmmo = maxAmmo - currentAmmo
										if missingAmmo > data.count then newAmmo = currentAmmo + data.count else newAmmo = maxAmmo end
										if newAmmo < 0 then newAmmo = 0 end 
										SetPedAmmo(ESX.PlayerData.ped, currentWeapon.hash, newAmmo)
										MakePedReload(ESX.PlayerData.ped)
										currentWeapon.metadata.ammo = newAmmo
										TriggerServerEvent('ox_inventory:updateWeapon', 'load', currentWeapon.metadata.ammo)
									end
								end
							end)
						end
					elseif item.name:find('at_') then
						TriggerEvent('ox_inventory:item', data, function(data)
							if data then
								local attachmentData = Items[data.name]

								for k, component in pairs(attachmentData.client.component) do
									if DoesWeaponTakeWeaponComponent(currentWeapon.hash, component) then
										if HasPedGotWeaponComponent(ESX.PlayerData.ped, currentWeapon.hash, component) then 
											Notify({text = "This weapon already has this component!"})
											return
										else
											GiveWeaponComponentToPed(ESX.PlayerData.ped, currentWeapon.hash, component)
											break
										end
									end
									if k == #attachmentData.client.component then Notify({text = "You can't fit this component to this weapon!"}) end
								end
							end
						end)
					end
				end
			end
		end
	end
end

local Raycast = function()
	local plyOffset = GetOffsetFromEntityInWorldCoords(ESX.PlayerData.ped, 0.0, 3.0, -0.05)
	local ret, hit, coords, surfacenormal, entity = GetShapeTestResult(StartShapeTestRay(playerCoords.x, playerCoords.y, playerCoords.z, plyOffset.x, plyOffset.y, plyOffset.z, -1, ESX.PlayerData.ped, 0))
	local type = GetEntityType(entity)
	if hit and type ~= 0 then return hit, coords, entity, type else	return false end
end

OnPlayerData = function(key, val)
	if key == 'dead' and val then Disarm()
		TriggerEvent('ox_inventory:closeInventory')
	end
	SetWeaponsNoAutoswap(1)
	SetWeaponsNoAutoreload(1)
	SetPedCanSwitchWeapon(ESX.PlayerData.ped, 0)
	SetPedEnableWeaponBlocking(ESX.PlayerData.ped, 1)
end

RegisterNetEvent('ox_inventory:closeInventory', function(options)
	if invOpen then
		SetNuiFocus(false, false)
		SetNuiFocusKeepInput(false)
		TriggerScreenblurFadeOut(0)
		SendNUIMessage({ action = 'closeInventory' })
		if currentInventory and currentInventory.type == 'trunk' then
			local animDict = 'anim@heists@fleeca_bank@scope_out@return_case'
			local anim = 'trevor_action'
			RequestAnimDict(animDict)
			while not HasAnimDictLoaded(animDict) do
				Wait(100)
			end
			ClearPedTasks(ESX.PlayerData.ped)
			Wait(100)
			TaskPlayAnimAdvanced(ESX.PlayerData.ped, animDict, anim, GetEntityCoords(ESX.PlayerData.ped, true), 0, 0, GetEntityHeading(ESX.PlayerData.ped), 2.0, 2.0, 1000, 49, 0.25, 0, 0)
			Wait(900)
			ClearPedTasks(ESX.PlayerData.ped)
			RemoveAnimDict(animDict)
			SetVehicleDoorShut(currentInventory.entity, currentInventory.door, false)
		else SendNUIMessage({ action = 'closeInventory' }) end
		invOpen = nil
		SetInterval(1, 250)
		Wait(500)
		if currentInventory then TriggerServerEvent('ox_inventory:closeInventory') end
		invOpen, currentInventory = false, nil
	end
end)

RegisterNetEvent('ox_inventory:updateInventory', function(items, weights, name, count, removed)
	if invOpen then SendNUIMessage({
			action = 'refreshSlots',
			data = items,
		})
	end
	if count then Notify({text = (removed and 'Removed' or 'Added')..' '..count..'x '..name, duration = 2500}) end
	for i=1, #items do
		local i = items[i].item
		ESX.PlayerData.inventory[i.slot] = i.name and i or nil
	end
	ESX.SetPlayerData('weight', weights.left)
end)

RegisterNetEvent('ox_inventory:inventoryReturned', function(data)
	Notify({text = ox.locale('items_returned'), duration = 2500})
	TriggerEvent('ox_inventory:closeInventory')
	ESX.PlayerData.inventory = data[1]
	ESX.SetPlayerData('inventory', data[1])
	ESX.SetPlayerData('weight', data[3])
end)

RegisterNetEvent('ox_inventory:inventoryConfiscated', function()
	Notify({text = ox.locale('items_confiscated'), duration = 2500})
	TriggerEvent('ox_inventory:closeInventory')
	ESX.PlayerData.inventory = {}
	ESX.SetPlayerData('weight', 0)
end)

RegisterNetEvent('ox_inventory:createDrop', function(data, owner)
	local coords = vector3(data[2].x, data[2].y, data[2].z-0.2)
	Drops = Drops or {}
	Drops[data[1]] = coords
	if owner == playerId and invOpen and #(playerCoords - coords) <= 1 then
		if not IsPedInAnyVehicle(ESX.PlayerData.ped, false) then
			OpenInventory('drop', {id=data[1]})
		end
	end
end)

RegisterNetEvent('ox_inventory:removeDrop', function(id)
	if currentMarker[3] == id then currentMarker = nil end
	nearbyMarkers['drop'..id] = nil
	Drops[id] = nil
end)

RegisterNetEvent('ox_inventory:setPlayerInventory', function(data)
	playerId, ESX.PlayerData.ped, invOpen, currentWeapon, currentDrop = GetPlayerServerId(PlayerId()), ESX.PlayerData.ped, false, false, nil, nil
	ClearWeapons()
	Drops, ESX.PlayerData.inventory = data[1] or {}, data[2]
	ESX.SetPlayerData('inventory', ESX.PlayerData.inventory)
	ESX.SetPlayerData('weight', data[3])
    local ItemData = {}
    for k, v in pairs(Items) do
		v.usable = (v.client and next(v.client) or v.consume == 0 or data[4][v.name] or v.name:find('WEAPON_') or v.name:find('ammo-') or v.name:find('at_')) and true or false
        ItemData[v.name] = {
            label = v.label,
            usable = v.usable,
            stack = v.stack,
            close = v.close
        }
    end
    SendNUIMessage({ action = 'items', data = ItemData })
	if next(Blips) then
		for k, v in pairs(Blips) do
			RemoveBlip(v)
		end
		Blips = {}
	end
	for k, v in pairs(Shops) do
		if v.blip and (not v.job or v.job == ESX.PlayerData.job.name) then
			Blips[k] = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
			SetBlipSprite(Blips[k], v.blip.id)
			SetBlipDisplay(Blips[k], 4)
			SetBlipScale(Blips[k], v.blip.scale)
			SetBlipColour(Blips[k], v.blip.colour)
			SetBlipAsShortRange(Blips[k], true)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(v.name)
			EndTextCommandSetBlipName(Blips[k])
		end
	end
	RegisterKeyMapping('inv', 'Open player inventory~', 'keyboard', Config.Keys[1])
	RegisterKeyMapping('inv2', 'Open secondary inventory~', 'keyboard', Config.Keys[2])
	RegisterKeyMapping('hotbar', 'Display inventory hotbar~', 'keyboard', Config.Keys[3])
	RegisterKeyMapping('reload', 'Reload weapon~', 'keyboard', 'r')
	TriggerEvent('chat:removeSuggestion', '/inv')
	TriggerEvent('chat:removeSuggestion', '/inv2')
	TriggerEvent('chat:removeSuggestion', '/hotbar')
	TriggerEvent('chat:removeSuggestion', '/reload')
	for i=1, 5 do
		RegisterCommand('hotkey'..i, function() if not invOpen then UseSlot(i) end end)
		RegisterKeyMapping('hotkey'..i, 'Use hotbar item '..i..'~', 'keyboard', i)
		TriggerEvent('chat:removeSuggestion', '/hotkey'..i)
	end
	Notify({text = ox.locale('inventory_setup'), duration = 2500})
	collectgarbage('collect')

	SetInterval(1, 250, function()
		playerCoords = GetEntityCoords(ESX.PlayerData.ped)
		if not invOpen then
			local closestMarker
			for k, v in pairs(Drops) do
				local distance = #(playerCoords - v)
				local marker = nearbyMarkers['drop'..k]
				if distance < 1.2 then
					if not marker then nearbyMarkers['drop'..k] = {v, 150, 30, 30} end
					if currentMarker and distance < currentMarker[1] or closestMarker and distance < closestMarker[1] or not closestMarker then
						closestMarker = {distance, k, 'drop'}
					end
				elseif not marker and distance < 8 then nearbyMarkers['drop'..k] = {v, 150, 30, 30} elseif marker and distance > 8 then nearbyMarkers['drop'..k] = nil end
			end
			for k, v in pairs(Shops) do
				local distance = #(playerCoords - v.coords)
				local marker = nearbyMarkers['shop'..k]
				if distance < 1 then
					if not marker then nearbyMarkers['shop'..k] = {v.coords, 30, 150, 30} end
					if currentMarker and distance < currentMarker[1] or closestMarker and distance < closestMarker[1] or not closestMarker then
						closestMarker = {distance, k, 'shop'}
					end
				elseif not marker and distance < 8 then nearbyMarkers['shop'..k] = {v.coords, 30, 150, 30} elseif marker and distance > 8 then nearbyMarkers['shop'..k] = nil end
			end
			for k, v in pairs(Stashes) do
				local distance = #(playerCoords - v.coords)
				local marker = nearbyMarkers['stash'..k]
				if distance < 1 then
					if not marker then nearbyMarkers['stash'..k] = {v.coords, 30, 30, 150} end
					if currentMarker and distance < currentMarker[1] or closestMarker and distance < closestMarker[1] or not closestMarker then
						closestMarker = {distance, k, 'stash'}
					end
				elseif not marker and distance < 8 then nearbyMarkers['stash'..k] = {v.coords, 30, 30, 150} elseif marker and distance > 8 then nearbyMarkers['stash'..k] = nil end
			end
			currentMarker = (closestMarker and closestMarker[1] < 2) and closestMarker or nil
		else
			playerCoords = GetEntityCoords(ESX.PlayerData.ped)
			if currentInventory then
				if currentInventory.type == 'player' then
					local id = GetPlayerFromServerId(currentInventory.id)
					local ped = GetESX.PlayerData.ped(id)
					local pedCoords = GetEntityCoords(ped)
					if not id or #(playerCoords - pedCoords) > 1.8 then
						TriggerEvent('ox_inventory:closeInventory')
						Notify({type = 'error', text = ox.locale('inventory_lost_access'), duration = 2500})
					elseif ESX.PlayerData.job.name ~= 'police' and not CanOpenTarget(ped) then
						TriggerEvent('ox_inventory:closeInventory')
						Notify({type = 'error', text = ox.locale('inventory_lost_access'), duration = 2500})
					else
						TaskTurnToFaceCoords(ESX.PlayerData.ped, pedCoords)
					end
				elseif not lastVehicle and currentInventory.coords and (#(playerCoords - currentInventory.coords) > 2 or CanOpenTarget(ESX.PlayerData.ped)) then
					TriggerEvent('ox_inventory:closeInventory')
					Notify({type = 'error', text = ox.locale('inventory_lost_access'), duration = 2500})
				end
			end
		end
		if ox.parachute and GetPedParachuteState(ESX.PlayerData.ped) ~= -1 then ESX.Game.DeleteObject(ox.parachute) ox.parachute = false end
		if invOpen and not CanOpenInventory() then TriggerEvent('ox_inventory:closeInventory') end
	end)
	
	local wait = nil
	SetInterval(2, 0, function()
		if invOpen then
			DisableAllControlActions(0)
			HideHudAndRadarThisFrame()
			if currentInventory.type == 'newdrop' then
				EnableControlAction(0, 30, true)
				EnableControlAction(0, 31, true)
			end
		else
			if Progress.Active then
				if Progress.Disable.mouse then
					DisableControlAction(0, 1, true) -- LookLeftRight
					DisableControlAction(0, 2, true) -- LookUpDown
					DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
				end
				if Progress.Disable.move then
					DisableControlAction(0, 30, true) -- disable left/right
					DisableControlAction(0, 31, true) -- disable forward/back
					DisableControlAction(0, 36, true) -- INPUT_DUCK
					DisableControlAction(0, 21, true) -- disable sprint
				end
				if Progress.Disable.car then
					DisableControlAction(0, 63, true) -- veh turn left
					DisableControlAction(0, 64, true) -- veh turn right
					DisableControlAction(0, 71, true) -- veh forward
					DisableControlAction(0, 72, true) -- veh backwards
					DisableControlAction(0, 75, true) -- disable exit vehicle
				end
				if Progress.Disable.combat then
					DisablePlayerFiring(playerId, true) -- Disable weapon firing
					DisableControlAction(0, 25, true) -- disable aim
				end
			end
			for k, v in pairs(nearbyMarkers) do
				DrawMarker(2, v[1].x,v[1].y,v[1].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, v[2], v[3], v[4], 222, false, false, false, true, false, false, false)
			end
			DisablePlayerVehicleRewards(playerId)
			if isBusy then
				DisablePlayerFiring(playerID, true)
				DisableControlAction(0, 23, true)
				DisableControlAction(0, 25, true)
				DisableControlAction(0, 263, true)
			end
			if currentWeapon then
				DisableControlAction(0, 263, true)
				if isBusy == false and currentWeapon.timer ~= 0 and currentWeapon.timer < GetGameTimer() then
					TriggerServerEvent('ox_inventory:updateWeapon', 'ammo', currentWeapon.metadata.ammo)
					currentWeapon.timer = 0
				elseif currentWeapon.metadata.ammo then
					if IsPedShooting(ESX.PlayerData.ped) then
						local currentAmmo = GetAmmoInPedWeapon(ESX.PlayerData.ped, currentWeapon.hash)
						currentWeapon.metadata.ammo = (currentWeapon.metadata.ammo < currentAmmo) and 0 or currentAmmo
						if currentAmmo == 0 then
							ClearPedTasks(ESX.PlayerData.ped)
							SetCurrentPedWeapon(ESX.PlayerData.ped, currentWeapon.hash, false)
							SetPedCurrentWeaponVisible(ESX.PlayerData.ped, true, false, false, false)
						end
						currentWeapon.timer = GetGameTimer() + 400
					end
				elseif IsControlJustReleased(0, 24) then
					if currentWeapon.throwable then
						SetBusy(true)
						SetTimeout(700, function()
							ClearPedSecondaryTask(ESX.PlayerData.ped)
							RemoveWeaponFromPed(ESX.PlayerData.ped, currentWeapon.hash)
							TriggerServerEvent('ox_inventory:updateWeapon', 'throw')
							SetWeapon()
							SetBusy(false)
						end)
					elseif IsPedPerformingMeleeAction(ESX.PlayerData.ped) then
						currentWeapon.timer = GetGameTimer() + 400
					end
				end
			end
		end
	end)	
end)

AddEventHandler('onResourceStop', function(resourceName)
	if ox.name == resourceName then
		if ox.parachute then ESX.Game.DeleteObject(ox.parachute) end
		if invOpen then
			SetNuiFocus(false, false)
			SetNuiFocusKeepInput(false)
			TriggerScreenblurFadeOut(0)
		end
	end
end)

AddEventHandler('ox_inventory:item', function(data, cb)
	if isBusy == false and not Progress.Active and not IsPedRagdoll(ESX.PlayerData.ped) and not IsPedFalling(ESX.PlayerData.ped) then
		SetBusy(true)
		local result = ox.TriggerServerCallback('ox_inventory:useItem', data.name, data.slot, data.metadata)
		if result then
			local used
			if data.client and data.client.usetime then
				data = data.client
				Progress.Start({
					duration = data.usetime,
					label = 'Using '..result.label,
					useWhileDead = data.useWhileDead or false,
					canCancel = data.cancel or false,
					Disable = data.disable or {},
					anim = data.anim and ({ dict = data.anim.dict, clip = data.anim.clip, flag = data.anim.flag or 49 } or {scenario = data.scenario}),
					prop = data.prop,
					propTwo = data.propTwo
				}, function(cancel)
					if cancel then used = false else used = true end
				end)
			else used = true end
			while used == nil do Wait(data.usetime/2) end
			if used then
				if result.consume and result.consume ~= 0 then TriggerServerEvent('ox_inventory:removeItem', result.name, result.consume, result.metadata, data.slot) end
				if data.status then
					for k, v in pairs(data.status) do
						if v > 0 then TriggerEvent('esx_status:add', k, v) else TriggerEvent('esx_status:remove', k, -v) end
					end
				end
				if currentWeapon and currentWeapon.metadata.serial ~= nil and result.metadata and result.metadata.serial == currentWeapon.metadata.serial then Disarm() else cb(result) end
				return SetBusy(false)
			end
		end
		SetBusy(false)
	end
	cb(false)
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout', function()
	if ox.parachute then ESX.Game.DeleteObject(ox.parachute) ox.parachute = false end
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
	if IsPedInAnyVehicle(ESX.PlayerData.ped, false) then currentDrop = nil end
	if currentMarker and not invOpen then OpenInventory(currentMarker[3], {id=currentMarker[2]})
	else OpenInventory() end
end)

RegisterCommand('inv2', function()
	if not invOpen then
		if isBusy then return Notify({type = 'error', text = ox.locale('inventory_cannot_open'), duration = 2500})
		elseif currentInventory then TriggerEvent('ox_inventory:closeInventory')
		else
			if not CanOpenInventory() then return Notify({type = 'error', text = ox.locale('inventory_cannot_open'), duration = 2500}) end
			if IsPedInAnyVehicle(ESX.PlayerData.ped, false) then
				local vehicle = GetVehiclePedIsIn(ESX.PlayerData.ped, false)
				if NetworkGetEntityIsNetworked(vehicle) then
					local plate = Config.TrimPlate and ox.trim(GetVehicleNumberPlateText(vehicle)) or GetVehicleNumberPlateText(vehicle)
					OpenInventory('glovebox', {id='glove'..plate, label=plate, class=GetVehicleClass(vehicle)})
					Wait(100)
					while true do
						Wait(100)
						if not invOpen then break
						elseif not IsPedInAnyVehicle(ESX.PlayerData.ped, false) then
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
					elseif type == 3 and Utils.CheckTable(Config.Dumpsters, GetEntityModel(entity)) then
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
				if vehicle and Vehicles.trunk[class] and #(playerCoords - position) < 6 and NetworkGetEntityIsNetworked(vehicle) then
					local locked = GetVehicleDoorLockStatus(vehicle)
					if locked == 0 or locked == 1 then
						local vehHash = GetEntityModel(vehicle)
						local checkVehicle = Vehicles.storage[vehHash]
						local open, vehBone
						if checkVehicle == 1 then open, vehBone = 4, GetEntityBoneIndexByName(vehicle, 'bonnet')
						elseif checkVehicle == nil then open, vehBone = 5, GetEntityBoneIndexByName(vehicle, 'boot') elseif checkVehicle == 2 then open, vehBone = 5, GetEntityBoneIndexByName(vehicle, 'boot') else --[[no vehicle nearby]] return end
						if vehBone == -1 then vehBone = GetEntityBoneIndexByName(vehicle, 'platelight') end
						position = GetWorldPositionOfEntityBone(vehicle, vehBone)
						local distance = #(playerCoords - position)
						local closeToVehicle = distance < 2 and (open == 5 and (checkVehicle == nil and true or 2) or open == 4)
						if closeToVehicle then
							local plate = Config.TrimPlate and ox.trim(GetVehicleNumberPlateText(vehicle)) or GetVehicleNumberPlateText(vehicle)
							TaskTurnPedToFaceCoord(ESX.PlayerData.ped, position)
							lastVehicle = vehicle
							OpenInventory('trunk', {id='trunk'..plate, label=plate, class=class})
							local timeout = 20
							repeat Wait(50)
								timeout = timeout - 1
							until (currentInventory and currentInventory.type == 'trunk') or timeout == 0
							if timeout == 0 then
								closeToVehicle, lastVehicle = false, nil
								return
							end
							SetVehicleDoorOpen(vehicle, open, false, false)
							Wait(200)
							Utils.PlayAnim(100, 'anim@heists@prison_heiststation@cop_reactions', 'cop_b_idle', 3.0, 3.0, -1, 49, 0, 0, 0, 0)
							currentInventory.entity = lastVehicle
							currentInventory.door = open
							while true do
								Wait(50)
								if closeToVehicle and invOpen then
									local position = GetWorldPositionOfEntityBone(vehicle, vehBone)
									local playerCoords = GetEntityCoords(ESX.PlayerData.ped)
									if #(playerCoords - position) >= 2 or not DoesEntityExist(vehicle) then
										break
									else TaskTurnPedToFaceCoord(ESX.PlayerData.ped, position) end
								else break end
							end
							if lastVehicle then TriggerEvent('ox_inventory:closeInventory') end
						end
					else Notify({type = 'error', text = ox.locale('vehicle_locked'), duration = 2500}) end
				end
			end
		end
	end
end)

RegisterCommand('reload', function()
	if currentWeapon and currentWeapon.ammo then
		local ammo = Utils.InventorySearch(1, currentWeapon.ammo)
		if ammo then UseSlot(ammo[1].slot) end
	end
end)

RegisterCommand('hotbar', function()
	SendNUIMessage({
		action = 'toggleHotbar'
	})
end)

RegisterNUICallback('useItem', function(data, cb)
	UseSlot(data.slot)
    cb()
end)

RegisterNUICallback('exit', function(data, cb)
	TriggerEvent('ox_inventory:closeInventory')
    cb()
end)

RegisterNUICallback('swapItems', function(data, cb)
	--todo: check inventory slot for weapon and disarm if equipped and moved
	local response, data = ox.TriggerServerCallback('ox_inventory:swapItems', data)
	if data then
		for k, v in pairs(data.items) do
			ESX.PlayerData.inventory[k] = v and v or nil
		end
		ESX.SetPlayerData('inventory', ESX.PlayerData.inventory)
		if data.weight then ESX.SetPlayerData('weight', data.weight) end
	end
	cb(response)
end)

RegisterNUICallback('buyItem', function(data, cb)
	local response, data, message = ox.TriggerServerCallback('ox_inventory:buyItem', data)
	if data then
		for k, v in pairs(data.items) do
			ESX.PlayerData.inventory[k] = v and v or nil

			SendNUIMessage({
				action = 'refreshSlots',
				data = {item = v},
			})
		end
		ESX.SetPlayerData('inventory', ESX.PlayerData.inventory)
		if data.weight then ESX.SetPlayerData('weight', data.weight) end
	end
	if message then Notify(message) end
	cb(response)
end)

if ESX.PlayerLoaded then TriggerServerEvent('ox_inventory:requestPlayerInventory') end
