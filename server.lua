local Utils, Shops, Inventory, Items = module('utils', true), module('shops'), module('inventory'), module('items')

SetInterval(1, 600000, function()
	local time = os.time(os.date('!*t'))
	for id, inv in pairs(Inventory('all')) do
		if inv.type ~= 'player' and not inv.open then
			if inv.type ~= 'drop' and inv.datastore == nil and inv.changed then
				Inventory.Save(inv)
			end
			if time - inv.time >= 3000 then
				Inventory.Remove(id, inv.type)
			end
		end
	end
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if eventData.secondsRemaining == 60 then
		CreateThread(function()
			Wait(50000)
			for id, inv in pairs(Inventory('all')) do
				if inv.type ~= 'player' and not inv.open then
					if inv.type ~= 'drop' and inv.datastore == nil and inv.changed then
						Inventory.Save(inv)
					end
				end
			end
		end)
	end
end)

RegisterNetEvent('ox_inventory:requestPlayerInventory', function()
	local xPlayer, inventory = ESX.GetPlayerFromId(source)
	while not ox.ready do Wait(15) end
	local result = exports.oxmysql:scalar('SELECT inventory FROM users WHERE identifier = ?',
	{ xPlayer.identifier }, function(result)
		if result then inventory = json.decode(result) end
		TriggerEvent('ox_inventory:setPlayerInventory', xPlayer, inventory)
	end)
end)

RegisterNetEvent('ox_inventory:closeInventory', function()
	local inventory, secondary = Inventory(source)
	if inventory.open then secondary = Inventory(inventory.open) end
	if secondary then secondary:set('open', false) end
	inventory:set('open', false)
end)

AddEventHandler('ox_inventory:setPlayerInventory', function(xPlayer, data)
	local money, inventory, totalWeight = {money=0, black_money=0}, {}, 0
	if data and next(data) then
		for i=1, #data do
			local i = data[i]
			if type(i) == 'number' then break end
			local item = Items(i.name)
			if item then
				local weight = Inventory.SlotWeight(item, i)
				totalWeight = totalWeight + weight
				inventory[i.slot] = {name = i.name, label = item.label, weight = weight, slot = i.slot, count = i.count, description = item.description, metadata = i.metadata, stack = item.stack, close = item.close}
				if money[i.name] then money[i.name] = money[i.name] + i.count end
			end
		end
	end
	Inventory.Create(xPlayer.source, xPlayer.name, 'player', Config.PlayerSlots, totalWeight, Config.DefaultWeight, xPlayer.identifier, inventory)
	xPlayer.syncInventory(totalWeight, Config.DefaultWeight, inventory, money)
	TriggerClientEvent('ox_inventory:setPlayerInventory', xPlayer.source, {Drops, inventory, totalWeight, ESX.UsableItemsCallbacks})
end)

AddEventHandler('ox_inventory:createDrop', function(source, slot, toSlot, cb)
	local drop
	repeat
		drop = math.random(100000, 999999)
		Wait(5)
	until not Inventory(drop)
	Inventory.Create(drop, 'Drop '..drop, 'drop', Config.PlayerSlots, 0, Config.DefaultWeight, false, {[slot] = Utils.Copy(toSlot)})
	local coords = GetEntityCoords(GetPlayerPed(source))
	Inventory(drop):set('coords', coords)
	cb(drop, coords)
end)

local Stashes, Vehicle = data('stashes'), data('vehicles')
ox.RegisterServerCallback('ox_inventory:openInventory', function(source, cb, inv, data) 
	local left, right = Inventory(source)
	if data then
		if inv == 'stash' then
			local stash = Stashes[data.id]
			if stash.owner == nil then
				right = Inventory(stash.name)
				if not right then
					right = Inventory.Create(stash.name, stash.name, inv, stash.slots, 0, stash.weight, false)
				end
			else
				local owner = stash.owner == true and left.owner or stash.owner
				right = Inventory(stash.name..owner)
				if not right then
					right = Inventory.Create(stash.name..owner, stash.name, inv, stash.slots, 0, stash.weight, owner)
				end
			end
		elseif inv == 'container' then
			local data = left.items[data]
			right = Inventory(data.metadata.container)
			if not right then
				right = Inventory.Create(data.metadata.container, data.label, inv, data.metadata.size[1], 0, data.metadata.size[2], false)
			end
		else
			right = Inventory(data.id)
			if not right then
				if data.class then
					local vehicle = Vehicle[inv][data.class]
					right = Inventory.Create(data.id, data.id:sub(6), inv, vehicle[1], 0, vehicle[2], false)
				end
			end
		end
		if not right.open then
			right:set('open', source)
			left:set('open', right.id)
		end
	end
	cb({id=left.label, type=left.type, slots=left.slots, weight=left.weight, maxWeight=left.maxWeight}, right)
end)

