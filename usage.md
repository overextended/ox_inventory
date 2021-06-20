---
title: Usage
---


## xPlayer functions
* Compatibility is important, that's why we've modified the framework with the inventory exports
* All functions will work as they did previously, with some extra benefits such as metadata
* Assigning metadata will work with a single word or a table (commands will not work for tables)

#### [#](usage/give-item) Give player an item
```lua
  xPlayer.addInventoryItem(water, 1, {type='pee', description='it smells a little funky'})
  
  /giveitem [id] [item] [count] [metadata.type (single word)]
```
* This would give water with the type and description in the item information

#### [#](usage/remove-item) Remove an item
```lua
  xPlayer.removeInventoryItem(water, 1, {type='pee', description='it smells a little funky'})
  
  /remove [id] [item] [count] [metadata.type (single word)]
```
* This would only remove an item with matching metadata
* Leaving the metadata blank will remove any item with that name

#### [#](usage/get-item) Get item data
```lua
  local metadata = {type='pee',description='it smells a little funky'}
  xPlayer.getInventoryItem(water, metadata)
```
* If you have 10 water but only one with metadata, the returning count is one

#### [#](usage/item-data) Retrieve item data from server
```lua
  ESX.TriggerServerCallback('linden_inventory:getItem',function(xItem)
    water = xItem
    print(xItem.count)
  end, 'water')
```
or
```lua
  ESX.TriggerServerCallback('linden_inventory:getItemCount',function(count)
    water = count
    print(count)
  end, 'water')
```

#### [#](usage/item-data) Check item data
* Example server command, print the serial of the item in slot one
```lua
RegisterCommand('getmeta', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local slot = exports['linden_inventory']:getPlayerSlot(xPlayer, 1)
	print(slot.metadata.serial)
end, true)
```
* On the client you can simply refer to the inventory slot
```lua
	print(ESX.PlayerData.inventory[3].metadata.serial
```

#### [#](usage/stash) Open a stash
* If you want anybody to be able to use a stash, do not define job
* Stashes should have unique names so they do not share
* You can define an owner for a stash, attaching their player identifier
* You can have owned stashes with the same name as long as the identifier doesn't match
```lua
	exports['linden_inventory']:OpenStash({ id = 'Hospital Locker', slots = 70, job= 'ambulance'})
	exports['linden_inventory']:OpenStash({ id = 'Bank Deposit Box', slots = 20, owner = ESX.GetPlayerData().identifier()})
	exports['linden_inventory']:OpenStash({ id = 'Personal Locker', slots = 20, job = 'police', owner = ESX.GetPlayerData().identifier()})
```
* Example for adding a stash to `esx_property` in Snippets

<br>

* I advise looking at `server/player.lua` to see all the different functions and learn how they work
* You can set literally anything in metadata, but only certain things will display in the item information
* There is specific metadata assigned for weapons and identification in `server/functions.lua`
* Look through some of the metadata from `shared/shops.lua` as well
* You could register a client event to show an item's metadata such as `metadata.registered` (which will tell you who bought a gun)


#### [#](usage/new-item) Creating new items
All your old items using `ESX.RegisterUsableItem` still work, however I would personally register items through the inventory
* Adding an item to `shared/items.lua` (use the existing for examples) will register the item as usable
* Setting consume to `0` means it's unlimited usage, otherwise it sets the number to remove (default is 1, do not define)
* Set how long it takes to use an item, animations to trigger, and props to attach (through mythic_progbar)
* Set items to add or remove hunger, thirst, stress, or drunk
* Trigger events callbacks when the item is used with `event`
* You can define existing events from other resources, or add new ones to `client/items.lua`

```lua
	['burger'] = {
		label = 'Burger',
		weight = 220,
		stack = true,
		close = true,
		client = {
			status = { hunger = 200000 },
			anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
			prop = { model = 'prop_cs_burger_01', pos = { x = 0.02, y = 0.02, y = -0.02}, rot = { x = 0.0, y = 0.0, y = 0.0} },
			usetime = 2500,
			event = true,
		}
	},
```

```lua
AddEventHandler('linden_inventory:burger', function(item, wait, cb)
	cb(true)
	SetTimeout(wait, function()
		if not cancelled then
			TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'You ate a delicious burger', length = 2500})
		end
	end)
end)
```

* The event triggered when using a burger receives all basic item information from `shared/items.lua`
* It will also receive the information from that specific instance of the item (count, metadata, etc)
* Using `cb(true)` will trigger the progress bar, item effects, and remove the item
* Using `cb(false)` will not use the item and return an error message
* Item use effects should always be contained within `SetTimeout` when it is not instant


#### [#](usage/drops) Custom drops
* The following example allows the creation of a drop from skinning an animal
* The drop is created on the animals x,y coordinates and the players z (dead animals result in underground drops)
* Confirm the entity exists, is not the player, and is near the player (prevent exploits)
```lua
	local playerPed = GetPlayerPed(xPlayer.source)
	local playerCoords = GetEntityCoords(playerPed)
	local entity = NetworkGetEntityFromNetworkId(animalid)
	if entity and entity ~= playerPed then
		local coords = GetEntityCoords(entity)
		if #(playerCoords - coords) <= 10 then
			local data = {
				type = 'create',
				label = 'Carcass',
				coords = vector3(coords.x, coords.y, playerCoords.z),
				inventory = {
					[1] = {slot=1, name='meat', count=meatAmount, metadata={grade=grade, animal=Config.Animals[hash].ModNam, type=Config.Animals[hash].label..' meat', description='A cut of '..grade..' grade meat from a '..Config.Animals[hash].label}}
				}
			}
			exports['linden_inventory']:CreateNewDrop(xPlayer, data)
			TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, {type = 'inform', text = 'You have slaughtered an animal yielding a total of ' ..meatAmount.. 'pieces of meat.'})
		end
	end
 ```
