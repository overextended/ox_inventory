---
title: Index
---
This category provides information on exports, commands, and events that are not covered under modules.


## Server Callbacks
We've implemented a system similar to ESX callbacks within the inventory. You can use both standard callbacks and Await callbacks.

!!! info "ox_inventory:getItemCount"
	=== "Standard"
		```lua
		ox.TriggerServerCallback('ox_inventory:getItemCount', callback, item, metadata, target)
		```
		```lua
		ox.TriggerServerCallback('ox_inventory:getItemCount', function(count)
			print('You currently have '..count..' water')
		end, 'water')
		```
	
		```lua
		ox.TriggerServerCallback('ox_inventory:getItemCount', function(count)
			print('Trunk contains '..count..' water')
		end, 'water', false, trunkEGZ 202)
		local count = ox.TriggerServerCallback('ox_inventory:getItemCount', 'water', false, 'trunkEGZ 202')
		```
	=== "Await"
		```lua
		ox.AwaitServerCallback('ox_inventory:getItemCount', item, metadata, target)
		```
		```lua
		print('You have '..ox.AwaitServerCallback('ox_inventory:getItemCount', 'water')..' water')
		```
		```lua
		local count = ox.AwaitServerCallback('ox_inventory:getItemCount', 'water', false, 'trunkEGZ 202')
		print('Trunk contains '..count..' water')
		```

!!! info "ox_inventory:getInventory"
	```lua
	ox.AwaitServerCallback('ox_inventory:getInventory', item, metadata, target)
	```
	```lua
	local inventory = ox.AwaitServerCallback('ox_inventory:getInventory', 'trunkEGZ 202')
	if inventory then
		print(('Inventory %s has the %s type, is able to hold up to %sg in %s different slots.\nCurrent weight: %sg'):format(
			inventory.id,
			inventory.type,
			inventory.maxWeight,
			inventory.slots,
			inventory.weight
		))
	end
	```
