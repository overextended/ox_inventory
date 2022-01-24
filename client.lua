local DisableControlActions = import 'controls'

local Items = client.items
local Utils = client.utils
local currentWeapon

RegisterNetEvent('ox_inventory:disarm', function(newSlot)
	currentWeapon = Utils.Disarm(currentWeapon, newSlot)
end)

RegisterNetEvent('ox_inventory:clearWeapons', function()
	Utils.ClearWeapons(currentWeapon)
end)

local StashTarget
exports('setStashTarget', function(id, owner)
	StashTarget = id and {id=id, owner=owner}
end)

local invBusy = true
local invOpen = false

local function CanOpenInventory()
	return PlayerData.loaded
	and not invBusy
	and not PlayerData.dead
	and not GetPedConfigFlag(PlayerData.ped, 120, true)
	and (currentWeapon == nil or currentWeapon.timer == 0)
	and not IsPauseMenuActive()
	and not IsPedFatallyInjured(PlayerData.ped)
	and invOpen ~= nil
end

local defaultInventory = {
	type = 'newdrop',
	slots = shared.playerslots,
	weight = 0,
	maxWeight = shared.playerweight,
	items = {}
}
local currentInventory = defaultInventory

local function CloseTrunk()
	if currentInventory?.type == 'trunk' then
		local coords = GetEntityCoords(PlayerData.ped, true)
		Utils.PlayAnimAdvanced(900, 'anim@heists@fleeca_bank@scope_out@return_case', 'trevor_action', coords.x, coords.y, coords.z, 0.0, 0.0, GetEntityHeading(PlayerData.ped), 2.0, 2.0, 1000, 49, 0.25)
		CreateThread(function()
			local entity = currentInventory.entity
			local door = currentInventory.door
			Wait(900)
			SetVehicleDoorShut(entity, door, false)
		end)
	end
end

local ServerCallback = import 'callbacks'
local Interface = client.interface
local plyState = LocalPlayer.state
local tick
local interval

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
			left, right = ServerCallback.Await(shared.resource, 'openShop', 200, data)
		elseif invOpen ~= nil then
			if inv == 'policeevidence' then
				local input = Interface.Keyboard(shared.locale('police_evidence'), {shared.locale('locker_number')})

				if input then
					input = tonumber(input[1])
				else
					return Utils.Notify({text = shared.locale('locker_no_value'), type = 'error'})
				end

				if type(input) ~= 'number' then
					return Utils.Notify({text = shared.locale('locker_must_number'), type = 'error'})
				else
					data = input
				end
			end

			left, right = ServerCallback.Await(shared.resource, 'openInventory', false, inv, data)
		end

		if left then
			if inv ~= 'trunk' and not IsPedInAnyVehicle(PlayerData.ped, false) then
				Utils.PlayAnim(1000, 'pickup_object', 'putdown_low', 5.0, 1.5, -1, 48, 0.0, 0, 0, 0)
			end
			plyState.invOpen = true
			SetInterval(interval, 100)
			SetNuiFocus(true, true)
			SetNuiFocusKeepInput(true)
			if client.screenblur then TriggerScreenblurFadeIn(0) end
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

			if not currentInventory.coords and not inv == 'container' then
				currentInventory.coords = GetEntityCoords(PlayerData.ped)
			end

			-- Stash exists (useful for custom stashes)
			return true
		else
			-- Stash does not exist
			if left == false then return false end
			if invOpen == false then Utils.Notify({type = 'error', text = shared.locale('inventory_right_access'), duration = 2500}) end
			if invOpen then TriggerEvent('ox_inventory:closeInventory') end
		end
	elseif not invBusy then Utils.Notify({type = 'error', text = shared.locale('inventory_player_access'), duration = 2500}) end
end
RegisterNetEvent('ox_inventory:openInventory', OpenInventory)
exports('openInventory', OpenInventory)

