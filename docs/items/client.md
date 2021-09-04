---
title: Creating new items
---

The client module handles item usage.

```lua
Item(name, callback)
```

Sets an item as usable and defines the effects after being triggered.

| Argument | Data Type | Optional | Explanation                                       |
| -------- | --------- | -------- | ------------------------------------------------- |
| name     | string    | no       | The name of the item to apply the function to     |
| callback | function  | no       | Performs actions before and after an item is used |

**Example**

```lua
-- Receives general data about bandages, and the slot being used
Item('bandage', function(data, slot)
	local maxHealth = 200
	local health = GetEntityHealth(ESX.PlayerData.ped)
	-- Checks if the item meets usage requirements
	if health < maxHealth then
		-- Triggers an event to check if the item can be used and exists on the server
		TriggerEvent('ox_inventory:item', data, function(data)
			-- When the callback function is triggered, receive server data and trigger the use effects
			if data then
				SetEntityHealth(ESX.PlayerData.ped, math.min(maxHealth, math.floor(health + maxHealth / 16)))
				TriggerEvent('ox_inventory:Notify', {text = 'You feel better already'})
			end
		end)
	end
end)
```
