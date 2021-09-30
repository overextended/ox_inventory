local Stashes <const> = data('stashes')
local Vehicles <const> = data('vehicles')
local Licenses <const> = data('licenses')
local Items <const>, Weapons <const> = table.unpack(module('items'))
local Utils <const> = module('utils')
local Progress <const> = module('progress')
local Shops <const> = module('shops')
local Inventory <const> = module('inventory')
local Keyboard <const> = module('input')
local invOpen, playerId, currentWeapon
local plyState, isBusy = LocalPlayer.state, false

local SetBusy = function(state)
	isBusy = state
	plyState:set('isBusy', state, false)
end
exports('SetBusy', SetBusy)

local SetWeapon = function(weapon, hash, ammo)
	currentWeapon = weapon and {
		hash = hash,
		ammo = ammo,
		name = weapon.name,
		slot = weapon.slot,
		label = weapon.label,
		metadata = weapon.metadata,
		throwable = weapon.throwable
	} or nil
	TriggerEvent('ox_inventory:currentWeapon', currentWeapon)
	if currentWeapon then currentWeapon.timer = 0 end
end

local Disarm = function(newSlot)
	SetWeaponsNoAutoswap(1)
	SetWeaponsNoAutoreload(1)
	SetPedCanSwitchWeapon(ESX.PlayerData.ped, 0)
	SetPedEnableWeaponBlocking(ESX.PlayerData.ped, 1)
	if currentWeapon then
		local ammo = GetAmmoInPedWeapon(ESX.PlayerData.ped, currentWeapon.hash)
		SetPedAmmo(ESX.PlayerData.ped, currentWeapon.hash, 0)
		ClearPedSecondaryTask(ESX.PlayerData.ped)
		if newSlot ~= -1 then
			local sleep = (ESX.PlayerData.job.name == 'police' and GetWeapontypeGroup(currentWeapon.hash) == 416676503) and 450 or 1400
			local coords = GetEntityCoords(ESX.PlayerData.ped, true)
			Utils.PlayAnimAdvanced(sleep, (sleep == 450 and 'reaction@intimidation@cop@unarmed' or 'reaction@intimidation@1h'), 'outro', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(ESX.PlayerData.ped), 8.0, 3.0, -1, 50, 0, 0, 0)
			Wait(sleep)
		end
		RemoveWeaponFromPed(ESX.PlayerData.ped, currentWeapon.hash)
		TriggerServerEvent('ox_inventory:updateWeapon', 'disarm', ammo, newSlot)
		SetWeapon()
	end
end
RegisterNetEvent('ox_inventory:disarm', Disarm)

local ClearWeapons = function()
	Disarm(-1)
	for k in pairs(Weapons) do SetPedAmmo(ESX.PlayerData.ped, k, 0) end
	RemoveAllPedWeapons(ESX.PlayerData.ped, true)
	if ox.parachute then
		local chute = `GADGET_PARACHUTE`
		GiveWeaponToPed(ESX.PlayerData.ped, chute, 0, true, false)
		SetPedGadget(ESX.PlayerData.ped, chute, true)
	end
end
RegisterNetEvent('ox_inventory:clearWeapons', ClearWeapons)

local Notify = function(data) SendNUIMessage({ action = 'showNotif', data = data }) end
RegisterNetEvent('ox_inventory:Notify', Notify)
exports('Notify', Notify)

local isCuffed = false
local CanOpenInventory = function()
	return ESX.PlayerLoaded
	and invOpen ~= nil
	and isBusy == false
	and isCuffed == false
	and ESX.PlayerData.dead == false
	and (currentWeapon == nil or currentWeapon.timer == 0)
	and IsPauseMenuActive() == false
	and IsPedFatallyInjured(ESX.PlayerData.ped, 1) == false
end

