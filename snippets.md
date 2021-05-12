---
title: Snippets
---

| [Installation](index) | [Usage](usage) | [Snippets](snippets) | [Other Resources](resources) | [Media](media)


## Police body search
* It's just /steal in a menu basically
* Find `OpenBodySearchMenu(closestPlayer)` and replace it with `exports['linden_inventory']:OpenTargetInventory()`
* Find and remove the `OpenBodySearchMenu` function


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

## Support for loaf_housing
* This is a single unified storage. If you want it for each piece of furniture, figure it out
* Find the `OpenStorage` function and replace with
```lua
OpenStorage = function(houseid, k, v)
    exports['linden_inventory']:OpenStash({ name = ('house %s'):format(houseid), slots = 101})
end
```

## Set player death status
* There are better ways to do this, but for the simplest method search go to `esx_ambulancejob/server/main.lua`
* Locate `RegisterNetEvent('esx_ambulancejob:setDeathStatus')` and add the following
```lua
	TriggerClientEvent('esx_ambulancejob:setDeathStatus', xPlayer.source, isDead)
```

## Display inventory items
* The default method for looping through the inventory will still function, however it will not stack items of the same name
* The below function will count up items with the same name, though it doesn't check metadata
```lua
	local inv = {}
	for k, v in pairs(ESX.GetPlayerData().inventory) do
		if inv[v.name] then
			inv[v.name].count = inv[v.name].count + v.count
		else inv[v.name] = v end
	end
	for k, v in pairs(inv) do
		print(k, v.count)
	end
```
