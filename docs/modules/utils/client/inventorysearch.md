---
title: Utils.InventorySearch
---
Returns a table containing data for the searched items, the result varying based on the provided searchtype.

!!! info
	```lua
	Utils.InventorySearch(searchtype, items, metadata)
	```
	```lua
	exports.ox_inventory:InventorySearch(searchtype, items, metadata)
	```

!!! summary preserve_tabs "Arguments"
	| Argument   | Type         | Optional | Explanation |
	| ---------- | ------------ | -------- | ----------- |
	| searchtype | integer      | no       | 1: Returns slots and data		2: Returns total count of item |
	| items      | string/table | no       | The name of an item - or array of item names - to search for |
	| metadata   | string/table | yes      | Required metadata values that must exist on an item to return data |


!!! example
	=== "Single item data"
		```lua
		local lockpick = Utils.InventorySearch(1, 'lockpick')
		local count = 0
		for _, v in pairs(lockpick) do
			print(v.slot..' contains '..v.count..' lockpicks '..json.encode(v.metadata))
			count = count + v.count
		end
		print('You have '..count..' lockpicks)
		```
	=== "Multiple items data"
		```lua
		local inventory = Utils.InventorySearch(1, {'meat', 'skin'}, 'deer')
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
		local count = Utils.InventorySearch(2, 'lockpick')
		print('You have '..count.. ' lockpicks')
		```
	=== "Multiple items count"
		```lua
		local inventory = Utils.InventorySearch(2, {'meat', 'skin'}, {grade=1})
		if inventory then
			for name, count in pairs(inventory) do
				print('You have '..count..' '..name)
			end
		end
		```