local currentInventory
local OpenInventory = function(inv, data)
	if CanOpenInventory() then
		local left, right
		if inv == 'shop' and invOpen == false then
			left, right = Utils.AwaitServerCallback('ox_inventory:openShop', data)
		elseif invOpen == false or (invOpen == true and currentInventory?.type == 'newdrop' and (inv == 'drop' or inv == 'container')) then
			if inv == 'policeevidence' then
				local input = Keyboard.Input('Police Evidence', {'Locker number'})
				if input then
					input = tonumber(input[1])
				else
					return Notify({text = 'Must contain value to open locker!', type = 'error'})
				end
				if type(input) ~= 'number' then return Notify({text = 'Locker must be a number!', type = 'error'}) else data = {id=input} end
			end
			left, right = Utils.AwaitServerCallback('ox_inventory:openInventory', inv, data)
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
		else
			if invOpen == false then Notify({type = 'error', text = ox.locale('inventory_cannot_open_other'), duration = 2500}) end
			TriggerEvent('ox_inventory:closeInventory')
		end
	else Notify({type = 'error', text = ox.locale('inventory_cannot_open'), duration = 2500}) end
end
RegisterNetEvent('ox_inventory:openInventory', OpenInventory)

local UseSlot = function(slot)
	if ESX.PlayerLoaded and isBusy == false and Progress.Active == false then
		local item = ESX.PlayerData.inventory[slot]
		local data = item and Items[item.name]
		if item and data.usable then
			data.slot = slot
			if item.metadata.container then
				OpenInventory('container', item.slot)
			elseif data.client and data.client.event then
				TriggerEvent(data.client.event, data, {name = item.name, slot = item.slot, metadata = item.metadata})
			elseif data.effect then
				data:effect({name = item.name, slot = item.slot, metadata = item.metadata})
			elseif item.name:find('WEAPON_') then
				TriggerEvent('ox_inventory:item', data, function(data)
					if data then
						local data = Items[item.name]
						if data.throwable then item.throwable = true end
						ClearPedSecondaryTask(ESX.PlayerData.ped)
						if currentWeapon then Disarm(data.slot) end
						local sleep = (ESX.PlayerData.job.name == 'police' and GetWeapontypeGroup(data.hash) == 416676503) and 400 or 1200
						local coords = GetEntityCoords(ESX.PlayerData.ped, true)
						Utils.PlayAnimAdvanced(sleep*2, sleep == 400 and 'reaction@intimidation@cop@unarmed' or 'reaction@intimidation@1h', 'intro', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(ESX.PlayerData.ped), 8.0, 3.0, -1, 50, 0.1)
						Wait(sleep)
						GiveWeaponToPed(ESX.PlayerData.ped, data.hash, 0, false, true)
						if item.metadata.components then
							for i=1, #item.metadata.components do
								local components = Items[item.metadata.components[i]].client.component
								for v=1, #components do
									local component = components[v]
									if DoesWeaponTakeWeaponComponent(data.hash, component) then
										if not HasPedGotWeaponComponent(ESX.PlayerData.ped, data.hash, component) then 
											GiveWeaponComponentToPed(ESX.PlayerData.ped, data.hash, component)
										end
									end
								end
							end
						end
						SetPedCurrentWeaponVisible(ESX.PlayerData.ped, true, false, false, false)
						SetAmmoInClip(ESX.PlayerData.ped, data.hash, item.metadata.ammo or 100)
						SetWeapon(item, data.hash, data.ammoname)
						Wait(sleep)
						ClearPedSecondaryTask(ESX.PlayerData.ped)
					end
				end)
			elseif currentWeapon then
				if item.name:find('ammo-') then
					local maxAmmo = GetMaxAmmoInClip(ESX.PlayerData.ped, currentWeapon.hash, true)
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
					local components = data.client.component
					for i=1, #components do
						local component = components[i]
						if DoesWeaponTakeWeaponComponent(currentWeapon.hash, component) then
							if HasPedGotWeaponComponent(ESX.PlayerData.ped, currentWeapon.hash, component) then 
								Notify({type = 'error', text = ox.locale('component_has', data.label)})
							else
								TriggerEvent('ox_inventory:item', data, function(data)
									if data then
										GiveWeaponComponentToPed(ESX.PlayerData.ped, currentWeapon.hash, component)
										table.insert(ESX.PlayerData.inventory[currentWeapon.slot].metadata.components, component)
									end
								end)
							end
							return
						end
					end
					Notify({type = 'error', text = ox.locale('component_invalid', data.label) })
				end
			else
				TriggerEvent('ox_inventory:item', data)
			end
		end
	end
end

