---
title: Inventory.SetMetadata
---
Replaces the metadata table on an item with new values.

!!! info
	```lua
	local Inventory = exports.ox_inventory:Inventory()
	```
	```lua
	Inventory.SetMetadata(source, item, metadata, slot)
	```

	| Argument   | Type    | Optional | Explanation |
	| ---------- | ------- | -------- | ----------- |
	| source     | integer | no       | The id of the inventory being accessed |
	| item       | string  | no       | Name of the item |
	| metadata   | table   | no       | New metadata values |
	| slot       | integer | yes      | The slot being modified |
	
	This will replace all metadata values, so if you want to change a value you need to get the item data first.


!!! example
	=== "Add item metadata"
		```lua
		local water = Inventory.Search(xPlayer.source, 1, 'water')
		for k, v in pairs(water) do
			print('\n______________'..'\n- index '..k)
			print(v.name, 'slot: '..v.slot, 'metadata: '..json.encode(v.metadata))
			water = v
		end
		water.metadata = {
			type = 'clean'
		}
		Inventory.SetMetadata(xPlayer.source, v.name, water.metadata, water.slot)
		print('Player 3 has '..count..' water')
		```
