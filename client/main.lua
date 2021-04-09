ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Blips = {}
local Drops = {}
local currentDrop = {}
local Keys = {157, 158, 160, 164, 165}
local currentWeapon = nil


local ClearWeapons = function()
	SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
	for k, v in pairs(Config.AmmoType) do
		SetPedAmmo(playerPed, k, 0)
	end
	RemoveAllPedWeapons(playerPed, true)
	SetPedCanSwitchWeapon(playerPed, false)
end

local DisarmPlayer = function(weapon)
	currentWeapon.metadata.ammo = GetAmmoInPedWeapon(playerPed, currentWeapon.hash)
	SetPedAmmo(playerPed, currentWeapon.hash, 0)
	SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
	RemoveWeaponFromPed(playerPed, currentWeapon.hash)
	TriggerServerEvent('linden_inventory:updateWeapon', currentWeapon)
	TriggerEvent('linden_inventory:currentWeapon', nil)
end

local error = function(msg)
	TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = msg, length = 2500})
end

local inform = function(msg)
	TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = msg, length = 2500})
end

local StartInventory = function()
	if next(Blips) then
		for k, v in pairs(Blips) do
			RemoveBlip(v)
		end
		Blips = {}
	end
	playerID, playerPed, invOpen, isDead, isCuffed, isBusy, isShooting, usingWeapon, weight, currentDrop = nil, nil, false, false, false, false, false, false, Config.PlayerWeight, {}
	ESX.TriggerServerCallback('linden_inventory:setup',function(data)
		ESX.PlayerData = ESX.GetPlayerData()
		playerPed = PlayerPedId()
		playerID = data.playerID
		playerName = data.name
		Drops = data.drops
		ClearWeapons()
		inform("Inventory is ready to use")
		for k, v in pairs(Config.Shops) do
			if (not Config.Shops[k].job or Config.Shops[k].job == ESX.PlayerData.job.name) then
				local name, data = 'Shop', {}
				if v.type then
					name = v.name
					if v.type == 'weapon' then data = Config.Ammunation.blip
					elseif v.type == 'tool' then data = Config.YouTool.blip
					elseif v.type == 'liquor' then data = Config.Liquor.blip end
				else
					data = Config.General.blip
				end
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

local CanOpenInventory = function()
	if playerName and not isBusy and not isShooting and not isDead and not isCuffed and not IsPedDeadOrDying(playerPed, 1) and not IsPauseMenuActive() then return true end
	return false
end

local CanOpenTarget = function(searchPlayerPed)
	if IsPedDeadOrDying(searchPlayerPed, 1)
	or IsEntityPlayingAnim(searchPlayerPed, 'random@mugging3', 'handsup_standing_base', 3)
	or IsEntityPlayingAnim(searchPlayerPed, 'missminuteman_1ig_2', 'handsup_base', 3)
	or IsEntityPlayingAnim(searchPlayerPed, 'dead', 'dead_a', 3)
	or IsEntityPlayingAnim(searchPlayerPed, 'mp_arresting', 'idle', 3)
	then return true
	else return false end
end

local OpenTargetInventory = function()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer ~= -1 and closestDistance <= 1.2 then
		local searchPlayerPed = GetPlayerPed(closestPlayer)
		if CanOpenTarget(searchPlayerPed) then
			TriggerServerEvent('linden_inventory:openTargetInventory', GetPlayerServerId(closestPlayer))
		else
			error("You can not open this inventory")
		end
	else
		error("You can not open this inventory")
	end
end
exports('OpenTargetInventory', OpenTargetInventory)

local DrawText3D = function(coords, text)
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

local loadAnimDict = function(dict)
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

local OpenShop = function(id)
	if not invOpen and CanOpenInventory() and not CanOpenTarget(playerPed) then
		TriggerServerEvent('linden_inventory:openInventory', {type = 'shop', id = id })
	end
end

local OpenStash = function(data)
	if not invOpen and CanOpenInventory() and not CanOpenTarget(playerPed) then
		TriggerServerEvent('linden_inventory:openInventory', {type = 'stash', id = data.name, slots = data.slots, coords = data.coords, job = data.job  })
	end
end
exports('OpenStash', OpenStash)

OpenGloveBox = function(gloveboxid, class)
	local storage = Config.GloveboxSlots[class]
	if storage then TriggerServerEvent('linden_inventory:openInventory', {type = 'glovebox',id  = 'glovebox-'..gloveboxid, slots = storage}) end
end

OpenTrunk = function(trunkid, class)
	local storage = Config.TrunkSlots[class]
	if storage then TriggerServerEvent('linden_inventory:openInventory', {type = 'trunk',id  = 'trunk-'..trunkid, slots = storage}) end
end

local CloseVehicle = function(veh)
	local animDict = 'anim@heists@fleeca_bank@scope_out@return_case'
	local anim = 'trevor_action'
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(100)
	end
	ClearPedTasks(playerPed)
	Citizen.Wait(100)
	TaskPlayAnimAdvanced(playerPed, animDict, anim, GetEntityCoords(playerPed, true), 0, 0, GetEntityHeading(playerPed), 2.0, 2.0, 1000, 49, 0.25, 0, 0)
	Citizen.Wait(1000)
	ClearPedTasks(playerPed)
	SetVehicleDoorShut(veh, open, false)
	CloseToVehicle = false
	lastVehicle = nil
end

local nui_focus = {false, false}
local SetNuiFocusAdvanced = function(hasFocus, hasCursor, allowMovement)
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
						invOpen = false
						currentInventory = nil
						if Config.EnableBlur then TriggerScreenblurFadeOut(0) end
						break
					end
				end
			end
		end)
	end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
	StartInventory()
