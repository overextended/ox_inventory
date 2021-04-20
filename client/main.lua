local Blips = {}
local Drops = {}
local Usables = {}
local currentDrop
local currentWeapon
local weaponTimer = 0

ClearWeapons = function()
	SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
	for k, v in pairs(Config.AmmoType) do
		SetPedAmmo(playerPed, k, 0)
	end
	RemoveAllPedWeapons(playerPed, true)
	SetPedCanSwitchWeapon(playerPed, false)
end

DisarmPlayer = function(weapon)
	currentWeapon.metadata.ammo = GetAmmoInPedWeapon(playerPed, currentWeapon.hash)
	SetPedAmmo(playerPed, currentWeapon.hash, 0)
	SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
	RemoveWeaponFromPed(playerPed, currentWeapon.hash)
	TriggerServerEvent('linden_inventory:updateWeapon', currentWeapon)
	TriggerEvent('linden_inventory:currentWeapon', nil)
end

error = function(msg)
	TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = msg, length = 2500})
end

inform = function(msg)
	TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = msg, length = 2500})
end

StartInventory = function()
	playerID, playerPed, invOpen, isDead, isCuffed, isBusy, usingWeapon, currentDrop = nil, nil, false, false, false, false, false, nil
	ESX.TriggerServerCallback('linden_inventory:setup',function(data)
		ESX.SetPlayerData('inventory', data.inventory)
		ESX.PlayerData = ESX.GetPlayerData()
		playerPed = PlayerPedId()
		playerCoords = GetEntityCoords(playerPed)
		playerID = GetPlayerServerId(PlayerId())
		playerName = data.name
		Drops = data.drops
		Usables = data.usables
		inventoryLabel = playerName..' ['..playerID..'] '--[[..ESX.PlayerData.job.grade_label]]
		PlayerLoaded = true
		ClearWeapons()
		inform("Inventory is ready to use")
		TriggerLoops()
		if next(Blips) then
			for k, v in pairs(Blips) do
				RemoveBlip(v)
			end
			Blips = {}
		end
		for k, v in pairs(Config.Shops) do
			if (not Config.Shops[k].job or Config.Shops[k].job == ESX.PlayerData.job.name) then
				local name, data = 'Shop'
				if v.type then data = v.type.blip else data =  Config.General.blip end
				Blips[k] = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
				SetBlipSprite(Blips[k], data.id)
				SetBlipDisplay(Blips[k], 4)
				SetBlipScale(Blips[k], data.scale)
				SetBlipColour(Blips[k], data.colour)
				SetBlipAsShortRange(Blips[k], true)
				BeginTextCommandSetBlipName('STRING')
				AddTextComponentString(name)
				EndTextCommandSetBlipName(Blips[k])
			end
		end
	end)
end
if ESX.IsPlayerLoaded() then StartInventory() end

CanOpenInventory = function()
	if PlayerLoaded and not isBusy and weaponTimer < 250 and not isDead and not isCuffed and not IsPauseMenuActive() then
		--if IsPedDeadOrDying(playerPed, 1) then return false end
		return true
	else return false end
end

CanOpenTarget = function(searchPlayerPed)
	if IsPedDeadOrDying(searchPlayerPed, 1)
	or IsEntityPlayingAnim(searchPlayerPed, 'random@mugging3', 'handsup_standing_base', 3)
	or IsEntityPlayingAnim(searchPlayerPed, 'missminuteman_1ig_2', 'handsup_base', 3)
	or IsEntityPlayingAnim(searchPlayerPed, 'missminuteman_1ig_2', 'handsup_enter', 3)
	or IsEntityPlayingAnim(searchPlayerPed, 'dead', 'dead_a', 3)
	or IsEntityPlayingAnim(searchPlayerPed, 'mp_arresting', 'idle', 3)
	then return true
	else return false end
end

OpenTargetInventory = function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 1.2 then
		local searchPlayerPed = GetPlayerPed(closestPlayer)
		if CanOpenTarget(searchPlayerPed) then
			TriggerServerEvent('linden_inventory:openTargetInventory', GetPlayerServerId(closestPlayer))
		else
			error("You can not open this inventory")
		end
	end
end
exports('OpenTargetInventory', OpenTargetInventory)

DrawText3D = function(coords, text)
	SetDrawOrigin(coords)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextEntry('STRING')
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(0.0, 0.0)
	DrawRect(0.0, 0.0125, 0.015 + text:gsub('~.-~', ''):len() / 370, 0.03, 45, 45, 45, 150)
	ClearDrawOrigin()
