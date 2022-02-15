---
title: Inventory.GetSlot
---
Returns slot information for the item in a specific slot.

!!! info
	```lua
	exports.ox_inventory.GetItem(inv, slot)
	```

	| Argument     | Type    | Optional | Explanation |
	| ------------ | ------- | -------- | ----------- |
	| inv          | str/int | no       | The id of the inventory |
	| slot         | integer | no       | Slot to retrieve data from |

!!! example
	```lua
	local ox_inventory = exports.ox_inventory

	local item = ox_inventory:GetSlot(1, 3)
	print('Slot 3 of inventory 1 contains:', json.encode(item, {indent=true}))
	```