end)

RegisterNetEvent('linden_inventory:forceStart')
AddEventHandler('linden_inventory:forceStart', function()
	StartInventory()
end)

AddEventHandler('esx:onPlayerSpawn', function(spawn)
	isDead = false
end)

RegisterNetEvent('esx_ambulancejob:setDeathStatus')
AddEventHandler('esx_ambulancejob:setDeathStatus', function(status)
	isDead = status
end)

RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()
	isCuffed = not isCuffed
end)

RegisterNetEvent('esx_policejob:unrestrain')
AddEventHandler('esx_policejob:unrestrain', function()
	isCuffed = false
end)

RegisterNetEvent('linden_inventory:openInventory')
AddEventHandler('linden_inventory:openInventory',function(data, rightinventory)
	if not playerID then return end
	movement = false
	invOpen = true
	SendNUIMessage({
		message = 'openinventory',
		inventory = data.inventory,
		slots = data.slots,
		name = playerName..' ['.. playerID ..']',
		maxweight = data.maxWeight,
		rightinventory = rightinventory
	})
	if not rightinventory then movement = true else movement = false end
	SetNuiFocusAdvanced(true, true, movement)
	currentInventory = rightinventory
end)

RegisterNetEvent('linden_inventory:refreshInventory')
AddEventHandler('linden_inventory:refreshInventory', function(data, item, text)
	SendNUIMessage({ message = 'notify', item = item, text = text })
	SendNUIMessage({
		message = 'refresh',
		inventory = data.inventory,
		slots = data.slots,
		name = playerName..' ['.. playerID ..']',
		maxweight = data.maxWeight
	})
end)

RegisterNetEvent('linden_inventory:createDrop')
AddEventHandler('linden_inventory:createDrop', function(coords, id, owner)
	Drops[id] = {
		dropid = id,
		coords = vector3(coords.x, coords.y, coords.z-0.2)
	}
	if owner == playerID then TriggerServerEvent('linden_inventory:openInventory', {type = 'drop', drop = Drops[id] }) end
end)

RegisterNetEvent('linden_inventory:removeDrop')
AddEventHandler('linden_inventory:removeDrop', function(id)
	Drops[id] = nil
	if currentDrop.id == id then currentDrop = {} end
end)

local HolsterWeapon = function(item)
	ClearPedSecondaryTask(playerPed)
	loadAnimDict('reaction@intimidation@1h')
	TaskPlayAnimAdvanced(playerPed, 'reaction@intimidation@1h', 'outro', GetEntityCoords(playerPed, true), 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, -1, 50, 0, 0, 0)
	Citizen.Wait(1600)
	DisarmPlayer()
	ClearPedSecondaryTask(playerPed)
	SetPedUsingActionMode(playerPed, -1, -1, 1)
	SendNUIMessage({ message = 'notify', item = item, text = 'Holstered' })
