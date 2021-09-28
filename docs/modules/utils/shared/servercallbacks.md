## Server Callbacks
We've implemented a system similar to ESX callbacks within the inventory. You can use both standard callbacks and Await callbacks.

!!! info "ox_inventory:getItemCount"
	=== "Standard"
		```lua
		Utils.TriggerServerCallback('ox_inventory:getItemCount', callback, item, metadata, target)
		```
		```lua
		Utils.TriggerServerCallback('ox_inventory:getItemCount', function(count)
			print('You currently have '..count..' water')
		end, 'water')
		```
	
		```lua
		Utils.TriggerServerCallback('ox_inventory:getItemCount', function(count)
			print('Trunk contains '..count..' water')
		end, 'water', false, trunkEGZ 202)
		local count = Utils.TriggerServerCallback('ox_inventory:getItemCount', 'water', false, 'trunkEGZ 202')
		```
	=== "Await"
		```lua
		Utils.AwaitServerCallback('ox_inventory:getItemCount', item, metadata, target)
		```
		```lua
		print('You have '..Utils.AwaitServerCallback('ox_inventory:getItemCount', 'water')..' water')
		```
		```lua
		local count = Utils.AwaitServerCallback('ox_inventory:getItemCount', 'water', false, 'trunkEGZ 202')
		print('Trunk contains '..count..' water')
		```

!!! info "ox_inventory:getInventory"
	```lua
	Utils.AwaitServerCallback('ox_inventory:getInventory', item, metadata, target)
	```
	```lua
	local inventory = Utils.AwaitServerCallback('ox_inventory:getInventory', 'trunkEGZ 202')
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
