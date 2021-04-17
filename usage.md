---
title: Usage
---

| [Installation](index) | [Usage](usage) | [Snippets](snippets) | [Other Resources](resources) | [Media](media)

## xPlayer functions
* Compatibility is important, that's why we've modified the framework with the inventory exports
* All functions will work as they did previously, with some extra benefits such as metadata
* Assigning metadata will work with a single word or a table (commands will not work for tables)

#### Give player an item
```lua
  local metadata = {type='pee',description='it smells a little funky'}
  xPlayer.addInventoryItem(water, 1, metadata)
  /giveitem [id] [item] [count] [metadata]
```
* This would give water with the type and description in the item information

#### Remove an item
```lua
  local metadata = {type='pee',description='it smells a little funky'}
  xPlayer.removeInventoryItem(water, 1, metadata)
  /remove [id] [item] [count] [metadata]
```
* This would only remove an item with matching metadata
* Leaving the metadata blank will remove any item with that name

#### Get item data
```lua
  local metadata = {type='pee',description='it smells a little funky'}
  xPlayer.getInventoryItem(water, metadata)
```
* If you have 10 water but only one with metadata, the returning count is one

#### Retrieve item data from server
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

#### Check an items metadata
* Example server command, print the serial of the item in slot one
```lua
RegisterCommand('getmeta', function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local slot = exports['linden_inventory']:getPlayerSlot(xPlayer, 1)
	print(slot.metadata.serial)
end, true)
```
* Still working on a good solution for checking client side

#### Open a stash
* If you want anybody to be able to use a stash, do not define job
* Stashes should have unique names so they do not share
* You can define an owner for a stash, attaching their player identifier
* You can have owned stashes with the same name as long as the identifier doesn't match
```lua
	exports['linden_inventory']:OpenStash({ name = 'Hospital Locker', slots = 70, job= 'ambulance'})
	exports['linden_inventory']:OpenStash({ name = 'Bank Deposit Box', slots = 20, owner = ESX.GetPlayerData().identifier()})
	exports['linden_inventory']:OpenStash({ name = 'Personal Locker', slots = 20, job = 'police', owner = ESX.GetPlayerData().identifier()})
```
* Example for adding a stash to `esx_property` in Snippets

<br>

* I advise looking at `server/player.lua` to see all the different functions and learn how they work
* You can set literally anything in metadata, but only certain things will display in the item information
* There is specific metadata assigned for weapons and identification in `server/functions.lua`
* Look through some of the metadata from `shared/shops.lua` as well
* You could register a client event to show an item's metadata such as `metadata.registered` (which will tell you who bought a gun)


#### Creating new items
All your old items using `ESX.RegisterUsableItem` still work, however I would personally register items through the inventory
* Adding an item to `shared/items.lua` using other items as a template will register the item as usable
* Setting consume to `0` means it's unlimited usage, otherwise it sets the number to remove (usually 1)
* Set how long it takes to use an item, animations to trigger, and props to attach (through mythic_progbar)
* Set items to add or remove hunger, thirst, stress, or drunk
* Add other item events before or after the progress bar plays by modifying `linden_inventory:useItem` in `client/main.lua`