end

loadAnimDict = function(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

RegisterNetEvent('randPickupAnim')
AddEventHandler('randPickupAnim', function()
	loadAnimDict('pickup_object')
	TaskPlayAnim(playerPed,'pickup_object', 'putdown_low',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
	Wait(1000)
	ClearPedSecondaryTask(playerPed)
end)

OpenShop = function(id)
	if not invOpen and CanOpenInventory() and not CanOpenTarget(playerPed) then
		TriggerServerEvent('linden_inventory:openInventory', {type = 'shop', id = id })
	end
end

OpenStash = function(data)
	if not invOpen and CanOpenInventory() and not CanOpenTarget(playerPed) then
		TriggerServerEvent('linden_inventory:openInventory', {type = 'stash', id = data.name, owner = data.owner, slots = data.slots, coords = data.coords, job = data.job  })
	end
end
exports('OpenStash', OpenStash)

OpenGloveBox = function(gloveboxid, class)
	local slots, weight = Config.Gloveboxes[class][1], Config.Gloveboxes[class][2]
	if slots then TriggerServerEvent('linden_inventory:openInventory', {type = 'glovebox',id  = 'glovebox-'..gloveboxid, slots = slots, maxWeight = weight}) end
end

OpenTrunk = function(trunkid, class)
	local slots, weight = Config.Trunks[class][1], Config.Trunks[class][2]
	if slots then TriggerServerEvent('linden_inventory:openInventory', {type = 'trunk',id  = 'trunk-'..trunkid, slots = slots, maxWeight = weight}) end
end

CloseVehicle = function(veh)
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
	SetVehicleDoorShut(veh, open, false)
	CloseToVehicle = false
	lastVehicle = nil
end

WeightActions = function(current, max)
	local difference = max - current
	if current > (max-5000) then
		--
	else
		--
	end
end

local nui_focus = {false, false}
SetNuiFocusAdvanced = function(hasFocus, hasCursor, allowMovement)
	SetNuiFocus(hasFocus, hasCursor)
	SetNuiFocusKeepInput(hasFocus)
	nui_focus = {hasFocus, hasCursor}
	TriggerEvent('nui:focus', hasFocus, hasCursor)

	if nui_focus[1] then
		if Config.EnableBlur then TriggerScreenblurFadeIn(0) end
		Citizen.CreateThread(function()
			local ticks = 0
			while true do
				Citizen.Wait(3)
				DisableAllControlActions(0)
				if not nui_focus[2] then
					EnableControlAction(0, 1, true)
					EnableControlAction(0, 2, true)
				end
				EnableControlAction(0, 249, true) -- N for PTT
				EnableControlAction(0, 20, true) -- Z for proximity
				if allowMovement and not currentInventory then
					EnableControlAction(0, 30, true) -- movement
					EnableControlAction(0, 31, true) -- movement
				end
				if not nui_focus[1] then
					ticks = ticks + 1
					if (IsDisabledControlJustReleased(0, 200, true) or ticks > 20) then
						currentInventory = nil
						if Config.EnableBlur then TriggerScreenblurFadeOut(0) end
						break
					end
				end
			end
		end)
	end
end

RegisterNetEvent('linden_inventory:openInventory')
AddEventHandler('linden_inventory:openInventory',function(data, rightinventory)
	if CanOpenInventory() then
		movement = false
		invOpen = true
		SendNUIMessage({
			message = 'openinventory',
			inventory = data.inventory,
			slots = data.slots,
			name = inventoryLabel,
			maxWeight = data.maxWeight,
			weight = data.weight,
			rightinventory = rightinventory
		})
		ESX.PlayerData.inventory = data.inventory
		if not rightinventory then movement = true else movement = false end
		SetNuiFocusAdvanced(true, true, movement)
		currentInventory = rightinventory
	end
end)

RegisterNetEvent('linden_inventory:refreshInventory')
AddEventHandler('linden_inventory:refreshInventory', function(data)
	SendNUIMessage({
		message = 'refresh',
		inventory = data.inventory,
		slots = data.slots,
		name = inventoryLabel,
		maxWeight = data.maxWeight,
		weight = data.weight
	})
	ESX.PlayerData.inventory = data.inventory
	ESX.SetPlayerData('inventory', data.inventory)
end)

RegisterNetEvent('linden_inventory:itemNotify')
AddEventHandler('linden_inventory:itemNotify', function(item, count, slot, notify)
	if count > 0 then notification = ('%s %sx'):format(notify, count)
	else notification = 'Used' end
	if type(slot) == 'table' then
		for k,v in pairs(slot) do
			ESX.PlayerData.inventory[k] = item
			if notify == 'Removed' and ESX.PlayerData.inventory[k].count then
				local count = ESX.PlayerData.inventory[k].count - v
				ESX.PlayerData.inventory[k].count = count
				if item.name:find('WEAPON_') then TriggerEvent('linden_inventory:checkWeapon', item) end
			end
		end
	else
		ESX.PlayerData.inventory[slot] = item
		if notify == 'Removed' then
			local count = ESX.PlayerData.inventory[slot].count - count
			ESX.PlayerData.inventory[slot].count = count
			if item.name:find('WEAPON_') then TriggerEvent('linden_inventory:checkWeapon', item) end
		end
	end
	ESX.SetPlayerData('inventory', ESX.PlayerData.inventory)
	SendNUIMessage({ message = 'notify', item = item, text = notification })
end)

RegisterNetEvent('linden_inventory:updateStorage')
AddEventHandler('linden_inventory:updateStorage', function(data)
	if Config.WeightActions then WeightActions(data[1], data[2]) end
end)

RegisterNetEvent('linden_inventory:createDrop')
AddEventHandler('linden_inventory:createDrop', function(data, owner)
	Drops[data.name] = data
	Drops[data.name].coords = vector3(data.coords.x, data.coords.y,data.coords.z - 0.2)
	Citizen.Wait(0)
	if owner == playerID then TriggerServerEvent('linden_inventory:openInventory', {type = 'drop', drop = data.name }) end
end)

RegisterNetEvent('linden_inventory:removeDrop')
AddEventHandler('linden_inventory:removeDrop', function(id, owner)
	Drops[id] = nil
	if currentDrop and currentDrop.name == id then currentDrop = nil end
	Citizen.Wait(0)
	if owner == playerID then TriggerServerEvent('linden_inventory:openInventory', {type = 'drop', drop = {} }) end
end)

HolsterWeapon = function(item)
	ClearPedSecondaryTask(playerPed)
	loadAnimDict('reaction@intimidation@1h')
	TaskPlayAnimAdvanced(playerPed, 'reaction@intimidation@1h', 'outro', GetEntityCoords(playerPed, true), 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, -1, 50, 0, 0, 0)
	Citizen.Wait(1600)
	DisarmPlayer()
	ClearPedSecondaryTask(playerPed)
	SetPedUsingActionMode(playerPed, -1, -1, 1)
	SendNUIMessage({ message = 'notify', item = item, text = 'Holstered' })
end

DrawWeapon = function(item)
	ClearPedSecondaryTask(playerPed)
	if ESX.PlayerData.job.name == 'police' then
		loadAnimDict('reaction@intimidation@cop@unarmed')
		TaskPlayAnimAdvanced(playerPed, 'reaction@intimidation@cop@unarmed', 'intro', GetEntityCoords(playerPed, true), 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, -1, 50, 1, 0, 0)
	else
		loadAnimDict('reaction@intimidation@1h')
		TaskPlayAnimAdvanced(playerPed, 'reaction@intimidation@1h', 'intro', GetEntityCoords(playerPed, true), 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, -1, 50, 0, 0, 0)
		Citizen.Wait(800)
	end
	if currentWeapon then
		SetPedAmmo(playerPed, currentWeapon.hash, 0)
		SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
		RemoveWeaponFromPed(playerPed, currentWeapon.hash)
	end
	TriggerEvent('linden_inventory:currentWeapon', item)
	GiveWeaponToPed(playerPed, currentWeapon.hash, 0, true, false)
	Citizen.Wait(800)
	SendNUIMessage({ message = 'notify', item = item, text = 'Equipped' })
end

RegisterNetEvent('linden_inventory:weapon')
AddEventHandler('linden_inventory:weapon', function(item)
	if not isBusy then
		TriggerEvent('linden_inventory:busy', true)
		local newWeapon = item.metadata.serial
		local found, wepHash = GetCurrentPedWeapon(playerPed, true)
		if wepHash == -1569615261 then currentWeapon = nil end
		wepHash = GetHashKey(item.name)
		if currentWeapon and currentWeapon.metadata.serial == newWeapon then
			HolsterWeapon(item)
			TriggerEvent('linden_inventory:currentWeapon', nil)
		else
			item.hash = wepHash
			DrawWeapon(item)
			if currentWeapon.metadata.throwable then item.metadata.ammo = 1 end
			if not item.ammoType then
				local ammoType = GetAmmoType(item.name)
				if ammoType then item.ammoType = ammoType end
			end
			currentWeapon = item
			SetCurrentPedWeapon(playerPed, currentWeapon.hash)
			SetPedCurrentWeaponVisible(playerPed, true, false, false, false)
			if item.metadata.weapontint then SetPedWeaponTintIndex(playerPed, item.name, item.metadata.weapontint) end
			if item.metadata.components then
				for k,v in pairs(item.metadata.components) do
					local componentHash = ESX.GetWeaponComponent(item.name, v).hash
					if componentHash then GiveWeaponComponentToPed(playerPed, wepHash, componentHash) end
				end
			end
			SetAmmoInClip(playerPed, currentWeapon.hash, item.metadata.ammo)
			if currentWeapon.name == 'WEAPON_FIREEXTINGUISHER' or currentWeapon.name == 'WEAPON_PETROLCAN' then SetAmmoInClip(playerPed, currentWeapon.hash, 10000) end
			TriggerEvent('linden_inventory:currentWeapon', currentWeapon)
		end
		ClearPedSecondaryTask(playerPed)
		TriggerEvent('linden_inventory:busy', false)
	end
end)

AddEventHandler('linden_inventory:usedWeapon',function()
	weaponTimer = (100 * 3)
end)

AddEventHandler('linden_inventory:currentWeapon', function(weapon)
	currentWeapon = weapon
end)

RegisterNetEvent('linden_inventory:checkWeapon')
AddEventHandler('linden_inventory:checkWeapon', function(item)
	if currentWeapon and currentWeapon.metadata.serial == item.metadata.serial then
		DisarmPlayer()
	end
end)

RegisterNetEvent('linden_inventory:addAmmo')
AddEventHandler('linden_inventory:addAmmo', function(ammo)
	if currentWeapon and not isBusy then
		if currentWeapon.ammoType == ammo.name then
			local maxAmmo = GetWeaponClipSize(currentWeapon.hash)
			local curAmmo = GetAmmoInPedWeapon(playerPed, currentWeapon.hash)
			if curAmmo > maxAmmo then SetPedAmmo(playerPed, currentWeapon.hash, maxAmmo) elseif curAmmo == maxAmmo then return
			else
				isBusy = true
				local newAmmo = 0
				if curAmmo < maxAmmo then missingAmmo = maxAmmo - curAmmo end
				if missingAmmo > ammo.count then newAmmo = ammo.count + curAmmo
				else newAmmo = maxAmmo end
				if newAmmo < 0 then newAmmo = 0 end
				SetPedAmmo(playerPed, currentWeapon.hash, newAmmo)
				MakePedReload(playerPed)
				TriggerServerEvent('linden_inventory:addweaponAmmo', currentWeapon, curAmmo, newAmmo)
				isBusy = false
			end
		else
			error("You can't load the "..currentWeapon.label.." with "..ammo.label.." ammo")
		end
	end
end)

RegisterNetEvent('linden_inventory:updateWeapon')
AddEventHandler('linden_inventory:updateWeapon',function(data)
	if currentWeapon then
		currentWeapon.metadata = data
		if currentWeapon.metadata.durability <= 0 then DisarmPlayer() end
	end
end)

AddEventHandler('linden_inventory:busy',function(busy)
	isBusy = busy
	if isBusy and invOpen then TriggerEvent('linden_inventory:closeInventory') end
end)

RegisterNetEvent('linden_inventory:closeInventory')
AddEventHandler('linden_inventory:closeInventory',function()
	SendNUIMessage({
		message = 'close',
	})
end)

AddEventHandler('onResourceStop', function(resourceName)
	if invOpen and GetCurrentResourceName() == resourceName then
		TriggerScreenblurFadeOut(0)
		SetNuiFocusAdvanced(false, false)
	end
end)

TriggerLoops = function()
	Citizen.CreateThread(function()
		local Keys = {157, 158, 160, 164, 165}
		local Disable = {37, 157, 158, 160, 164, 165, 289}
		local wait = false
		while PlayerLoaded do
			sleep = 5
			for i=1, #Disable, 1 do
				DisableControlAction(0, Disable[i], true)
			end
			for i = 19, 20 do
				HideHudComponentThisFrame(i)
			end
			if isBusy then
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 25, true)
				DisableControlAction(0, 142, true)
				DisableControlAction(0, 257, true)
			elseif not invOpen and not wait and CanOpenInventory() then
				for i=1, #Keys, 1 do
					if not isBusy and IsDisabledControlJustReleased(0, Keys[i]) and ESX.PlayerData.inventory[i] then
						if Usables[ESX.PlayerData.inventory[i].name] then
							TriggerServerEvent('linden_inventory:useSlotItem', i)
						end
					end
				end
			end
			if weaponTimer == 3 and currentWeapon then
				TriggerServerEvent('linden_inventory:updateWeapon', currentWeapon)
				weaponTimer = 0
			elseif weaponTimer > 3 then weaponTimer = weaponTimer - 3 end
			if not invOpen and currentWeapon then
				if IsPedArmed(playerPed, 6) then
					DisableControlAction(1, 140, true)
					DisableControlAction(1, 141, true)
					DisableControlAction(1, 142, true)
				end
				usingWeapon = IsPedShooting(playerPed)
				if usingWeapon then
					local currentAmmo = GetAmmoInPedWeapon(playerPed, currentWeapon.hash)
					if currentWeapon.name == 'WEAPON_FIREEXTINGUISHER' or currentWeapon.name == 'WEAPON_PETROLCAN' and not wait then
						currentWeapon.metadata.durability = currentWeapon.metadata.durability - 0.1
						if currentWeapon.metadata.durability <= 0 then
							Citizen.CreateThread(function()
								wait = true
								ClearPedTasks(playerPed)
								SetCurrentPedWeapon(playerPed, currentWeapon.hash, true)
								TriggerServerEvent('linden_inventory:updateWeapon', currentWeapon)
								Citizen.Wait(200)
								SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
								currentWeapon = nil
								wait = false
							end)
						end
					elseif currentWeapon.ammoType then
						currentWeapon.metadata.ammo = currentAmmo
						if currentAmmo == 0 then
							if Config.AutoReload then
								weaponTimer = 0
								TriggerServerEvent('linden_inventory:reloadWeapon', currentWeapon)
							end
							ClearPedTasks(playerPed)
							SetCurrentPedWeapon(playerPed, currentWeapon.hash, false)
							SetPedCurrentWeaponVisible(playerPed, true, false, false, false)
							
						else TriggerEvent('linden_inventory:usedWeapon', currentWeapon) end
					end
				else
					if currentWeapon.metadata.throwable and not wait and IsControlJustReleased(0, 24) then
						usingWeapon = true
						Citizen.CreateThread(function()
							wait = true
							Citizen.Wait(800)
							TriggerServerEvent('linden_inventory:updateWeapon', currentWeapon, 'throw')
							SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
							currentWeapon = nil
							wait = false
						end)
					elseif Config.Melee[currentWeapon.name] and not wait and IsPedInMeleeCombat(playerPed) and IsControlPressed(0, 24) then
						usingWeapon = true
						Citizen.CreateThread(function()
							wait = true
							TriggerServerEvent('linden_inventory:updateWeapon', currentWeapon, 'melee')
							TriggerEvent('linden_inventory:usedWeapon', currentWeapon)
							Citizen.Wait(400)
							wait = false
						end)
					else usingWeapon = false end
				end	
			end		
			Citizen.Wait(sleep)
		end
	end)

	Citizen.CreateThread(function()
		local text, type, id = ''
		while PlayerLoaded do
			local sleep = 250
			playerPed = PlayerPedId()
			playerCoords = GetEntityCoords(playerPed)
			if not invOpen then
				if not id or type == 'shop' then
					if id then
						sleep = 5
						DrawMarker(2, Config.Shops[id].coords.x,Config.Shops[id].coords.y,Config.Shops[id].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 150, 30, 222, false, false, false, true, false, false, false)			
						local distance = #(playerCoords - Config.Shops[id].coords)
						if distance <= 1 then text='[~g~E~s~] '..Config.Shops[id].name
							if IsControlJustPressed(0, 38) then
								OpenShop(id)
							end
						elseif distance > 4 then id, type = nil, nil
						else text = Config.Shops[id].name end
						if distance <= 2 then DrawText3D(Config.Shops[id].coords, text) end
					else
						for k, v in pairs(Config.Shops) do
							if v.coords and (not v.job or v.job == ESX.PlayerData.job.name) then
								local distance = #(playerCoords - v.coords)
								if distance <= 4 then
									sleep = 10
									id = k
									type = 'shop'
								end
							end
						end
					end
				end
				if not id or type == 'stash' then
					if id then
						sleep = 5
						DrawMarker(2, Config.Stashes[id].coords.x,Config.Stashes[id].coords.y,Config.Stashes[id].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 30, 150, 222, false, false, false, true, false, false, false)			
						local distance = #(playerCoords - Config.Stashes[id].coords)
						if distance <= 1 then text='[~g~E~s~] '..Config.Stashes[id].name
							if IsControlJustPressed(0, 38) then
								OpenStash(Config.Stashes[id])
							end
						elseif distance > 4 then id, type = nil, nil
						else text = Config.Stashes[id].name end
						if distance <= 2 then DrawText3D(Config.Stashes[id].coords, text) end
					else
						for k, v in pairs(Config.Stashes) do
							if v.coords and (not v.job or v.job == ESX.PlayerData.job.name) then
								local distance = #(playerCoords - v.coords)
								if distance <= 4 then
									sleep = 10
									id = k
									type = 'stash'
								end
							end
						end
					end
				end
				if Drops and not invOpen then
					local closestDrop
					for k, v in pairs(Drops) do
						if v.coords then
							local distance = #(playerCoords - v.coords)
							if distance <= 8 then
								sleep = 5
								DrawMarker(2, v.coords.x,v.coords.y,v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 150, 30, 30, 222, false, false, false, true, false, false, false)
								if distance <= 2 and (closestDrop == nil or (currentDrop and closestDrop and distance < currentDrop.distance)) then
									closestDrop = {name = v.name, distance = distance}
								end
							end
						end
					end
					if closestDrop then
						if closestDrop.distance <= 1 then currentDrop = {name=closestDrop.name, distance=closestDrop.distance} else currentDrop = nil end
					end
				end
				if Config.WeaponsLicense then
					local coords, text, license = vector3(12.42198, -1105.82, 29.7854), "Weapons License", 'weapon'
					local distance = #(playerCoords - coords)
					if distance <= 5 then
						sleep = 5
						DrawMarker(2, coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.15, 0.2, 30, 150, 30, 100, false, false, false, true, false, false, false)
						if not invOpen then
							if distance <= 1.5 then
								text = '[~g~E~s~] Purchase license'
								if IsControlJustPressed(1,38) then
									ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
										if hasWeaponLicense then
											error("You already have a Weapons License")
										else
											ESX.TriggerServerCallback('linden_inventory:buyLicense', function(bought)
												if bought then
													inform("You have purchased a Weapons License")
												else
													error("You can not afford a Weapons License")
												end
											end, license)
										end
									end, playerID, license)
									Citizen.Wait(500)
								end
							end   
							DrawText3D(coords, text)
						end
					end
				end
			else
				sleep = 100
				if not CanOpenInventory() then
					TriggerEvent('linden_inventory:closeInventory')
				elseif currentInventory then
					if string.find(currentInventory.name, 'Player') then
						local id = GetPlayerFromServerId(currentInventory.id)
						local ped = GetPlayerPed(id)
						local pedCoords = GetEntityCoords(ped)
						local dist = #(playerCoords - pedCoords)
						if not id or dist > 1.8 or not CanOpenTarget(ped) then
							TriggerEvent('linden_inventory:closeInventory')
							error("No longer able to access this inventory")
						end
					elseif not lastVehicle and currentInventory.coords then
						local dist = #(playerCoords - currentInventory.coords)
						if dist > 2 or CanOpenTarget(playerPed) then
							TriggerEvent('linden_inventory:closeInventory')
							error("No longer able to access this inventory")
						end
					end
				end
			end
			Citizen.Wait(sleep)
		end
	end)
