| [Installation](index) | [Usage](usage) | [Snippets](snippets) |

### Weight fix for esx_skin
* Either returns errors or sets the player weight incorrectly, due to getting ESX's weight
```lua
RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)
	local defaultMaxWeight = 30000      -- put the default weight for players here, 30000 by default in linden_inventory
	local backpackModifier = Config.BackpackWeight[skin.bags_1]

	if backpackModifier then
		xPlayer.setMaxWeight(defaultMaxWeight + backpackModifier)
	else
		xPlayer.setMaxWeight(defaultMaxWeight)
	end

	MySQL.Async.execute('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
		['@skin'] = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)
````

### Police body search, without having to /steal
* It's just /steal in a menu basically, has all the same requirements (dead, handsup, cuffed, etc)
`exports['linden_inventory']:OpenTargetInventory()`

### Create a stash with esx_property
* Find and remove the following two blocks of code
```lua
	table.insert(elements, {label = _U('remove_object'),  value = 'room_inventory'})
	table.insert(elements, {label = _U('deposit_object'), value = 'player_inventory'})
```
```lua
	elseif data.current.value == 'room_inventory' then
		OpenRoomInventoryMenu(property, owner)
	elseif data.current.value == 'player_inventory' then
		OpenPlayerInventoryMenu(property, owner)
	end
```
* Search for `if CurrentAction then` and below insert
```lua
	if IsDisabledControlJustPressed(0, 289) and CurrentAction == 'room_menu' then
			exports['linden_inventory']:OpenStash({ name = ('%s-%s'):format(CurrentActionData.property.name, CurrentActionData.owner), slots = 71})
		end
```