local CanOpenTarget = function(ped)
	return IsPedFatallyInjured(ped)
	or IsEntityPlayingAnim(ped, 'dead', 'dead_a', 3)
	or IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_enter', 3)
	or IsEntityPlayingAnim(ped, 'random@mugging3', 'handsup_standing_base', 3)
end

local Drops, nearbyMarkers, closestMarker, playerCoords = {}, {}, {}, nil
local Markers = function(tb, type, rgb, name)
	for k, v in pairs(tb) do
		local coords = v.coords or v
		local distance = #(playerCoords - coords)
		local id = name and type..name..k or type..k
		local marker = nearbyMarkers[id]
		if distance < 1.2 then
			if not marker then nearbyMarkers[id] = mat(vec3(coords), vec3(rgb)) end
			if closestMarker[1] == nil or (closestMarker and distance < closestMarker[1]) then
				closestMarker[1] = distance
				closestMarker[2] = k
				closestMarker[3] = type
				closestMarker[4] = name or v.name
			end
		elseif not marker and distance < 8 then nearbyMarkers[id] = mat(vec3(coords), vec3(rgb)) elseif marker and distance > 8 then nearbyMarkers[id] = nil end
	end
end

OnPlayerData = function(key, val)
	if key == 'job' then Shops.CreateShopLocations()
	elseif key == 'dead' and val then
		Disarm(-1)
		TriggerEvent('ox_inventory:closeInventory')
		Wait(50)
	end
	SetWeaponsNoAutoswap(1)
	SetWeaponsNoAutoreload(1)
end

