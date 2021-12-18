local DisableControlActions = import 'controls'
local isBusy = true

AddStateBagChangeHandler('busy', nil, function(bagName, _, value, _, _)
	if bagName:find(PlayerData.id) then
		isBusy = value
		if isBusy then
			DisableControlActions:Add(23, 25, 36, 263)
		else
			DisableControlActions:Remove(23, 25, 36, 263)
		end
	end
end)

local Items = client.items
local Utils = client.utils
local currentWeapon

RegisterNetEvent('ox_inventory:disarm', function(newSlot)
	Utils.Disarm(currentWeapon, newSlot)
end)

RegisterNetEvent('ox_inventory:clearWeapons', function()
	Utils.ClearWeapons(currentWeapon)
end)

AddEventHandler('ox_inventory:currentWeapon', function(weapon)
	currentWeapon = weapon
end)

local StashTarget
exports('setStashTarget', function(id, owner)
	StashTarget = id and {id=id, owner=owner}
end)

local invOpen = false

local function CanOpenInventory()
	return PlayerData.loaded
	and not isBusy
	and not PlayerData.dead
	and (currentWeapon == nil or currentWeapon.timer == 0)
	and not IsPauseMenuActive()
	and not IsPedFatallyInjured(PlayerData.ped)
	and invOpen ~= nil
end

local defaultInventory = {
	type = 'newdrop',
	slots = ox.playerslots,
	weight = 0,
	maxWeight = ox.playerweight,
	items = {}
}
local currentInventory = defaultInventory

local function CloseTrunk()
	if currentInventory?.type == 'trunk' then
		local entity = currentInventory.entity
		local door = currentInventory.door
		local coords = GetEntityCoords(PlayerData.ped, true)
		Utils.PlayAnimAdvanced(900, 'anim@heists@fleeca_bank@scope_out@return_case', 'trevor_action', coords.x, coords.y, coords.z, 0.0, 0.0, GetEntityHeading(PlayerData.ped), 2.0, 2.0, 1000, 49, 0.25)
		CreateThread(function()
			local entity, door = entity, door
			Wait(900)
			SetVehicleDoorShut(entity, door, false)
		end)
	end
end

local ServerCallback = import 'callbacks'
local Interface = client.interface
local plyState = LocalPlayer.state

local function OpenInventory(inv, data)
	if invOpen then
		if not inv and currentInventory.type == 'newdrop' then
			return TriggerEvent('ox_inventory:closeInventory')
		end

		if inv == 'container' and currentInventory.id == PlayerData.inventory[data].metadata.container then
			return TriggerEvent('ox_inventory:closeInventory')
		end

		if currentInventory.type == 'drop' and (not data or currentInventory.id == (type(data) == 'table' and data.id or data)) then
			return TriggerEvent('ox_inventory:closeInventory')
		end
	end

	if CanOpenInventory() then
		local left, right
		if inv == 'shop' and invOpen == false then
			left, right = ServerCallback.Await(ox.resource, 'openShop', 200, data)
		elseif invOpen ~= nil then
			if inv == 'policeevidence' then
				local input = Interface.Keyboard(ox.locale('police_evidence'), {ox.locale('locker_number')})

				if input then
					input = tonumber(input[1])
				else
					return Utils.Notify({text = ox.locale('locker_no_value'), type = 'error'})
				end

				if type(input) ~= 'number' then
					return Utils.Notify({text = ox.locale('locker_must_number'), type = 'error'})
				else
					data = input
				end
			end
			left, right = ServerCallback.Await(ox.resource, 'openInventory', 200, inv, data)
		end

		if left then
			if inv ~= 'trunk' and not IsPedInAnyVehicle(PlayerData.ped, false) then
				Utils.PlayAnim(1000, 'pickup_object', 'putdown_low', 5.0, 1.5, -1, 48, 0.0, 0, 0, 0)
			end
			invOpen = true
			plyState:set('invOpen', true, false)
			SetInterval[1] = 100
			SetNuiFocus(true, true)
			SetNuiFocusKeepInput(true)
			if ox.blurscreen then TriggerScreenblurFadeIn(0) end
			CloseTrunk()
			currentInventory = right or defaultInventory
			left.items = PlayerData.inventory
			SendNUIMessage({
				action = 'setupInventory',
				data = {
					leftInventory = left,
					rightInventory = currentInventory,
					job = {
						grade = PlayerData.job.grade,
						grade_label = PlayerData.job.grade_label,
						name = PlayerData.job.name
					}
				}
			})
		else
			if invOpen == false then Utils.Notify({type = 'error', text = ox.locale('inventory_right_access'), duration = 2500}) end
			if invOpen then TriggerEvent('ox_inventory:closeInventory') end
		end
	elseif not isBusy then Utils.Notify({type = 'error', text = ox.locale('inventory_player_access'), duration = 2500}) end
