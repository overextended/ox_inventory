---
title: Inventory.SetDurability
---
Sets the metadata.durability of a specific slot.

!!! info
	```lua
	exports.ox_inventory.SetDurability(inv, slot, durability)
	```

	| Argument     | Type    | Optional | Explanation |
	| ------------ | ------- | -------- | ----------- |
	| inv          | str/int | no       | The id of the inventory |
	| slot         | integer | no       | Slot to retrieve data from |
	| durability   | integer | no       | Value to set |

!!! example
	```lua
	local ox_inventory = exports.ox_inventory

	-- Set the durability of the item in slot 3 of player 1's inventory to 100
	ox_inventory:SetDurability(1, 3, 100)

	-- Set the durability of the player 1's current weapon to 100
	local weapon = ox_inventory:GetCurrentWeapon(1)

	if weapon then
		ox_inventory:SetDurability(1, weapon.slot, 100)
	end
	```