---
title: ESX Legacy Installation
---


<h2 align='center'> Notice </h2>
The following adjustments must be made for compatibility and security reasons.  
These changes are intended to make it easier for those using modified files already.

If you are already starting from the basics, I strongly suggest [downloading my fork](https://github.com/thelindat/es_extended) and ignoring the rest of this page.


<h2 align='center'> client/main.lua </h2>

* Locate `AddEventHandler('esx:restoreLoadout', function()` and replace the event (for compatibility) with
```lua
AddEventHandler('esx:restoreLoadout', function()
	local playerPed = PlayerPedId()
	if ESX.PlayerData.ped ~= playerPed then ESX.SetPlayerData('ped', playerPed) end
end)
```

* Locate the following events and remove all of them (for security)
```lua
RegisterNetEvent('esx:addInventoryItem')
RegisterNetEvent('esx:removeInventoryItem')
RegisterNetEvent('esx:addWeapon')
RegisterNetEvent('esx:addWeaponComponent')
RegisterNetEvent('esx:setWeaponAmmo')
RegisterNetEvent('esx:setWeaponTint')
RegisterNetEvent('esx:removeWeapon')
RegisterNetEvent('esx:removeWeaponComponent')
RegisterNetEvent('esx:createPickup')
RegisterNetEvent('esx:removePickup')
```

* Locate and remove the following function and remove it (for performance)
```lua
	-- keep track of ammo
	Citizen.CreateThread(function()
		while ESX.PlayerLoaded do
			Citizen.Wait(1000)

			local letSleep = true

			if IsPedArmed(ESX.PlayerData.ped, 4) then
				if IsPedShooting(ESX.PlayerData.ped) then
					local _,weaponHash = GetCurrentPedWeapon(ESX.PlayerData.ped, true)
					local weapon = ESX.GetWeaponFromHash(weaponHash)

					if weapon then
						local ammoCount = GetAmmoInPedWeapon(ESX.PlayerData.ped, weaponHash)
						TriggerServerEvent('esx:updateWeaponAmmo', weapon.name, ammoCount)
					end
				end
			end
			if letSleep then
				Citizen.Wait(500)
			end
		end
	end)
```

* Locate and remove the following command (deprecated)
```lua
if Config.EnableDefaultInventory then
	RegisterCommand('showinv', function()
		if not isDead and not ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
			ESX.ShowInventory()
		end
	end)

	RegisterKeyMapping('showinv', _U('keymap_showinventory'), 'keyboard', 'F2')
end
```

* Locate and remove the following thread (for performance)
```lua
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords, letSleep = GetEntityCoords(ESX.PlayerData.ped), true
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer(playerCoords)

		for pickupId,pickup in pairs(pickups) do
			local distance = #(playerCoords - pickup.coords)

			if distance < 5 then
				local label = pickup.label
				letSleep = false

				if distance < 1 then
					if IsControlJustReleased(0, 38) then
						if IsPedOnFoot(ESX.PlayerData.ped) and (closestDistance == -1 or closestDistance > 3) and not pickup.inRange then
							pickup.inRange = true

							local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
							ESX.Streaming.RequestAnimDict(dict)
							TaskPlayAnim(ESX.PlayerData.ped, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
							Citizen.Wait(1000)

							TriggerServerEvent('esx:onPickup', pickupId)
							PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
						end
					end

					label = ('%s~n~%s'):format(label, _U('threw_pickup_prompt'))
				end

				ESX.Game.Utils.DrawText3D({
					x = pickup.coords.x,
					y = pickup.coords.y,
					z = pickup.coords.z + 0.25
				}, label, 1.2, 1)
			elseif pickup.inRange then
				pickup.inRange = false
			end
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)
```



<h2 align='center'> server/commands.lua </h2>

* Add the following code to the top of the file (for compatibility and ease)
```lua
ExecuteCommand('add_principal group.moderator group.user')
ExecuteCommand('add_principal group.admin group.moderator')
ExecuteCommand('add_principal group.superadmin group.admin')
ExecuteCommand('add_ace group.superadmin command allow')
ExecuteCommand('add_ace group.superadmin command.quit deny')
```

* Remove the following commands (deprecated)
```lua
giveitem, giveweapon, giveweaponcomponent, clearinventory
```

* Remove the following line
```lua
if args.group == "superadmin" then args.group = "admin" end
```


<h2 align='center'> server/functions.lua </h2>

* Locate `ESX.SavePlayer` and modify the SQL query
```lua
MySQL.Async.execute('UPDATE users SET accounts = @accounts, job = @job, job_grade = @job_grade, `group` = @group, position = @position, inventory = @inventory WHERE identifier = @identifier', {
			['@accounts'] = json.encode(xPlayer.getAccounts(true)),
			['@job'] = xPlayer.job.name,
			['@job_grade'] = xPlayer.job.grade,
			['@group'] = xPlayer.getGroup(),
			['@position'] = json.encode(xPlayer.getCoords()),
			['@identifier'] = xPlayer.getIdentifier(),
			['@inventory'] = json.encode(xPlayer.getInventory(true))
```


<h2 align='center'> server/main.lua </h2>

* Locate `-- Inventory` on line `176` and replace (until line `208`) with
```lua
if result[1].inventory and result[1].inventory ~= '' then
			userData.inventory = json.decode(result[1].inventory)
end
```

* Locate `-- Group` and replace the statement with
```lua
-- Group
if result[1].group then
  userData.group = result[1].group
else
  userData.group = 'user'
end
```

* Locate and removing the following
```lua

			-- Loadout
			if result[1].loadout and result[1].loadout ~= '' then
				local loadout = json.decode(result[1].loadout)

				for name,weapon in pairs(loadout) do
					local label = ESX.GetWeaponLabel(name)

					if label then
						if not weapon.components then weapon.components = {} end
						if not weapon.tintIndex then weapon.tintIndex = 0 end

						table.insert(userData.loadout, {
							name = name,
							ammo = weapon.ammo,
							label = label,
							components = weapon.components,
							tintIndex = weapon.tintIndex
						})
					end
				end
			end
```

* Locate `CreateExtendedPlayer` and replace the function with 
```lua
local xPlayer = CreateExtendedPlayer(playerId, identifier, userData.group, userData.accounts, userData.job, userData.playerName, userData.coords)
```

* Locate `TriggerEvent('esx:playerLoaded', playerId, xPlayer, isNew)` and immediately below it add
```lua
TriggerEvent('linden_inventory:setPlayerInventory', xPlayer, userData.inventory)
```

* Locate `xPlayer.getLoadout()` and replace it with `{}` whenever it occurs
* Locate and remove the following events or triggers
```lua
xPlayer.triggerEvent('esx:createMissingPickups', ESX.Pickups)
RegisterNetEvent('esx:updateWeaponAmmo')
RegisterNetEvent('esx:giveInventoryItem')
RegisterNetEvent('esx:removeInventoryItem')
RegisterNetEvent('esx:useItem')
RegisterNetEvent('esx:onPickup')
```


<h2 align='center'> server/classes/player.lua </h2>

* Replace the entirety of the file with my modified version
[Link](https://github.com/thelindat/es_extended/blob/linden/server/classes/player.lua)






<h4 align='center'><br>Getting errors? You need to check your edits and confirm you removed it all properly</h4>
<h3 align='center'>Restarting the framework or inventory should show lines causing errors (in server or client console)</h3>