end

RegisterCommand('inv', function()
	if isBusy or invOpen then error("You can't open your inventory right now") return end
	if CanOpenInventory() then
		TriggerEvent('randPickupAnim')
		if currentDrop then drop = currentDrop.name end
		TriggerServerEvent('linden_inventory:openInventory', {type = 'drop', drop = drop })
	end
end)

RegisterCommand('vehinv', function()
	if not PlayerLoaded then return end
	if not CanOpenInventory() or invOpen then error("You can't open your inventory right now") return end
	if not IsPedInAnyVehicle(playerPed, false) then -- trunk
		local vehicle, vehiclePos = ESX.Game.GetVehicleInDirection()
		if not vehiclePos then vehiclePos = GetEntityCoords(vehicle) end
		CloseToVehicle = false
		lastVehicle = nil
		local class = GetVehicleClass(vehicle)
		if vehicle and Config.Trunks[class] and #(playerCoords - vehiclePos) < 6 then
			if GetVehicleDoorLockStatus(vehicle) ~= 2 then
				local vehHash = GetEntityModel(vehicle)
				local checkVehicle = Config.VehicleStorage[vehHash]
				if checkVehicle == 1 then open, vehBone = 4, GetEntityBoneIndexByName(vehicle, 'bonnet')
				elseif checkVehicle == nil then open, vehBone = 5, GetEntityBoneIndexByName(vehicle, 'boot') elseif checkVehicle == 2 then open, vehBone = 5, GetEntityBoneIndexByName(vehicle, 'boot') else --[[no vehicle nearby]] return end
				
				if vehBone == -1 then
					vehBone = GetEntityBoneIndexByName(vehicle, 'wheel_rr')
				end
				
				vehiclePos = GetWorldPositionOfEntityBone(vehicle, vehBone)
				local pedDistance = #(playerCoords - vehiclePos)
				if (open == 5 and checkVehicle == nil) then if pedDistance < 2.0 then CloseToVehicle = true end elseif (open == 5 and checkVehicle == 2) then if pedDistance < 2.0 then CloseToVehicle = true end elseif open == 4 then if pedDistance < 2.0 then CloseToVehicle = true end end	
				if CloseToVehicle then
					local plate = GetVehicleNumberPlateText(vehicle)
					TaskTurnPedToFaceCoord(playerPed, vehiclePos)
					lastVehicle = vehicle
					OpenTrunk(plate, class)
					local timeout = 20
					while true do
						if currentInventory and currentInventory.type == 'trunk' then break end
						if timeout == 0 then
							CloseToVehicle = false
							lastVehicle = nil
							return
						end
						Citizen.Wait(50) timeout = timeout - 1
					end
					SetVehicleDoorOpen(vehicle, open, false, false)
					local animDict = 'anim@heists@prison_heiststation@cop_reactions'
					local anim = 'cop_b_idle'
					RequestAnimDict(animDict)
					while not HasAnimDictLoaded(animDict) do
						Citizen.Wait(100)
					end
					Citizen.Wait(200)
					TaskPlayAnim(playerPed, animDict, anim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
					Citizen.Wait(100)
					lastVehicle = vehicle
					while true do
						Citizen.Wait(50)
						if CloseToVehicle and invOpen then
							coords = GetEntityCoords(playerPed)
							local vehiclePos = GetWorldPositionOfEntityBone(vehicle, vehBone)
							local pedDistance = #(coords - vehiclePos)
							local isClose = false
							if pedDistance < 2.0 then isClose = true end
							if not DoesEntityExist(vehicle) or not isClose then
								break
							end
							TaskTurnPedToFaceCoord(playerPed, vehiclePos)
						else
							break
						end
					end
					if lastVehicle then TriggerEvent('linden_inventory:closeInventory') end
					return
				end
			else
				error("Vehicle is locked")
			end
		end
	elseif IsPedInAnyVehicle(playerPed, false) then -- glovebox
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local plate = GetVehicleNumberPlateText(vehicle)
		local class = GetVehicleClass(vehicle)
		OpenGloveBox(plate, class)
		Citizen.Wait(100)
		while true do
			Citizen.Wait(100)
			if not invOpen then break
			elseif not IsPedInAnyVehicle(playerPed, false) then
				TriggerEvent('linden_inventory:closeInventory')
				break
			end
		end
	end
end)

RegisterCommand('hotbar', function()
	local data = {}
	for i=1, 5 do
		if ESX.PlayerData.inventory[i] then data[i] = ESX.PlayerData.inventory[i] end
	end
	SendNUIMessage({
		message = 'hotbar',
		items = data
	})
end)
RegisterKeyMapping('hotbar', 'Display inventory hotbar', 'keyboard', 'tab')
		
RegisterKeyMapping('inv', 'Open player inventory', 'keyboard', Config.InventoryKey)
RegisterKeyMapping('vehinv', 'Open vehicle inventory', 'keyboard', Config.VehicleInventoryKey)

RegisterCommand('steal', function()
	if not IsPedInAnyVehicle(playerPed, true) and not invOpen and CanOpenInventory() then	 
		OpenTargetInventory()
	end
end)

RegisterCommand('-nui', function()
	TriggerEvent('linden_inventory:closeInventory')
end)

RegisterNUICallback('devtool', function()
	TriggerServerEvent('linden_inventory:devtool')
end)

RegisterNUICallback('notification', function(data)
	if data.type == 2 then error(data.message) else inform(data.message) end
end)

RegisterNUICallback('useItem', function(data, cb)
	if data.inv == 'Playerinv' and Usables[data.item.name] then TriggerServerEvent('linden_inventory:useItem', data.item) end
end)

RegisterNUICallback('giveItem', function(data, cb)
	local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer == -1 or closestPlayerDistance > 2.0 then 
		error('There is nobody nearby')
	elseif data.inv == 'Playerinv' then
		if data.amount >= 1 then
			TriggerServerEvent('linden_inventory:giveItem', data, GetPlayerServerId(closestPlayer))
		else error('You must enter an amount to give') end
	end
end)

RegisterNUICallback('saveinventorydata',function(data)
	TriggerServerEvent('linden_inventory:saveInventoryData', data)
end)

RegisterNUICallback('BuyFromShop', function(data)
	if data.count >= 1 then
		TriggerServerEvent('linden_inventory:buyItem', data)
	else error('You must select an amount to buy') end
end)

RegisterNUICallback('exit',function(data)
	TriggerScreenblurFadeOut(0)
	if lastVehicle then
		CloseVehicle(lastVehicle)
	end
	TriggerServerEvent('linden_inventory:saveInventory', data)
	currentInventory = nil
	SetNuiFocusAdvanced(false, false)
	invOpen = false
end)


local useItemCooldown = false
RegisterNetEvent('linden_inventory:useItem')
AddEventHandler('linden_inventory:useItem',function(item)
	if CanOpenInventory() and not useItemCooldown then
		useItemCooldown = true
		ESX.SetTimeout(500, function()
			useItemCooldown = false
		end)
		local data = Config.ItemList[item.name]
		if not data or not next(data) then return end

		if data.component then
			if not currentWeapon then isBusy = false return end
			local result, esxWeapon = ESX.GetWeapon(currentWeapon.name)
				
			for k,v in ipairs(esxWeapon.components) do
				for k2, v2 in pairs(data.component) do
					if v.hash == v2 then
						component = {name = v.name, hash = v2}
						break
					end
				end
			end
			if not component then error("This weapon is incompatible with "..item.label) isBusy = false return end
			if HasPedGotWeaponComponent(playerPed, currentWeapon.hash, component.hash) then
				error("This weapon already has a "..item.label) isBusy = false return
			end
		end

		ESX.TriggerServerCallback('linden_inventory:usingItem', function(xItem)
			if xItem then
				if data.dofirst then TriggerEvent(data.dofirst) end
				if data.useTime and data.useTime >= 0 then
					isBusy = true
					if not data.animDict or not data.anim then
						data.animDict = 'pickup_object'
						data.anim = 'putdown_low'
					end
					if not data.flags then data.flags = 48 end
					
					exports['mythic_progbar']:Progress({
						name = 'useitem',
						duration = data.useTime,
						label = 'Using '..xItem.label,
						useWhileDead = false,
						canCancel = false,
						controlDisables = { disableMovement = data.disableMove, disableCarMovement = false, disableMouse = false, disableCombat = true },
						animation = { animDict = data.animDict, anim = data.anim, flags = data.flags },
						prop = { model = data.model, coords = data.coords, rotation = data.rotation }
					}, function() isBusy = false end)
				else isBusy = false end
				Citizen.Wait(data.useTime)
		
				if data.hunger then
					if data.hunger > 0 then TriggerEvent('esx_status:add', 'hunger', data.hunger)
					else TriggerEvent('esx_status:remove', 'hunger', data.hunger) end
				end
				if data.thirst then
					if data.thirst > 0 then TriggerEvent('esx_status:add', 'thirst', data.thirst)
					else TriggerEvent('esx_status:remove', 'thirst', data.thirst) end
				end
				if data.stress then
					if data.stress > 0 then TriggerEvent('esx_status:add', 'stress', data.stress)
					else TriggerEvent('esx_status:remove', 'stress', data.stress) end
				end
				if data.drunk then
					if data.drunk > 0 then TriggerEvent('esx_status:add', 'drunk', data.drunk)
					else TriggerEvent('esx_status:remove', 'drunk', data.drunk) end
				end

				if data.component then
					GiveWeaponComponentToPed(playerPed, currentWeapon.name, component.hash)
					table.insert(currentWeapon.metadata.components, component.name)
					TriggerServerEvent('linden_inventory:updateWeapon', currentWeapon, component.name)
				end

				if data.event then TriggerEvent(data.event) end

				isBusy = false
			end
		end, item.name, item.slot, item.metadata)
	end
end)