ox.RegisterServerCallback('ox_inventory:swapItems', function(source, cb, data)
	if data.count > 0 and data.toType ~= 'shop' and data.fromSlot ~= data.toSlot then
		local playerInventory, items, ret = Inventory(source), {}
		if data.toType == 'newdrop' then
			local fromSlot = playerInventory.items[data.fromSlot]
			local toSlot = Utils.Copy(fromSlot)
			toSlot.slot = data.toSlot
			local items = {[data.fromSlot] = false}
			playerInventory.items[data.fromSlot] = nil
			Inventory.SyncInventory(playerInventory:player(), playerInventory, items)
			playerInventory.weight = playerInventory.weight - toSlot.weight
			TriggerEvent('ox_inventory:createDrop', source, data.toSlot, toSlot, function(drop, coords)
				TriggerClientEvent('ox_inventory:createDrop', -1, {drop, coords}, source)
			end)
			return cb(true, {weight=playerInventory.weight, items=items})
		else
			local toInventory = data.toType == 'player' and playerInventory or Inventory(playerInventory.open)
			local fromInventory = data.fromType == 'player' and playerInventory or Inventory(playerInventory.open)
			if toInventory and fromInventory then
				local fromSlot, toSlot = fromInventory.items[data.fromSlot], toInventory.items[data.toSlot]
				if fromSlot then
					if data.count > fromSlot.count then data.count = fromSlot.count end
					if toSlot and ((toSlot.name ~= fromSlot.name) or (not Utils.MatchTables(toSlot.metadata, fromSlot.metadata))) then
						toSlot, fromSlot = Inventory.SwapSlots({fromInventory, toInventory}, {data.fromSlot, data.toSlot})
						if fromInventory.id ~= toInventory.id then
							fromInventory.weight = fromInventory.weight - toSlot.weight
							toInventory.weight = toInventory.weight + toSlot.weight
						end
					elseif toSlot and toSlot.name == fromSlot.name and Utils.MatchTables(toSlot.metadata, fromSlot.metadata) then
						fromSlot.count = fromSlot.count - data.count
						toSlot.count = toSlot.count + data.count
						fromSlot.weight = Inventory.SlotWeight(Items(fromSlot.name), fromSlot)
						toSlot.weight = Inventory.SlotWeight(Items(toSlot.name), toSlot)
						if fromInventory.id ~= toInventory.id then
							fromInventory.weight = fromInventory.weight - toSlot.weight
							toInventory.weight = toInventory.weight + toSlot.weight
						end
					elseif data.count <= fromSlot.count then
						fromSlot.count = fromSlot.count - data.count
						toSlot = Utils.Copy(fromSlot)
						toSlot.count = data.count
						toSlot.slot = data.toSlot
						fromSlot.weight = Inventory.SlotWeight(Items(fromSlot.name), fromSlot)
						toSlot.weight = Inventory.SlotWeight(Items(toSlot.name), toSlot)
						if fromInventory.id ~= toInventory.id then
							fromInventory.weight = fromInventory.weight - toSlot.weight
							toInventory.weight = toInventory.weight + toSlot.weight
						end
					else
						print('swapItems', data.fromType, data.fromSlot, 'to', data.toType, data.toSlot)
						return cb(false)
					end
					if fromSlot.count < 1 then fromSlot = nil end
					if data.fromType == 'player' then items[data.fromSlot] = fromSlot or false end
					if data.toType == 'player' then items[data.toSlot] = toSlot or false end
					fromInventory.items[data.fromSlot], toInventory.items[data.toSlot] = fromSlot, toSlot
					if next(items) then
						ret = {weight=playerInventory.weight, items=items}
						Inventory.SyncInventory(playerInventory:player(), playerInventory, items)
					end
					if fromInventory.changed ~= nil then fromInventory:set('changed', true) end
					if toInventory.changed ~= nil then toInventory:set('changed', true) end
					return cb(true, ret)
				end
			end
		end
	end
	cb(false)
end)

