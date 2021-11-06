---
title: Inventory.AddItem
---
Adds an item to the specified inventory.

!!! info
	```lua
	Inventory.AddItem(inventory, item, count, metadata, slot)
	```

	| Argument   | Type    | Optional | Explanation |
	| ---------- | ------- | -------- | ----------- |
	| inventory  | str/int | no       | The id of the inventory to add an item to, such as playerid |
	| item       | string  | no       | Name of the item to add |
	| count      | integer | no       | Number of items to add |
	| metadata   | table   | yes      | Metadata to assign to the given item |
	
	This function should be used in combination with `Inventory.CanCarryItem` to ensure space is available.