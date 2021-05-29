---
title: ExtendedMode
---


> This is an outdated guide and will only work for the inventory prior to version 1.5x

<h2 align='center'>Server Config</h2>

```js
set mysql_connection_string "mysql://user:password@localhost/database?connectTimeout=30000&acquireTimeout=30000&waitForConnections=true&keepAlive=15"
# Choose one, or set it in txAdmin (run FXServer directly to enable)
#set onesync_enabled
#set onesync_enableInfinity

ensure mapmanager
ensure chat
ensure spawnmanager
ensure sessionmanager
ensure hardcap

ensure mysql-async
ensure ghmattimysql
ensure cron

ensure extendedmode       	# extendedmode provides es_extended, you don't need to replace any dependencies or events
** etc
** etc
** etc
** etc
ensure linden_inventory		# have it load after resources that register items, or just last
```


<h2 align='center'>Modifying your framework</h2>

## config.lua
* Set your desired player weight in grams, where 24000 is equal to 24kg (about 53lbs)


## server/main.lua
* Remove `loadout = {},` from the userData table
* Search for `MySQL.Async.fetchAll` and replace
```lua
		MySQL.Async.fetchAll('SELECT accounts, job, job_grade, `group`, position, inventory FROM users WHERE identifier = @identifier', {
```
* Search for `-- Inventory` and replace until you reach `-- Group`
```lua
		-- Inventory
		if result[1].inventory and result[1].inventory ~= '' then
			userData.inventory = json.decode(result[1].inventory)
		end
```
* Remove the following
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
* Search for `local xPlayer = CreateExtendedPlayer` and replace
```lua
		-- Create Extended Player Object
		local xPlayer = CreateExtendedPlayer(playerId, identifier, userData.group, userData.accounts, userData.weight, userData.job, userData.playerName, userData.coords)
		ESX.Players[playerId] = xPlayer
		TriggerEvent('linden_inventory:setPlayerInventory', xPlayer, userData.inventory)
		TriggerEvent('esx:playerLoaded', playerId, xPlayer)

		xPlayer.triggerEvent('esx:playerLoaded', {
			accounts = xPlayer.getAccounts(),
			coords = xPlayer.getCoords(),
			identifier = xPlayer.getIdentifier(),
			inventory = xPlayer.getInventory(),
			job = xPlayer.getJob(),
			money = xPlayer.getMoney()
		})

		xPlayer.triggerEvent('esx:registerSuggestions', ESX.RegisteredCommands)
```
* The following events can be removed, or set to trigger bans automatically (they will never be used legitimately)
```lua
esx:updateWeaponAmmo
esx:giveInventoryItem
esx:removeInventoryItem
esx:onPickup
```
* Search for and remove any instance of `loadout      = xPlayer.getLoadout(),`
* Search for `esx:useItem` and remove the event


## server/functions.lua
* Search for `ESX.CreatePickup` and remove the function
* Search for `ESX.SavePlayer` and replace
```lua
ESX.SavePlayer = function(xPlayer, cb)
	if ExM.DatabaseType == "es+esx" then
		-- Nothing yet ;)
	elseif ExM.DatabaseType == "newesx" then
		MySQL.Async.execute('UPDATE users SET accounts = @accounts, job = @job, job_grade = @job_grade, `group` = @group, position = @position, inventory = @inventory WHERE identifier = @identifier', {
			['@accounts'] = json.encode(xPlayer.getAccounts(true)),
			['@job'] = xPlayer.job.name,
			['@job_grade'] = xPlayer.job.grade,
			['@group'] = xPlayer.getGroup(),
			['@position'] = json.encode(xPlayer.getCoords()),
			['@identifier'] = xPlayer.getIdentifier(),
			['@inventory'] = json.encode(xPlayer.getInventory(true))
		}, cb)
	end
end
```


