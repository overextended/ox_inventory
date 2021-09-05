---
title: Utils.MatchTables
---

```lua
Utils.MatchTables(table1, table2)
```

```lua
exports.ox_inventory:MatchTables(table1, table2)
```

Returns true or false if the two provided elements contain the exact same entries.

**Examples**

```lua
if Utils.MatchTables(toSlot.metadata, fromSlot.metadata) then
	print('Item metadata perfectly matches, so they can stack')
end
```
