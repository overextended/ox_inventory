if not lib then return end

local Utils = client.utils
local Weapon = client.weapon
local currentWeapon

exports('getCurrentWeapon', function()
	return currentWeapon
end)

RegisterNetEvent('ox_inventory:disarm', function()
	currentWeapon = Weapon.Disarm(currentWeapon)
end)

RegisterNetEvent('ox_inventory:clearWeapons', function()
	Weapon.ClearAll(currentWeapon)
end)

local StashTarget

exports('setStashTarget', function(id, owner)
	StashTarget = id and {id=id, owner=owner}
end)

---@type boolean | number
local invBusy = true

---@type boolean?
local invOpen = false
local plyState = LocalPlayer.state
local IsPedCuffed = IsPedCuffed
local playerPed = cache.ped

lib.onCache('ped', function(ped)
	playerPed = ped
	Utils.WeaponWheel()
end)

plyState:set('invBusy', true, false)
plyState:set('invHotkeys', false, false)

local function canOpenInventory()
	return PlayerData.loaded
	and not invBusy
	and not PlayerData.dead
	and invOpen ~= nil
	and (not currentWeapon or currentWeapon.timer == 0)
	and not IsPedCuffed(playerPed)
	and not IsPauseMenuActive()
	and not IsPedFatallyInjured(playerPed)
end

---@param ped number
---@return boolean
local function canOpenTarget(ped)
	return IsPedFatallyInjured(ped)
	or IsEntityPlayingAnim(ped, 'dead', 'dead_a', 3)
	or IsPedCuffed(ped)
	or IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_enter', 3)
	or IsEntityPlayingAnim(ped, 'random@mugging3', 'handsup_standing_base', 3)
end

local defaultInventory = {
	type = 'newdrop',
	slots = shared.playerslots,
	weight = 0,
	maxWeight = shared.playerweight,
	items = {}
}
local currentInventory = defaultInventory

local function closeTrunk()
	if currentInventory?.type == 'trunk' then
		local coords = GetEntityCoords(playerPed, true)
		---@todo animation for vans?
		Utils.PlayAnimAdvanced(0, 'anim@heists@fleeca_bank@scope_out@return_case', 'trevor_action', coords.x, coords.y, coords.z, 0.0, 0.0, GetEntityHeading(playerPed), 2.0, 2.0, 1000, 49, 0.25)

		CreateThread(function()
			local entity = currentInventory.entity
			local door = currentInventory.door
			Wait(900)

			if type(door) == 'table' then
				for i = 1, #door do
					SetVehicleDoorShut(entity, door[i], false)
				end
			else
				SetVehicleDoorShut(entity, door, false)
			end
		end)
	end
end

---@param inv string
---@param data any
---@return boolean?
function client.openInventory(inv, data)
	if invOpen then
		if not inv and currentInventory.type == 'newdrop' then
			return client.closeInventory()
		end

		if IsNuiFocused() then
			if inv == 'container' and currentInventory.id == PlayerData.inventory[data].metadata.container then
				return client.closeInventory()
			end

			if currentInventory.type == 'drop' and (not data or currentInventory.id == (type(data) == 'table' and data.id or data)) then
				return client.closeInventory()
			end

			if inv ~= 'drop' and inv ~= 'container' then
				return client.closeInventory()
			end
		end
	elseif IsNuiFocused() then
		-- If triggering event from another nui such as qtarget, may need to wait for focus to end
		Wait(100)

		if IsNuiFocused() then
			return warn('Inventory did not open as another resource has NUI Focus.')
		end
	end

	if inv == 'dumpster' and cache.vehicle then
		return lib.notify({ id = 'inventory_right_access', type = 'error', description = locale('inventory_right_access') })
	end

	if canOpenInventory() then
		local left, right

		if inv == 'player' then
			local targetId, targetPed

			if not data then
				targetId, targetPed = Utils.GetClosestPlayer()
				data = targetId and GetPlayerServerId(targetId)
			else
				local serverId = type(data) == 'table' and data.id or data

				if serverId == cache.serverId then return end

				targetId = serverId and GetPlayerFromServerId(serverId)
				targetPed = targetId and GetPlayerPed(targetId)
			end

			local targetCoords = targetPed and GetEntityCoords(targetPed)

			if not targetCoords or #(targetCoords - GetEntityCoords(playerPed)) > 1.8 or not (client.hasGroup(shared.police) or canOpenTarget(targetPed)) then
				return lib.notify({ id = 'inventory_right_access', type = 'error', description = locale('inventory_right_access') })
			end
		end

		if inv == 'shop' and invOpen == false then
			if cache.vehicle then
				return lib.notify({ id = 'cannot_perform', type = 'error', description = locale('cannot_perform') })
			end

			left, right = lib.callback.await('ox_inventory:openShop', 200, data)
		elseif inv == 'crafting' then
			if cache.vehicle then
				return lib.notify({ id = 'cannot_perform', type = 'error', description = locale('cannot_perform') })
			end

			left = lib.callback.await('ox_inventory:openCraftingBench', 200, data.id, data.index)

			if left then
				right = client.craftingBenches[data.id]
				local coords = shared.target == 'ox_target' and right.zones[data.index].coords or right.points[data.index]

				right = {
					type = 'crafting',
					id = data.id,
					label = right.label or locale('crafting_bench'),
					index = data.index,
					slots = right.slots,
					items = right.items,
					coords = coords
				}
			end
		elseif invOpen ~= nil then
			if inv == 'policeevidence' then
				local input = lib.inputDialog(locale('police_evidence'), {locale('locker_number')}) --[[@as any]]

				if input then
					input = tonumber(input[1])
				else
					return lib.notify({ description = locale('locker_no_value'), type = 'error' })
				end

				if type(input) ~= 'number' then
					return lib.notify({ description = locale('locker_must_number'), type = 'error' })
				else
					data = input
				end
			end

			left, right = lib.callback.await('ox_inventory:openInventory', false, inv, data)
		end

		if left then
			if not cache.vehicle then
				if inv == 'player' then
					Utils.PlayAnim(0, 'mp_common', 'givetake1_a', 8.0, 1.0, 2000, 50, 0.0, 0, 0, 0)
				elseif inv ~= 'trunk' then
					Utils.PlayAnim(0, 'pickup_object', 'putdown_low', 5.0, 1.5, 1000, 48, 0.0, 0, 0, 0)
				end
			end

			plyState.invOpen = true
			SetInterval(client.interval, 100)
			SetNuiFocus(true, true)
			SetNuiFocusKeepInput(true)
			if client.screenblur then TriggerScreenblurFadeIn(0) end
			closeTrunk()
			currentInventory = right or defaultInventory
			left.items = PlayerData.inventory
			SendNUIMessage({
				action = 'setupInventory',
				data = {
					leftInventory = left,
					rightInventory = currentInventory
				}
			})

			if not currentInventory.coords and not inv == 'container' then
				currentInventory.coords = GetEntityCoords(playerPed)
			end

			-- Stash exists (useful for custom stashes)
			return true
		else
			-- Stash does not exist
			if left == false then return false end
			if invOpen == false then lib.notify({ id = 'inventory_right_access', type = 'error', description = locale('inventory_right_access') }) end
			if invOpen then client.closeInventory() end
		end
	elseif invBusy then lib.notify({ id = 'inventory_player_access', type = 'error', description = locale('inventory_player_access') }) end
