local Blips, Drops, Usables, weaponTimer, currentDrop, currentWeapon = {}, {}, {}, 0
cancelled = false

ClearWeapons = function()
	for k, v in pairs(Weapons) do
		SetPedAmmo(ESX.PlayerData.ped, v.hash, 0)
	end
	RemoveAllPedWeapons(ESX.PlayerData.ped, true)
	if parachute then
		local chute = `GADGET_PARACHUTE`
		GiveWeaponToPed(ESX.PlayerData.ped, chute, 0, true, false)
		SetPedGadget(ESX.PlayerData.ped, chute, true)
	end
	TriggerEvent('linden_inventory:currentWeapon', nil)
end

DisarmPlayer = function(weapon)
	if currentWeapon then
		currentWeapon.metadata.ammo = GetAmmoInPedWeapon(ESX.PlayerData.ped, currentWeapon.hash)
		SetPedAmmo(ESX.PlayerData.ped, currentWeapon.hash, 0)
		RemoveWeaponFromPed(ESX.PlayerData.ped, currentWeapon.hash)
		if currentWeapon.metadata.components then
			for k,v in pairs(currentWeapon.metadata.components) do
				local componentHash = ESX.GetWeaponComponent(currentWeapon.name, v).hash
				if componentHash then RemoveWeaponComponentFromPed(ESX.PlayerData.ped, currentWeapon.hash, componentHash) end
			end
		end
		TriggerServerEvent('linden_inventory:updateWeapon', currentWeapon)
	end
	TriggerEvent('linden_inventory:currentWeapon', nil)
end

StartInventory = function()
	playerID, invOpen, ESX.PlayerData.dead, isCuffed, isBusy, usingWeapon, currentDrop = nil, false, false, false, false, false, nil
	ESX.TriggerServerCallback('linden_inventory:setup', function(data)
		ESX.PlayerData = ESX.GetPlayerData()
		ESX.SetPlayerData('inventory', data.inventory)
		ESX.SetPlayerData('weight', data.weight)
		playerCoords = GetEntityCoords(ESX.PlayerData.ped)
		playerID = GetPlayerServerId(PlayerId())
		playerName = data.name
		Drops = data.drops
		Usables = data.usables
		inventoryLabel = playerName..' ['..playerID..'] '--[[..ESX.PlayerData.job.grade_label]]
		PlayerLoaded = true
		ClearWeapons()
		TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = _U('inventory_setup'), length = 2500})
		TriggerLoops()
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
	end)
end
if ESX.IsPlayerLoaded() then StartInventory() end

CanOpenInventory = function()
	if PlayerLoaded and not isBusy and weaponTimer < 250 and not ESX.PlayerData.dead and not isCuffed and not IsPauseMenuActive() and not IsPedDeadOrDying(ESX.PlayerData.ped, 1) then
		return true
	else return false end
end

CanOpenTarget = function(ped)
	if GetEntityHealth(ped) == 0
	or IsEntityPlayingAnim(ped, 'random@mugging3', 'handsup_standing_base', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_base', 3)
	or IsEntityPlayingAnim(ped, 'missminuteman_1ig_2', 'handsup_enter', 3)
	or IsEntityPlayingAnim(ped, 'dead', 'dead_a', 3)
	or IsEntityPlayingAnim(ped, 'mp_arresting', 'idle', 3)
	then return true
	else return false end
end

OpenTargetInventory = function(target)
	if not invOpen and not IsPedInAnyVehicle(ESX.PlayerData.ped, true) and not currentInventory and CanOpenInventory() then
		local targetPlayer, targetDistance
		if target then
			targetPlayer = target
			targetDistance = #(playerCoords - GetEntityCoords(GetPlayerPed(targetPlayer)))
		else
			targetPlayer, targetDistance = ESX.Game.GetClosestPlayer()
		end
		if targetPlayer ~= -1 and targetDistance <= 1.5 then
			if CanOpenTarget(GetPlayerPed(targetPlayer)) or ESX.PlayerData.job.name == 'police' then
				TriggerServerEvent('linden_inventory:openTargetInventory', GetPlayerServerId(targetPlayer))
			else
				TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = _U('inventory_cannot_open_other'), length = 2500})
			end
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
	DrawRect(0.0, 0.0125, 0.02 + text:gsub('~.-~', ''):len() / 360, 0.03, 25, 25, 25, 140)
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
	TaskPlayAnim(ESX.PlayerData.ped,'pickup_object', 'putdown_low',5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
	Wait(1000)
	ClearPedSecondaryTask(ESX.PlayerData.ped)
end)

RegisterNetEvent('targetPlayerAnim')
AddEventHandler('targetPlayerAnim', function()
	loadAnimDict('mp_ped_interaction')
	TaskPlayAnim(ESX.PlayerData.ped,'mp_ped_interaction', 'handshake_guy_b',1.0, 1.0, 1.0, 49, 0.0, 0, 0, 0)
	Wait(250)
	ClearPedSecondaryTask(ESX.PlayerData.ped)
end)

