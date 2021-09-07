---
title: Custom drops
---
Allows simple creation of a drop with a custom prefix.

!!! info
	```lua
	TriggerEvent('ox_inventory:customDrop', prefix, coords, items, slots, maxWeight)
	```
	
	| Argument   | Type    | Default              | Optional | Explanation |
	| ---------- | ------- | -------------------- | -------- | ----------- |
	| prefix     | string  | -                    | no       | Label text before the drop id |
	| coords     | vector3 | -                    | no       | Where should the drop be created |
	| items      | table   | -                    | no       | Table of items to be added to the drop |
	| slots      | integer | Config.PlayerSlots   | yes      | How many slots are in the drop |
	| maxWeight  | integer | Config.DefaultWeight | yes      | How much weight can be stored |

!!! summary "Defining items"
	Documentation to be written, pending a function for easy item generation. Currently requires defining all the item variables manually.