local function useItem(data, cb)
	if invOpen and data.close then TriggerEvent('ox_inventory:closeInventory') end
	if not invBusy and not Interface.ProgressActive and not IsPedRagdoll(PlayerData.ped) and not IsPedFalling(PlayerData.ped) then
		if currentWeapon and currentWeapon?.timer > 100 then return end

		invBusy = true
		local result = ServerCallback.Await(shared.resource, 'useItem', 200, data.name, data.slot, PlayerData.inventory[data.slot].metadata)

		if not result then
			Wait(500)
			invBusy = false
			return
		end

		local p
		if result and invBusy then
			plyState.invBusy = true
			if data.client then data = data.client end

			if data.usetime then
				p = promise.new()
				Interface.Progress({
					duration = data.usetime,
					label = data.label or shared.locale('using', result.label),
					useWhileDead = data.useWhileDead or false,
					canCancel = data.cancel or false,
					disable = data.disable,
					anim = data.anim or data.scenario,
					prop = data.prop,
					propTwo = data.propTwo
				}, function(cancel)
					p:resolve(cancel)
				end)
			end

			if p then Citizen.Await(p) end

			if not p or not p.value then
				if result.consume and result.consume ~= 0 then
					TriggerServerEvent('ox_inventory:removeItem', result.name, result.consume, result.metadata, result.slot, true)
				end

				if data.status then
					for k, v in pairs(data.status) do
						if v > 0 then TriggerEvent('esx_status:add', k, v) else TriggerEvent('esx_status:remove', k, -v) end
					end
				end

				if data.notification then
					Utils.Notify({text = data.notification})
				end

				if cb then cb(result) end
				Wait(500)
				plyState.invBusy = false
				return
			end
		end
	end
	if cb then cb(false) end
	Wait(200)
	plyState.invBusy = false
end
AddEventHandler('ox_inventory:item', useItem)
exports('useItem', useItem)