SetInterval(1, 250, function()
	if not invOpen then
		playerCoords = GetEntityCoords(ESX.PlayerData.ped)
		closestMarker = table.wipe(closestMarker)
		Markers(Drops, 'drop', vec3(150, 30, 30))
		Markers(Stashes, 'stash', vec3(30, 30, 150))
		if not Config.Target then
			for k, v in pairs(Shops.Stores) do
				Markers(v.locations, 'shop', vec3(30, 150, 30), k)
			end
		end
		Markers(Licenses, 'license', vec(30, 150, 30))
		-- todo: finish police evidence system
		local distance = #(playerCoords - vec3(-22.4, -1105.5, 26.7))
		local marker = nearbyMarkers['policeevidence']
		if distance < 1.2 then
			if not marker then nearbyMarkers['policeevidence'] = mat(vec3(-22.4, -1105.5, 26.7), vec3(30, 30, 150)) end
			if closestMarker[1] == nil or (closestMarker and distance < closestMarker[1]) then
				closestMarker = {distance, 1, 'policeevidence'}
			end
		elseif not marker and distance < 8 then nearbyMarkers['policeevidence'] = mat(vec3(-22.4, -1105.5, 26.7), vec3(30, 30, 150)) elseif marker and distance > 8 then nearbyMarkers['policeevidence'] = nil end
		----------------
		if IsPedInAnyVehicle(ESX.PlayerData.ped, false) then closestMarker = table.wipe(closestMarker) end
		SetPedCanSwitchWeapon(ESX.PlayerData.ped, false)
		SetPedEnableWeaponBlocking(ESX.PlayerData.ped, true)
	else
		playerCoords = GetEntityCoords(ESX.PlayerData.ped)
		if currentInventory then
			if currentInventory.type == 'target' then
				local id = GetPlayerFromServerId(currentInventory.id)
				local ped = GetPlayerPed(id)
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
			elseif currentInventory.coords and (#(playerCoords - currentInventory.coords) > 2 or CanOpenTarget(ESX.PlayerData.ped)) then
				TriggerEvent('ox_inventory:closeInventory')
				Notify({type = 'error', text = ox.locale('inventory_lost_access'), duration = 2500})
			end
		end
	end
	if ox.parachute and GetPedParachuteState(ESX.PlayerData.ped) ~= -1 then ESX.Game.DeleteObject(ox.parachute) ox.parachute = false end
	if invOpen and not CanOpenInventory() then TriggerEvent('ox_inventory:closeInventory') end
end)

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
		for _, v in pairs(nearbyMarkers) do
			DrawMarker(2, v[1].x, v[1].y, v[1].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, v[2].x, v[2].y, v[2].z, 222, false, false, false, true, false, false, false)
		end
		DisablePlayerVehicleRewards(playerId)
		if isBusy then
			DisablePlayerFiring(playerID, true)
			DisableControlAction(0, 23, true)
			DisableControlAction(0, 25, true)
			DisableControlAction(0, 263, true)
		end
		if closestMarker and IsControlJustReleased(0, 38, true) then
			if closestMarker[3] == 'license' then
				Utils.TriggerServerCallback('ox_inventory:buyLicense', function(success, message)
					if success == false then
						Notify({type = 'error', text = ox.locale(message), duration = 2500})
					else
						Notify({text = ox.locale(success), duration = 2500})
					end
				end, 1000, closestMarker[2])
			elseif closestMarker[3] == 'shop' then OpenInventory(closestMarker[3], {id=closestMarker[2], type=closestMarker[4]})
			elseif closestMarker[3] == 'policeevidence' then OpenInventory(closestMarker[3]) end
		end
		if currentWeapon then
			DisableControlAction(0, 140, true)
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
						if Config.AutoReload and Progress.Active == false and IsPedRagdoll(ESX.PlayerData.ped) == false and IsPedFalling(ESX.PlayerData.ped) == false then
							local ammo = Inventory.Search(1, currentWeapon.ammo)
							if ammo[1] then
								currentWeapon.timer = 0
								UseSlot(ammo[1].slot)
							end
						end
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

RegisterNetEvent('ox_inventory:closeInventory', function(options)
	if invOpen then invOpen = nil
		SetNuiFocus(false, false)
		SetNuiFocusKeepInput(false)
		TriggerScreenblurFadeOut(0)
		if currentInventory and currentInventory.type == 'trunk' then
			local animDict = 'anim@heists@fleeca_bank@scope_out@return_case'
			local anim = 'trevor_action'
			RequestAnimDict(animDict)
			while not HasAnimDictLoaded(animDict) do
				Wait(100)
			end
			ClearPedTasks(ESX.PlayerData.ped)
			Wait(100)
			local coords = GetEntityCoords(ESX.PlayerData.ped, true)
			TaskPlayAnimAdvanced(ESX.PlayerData.ped, animDict, anim, coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(ESX.PlayerData.ped), 2.0, 2.0, 1000, 49, 0.25, 0, 0)
			Wait(900)
			ClearPedTasks(ESX.PlayerData.ped)
			RemoveAnimDict(animDict)
			SetVehicleDoorShut(currentInventory.entity, currentInventory.door, false)
		end
		SendNUIMessage({ action = 'closeInventory' })
		SetInterval(1, 250)
		Wait(200)
		if currentInventory then TriggerServerEvent('ox_inventory:closeInventory') end
		invOpen, currentInventory = false, nil
	end
end)

RegisterNetEvent('ox_inventory:updateInventory', function(items, weights, name, count, removed)
	SendNUIMessage({ action = 'refreshSlots', data = items })
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

RegisterNetEvent('ox_inventory:inventoryConfiscated', function(message)
	if message then Notify({text = ox.locale('items_confiscated'), duration = 2500}) end
	TriggerEvent('ox_inventory:closeInventory')
	ESX.PlayerData.inventory = table.wipe(ESX.PlayerData.inventory)
	ESX.SetPlayerData('weight', 0)
end)

RegisterNetEvent('ox_inventory:createDrop', function(data, owner, slot)
	local coords = vec3(data[2].x, data[2].y, data[2].z-0.2)
	Drops[data[1]] = {coords=coords}
	if owner == playerId and invOpen and #(GetEntityCoords(ESX.PlayerData.ped) - coords) <= 1 then
		if currentWeapon?.slot == slot then Disarm(-1) end
		if not IsPedInAnyVehicle(ESX.PlayerData.ped, false) then
			OpenInventory('drop', {id=data[1]})
		end
	end
end)

RegisterNetEvent('ox_inventory:removeDrop', function(id)
	if closestMarker?[3] == id then closestMarker = table.wipe(closestMarker) end
	if Drops then Drops[id] = nil end
	nearbyMarkers['drop'..id] = nil
end)

RegisterNetEvent('ox_inventory:setPlayerInventory', function(drops, inventory, weight, esxitem, label)
	playerId, ESX.PlayerData.ped, invOpen, currentWeapon = GetPlayerServerId(PlayerId()), ESX.PlayerData.ped, false, nil
	ClearWeapons()
	Drops, ESX.PlayerData.inventory = drops, inventory
	ESX.SetPlayerData('inventory', ESX.PlayerData.inventory)
	ESX.SetPlayerData('weight', weight)
    local ItemData = table.create(0, #Items)
    for _, v in pairs(Items) do
		v.usable = (v.client and next(v.client) or v.consume == 0 or esxitem[v.name] or v.name:find('WEAPON_') or v.name:find('ammo-') or v.name:find('at_')) and true or false
        ItemData[v.name] = {
            label = v.label,
            usable = v.usable,
            stack = v.stack,
            close = v.close,
			description = v.description
        }
    end
    SendNUIMessage({ 
		action = 'init',
		data = {
			items = ItemData,
			leftInventory = {
				id = playerId,
				slots = Config.PlayerSlots,
				items = ESX.PlayerData.inventory,
				maxWeight = Config.DefaultWeight,
				label = label
			}
		}
	})
	Shops.CreateShopLocations()
	Notify({text = ox.locale('inventory_setup'), duration = 2500})
	collectgarbage('collect')
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
	if isBusy == false and Progress.Active == false and IsPedRagdoll(ESX.PlayerData.ped) == false and IsPedFalling(ESX.PlayerData.ped) == false then
		if currentWeapon and currentWeapon?.timer > 100 then return end
		SetBusy(true)
		if invOpen and data.close then TriggerEvent('ox_inventory:closeInventory') end
		local result = Utils.AwaitServerCallback('ox_inventory:useItem', data.name, data.slot, data.metadata)
		if cb == nil then return SetBusy(false) end
		if result and isBusy then
			local used
			if data.client and data.client.usetime then
				data = data.client
				Progress.Start({
					duration = data.usetime,
					label = 'Using '..result.label,
					useWhileDead = data.useWhileDead or false,
					canCancel = data.cancel or false,
					disable = data.disable,
					anim = data.anim and ({ dict = data.anim.dict, clip = data.anim.clip, flag = data.anim.flag or 49 } or {scenario = data.scenario}),
					prop = data.prop,
					propTwo = data.propTwo
				}, function(cancel)
					if cancel then used = false else used = true end
				end)
			else used = true end
			while used == nil do Wait(data.usetime/2) end
			if used then
				if result.consume and result.consume ~= 0 then TriggerServerEvent('ox_inventory:removeItem', result.name, result.consume, result.metadata, result.slot) end
				if data.status then
					for k, v in pairs(data.status) do
						if v > 0 then TriggerEvent('esx_status:add', k, v) else TriggerEvent('esx_status:remove', k, -v) end
					end
				end
				if currentWeapon?.slot == result.slot then Disarm() else cb(result) end
				Wait(200)
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
	Disarm(-1)
end)

RegisterNetEvent('esx_policejob:handcuff', function()
	isCuffed = not isCuffed
	if isCuffed then Disarm(-1) TriggerEvent('ox_inventory:closeInventory') end
end)

RegisterNetEvent('esx_policejob:unrestrain', function()
	isCuffed = false
	TriggerEvent('ox_inventory:closeInventory')
end)

RegisterCommand('inv', function()
	if closestMarker[1] and closestMarker[3] ~= 'license' and closestMarker[3] ~= 'policeevidence' then
		OpenInventory(closestMarker[3], {id=closestMarker[2], type=closestMarker[4]})
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
					local plate = Config.TrimPlate and string.strtrim(GetVehicleNumberPlateText(vehicle)) or GetVehicleNumberPlateText(vehicle)
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
				local entity, type = Utils.Raycast()
				if entity == false then return end
				local vehicle, position
				if not Config.Target then
					if type == 2 then vehicle, position = entity, GetEntityCoords(entity)
					elseif type == 3 and Utils.CheckTable(Inventory.Dumpsters, GetEntityModel(entity)) then
						local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity) or false
						if netId == false then
							SetEntityAsMissionEntity(entity)
							NetworkRegisterEntityAsNetworked(entity)
							netId = NetworkGetNetworkIdFromEntity(entity)
							NetworkUseHighPrecisionBlending(netId, false)
							SetNetworkIdExistsOnAllMachines(netId)
							SetNetworkIdCanMigrate(netId, true)
						end
						return OpenInventory('dumpster', {id='dumpster'..netId})
					end
				elseif type == 2 then
					vehicle, position = entity, GetEntityCoords(entity)
				else return end
				local lastVehicle = nil
				local class = GetVehicleClass(vehicle)
				if vehicle and Vehicles.trunk[class] and #(playerCoords - position) < 6 and NetworkGetEntityIsNetworked(vehicle) then
					local locked = GetVehicleDoorLockStatus(vehicle)
					if locked == 0 or locked == 1 then
						local vehHash = GetEntityModel(vehicle)
						local checkVehicle = Vehicles.Storage[vehHash]
						local open, vehBone
						if checkVehicle == 1 then open, vehBone = 4, GetEntityBoneIndexByName(vehicle, 'bonnet')
						elseif checkVehicle == nil then open, vehBone = 5, GetEntityBoneIndexByName(vehicle, 'boot') elseif checkVehicle == 2 then open, vehBone = 5, GetEntityBoneIndexByName(vehicle, 'boot') else --[[no vehicle nearby]] return end
						if vehBone == -1 then vehBone = GetEntityBoneIndexByName(vehicle, 'platelight') end
						position = GetWorldPositionOfEntityBone(vehicle, vehBone)
						local distance = #(playerCoords - position)
						local closeToVehicle = distance < 2 and (open == 5 and (checkVehicle == nil and true or 2) or open == 4)
						if closeToVehicle then
							local plate = Config.TrimPlate and string.strtrim(GetVehicleNumberPlateText(vehicle)) or GetVehicleNumberPlateText(vehicle)
							TaskTurnPedToFaceCoord(ESX.PlayerData.ped, position.x, position.y, position.z)
							lastVehicle = vehicle
							OpenInventory('trunk', {id='trunk'..plate, label=plate, class=class})
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
							Utils.PlayAnim(100, 'anim@heists@prison_heiststation@cop_reactions', 'cop_b_idle', 3.0, 3.0, -1, 49, 0, 0, 0, 0)
							currentInventory.entity = lastVehicle
							currentInventory.door = open
							while true do
								Wait(50)
								if closeToVehicle and invOpen then
									position = GetWorldPositionOfEntityBone(vehicle, vehBone)
									if #(GetEntityCoords(ESX.PlayerData.ped) - position) >= 2 or not DoesEntityExist(vehicle) then
										break
									else TaskTurnPedToFaceCoord(ESX.PlayerData.ped, position.x, position.y, position.z) end
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
	if currentWeapon?.ammo then
		local ammo = Inventory.Search(1, currentWeapon.ammo)
		if ammo[1] then UseSlot(ammo[1].slot) end
	end
end)

RegisterCommand('hotbar', function()
	SendNUIMessage({ action = 'toggleHotbar' })
end)

RegisterNUICallback('useItem', function(slot)
	UseSlot(slot)
end)

RegisterNUICallback('exit', function()
	TriggerEvent('ox_inventory:closeInventory')
end)

RegisterNUICallback('swapItems', function(data, cb)
	local response, data, weapon = Utils.AwaitServerCallback('ox_inventory:swapItems', data)
	if data then
		for k, v in pairs(data.items) do
			ESX.PlayerData.inventory[k] = v and v or nil
		end
		ESX.SetPlayerData('inventory', ESX.PlayerData.inventory)
		if data.weight then ESX.SetPlayerData('weight', data.weight) end
	end
	if weapon and currentWeapon then
		currentWeapon.slot = weapon
		TriggerEvent('ox_inventory:currentWeapon', currentWeapon)
	end
	cb(response)
end)

RegisterNUICallback('buyItem', function(data, cb)
	local response, data, message =Utils.AwaitServerCallback('ox_inventory:buyItem', data)
	if data then
		ESX.PlayerData.inventory[data[1]] = data[2]
		ESX.SetPlayerData('inventory', ESX.PlayerData.inventory)
		ESX.SetPlayerData('weight', data[3])
		SendNUIMessage({ action = 'refreshSlots', data = {item = data[2]} })
	end
	if message then Notify(message) end
	cb(response)
end)

if ESX.PlayerLoaded then TriggerServerEvent('ox_inventory:requestPlayerInventory') end

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
