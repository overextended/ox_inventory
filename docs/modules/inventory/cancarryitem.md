---
title: Inventory.CanCarryItem
---
Checks if the provided inventory is capable of holding new items.

!!! info
	```lua
	Inventory.CanCarryItem(inv, item, count, metadata)
	```
	This function enhances the default functionality of `xPlayer.canCarryItem`.

	| Argument | Type   | Optional | Explanation |
	| -------- | ------ | -------- | ----------- |
	| inv      | id     | no       | Which inventory to check |
	| item     | string | no       | Name of the item |
	| count    | number | no       | Number of items |
	| metadata | table  | yes      | Metadata values to compare |

!!! example
	```lua
	local item = Inventory.GetItem(2, 'bread')
	if item and item.count > 5 then
		if Inventory.CanCarryItem(1, 'bread' 5) then
			Inventory.RemoveItem(2, 'bread')
			Inventory.AddItem(1, 'bread')
		else
			print(Inventory(1).label..' is unable to carry 5 bread')
		end
	else
		print(Inventory(2).label..' does not have 5 bread')
	end
	```