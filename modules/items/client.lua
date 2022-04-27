local Items = shared.items

local function zobrazitMetada(metadata, value)
	local data = metadata
	if type(metadata) == 'string' and value then data = { [metadata] = value } end
	SendNUIMessage({
		action = 'zobrazitMetada',
		data = data
	})
end
exports('zobrazitMetada', zobrazitMetada)

local function ZiskatPolozku(item)
	if item then
		item = string.lower(item)
		if item:sub(0, 7) == 'weapon_' then item = string.upper(item) end
		return Items[item]
	end
	return Items
end

local function Polozka(name, cb)
	local item = Items[name]
	if item then
		if not Polozka.client?.export and not Polozka.client?.event then
			Polozka.effect = cb
		end
	end
end

local ox_inventory = exports[shared.resource]
-----------------------------------------------------------------------------------------------
-- Clientside item use functions
-----------------------------------------------------------------------------------------------

Polozka('bandage', function(data, slot)
	local maxHealth = GetEntityMaxHealth(cache.ped)
	local health = GetEntityHealth(cache.ped)
	ox_inventory:pouzitPolozku(data, function(data)
		if data then
			SetEntityHealth(cache.ped, math.min(maxHealth, math.floor(health + maxHealth / 16)))
			lib.notify({ description = 'You feel better already' })
		end
	end)
end)

Polozka('armour', function(data, slot)
	if GetPedArmour(cache.ped) < 100 then
		ox_inventory:pouzitPolozku(data, function(data)
			if data then
				SetPlayerMaxArmour(PlayerData.id, 100)
				SetPedArmour(cache.ped, 100)
			end
		end)
	end
end)

client.parachute = false
Polozka('parachute', function(data, slot)
	if not client.parachute then
		ox_inventory:pouzitPolozku(data, function(data)
			if data then
				local chute = `GADGET_PARACHUTE`
				SetPlayerParachuteTintIndex(PlayerData.id, -1)
				GiveWeaponToPed(cache.ped, chute, 0, true, false)
				SetPedGadget(cache.ped, chute, true)
				lib.requestModel(1269906701)
				client.parachute = CreateParachuteBagObject(cache.ped, true, true)
				if slot.metadata.type then
					SetPlayerParachuteTintIndex(PlayerData.id, slot.metadata.type)
				end
			end
		end)
	end
end)

Polozka('phone', function(data, slot)
	exports.npwd:setPhoneVisible(not exports.npwd:isPhoneVisible())
end)

-----------------------------------------------------------------------------------------------

exports('Items', ZiskatPolozku)
exports('ItemList', ZiskatPolozku)
client.items = Items