end
RegisterNetEvent('ox_inventory:openInventory', OpenInventory)
exports('openInventory', OpenInventory)

local function UseSlot(slot)
	if PlayerData.loaded and not isBusy and not Interface.ProgressActive then
		local item = PlayerData.inventory[slot]
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
				TriggerEvent('ox_inventory:item', data, function(result)
					if result then
						local playerPed = PlayerData.ped
						if data.throwable then item.throwable = true end
						ClearPedSecondaryTask(playerPed)
						if currentWeapon then Utils.Disarm(currentWeapon, data.slot) end
						local sleep = (PlayerData.job.name == 'police' and GetWeapontypeGroup(data.hash) == 416676503) and 400 or 1200
						local coords = GetEntityCoords(playerPed, true)
						Utils.PlayAnimAdvanced(sleep*2, sleep == 400 and 'reaction@intimidation@cop@unarmed' or 'reaction@intimidation@1h', 'intro', coords.x, coords.y, coords.z, 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, -1, 50, 0.1)
						Wait(sleep)
						SetPedAmmo(playerPed, data.hash, 0)
						GiveWeaponToPed(playerPed, data.hash, 0, false, true)

						if item.metadata.tint then SetPedWeaponTintIndex(playerPed, data.hash, item.metadata.tint) end
						if item.metadata.components then
							for i=1, #item.metadata.components do
								local components = Items[item.metadata.components[i]].client.component
								for v=1, #components do
									local component = components[v]
									if DoesWeaponTakeWeaponComponent(data.hash, component) then
										if not HasPedGotWeaponComponent(playerPed, data.hash, component) then
											GiveWeaponComponentToPed(playerPed, data.hash, component)
										end
									end
								end
							end
						end

						item.hash = data.hash
						item.ammo = data.ammoname
						item.melee = (not item.throwable and not data.ammoname) and 0
						item.timer = 0
						SetCurrentPedWeapon(playerPed, data.hash, true)
						SetPedCurrentWeaponVisible(playerPed, true, false, false, false)
						AddAmmoToPed(playerPed, data.hash, item.metadata.ammo or 100)
						Wait(0)
						RefillAmmoInstantly(playerPed)

						if data.name == 'WEAPON_PETROLCAN' or data.name == 'WEAPON_FIREEXTINGUISHER' then
							item.metadata.ammo = item.metadata.durability
							SetPedInfiniteAmmo(playerPed, true, data.hash)
						end

						TriggerEvent('ox_inventory:currentWeapon', item)
						Utils.ItemNotify({item = item.name, text = ox.locale('equipped')})
						Wait(sleep)
						ClearPedSecondaryTask(playerPed)
					end
				end)
			elseif currentWeapon then
				local playerPed = PlayerData.ped
				if item.name:find('ammo-') then
					local maxAmmo = GetMaxAmmoInClip(playerPed, currentWeapon.hash, true)
					local currentAmmo = GetAmmoInPedWeapon(playerPed, currentWeapon.hash)
					if currentAmmo ~= maxAmmo and currentAmmo < maxAmmo then
						TriggerEvent('ox_inventory:item', data, function(data)
							if data then
								if data.name == currentWeapon.ammo then
									local missingAmmo = 0
									local newAmmo = 0
									missingAmmo = maxAmmo - currentAmmo
									if missingAmmo > data.count then newAmmo = currentAmmo + data.count else newAmmo = maxAmmo end
									if newAmmo < 0 then newAmmo = 0 end
									SetPedAmmo(playerPed, currentWeapon.hash, newAmmo)
									MakePedReload(playerPed)
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
							if HasPedGotWeaponComponent(playerPed, currentWeapon.hash, component) then
								Utils.Notify({type = 'error', text = ox.locale('component_has', data.label)})
							else
								TriggerEvent('ox_inventory:item', data, function(data)
									if data then
										GiveWeaponComponentToPed(playerPed, currentWeapon.hash, component)
										table.insert(PlayerData.inventory[currentWeapon.slot].metadata.components, component)
										TriggerServerEvent('ox_inventory:updateWeapon', 'component', data.name)
									end
								end)
							end
							return
						end
					end
					Utils.Notify({type = 'error', text = ox.locale('component_invalid', data.label) })
				end
			else
				TriggerEvent('ox_inventory:item', data)
			end
		end
	end
end
exports('useSlot', UseSlot)

local function CanOpenTarget(ped)
	return IsPedFatallyInjured(ped)
	or IsEntityPlayingAnim(ped, 'dead', 'dead_a', 3)
	or IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_enter', 3)
	or IsEntityPlayingAnim(ped, 'random@mugging3', 'handsup_standing_base', 3)
end

local function OpenNearbyInventory()
	if CanOpenInventory() then
		local closestPlayer, coords = Utils.GetClosestPlayer()
		if closestPlayer.x < 2 and (PlayerData.job.name == 'police' or CanOpenTarget(closestPlayer.z)) then
			Utils.PlayAnim(2000, 'mp_common', 'givetake1_a', 1.0, 1.0, -1, 50, 0.0, 0, 0, 0)
			OpenInventory('player', GetPlayerServerId(closestPlayer.y))
		end
	end
end
exports('openNearbyInventory', OpenNearbyInventory)

local nearbyMarkers, closestMarker = {}, {}
local drops, playerCoords
local function Markers(tb, type, rgb, name)
	if tb then
		for k, v in pairs(tb) do
			if not v.jobs or v.jobs[PlayerData.job.name] then
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
	end
end

local table = import 'table'
local Shops = client.shops
local Inventory = client.inventory

function OnPlayerData(key, val)
	if key == 'job' then
		Shops()
		if ox.qtarget then
			Inventory.Stashes()
			Inventory.Evidence()
		end
		table.wipe(nearbyMarkers)
	elseif key == 'dead' and val then
		Utils.Disarm(currentWeapon, -1)
		TriggerEvent('ox_inventory:closeInventory')
		Wait(50)
	end
	SetWeaponsNoAutoswap(1)
	SetWeaponsNoAutoreload(1)
end

local function RegisterCommands()

	RegisterCommand('inv', function()
		if closestMarker[1] and closestMarker[3] ~= 'license' and closestMarker[3] ~= 'policeevidence' then
			OpenInventory(closestMarker[3], {id=closestMarker[2], type=closestMarker[4]})
		else OpenInventory() end
	end)
	RegisterKeyMapping('inv', ox.locale('open_player_inventory'), 'keyboard', ox.keys[1])
	TriggerEvent('chat:removeSuggestion', '/inv')

	local Vehicles = data 'vehicles'

	RegisterCommand('inv2', function()
		if not invOpen then
			if isBusy then return Utils.Notify({type = 'error', text = ox.locale('inventory_player_access'), duration = 2500})
			else
				if not CanOpenInventory() then return Utils.Notify({type = 'error', text = ox.locale('inventory_player_access'), duration = 2500}) end
				if StashTarget then
					OpenInventory('stash', StashTarget)
				elseif IsPedInAnyVehicle(PlayerData.ped, false) then
					local vehicle = GetVehiclePedIsIn(PlayerData.ped, false)
					if NetworkGetEntityIsNetworked(vehicle) then
						local plate = ox.playerslots and string.strtrim(GetVehicleNumberPlateText(vehicle)) or GetVehicleNumberPlateText(vehicle)
						OpenInventory('glovebox', {id='glove'..plate, class=GetVehicleClass(vehicle), model=GetEntityModel(vehicle)})
						while true do
							Wait(100)
							if not invOpen then break
							elseif not IsPedInAnyVehicle(PlayerData.ped, false) then
								TriggerEvent('ox_inventory:closeInventory')
								break
							end
						end
					end
				else
					local entity, type = Utils.Raycast()
					if not entity then return end
					local vehicle, position
					if not ox.qtarget then
						if type == 2 then vehicle, position = entity, GetEntityCoords(entity)
						elseif type == 3 and table.contains(Inventory.Dumpsters, GetEntityModel(entity)) then
							local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity)
							if not netId then
								SetEntityAsMissionEntity(entity)
								NetworkRegisterEntityAsNetworked(entity)
								netId = NetworkGetNetworkIdFromEntity(entity)
								NetworkUseHighPrecisionBlending(netId, false)
								SetNetworkIdExistsOnAllMachines(netId)
								SetNetworkIdCanMigrate(netId, true)
							end
							return OpenInventory('dumpster', 'dumpster'..netId)
						end
					elseif type == 2 then
						vehicle, position = entity, GetEntityCoords(entity)
					else return end
					local lastVehicle = nil
					local class = GetVehicleClass(vehicle)
					local vehHash = GetEntityModel(vehicle)
					if vehicle and Vehicles.trunk['models'][vehHash] or Vehicles.trunk[class] and #(playerCoords - position) < 6 and NetworkGetEntityIsNetworked(vehicle) then
						local locked = GetVehicleDoorLockStatus(vehicle)
						if locked == 0 or locked == 1 then
							local checkVehicle = Vehicles.Storage[vehHash]
							local open, vehBone
							if checkVehicle == 1 then open, vehBone = 4, GetEntityBoneIndexByName(vehicle, 'bonnet')
							elseif checkVehicle == nil then open, vehBone = 5, GetEntityBoneIndexByName(vehicle, 'boot') elseif checkVehicle == 2 then open, vehBone = 5, GetEntityBoneIndexByName(vehicle, 'boot') else --[[no vehicle nearby]] return end
							if vehBone == -1 then vehBone = GetEntityBoneIndexByName(vehicle, 'platelight') end
							position = GetWorldPositionOfEntityBone(vehicle, vehBone)
							local distance = #(playerCoords - position)
							local closeToVehicle = distance < 2 and (open == 5 and (checkVehicle == nil and true or 2) or open == 4)
							if closeToVehicle then
								local plate = ox.playerslots and string.strtrim(GetVehicleNumberPlateText(vehicle)) or GetVehicleNumberPlateText(vehicle)
								TaskTurnPedToFaceCoord(PlayerData.ped, position.x, position.y, position.z)
								lastVehicle = vehicle
								OpenInventory('trunk', {id='trunk'..plate, class=class, model=vehHash})
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
								Utils.PlayAnim(0, 'anim@heists@prison_heiststation@cop_reactions', 'cop_b_idle', 3.0, 3.0, -1, 49, 0.0, 0, 0, 0)
								currentInventory.entity = lastVehicle
								currentInventory.door = open
								while true do
									Wait(50)
									if closeToVehicle and invOpen then
										position = GetWorldPositionOfEntityBone(vehicle, vehBone)
										if #(GetEntityCoords(PlayerData.ped) - position) >= 2 or not DoesEntityExist(vehicle) then
											break
										else TaskTurnPedToFaceCoord(PlayerData.ped, position.x, position.y, position.z) end
									else break end
								end
								if lastVehicle then TriggerEvent('ox_inventory:closeInventory') end
							end
						else Utils.Notify({type = 'error', text = ox.locale('vehicle_locked'), duration = 2500}) end
					end
				end
			end
		end
	end)
	RegisterKeyMapping('inv2', ox.locale('open_secondary_inventory'), 'keyboard', ox.keys[2])
	TriggerEvent('chat:removeSuggestion', '/inv2')

	RegisterCommand('reload', function()
		if currentWeapon?.ammo then
			local ammo = Inventory.Search(1, currentWeapon.ammo)
			if ammo[1] then UseSlot(ammo[1].slot) end
		end
	end)
	RegisterKeyMapping('reload', ox.locale('reload_weapon'), 'keyboard', 'r')
	TriggerEvent('chat:removeSuggestion', '/reload')

	RegisterCommand('hotbar', function()
		SendNUIMessage({ action = 'toggleHotbar' })
	end)
	RegisterKeyMapping('hotbar', ox.locale('disable_hotbar'), 'keyboard', ox.keys[3])
	TriggerEvent('chat:removeSuggestion', '/hotbar')

	RegisterCommand('steal', function()
		OpenNearbyInventory()
	end)

	for i=1, 5 do
		local hotkey = ('hotkey%s'):format(i)
		RegisterCommand(hotkey, function() if not invOpen then UseSlot(i) end end)
		RegisterKeyMapping(hotkey, ox.locale('use_hotbar', i), 'keyboard', i)
		TriggerEvent('chat:removeSuggestion', '/'..hotkey)
	end

