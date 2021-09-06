---
title: Utils.TableContains
---
Returns true if the first table contains all the elements from the second table.

!!! info
	```lua
	Utils.TableContains(table1, table2)
	```

	```lua
	exports.ox_inventory:TableContains(table1, table2)
	```

!!! example
	```lua
	for k, v in pairs(ESX.GetPlayerData().Inventory) do
		if v.name == 'meat' and Utils.TableContains(v.metadata, {grade=1}) then
			count = count + v.count
		end
	end
	```