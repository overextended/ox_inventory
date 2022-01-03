---
title: Inventory.OpenInventory
---
Trigger an event on the player to open an inventory.

!!! info
	```lua
	TriggerEvent('ox_inventory:openInventory', inv, data)
	```

	| Argument   | Type    | Optional | Explanation |
	| ---------- | ------- | -------- | ----------- |
	| inv		 | string  | no       | The inventory's type (player, shop, trunk, stash, container, policeevidence) |
	| data       | table   | no       | Extra information for the inventory you're opening |
	

!!! example

	=== "Player"

		```lua
		TriggerEvent('ox_inventory:openInventory', 'player', targetId [int])
		TriggerClientEvent('ox_inventory:openInventory', id, 'player', targetId [int])
		```

	=== "Stash"

		```lua
		TriggerEvent('ox_inventory:openInventory', 'stash', 'police_stash')
		TriggerClientEvent('ox_inventory:openInventory', id, 'stash', 'police_stash')
		```

		* To open a stash you must first use [RegisterStash](../../customstash)	