end
RegisterNetEvent('ox_inventory:openInventory', client.openInventory)
exports('openInventory', client.openInventory)

local Animations = data 'animations'
local Items = client.items

lib.callback.register('ox_inventory:usingItem', function(data)
	local item = Items[data.name]

	if item and invBusy then
		if not item.client then return true end
		---@cast item +OxClientProps
		item = item.client
		plyState.invBusy = true

		if type(item.anim) == 'string' then
			item.anim = Animations.anim[item.anim]
		end

		if item.propTwo then
			item.prop = { item.prop, item.propTwo }
		end

		if item.prop then
			if item.prop[1] then
				for i = 1, #item.prop do
					if type(item.prop) == 'string' then
						item.prop = Animations.prop[item.prop[i]]
					end
				end
			elseif type(item.prop) == 'string' then
				item.prop = Animations.prop[item.prop]
			end
		end

		local success = (not item.usetime or lib.progressBar({
			duration = item.usetime,
			label = item.label or locale('using', data.label),
			useWhileDead = item.useWhileDead,
			canCancel = item.cancel,
			disable = item.disable,
			anim = item.anim or item.scenario,
			prop = item.prop --[[@as ProgressProps]]
		})) and not PlayerData.dead

		if success then
			if item.notification then
				lib.notify({ description = item.notification })
			end

			if item.status then
				if client.setPlayerStatus then
					client.setPlayerStatus(item.status)
				else
					-- Not ideal, but compatibility and all that
					return true, { status = item.status }
				end
			end

			return true
		end
	end
end)

local function canUseItem(isAmmo)
	local ped = cache.ped

	return (not isAmmo or currentWeapon)
	and PlayerData.loaded
	and not PlayerData.dead
	and not invBusy
	and not lib.progressActive()
	and not IsPedRagdoll(ped)
	and not IsPedFalling(ped)
end

---@param data table
---@param cb function?
local function useItem(data, cb)
	if invOpen and data.close then client.closeInventory() end
	local slotData, result = PlayerData.inventory[data.slot]

	if canUseItem(data.ammo and true) then
		if currentWeapon and currentWeapon?.timer > 100 then return end

		invBusy = true
		result = lib.callback.await('ox_inventory:useItem', 200, data.name, data.slot, slotData.metadata)

		if not result then
			Wait(500)
			plyState.invBusy = false
			return
		end
	end

	if cb then
		local success, response = pcall(cb, result and slotData)

		if not success and response then
			print(('^1An error occurred while calling item "%s" callback!\n^1SCRIPT ERROR: %s^0'):format(slotData.name, response))
		end
	end

	Wait(200)
	plyState.invBusy = false
end
AddEventHandler('ox_inventory:item', useItem)
exports('useItem', useItem)

---@param slot number
---@return boolean?
local function useSlot(slot)
	local item = PlayerData.inventory[slot]
	if not item then return end

	local data = Items[item.name]
	if not data then return end

	if canUseItem(data.ammo and true) then

		if data.component and not currentWeapon then
			return lib.notify({ id = 'weapon_hand_required', type = 'error', description = locale('weapon_hand_required') })
		end

		data.slot = slot

		if item.metadata.container then
			return client.openInventory('container', item.slot)
		elseif data.client then
			if invOpen and data.close then client.closeInventory() end

			if data.export then
				return data.export(data, {name = item.name, slot = item.slot, metadata = item.metadata})
			elseif data.client.event then -- re-add it, so I don't need to deal with morons taking screenshots of errors when using trigger event
				return TriggerEvent(data.client.event, data, {name = item.name, slot = item.slot, metadata = item.metadata})
			end
		end

		if data.effect then
			data:effect({name = item.name, slot = item.slot, metadata = item.metadata})
		elseif data.weapon then
			if EnableWeaponWheel then return end
			useItem(data, function(result)
				if result then
					if currentWeapon then
						local weaponSlot = currentWeapon.slot
						currentWeapon = Weapon.Disarm(currentWeapon)

						if weaponSlot == result.slot then return end
					end

					currentWeapon = item
					currentWeapon = Weapon.Equip(item, data)

					if IsCinematicCamRendering() then SetCinematicModeActive(false) end
				end
			end)
		elseif currentWeapon then
			if data.ammo then
				if EnableWeaponWheel or currentWeapon.metadata.durability <= 0 then return end
				local maxAmmo = GetMaxAmmoInClip(playerPed, currentWeapon.hash, true)
				local currentAmmo = GetAmmoInPedWeapon(playerPed, currentWeapon.hash)

				if currentAmmo ~= maxAmmo and currentAmmo < maxAmmo then
					useItem(data, function(data)
						if data then
							if data.name == currentWeapon.ammo then
								local missingAmmo = maxAmmo - currentAmmo
								local newAmmo = 0

								if missingAmmo > data.count then newAmmo = currentAmmo + data.count else newAmmo = maxAmmo end
								if newAmmo < 0 then newAmmo = 0 end

								currentWeapon.metadata.ammo = newAmmo

								if cache.vehicle then
									SetAmmoInClip(playerPed, currentWeapon.hash, newAmmo)
								else
									SetPedAmmo(playerPed, currentWeapon.hash, newAmmo)
									MakePedReload(playerPed)
								end

								TriggerServerEvent('ox_inventory:updateWeapon', 'load', currentWeapon.metadata.ammo)
							end
						end
					end)
				end
			elseif data.component then
				local components = data.client.component
				local componentType = data.type
				local weaponComponents = PlayerData.inventory[currentWeapon.slot].metadata.components
				-- Checks if the weapon already has the same component type attached
				for componentIndex = 1, #weaponComponents do
					if componentType == Items[weaponComponents[componentIndex]].type then
						-- todo: Update locale?
						return lib.notify({ id = 'component_has', type = 'error', description = locale('component_has', data.label) })
					end
				end
				for i = 1, #components do
					local component = components[i]

					if DoesWeaponTakeWeaponComponent(currentWeapon.hash, component) then
						if HasPedGotWeaponComponent(playerPed, currentWeapon.hash, component) then
							lib.notify({ id = 'component_has', type = 'error', description = locale('component_has', data.label) })
						else
							useItem(data, function(data)
								if data then
									GiveWeaponComponentToPed(playerPed, currentWeapon.hash, component)
									table.insert(PlayerData.inventory[currentWeapon.slot].metadata.components, data.name)
									TriggerServerEvent('ox_inventory:updateWeapon', 'component', tostring(data.slot), currentWeapon.slot)
								end
							end)
						end
						return
					end
				end
				lib.notify({ id = 'component_invalid', type = 'error', description = locale('component_invalid', data.label) })
			elseif data.allowArmed then
				useItem(data)
			end
		elseif not data.ammo and not data.component then
			useItem(data)
		end
	end
