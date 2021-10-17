---
title: Inventory.Search
---
Returns a table containing data for the searched items, the result varying based on the provided searchtype.

!!! info
	```lua
	Inventory.Search(searchtype, items, metadata)
	```
	```lua
	exports.ox_inventory:Search(searchtype, items, metadata)
	```

	| Argument   | Type    | Optional | Explanation |
	| ---------- | ------- | -------- | ----------- |
	| searchtype | integer | no       | 1: Returns slots and data, 2: Returns total count of item |
	| items      | table   | no       | Array of item names to search for |
	| metadata   | table   | yes      | Metadata pairs that must exist on the found item |
	
	Items and metadata will accept a string, though it limits you to searching for metadata.type


!!! example
	=== "Single item data"
		```lua
		local water = Inventory.Search(1, 'water')
		local count = 0
		for _, v in pairs(water) do
			print(v.slot..' contains '..v.count..' water '..json.encode(v.metadata))
			count = count + v.count
		end
		print('You have '..count..' water')
		```
	=== "Multiple items data"
		```lua
		local inventory = Inventory.Search(1, {'meat', 'skin'}, 'deer')
		if inventory then
			for name, data in pairs(inventory) do
				local count = 0
				for _, v in pairs(data) do
					if v.slot then
						print(v.slot..' contains '..v.count..' '..name..' '..json.encode(v.metadata))
						count = count + v.count
					end
				end
				print('You have '..count..' '..name)
			end
		end
		```
	=== "Single item count"
		```lua
		local count = Inventory.Search(2, 'water')
		print('You have '..count.. ' water')
		```
	=== "Multiple items count"
		```lua
		local inventory = Inventory.Search(2, {'meat', 'skin'}, {grade=1})
		if inventory then
			for name, count in pairs(inventory) do
				print('You have '..count..' '..name)
			end
		end
		```