end

RegisterNetEvent('ox_inventory:closeInventory', function(options)
	if invOpen then invOpen = nil
		plyState:set('invOpen', false, false)
		SetNuiFocus(false, false)
		SetNuiFocusKeepInput(false)
		TriggerScreenblurFadeOut(0)
		CloseTrunk()
		SendNUIMessage({ action = 'closeInventory' })
		SetInterval[1] = 200
		Wait(200)
		if currentInventory then TriggerServerEvent('ox_inventory:closeInventory') end
		invOpen, currentInventory = false, nil
	end
end)

RegisterNetEvent('ox_inventory:updateInventory', function(items, weights, count, removed)
	local itemName = items[1].item.name
	if not items[1].item.label then items[1].item.name = nil end
	SendNUIMessage({ action = 'refreshSlots', data = items })
	if count then Utils.ItemNotify({text = ox.locale(removed and 'removed' or 'added', count), item = itemName}) end
	for i=1, #items do
		local i = items[i].item
		PlayerData.inventory[i.slot] = i.name and i or nil
	end
	ox.SetPlayerData('weight', weights.left)
end)

RegisterNetEvent('ox_inventory:inventoryReturned', function(data)
	Utils.Notify({text = ox.locale('items_returned'), duration = 2500})
	TriggerEvent('ox_inventory:closeInventory')
	PlayerData.inventory = data[1]
	ox.SetPlayerData('inventory', data[1])
	ox.SetPlayerData('weight', data[3])
end)

