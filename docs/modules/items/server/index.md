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