end
exports('useSlot', useSlot)

---@param id number
---@param slot number
local function useButton(id, slot)
	if PlayerData.loaded and not invBusy and not lib.progressActive() then
		local item = PlayerData.inventory[slot]
		if not item then return end

		local data = Items[item.name]
		local buttons = data?.buttons

		if buttons and buttons[id]?.action then
			buttons[id].action(slot)
		end
	end
end

local function openNearbyInventory() client.openInventory('player') end

exports('openNearbyInventory', openNearbyInventory)

local currentInstance
local playerCoords
local table = lib.table
local Inventory = client.inventory

---@todo remove or replace when the bridge module gets restructured
function OnPlayerData(key, val)
	if key ~= 'groups' and key ~= 'ped' and key ~= 'dead' then return end

	if key == 'groups' then
		Inventory.Stashes()
		Inventory.Evidence()
		client.refreshShops()
	elseif key == 'dead' and val then
		currentWeapon = Weapon.Disarm(currentWeapon)
		client.closeInventory()
	end

	Utils.WeaponWheel()
end

-- People consistently ignore errors when one of the "modules" failed to load
if not Utils or not Weapon or not Items or not Inventory then return end

local invHotkeys = false

local function registerCommands()
	RegisterCommand('steal', openNearbyInventory, false)

	lib.addKeybind({
		name = 'inv',
		description = locale('open_player_inventory'),
		defaultKey = client.keys[1],
		onPressed = function()
			if invOpen then
				return client.closeInventory()
			end

			local closest = lib.points.closest()

			if closest and closest.currentDistance < 1.2 and (not closest.instance or closest.instance == currentInstance) then
				if closest.inv == 'crafting' then
					return client.openInventory('crafting', { id = closest.id, index = closest.index })
				elseif closest.inv ~= 'license' and closest.inv ~= 'policeevidence' then
					return client.openInventory(closest.inv or 'drop', { id = closest.invId, type = closest.type })
				end
			end

			return client.openInventory()
		end
	})

	local Vehicles = data 'vehicles'

	lib.addKeybind({
		name = 'inv2',
		description = locale('open_secondary_inventory'),
		defaultKey = client.keys[2],
		onPressed = function()
			if invOpen then
				return client.closeInventory()
			end

			if invBusy then
				return lib.notify({ id = 'inventory_player_access', type = 'error', description = locale('inventory_player_access') })
			end

			if not canOpenInventory() then
				return lib.notify({ id = 'inventory_player_access', type = 'error', description = locale('inventory_player_access') })
			end

			if StashTarget then
				client.openInventory('stash', StashTarget)
			elseif cache.vehicle then
				-- Player is still entering vehicle, so bailout
				if not IsPedInAnyVehicle(playerPed, false) then return end

				local vehicle = cache.vehicle

				if NetworkGetEntityIsNetworked(vehicle) then
					local vehicleHash = GetEntityModel(vehicle)
					local vehicleClass = GetVehicleClass(vehicle)
					local checkVehicle = Vehicles.Storage[vehicleHash]
					-- No storage or no glovebox
					if (checkVehicle == 0 or checkVehicle == 2) or (not Vehicles.glovebox[vehicleClass] and not Vehicles.glovebox.models[vehicleHash]) then return end

					local plate = GetVehicleNumberPlateText(vehicle)
					client.openInventory('glovebox', {id = 'glove'..plate, netid = NetworkGetNetworkIdFromEntity(vehicle) })

					while true do
						Wait(100)
						if not invOpen then break
						elseif not cache.vehicle then
							client.closeInventory()
							break
						end
					end
				end
			else
				local entity, entityType = Utils.Raycast()
				if not entity then return end
				local vehicle, position

				if not shared.target then
					if entityType == 2 then vehicle, position = entity, GetEntityCoords(entity)
					elseif entityType == 3 and table.contains(Inventory.Dumpsters, GetEntityModel(entity)) then
						local netId = NetworkGetEntityIsNetworked(entity) and NetworkGetNetworkIdFromEntity(entity)

						if not netId then
							local coords = GetEntityCoords(entity)
							entity = GetClosestObjectOfType(coords.x, coords.y, coords.z, 0.1, GetEntityModel(entity), true, true, true)
							netId = entity ~= 0 and NetworkGetNetworkIdFromEntity(entity)
						end

						if netId then
							client.openInventory('dumpster', 'dumpster'..netId)
						end
					end
				elseif entityType == 2 then
					vehicle, position = entity, GetEntityCoords(entity)
				else return end

				if not vehicle then return end

				local lastVehicle
				local vehicleHash = GetEntityModel(vehicle)
				local vehicleClass = GetVehicleClass(vehicle)
				local checkVehicle = Vehicles.Storage[vehicleHash]
				-- No storage or no glovebox
				if (checkVehicle == 0 or checkVehicle == 1) or (not Vehicles.trunk[vehicleClass] and not Vehicles.trunk.models[vehicleHash]) then return end

				if #(playerCoords - position) < 6 and NetworkGetEntityIsNetworked(vehicle) then
					local locked = GetVehicleDoorLockStatus(vehicle)

					if locked == 0 or locked == 1 then
						local open, vehBone

						if checkVehicle == nil then -- No data, normal trunk
							open, vehBone = 5, GetEntityBoneIndexByName(vehicle, 'boot')
						elseif checkVehicle == 3 then -- Trunk in hood
							open, vehBone = 4, GetEntityBoneIndexByName(vehicle, 'bonnet')
						else -- No storage or no trunk
							return
						end

						if vehBone == -1 then
							if vehicleClass == 12 then
								open = { 2, 3 }
							end

							vehBone = GetEntityBoneIndexByName(vehicle, Vehicles.trunk.boneIndex[vehicleHash] or 'platelight')
						end

						position = GetWorldPositionOfEntityBone(vehicle, vehBone)
						local distance = #(playerCoords - position)
						local closeToVehicle = distance < 2 and open

						if closeToVehicle then
							local plate = GetVehicleNumberPlateText(vehicle)
							TaskTurnPedToFaceCoord(playerPed, position.x, position.y, position.z, 0)
							lastVehicle = vehicle
							client.openInventory('trunk', {id='trunk'..plate, netid = NetworkGetNetworkIdFromEntity(vehicle)})
							local timeout = 20
							repeat Wait(50)
								timeout -= 1
							until (currentInventory and currentInventory.type == 'trunk') or timeout == 0

							if timeout == 0 then
								closeToVehicle, lastVehicle = false, nil
								return
							end

							if type(open) == 'table' then
								for i = 1, #open do
									SetVehicleDoorOpen(vehicle, open[i], false, false)
								end
							else
								SetVehicleDoorOpen(vehicle, open, false, false)
							end

							Wait(200)
							---@todo animation for vans?
							Utils.PlayAnim(0, 'anim@heists@prison_heiststation@cop_reactions', 'cop_b_idle', 3.0, 3.0, -1, 49, 0.0, 0, 0, 0)
							currentInventory.entity = lastVehicle
							currentInventory.door = open

							while true do
								Wait(50)

								if closeToVehicle and invOpen then
									position = GetWorldPositionOfEntityBone(vehicle, vehBone)

									if #(GetEntityCoords(playerPed) - position) >= 2 or not DoesEntityExist(vehicle) then
										break
									else TaskTurnPedToFaceCoord(playerPed, position.x, position.y, position.z, 0) end
								else break end
							end

							if lastVehicle then client.closeInventory() end
						end
					else lib.notify({ id = 'vehicle_locked', type = 'error', description = locale('vehicle_locked') }) end
				end
			end
		end
	})

	lib.addKeybind({
		name = 'reloadweapon',
		description = locale('reload_weapon'),
		defaultKey = 'r',
		onPressed = function(self)
			if not currentWeapon or not canUseItem(true) then return end

			if currentWeapon.ammo then
				if currentWeapon.metadata.durability > 0 then
					local ammo = Inventory.Search(1, currentWeapon.ammo)?[1]

					if ammo then
						useSlot(ammo.slot)
					end
				else
					lib.notify({ id = 'no_durability', type = 'error', description = locale('no_durability', currentWeapon.label) })
				end
			end
		end
	})

	lib.addKeybind({
		name = 'hotbar',
		description = locale('disable_hotbar'),
		defaultKey = client.keys[3],
		onPressed = function()
			if EnableWeaponWheel or IsNuiFocused() or lib.progressActive() then return end
			SendNUIMessage({ action = 'toggleHotbar' })
		end
	})

	for i = 1, 5 do
		lib.addKeybind({
			name = ('hotkey%s'):format(i),
			description = locale('use_hotbar', i),
			defaultKey = tostring(i),
			onPressed = function()
				if invOpen or IsNuiFocused() or not invHotkeys then return end
				useSlot(i)
			end
		})
	end
