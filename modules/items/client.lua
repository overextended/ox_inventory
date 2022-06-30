local Items = shared.items

local function displayMetadata(metadata, value)
	local data = metadata
	if type(metadata) == 'string' and value then data = { [metadata] = value } end
	SendNUIMessage({
		action = 'displayMetadata',
		data = data
	})
end
exports('displayMetadata', displayMetadata)

local function GetItem(item)
	if item then
		item = string.lower(item)
		if item:sub(0, 7) == 'weapon_' then item = string.upper(item) end
		return Items[item]
	end
	return Items
end

local function Item(name, cb)
	local item = Items[name]
	if item then
		if not item.client?.export and not item.client?.event then
			item.effect = cb
		end
	end
end

local ox_inventory = exports[shared.resource]
-----------------------------------------------------------------------------------------------
-- Clientside item use functions
-----------------------------------------------------------------------------------------------
Item('burger', function(data, slot)
    print('json.encode: Using item')
    ox_inventory:useItem(data, function(data)
        if data then
            print('metadata.logged: Finished using item')
						TriggerEvent('chat:addMessage', { template = '<div style="color: darkseagreen; "><b>* [Status]: You ate a Burger, and start to feel hungry... *</b></div>' })
						--exports['ybn_misc']:Alert("HUD", "You are feeling hungry...", 5000, 'hungry')
        end
    end)
end)

Item('water', function(data, slot)
    print('json.encode: Using item')
    ox_inventory:useItem(data, function(data)
        if data then
            print('metadata.logged: Finished using item')
						TriggerEvent('chat:addMessage', { template = '<div style="color: lightblue; "><b>* [Status]: You quenched your thirst with a Water. *</b></div>' })
						--exports['ybn_misc']:Alert("HUD", "You are feeling thirsty...", 5000, 'thirsty')
        end
    end)
end)

Item('cola', function(data, slot)
    print('json.encode: Using item')
    ox_inventory:useItem(data, function(data)
        if data then
            print('metadata.logged: Finished using item')
						TriggerEvent('chat:addMessage', { template = '<div style="color: lightblue; "><b>* [Status]: You drank a Cola, and start to feel thirsty... *</b></div>' })
						--exports['ybn_misc']:Alert("HUD", "You are feeling thirsty...", 5000, 'thirsty')
        end
    end)
end)

Item('snickers', function(data, slot)
    print('json.encode: Using item')
    ox_inventory:useItem(data, function(data)
        if data then
            print('metadata.logged: Finished using item')
						TriggerEvent('chat:addMessage', { template = '<div style="color: darkseagreen; "><b>* [Status]: You ate a Snickers chocolate bar, and start to feel hungry... *</b></div>' })
            --ox_inventory:Notify({text = 'You ate a delicious '..data.name})
						--exports['ybn_misc']:Alert("HUD", "You are feeling hungry...", 5000, 'hungry')
        end
    end)
end)

Item('donut', function(data, slot)
    print('json.encode: Using item')
    ox_inventory:useItem(data, function(data)
        if data then
            print('metadata.logged: Finished using item')
						TriggerEvent('chat:addMessage', { template = '<div style="color: darkseagreen; "><b>* [Status]: You ate a Donut, and start to feel hungry... *</b></div>' })
						--exports['ybn_misc']:Alert("HUD", "You are feeling hungry...", 5000, 'hungry')
        end
    end)
end)

Item('beer', function(data, slot)
    print('json.encode: Using item')
    ox_inventory:useItem(data, function(data)
        if data then
            print('metadata.logged: Finished using item')
						TriggerEvent('chat:addMessage', { template = '<div style="color: lightblue; "><b>* [Status]: You just drank a refreshing Beer... *</b></div>' })
						--exports['ybn_misc']:Alert("HUD", "You are feeling thirsty...", 5000, 'thirsty')
        end
    end)
end)

Item('taco', function(data, slot)
    print('json.encode: Using item')
    ox_inventory:useItem(data, function(data)
        if data then
            print('metadata.logged: Finished using item')
						TriggerEvent('chat:addMessage', { template = '<div style="color: darkseagreen; "><b>* [Status]: You ate a Taco, and start to feel hungry... *</b></div>' })
						--exports['ybn_misc']:Alert("HUD", "You are feeling hungry...", 5000, 'hungry')
        end
    end)
end)

Item('bsfries', function(data, slot)
    print('json.encode: Using item')
    ox_inventory:useItem(data, function(data)
        if data then
            print('metadata.logged: Finished using item')
						TriggerEvent('chat:addMessage', { template = '<div style="color: darkseagreen; "><b>* [Status]: You ate some Burgershot fries, and start to feel hungry... *</b></div>' })
						--exports['ybn_misc']:Alert("HUD", "You are feeling hungry...", 5000, 'hungry')
        end
    end)
end)

