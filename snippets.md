---
title: Snippets
---


## Police body search
* It's just /steal in a menu basically
* Find `OpenBodySearchMenu(closestPlayer)` and replace it with `exports['linden_inventory']:OpenTargetInventory()`
* Find and remove the `OpenBodySearchMenu` function


## Clearing player inventory
* Trigger the following event when you want to wipe their inventory (such as when dying)
```lua
	TriggerEvent('linden_inventory:clearPlayerInventory', playerId)
```
* You can use the following events to temporarily remove their inventory (such as when getting sent to jail, then released)
```lua
	TriggerEvent('linden_inventory:confiscatePlayerInventory', playerId)
	TriggerEvent('linden_inventory:recoverPlayerInventory', playerId)
```


## Support for esx_property
* Find and remove the following two blocks of code from `client/main.lua`
```lua
	table.insert(elements, {label = _U('remove_object'),  value = 'room_inventory'})
	table.insert(elements, {label = _U('deposit_object'), value = 'player_inventory'})
```
```lua
	elseif data.current.value == 'room_inventory' then
		OpenRoomInventoryMenu(property, owner)
	elseif data.current.value == 'player_inventory' then
		OpenPlayerInventoryMenu(property, owner)
```
* Add this new event to the bottom of the file
```lua
	AddEventHandler('linden_inventory:getProperty', function(cb)
		if CurrentAction == 'room_menu' then
			cb({name = CurrentActionData.property.name, label = CurrentActionData.property.label, owner = CurrentActionData.owner, slots = 70})
		end
	end)
```
* If you were using the previous method it should still work, though I recommend adding the label


## Support for loaf_housing (per furniture)
* Find the `OpenStorage` function and replace with
```lua
OpenStorage = function(houseid, k, v)
    exports['linden_inventory']:OpenStash({owner = currentHouseOwner, id = 'house'..houseid..'-'..k, label = v.label, slots = 20 })
end
```
* Find the `EnterHouse` function, and below `if type(success) == "table" then` add
```lua
currentHouseOwner = success.owner
```
* Search for `spawned_houses[houseid] = {` and within the table add (to both instances)
```lua
owner = owner
```
