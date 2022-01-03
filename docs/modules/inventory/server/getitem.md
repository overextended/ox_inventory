---
title: Inventory.GetItem
---
Searches an inventory for an item, returning generic item data and the count.

!!! info
	```lua
	exports.ox_inventory.GetItem(inv, item, metadata, returnsCount)
	```

	This function enhances the default functionality of `xPlayer.getInventoryItem`.

	| Argument     | Type    | Optional | Explanation |
	| ------------ | ------- | -------- | ----------- |
	| inv          | str/int | no       | The id of the inventory to add an item to, such as playerid |
	| item         | string  | no       | Name of the item to get |
	| metadata     | table   | yes      | Specific metadata to search for |
	| returnsCount | boolean | yes      | Only return the item count |

!!! example
	```lua
	local ox_inventory = exports.ox_inventory

	-- retrieve the amount of water held in inventory 1
	local water = ox_inventory:GetItem(1, 'water', false, true)

	if ox_inventory:GetItem(1, 'money', false, true) < 5 then
		print('1 has less than $5')
	end
	```