end

function client.closeInventory(server)
	-- because somehow people are triggering this when the inventory isn't loaded
	-- and they're incapable of debugging, and I can't repro on a fresh install
	if not client.interval then return end

	if invOpen then
		invOpen = nil
		SetNuiFocus(false, false)
		SetNuiFocusKeepInput(false)
		TriggerScreenblurFadeOut(0)
		closeTrunk()
		SendNUIMessage({ action = 'closeInventory' })
		SetInterval(client.interval, 200)
		Wait(200)

		if invOpen ~= nil then return end

		if not server and currentInventory then
			TriggerServerEvent('ox_inventory:closeInventory')
		end

		currentInventory = nil
		plyState.invOpen = false
		defaultInventory.coords = nil
	end
end

RegisterNetEvent('ox_inventory:closeInventory', client.closeInventory)

local function updateInventory(items, weight)
	-- todo: combine iterators
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

		SendNUIMessage({ action = 'refreshSlots', data = {itemCount = itemCount} })
		client.setPlayerData('weight', weight)
	else
		for i = 1, #items do
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

		SendNUIMessage({ action = 'refreshSlots', data = { items = items, itemCount = itemCount} })
		client.setPlayerData('weight', weight.left)
	end


	for item, count in pairs(itemCount) do
		local data = Items[item]

		if count < 0 then
			if currentWeapon and not currentWeapon.throwable and currentWeapon.slot == data.slot then
				currentWeapon = Weapon.Disarm(currentWeapon)
			end

			data.count += count

			if shared.framework == 'esx' then
				TriggerEvent('esx:removeInventoryItem', data.name, data.count)
			else
				TriggerEvent('ox_inventory:itemCount', data.name, data.count)
			end

			if data.client?.remove then
				data.client.remove(data.count)
			end
		elseif count > 0 then
			data.count += count

			if shared.framework == 'esx' then
				TriggerEvent('esx:addInventoryItem', data.name, data.count)
			else
				TriggerEvent('ox_inventory:itemCount', data.name, data.count)
			end

			if data.client?.add then
				data.client.add(data.count)
			end
		end
	end

	client.setPlayerData('inventory', PlayerData.inventory)
	TriggerEvent('ox_inventory:updateInventory', changes)