Citizen.CreateThread(function()
	-- Leah#0001 block of code
	for i = 1, #Config.Shops, 1 do
		if (Config.bt_target) then
            local typeName = i
            if (Config.Shops[i].type == nil) then
                typeName = Config.Shops[i].name or math.random(1, 10000)
            else
                typeName = Config.Shops[i].type['name']
            end
			local jobAccess = {"all"}
			if (Config.Shops[i].job) then jobAccess = { Config.Shops[i].job } end
			local length, width = Config.Shops[i].bt_length or 0.5, Config.Shops[i].bt_width or 0.5
			local minZ, maxZ = Config.Shops[i].bt_minZ or 10.0, Config.Shops[i].bt_maxZ or 100.0
			local heading = Config.Shops[i].bt_heading or 0.0
			local distance = Config.Shops[i].bt_distance or 6.0

			exports['bt-target']:AddBoxZone(i .. typeName, Config.Shops[i].coords, length, width, {
                name=i .. typeName,
                heading=heading,
                debugPoly=false,
                minZ=minZ,
                maxZ=maxZ
            }, {
				options = {
					{
						event = "OpenShopTarget",
						icon = "fas fa-shopping-basket",
						label = "Open " .. typeName,
						shopid = i,
					},
				},
				job = jobAccess,
				distance = distance
			})
		end
   end
end)

RegisterNetEvent('OpenShopTarget')
AddEventHandler('OpenShopTarget',function(data)
	OpenShop(data.shopid)
end)

OpenShop = function(id)
	if not currentInventory and CanOpenInventory() and not CanOpenTarget(ESX.PlayerData.ped) then
		if closestShop and GetInvokingResource() ~= Config.Resource then id = closestShop end
		TriggerServerEvent('linden_inventory:openInventory', 'shop', id)
	end
end
exports('OpenShop', OpenShop)

OpenStash = function(data)
	if data and not currentInventory and CanOpenInventory() and not CanOpenTarget(ESX.PlayerData.ped) then
		if not data.slots then data.slots = (Config.PlayerSlots * 1.5) end
		if data.name then data.id = data.name end
		TriggerServerEvent('linden_inventory:openInventory', 'stash', data)
	end
end
exports('OpenStash', OpenStash)

GiveStash = function(data)
	if data then
		TriggerServerEvent('linden_inventory:giveStash', data)
	end
end
exports('GiveStash', GiveStash)
--GiveStash({name = Config.Stashes[id].name, slots = Config.Stashes[id].slots, coords = Config.Stashes[id].coords, item = 'money', count = 20})

OpenBag = function(data)
	if data and not currentInventory and CanOpenInventory() and not CanOpenTarget(ESX.PlayerData.ped) then
		TriggerServerEvent('linden_inventory:openInventory', 'bag', data)
	end
end
exports('OpenBag', OpenBag)

OpenDumpster = function(data)
	if data and not currentInventory and CanOpenInventory() and not CanOpenTarget(ESX.PlayerData.ped) then
		if not data.slots then data.slots = (Config.PlayerSlots * 1.5) end
		TriggerServerEvent('linden_inventory:openInventory', 'dumpster', data)
	end
end
exports('OpenDumpster', OpenDumpster)

OpenGloveBox = function(plate, class)
	local data = {id = 'glovebox-'..plate, slots = Config.Gloveboxes[class][1], maxWeight = Config.Gloveboxes[class][2]}
	if data.slots then TriggerServerEvent('linden_inventory:openInventory', 'glovebox', data) end
end

OpenTrunk = function(plate, class)
	local data = {id = 'trunk-'..plate, slots = Config.Trunks[class][1], maxWeight = Config.Trunks[class][2]}
	if data.slots then TriggerServerEvent('linden_inventory:openInventory', 'trunk', data) end
end

CloseVehicle = function(veh)
	local animDict = 'anim@heists@fleeca_bank@scope_out@return_case'
	local anim = 'trevor_action'
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do
		Citizen.Wait(100)
	end
	ClearPedTasks(ESX.PlayerData.ped)
	Citizen.Wait(100)
	TaskPlayAnimAdvanced(ESX.PlayerData.ped, animDict, anim, GetEntityCoords(ESX.PlayerData.ped, true), 0, 0, GetEntityHeading(ESX.PlayerData.ped), 2.0, 2.0, 1000, 49, 0.25, 0, 0)
	Citizen.Wait(900)
	ClearPedTasks(ESX.PlayerData.ped)
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
SetNuiFocusAdvanced = function(hasFocus, hasCursor)
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
				if movement and not currentInventory then
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
	if CanOpenInventory() and not invOpen then
		movement = false
		invOpen = true
		if rightinventory then
			if not rightinventory.id then rightinventory.id = rightinventory.name end
			if not rightinventory.name then rightinventory.name = rightinventory.id end
		end
		SendNUIMessage({
			message = 'openinventory',
			inventory = data.inventory,
			slots = data.slots,
			name = inventoryLabel,
			maxWeight = data.maxWeight,
			weight = data.weight,
			rightinventory = rightinventory,
			job = ESX.PlayerData.job,
		})
		ESX.PlayerData.inventory = data.inventory
		if not rightinventory then movement = true else movement = false end
		SetNuiFocusAdvanced(true, true)
		currentInventory = rightinventory
	end
end)