local function useSlot(slot)
	if PlayerData.loaded and not invBusy and not Interface.ProgressActive then
		local item = PlayerData.inventory[slot]
		if not item then return end
		local data = item and Items[item.name]
		if not data or not data.usable then return end
		if data.name:find('at_') and not currentWeapon then Utils.Notify({type = 'error', text = shared.locale('weapon_hand_required')}) return end
		data.slot = slot

		if item.metadata.container then
			return OpenInventory('container', item.slot)
		elseif data.client then
			if invOpen and data.close then TriggerEvent('ox_inventory:closeInventory') end

			if data.client.export then
				if type(data.client.export) ~= 'function' then
					local resource, fn = string.strsplit('.', data.client.export)
					data.client.export = exports[resource][fn]
				end

				return data.client.export(0, data, {name = item.name, slot = item.slot, metadata = item.metadata})
			elseif data.client.event then -- deprecated, to be removed
				return print(('unable to trigger event for %s, data.client.event has been removed. utilise exports instead.'):format(item.name))
			end
		end

		if data.effect then
			data:effect({name = item.name, slot = item.slot, metadata = item.metadata})
		elseif item.name:find('WEAPON_') then
			useItem(data, function(result)
				if result then
					if currentWeapon?.slot == result.slot then
						currentWeapon = Utils.Disarm(currentWeapon)
						return
					end

					local playerPed = PlayerData.ped
					ClearPedSecondaryTask(playerPed)
					if data.throwable then item.throwable = true end
					if currentWeapon then currentWeapon = Utils.Disarm(currentWeapon) end
					local sleep = (client.isPolice() and (GetWeapontypeGroup(data.hash) == 416676503 or GetWeapontypeGroup(data.hash) == 690389602)) and 400 or 1200
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

					currentWeapon = item
					TriggerEvent('ox_inventory:currentWeapon', item)
					Utils.ItemNotify({item.label, item.name, shared.locale('equipped')})
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
					useItem(data, function(data)

						if data then
							if data.name == currentWeapon.ammo then
								DisableControlActions:Add(22)
								local missingAmmo = 0
								local newAmmo = 0
								missingAmmo = maxAmmo - currentAmmo
								if missingAmmo > data.count then newAmmo = currentAmmo + data.count else newAmmo = maxAmmo end
								if newAmmo < 0 then newAmmo = 0 end
								SetPedAmmo(playerPed, currentWeapon.hash, newAmmo)
								MakePedReload(playerPed)
								currentWeapon.metadata.ammo = newAmmo
								TriggerServerEvent('ox_inventory:updateWeapon', 'load', currentWeapon.metadata.ammo)
								Wait(1500)
								DisableControlActions:Remove(22)
							end
						end
					end)
				end
			elseif item.name:find('at_') then
				local components = data.client.component
				local componentType = data.type
				local weaponComponents = PlayerData.inventory[currentWeapon.slot].metadata.components
				-- Checks if the weapon already has the same component type attached
				for componentIndex = 1, #weaponComponents do
					if componentType == Items[weaponComponents[componentIndex]].type then
						-- todo: Update locale?
						return Utils.Notify({type = 'error', text = shared.locale('component_has', data.label)})
					end
				end
				for i=1, #components do
					local component = components[i]

					if DoesWeaponTakeWeaponComponent(currentWeapon.hash, component) then
						if HasPedGotWeaponComponent(playerPed, currentWeapon.hash, component) then
							Utils.Notify({type = 'error', text = shared.locale('component_has', data.label)})
						else
							useItem(data, function(data)
								if data then
									GiveWeaponComponentToPed(playerPed, currentWeapon.hash, component)
									table.insert(PlayerData.inventory[currentWeapon.slot].metadata.components, data.name)
								end
							end)
						end
						return
					end
				end
				Utils.Notify({type = 'error', text = shared.locale('component_invalid', data.label) })
			end
		else
			useItem(data)
		end
	end
end
exports('useSlot', useSlot)

local function CanOpenTarget(ped)
	return IsPedFatallyInjured(ped)
	or IsEntityPlayingAnim(ped, 'dead', 'dead_a', 3)
	or GetPedConfigFlag(ped, 120, true)
	or IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_enter', 3)
	or IsEntityPlayingAnim(ped, 'random@mugging3', 'handsup_standing_base', 3)
end

local function OpenNearbyInventory()
	if CanOpenInventory() then
		local closestPlayer = Utils.GetClosestPlayer()
		if closestPlayer.x < 2 and (client.isPolice() or CanOpenTarget(closestPlayer.z)) then
			Utils.PlayAnim(2000, 'mp_common', 'givetake1_a', 1.0, 1.0, -1, 50, 0.0, 0, 0, 0)
			OpenInventory('player', GetPlayerServerId(closestPlayer.y))
		end
	end
end
exports('openNearbyInventory', OpenNearbyInventory)

local currentInstance

local nearbyMarkers, closestMarker = {}, {}
local drops, playerCoords
local function Markers(tb, type, rgb, name)
	if tb then
		for k, v in pairs(tb) do
			if not v.instance or v.instance == currentInstance then
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
					elseif not marker and distance < 8 then
						nearbyMarkers[id] = mat(vec3(coords), vec3(rgb))
					elseif marker and distance > 8 then
						nearbyMarkers[id] = nil
					end
				end
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
		if shared.qtarget then
			Inventory.Stashes()
			Inventory.Evidence()
		end
		table.wipe(nearbyMarkers)
	elseif key == 'dead' and val then
		currentWeapon = Utils.Disarm(currentWeapon)
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
	RegisterKeyMapping('inv', shared.locale('open_player_inventory'), 'keyboard', client.keys[1])
	TriggerEvent('chat:removeSuggestion', '/inv')

	local Vehicles = data 'vehicles'

	RegisterCommand('inv2', function()
		if not invOpen then
			if invBusy then return Utils.Notify({type = 'error', text = shared.locale('inventory_player_access'), duration = 2500})
			else
				if not CanOpenInventory() then return Utils.Notify({type = 'error', text = shared.locale('inventory_player_access'), duration = 2500}) end
				if StashTarget then
					OpenInventory('stash', StashTarget)
				elseif IsPedInAnyVehicle(PlayerData.ped, false) then
					local vehicle = GetVehiclePedIsIn(PlayerData.ped, false)

					if NetworkGetEntityIsNetworked(vehicle) then
						local checkVehicle = Vehicles.Storage[GetEntityModel(vehicle)]
						if checkVehicle == 0 or checkVehicle == 2 then -- No storage or no glovebox
							return
						end

						local plate = client.trimplate and string.strtrim(GetVehicleNumberPlateText(vehicle)) or GetVehicleNumberPlateText(vehicle)
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
					if not shared.qtarget then
						if type == 2 then vehicle, position = entity, GetEntityCoords(entity)
						elseif type == 3 and table.contains(Inventory.Dumpsters, GetEntityModel(entity)) then
							local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity)

							if not netId then
								NetworkRegisterEntityAsNetworked(entity)
								SetEntityAsMissionEntity(entity)
								netId = NetworkGetNetworkIdFromEntity(entity)
								NetworkUseHighPrecisionBlending(netId, false)
								SetNetworkIdExistsOnAllMachines(netId, true)
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

							if checkVehicle == nil then -- No data, normal trunk
								open, vehBone = 5, GetEntityBoneIndexByName(vehicle, 'boot')
							elseif checkVehicle == 3 then -- Trunk in hood
								open, vehBone = 4, GetEntityBoneIndexByName(vehicle, 'bonnet')
							else -- No storage or no trunk
								return
							end

							if vehBone == -1 then vehBone = GetEntityBoneIndexByName(vehicle, Vehicles.trunk.boneIndex[vehHash] or 'platelight') end

							position = GetWorldPositionOfEntityBone(vehicle, vehBone)
							local distance = #(playerCoords - position)
							local closeToVehicle = distance < 2 and (open == 5 and (checkVehicle == nil and true or 2) or open == 4)

							if closeToVehicle then
								local plate = client.trimplate and string.strtrim(GetVehicleNumberPlateText(vehicle)) or GetVehicleNumberPlateText(vehicle)
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
						else Utils.Notify({type = 'error', text = shared.locale('vehicle_locked'), duration = 2500}) end
					end
				end
			end
		else return TriggerEvent('ox_inventory:closeInventory')
		end
	end)
	RegisterKeyMapping('inv2', shared.locale('open_secondary_inventory'), 'keyboard', client.keys[2])
	TriggerEvent('chat:removeSuggestion', '/inv2')

	RegisterCommand('reload', function()
		if currentWeapon?.ammo then
			local ammo = Inventory.Search(1, currentWeapon.ammo)
			if ammo[1] then useSlot(ammo[1].slot) end
		end
	end)
	RegisterKeyMapping('reload', shared.locale('reload_weapon'), 'keyboard', 'r')
	TriggerEvent('chat:removeSuggestion', '/reload')

	RegisterCommand('hotbar', function()
		if not IsPauseMenuActive() then
    		SendNUIMessage({ action = 'toggleHotbar' })
		end
	end)
	RegisterKeyMapping('hotbar', shared.locale('disable_hotbar'), 'keyboard', client.keys[3])
	TriggerEvent('chat:removeSuggestion', '/hotbar')

	RegisterCommand('steal', function()
		OpenNearbyInventory()
	end)

	for i=1, 5 do
		local hotkey = ('hotkey%s'):format(i)
		RegisterCommand(hotkey, function() if not invOpen then useSlot(i) end end)
		RegisterKeyMapping(hotkey, shared.locale('use_hotbar', i), 'keyboard', i)
		TriggerEvent('chat:removeSuggestion', '/'..hotkey)
	end

