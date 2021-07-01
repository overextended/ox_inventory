---
title: Snippets
---


#### Client-side check for items
* This concerns the usage of the SearchItems exports from `client/exports.lua`
* You can define as many items as you want to search for to get all the results.
* When searching for metadata, using a string will search for `metadata.type`
* To search for specific metadata use a table such as `{grade=1, type='Deer meat'}`
* Only partial metadata matches are required, so extra metadata will not return false
##### Example 1: Search for grade 1 meat and skin (any animal)
```lua
	local inventory = exports['linden_inventory']:SearchItems({'meat', 'skin'}, {grade=1})
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
##### Example 2: Search for any type of meat
```lua
	local inventory = exports['linden_inventory']:SearchItems({'meat'})
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
##### Example 3: Alternative method of checking multiple items
```lua
	local inventory = exports['linden_inventory']:SearchItems({'meat', 'skin'})
	if inventory then
		local meat, skin = 0, 0
		for name, v in pairs(inventory.meat) do
			if v.slot then
				print(v.slot..' contains '..v.count..' '..name..' '..json.encode(v.metadata))
				count = count + v.count
			end
		end
		print('You have '..meat.. ' meat')
		for name, v in pairs(inventory.skin) do
			if v.slot then
				print(v.slot..' contains '..v.count..' '..name..' '..json.encode(v.metadata))
				count = count + v.count
			end
		end
		print('You have '..skin.. ' skin')
	end
```
##### Example 4: Only return item counts
```lua
	local items, result = {['water']=false, ['meat']=false, ['skin']=false}
	local inventory = ESX.GetPlayerData().inventory
	for k,v in pairs(inventory) do
		if items[v.name] then
			if result[v.name] then
				result[v.name] = result[v.name].count + v.count
			else
				result[v.name] = v.count
			end
		end
	end
	for k,v in pairs(result) do
		print('You have '..v..' '..k)
	end
```



#### Police body search
* It's just /steal in a menu basically
* Find `OpenBodySearchMenu(closestPlayer)` and replace it with `exports['linden_inventory']:OpenTargetInventory()`
* Find and remove the `OpenBodySearchMenu` function


#### Clearing player inventory
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