RegisterNetEvent('linden_inventory:refreshInventory')
AddEventHandler('linden_inventory:refreshInventory', function(data, clear)
	ESX.PlayerData.inventory = data.inventory
	if invOpen then
		SendNUIMessage({
			message = 'refresh',
			inventory = data.inventory,
			slots = data.slots,
			name = inventoryLabel,
			maxWeight = data.maxWeight,
			weight = data.weight
		})
	end
	ESX.SetPlayerData('inventory', data.inventory)
	ESX.SetPlayerData('maxWeight', data.maxWeight)
	ESX.SetPlayerData('weight', data.weight)
	if clear then ClearWeapons()
		TriggerEvent('linden_inventory:closeInventory')
	end
end)

RegisterNetEvent('linden_inventory:itemNotify')
AddEventHandler('linden_inventory:itemNotify', function(item, count, slot, notify)
	if count > 0 then notification = _U(notify)..' '..count..'x'
	else notification = _U('used') end
	if notify == 'removed' and item.name:find('WEAPON_') then TriggerEvent('linden_inventory:checkWeapon', item) end
	SendNUIMessage({ message = 'notify', item = item, text = notification })
end)


RegisterNetEvent('linden_inventory:updateStorage')
AddEventHandler('linden_inventory:updateStorage', function(data)
	ESX.SetPlayerData('weight', data[1])
	if Config.WeightActions then WeightActions(data[1], data[2]) end
end)

RegisterNetEvent('linden_inventory:createDrop')
AddEventHandler('linden_inventory:createDrop', function(data, owner)
	Drops[data.id] = data
	Drops[data.id].coords = vector3(data.coords.x, data.coords.y,data.coords.z - 0.2)
	if owner == playerID and invOpen and #(playerCoords - data.coords) <= 1 then
		if not IsPedInAnyVehicle(ESX.PlayerData.ped, false) then
			invOpen = false
			TriggerServerEvent('linden_inventory:openInventory', 'drop', data.id )
		else
			TriggerServerEvent('linden_inventory:openInventory')
		end
	end
end)

RegisterNetEvent('linden_inventory:removeDrop')
AddEventHandler('linden_inventory:removeDrop', function(id, owner)
	Drops[id] = nil
	if currentDrop and currentDrop.id == id then currentDrop = nil end
	if owner == playerID and invOpen then
		SendNUIMessage({ message = 'closeright' })
		movement = true
	end
end)

HolsterWeapon = function(item)
	ClearPedSecondaryTask(ESX.PlayerData.ped)
	loadAnimDict('reaction@intimidation@1h')
	TaskPlayAnimAdvanced(ESX.PlayerData.ped, 'reaction@intimidation@1h', 'outro', GetEntityCoords(ESX.PlayerData.ped, true), 0, 0, GetEntityHeading(ESX.PlayerData.ped), 8.0, 3.0, -1, 50, 0, 0, 0)
	Citizen.Wait(1600)
	ClearWeapons()
	ClearPedSecondaryTask(ESX.PlayerData.ped)
	SendNUIMessage({ message = 'notify', item = item, text = _U('holstered') })
end

DrawWeapon = function(item)
	ClearPedSecondaryTask(ESX.PlayerData.ped)
	if ESX.PlayerData.job.name == 'police' then
		loadAnimDict('reaction@intimidation@cop@unarmed')
		TaskPlayAnimAdvanced(ESX.PlayerData.ped, 'reaction@intimidation@cop@unarmed', 'intro', GetEntityCoords(ESX.PlayerData.ped, true), 0, 0, GetEntityHeading(ESX.PlayerData.ped), 8.0, 3.0, -1, 50, 1, 0, 0)
	else
		loadAnimDict('reaction@intimidation@1h')
		TaskPlayAnimAdvanced(ESX.PlayerData.ped, 'reaction@intimidation@1h', 'intro', GetEntityCoords(ESX.PlayerData.ped, true), 0, 0, GetEntityHeading(ESX.PlayerData.ped), 8.0, 3.0, -1, 50, 0, 0, 0)
		Citizen.Wait(800)
	end
	if currentWeapon then
		SetPedAmmo(ESX.PlayerData.ped, currentWeapon.hash, 0)
		RemoveWeaponFromPed(ESX.PlayerData.ped, currentWeapon.hash)
	end
	GiveWeaponToPed(ESX.PlayerData.ped, item.hash, 0, true, false)
	Citizen.Wait(800)
	SendNUIMessage({ message = 'notify', item = item, text = _U('equipped') })
end

