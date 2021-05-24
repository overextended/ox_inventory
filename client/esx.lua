RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerLoaded = true
	StartInventory()
end)

RegisterNetEvent('esx:onPlayerLogout')	-- Trigger this event when a player logs out to character selection
AddEventHandler('esx:onPlayerLogout', function()
	DisarmPlayer() TriggerEvent('linden_inventory:closeInventory')
	PlayerLoaded = false
end)

OnPlayerData = function(key, val)
	if key == 'dead' and val == true then
		DisarmPlayer() TriggerEvent('linden_inventory:closeInventory')
	end
end

RegisterNetEvent('esx_policejob:handcuff')
AddEventHandler('esx_policejob:handcuff', function()
	isCuffed = not isCuffed
	if isCuffed then DisarmPlayer() TriggerEvent('linden_inventory:closeInventory') end
end)

RegisterNetEvent('esx_policejob:unrestrain')
AddEventHandler('esx_policejob:unrestrain', function()
	isCuffed = false
	TriggerEvent('linden_inventory:closeInventory')
end)
