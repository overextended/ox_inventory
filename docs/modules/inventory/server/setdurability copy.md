---
title: Inventory.GetCurrentWeapon
---
Gets information about the weapon equipped by a player.

!!! info
	```lua
	exports.ox_inventory.GetCurrentWeapon(inv)
	```

	| Argument     | Type    | Optional | Explanation |
	| ------------ | ------- | -------- | ----------- |
	| inv          | str/int | no       | The id of the inventory |

!!! example
	```lua
	local ox_inventory = exports.ox_inventory

	local weapon = ox_inventory:GetCurrentWeapon(1)

	print(json.encode(weapon, {indent=true}))
	```