RegisterNetEvent('linden_inventory:weapon')
AddEventHandler('linden_inventory:weapon', function(item)
	if not isBusy and item and not IsPedFalling(ESX.PlayerData.ped) and not IsPedRagdoll(ESX.PlayerData.ped) then
		TriggerEvent('linden_inventory:busy', true)
		useItemCooldown = true
		local newWeapon = item.metadata.serial
		local found, wepHash = GetCurrentPedWeapon(ESX.PlayerData.ped, true)
		if wepHash == -1569615261 then currentWeapon = nil end
		wepHash = item.hash or GetHashKey(item.name)
		if currentWeapon and (currentWeapon.metadata.serial == newWeapon or currentWeapon.name == item.name) then
			HolsterWeapon(item)
			TriggerEvent('linden_inventory:currentWeapon', nil)
		else
			item.hash = wepHash
			DrawWeapon(item)
			if Items[item.name].throwable then item.throwable, item.metadata.ammo = 1, true end
			local ammoname = Items[item.name].ammoname
			if ammoname then item.ammoname = ammoname end
			TriggerEvent('linden_inventory:currentWeapon', item)
			SetCurrentPedWeapon(ESX.PlayerData.ped, currentWeapon.hash)
			SetPedCurrentWeaponVisible(ESX.PlayerData.ped, true, false, false, false)
			if item.metadata.weapontint then SetPedWeaponTintIndex(ESX.PlayerData.ped, item.name, item.metadata.weapontint) end
			if item.metadata.components then
				for k,v in pairs(item.metadata.components) do
					local componentHash = ESX.GetWeaponComponent(item.name, v).hash
					if componentHash then GiveWeaponComponentToPed(ESX.PlayerData.ped, currentWeapon.hash, componentHash) end
				end
			end
			SetAmmoInClip(ESX.PlayerData.ped, currentWeapon.hash, item.metadata.ammo)
			if currentWeapon.name == 'WEAPON_FIREEXTINGUISHER' or currentWeapon.name == 'WEAPON_PETROLCAN' then SetAmmoInClip(ESX.PlayerData.ped, currentWeapon.hash, 10000) end
		end
		ClearPedSecondaryTask(ESX.PlayerData.ped)
		TriggerEvent('linden_inventory:busy', false)
		useItemCooldown = false
	end
end)

AddEventHandler('linden_inventory:usedWeapon',function()
	weaponTimer = (100 * 5)
end)

AddEventHandler('linden_inventory:currentWeapon', function(weapon)
	DisablePlayerFiring(ESX.PlayerData.ped, weapon and false or true)
	currentWeapon = weapon
end)

RegisterNetEvent('linden_inventory:checkWeapon')
AddEventHandler('linden_inventory:checkWeapon', function(item)
	if currentWeapon and ((not currentWeapon.metadata.serial and currentWeapon.name == item.name) or currentWeapon.metadata.serial == item.metadata.serial) then
		DisarmPlayer()
	end
end)

RegisterNetEvent('linden_inventory:clearWeapons')
AddEventHandler('linden_inventory:clearWeapons', function()
	ClearWeapons()
end)

RegisterNetEvent('linden_inventory:addAmmo')
AddEventHandler('linden_inventory:addAmmo', function(ammo)
	if currentWeapon and not isBusy then
		if currentWeapon.ammoname == ammo.name then
			local maxAmmo = GetMaxAmmoInClip(ESX.PlayerData.ped, currentWeapon.hash, 1)
			local curAmmo = GetAmmoInPedWeapon(ESX.PlayerData.ped, currentWeapon.hash)
			if curAmmo > maxAmmo then SetPedAmmo(ESX.PlayerData.ped, currentWeapon.hash, maxAmmo) elseif curAmmo == maxAmmo then return
			else
				isBusy, useItemCooldown = true, true
				local newAmmo = 0
				if curAmmo < maxAmmo then missingAmmo = maxAmmo - curAmmo end
				if missingAmmo > ammo.count then newAmmo = ammo.count + curAmmo
				else newAmmo = maxAmmo end
				if newAmmo < 0 then newAmmo = 0 end
				SetPedAmmo(ESX.PlayerData.ped, currentWeapon.hash, newAmmo)
				MakePedReload(ESX.PlayerData.ped)
				TriggerServerEvent('linden_inventory:addweaponAmmo', currentWeapon, curAmmo, newAmmo)
				Citizen.Wait(100)
				isBusy, useItemCooldown = false, false
			end
		else
			TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = _U('wrong_ammo', currentWeapon.label, ammo.label), length = 2500})
		end
	end
end)

RegisterNetEvent('linden_inventory:updateWeapon')
AddEventHandler('linden_inventory:updateWeapon',function(data)
	if currentWeapon and (not currentWeapon.serial or currentWeapon.serial == data.serial) then
		currentWeapon.metadata = data
		if currentWeapon.metadata.durability <= 0 then DisarmPlayer() end
	end
end)

AddEventHandler('linden_inventory:busy',function(busy)
	isBusy = busy
	if isBusy and invOpen then TriggerEvent('linden_inventory:closeInventory') end
end)

RegisterNetEvent('linden_inventory:closeInventory')
AddEventHandler('linden_inventory:closeInventory', function(sendNUI)
	if invOpen then
		if sendNUI ~= false then
			SendNUIMessage({
				message = 'close',
			})
		end
		TriggerScreenblurFadeOut(0)
		if lastVehicle then
			CloseVehicle(lastVehicle)
		end
		SetNuiFocusAdvanced(false, false)
		invOpen, currentInventory, currentDrop = false, nil, nil
	end
end)

AddEventHandler('onResourceStop', function(resourceName)
	if parachute then ESX.Game.DeleteObject(parachute) end
	if invOpen and Config.Resource == resourceName then
		TriggerScreenblurFadeOut(0)
		if nui_focus[1] == true then SetNuiFocusAdvanced(false, false) end
	end
end)