end

RegisterNetEvent('ox_inventory:closeInventory', function(server)
	if invOpen then
		invOpen = nil
		SetNuiFocus(false, false)
		SetNuiFocusKeepInput(false)
		TriggerScreenblurFadeOut(0)
		CloseTrunk()
		SendNUIMessage({ action = 'closeInventory' })
		SetInterval(interval, 200)
		Wait(200)

		if not server and currentInventory then
			TriggerServerEvent('ox_inventory:closeInventory')
		end

		currentInventory = false
		plyState.invOpen = false
		defaultInventory.coords = nil
	end
end)

local function updateInventory(items, weight)
	local changes = {}
	local itemCount = {}
	-- swapslots
	if type(weight) == 'number' then
		for slot, v in pairs(items) do
			local item = PlayerData.inventory[slot]

			if item then
				itemCount[item.name] = (itemCount[item.name] or 0) - item.count
			end

			if v then
				itemCount[v.name] = (itemCount[v.name] or 0) + v.count
			end

			PlayerData.inventory[slot] = v and v or nil
			changes[slot] = v
		end
		client.setPlayerData('weight', weight)
	else
		for i=1, #items do
			local v = items[i].item
			local item = PlayerData.inventory[v.slot]

			if item?.name then
				itemCount[item.name] = (itemCount[item.name] or 0) - item.count
			end

			if v.count then
				itemCount[v.name] = (itemCount[v.name] or 0) + v.count
			end

			changes[v.slot] = v.count and v or false
			if not v.count then v.name = nil end
			PlayerData.inventory[v.slot] = v.name and v or nil
		end
		client.setPlayerData('weight', weight.left)
		SendNUIMessage({ action = 'refreshSlots', data = items })
	end

	for item, count in pairs(itemCount) do
		local data = Items[item]

		if count < 0 then
			data.count += count
			if data.client?.remove then
				data.client.remove(data.count)
			end
		elseif count > 0 then
			data.count += count
			if data.client?.add then
				data.client.add(data.count)
			end
		end
	end

	client.setPlayerData('inventory', PlayerData.inventory)
	TriggerEvent('ox_inventory:updateInventory', changes)
