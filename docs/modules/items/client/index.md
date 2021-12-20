---
title: Client module
---
The client-side items module holds general item data, and provides functions when using items.

###Retrieve item data
!!! info
	```lua
	Items(name)
	```
	The argument is optional and, if ignored, will return the full items list.
	```lua
	Items = exports.ox_inventory:Items(name)
	```

!!! example
	```lua
	local item = Items(name)
	if item then
		print(item.name, item.weight)
	end
	```
	