end

local DrawWeapon = function(item)
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
			item.ammo = GetAmmoType(item.name)
			DrawWeapon(item)
			if currentWeapon.metadata.throwable then item.metadata.ammo = 1 end
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

local weaponTimer = 0
AddEventHandler('linden_inventory:usedWeapon',function(weapon)
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
	if currentWeapon then
		if currentWeapon.ammo == ammo.name then
			local maxAmmo = GetWeaponClipSize(currentWeapon.hash)
			local curAmmo = GetAmmoInPedWeapon(playerPed, currentWeapon.hash)
			if curAmmo > maxAmmo then SetPedAmmo(playerPed, currentWeapon.hash, maxAmmo) elseif curAmmo == maxAmmo then return
			else
				print(ammo.count)
				local newAmmo = 0
				if curAmmo < maxAmmo then missingAmmo = maxAmmo - curAmmo end
				if missingAmmo > ammo.count then newAmmo = ammo.count + curAmmo removeAmmo = ammo.count - curAmmo
				else newAmmo = maxAmmo removeAmmo = missingAmmo end
				if newAmmo < 0 then newAmmo = 0 end
				SetPedAmmo(playerPed, currentWeapon.hash, newAmmo)
				MakePedReload(playerPed)
				TriggerServerEvent('linden_inventory:addweaponAmmo', currentWeapon, removeAmmo, newAmmo)
			end
		else
			error("You can't load the %s with %s ammo"):format(currentWeapon.label, ammo.label)
		end
	end
end)

