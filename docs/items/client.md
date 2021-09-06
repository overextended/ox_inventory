---
title: Creating usable items
---
The recommended method for registering items as usable is adding a function to ++modules/items/client.lua++.
It is still possible to use items through ESX.RegisterUsableItem, though it is less flexible.

!!! info
	```lua
    Item(name, callback)
	```

	| Argument | Data Type | Optional | Explanation |
	| -------- | --------- | -------- | ----------- |
	| name     | string    | no       | The name of the item to apply the function to |
	| callback | function  | no       | Creates a function to be triggered when an item is used |

!!! example
	=== "Sample"
		```lua
		Item(name, function(data, slot)
			-- Trigger on use
			TriggerEvent('ox_inventory:item', data, function(data)
				-- Trigger after use
			end)
		end)
		```
	=== "Example"
		```lua
		Item('bandage', function(data, slot)
			local maxHealth = 200
			local health = GetEntityHealth(ESX.PlayerData.ped)
			if health < maxHealth then
				TriggerEvent('ox_inventory:item', data, function(data)
					if data then
						SetEntityHealth(ESX.PlayerData.ped, math.min(maxHealth, math.floor(health + maxHealth / 16)))
						TriggerEvent('ox_inventory:Notify', {text = 'You feel better already'})
					end
				end)
			end
		end)
		```