---
title: Utils.InventorySearch
---

```lua
Utils.InventorySearch(searchtype, items, metadata)
```

```lua
exports.ox_inventory:InventorySearch(searchtype, items, metadata)
```

Returns a table containing data for the searched items, the result varying based on the provided searchtype.

| Argument   | Data Type       | Optional | Explanation                                                                              |
| ---------- | --------------- | -------- | ---------------------------------------------------------------------------------------- |
| searchtype | integer         | no       | 1 returns slot data; 2 returns total count                                               |
| items      | string or table | no       | An array of items to search for; permits a string for a single item                      |
| metadata   | string or table | yes      | A table of metadata values the item needs to contain; permits a string for metadata.type |

**Examples**

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

local inventory = Utils.InventorySearch(2, {'meat', 'skin'}, {grade=1})
if inventory then
	for name, count in pairs(inventory) do
		print('You have '..count.. ' '..name)
	end
end

local count = Utils.InventorySearch(2, 'lockpick')['lockpick']
print('You have '..count.. ' lockpicks')
```