RegisterNetEvent('linden_inventory:updateWeapon')
AddEventHandler('linden_inventory:updateWeapon',function(data)
	if currentWeapon then currentWeapon.metadata = data end
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

Citizen.CreateThread(function()
	local wait = false
	local Disable = {37, 157, 158, 160, 164, 165, 289}
	while true do
		sleep = 100
		if not invOpen then
			sleep = 3
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
			elseif not invOpen and CanOpenInventory() then
				for i=1, #Keys, 1 do
					if IsDisabledControlJustReleased(0, Keys[i]) then
						TriggerServerEvent('linden_inventory:useSlotItem', i)
					end
				end
			end
			if currentWeapon then
				if weaponTimer == 3 then
					TriggerServerEvent('linden_inventory:updateWeapon', currentWeapon)
				elseif weaponTimer > 3 then weaponTimer = weaponTimer - 3 end
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
					elseif currentWeapon.metadata.ammo then
						currentWeapon.metadata.ammo = ammo
						if ammo == 0 then
							weaponTimer = 0
							ClearPedTasks(playerPed)
							SetCurrentPedWeapon(playerPed, currentWeapon.hash, false)
							SetPedCurrentWeaponVisible(playerPed, true, false, false, false)
							TriggerServerEvent('linden_inventory:reloadWeapon', currentWeapon)
						else TriggerEvent('linden_inventory:usedWeapon', currentWeapon) end
					end
				else
					if currentWeapon.metadata.throwable and not wait and IsControlJustReleased(0, 24) then
						usingWeapon = true
						Citizen.CreateThread(function()
							wait = true
							Citizen.Wait(800)
							TriggerServerEvent('linden_inventory:updateWeapon', currentWeapon)
							SetCurrentPedWeapon(playerPed, `WEAPON_UNARMED`, true)
							currentWeapon = nil
							wait = false
						end)
					elseif Config.Melee[currentWeapon.name] and not wait and IsPedInMeleeCombat(playerPed) and IsControlPressed(0, 24) then
						usingWeapon = true
						Citizen.CreateThread(function()
							wait = true
							TriggerServerEvent('linden_inventory:updateWeapon', currentWeapon)
							TriggerEvent('linden_inventory:usedWeapon', currentWeapon)
							Citizen.Wait(400)
							wait = false
						end)
					else usingWeapon = false end
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 250
		playerPed = PlayerPedId()
		playerCoords = GetEntityCoords(playerPed)
		if not invOpen and playerID then
			for i=1, #Config.Shops do
				local text = Config.Shops[i].name
				local distance = #(playerCoords - Config.Shops[i].coords)

				if distance <= 5 and (not Config.Shops[i].job or Config.Shops[i].job == ESX.PlayerData.job.name) then
					sleep = 5
					DrawMarker(2, Config.Shops[i].coords.x,Config.Shops[i].coords.y,Config.Shops[i].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.15, 0.2, 30, 150, 30, 100, false, false, false, true, false, false, false)
					if distance <= 1.5 then
						text = '[~g~E~s~] ' .. Config.Shops[i].name
						if IsControlJustPressed(0, 38) then
							OpenShop(i)
							Citizen.Wait(sleep)
						end
					end
					DrawText3D(Config.Shops[i].coords, text)
				end
			end

			for i=1, #Config.Stashes do
				local text = Config.Stashes[i].name
				local distance = #(playerCoords - Config.Stashes[i].coords)

				if distance <= 5 and not (Config.Stashes[i].job or Config.Shops[i].job == ESX.PlayerData.job.name) then
					sleep = 5
					DrawMarker(2, Config.Stashes[i].coords.x,Config.Stashes[i].coords.y,Config.Stashes[i].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.15, 0.2, 30, 30, 150, 100, false, false, false, true, false, false, false)
					if distance <= 1.5 then
						text = '[~g~E~s~] ' .. Config.Stashes[i].name
						if IsControlJustPressed(0, 38) then
							OpenStash(Config.Stashes[i])
							Citizen.Wait(sleep)
						end
					end
					DrawText3D(Config.Stashes[i].coords, text)
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
										error("You already have a weapon's license")
									else
										ESX.TriggerServerCallback('linden_inventory:buyLicense', function(bought)
											if bought then
												inform("You have purchased a weapon's license")
											else
												error("You can not afford a weapon's license")
											end
										end, license)
									end
									Citizen.Wait(sleep)
								end, playerID, license)
							end
						end   
						DrawText3D(coords, text)
					end
				end
			end

		else sleep = 50 end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 250
		if playerID then
			for k, v in pairs(Drops) do
				v.distance = #(playerCoords - v.coords)
				if (invOpen and distance <= 1.2) or distance <= 8 then
					sleep = 5
					DrawMarker(2, v.coords.x,v.coords.y,v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 150, 30, 30, 222, false, false, false, true, false, false, false)
					local closestDrop
					if distance <= 1.2 and (not closestDrop or v.distance < closestDrop) then
						closestDrop = {}
						closestDrop.id = v.id
						closestDrop.coords = v.coords
						closestDrop.distance = v.distance
					end
				end
			end
			if closestDrop then
				local distance = #(playerCoords - closestDrop.coords)
				if distance <= 1.2 then currentDrop = closestDrop else currentDrop = {} end
			end
			if currentInventory then
				sleep = 125
				if currentInventory.name:find('Player') then
					local str = string.sub(currentInventory.name, 7)
					local id = GetPlayerFromServerId(tonumber(str))
					local dist = #(playerCoords - playerCoords)
					if not id or dist > 1.5 or not CanOpenTarget(playerPed) then
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

RegisterNetEvent('linden_inventory:useItem')
AddEventHandler('linden_inventory:useItem',function(item)
	if not CanOpenInventory() then return end
	ESX.TriggerServerCallback('linden_inventory:getItem',function(xItem)
		if xItem then
			local data = Config.ItemList[xItem.name]
			if not data or not next(data) then return end
			if xItem.closeonuse then TriggerEvent('linden_inventory:closeInventory') end
			if not data.animDict then data.animDict = 'pickup_object' end
			if not data.anim then data.anim = 'putdown_low' end
			if not data.flags then data.flags = 48 end

			-- Trigger effects before the progress bar
			if data.component then
				if not currentWeapon then return end
				local result, esxWeapon = ESX.GetWeapon(currentWeapon.name)
				
				for k,v in ipairs(esxWeapon.components) do
					for k2, v2 in pairs(data.component) do
						if v.hash == v2 then
							component = {name = v.name, hash = v2}
							break
						end
					end
				end
				if not component then error("This weapon is incompatible with "..xItem.label) return end
				if HasPedGotWeaponComponent(playerPed, currentWeapon.hash, component.hash) then
					error("This weapon already has a "..xItem.label) return
				end
			end

			if xItem.name == 'lockpick' then
				TriggerEvent('esx_lockpick:onUse')
			end

			------------------------------------------------------------------------------------------------
			if data.useTime and data.useTime >= 0 then
				TriggerEvent('linden_inventory:busy', true)
				exports['mythic_progbar']:Progress({
					name = 'useitem',
					duration = data.useTime,
					label = 'Using '..xItem.label,
					useWhileDead = false,
					canCancel = false,
					controlDisables = { disableMovement = data.disableMove, disableCarMovement = false, disableMouse = false, disableCombat = true },
					animation = { animDict = data.animDict, anim = data.anim, flags = data.flags },
					prop = { model = data.model, coords = data.coords, rotation = data.rotation }
				}, function() TriggerEvent('linden_inventory:busy', false) end)
			else TriggerEvent('linden_inventory:busy', false) end
			while isBusy do Citizen.Wait(10) end

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
			if data.consume then TriggerServerEvent('linden_inventory:removeItem', xItem.name, data.consume, xItem.metadata) end
			TriggerEvent('linden_inventory:busy', false)
			------------------------------------------------------------------------------------------------

				if data.component then
					GiveWeaponComponentToPed(playerPed, currentWeapon.name, component.hash)
					table.insert(currentWeapon.metadata.components, component.name)
					TriggerServerEvent('linden_inventory:updateWeapon', currentWeapon, component.name)
				end
				

				if xItem.name == 'bandage' then
					local maxHealth = 200
					local health = GetEntityHealth(playerPed)
					local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 16))
					SetEntityHealth(playerPed, newHealth)
				end


			------------------------------------------------------------------------------------------------
		end
	end, item.name, item.metadata)
