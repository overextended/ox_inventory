---
title: Server module
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

!!! danger
	The following functions are intended for internal use _only_. They are documented here for convenience.  
	Using or modifying these functions may break intended functionality.

###Module functions
!!! info
	```lua
	Inventory.SyncInventory(xPlayer, inv)
	```
	Updates the xPlayer with correct inventory, weight, maxWeight, and accounts values.

!!! info
	```lua
	Inventory.SetSlot(inventory, item, count, metadata, slot)
	```
	Sets the current item, count, and metadata of a slot.

!!! info
	```lua
	Inventory.SlotWeight(item, slot)
	```
	Updates the weight values of a slot depending on item count, ammo, and metadata.

!!! info
	```lua
	Inventory.Remove(id, type)
	```
	Deletes the inventory for the provided id. Ensures drops are removed from clients.

!!! info
	```lua
	Inventory.Save(inv)
	```
	Saves an inventory to the database immediately.

!!! info
	```lua
	Inventory.Load(id, inventory, owner)
	```
	Loads an inventory from the database.