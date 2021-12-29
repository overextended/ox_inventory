---
title: Server module
---
The inventory module handles most inventory-related functions and stores all current inventory data.  
Many of the functions provided in this module are similar to the `xPlayer` functions, however they can be used for non-player inventories too.

!!! info
	```lua
	exports.ox_inventory:Inventory(id)
	```
	
	When utilising the inventory in a resource, it is recommended to store a variable to reference the inventory for performance and convenience.

!!! example
	```lua
	-- define an alias at the top of your script
	local ox_inventory = exports.ox_inventory

	-- give 2 water to inventory id 1
	ox_inventory:AddItem(1, 'water', 2)
	
	-- print all items in inventory id 1
	print(json.encode(ox_inventory:Inventory(1).items, {indent=true}))
	```