Item('candy', function(data, slot)
    print('json.encode: Using item')
    ox_inventory:useItem(data, function(data)
        if data then
            print('metadata.logged: Finished using item')
						TriggerEvent('chat:addMessage', { template = '<div style="color: darkseagreen; "><b>* [Status]: You ate some delicious Candy, and start to feel hungry... *</b></div>' })
						--exports['ybn_misc']:Alert("HUD", "You are feeling hungry...", 5000, 'hungry')
        end
    end)
end)

Item('hotdog', function(data, slot)
    print('json.encode: Using item')
    ox_inventory:useItem(data, function(data)
        if data then
            print('metadata.logged: Finished using item')
						TriggerEvent('chat:addMessage', { template = '<div style="color: darkseagreen; "><b>* [Status]: You just ate a Hotdog... *</b></div>' })
						--exports['ybn_misc']:Alert("HUD", "You are feeling hungry...", 5000, 'hungry')
        end
    end)
end)

Item('ramen', function(data, slot)
    print('json.encode: Using item')
    ox_inventory:useItem(data, function(data)
        if data then
            print('metadata.logged: Finished using item')
						TriggerEvent('chat:addMessage', { template = '<div style="color: darkseagreen; "><b>* [Status]: You ate some delicious Cup noodles, and start to feel hungry... *</b></div>' })
						--exports['ybn_misc']:Alert("HUD", "You are feeling hungry...", 5000, 'hungry')
        end
    end)
end)

Item('cheesechips', function(data, slot)
    print('json.encode: Using item')
    ox_inventory:useItem(data, function(data)
        if data then
            print('metadata.logged: Finished using item')
						TriggerEvent('chat:addMessage', { template = '<div style="color: darkseagreen; "><b>* [Status]: You ate a bag of Cheese chips, and start to feel hungry... *</b></div>' })
						--exports['ybn_misc']:Alert("HUD", "You are feeling hungry...", 5000, 'hungry')
        end
    end)
end)

Item('ribchips', function(data, slot)
    print('json.encode: Using item')
    ox_inventory:useItem(data, function(data)
        if data then
            print('metadata.logged: Finished using item')
						TriggerEvent('chat:addMessage', { template = '<div style="color: darkseagreen; "><b>* [Status]: You ate a bag of Rib chips, and start to feel hungry... *</b></div>' })
						--exports['ybn_misc']:Alert("HUD", "You are feeling hungry...", 5000, 'hungry')
        end
    end)
end)

Item('saltchips', function(data, slot)
    print('json.encode: Using item')
    ox_inventory:useItem(data, function(data)
        if data then
            print('metadata.logged: Finished using item')
						TriggerEvent('chat:addMessage', { template = '<div style="color: darkseagreen; "><b>* [Status]: You ate a bag of Salt chips, and start to feel hungry... *</b></div>' })
						--exports['ybn_misc']:Alert("HUD", "You are feeling hungry...", 5000, 'hungry')
        end
    end)
end)

Item('habanerochips', function(data, slot)
    print('json.encode: Using item')
    ox_inventory:useItem(data, function(data)
        if data then
            print('metadata.logged: Finished using item')
						TriggerEvent('chat:addMessage', { template = '<div style="color: darkseagreen; "><b>* [Status]: You ate a bag of Habanero chips, and start to feel hungry... *</b></div>' })
						--exports['ybn_misc']:Alert("HUD", "You are feeling hungry...", 5000, 'hungry')
        end
    end)
end)

Item('fanta', function(data, slot)
    print('json.encode: Using item')
    ox_inventory:useItem(data, function(data)
        if data then
            print('metadata.logged: Finished using item')
						TriggerEvent('chat:addMessage', { template = '<div style="color: lightblue; "><b>* [Status]: You drank a Fanta, and start to feel thirsty... *</b></div>' })
						--exports['ybn_misc']:Alert("HUD", "You are feeling thirsty...", 5000, 'thirsty')
        end
    end)
end)
-- End of food items

Item('bandage', function(data, slot)
	local maxHealth = GetEntityMaxHealth(cache.ped)
	local health = GetEntityHealth(cache.ped)
	ox_inventory:useItem(data, function(data)
		if data then
			SetEntityHealth(cache.ped, math.min(maxHealth, math.floor(health + maxHealth / 16)))
			TriggerEvent('chat:addMessage', { template = '<div style="color: lightcoral; "><b>* [Status]: You feel better already. *</b></div>' })
			--lib.notify({ description = 'You feel better already' })
		end
	end)
end)

Item('armour', function(data, slot)
	if GetPedArmour(cache.ped) < 100 then
		ox_inventory:useItem(data, function(data)
			if data then
				SetPlayerMaxArmour(PlayerData.id, 100)
				SetPedArmour(cache.ped, 100)
			end
		end)
	end
end)

client.parachute = false
Item('parachute', function(data, slot)
	if not client.parachute then
		ox_inventory:useItem(data, function(data)
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

Item('phone', function(data, slot)
	local isOpen = exports.high_phone:isOpen()
end)
-----------------------------------------------------------------------------------------------

exports('Items', GetItem)
exports('ItemList', GetItem)
client.items = Items