## server/classes/player.lua
* Search for `CreateExtendedPlayer` and remove `inventory` and `loadout`
* Change `self.inventory = inventory` to `self.inventory = {}`
* Remove `self.loadout = loadout`
* Remove `self.maxWeight = Config.MaxWeight`
* Add the following new functions
```lua
	self.setAccount = function(account)
		for k,v in ipairs(self.accounts) do
			if v.name == account.name then
				self.accounts[k] = account
			end
		end
	end

	self.getPlayerSlot = function(slot)
		return exports['linden_inventory']:getPlayerSlot(self, slot)
	end
```
* Search for `self.getInventory` and replace the function with
```lua
	self.getInventory = function(minimal)
		return exports['linden_inventory']:getPlayerInventory(self, minimal)
	end
```

* Search for `self.setAccountMoney` and replace the functions as below
```lua
	self.setAccountMoney = function(accountName, money)
		if money >= 0 then
			local account = self.getAccount(accountName)

			if account then
				local prevMoney = account.money
				local newMoney = ESX.Math.Round(money)
				account.money = newMoney
				if accountName ~= 'bank' then exports['linden_inventory']:setInventoryItem(self, accountName, money) end
				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.addAccountMoney = function(accountName, money)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money + ESX.Math.Round(money)
				account.money = newMoney
				if accountName ~= 'bank' then exports['linden_inventory']:addInventoryItem(self, accountName, money) end
				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.removeAccountMoney = function(accountName, money)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money - ESX.Math.Round(money)
				account.money = newMoney
				if accountName ~= 'bank' then exports['linden_inventory']:removeInventoryItem(self, accountName, money) end
				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.getInventoryItem = function(name, metadata)
		return exports['linden_inventory']:getInventoryItem(self, name, metadata)
	end

	self.addInventoryItem = function(name, count, metadata, slot)
		exports['linden_inventory']:addInventoryItem(self, name, count, metadata, slot)
	end

	self.removeInventoryItem = function(name, count, metadata)
		exports['linden_inventory']:removeInventoryItem(self, name, count, metadata)
	end

	self.setInventoryItem = function(name, count, metadata)
		exports['linden_inventory']:setInventoryItem(self, name, count, metadata)
	end

	self.getWeight = function()
		return exports['linden_inventory']:getWeight(self)
	end

	self.getMaxWeight = function()
		return exports['linden_inventory']:getMaxWeight(self)
	end

	self.canCarryItem = function(name, count)
		return exports['linden_inventory']:canCarryItem(self, name, count)
	end

	self.canSwapItem = function(firstItem, firstItemCount, testItem, testItemCount)
		return exports['linden_inventory']:canSwapItem(self, firstItem, firstItemCount, testItem, testItemCount)
	end

	self.setMaxWeight = function(newWeight)
		return exports['linden_inventory']:setMaxWeight(self, newWeight)
	end
```
* Remove the following functions
```lua
self.getLoadout
self.addWeapon
self.addWeaponComponent
self.addWeaponAmmo
self.updateWeaponAmmo
self.setWeaponTint
self.getWeaponTint
self.removeWeapon
self.removeWeaponComponent
self.removeWeaponAmmo
self.hasWeaponComponent
self.hasWeapon
self.getWeapon
```
* Search for `self.setMoney` and replace
```lua
	self.setMoney = function(money)
		money = ESX.Math.Round(money)
		self.setAccountMoney('money', money)
	end
```
* Search for `self.addMoney` and replace the following
```lua
	self.addMoney = function(money)
		money = ESX.Math.Round(money)
		self.addAccountMoney('money', money)
	end
  
	self.removeMoney = function(money)
		money = ESX.Math.Round(money)
		self.removeAccountMoney('money', money)
	end
```


## client/main.lua
* Replace `isLoadoutLoaded` on line 1 with `isSpawned`
* Remove all other instances of `isLoadoutLoaded`
* Search for `function AddPickup` and remove the entire function
* Find `TriggerEvent('esx:restoreLoadout')` and replace it with
```lua
isSpawned = true
StartUpdating()
```

