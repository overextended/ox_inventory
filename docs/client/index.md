---
title: Index
---
This category provides information on exports, commands, and events that are not covered under modules.


## Server Callbacks
!!! info "ox_inventory:getItemCount"
	```lua
	ox.TriggerServerCallback('ox_inventory:getItemCount', item, metadata, target)
	```
	=== "Self"
		```lua
		local count = ox.TriggerServerCallback('ox_inventory:getItemCount', 'water')
		if count then print('You currently have '..count..' water')
		```
	=== "Target"
		```lua
		local count = ox.TriggerServerCallback('ox_inventory:getItemCount', 'water', false, 'trunkEGZ 202')
		if count then print('Trunk contains '..count..' water')
		```

!!! info "ox_inventory:getInventory"
	```lua
	ox.TriggerServerCallback('ox_inventory:getInventory', item, metadata, target)
	```
	```lua
	local inventory = ox.TriggerServerCallback('ox_inventory:getInventory', 'trunkEGZ 202')
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