RegisterNetEvent('ox_inventory:inventoryConfiscated', function(message)
	if message then Utils.Notify({text = ox.locale('items_confiscated'), duration = 2500}) end
	TriggerEvent('ox_inventory:closeInventory')
	table.wipe(PlayerData.inventory)
	ox.SetPlayerData('weight', 0)
end)

RegisterNetEvent('ox_inventory:createDrop', function(data, owner, slot)
	drops[data[1]] = data[2]
	if owner == PlayerData.id and invOpen and #(GetEntityCoords(PlayerData.ped) - data[2]) <= 1 then
		if currentWeapon?.slot == slot then Utils.Disarm(currentWeapon, -1) end
		if not IsPedInAnyVehicle(PlayerData.ped, false) then
			OpenInventory('drop', data[1])
		end
	end
end)

RegisterNetEvent('ox_inventory:removeDrop', function(id)
	if closestMarker?[3] == id then table.wipe(closestMarker) end
	if drops then drops[id] = nil end
	nearbyMarkers['drop'..id] = nil
end)

local uiLoaded = false

RegisterNetEvent('ox_inventory:setPlayerInventory', function(currentDrops, inventory, weight, esxItem, player)
	PlayerData = player
	PlayerData.id = GetPlayerServerId(PlayerId())
	PlayerData.ped = PlayerPedId()
	ox.SetPlayerData('inventory', inventory)
	ox.SetPlayerData('weight', weight)
	invOpen = false
	currentWeapon = nil
	drops = currentDrops
	Utils.ClearWeapons()
	local ItemData = table.create(0, #Items)

	for _, v in pairs(Items) do
		v.usable = (v.client and next(v.client) or v.consume == 0 or esxItem[v.name] or v.name:find('WEAPON_') or v.name:find('ammo-') or v.name:find('at_')) and true or false
		ItemData[v.name] = {
			label = v.label,
			usable = v.usable,
			stack = v.stack,
			close = v.close,
			description = v.description
		}
	end

	local locales = {}
	for k, v in pairs(ox.locale()) do
		if k:find('ui_') then
			locales[k] = v
		end
	end

	while not uiLoaded do Wait(50) end

	SendNUIMessage({
		action = 'init',
		data = {
			sentry = ox.sentry,
			locale = locales,
			items = ItemData,
			leftInventory = {
				id = PlayerData.id,
				slots = ox.playerslots,
				items = PlayerData.inventory,
				maxWeight = ox.playerweight,
			}
		}
	})

	Shops()
	Inventory.Stashes()
	Inventory.Evidence()
	RegisterCommands()

	plyState:set('busy', false, false)
	PlayerData.loaded = true

	Utils.Notify({text = ox.locale('inventory_setup'), duration = 2500})
	local Licenses = data 'licenses'

	SetInterval(function()
		PlayerData.ped = PlayerPedId()
		if invOpen == false then
			playerCoords = GetEntityCoords(PlayerData.ped)
			table.wipe(closestMarker)

			Markers(drops, 'drop', vec3(150, 30, 30))
			if not ox.qtarget then
				if PlayerData.job.name == 'police' then Markers(Inventory.Evidence, 'policeevidence', vec(30, 30, 150)) end
				Markers(Inventory.Stashes, 'stash', vec3(30, 30, 150))
				for k, v in pairs(Shops) do
					if not v.jobs or (v.jobs[PlayerData.job.name] and PlayerData.job.grade >= v.jobs[PlayerData.job.name]) then
						Markers(v.locations, 'shop', vec3(30, 150, 30), k)
					end
				end
			end
			Markers(Licenses, 'license', vec(30, 150, 30))

			if IsPedInAnyVehicle(PlayerData.ped, false) then table.wipe(closestMarker) end
			SetPedCanSwitchWeapon(PlayerData.ped, false)
			SetPedEnableWeaponBlocking(PlayerData.ped, true)
		elseif invOpen == true then
			if not CanOpenInventory() then
				TriggerEvent('ox_inventory:closeInventory')
			else
				playerCoords = GetEntityCoords(PlayerData.ped)
				if currentInventory then
					if currentInventory.type == 'otherplayer' then
						local id = GetPlayerFromServerId(currentInventory.id)
						local ped = GetPlayerPed(id)
						local pedCoords = GetEntityCoords(ped)
						if not id or #(playerCoords - pedCoords) > 1.8 or not (PlayerData.job.name == 'police' or CanOpenTarget(ped)) then
							TriggerEvent('ox_inventory:closeInventory')
							Utils.Notify({type = 'error', text = ox.locale('inventory_lost_access'), duration = 2500})
						else
							TaskTurnPedToFaceCoord(PlayerData.ped, pedCoords.x, pedCoords.y, pedCoords.z, 50)
						end
					elseif currentInventory.coords and (#(playerCoords - currentInventory.coords) > 2 or CanOpenTarget(PlayerData.ped)) then
						TriggerEvent('ox_inventory:closeInventory')
						Utils.Notify({type = 'error', text = ox.locale('inventory_lost_access'), duration = 2500})
					end
				end
			end
		end

		if currentWeapon and GetSelectedPedWeapon(PlayerData.ped) ~= currentWeapon.hash then Utils.Disarm(currentWeapon, -1) end
		if ox.parachute and GetPedParachuteState(PlayerData.ped) ~= -1 then Utils.DeleteObject(ox.parachute) ox.parachute = false end
	end, 200)

	local EnableKeys = ox.enablekeys
	SetInterval(function()
		DisablePlayerVehicleRewards(PlayerData.id)

		if invOpen then
			DisableAllControlActions(0)
			HideHudAndRadarThisFrame()

			for i=1, #EnableKeys do
				EnableControlAction(0, EnableKeys[i], true)
			end

			if currentInventory.type == 'newdrop' then
				EnableControlAction(0, 30, true)
				EnableControlAction(0, 31, true)
			end
		else
			DisableControlActions()
			if isBusy then DisablePlayerFiring(PlayerData.id, true) end

			for _, v in pairs(nearbyMarkers) do
				DrawMarker(2, v[1].x, v[1].y, v[1].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, v[2].x, v[2].y, v[2].z, 222, false, false, false, true, false, false, false)
			end

			if closestMarker and IsControlJustReleased(0, 38) then
				if closestMarker[3] == 'license' then
					ServerCallback.Async(ox.resource, 'buyLicense', 1000, function(success, message)
						if success == false then
							Utils.Notify({type = 'error', text = ox.locale(message), duration = 2500})
						else
							Utils.Notify({text = ox.locale(success), duration = 2500})
						end
					end, closestMarker[2])
				elseif closestMarker[3] == 'shop' then OpenInventory(closestMarker[3], {id=closestMarker[2], type=closestMarker[4]})
				elseif closestMarker[3] == 'policeevidence' then OpenInventory(closestMarker[3]) end
			end
			if currentWeapon then
				DisableControlAction(0, 140, true)
				if not isBusy and currentWeapon.timer ~= 0 and currentWeapon.timer < GetGameTimer() then
					if currentWeapon.metadata.ammo then
						TriggerServerEvent('ox_inventory:updateWeapon', 'ammo', currentWeapon.metadata.ammo)
					elseif currentWeapon.metadata.durability then
						TriggerServerEvent('ox_inventory:updateWeapon', 'melee', currentWeapon.melee)
						currentWeapon.melee = 0
					end
					currentWeapon.timer = 0
				elseif currentWeapon.metadata.ammo then
					local playerPed = PlayerData.ped
					if IsPedShooting(playerPed) then
						local currentAmmo
						if currentWeapon.name == 'WEAPON_PETROLCAN' or currentWeapon.name == 'WEAPON_FIREEXTINGUISHER' then
							currentAmmo = currentWeapon.metadata.ammo - 0.05
							if currentAmmo <= 0 then
								SetPedInfiniteAmmo(playerPed, false, currentWeapon.hash)
							end
						else currentAmmo = GetAmmoInPedWeapon(playerPed, currentWeapon.hash) end
						currentWeapon.metadata.ammo = (currentWeapon.metadata.ammo < currentAmmo) and 0 or currentAmmo
						if currentAmmo <= 0 then
							ClearPedTasks(playerPed)
							SetCurrentPedWeapon(playerPed, currentWeapon.hash, true)
							SetPedCurrentWeaponVisible(playerPed, true, false, false, false)
							if currentWeapon?.ammo and ox.autoreload and not Interface.ProgressActive and not IsPedRagdoll(playerPed) and not IsPedFalling(playerPed) then
								local ammo = Inventory.Search(1, currentWeapon.ammo)
								if ammo[1] then
									TriggerServerEvent('ox_inventory:updateWeapon', 'ammo', currentWeapon.metadata.ammo)
									currentWeapon.timer = 0
									UseSlot(ammo[1].slot)
								end
							end
						end
						currentWeapon.timer = GetGameTimer() + 400
					end
				elseif IsControlJustReleased(0, 24) then
					if currentWeapon.throwable then
						local playerPed = PlayerData.ped
						plyState.isBusy = true
						SetTimeout(700, function()
							ClearPedSecondaryTask(playerPed)
							RemoveWeaponFromPed(playerPed, currentWeapon.hash)
							TriggerServerEvent('ox_inventory:updateWeapon', 'throw')
							TriggerEvent('ox_inventory:currentWeapon')
							plyState.isBusy = false
						end)
					elseif IsPedPerformingMeleeAction(PlayerData.ped) then
						currentWeapon.melee += 1
						currentWeapon.timer = GetGameTimer() + 400
					end
				end
			end
		end
	end)

	collectgarbage('collect')
end)

AddEventHandler('onResourceStop', function(resourceName)
	if ox.resource == resourceName then
		if ox.parachute then Utils.DeleteObject(ox.parachute) end
		if invOpen then
			SetNuiFocus(false, false)
			SetNuiFocusKeepInput(false)
			TriggerScreenblurFadeOut(0)
		end
	end
end)

AddEventHandler('ox_inventory:item', function(data, cb)
	if not isBusy and not Interface.ProgressActive and not IsPedRagdoll(PlayerData.ped) and not IsPedFalling(PlayerData.ped) then
		if currentWeapon and currentWeapon?.timer > 100 then return end
		isBusy = true
		if invOpen and data.close then TriggerEvent('ox_inventory:closeInventory') end
		local result = ServerCallback.Await(ox.resource, 'useItem', 200, data.name, data.slot, PlayerData.inventory[data.slot].metadata)
		if cb == nil then
			isBusy = false
			return
		end
		if result and isBusy then
			plyState:set('busy', true, false)
			local used
			if data.client and data.client.usetime then
				data = data.client
				Interface.Progress({
					duration = data.usetime,
					label = data.label or ox.locale('using', result.label),
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
				if result.consume and result.consume ~= 0 then TriggerServerEvent('ox_inventory:removeItem', result.name, result.consume, result.metadata, result.slot, true) end
				if data.status then
					for k, v in pairs(data.status) do
						if v > 0 then TriggerEvent('esx_status:add', k, v) else TriggerEvent('esx_status:remove', k, -v) end
					end
				end
				if currentWeapon?.slot == result.slot then Utils.Disarm(currentWeapon) else cb(result) end
				Wait(200)
				plyState:set('busy', false, false)
				return
			end
		end
		plyState:set('busy', false, false)
	end
	cb(false)
end)

RegisterNetEvent('esx:onPlayerLogout', function()
	if ox.parachute then Utils.DeleteObject(ox.parachute) ox.parachute = false end
	TriggerEvent('ox_inventory:closeInventory')
	PlayerData.loaded = false
	ClearInterval(1)
	ClearInterval(2)
	Utils.Disarm(currentWeapon, -1)
end)

RegisterNetEvent('ox_inventory:viewInventory', function(data)
	if data and invOpen == false then
		data.type = 'admin'
		invOpen = true
		currentInventory = data
		SendNUIMessage({
			action = 'setupInventory',
			data = {
				rightInventory = currentInventory,
			}
		})
		SetNuiFocus(true, true)
	end
end)

RegisterNUICallback('uiLoaded', function(data, cb)
	uiLoaded = true
	cb(1)
end)

RegisterNUICallback('removeComponent', function(data, cb)
	cb(1)
	if not currentWeapon then return Utils.Notify({type = 'error', text = ox.locale('weapon_hand_required')}) end
	if data.slot ~= currentWeapon.slot then return Utils.Notify({type = 'error', text = ox.locale('weapon_hand_wrong')}) end
	local itemSlot = PlayerData.inventory[currentWeapon.slot]
	for _, component in pairs(Items[data.component].client.component) do
		if HasPedGotWeaponComponent(PlayerData.ped, currentWeapon.hash, component) then
			RemoveWeaponComponentFromPed(PlayerData.ped, currentWeapon.hash, component)
			for k, v in pairs(itemSlot.metadata.components) do
				if v == data.component then
					table.remove(itemSlot.metadata.components, k)
					TriggerServerEvent('ox_inventory:updateWeapon', 'component', k)
					break
				end
			end
		end
	end
end)

RegisterNUICallback('useItem', function(slot, cb)
	UseSlot(slot)
	cb(1)
end)

RegisterNUICallback('giveItem', function(data, cb)
	local vehicle = GetVehiclePedIsIn(PlayerData.ped, false)
	if vehicle ~= 0 then
		local passenger = GetVehicleMaxNumberOfPassengers(vehicle) - 1
		if passenger >= 0 then
			local playerSeat
			for i = -1, passenger do
				if i == -1 then passenger = {} end
				if not IsVehicleSeatFree(vehicle, i) then
					local entity = GetPedInVehicleSeat(vehicle, i)
					if entity == PlayerData.ped then
						playerSeat = i
					else
						passenger[i] = entity
					end
				end
			end
			--todo: make this less depressing to look at
			--ref: https://docs.fivem.net/natives/?_0x22AC59A870E6A669
			if playerSeat == -1 and passenger[0] then
				passenger = GetPlayerServerId(NetworkGetPlayerIndexFromPed(passenger[0]))
			elseif playerSeat == 0 and passenger[-1] then
				passenger = GetPlayerServerId(NetworkGetPlayerIndexFromPed(passenger[-1]))
			elseif playerSeat == 2 and passenger[3] then
				passenger = GetPlayerServerId(NetworkGetPlayerIndexFromPed(passenger[3]))
			elseif playerSeat == 3 and passenger[2] then
				passenger = GetPlayerServerId(NetworkGetPlayerIndexFromPed(passenger[2]))
			else return end
			if passenger then
				TriggerServerEvent('ox_inventory:giveItem', data.slot, passenger, data.count)
				if data.slot == currentWeapon?.slot then Utils.Disarm(currentWeapon, -1) end
			end
		end
	else
		local target = Utils.Raycast()
		if target and IsPedAPlayer(target) and #(GetEntityCoords(PlayerData.ped, true) - GetEntityCoords(target, true)) < 2 then
			target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(target))
			Utils.PlayAnim(2000, 'mp_common', 'givetake1_a', 1.0, 1.0, -1, 50, 0.0, 0, 0, 0)
			TriggerServerEvent('ox_inventory:giveItem', data.slot, target, data.count)
			if data.slot == currentWeapon?.slot then Utils.Disarm(currentWeapon, -1) end
		end
	end
	cb(1)
end)

RegisterNUICallback('exit', function(data, cb)
	TriggerEvent('ox_inventory:closeInventory')
	cb(1)
end)

RegisterNUICallback('swapItems', function(data, cb)
	local response, data, weapon = ServerCallback.Await(ox.resource, 'swapItems', false, data)
	if data then
		for k, v in pairs(data.items) do
			PlayerData.inventory[k] = v and v or nil
		end
		ox.SetPlayerData('inventory', PlayerData.inventory)
		if data.weight then ox.SetPlayerData('weight', data.weight) end
	end
	if weapon and currentWeapon then
		currentWeapon.slot = weapon
		TriggerEvent('ox_inventory:currentWeapon', currentWeapon)
	end
	cb(response)
end)

RegisterNUICallback('buyItem', function(data, cb)
	local response, data, message = ServerCallback.Await(ox.resource, 'buyItem', 100, data)
	if data then
		PlayerData.inventory[data[1]] = data[2]
		ox.SetPlayerData('inventory', PlayerData.inventory)
		ox.SetPlayerData('weight', data[3])
		SendNUIMessage({ action = 'refreshSlots', data = {item = data[2]} })
	end
	if message then Utils.Notify(message) end
	cb(response)
end)

if ox.esx and PlayerData.loaded then TriggerServerEvent('ox_inventory:requestPlayerInventory') end
