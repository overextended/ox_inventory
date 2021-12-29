---
title: Inventory.Search
---
Returns a table containing data for the searched items, the result varying based on the provided searchtype.

!!! info
	```lua
	exports.ox_inventory:Search(inventory, searchtype, items, metadata)
	```

	| Argument   | Type    | Optional | Explanation |
	| ---------- | ------- | -------- | ----------- |
	| inventory  | str/int | no       | The id of the inventory to search, such as playerid or a plate |
	| searchtype | integer | no       | 1: Returns slots and data, 2: Returns total count of item |
	| items      | table   | no       | Array of item names to search for |
	| metadata   | table   | yes      | Metadata pairs that must exist on the found item |
	
	Items and metadata will accept a string, though it limits you to searching for metadata.type


!!! example
	=== "Single item data"
		```lua
		local ox_inventory = exports.ox_inventory

		local water = ox_inventory:Search(3, 1, 'water')
		local count = 0
		for _, v in pairs(water) do
			print(v.slot..' contains '..v.count..' water '..json.encode(v.metadata))
			count = count + v.count
		end
		print('Player 3 has '..count..' water')
		```
	=== "Multiple items data"
		```lua
		local ox_inventory = exports.ox_inventory

		local inventory = ox_inventory:Search(377346, 1, {'meat', 'skin'}, 'deer')
		if inventory then
			for name, data in pairs(inventory) do
				local count = 0
				for _, v in pairs(data) do
					if v.slot then
						print(v.slot..' contains '..v.count..' '..name..' '..json.encode(v.metadata))
						count = count + v.count
					end
				end
				print('Drop 377346 contains deer '..count..' '..name)
			end
		end
		```
	=== "Single item count"
		```lua
		local ox_inventory = exports.ox_inventory

		local count = ox_inventory:Search('trunk-GEZ 461', 2, 'water')
		print('Vehicle contains '..count.. ' water')
		```
	=== "Multiple items count"
		```lua
		local ox_inventory = exports.ox_inventory

		local inventory = ox_inventory:Search(1, 2, {'meat', 'skin'}, {grade=1})
		if inventory then
			for name, count in pairs(inventory) do
				print('Player 1 has '..count..' '..name)
			end
		end
		```
