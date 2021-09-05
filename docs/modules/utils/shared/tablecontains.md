---
title: Utils.TableContains
---

```lua
Utils.TableContains(table, value)
```

```lua
exports.ox_inventory:TableContains(table, value)
```

Returns true or false if the table contains a given value.

**Examples**

```lua
for k, v in pairs(ESX.GetPlayerData().Inventory) do
	if v and v.name == 'meat' and Utils.TableContains(v.metadata, {grade=1}) then
		count = count + v.count
	end
end
```
