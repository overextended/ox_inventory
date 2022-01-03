---
title: Inventory.RemoveItem
---
Removes an item from the provided inventory.

!!! info
	```lua
	exports.ox_inventory:RemoveItem(inv, item, count, metadata, slot)
	```
		
	This function enhances the default functionality of `xPlayer.removeInventoryItem`.

	| Argument   | Type    | Optional | Explanation |
	| ---------- | ------- | -------- | ----------- |
	| inv        | string / integer | no       | The id of the inventory to remove the item from |
	| item       | string  | no       | Name of the item to remove |
	| count      | integer | no       | Number of items to remove |
	| metadata   | table   | yes      | Required metadata for removal |
	| slot       | integer | yes      | Try to remove the item from a specific slot |


!!! example
	```lua
	local ox_inventory = exports.ox_inventory

	-- check if
	local bread = ox_inventory:GetItem(2, 'bread')
	if bread.count > 4 then
		ox_inventory:RemoveItem(2, 'bread', 5)
	else
		print(('id 2 does only has %s %s'):format(bread.count, bread.label))
	end
	```