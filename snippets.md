---
title: Snippets
---

| [Installation](index) | [Usage](usage) | [Snippets](snippets) | [Other Resources](resources) | [Media](media)

## Weight fix for esx_skin
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

## Police body search, without having to /steal
* It's just /steal in a menu basically, has all the same requirements (dead, handsup, cuffed, etc)
* Find `OpenBodySearchMenu(closestPlayer)` and replace it with `exports['linden_inventory']:OpenTargetInventory()`
* Find and remove the `OpenBodySearchMenu` function

## Create a stash with esx_property
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

## Set player death status
* There are better ways to do this, but for the simplest method search go to `esx_ambulancejob/server/main.lua`
* Locate `RegisterNetEvent('esx_ambulancejob:setDeathStatus')` and add the following
```lua
	TriggerEvent('esx_ambulancejob:setDeathStatus', xPlayer.source, isDead)
```

## Display inventory items in a menu (ie. [esx_drugs](https://github.com/DoPeMan17/esx_drugs/blob/master/client/main.lua))
* Inventory displays in menus (like esx-menu) typically use `for k, v in pairs(ESX.GetPlayerData().inventory) do`
* Put the functions into a server callback and loop the retrieved inventory instead
```lua
function OpenDrugShop()
	ESX.UI.Menu.CloseAll()
	local elements = {}

	ESX.TriggerServerCallback('hsn-inventory:getPlayerInventory',function(playerInventory)

		for k, v in pairs(playerInventory.inventory) do
			local price = Config.DrugDealerItems[v.name]
	
			if price and v.count > 0 then
				table.insert(elements, {
					label = ('%s - %s'):format(v.label, _U('dealer_item', ESX.Math.GroupDigits(price))),
					name = v.name,
					price = price,
	
					-- menu properties
					type = 'slider',
					value = v.count,
					min = 1,
					max = v.count
				})
			end
		end
		menuOpen = true
	end, GetPlayerServerId(PlayerId()))
	while not menuOpen do Citizen.Wait(50) end
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'drug_shop', {
		title    = _U('dealer_title'),
		align    = 'top-left',
		elements = elements
	}, function(data, menu)
		TriggerServerEvent('esx_illegal:sellDrug', data.current.name, data.current.value)
	end, function(data, menu)
		menu.close()
		menuOpen = false
	end)
end
```