TriggerLoops = function()
	Citizen.CreateThread(function()
		local Disable = {37, 157, 158, 160, 164, 165, 289, 80}
		local Disable2 = {23, 24, 25, 142, 257, 140, 141, 142}
		local wait = false
		while PlayerLoaded do
			HideHudComponentThisFrame(19)
			HideHudComponentThisFrame(20)
			for i=1, #Disable, 1 do
				DisableControlAction(0, Disable[i], true)
			end
			if isBusy or useItemCooldown then
				for i=1, #Disable2, 1 do
					DisableControlAction(0, Disable2[i], true)
				end
			end
			if weaponTimer == 5 and currentWeapon then
				TriggerServerEvent('linden_inventory:updateWeapon', currentWeapon)
				weaponTimer = 0
				SetPedUsingActionMode(ESX.PlayerData.ped, false, -1, "DEFAULT_ACTION")
			elseif weaponTimer > 5 then weaponTimer = weaponTimer - 5 end
			if not invOpen and currentWeapon then
				if IsPedArmed(ESX.PlayerData.ped, 6) then
					DisableControlAction(1, 140, true)
					DisableControlAction(1, 141, true)
					DisableControlAction(1, 142, true)
				end
				usingWeapon = IsPedShooting(ESX.PlayerData.ped)
				if currentWeapon and usingWeapon then
					local currentAmmo = GetAmmoInPedWeapon(ESX.PlayerData.ped, currentWeapon.hash)
					if currentWeapon.name == 'WEAPON_FIREEXTINGUISHER' or currentWeapon.name == 'WEAPON_PETROLCAN' and not wait then
						currentWeapon.metadata.durability = currentWeapon.metadata.durability - 0.1
						if currentWeapon.metadata.durability <= 0 then
							Citizen.CreateThread(function()
								wait = true
								ClearPedTasks(ESX.PlayerData.ped)
								SetCurrentPedWeapon(ESX.PlayerData.ped, currentWeapon.hash, true)
								TriggerServerEvent('linden_inventory:updateWeapon', currentWeapon)
								Citizen.Wait(200)
								DisarmPlayer()
								wait = false
							end)
						end
					elseif currentWeapon.ammoname then
						currentWeapon.metadata.ammo = currentAmmo
						if currentAmmo == 0 then
							if Config.AutoReload and not IsPedFalling(ESX.PlayerData.ped) and not IsPedRagdoll(ESX.PlayerData.ped) then
								weaponTimer = 0
								TriggerServerEvent('linden_inventory:reloadWeapon', currentWeapon)
							end
							ClearPedTasks(ESX.PlayerData.ped)
							SetCurrentPedWeapon(ESX.PlayerData.ped, currentWeapon.hash, false)
							SetPedCurrentWeaponVisible(ESX.PlayerData.ped, true, false, false, false)
							
						else TriggerEvent('linden_inventory:usedWeapon', currentWeapon) end
					end
				else
					if currentWeapon.throwable and not wait and IsControlJustReleased(0, 24) then
						usingWeapon = true
						Citizen.CreateThread(function()
							wait = true
							Citizen.Wait(700)
							TriggerServerEvent('linden_inventory:updateWeapon', currentWeapon, 'throw')
							DisarmPlayer()
							wait = false
						end)
					elseif currentWeapon.durability and not wait and IsPedInMeleeCombat(ESX.PlayerData.ped) and IsControlPressed(0, 24) then
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
			Citizen.Wait(5)
		end
	end)

	Citizen.CreateThread(function()
		local text, type, id = ''
		while PlayerLoaded do
			local sleep = 250
			if IsPedInAnyVehicle(ESX.PlayerData.ped, false) then SetPedCanSwitchWeapon(ESX.PlayerData.ped, true) else SetPedCanSwitchWeapon(ESX.PlayerData.ped, false) end
			playerCoords = GetEntityCoords(ESX.PlayerData.ped)
			if not invOpen then
				if not Config.bt_target and not id or type == 'shop' then
					if id then
						sleep = 5
						closestShop = id
						DrawMarker(2, Config.Shops[id].coords.x,Config.Shops[id].coords.y,Config.Shops[id].coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 30, 150, 30, 222, false, false, false, true, false, false, false)			
						local distance = #(playerCoords - Config.Shops[id].coords)
						local name = Config.Shops[id].name or Config.Shops[id].type.name
						if distance <= 1 then text='[~g~E~s~] '..name
							if IsControlJustPressed(0, 38) then
								OpenShop(id)
							end
						elseif distance > 4 then id, type = nil, nil
						else text = Config.Shops[id].name or Config.Shops[id].type.name end
						if distance <= 2 then DrawText3D(Config.Shops[id].coords, text) end
					else
						closestShop = nil
						for k, v in pairs(Config.Shops) do
							if not id and v.coords and (not v.job or v.job == ESX.PlayerData.job.name) then
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
							if not id and v.coords and (not v.job or v.job == ESX.PlayerData.job.name) then
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
									closestDrop = {id = v.id, distance = distance}
								end
							end
						end
					end
					if closestDrop then
						if closestDrop.distance <= 1 then currentDrop = {id=closestDrop.id, distance=closestDrop.distance} else currentDrop = nil end
					end
				end
				if Config.WeaponsLicense then
					local coords, text, license = vector3(12.42198, -1105.82, 29.7854), _U('weapon_license'), 'weapon'
					local distance = #(playerCoords - coords)
					if distance <= 5 then
						sleep = 5
						DrawMarker(2, coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.15, 0.2, 30, 150, 30, 100, false, false, false, true, false, false, false)
						if not invOpen then
							if distance <= 1.5 then
								text = _U('purchase_license')
								if IsControlJustPressed(1,38) then
									ESX.TriggerServerCallback('esx_license:checkLicense', function(hasWeaponLicense)
										if hasWeaponLicense then
											TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = _U('has_weapon_license'), length = 2500})
										else
											ESX.TriggerServerCallback('linden_inventory:buyLicense', function(bought)
												if bought then
													TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = _U('bought_weapon_license'), length = 2500})
												else
													TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = _U('poor_weapon_license'), length = 2500})
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
				if currentInventory then
					if currentInventory.type == 'player' then
						local id = GetPlayerFromServerId(currentInventory.id)
						local ped = GetPlayerPed(id)
						local pedCoords = GetEntityCoords(ped)
						local dist = #(playerCoords - pedCoords)
						if not id or dist > 1.8 then
							if (ESX.PlayerData.job.name == 'police' and dist > 1.8) or not CanOpenTarget(ped) then
								TriggerEvent('linden_inventory:closeInventory')
								TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = _U('inventory_lost_access'), length = 2500})
							end
						else
							TaskTurnPedToFaceCoord(ESX.PlayerData.ped, pedCoords)
						end
					elseif not lastVehicle and currentInventory.coords then
						local dist = #(playerCoords - currentInventory.coords)
						if dist > 2 or CanOpenTarget(ESX.PlayerData.ped) then
							TriggerEvent('linden_inventory:closeInventory')
							TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = _U('inventory_lost_access'), length = 2500})
						end
					end
				end
			end
			if parachute and sleep > 50 and GetPedParachuteState(ESX.PlayerData.ped) ~= -1 then ESX.Game.DeleteObject(parachute) parachute = false end
			if invOpen and not CanOpenInventory() then TriggerEvent('linden_inventory:closeInventory') end
			Citizen.Wait(sleep)
		end
	end)

	Citizen.CreateThread(function()
		while PlayerLoaded do
			local sleep = 1000
				if id then
					sleep = 5
					local distance = #(playerCoords - GetEntityCoords(id))
					if distance <= 2 then
						NetworkRegisterEntityAsNetworked(id)
						local netid = NetworkGetNetworkIdFromEntity(id)
						SetNetworkIdExistsOnAllMachines(netid)
						NetworkSetNetworkIdDynamic(netid, false)
						if IsControlJustPressed(0, 38) then
							OpenDumpster({ id = netid, label = 'Dumpster', slots = 20})
						end
					elseif distance > 1.5 then id = nil
					end
				else
					for i=1, #Config.Dumpsters do 
						if not id then
							local dumpster = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 2.0, Config.Dumpsters[i], false, false, false)
							local dumpPos = GetEntityCoords(dumpster)
							local distance = #(playerCoords - dumpPos)
							if distance <= 1.5 and dumpster ~= 0 then
								sleep = 100
								id = dumpster
							end
						end
					end
				end
			Citizen.Wait(sleep)
		end
	end)

