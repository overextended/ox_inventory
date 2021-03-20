<p align='center'><img src='https://i.imgur.com/JxZpgNM.png'/><br>
<a href='https://streamable.com/bggvpg'>Showcase</a> | <a href='https://discord.gg/hmcmv3P7YW'>Discord</a></p>
<h2 align='center'>Notice</h2><p align='center'><a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.</p>
<h4 align='center'>If you encounter any issues, please report them in the issues section (or discord).<br>This resource is not yet recommended for use on an active server.</h4><br><br>
<p align='center'>Hasan is no updating the inventory and has stopped development.<br>
<img src='https://i.imgur.com/IZStQrx.png'/><br><br>
Original Showcase --> https://streamable.com/kpvdj3<br>
Hasan's discord is available at https://discord.gg/6FQhKDXBJ6<br><br>
Further development of this resource is continuing at <a href='https://github.com/thelindat/hsn-inventory'>thelindat/hsn-inventory</a>.<br>All stable updates will be submitted to the main repository as pull requests.</p>
<h1 align='center'>Installation Guide</h1>
<h3 align='center'> <a href='https://github.com/thelindat/hsn-inventory/wiki'>More guides on the wiki</a> </h3>

<p align='center'>Requires OneSync and either <a href='https://github.com/esx-framework/es_extended/tree/v1-final'>ESX v1 Final</a>, or <a href='https://github.com/extendedmode/extendedmode'>ExtendedMode</a><br>If you are looking to upgrade or starting fresh, a modified framework is <a href='https://github.com/thelindat/extendedmode-hsn-inventory-compatibility'>available here</a>.

