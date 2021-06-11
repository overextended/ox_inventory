AddEventHandler('linden_inventory:burger', function(item, wait, cb)
	cb(true)
	SetTimeout(wait, function()
		if not cancelled then
			TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'You ate a delicious burger', length = 2500})
		end
	end)
end)

AddEventHandler('linden_inventory:water', function(item, wait, cb)
	cb(true)
	SetTimeout(wait, function()
		if not cancelled then
			TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'You drank some refreshing water', length = 2500})
		end
	end)
end)

AddEventHandler('linden_inventory:cola', function(item, wait, cb)
	cb(true)
	SetTimeout(wait, function()
		if not cancelled then
			TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'You drank some delicious eCola', length = 2500})
		end
	end)
end)

AddEventHandler('linden_inventory:mustard', function(item, wait, cb)
	cb(true)
	SetTimeout(wait, function()
		if not cancelled then
			TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'You.. drank mustard', length = 2500})
		end
	end)
end)

AddEventHandler('linden_inventory:bandage', function(item, wait, cb)
	local maxHealth = 200
	local health = GetEntityHealth(ESX.PlayerData.ped)
	if health < maxHealth then
		cb(true)
		SetTimeout(wait, function()
			if not cancelled then
				local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 16))
				SetEntityHealth(ESX.PlayerData.ped, newHealth)
				TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'You feel better already', length = 2500})
			end
		end)
	else cb(false) end
end)

AddEventHandler('linden_inventory:lockpick', function(item, wait, cb)
	-- This is just for unlocking car doors - if you want more advanced options either set it up or hope somebody PRs it
	local vehicle, vehicleCoords = ESX.Game.GetVehicleInDirection()
	if vehicle then
		local locked = GetVehicleDoorLockStatus(vehicle)
		if #(vehicleCoords - GetEntityCoords(ESX.PlayerData.ped)) <= 2.0 and locked == 2 or locked == 3 then
			cb(true)
			SetTimeout(wait, function()
				if not cancelled then
					math.randomseed(math.random(1,9999))
					local random = math.random(1,10)
					print(random)
					if random >= 7 then
						TriggerEvent('mythic_notify:client:SendAlert', {type = 'inform', text = 'Successfuly picked the lock', length = 2500})
						SetVehicleAlarm(vehicle, true)
						SetVehicleAlarmTimeLeft(vehicle, 7000)
						SetVehicleDoorsLocked(vehicle, 1)
						SetVehicleDoorsLockedForAllPlayers(vehicle, false)
					elseif random <= 2 then
						TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = 'Your lockpick broke', length = 2500})
						TriggerServerEvent('linden_inventory:removeItem', item, 1)
					else
						TriggerEvent('mythic_notify:client:SendAlert', {type = 'error', text = 'You failed to pick the lock', length = 2500})
					end
				end
			end)
		else cb(false) end
	else cb(false) end
end)

AddEventHandler('linden_inventory:armour', function(item, wait, cb)
	cb(true)
	SetTimeout(wait, function()
		if not cancelled then
			SetPlayerMaxArmour(playerID, 100)
			SetPedArmour(ESX.PlayerData.ped, 100)
		end
	end)
end)