end

RegisterNetEvent('ox_inventory:updateSlots', function(items, weights, count, removed)
	if source == '' or not next(items) then return end

	local item = items[1]?.item

	if currentWeapon?.slot == item?.slot and item.metadata then
		currentWeapon.metadata = item.metadata
		TriggerEvent('ox_inventory:currentWeapon', currentWeapon)
	end

	if count then
		if not item.name then
			item = PlayerData.inventory[item.slot]
		end

		Utils.ItemNotify({item.metadata?.label or item.label, item.metadata?.image or item.metadata?.imageurl or item.name, removed and 'ui_removed' or 'ui_added', count})
	end

	updateInventory(items, weights)
end)

RegisterNetEvent('ox_inventory:inventoryReturned', function(data)
	if source == '' then return end
	if currentWeapon then currentWeapon = Weapon.Disarm(currentWeapon) end

	lib.notify({ description = locale('items_returned') })
	client.closeInventory()

	local num, items = 0, {}

	for _, slotData in pairs(data[1]) do
		num += 1
		items[num] = { item = slotData, inventory = 'player' }
	end

	updateInventory(items, { left = data[3] })
end)

RegisterNetEvent('ox_inventory:inventoryConfiscated', function(message)
	if source == '' then return end
	if message then lib.notify({ description = locale('items_confiscated') }) end
	if currentWeapon then currentWeapon = Weapon.Disarm(currentWeapon) end

	client.closeInventory()

	local num, items = 0, {}

	for slot in pairs(PlayerData.inventory) do
		num += 1
		items[num] = { item = { slot = slot }, inventory = 'player' }
	end

	updateInventory(items, { left = 0 })
end)


---@param point CPoint
local function nearbyDrop(point)
	if not point.instance or point.instance == currentInstance then
		---@diagnostic disable-next-line: param-type-mismatch
		DrawMarker(2, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 150, 30, 30, 222, false, false, 0, true, false, false, false)
	end
end

---@param point CPoint
local function onEnterDrop(point)
	if not point.instance or point.instance == currentInstance and not point.entity then
		local model = point.model or `prop_med_bag_01b`

		lib.requestModel(model)

		local entity = CreateObject(model, point.coords.x, point.coords.y, point.coords.z, false, true, true)

		SetModelAsNoLongerNeeded(model)
		PlaceObjectOnGroundProperly(entity)
		FreezeEntityPosition(entity, true)
		SetEntityCollision(entity, false, true)

		point.entity = entity
	end
end

local function onExitDrop(point)
	local entity = point.entity

	if entity and DoesEntityExist(entity) then
		Utils.DeleteObject(entity)
		point.entity = nil
	end
end

local function createDrop(dropId, data)
	local point = lib.points.new({
		coords = data.coords,
		distance = 16,
		invId = dropId,
		instance = data.instance,
		model = data.model
	})

	if point.model or client.dropprops then
		point.distance = 30
		point.onEnter = onEnterDrop
		point.onExit = onExitDrop
	else
		point.nearby = nearbyDrop
	end

	client.drops[dropId] = point
end

RegisterNetEvent('ox_inventory:createDrop', function(dropId, data, owner, slot)
	if client.drops then
		createDrop(dropId, data)
	end

	if owner == cache.serverId then
		if currentWeapon?.slot == slot then
			currentWeapon = Weapon.Disarm(currentWeapon)
		end

		if invOpen and #(GetEntityCoords(playerPed) - data.coords) <= 1 then
			if not cache.vehicle then
				client.openInventory('drop', dropId)
			else
				SendNUIMessage({
					action = 'setupInventory',
					data = { rightInventory = currentInventory }
				})
			end
		end
	end
end)

RegisterNetEvent('ox_inventory:removeDrop', function(dropId)
	if client.drops then
		local point = client.drops[dropId]

		if point then
			client.drops[dropId] = nil
			point:remove()

			if point.entity then Utils.DeleteObject(point.entity) end
		end
	end
end)

local uiLoaded = false

---@type function?
local function setStateBagHandler(stateId)
	AddStateBagChangeHandler('invOpen', stateId, function(_, _, value)
		invOpen = value
	end)

	AddStateBagChangeHandler('invBusy', stateId, function(_, _, value)
		invBusy = value

		if value then
			lib.disableControls:Add(23, 25, 36, 68, 263)
		else
			lib.disableControls:Remove(23, 25, 36, 68, 263)
		end
	end)

	AddStateBagChangeHandler('instance', stateId, function(_, _, value)
		currentInstance = value
	end)

	AddStateBagChangeHandler('dead', stateId, function(_, _, value)
		Utils.WeaponWheel()
		PlayerData.dead = value
	end)

	AddStateBagChangeHandler('invHotkeys', stateId, function(_, _, value)
		invHotkeys = value
	end)

	setStateBagHandler = nil
end

lib.onCache('seat', function(seat)
	if seat then
		if DoesVehicleHaveWeapons(cache.vehicle) then
			return Utils.WeaponWheel(true)
		end
	end

	Utils.WeaponWheel(false)
end)

