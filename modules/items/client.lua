local M = module('items', true)

local GetItem = function(item)
	if item then
		item = string.lower(item)
		if item:find('weapon_') then item = string.upper(item) end
		return Items[item]
	end
	return
end

local Item = function(name, cb)
	if M[1][name] then M[1][name].effect = cb end
end

Item('burger', function(data, slot)
	TriggerEvent('ox_inventory:item', data, function(data)
		if data then
			TriggerEvent('ox_inventory:Notify', {text = 'You ate a delicious '..data.name})
		end
	end)
end)

Item('water', function(data, slot)
	TriggerEvent('ox_inventory:item', data, function(data)
		if data then
			TriggerEvent('ox_inventory:Notify', {text = 'You drank some refreshing '..data.name})
		end
	end)
end)

Item('cola', function(data, slot)
	TriggerEvent('ox_inventory:item', data, function(data)
		if data then
			TriggerEvent('ox_inventory:Notify', {text = 'You drank some delicious '..data.name})
		end
	end)
end)

Item('mustard', function(data, slot)
	TriggerEvent('ox_inventory:item', data, function(data)
		if data then
			TriggerEvent('ox_inventory:Notify', {text = 'You.. drank '..data.name})
		end
	end)
end)

Item('bandage', function(data, slot)
	local maxHealth = 200
	local health = GetEntityHealth(ESX.PlayerData.ped)
	if health < maxHealth then
		TriggerEvent('ox_inventory:item', data, function(data)
			if data then
				SetEntityHealth(ESX.PlayerData.ped, math.min(maxHealth, math.floor(health + maxHealth / 16)))
				TriggerEvent('ox_inventory:Notify', {text = 'You feel better already'})
			end
		end)
	end
end)

Item('armour', function(data, slot)
	if GetPedArmour(ESX.PlayerData.ped) < 100 then
		TriggerEvent('ox_inventory:item', data, function(data)
			if data then
				SetPlayerMaxArmour(PlayerId(), 100)
				SetPedArmour(ESX.PlayerData.ped, 100)
			end
		end)
	end
end)

ox.parachute = false
Item('parachute', function(data, slot)
	if not ox.parachute then
		TriggerEvent('ox_inventory:item', data, function(data)
			if data then
				local chute = `GADGET_PARACHUTE`
				SetPlayerParachuteTintIndex(PlayerId(), -1)
				GiveWeaponToPed(ESX.PlayerData.ped, chute, 0, true, false)
				SetPedGadget(ESX.PlayerData.ped, chute, true)
				ESX.Streaming.RequestModel(1269906701)
				ox.parachute = CreateParachuteBagObject(ESX.PlayerData.ped, true, true)
				if slot.metadata.type then
					SetPlayerParachuteTintIndex(PlayerId(), slot.metadata.type)
				end
			end
		end)
	end
end)

exports('Items', GetItem)
return M