---
title: Index
---
The inventory module handles most inventory-related functions and stores all current inventory data.  
Many of the functions provided in this module are similar to the `xPlayer` functions, however they can be used for non-player inventories too.

!!! info
	```lua
	Inventory(id)
	```
	```lua
	exports.ox_inventory:Inventory(id)
	```
	The argument is optional - by providing it you will receive a specific inventory object, otherwise you gain access to all module functions.

!!! example
	```lua
	local Inventory = exports.ox_inventory:Inventory()
	Inventory.AddItem(1, 'water', 1)
	print(json.encode(exports.ox_inventory:Inventory(1).items))
	```
	The first export grants access to all the functions (you don't _have to_ define it locally).  
	After adding an item to the inventory, the second export will retrieve inventory id 1 and print out all items.