## Dependencies
[ghmattimysql](https://github.com/GHMatti/ghmattimysql)  
[mythic_progbar](https://github.com/thelindat/mythic_progbar)  
[mythic_notify](https://github.com/FlawwsX/mythic_notify)  

## ghmattimysql
* Add this function to wait for sql connection to be established
### ghmattimysql-server.lua
```
exports("ready", function (callback)
  Citizen.CreateThread(function ()
      -- add some more error handling
      while GetResourceState('ghmattimysql') ~= 'started' do
          Citizen.Wait(0)
      end
      -- while not exports['mysql-async']:is_ready() do
      --     Citizen.Wait(0)
      -- end
      callback()
  end)
end)
```

<br>

## Modifying your framework (ESX/EXM) - _Updated for 1.5.2_
* Modifications to money related functions have changed _(1.5.2)_
* Modifications to inventory related functions have changed _(1.5.2)_
* Vanilla files: <a href='https://github.com/esx-framework/es_extended/blob/v1-final/server/classes/player.lua'>ESX Final</a> | <a href='https://github.com/extendedmode/extendedmode/blob/master/server/classes/player.lua'>EXM</a>

Replace the contents of `config.weapons.lua` contents with <a href='https://raw.githubusercontent.com/thelindat/extendedmode-hsn-inventory-compatibility/main/config.weapons.lua'>this file</a>
### server/classes/player.lua
* Search for `self.getAccounts`, delete everything from there until `self.getInventory` and replace with
```
	self.getAccounts = function(minimal)
		if minimal then
			local minimalAccounts = {}

			for k,v in ipairs(self.accounts) do
				if not v.name:find('money') then minimalAccounts[v.name] = v.money end
			end

			return minimalAccounts
		else
			return self.accounts
		end
	end

	self.getAccount = function(account)
		if account:find('money') then
			local money = exports["hsn-inventory"]:getItemCount(self.source, account)
			local account = {}
			account.money = money or 0
			return account
		else
			for k,v in ipairs(self.accounts) do
				if v.name == account then
					return v
				end
			end
		end
	end

	self.getInventory = function(minimal)
		local inventory = {}
		TriggerEvent('hsn-inventory:getplayerInventory', function(data)
			inventory = data
		end, self.identifier)
		return inventory
	end
```
* Search for `self.setAccountMoney`, delete everything from there until `self.canSwapItem` and replace with
```
	self.setAccountMoney = function(accountName, money)
		money = tonumber(money)
		if accountName:find('money') then self.setInventoryItem(accountName, money) return end
		if money >= 0 then
			local account = self.getAccount(accountName)

			if account then
				local prevMoney = account.money
				local newMoney = ESX.Math.Round(money)
				account.money = newMoney
				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.addAccountMoney = function(accountName, money)
		money = tonumber(money)
		if accountName:find('money') then self.addInventoryItem(accountName, money) return end
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money + ESX.Math.Round(money)
				account.money = newMoney
				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.removeAccountMoney = function(accountName, money)
		money = tonumber(money)
		if accountName:find('money') then self.removeInventoryItem(accountName, money) return end
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money - ESX.Math.Round(money)
				account.money = newMoney
				self.triggerEvent('esx:setAccountMoney', account)
			end
		end
	end

	self.getInventoryItem = function(name, metadata)
		local item = exports["hsn-inventory"]:getItem(self.source, name, metadata)
		if item then
			return item
		end
		return 
	end

	self.addInventoryItem = function(name, count, metadata)
		if name and count > 0 then
			count = ESX.Math.Round(count)
			exports["hsn-inventory"]:addItem(self.source, name, count, metadata)
		end
	end

	self.removeInventoryItem = function(name, count, metadata)
		if name and count > 0 then
			count = ESX.Math.Round(count)
			exports["hsn-inventory"]:removeItem(self.source, name, count, metadata)
		end
	end

	self.setInventoryItem = function(name, count, metadata)
		local item = exports["hsn-inventory"]:getItem(self.source, name, metadata)
		if item and count >= 0 then
			count = ESX.Math.Round(count)
			if count > item.count then
				self.addInventoryItem(item.name, count - item.count, metadata)
			else
				self.removeInventoryItem(item.name, item.count - count, metadata)
			end
		end
	end

	self.getWeight = function()
		return 0 --self.weight
	end

	self.getMaxWeight = function()
		return self.maxWeight
	end

	self.canCarryItem = function(name, count)
		return exports["hsn-inventory"]:canCarryItem(self.source, name, count)
	end

	self.canSwapItem = function(firstItem, firstItemCount, testItem, testItemCount)
		return true
	end
```

<br>

### server/main.lua
* Replace the event `esx:useItem` with the following  
```
RegisterNetEvent('esx:useItem')
AddEventHandler('esx:useItem', function(source, itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem(itemName)
	if item.count > 0 then
		if item.closeonuse then TriggerClientEvent("hsn-inventory:client:closeInventory", source) end
		ESX.UseItem(source, itemName)
	end
end)
```

* Search for `TriggerEvent('esx:playerLoaded', playerId, xPlayer)`, after which add  
`TriggerEvent('hsn-inventory:setplayerInventory', xPlayer.identifier, xPlayer.inventory)`  

<br>

* Search for `if result[1].inventory and result[1].inventory ~= '' then`  
* Remove or comment out the code below that references inventory and items (should be until it mentions `group`) <a href='https://i.imgur.com/cOAx3SU.png'>EXAMPLE</a>  
* Add the following
```
if result[1].inventory and result[1].inventory ~= '' then
	userData.inventory = json.decode(result[1].inventory)
end
```  

<br>

### server/functions.lua
* Search for `ESX.SavePlayer = function(xPlayer, cb)` and insert into it (at the top)
```
local inventory = {}
TriggerEvent('hsn-inventory:getplayerInventory', function(data)
	inventory = data
end, xPlayer.identifier)
```
* Inside the MySQL.Async.execute function, replace  
`[@inventory'] = json.encode(xPlayer.getInventory(true))` with `['@inventory'] = json.encode(inventory)`

<br>
<h3 align='center'>If your framework doesn't load/CreateExtendedPlayer double check your edits</h3>

## Setting up items
* As long as you have the above edits in place, you can continue to use ESX.RegiserUsableItem as you have been.  
* Alternatively you are able to add items directly to hsn-inventory in `Config.ItemList`  
* Modify the `hsn-inventory:useItem` event to add effects from using an item.  
* Any items registered with hsn will override the default `esx:useItem` event, so don't worry about overlap.