end)


RegisterCommand('inv', function()
	if isBusy or invOpen then error("You can't open your inventory right now") return end 
	if CanOpenInventory() then
		TriggerEvent('randPickupAnim')
		TriggerServerEvent('linden_inventory:openInventory', {type = 'drop', drop = currentDrop })
	end
end)

RegisterCommand('vehinv', function()
	if not playerID then return end
	if isBusy or invOpen then error("You can't open your inventory right now") return end 
	if not CanOpenInventory() then return end
	if not isDead and not isCuffed and not IsPedInAnyVehicle(playerPed, false) then -- trunk
		local vehicle, vehiclePos = ESX.Game.GetVehicleInDirection()
		CloseToVehicle = false
		lastVehicle = nil
		if vehicle and #(playerCoords - vehiclePos) < 6 then
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
					local class = GetVehicleClass(vehicle)
					TaskTurnPedToFaceCoord(playerPed, vehiclePos)
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
					TriggerEvent('linden_inventory:closeInventory')
					return
				end
			else
				error("Vehicle is locked")
			end
		end
	elseif not isDead and not isCuffed and IsPedInAnyVehicle(playerPed, false) then -- glovebox
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local plate = GetVehicleNumberPlateText(vehicle)
		local class = GetVehicleClass(vehicle)
		OpenGloveBox(plate, class)
		while true do
			Citizen.Wait(100)
			if not IsPedInAnyVehicle(playerPed, false) then
				TriggerEvent('linden_inventory:closeInventory')
				return
			elseif not invOpen then return end
		end
	end
end)
		
RegisterKeyMapping('inv', 'Open player inventory', 'keyboard', Config.InventoryKey)
RegisterKeyMapping('vehinv', 'Open vehicle inventory', 'keyboard', Config.VehicleInventoryKey)

RegisterCommand('steal', function()
	if not IsPedInAnyVehicle(playerPed, true) and not invOpen and CanOpenInventory() then	 
		openTargetInventory()
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
	if data.inv == 'Playerinv' then TriggerServerEvent('linden_inventory:useItem', data.item) end
end)

RegisterNUICallback('saveinventorydata',function(data)
	TriggerServerEvent('linden_inventory:saveInventoryData', data)
end)

RegisterNUICallback('BuyFromShop', function(data)
    TriggerServerEvent('linden_inventory:buyItem', data)
end)

RegisterNUICallback('exit',function(data)
	TriggerScreenblurFadeOut(0)
	if lastVehicle then
		CloseVehicle(lastVehicle)
	end
	currentInventory = nil
	SetNuiFocusAdvanced(false, false)
	TriggerServerEvent('linden_inventory:saveInventory', data)
	Citizen.Wait(200)
	invOpen = false
end)
