---
title: Inventory.SetMetadata
---
Replaces the metadata table on an item with new values.

!!! info
	```lua
	exports.ox_inventory:SetMetadata(source, slot, metadata)
	```

	| Argument   | Type    | Optional | Explanation |
	| ---------- | ------- | -------- | ----------- |
	| source     | integer | no       | The id of the inventory being accessed |
	| slot       | integer | no       | The slot being modified |
	| metadata   | table   | no       | New metadata values |
	
	This will replace all metadata values, so if you want to change a value you need to get the item data first.


!!! example
	```lua
	local ox_inventory = exports.ox_inventory

	local water = ox_inventory:Search(xPlayer.source, 1, 'water')
	for k, v in pairs(water) do
		print('\n______________'..'\n- index '..k)
		print(v.name, 'slot: '..v.slot, 'metadata: '..json.encode(v.metadata))
		water = v
	end
	water.metadata.type = 'clean'
	ox_inventory:SetMetadata(xPlayer.source, water.slot, water.metadata)
	print(('modified %sx water in slot %s with new metadata'):format(water.count, water.slot))
	```
