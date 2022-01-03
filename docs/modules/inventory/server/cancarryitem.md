---
title: Inventory.CanCarryItem
---
Checks if the provided inventory is capable of holding new items.

!!! info
	```lua
	exports.ox_inventory.CanCarryItem(inventory, item, count, metadata)
	```

	This function enhances the default functionality of `xPlayer.canCarryItem`.

	| Argument | Type    | Optional | Explanation |
	| -------- | ------- | -------- | ----------- |
	| inv      | str/int | no       | Which inventory to check |
	| item     | string  | no       | Name of the item |
	| count    | number  | no       | Number of items |
	| metadata | table   | yes      | Metadata values to compare |

!!! example
	```lua
	local ox_inventory = exports.ox_inventory

	local item = ox_inventory:GetItem(2, 'bread')
	if item and item.count > 5 then
		if ox_inventory:CanCarryItem(1, 'bread' 5) then
			ox_inventory:RemoveItem(2, 'bread', 5)
			ox_inventory:AddItem(1, 'bread', 5)
		else
			print(ox_inventory:Inventory(1).label..' is unable to carry 5 bread')
		end
	else
		print(ox_inventory:Inventory(2).label..' does not have 5 bread')
	end
	```