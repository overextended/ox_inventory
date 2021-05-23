AddEventHandler('linden_inventory:burger', function(item, cb)
	TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'You ate a delicious burger', length = 2500})
	cb(true)
end)

AddEventHandler('linden_inventory:water', function(item, cb)
	TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'You drank some refreshing water', length = 2500})
	cb(true)
end)

AddEventHandler('linden_inventory:cola', function(item, cb)
	TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'You drank some delicious eCola', length = 2500})
	cb(true)
end)

AddEventHandler('linden_inventory:mustard', function(item, cb)
	TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'You.. drank mustard', length = 2500})
	cb(true)
end)

AddEventHandler('linden_inventory:bandage', function(item, cb)
	local maxHealth = 200
	local health = GetEntityHealth(ESX.PlayerData.ped)
	if health < maxHealth then
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 16))
		SetEntityHealth(ESX.PlayerData.ped, newHealth)
		TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'You feel better already', length = 2500})
		cb(true)
	else cb(false) end
end)

AddEventHandler('linden_inventory:armour', function(item, cb)
	SetPlayerMaxArmour(playerID, 100)
	SetPedArmour(ESX.PlayerData.ped, 100)
	cb(true)
end)

--[[		On hold, giving me an aneurysm to get the weight system working properly
AddEventHandler('linden_inventory:paperbag', function(item, cb)
	if item.name == 'paperbag' then
		OpenStash({ item = {slot=item.slot, name=item.name}, slots = 3, maxWeight = 1000, name = item.metadata.type, label = 'Paper bag ('..item.metadata.type..')' })
	end
end)]]
