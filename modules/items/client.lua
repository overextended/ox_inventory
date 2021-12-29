local Items = items()

local function GetItem(item)
	if item then
		item = string.lower(item)
		if item:find('weapon_') then item = string.upper(item) end
		return Items[item]
	end
	return Items
end

local function Item(name, cb)
	local item = Items[name]
	if item and not item.client?.event then item.effect = cb end
end

local ox_inventory = exports[ox.resource]
-----------------------------------------------------------------------------------------------
-- Clientside item use functions
-----------------------------------------------------------------------------------------------

Item('burger', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			ox_inventory:notify({text = 'You ate a delicious '..data.name})
		end
	end)
end)

Item('testburger', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			if data.server then print(json.encode(data.server, {indent=true})) end
			ox_inventory:notify({text = 'You ate a delicious '..data.name})
		end
	end)
end)

Item('water', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			ox_inventory:notify({text = 'You drank some refreshing '..data.name})
		end
	end)
end)

Item('cola', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			ox_inventory:notify({text = 'You drank some delicious '..data.name})
		end
	end)
end)

Item('mustard', function(data, slot)
	ox_inventory:useItem(data, function(data)
		if data then
			ox_inventory:notify({text = 'You.. drank '..data.name})
		end
	end)
end)

Item('bandage', function(data, slot)
	local maxHealth = 200
	local health = GetEntityHealth(PlayerData.ped)
	-- if health < maxHealth then
		ox_inventory:useItem(data, function(data)
			if data then
				SetEntityHealth(PlayerData.ped, math.min(maxHealth, math.floor(health + maxHealth / 16)))
				ox_inventory:notify({text = 'You feel better already'})
			end
		end)
	-- end
end)

Item('armour', function(data, slot)
	if GetPedArmour(PlayerData.ped) < 100 then
		ox_inventory:useItem(data, function(data)
			if data then
				SetPlayerMaxArmour(PlayerData.id, 100)
				SetPedArmour(PlayerData.ped, 100)
			end
		end)
	end
end)

ox.parachute = false
Item('parachute', function(data, slot)
	if not ox.parachute then
		ox_inventory:useItem(data, function(data)
			if data then
				local chute = `GADGET_PARACHUTE`
				SetPlayerParachuteTintIndex(PlayerData.id, -1)
				GiveWeaponToPed(PlayerData.ped, chute, 0, true, false)
				SetPedGadget(PlayerData.ped, chute, true)
				lib.requestModel(1269906701)
				ox.parachute = CreateParachuteBagObject(PlayerData.ped, true, true)
				if slot.metadata.type then
					SetPlayerParachuteTintIndex(PlayerData.id, slot.metadata.type)
				end
			end
		end)
	end
end)

-----------------------------------------------------------------------------------------------

exports('Items', GetItem)
exports('ItemList', GetItem)
client.items = Items