RegisterNetEvent('ox_inventory:setPlayerInventory', function(currentDrops, inventory, weight, player)
	if source == '' then return end

	PlayerData = player
	PlayerData.id = cache.playerId
	PlayerData.source = cache.serverId

	setmetatable(PlayerData, {
		__index = function(self, key)
			if key == 'ped' then
				return PlayerPedId()
			end
		end
	})

	if setStateBagHandler then setStateBagHandler(('player:%s'):format(cache.serverId)) end

	local ItemData = table.create(0, #Items)

	for _, v in pairs(Items) do
		local buttons = v.buttons and {} or nil

		if buttons then
			for i = 1, #v.buttons do
				buttons[i] = v.buttons[i].label
			end
		end

		ItemData[v.name] = {
			label = v.label,
			stack = v.stack,
			close = v.close,
			count = 0,
			description = v.description,
			buttons = buttons,
			ammoName = v.ammoname,
		}
	end

	for _, data in pairs(inventory) do
		local item = Items[data.name]

		if item then
			item.count += data.count
			ItemData[data.name].count += data.count
			local add = item.client?.add

			if add then
				add(item.count)
			end
		end
	end

	local phone = Items.phone

	if phone and phone.count < 1 then
		pcall(function()
			return exports.npwd:setPhoneDisabled(true)
		end)
	end

	client.setPlayerData('inventory', inventory)
	client.setPlayerData('weight', weight)
	currentWeapon = nil
	Weapon.ClearAll()

	local uiLocales = {}
	local locales = lib.getLocales()

	for k, v in pairs(locales) do
		if k:find('^ui_')then
			uiLocales[k] = v
		end
	end

	uiLocales['$'] = locales['$']
	uiLocales.ammo_type = locales.ammo_type

	client.drops = currentDrops

	for dropId, data in pairs(currentDrops) do
		createDrop(dropId, data)
	end

	local hasTextUi = false
	local uiOptions = { icon = 'fa-id-card' }

	---@param point CPoint
	local function nearbyLicense(point)
		---@diagnostic disable-next-line: param-type-mismatch
		DrawMarker(2, point.coords.x, point.coords.y, point.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 150, 30, 222, false, false, 0, true, false, false, false)

		if point.isClosest and point.currentDistance < 1.2 then
			if not hasTextUi then
				hasTextUi = true
				lib.showTextUI(point.message, uiOptions)
			end

			if IsControlJustReleased(0, 38) then
				lib.callback('ox_inventory:buyLicense', 1000, function(success, message)
					if success ~= nil then
						lib.notify({
							id = message,
							type = success == false and 'error' or 'success',
							description = locale(message, locale('license', point.type:gsub("^%l", string.upper)))
						})
					end
				end, point.invId)
			end
		elseif hasTextUi then
			hasTextUi = false
			lib.hideTextUI()
		end
	end

	for id, data in pairs(data('licenses')) do
		lib.points.new({
			coords = data.coords,
			distance = 16,
			inv = 'license',
			type = data.name,
			price = data.price,
			invId = id,
			nearby = nearbyLicense,
			message = ('**%s**  \n%s'):format(locale('purchase_license', data.name), locale('interact_prompt', GetControlInstructionalButton(0, 38, true):sub(3)))
		})
	end

	while not uiLoaded do Wait(50) end

	SendNUIMessage({
		action = 'init',
		data = {
			locale = uiLocales,
			items = ItemData,
			leftInventory = {
				id = cache.playerId,
				slots = shared.playerslots,
				items = PlayerData.inventory,
				maxWeight = shared.playerweight,
			},
			imagepath = GetConvar('inventory:imagepath', 'nui://ox_inventory/web/images')
		}
	})

	PlayerData.loaded = true

	lib.notify({ description = locale('inventory_setup') })
	client.refreshShops()
	Inventory.Stashes()
	Inventory.Evidence()
	registerCommands()

	TriggerEvent('ox_inventory:updateInventory', PlayerData.inventory)

	client.interval = SetInterval(function()
		if invOpen == false then
			playerCoords = GetEntityCoords(playerPed)

			if currentWeapon and IsPedUsingActionMode(playerPed) then
				SetPedUsingActionMode(playerPed, false, -1, 'DEFAULT_ACTION')
			end

		elseif invOpen == true then
			if not canOpenInventory() then
				client.closeInventory()
			else
				playerCoords = GetEntityCoords(playerPed)
				if currentInventory then

					if currentInventory.type == 'otherplayer' then
						local id = GetPlayerFromServerId(currentInventory.id)
						local ped = GetPlayerPed(id)
						local pedCoords = GetEntityCoords(ped)

						if not id or #(playerCoords - pedCoords) > 1.8 or not (client.hasGroup(shared.police) or canOpenTarget(ped)) then
							client.closeInventory()
							lib.notify({ id = 'inventory_lost_access', type = 'error', description = locale('inventory_lost_access') })
						else
							TaskTurnPedToFaceCoord(playerPed, pedCoords.x, pedCoords.y, pedCoords.z, 50)
						end

					elseif currentInventory.coords and (#(playerCoords - currentInventory.coords) > (currentInventory.distance or 2.0) or canOpenTarget(playerPed)) then
						client.closeInventory()
						lib.notify({ id = 'inventory_lost_access', type = 'error', description = locale('inventory_lost_access') })
					end
				end
			end
		end

		local weaponHash = GetSelectedPedWeapon(playerPed)

		if currentWeapon then
			if weaponHash ~= currentWeapon.hash and currentWeapon.timer then
				local weaponCount = Items[currentWeapon.name]?.count

				if weaponCount > 0 then
					SetCurrentPedWeapon(playerPed, currentWeapon.hash, true)
					SetAmmoInClip(playerPed, currentWeapon.hash, currentWeapon.metadata.ammo)
					SetPedCurrentWeaponVisible(playerPed, true, false, false, false)

					weaponHash = GetSelectedPedWeapon(playerPed)
				end

				if weaponHash ~= currentWeapon.hash then
					TriggerServerEvent('ox_inventory:updateWeapon')
					currentWeapon = Weapon.Disarm(currentWeapon, true)
				end
			end
		elseif client.weaponmismatch and weaponHash ~= `WEAPON_UNARMED` then
			local weaponType = GetWeapontypeGroup(weaponHash)

			if weaponType ~= 0 and weaponType ~= `GROUP_UNARMED` then
				if weaponHash ~= `WEAPON_HANDCUFFS` and weaponHash ~= `WEAPON_GARBAGEBAG` then
					Weapon.Disarm(currentWeapon, true)
				end
			end
		end

		if client.parachute and GetPedParachuteState(playerPed) ~= -1 then
			Utils.DeleteObject(client.parachute)
			client.parachute = false
		end
	end, 200)

	local playerId = cache.playerId
	local EnableKeys = client.enablekeys
	local DisablePlayerVehicleRewards = DisablePlayerVehicleRewards
	local DisableAllControlActions = DisableAllControlActions
	local HideHudAndRadarThisFrame = HideHudAndRadarThisFrame
	local EnableControlAction = EnableControlAction
	local disableControls = lib.disableControls
	local DisablePlayerFiring = DisablePlayerFiring
	local HudWeaponWheelIgnoreSelection = HudWeaponWheelIgnoreSelection
	local DisableControlAction = DisableControlAction
	local IsPedShooting = IsPedShooting
	local IsControlJustReleased = IsControlJustReleased

	client.tick = SetInterval(function()
		DisablePlayerVehicleRewards(playerId)

		if invOpen then
			DisableAllControlActions(0)
			HideHudAndRadarThisFrame()

			for i = 1, #EnableKeys do
				EnableControlAction(0, EnableKeys[i], true)
			end

			if currentInventory.type == 'newdrop' then
				EnableControlAction(0, 30, true)
				EnableControlAction(0, 31, true)
			end
		else
			disableControls()

			if invBusy == true or IsPedCuffed(playerPed) then
				DisablePlayerFiring(playerId, true)
			end

			if not EnableWeaponWheel then
				HudWeaponWheelIgnoreSelection()
				DisableControlAction(0, 37, true)
			end

			if currentWeapon and currentWeapon.timer then
				DisableControlAction(0, 80, true)
				DisableControlAction(0, 140, true)

				if currentWeapon.metadata.durability <= 0 then
					DisablePlayerFiring(playerId, true)
				elseif client.aimedfiring and not currentWeapon.melee and not IsPlayerFreeAiming(playerId) then
					DisablePlayerFiring(playerId, true)
				end

				local weaponAmmo = currentWeapon.metadata.ammo

				if not invBusy and currentWeapon.timer ~= 0 and currentWeapon.timer < GetGameTimer() then
					currentWeapon.timer = 0

					if weaponAmmo then
						TriggerServerEvent('ox_inventory:updateWeapon', 'ammo', weaponAmmo)

						if client.autoreload and weaponAmmo == 0 and currentWeapon.ammo and canUseItem(true) then
							local ammo = Inventory.Search(1, currentWeapon.ammo)?[1]

							if ammo then
								useSlot(ammo.slot)
							end
						end
					elseif currentWeapon.metadata.durability then
						TriggerServerEvent('ox_inventory:updateWeapon', 'melee', currentWeapon.melee)
						currentWeapon.melee = 0
					end
				elseif weaponAmmo then
					if IsPedShooting(playerPed) then
						local currentAmmo

						if currentWeapon.hash == `WEAPON_PETROLCAN` or currentWeapon.hash == `WEAPON_HAZARDCAN` or currentWeapon.hash == `WEAPON_FERTILIZERCAN` or currentWeapon.hash == `WEAPON_FIREEXTINGUISHER` then
							currentAmmo = weaponAmmo - 0.05 < 0 and 0 or weaponAmmo - 0.05
							currentWeapon.metadata.durability = currentAmmo
							currentWeapon.metadata.ammo = (weaponAmmo < currentAmmo) and 0 or currentAmmo

							if currentAmmo <= 0 then
								SetPedInfiniteAmmo(playerPed, false, currentWeapon.hash)
							end
						else
							currentAmmo = GetAmmoInPedWeapon(playerPed, currentWeapon.hash)

							if currentAmmo < weaponAmmo then
								currentAmmo = (weaponAmmo < currentAmmo) and 0 or currentAmmo

								local durability = Items[currentWeapon.name].durability * math.abs((weaponAmmo or 0.1) - currentAmmo)
								currentWeapon.metadata.ammo = currentAmmo
								currentWeapon.metadata.durability = currentWeapon.metadata.durability - durability
							end
						end

						if currentAmmo <= 0 then
							if cache.vehicle then
								TaskSwapWeapon(playerPed, true)
							end

							currentWeapon.timer = GetGameTimer() + 200
						else currentWeapon.timer = GetGameTimer() + 200 end
					end
				elseif currentWeapon.throwable then
					if not invBusy and IsControlPressed(0, 24) then
						invBusy = 1

						CreateThread(function()
							local weapon = currentWeapon

							while currentWeapon and (not IsPedWeaponReadyToShoot(cache.ped) or IsDisabledControlPressed(0, 24)) and GetSelectedPedWeapon(playerPed) == weapon.hash do
								Wait(0)
							end

							if GetSelectedPedWeapon(playerPed) == weapon.hash then Wait(700) end

							while IsPedPlantingBomb(playerPed) do Wait(0) end

							TriggerServerEvent('ox_inventory:updateWeapon', 'throw', nil, weapon.slot)

							plyState.invBusy = false
							currentWeapon = nil

							RemoveWeaponFromPed(playerPed, weapon.hash)
							TriggerEvent('ox_inventory:currentWeapon')
						end)
					end
				elseif IsControlJustReleased(0, 24) and IsPedPerformingMeleeAction(playerPed) then
					currentWeapon.melee += 1
					currentWeapon.timer = GetGameTimer() + 200
				end
			end
		end
	end)

	plyState:set('invBusy', false, false)
	plyState:set('invOpen', false, false)
	plyState:set('invHotkeys', true, false)
	collectgarbage('collect')
end)

AddEventHandler('onResourceStop', function(resourceName)
	if shared.resource == resourceName then
		client.onLogout()
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
		if data.slot ~= currentWeapon.slot then return lib.notify({ id = 'weapon_hand_wrong', type = 'error', description = locale('weapon_hand_wrong') }) end
		local itemSlot = PlayerData.inventory[currentWeapon.slot]
		for _, component in pairs(Items[data.component].client.component) do
			if HasPedGotWeaponComponent(playerPed, currentWeapon.hash, component) then
				RemoveWeaponComponentFromPed(playerPed, currentWeapon.hash, component)
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

RegisterNUICallback('removeAmmo', function(slot, cb)
	cb(1)
	local slotData = PlayerData.inventory[slot]

	if not slotData or not slotData.metadata.ammo or slotData.metadata.ammo == 0 then return end

	local success = lib.callback.await('ox_inventory:removeAmmoFromWeapon', false, slot)

	if success and slot == currentWeapon?.slot then
		slotData.metadata.ammo = 0
		SetPedAmmo(playerPed, currentWeapon.hash, 0)
	end
end)

RegisterNUICallback('useItem', function(slot, cb)
	useSlot(slot --[[@as number]])
	cb(1)
end)

RegisterNUICallback('giveItem', function(data, cb)
	cb(1)
	local target

	if client.giveplayerlist then
		local nearbyPlayers, n = lib.getNearbyPlayers(GetEntityCoords(playerPed), 2.0), 0

		if #nearbyPlayers == 0 then return end

		for i = 1, #nearbyPlayers do
			local option = nearbyPlayers[i]
			local ped = GetPlayerPed(option.id)

			if ped > 0 and IsEntityVisible(ped) then
				local playerName = GetPlayerName(option.id)
				option.id = GetPlayerServerId(option.id)
				option.label = ('[%s] %s'):format(option.id, playerName)
				n += 1
				nearbyPlayers[n] = option
			end
		end

		local p = promise.new()

		lib.registerMenu({
			id = 'ox_inventory:givePlayerList',
			title = 'Give item',
			options = nearbyPlayers,
			onClose = function() p:resolve() end,
		}, function(selected) p:resolve(selected and nearbyPlayers[selected].id) end)

		lib.showMenu('ox_inventory:givePlayerList')

		target = Citizen.Await(p)
	elseif cache.vehicle then
		local seats = GetVehicleMaxNumberOfPassengers(cache.vehicle) - 1

		if seats >= 0 then
			local passenger = GetPedInVehicleSeat(cache.vehicle, cache.seat - 2 * (cache.seat % 2) + 1)

			if passenger ~= 0 and IsEntityVisible(passenger) then
				target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(passenger))
			end
		end
	else
		local entity = Utils.Raycast(12)

		if entity and IsPedAPlayer(entity) and IsEntityVisible(entity) and #(GetEntityCoords(playerPed, true) - GetEntityCoords(entity, true)) < 2.0 then
			target = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))
			Utils.PlayAnim(0, 'mp_common', 'givetake1_a', 1.0, 1.0, 2000, 50, 0.0, 0, 0, 0)
		end
	end

	if target then
		if data.slot == currentWeapon?.slot then
			currentWeapon = Weapon.Disarm(currentWeapon)
		end

		TriggerServerEvent('ox_inventory:giveItem', data.slot, target, data.count)
	end
end)