end

-- AddEventHandler('ox_inventory:updateInventory', function(inventory)
-- 	for k, v in pairs(inventory) do
-- 		if type(v) == 'table' then
-- 			print(k, json.encode(v))
-- 		else
-- 			print(k, false)
-- 		end
-- 	end
-- 	print()
-- end)

RegisterNetEvent('ox_inventory:updateSlots', function(items, weights, count, removed)
	if count then
		local item = items[1].item
		Utils.ItemNotify({item.label, item.name, shared.locale(removed and 'removed' or 'added', count)})
	end

	updateInventory(items, weights)
end)

RegisterNetEvent('ox_inventory:inventoryReturned', function(data)
	Utils.Notify({text = shared.locale('items_returned'), duration = 2500})
	if currentWeapon then currentWeapon = Utils.Disarm(currentWeapon) end
	TriggerEvent('ox_inventory:closeInventory')
	PlayerData.inventory = data[1]
	client.setPlayerData('inventory', data[1])
	client.setPlayerData('weight', data[3])
end)

RegisterNetEvent('ox_inventory:inventoryConfiscated', function(message)
	if message then Utils.Notify({text = shared.locale('items_confiscated'), duration = 2500}) end
	if currentWeapon then currentWeapon = Utils.Disarm(currentWeapon) end
	TriggerEvent('ox_inventory:closeInventory')
	table.wipe(PlayerData.inventory)
	client.setPlayerData('weight', 0)
end)

RegisterNetEvent('ox_inventory:createDrop', function(drop, data, owner, slot)
	if drops then
		drops[drop] = data
	end

	if owner == PlayerData.id and invOpen and #(GetEntityCoords(PlayerData.ped) - data.coords) <= 1 then
		if currentWeapon?.slot == slot then currentWeapon = Utils.Disarm(currentWeapon) end

		if not IsPedInAnyVehicle(PlayerData.ped, false) then
			OpenInventory('drop', drop)
		else
			SendNUIMessage({
				action = 'setupInventory',
				data = {
					rightInventory = currentInventory,
					job = {
						grade = PlayerData.job.grade,
						grade_label = PlayerData.job.grade_label,
						name = PlayerData.job.name
					}
				}
			})
		end
	end
end)

RegisterNetEvent('ox_inventory:removeDrop', function(id)
	if closestMarker?[3] == id then table.wipe(closestMarker) end
	if drops then drops[id] = nil end
	nearbyMarkers['drop'..id] = nil
end)

local uiLoaded = false

local function setStateBagHandler(id)
	AddStateBagChangeHandler(nil, 'player:'..id, function(bagName, key, value, _, _)
		if key == 'invOpen' then
			invOpen = value
		elseif key == 'invBusy' then
			invBusy = value
			if value then
				DisableControlActions:Add(23, 25, 36, 263)
			else
				DisableControlActions:Remove(23, 25, 36, 263)
			end
		end
	end)
	setStateBagHandler = nil
end

