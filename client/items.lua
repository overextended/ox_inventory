AddEventHandler('linden_inventory:burger', function()
	TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'You ate a delicious burger', length = 2500})
end)

AddEventHandler('linden_inventory:water', function()
	TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'You drank some refreshing water', length = 2500})
end)

AddEventHandler('linden_inventory:cola', function()
	TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'You drank some delicious eCola', length = 2500})
end)

AddEventHandler('linden_inventory:mustard', function()
	TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'You.. drank mustard', length = 2500})
end)

AddEventHandler('linden_inventory:bandage', function()
	local maxHealth = 200
	local health = GetEntityHealth(playerPed)
	local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 16))
	SetEntityHealth(playerPed, newHealth)
end)

AddEventHandler('linden_inventory:armour', function()
	SetPlayerMaxArmour(playerID, 100)
	SetPedArmour(playerPed, 100)
end)
