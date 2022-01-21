---
title: Creating custom drops
---
Allows server-side creation of a drop with pre-defined items and a custom prefix.
todo: more details, move to Guides

!!! info
	```lua
	exports.ox_inventory:CustomDrop(prefix, items, coords, slots, maxWeight)
	```
	
	| Argument   | Type    | Default              | Optional | Explanation |
	| ---------- | ------- | -------------------- | -------- | ----------- |
	| prefix     | string  | -                    | no       | Label text before the drop id |
	| items      | table   | -                    | no       | An array of items to add (more below) |
	| coords     | vector3 | -                    | no       | Where should the drop be created |
	| slots      | integer | Config.PlayerSlots   | yes      | How many slots are in the drop |
	| maxWeight  | integer | Config.DefaultWeight | yes      | How much weight can be stored |

!!! example "Defining items"
	```lua
	local ox_inventory = exports.ox_inventory

	ox_inventory:CustomDrop('Carcass', {
		{'meat', 5, {grade=2, type='deer'}},
		{'hide', 5, {grade=2, type='deer'}}
	}, entityCoords)
	```
	Creates a "Carcass" drop on some supplied coordinates, containing meat and hide from a deer.

	| Option | Type    | Optional | Explanation |
	| ------ | ------- | -------- | ----------- |
	| 1      | string  | no       | Name of the item to add |
	| 2      | integer | no       | Number of items to add |
	| 3      | table   | yes      | Metadata table to apply to the item |
