---
title: Server item handling
---

The server module provides both data and functions for use within the resource and externally.

- Triggers an event after resource initialisation to receive the item list in another resource
- Registers items using ESX item callbacks as usable
- Automatically dumps the items database into the items data file
- Applies default metadata values for specified items
- Allows lookup of item data

```lua
Items(name)
```

```lua
exports.ox_inventory:Items(name)
```

Returns general data for the given item name, or all data if no argument is provided.

| Argument | Data Type | Optional | Explanation                          |
| -------- | --------- | -------- | ------------------------------------ |
| name     | string    | yes      | Name of the item to receive data for |

**Example**

```lua
local item, itemtype = Items(name)
if item then
	print(item.name, item.weight, itemtype)
end
```

| Item Type | Explanation |
| --------- | ----------- |
| nil       | Item        |
| 1         | Weapon      |
| 2         | Ammo        |
| 3         | Component   |