* Remove the following events  
```lua
skinchanger:modelLoaded
esx:restoreLoadout
esx:addInventoryItem
esx:removeInventoryItem
esx:addWeapon
esx:addWeaponComponent
esx:setWeaponAmmo
esx:setWeaponTint
esx:removeWeapon
esx:removeWeaponComponent
esx:createPickup
esx:createMissingPickups
esx:removePickup
```

* Search for `Keep track of ammo usage` and remove the following
```lua
--- Keep track of ammo usage
CreateThread(function()
	while true do
		Wait(0)

		if isDead then
			Wait(500)
		else
			local playerPed = PlayerPedId()

			if IsPedShooting(playerPed) then
				local _, weaponHash = GetCurrentPedWeapon(playerPed, true)
				local weapon = ESX.GetWeaponFromHash(weaponHash)

				if weapon then
					local ammoCount = GetAmmoInPedWeapon(playerPed, weaponHash)
					TriggerServerEvent('esx:updateWeaponAmmo', weapon.name, ammoCount)
				end
			end
		end
	end
end)
```

* Search for `IsControlJustReleased(0, 289)` and remove the following
```lua
CreateThread(function()
	while true do
		Wait(0)

		if IsControlJustReleased(0, 289) then
			if IsInputDisabled(0) and not isDead and not ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
				ESX.ShowInventory()
			end
		end
	end
end)
```
* Search for `-- Pickups` and remove the entire function (around 100 lines)
```lua
function StartUpdating()
	CreateThread(function()
		local previousCoords = vector3(ESX.PlayerData.coords.x, ESX.PlayerData.coords.y, ESX.PlayerData.coords.z)
		local playerHeading = ESX.PlayerData.heading
		local formattedCoords = {x = ESX.Math.Round(previousCoords.x, 1), y = ESX.Math.Round(previousCoords.y, 1), z = ESX.Math.Round(previousCoords.z, 1), heading = playerHeading}

		while isSpawned do
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			local distance = #(playerCoords - previousCoords)

			if distance >= 5 then
				previousCoords = playerCoords
				playerHeading = ESX.Math.Round(GetEntityHeading(playerPed), 1)
				formattedCoords = {x = ESX.Math.Round(playerCoords.x, 1), y = ESX.Math.Round(playerCoords.y, 1), z = ESX.Math.Round(playerCoords.z, 1), heading = playerHeading}
				TriggerServerEvent('esx:updateCoords', formattedCoords)
			end
			Wait(1000)
		end
	end)
end
```
* Search for `-- Update current player coords` and replace with
```lua
function StartUpdating()
	CreateThread(function()
		if not ESX.PlayerData then return end
		local previousCoords = vector3(ESX.PlayerData.coords.x, ESX.PlayerData.coords.y, ESX.PlayerData.coords.z)
		local playerHeading = ESX.PlayerData.heading
		local formattedCoords = {x = ESX.Math.Round(previousCoords.x, 1), y = ESX.Math.Round(previousCoords.y, 1), z = ESX.Math.Round(previousCoords.z, 1), heading = playerHeading}

		while isSpawned do
			local playerPed = PlayerPedId()
			local playerCoords = GetEntityCoords(playerPed)
			local distance = #(playerCoords - previousCoords)

			if distance >= 5 then
				previousCoords = playerCoords
				playerHeading = ESX.Math.Round(GetEntityHeading(playerPed), 1)
				formattedCoords = {x = ESX.Math.Round(playerCoords.x, 1), y = ESX.Math.Round(playerCoords.y, 1), z = ESX.Math.Round(playerCoords.z, 1), heading = playerHeading}
				TriggerServerEvent('esx:updateCoords', formattedCoords)
			end
			Wait(1000)
		end
	end)
end
```



## client/functions.lua
* Search for `ESX.ShowInventory` and remove the function (it's about 250 lines)


<h4 align='center'><br>Getting errors? You need to check your edits and confirm you removed it all properly</h4>
<h3 align='center'>Restarting the framework or inventory should show lines causing errors (in server or client console)</h3>