ox.RegisterServerCallback('ox_inventory:buyItem', function(source, cb, data)
	if data.toType == 'player' and data.fromSlot ~= data.toSlot then
		if data.count == nil then data.count = 1 end
		local player, items, ret = Inventory(source), {}
		local xPlayer = player:player()
		local shop = Shops[tonumber(player.open:sub(5))]
		local fromSlot, toSlot = shop.items[data.fromSlot], player.items[data.toSlot]
		if fromSlot then
			if fromSlot.count == 0 then return cb(false, nil, {type = 'error', text = ox.locale('shop_nostock')}) end
			if fromSlot.count and data.count > fromSlot.count then data.count = fromSlot.count end
			local metadata, count = Items.Metadata(xPlayer, Items(fromSlot.name), fromSlot.metadata or {}, data.count)
			local price = count * fromSlot.price
			if Inventory.GetItem(source, 'money').count >= price and toSlot and Utils.MatchTables(toSlot.metadata, metadata) or toSlot == nil then
				if toSlot and toSlot.name == fromSlot.name then
					if fromSlot.count then fromSlot.count = fromSlot.count - count end
					toSlot.count = toSlot.count + count
					toSlot.weight = Inventory.SlotWeight(Items(toSlot.name), toSlot)
					player.weight = player.weight + toSlot.weight
				elseif fromSlot.count == nil or count <= fromSlot.count then
					if fromSlot.count then fromSlot.count = fromSlot.count - count end
					toSlot = Utils.Copy(fromSlot)
					toSlot.count = count
					toSlot.slot = data.toSlot
					toSlot.weight = Inventory.SlotWeight(Items(toSlot.name), toSlot)
					player.weight = player.weight + toSlot.weight
				else
					print('buyItem', data.fromType, data.fromSlot, 'to', data.toType, data.toSlot)
					return cb(false)
				end
				toSlot.metadata = metadata
				items[data.toSlot] = toSlot
				shop.items[data.fromSlot], player.items[data.toSlot] = fromSlot, toSlot
				ret = {weight=player.weight, items=items}
				Inventory.RemoveItem(source, 'money', price)
				Inventory.SyncInventory(xPlayer, player, items)
				return cb(true, ret, {type = 'success', text = 'Purchased '..count..'x '..toSlot.name..' for $'..price})
			end
		end
	end
	cb(false)
end)

ox.RegisterServerCallback('ox_inventory:openShop', function(source, cb, inv, data) 
	local left, shop = Inventory(source)
	if data then
		shop = Shops[data.id]
		shop.type = inv
		left:set('open', shop.id)
	end
	cb({id=left.label, type=left.type, slots=left.slots, weight=left.weight, maxWeight=left.maxWeight}, shop)
end)

RegisterNetEvent('ox_inventory:currentWeapon', function(slot)
	local inv = Inventory(source)
	if slot then
		inv.weapon = inv.items[slot]
	else inv.weapon = nil end
end)

RegisterNetEvent('ox_inventory:updateWeapon', function(action)
	print(action)
end)

ox.RegisterServerCallback('ox_inventory:useItem', function(source, cb, item, slot, metadata)
	local item, type = Items(item)
	local data = item and (slot and Inventory(source).items[slot] or Inventory.GetItem(source, item, metadata))
	if item and data and data.count > 0 and data.name == item.name then
		if type == 1 then -- weapon
			cb(data)
		elseif type == 2 then -- ammo
			cb(data)
		elseif ESX.UsableItemsCallbacks[item.name] then
			ESX.UseItem(source, item.name)
			cb(false)
		else
			if item.consume and data.count >= item.consume then
				cb(data)
			else
				TriggerClientEvent('ox_inventory:Notify', source, {type = 'error', text = ox.locale('item_not_enough'), duration = 2500})
				cb(false)
			end
		end
	else cb(false) end
end)