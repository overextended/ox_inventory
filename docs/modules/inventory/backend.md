---
title: Module functions
---
!!! danger
	The following functions intended for internal use _only_. They are documented here for convenience.  
	Using or modifying these functions may break intended functionality.

###Local functions
!!! info
	```lua
	GetItemSlots(inv, item, metadata)
	```
	Returns the slots and total count of an item, and the number of empty slots in the provided inventory.

###Module functions
!!! info
	```lua
	Inventory.SyncInventory(xPlayer, inv)
	```
	Updates the xPlayer with correct inventory, weight, maxWeight, and accounts values.

!!! info
	```lua
	Inventory.SetSlot(inv, item, count, metadata, slot)
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
	Inventory.Load(id, inv, owner)
	```
	Loads an inventory from the database.