end

local canReload = true
RegisterCommand('reload', function()
	if canReload and not isBusy and currentWeapon and currentWeapon.ammoname and CanOpenInventory() then
		local maxAmmo = GetMaxAmmoInClip(ESX.PlayerData.ped, currentWeapon.hash, 1)
		local curAmmo = GetAmmoInPedWeapon(ESX.PlayerData.ped, currentWeapon.hash)
		if curAmmo < maxAmmo then TriggerServerEvent('linden_inventory:reloadWeapon', currentWeapon) end
		canReload = false
		Citizen.Wait(200)
		canReload = true
	end
end)
RegisterKeyMapping('reload', 'Reload weapon', 'keyboard', 'r')

RegisterCommand('inv', function()
	if isBusy then TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = _U('inventory_cannot_open'), length = 2500})
	elseif invOpen then TriggerEvent('linden_inventory:closeInventory')
	else
		if CanOpenInventory() then
			TriggerEvent('randPickupAnim')
			local property = false
			TriggerEvent('linden_inventory:getProperty', function(data) property = data end)
			if property then OpenStash(property) return end
			if IsPedInAnyVehicle(ESX.PlayerData.ped, false) then currentDrop = nil end
			if currentDrop then
				TriggerServerEvent('linden_inventory:openInventory', 'drop', currentDrop.id)
			else
				TriggerServerEvent('linden_inventory:openInventory')
			end
		end
	end
end)