RegisterNetEvent('ox_inventory:setPlayerInventory', function(currentDrops, inventory, weight, esxItem, player)
	PlayerData = player
	PlayerData.id = GetPlayerServerId(PlayerId())
	PlayerData.ped = PlayerPedId()

	if setStateBagHandler then setStateBagHandler(PlayerData.id) end

	for _, data in pairs(inventory) do
		Items[data.name].count += data.count
	end

	if Items['phone']?.count < 1 and GetResourceState('npwd') == 'started' then
		exports.npwd:setPhoneDisabled(true)
	end

	client.setPlayerData('inventory', inventory)
	client.setPlayerData('weight', weight)
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
	for k, v in pairs(shared.locale()) do
		if k:find('ui_') then
			locales[k] = v
		end
	end

	while not uiLoaded do Wait(50) end

	SendNUIMessage({
		action = 'init',
		data = {
			locale = locales,
			items = ItemData,
			leftInventory = {
				id = PlayerData.id,
				slots = shared.playerslots,
				items = PlayerData.inventory,
				maxWeight = shared.playerweight,
			}
		}
	})

	Shops()
	Inventory.Stashes()
	Inventory.Evidence()
	RegisterCommands()

	plyState:set('invBusy', false, false)
	plyState:set('invOpen', false, false)
	PlayerData.loaded = true
	TriggerEvent('ox_inventory:updateInventory', PlayerData.inventory)

	Utils.Notify({text = shared.locale('inventory_setup'), duration = 2500})
	local Licenses = data 'licenses'

	interval = SetInterval(function()
		PlayerData.ped = PlayerPedId()

		if invOpen == false then
			playerCoords = GetEntityCoords(PlayerData.ped)
			table.wipe(closestMarker)


			Markers(drops, 'drop', vec3(150, 30, 30))

			if not shared.qtarget then
				if client.isPolice() then Markers(Inventory.Evidence, 'policeevidence', vec(30, 30, 150)) end
				Markers(Inventory.Stashes, 'stash', vec3(30, 30, 150))
				for k, v in pairs(Shops) do
					if not v.jobs or (v.jobs[PlayerData.job.name] and PlayerData.job.grade >= v.jobs[PlayerData.job.name]) then
						Markers(v.locations, 'shop', vec3(30, 150, 30), k)
					end
				end
			end

			Markers(Licenses, 'license', vec(30, 150, 30))
			SetPedCanSwitchWeapon(PlayerData.ped, false)
			SetPedEnableWeaponBlocking(PlayerData.ped, true)

			if IsPedInAnyVehicle(PlayerData.ped, false) then table.wipe(closestMarker) end
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

						if not id or #(playerCoords - pedCoords) > 1.8 or not (client.isPolice() or CanOpenTarget(ped)) then
							TriggerEvent('ox_inventory:closeInventory')
							Utils.Notify({type = 'error', text = shared.locale('inventory_lost_access'), duration = 2500})
						else
							TaskTurnPedToFaceCoord(PlayerData.ped, pedCoords.x, pedCoords.y, pedCoords.z, 50)
						end

					elseif currentInventory.coords and (#(playerCoords - currentInventory.coords) > 2 or CanOpenTarget(PlayerData.ped)) then
						TriggerEvent('ox_inventory:closeInventory')
						Utils.Notify({type = 'error', text = shared.locale('inventory_lost_access'), duration = 2500})
					end
				end
			end
		end

		if currentWeapon and GetSelectedPedWeapon(PlayerData.ped) ~= currentWeapon.hash then currentWeapon = Utils.Disarm(currentWeapon) end
		if client.parachute and GetPedParachuteState(PlayerData.ped) ~= -1 then
			Utils.DeleteObject(client.parachute)
			client.parachute = false
		end
	end, 200)

	local EnableKeys = client.enablekeys
	tick = SetInterval(function()
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
			if invBusy then DisablePlayerFiring(PlayerData.id, true) end

			for _, v in pairs(nearbyMarkers) do
				local coords, rgb = v[1], v[2]
				DrawMarker(2, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, rgb.x, rgb.y, rgb.z, 222, false, false, false, true, false, false, false)
			end

			if closestMarker and IsControlJustReleased(0, 38) then
				if closestMarker[3] == 'license' then
					ServerCallback.Async(shared.resource, 'buyLicense', 1000, function(success, message)
						if success == false then
							Utils.Notify({type = 'error', text = shared.locale(message), duration = 2500})
						else
							Utils.Notify({text = shared.locale(message), duration = 2500})
						end
					end, closestMarker[2])
				elseif closestMarker[3] == 'shop' then OpenInventory(closestMarker[3], {id=closestMarker[2], type=closestMarker[4]})
				elseif closestMarker[3] == 'policeevidence' then OpenInventory(closestMarker[3]) end
			end

			if currentWeapon then
				DisableControlAction(0, 140, true)

				if not invBusy and currentWeapon.timer ~= 0 and currentWeapon.timer < GetGameTimer() then
					currentWeapon.timer = 0
					if currentWeapon.metadata.ammo then
						TriggerServerEvent('ox_inventory:updateWeapon', 'ammo', currentWeapon.metadata.ammo)
					elseif currentWeapon.metadata.durability then
						TriggerServerEvent('ox_inventory:updateWeapon', 'melee', currentWeapon.melee)
						currentWeapon.melee = 0
					end
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
							if currentWeapon?.ammo and shared.autoreload and not Interface.ProgressActive and not IsPedRagdoll(playerPed) and not IsPedFalling(playerPed) then
								currentWeapon.timer = 0
								local ammo = Inventory.Search(1, currentWeapon.ammo)

								if ammo[1] then
									TriggerServerEvent('ox_inventory:updateWeapon', 'ammo', currentWeapon.metadata.ammo)
									useSlot(ammo[1].slot)
								end
							else currentWeapon.timer = GetGameTimer() + 400 end
						else currentWeapon.timer = GetGameTimer() + 400 end
					end
				elseif IsControlJustReleased(0, 24) then
					if currentWeapon.throwable then
						local playerPed = PlayerData.ped
						plyState.invBusy = true

						SetTimeout(700, function()
							ClearPedSecondaryTask(playerPed)
							RemoveWeaponFromPed(playerPed, currentWeapon.hash)
							TriggerServerEvent('ox_inventory:updateWeapon', 'throw')
							currentWeapon = nil
							TriggerEvent('ox_inventory:currentWeapon')
							plyState.invBusy = false
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
	if shared.resource == resourceName then
		if client.parachute then
			Utils.DeleteObject(client.parachute)
		end

		if invOpen then
			SetNuiFocus(false, false)
			SetNuiFocusKeepInput(false)
			TriggerScreenblurFadeOut(0)
		end
	end
end)

RegisterNetEvent('esx:onPlayerLogout', function()
	if PlayerData.loaded then
		if client.parachute then
			Utils.DeleteObject(client.parachute)
			client.parachute = false
		end

		TriggerEvent('ox_inventory:closeInventory')
		PlayerData.loaded = false
		ClearInterval(interval)
		ClearInterval(tick)
		currentWeapon = Utils.Disarm(currentWeapon)
	end
end)

RegisterNetEvent('ox_inventory:viewInventory', function(data)
	if data and invOpen == false then
		data.type = 'admin'
		plyState.invOpen = true
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

RegisterNUICallback('uiLoaded', function(_, cb)
	uiLoaded = true
	cb(1)
end)

RegisterNUICallback('removeComponent', function(data, cb)
	cb(1)
	if currentWeapon then
		if data.slot ~= currentWeapon.slot then return Utils.Notify({type = 'error', text = shared.locale('weapon_hand_wrong')}) end
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
	else
		TriggerServerEvent('ox_inventory:updateWeapon', 'component', data)
	end
end)

RegisterNUICallback('useItem', function(slot, cb)
	useSlot(slot)
	cb(1)
end)

RegisterNUICallback('giveItem', function(data, cb)
	cb(1)
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
				if data.slot == currentWeapon?.slot then currentWeapon = Utils.Disarm(currentWeapon) end
			end
		end
	else
		local target = Utils.Raycast()
		if target and IsPedAPlayer(target) and #(GetEntityCoords(PlayerData.ped, true) - GetEntityCoords(target, true)) < 2 then
			target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(target))
			Utils.PlayAnim(2000, 'mp_common', 'givetake1_a', 1.0, 1.0, -1, 50, 0.0, 0, 0, 0)
			TriggerServerEvent('ox_inventory:giveItem', data.slot, target, data.count)
			if data.slot == currentWeapon?.slot then currentWeapon = Utils.Disarm(currentWeapon) end
		end
	end
end)

RegisterNUICallback('exit', function(_, cb)
	TriggerEvent('ox_inventory:closeInventory')
	cb(1)
end)

RegisterNUICallback('swapItems', function(data, cb)
	if currentInstance then
		data.instance = currentInstance
	end

	local response, data, weapon = ServerCallback.Await(shared.resource, 'swapItems', false, data)

	if data then
		updateInventory(data.items, data.weight)
	end

	if weapon and currentWeapon then
		currentWeapon.slot = weapon
		TriggerEvent('ox_inventory:currentWeapon', currentWeapon)
	end
	cb(response or false)
end)

RegisterNUICallback('buyItem', function(data, cb)
	local response, data, message = ServerCallback.Await(shared.resource, 'buyItem', 100, data)
	if data then
		PlayerData.inventory[data[1]] = data[2]
		client.setPlayerData('inventory', PlayerData.inventory)
		client.setPlayerData('weight', data[3])
		SendNUIMessage({ action = 'refreshSlots', data = {item = data[2]} })
	end
	if message then Utils.Notify(message) end
	cb(response)
end)
