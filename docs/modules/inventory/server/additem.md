---
title: Inventory.AddItem
---
Adds an item to the specified inventory.

!!! info
	```lua
	exports.ox_inventory.AddItem(inv, item, count, metadata, slot)
	```

	| Argument   | Type    | Optional | Explanation |
	| ---------- | ------- | -------- | ----------- |
	| inv        | string / integer | no       | The id of the inventory to add an item to, such as playerid |
	| item       | string  | no       | Name of the item to add |
	| count      | integer | no       | Number of items to add |
	| metadata   | table   | yes      | Metadata to assign to the given item |
	
	This function should be used in combination with `Inventory.CanCarryItem` to ensure space is available.

	```lua
	local ox_inventory = exports.ox_inventory

	ox_inventory:AddItem(1, 'water', 3, {description = 'Looks a little yellow..'})
	```