RegisterCommand('vehinv', function()
	if invOpen then return end
	if isBusy then TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = _U('inventory_cannot_open'), length = 2500})
	elseif currentInventory then TriggerEvent('linden_inventory:closeInventory')
	else
		if not CanOpenInventory() then TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = _U('inventory_cannot_open'), length = 2500}) return end
		if not IsPedInAnyVehicle(ESX.PlayerData.ped, false) then -- trunk
			local vehicle, vehiclePos = ESX.Game.GetVehicleInDirection()
			if not vehiclePos then vehiclePos = GetEntityCoords(vehicle) end
			CloseToVehicle = false
			lastVehicle = nil
			local class = GetVehicleClass(vehicle)
			if vehicle and Config.Trunks[class] and #(playerCoords - vehiclePos) < 6 then
				if GetVehicleDoorLockStatus(vehicle) == 1 then
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
						if Config.TrimPlate then plate = ESX.Math.Trim(plate) end
						TaskTurnPedToFaceCoord(ESX.PlayerData.ped, vehiclePos)
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
						TaskPlayAnim(ESX.PlayerData.ped, animDict, anim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
						Citizen.Wait(100)
						lastVehicle = vehicle
						while true do
							Citizen.Wait(50)
							if CloseToVehicle and invOpen then
								coords = GetEntityCoords(ESX.PlayerData.ped)
								local vehiclePos = GetWorldPositionOfEntityBone(vehicle, vehBone)
								local pedDistance = #(coords - vehiclePos)
								local isClose = false
								if pedDistance < 2.0 then isClose = true end
								if not DoesEntityExist(vehicle) or not isClose then
									break
								end
								TaskTurnPedToFaceCoord(ESX.PlayerData.ped, vehiclePos)
							else
								break
							end
						end
						if lastVehicle then TriggerEvent('linden_inventory:closeInventory') end
						return
					end
				else
					TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = _U('vehicle_locked'), length = 2500})
				end
			end
		elseif IsPedInAnyVehicle(ESX.PlayerData.ped, false) then -- glovebox
			local vehicle = GetVehiclePedIsIn(ESX.PlayerData.ped, false)
			local plate = GetVehicleNumberPlateText(vehicle)
			if Config.TrimPlate then plate = ESX.Math.Trim(plate) end
			local class = GetVehicleClass(vehicle)
			OpenGloveBox(plate, class)
			Citizen.Wait(100)
			while true do
				Citizen.Wait(100)
				if not invOpen then break
				elseif not IsPedInAnyVehicle(ESX.PlayerData.ped, false) then
					TriggerEvent('linden_inventory:closeInventory')
					break
				end
			end
		end
	end
end)

RegisterCommand('hotbar', function()
	if PlayerLoaded then
		local data = {}
		for i=1, 5 do
			if ESX.PlayerData.inventory[i] then data[i] = ESX.PlayerData.inventory[i] end
		end
		SendNUIMessage({
			message = 'hotbar',
			items = data
		})
	end
end)
RegisterKeyMapping('hotbar', 'Display inventory hotbar', 'keyboard', 'tab')
		
RegisterKeyMapping('inv', 'Open player inventory', 'keyboard', Config.InventoryKey)
RegisterKeyMapping('vehinv', 'Open vehicle inventory', 'keyboard', Config.VehicleInventoryKey)

RegisterCommand('steal', function() OpenTargetInventory() end)

RegisterCommand('weapondetails', function()
	if currentWeapon and ESX.PlayerData.job.name == 'police' then
		local msg
		if currentWeapon.metadata.registered then msg = _U('weapon_registered', currentWeapon.label, currentWeapon.metadata.serial, currentWeapon.metadata.registered)
		else msg = _U('weapon_unregistered', currentWeapon.label) end
		TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = msg, length = 8000})
	end
end)

RegisterCommand('-nui', function()
	TriggerEvent('linden_inventory:closeInventory')
end)

RegisterNUICallback('devtool', function()
	TriggerServerEvent('linden_inventory:devtool')
end)

RegisterNUICallback('notification', function(data)
	if data.type == 2 then data.type = 'error' else data.type = 'inform' end
	TriggerEvent('mythic_notify:client:SendAlert', {type = data.type, text = _U(data.message), length = 2500})
end)

RegisterNUICallback('useItem', function(data, cb)
	if data.inv == 'Playerinv' then TriggerEvent('linden_inventory:useItem', data.item) end
end)

RegisterNUICallback('giveItem', function(data, cb)
	local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()
	if closestPlayer == -1 or closestPlayerDistance > 2.0 then 
		TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = _U('nobody_nearby'), length = 2500})
	elseif data.inv == 'Playerinv' then
		if data.amount >= 1 then
			TriggerServerEvent('linden_inventory:giveItem', data, GetPlayerServerId(closestPlayer))
			TriggerEvent('randPickupAnim')
		else TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = _U('give_amount'), length = 2500}) end
	end
end)

RegisterNUICallback('saveinventorydata',function(data)
	TriggerServerEvent('linden_inventory:saveInventoryData', data)
end)

RegisterNUICallback('BuyFromShop', function(data)
	if data.count >= 1 then
		TriggerServerEvent('linden_inventory:buyItem', data)
	else TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = _U('buy_amount'), length = 2500})end
end)

RegisterNUICallback('exit',function(data)
	TriggerServerEvent('linden_inventory:saveInventory', data)
	TriggerEvent('linden_inventory:closeInventory', false)
end)


