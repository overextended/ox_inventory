---
title: Server module
---
The server-side items module loads general item data, provides functions for manipulating items, and completes the startup process.

###Retrieve item data
!!! info
	```lua
	Items(name)
	```
	```lua
	exports.ox_inventory:Items(name)
	```
	The argument is optional and, if ignored, will return the full items list.

!!! example
	```lua
	local item, itemtype = Items(name)
	if item then
		print(item.name, item.weight, itemtype)
	end
	```
	
	| Item Type | Explanation |
	| --------- | ----------- |
	| nil       | Item        |
	| 1         | Weapon      |
	| 2         | Ammo        |
	| 3         | Component   |

###New item metadata
This function is used internally when adding or buying items to define default metadata values.
!!! info
	```lua
	Items.Metadata(xPlayer, item, metadata, count)
	```

	| Argument   | Explanation |
	| ---------- | ----------- |
	| xPlayer    | Player triggering the function |
	| item       | Name of the item being manipulated |
	| metadata   | Extra metadata to be added to the item |
	| count      | Number of items to be added |