RegisterNUICallback('useButton', function(data, cb)
	useButton(data.id, data.slot)
	cb(1)
end)

RegisterNUICallback('exit', function(_, cb)
	client.closeInventory()
	cb(1)
end)

lib.callback.register('ox_inventory:startCrafting', function(id, recipe)
	recipe = client.craftingBenches[id].items[recipe]

	return lib.progressCircle({
		label = locale('crafting_item', Items[recipe.name].label),
		duration = recipe.duration or 3000,
		canCancel = true,
		disable = {
			move = true,
			combat = true,
		},
		anim = {
			dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
			clip = 'machinic_loop_mechandplayer',
		}
	})
end)

---Synchronise and validate all item movement between the NUI and server.
RegisterNUICallback('swapItems', function(data, cb)
	if data.toType == 'newdrop' and cache.vehicle then
        return cb(false)
    end

	if currentInstance then
		data.instance = currentInstance
	end

	if currentWeapon and data.fromType ~= data.toType then
		if (data.fromType == 'player' and data.fromSlot == currentWeapon.slot) or (data.toType == 'player' and data.toSlot == currentWeapon.slot) then
			currentWeapon = Weapon.Disarm(currentWeapon, true)
		end
	end

	local success, response, weaponSlot = lib.callback.await('ox_inventory:swapItems', false, data)

	if success then
		if response then
			updateInventory(response.items, response.weight)

			if weaponSlot and currentWeapon then
				currentWeapon.slot = weaponSlot
				TriggerEvent('ox_inventory:currentWeapon', currentWeapon)
			end
		end
	elseif response then
		lib.notify({ type = 'error', description = locale(response) })
	end

	if data.toType == 'newdrop' then
		Wait(50)
	end

	cb(success or false)
end)

RegisterNUICallback('buyItem', function(data, cb)
	local response, data, message = lib.callback.await('ox_inventory:buyItem', 100, data)

	if data then
		updateInventory({[data[1]] = data[2]}, data[4])
		SendNUIMessage({ action = 'refreshSlots', data = data[3] and {items = {{item = data[2]}, {item = data[3], inventory = 'shop'}}} or {items = {item = data[2]}}})
	end

	if message then
		lib.notify(message)
	end

	cb(response)
end)

RegisterNUICallback('craftItem', function(data, cb)
	cb(true)

	local id, index = currentInventory.id, currentInventory.index
	local success, response = lib.callback.await('ox_inventory:craftItem', 200, currentInventory.id, currentInventory.index, data.fromSlot, data.toSlot)

	if not success then
		lib.notify({ type = 'error', description = locale(response or 'cannot_perform') })
	end

	if not currentInventory or currentInventory.type ~= 'crafting' then
		client.openInventory('crafting', { id = id, index = index })
	end
end)

lib.callback.register('ox_inventory:getVehicleData', function(netid)
	local entity = NetworkGetEntityFromNetworkId(netid)

	if entity then
		return GetEntityModel(entity), GetVehicleClass(entity)
	end
end)