local useItemCooldown = false
RegisterNetEvent('linden_inventory:useItem')
AddEventHandler('linden_inventory:useItem', function(item)
	if item.metadata.bag and not currentInventory then
		invOpen = false
		TriggerServerEvent('linden_inventory:openInventory', 'bag', { id = item.metadata.bag, label = item.label..' ('..item.metadata.bag..')', slot = item.slot, slots = item.metadata.slot or 5})
		return
	end
	if CanOpenInventory() and not useItemCooldown and not IsPedRagdoll(ESX.PlayerData.ped) then
		local data = Items[item.name] and Items[item.name].client
		local esxItem = Usables[item.name]
		if data or esxItem then
			if data then
				if data.useinvehicle == false and IsPedInAnyVehicle(ESX.PlayerData.ped, true) then
					TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = _U('cannot_use', item.label), length = 2500}) return
				elseif data.component then
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
					if not component then TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = _U('component_invalid', item.label), length = 2500}) return end
					if HasPedGotWeaponComponent(ESX.PlayerData.ped, currentWeapon.hash, component.hash) then
						TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = _U('component_has', item.label), length = 2500}) return
					end
				end
			end
				
			if esxItem then
				TriggerEvent('linden_inventory:closeInventory') UseItem(item, true)
			elseif data and next(data) then
				if item.close then TriggerEvent('linden_inventory:closeInventory') end
				if not data.usetime then data.usetime = 500 end
				if data.event then
					local event = type(data.event) ~= 'string' and 'linden_inventory:'..item.name or data.event
					TriggerEvent(event, item, data.usetime, function(cb)
						if cb then
							UseItem(item, false, data)
						else
							TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = _U('cannot_use', item.label), length = 2500}) return
						end
					end)
				else
					UseItem(item, false, data)
				end
			end
		elseif Weapons[item.name] or item.name:find('ammo-') then
			UseItem(item, false)
		else Citizen.Wait(100) end
	end
end)

Hotkey = function(slot)
	if PlayerLoaded and not invOpen and not wait and ESX.PlayerData.inventory[slot] then
		TriggerEvent('linden_inventory:useItem', ESX.PlayerData.inventory[slot])
	end
end

RegisterCommand('hotkey1', function() Hotkey(1) end)
RegisterCommand('hotkey2', function() Hotkey(2) end)
RegisterCommand('hotkey3', function() Hotkey(3) end)
RegisterCommand('hotkey4', function() Hotkey(4) end)
RegisterCommand('hotkey5', function() Hotkey(5) end)

RegisterKeyMapping('hotkey1', 'Use hotbar item 1', 'keyboard', '1')
RegisterKeyMapping('hotkey2', 'Use hotbar item 2', 'keyboard', '2')
RegisterKeyMapping('hotkey3', 'Use hotbar item 3', 'keyboard', '3')
RegisterKeyMapping('hotkey4', 'Use hotbar item 4', 'keyboard', '4')
RegisterKeyMapping('hotkey5', 'Use hotbar item 5', 'keyboard', '5')

local canCancel = false
RegisterCommand('cancelitem', function()
	if useItemCooldown then
		TriggerEvent("mythic_progbar:client:cancel")
	end
end)
RegisterKeyMapping('cancelitem', 'Cancel item use', 'keyboard', 'x')

UseItem = function(item, esxItem, data)
	useItemCooldown = true
	ESX.TriggerServerCallback('linden_inventory:usingItem', function(xItem)
		if xItem and data then
			isBusy = true
			if data.usetime > 0 then
				if data.cancel then canCancel = true end
				local disable = {
					move = data.disable and data.disable.move or false,
					car = data.disable and data.disable.car or false,
					mouse = data.disable and data.disable.mouse or false,
					combat = data.disable and data.disable.combat or false,
				}
				local anim = {
					dict = data.anim and data.anim.dict or 'pickup_object',
					clip = data.anim and data.anim.clip or 'putdown_low',
					flag = data.anim and data.anim.flag or 48,
					bone = data.anim and data.anim.bone or nil,
				}
				local prop = data.prop or {}
				exports['mythic_progbar']:Progress({
					name = 'useitem',
					duration = data.usetime,
					label = 'Using '..xItem.label,
					useWhileDead = false,
					canCancel = false,
					controlDisables = { disableMovement = disable.move, disableCarMovement = disable.car, disableMouse = disable.mouse, disableCombat = disable.combat },
					animation = { animDict = anim.dict, anim = anim.clip, flags = anim.flag, bone = anim.bone },
					prop = prop
				}, function(status)
					if status then
						cancelled = true
					end
				end)
			end
			Citizen.Wait(data.usetime)
			if not cancelled then
				local consume = Items[item.name].consume or 1
				if consume > 0 then TriggerServerEvent('linden_inventory:removeItem', item) end

				if data.status then
					for k, v in pairs(data.status) do
						if v > 0 then TriggerEvent('esx_status:add', k, v) else TriggerEvent('esx_status:remove', k, -v) end
					end
				end

				if data.component then
					GiveWeaponComponentToPed(ESX.PlayerData.ped, currentWeapon.name, component.hash)
					table.insert(currentWeapon.metadata.components, component.name)
					TriggerServerEvent('linden_inventory:updateWeapon', currentWeapon, component.name)
				end
			end
		end
		Citizen.Wait(500)
		useItemCooldown, isBusy, canCancel, cancelled = false, false, false, false
	end, item.name, item.slot, item.metadata, esxItem)
end
