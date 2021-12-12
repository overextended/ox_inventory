---
title: Client module
---
The client-side items module holds general item data, and provides functions when using items.

###Retrieve item data
!!! info
	```lua
	Items = GlobalState.itemList

	AddStateBagChangeHandler('itemList', 'global', function(bagName, key, value, reserved, replicated)
		client.items = value
	end)
	```
	