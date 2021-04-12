title: Installation

| [Installation](index) | [Usage](usage) | [Snippets](snippets) | [Other Resources](resources) | [Media](media)

<h1 align='center'>Requirements</h1>

* OneSync must be enabled on your server (Legacy or Infinity)
* You can use OneSync for up to 32 slots without being a FiveM patron
* ESX Framework ([v1 Final](https://github.com/esx-framework/es_extended/tree/v1-final) or [ExtendedMode](https://github.com/extendedmode/extendedmode/tree/dev))
* Alternatively, you can get my version of [ExtendedMode](https://github.com/thelindat/extendedmode) with the necessary changes
* [ghmattimysql](https://github.com/GHMatti/ghmattimysql/releases)
* [mythic_progbar](https://github.com/thelindat/mythic_progbar)
* [mythic_notify](https://github.com/thelindat/mythic_notify)

* If I say to remove something, feel free to keep it in a comment block `--[[ ]]`

<h2 align='center'>Server Config</h2>

```js
set mysql_connection_string "mysql://user:password@localhost/database?connectTimeout=20000&acquireTimeout=20000&waitForConnections=true&keepAlive=15"
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
ensure async

ensure extendedmode
** etc
** etc
** etc
** etc
ensure linden_inventory		# have it load after resources that register items, or just last
```

<br><br>

<h1 align='center'>Modifying third-party resources</h1>

* Add the following code to ghmattimysql-server.lua
```lua
exports("ready", function (callback)
	Citizen.CreateThread(function ()
		while GetResourceState('ghmattimysql') ~= 'started' do
			Citizen.Wait(0)
		end
		callback()
	end)
end)
```
* Delete `config.json` to fallback to using the MySQL connection string in server.cfg

Moving items around while the inventory is refreshing can cause the client to desync; while I do plan to resolve the cause I recommend locking the inventory during certain situations.
* [esx_jobs] When the Work() function is running for a player, trigger `TriggerEvent('linden_inventory:busy', true)`; toggle it off once their task is complete
* When an item is added or removed from the player inventory while they are moving it (typically going to use a progressbar, I recommend the above)


<h1 align='center'>Modifying your framework</h1>

#### Updating from hsn-inventory
* Though the changes being applied are mostly the same, there are some minor differences (aside from the obvious name change)
* `ESX.SavePlayer` is no longer being modified and should be reverted to default
* `self.getAccounts` and `self.getAccount` are no longer being modified and should be reverted to default
* That should be everything, but let me know if I missed anything leftover


## server/main.lua
* Remove `loadout,` from `MySQL.Async.fetchAll`
* Search for `-- Inventory` (line 137 for ESX, 142 for EXM)
* Remove everything from this line until you reach `-- Group`, then add
```lua
-- Inventory
if result[1].inventory and result[1].inventory ~= '' then
	userData.inventory = json.decode(result[1].inventory)
end
```
* Search for `-- Loadout` and remove the code block
* Remove `userData.inventory` from CreateExtendedPlayer()
* Remove `userData.loadout` from CreateExtendedPlayer()
* Add `TriggerEvent('linden_inventory:setPlayerInventory', xPlayer, userData.inventory)` after xPlayer is created  
![image](https://user-images.githubusercontent.com/65407488/114259210-b5c97d80-9a0f-11eb-979d-553839a6ea8d.png)
* Remove `loadout = xPlayer.getLoadout()` from xPlayer.triggerEvent('esx:playerLoaded')
* Remove `xPlayer.triggerEvent('esx:createMissingPickups', ESX.Pickups)`
* Search for `RegisterNetEvent('esx:useItem')` and replace it with
```lua
RegisterNetEvent('esx:useItem')
AddEventHandler('esx:useItem', function(source, itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem(itemName)
	if item.count > 0 then
		if item.closeonuse then TriggerClientEvent('linden_inventory:closeInventory', source) end
		ESX.UseItem(source, itemName)
	end
end)
```


## server/classes/player.lua
* Remove `loadout` from CreateExtendedPlayer
* Remove `inventory` from CreateExtendedPlayer
* Change `self.inventory = inventory` to `self.inventory = {}`
* Remove `self.loadout = loadout`
* Remove `self.maxWeight = Config.MaxWeight`
* Add this new function (I have it after `self.getAccount = function()`)
```lua
self.setAccount = function(account)
	for k,v in ipairs(self.accounts) do
		if v.name == account.name then
			self.accounts[k] = account
		end
	end
end
```

* Locate `self.getInventory` and replace the function with
```lua
self.getInventory = function()
	return exports['linden_inventory']:getPlayerInventory(self)
end
```

* Locate `self.setAccountMoney` and replace the functions as below
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
* Remove any functions related to loadouts or weapons


## server/functions.lua
* Remove the `ESX.CreatePickup` function
* Remove `loadout = @loadout` from the MySQL function
* Remove `['@loadout'] = json.encode(xPlayer.getLoadout(true)),` from `ESX.SavePlayer`


## client/main.lua
* Find and remove anything related to `'esx:restoreLoadout'`
* If using EXM, remove `isLoadoutLoaded = false` from the skinchanger event
* Find `-- Keep track of ammo` and remove the threaded function (lines 392 to 413 in ESX // 385 to 406 in EXM)
* Find `if IsControlJustReleased(0, 289) then` and remove the function
* Find `-- Pickups` and remove the function
#### Optional
* Remove the `RegisterNetEvent('esx:addInventoryItem')` event
* Remove the `RegisterNetEvent('esx:removeInventoryItem')` event
* Remove the `AddPickup` function
* Remove the `RegisterNetEvent('esx:createPickup')` event
* Remove the `RegisterNetEvent('esx:createMissingPickups')` event
* Remove the `RegisterNetEvent('esx:removePickup')` event


## client/functions.lua
* Remove the `ESX.ShowInventory` function (lines 706 to 1006 in ESX // 875 to 1120 in EXM)
* Find and remove the following thread (if it exists)
```lua
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, 289) then
			if IsInputDisabled(0) and not isDead and not ESX.UI.Menu.IsOpen('default', 'es_extended', 'inventory') then
				ESX.ShowInventory()
			end
		end
	end
end)
```

<h4 align='center'>Confirm you have removed all functions trying to get loadout data<br>
Getting errors? You need to check your edits and confirm you removed it all properly<br></h4>
<h3 align='center'>Restarting the framework or inventory should show lines causing errors (in server or client console)</h3>
