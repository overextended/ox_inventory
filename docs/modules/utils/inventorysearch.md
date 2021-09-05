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

!!! summary "Arguments"
	| Argument   | Type         | Optional | Explanation |
	| ---------- | ------------ | -------- | ----------- |
	| searchtype | integer      | no       | 1: Returns slots and data		2: Returns total count of item |
	| items      | string/table | no       | The name of an item - or array of item names - to search for |
	| metadata   | string/table | yes      | Required metadata values that must exist on an item to return data |


!!! example
	```lua
	local inventory = Utils.InventorySearch(1, {'meat', 'skin'}, {grade=1})
	if inventory then
		for name, data in pairs(inventory) do
			local count = 0
			for _, v in pairs(data) do
				if v.slot then
					print(v.slot..' contains '..v.count..' '..name..' '..json.encode(v.metadata))
					count = count + v.count
				end
			end
			print('You have '..count.. ' '..name)
		end
	end
	```
	```lua
	local inventory = Utils.InventorySearch(2, {'meat', 'skin'}, {grade=1})
	if inventory then
		for name, count in pairs(inventory) do
			print('You have '..count.. ' '..name)
		end
	end

	local count = Utils.InventorySearch(2, 'lockpick')['lockpick']
	print('You have '..count.. ' lockpicks')
	```
