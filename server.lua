
local Stashes <const>, Vehicle <const> = data('stashes'), data('vehicles')
local Utils <const>, Shops <const>, Inventory <const>, Items <const> = module('utils'), module('shops'), module('inventory'), module('items')

local SaveInventories = function()
	local time = os.time(os.date('!*t'))
	for id, inv in pairs(Inventory('all')) do
		if inv.type ~= 'player' and not inv.open then
			if inv.datastore == nil and inv.changed then
				Inventory.Save(inv)
			end
			if time - inv.time >= 3000 then
				Inventory.Remove(id, inv.type)
			end
		end
	end
end

SetInterval(1, 600000, SaveInventories)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if eventData.secondsRemaining == 60 then SetTimeout(50000, SaveInventories) end
end)

RegisterServerEvent('ox_inventory:requestPlayerInventory', function()
	local xPlayer, inventory = ESX.GetPlayerFromId(source)
	while not ox.ready do Wait(15) end
	exports.oxmysql:scalar('SELECT inventory FROM users WHERE identifier = ?',
	{ xPlayer.identifier }, function(result)
		if result then inventory = json.decode(result) end
		TriggerEvent('ox_inventory:setPlayerInventory', xPlayer, inventory)
	end)
end)

RegisterServerEvent('ox_inventory:closeInventory', function()
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
				if i.metadata and i.metadata.bag then
					i.metadata.container = i.metadata.bag
					i.metadata.size = {5, 1000}
					i.metadata.bag = nil
				end
				inventory[i.slot] = {name = i.name, label = item.label, weight = weight, slot = i.slot, count = i.count, description = item.description, metadata = i.metadata, stack = item.stack, close = item.close}
				if money[i.name] then money[i.name] = money[i.name] + i.count end
			end
		end
	end
	Inventory.Create(xPlayer.source, xPlayer.name, 'player', Config.PlayerSlots, totalWeight, Config.DefaultWeight, xPlayer.identifier, inventory)
	xPlayer.syncInventory(totalWeight, Config.DefaultWeight, inventory, money)
	TriggerClientEvent('ox_inventory:setPlayerInventory', xPlayer.source, {Drops, inventory, totalWeight, ESX.UsableItemsCallbacks})
end)

ox.RegisterServerCallback('ox_inventory:openInventory', function(source, cb, inv, data) 
	local left, right = Inventory(source)
	if data then
		if inv == 'stash' then
			local stash = Stashes[data.id]
			if not stash then
				stash = data
				stash.name = stash.name
				stash.slots = tonumber(stash.slots)
				stash.weight = tonumber(stash.weight)
				stash.coords = stash.coords
			end
			stash.owner = stash.owner == true and left.owner or stash.owner
			right = Inventory(stash.owner and stash.name..owner or stash.name)
			if not right then
				right = Inventory.Create(stash.owner and stash.name..stash.owner or stash.name, stash.label or stash.name, inv, stash.slots, 0, stash.weight, stash.owner or false)
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
	if data.count > 0 and data.toType ~= 'shop' then
		local playerInventory, items, ret = Inventory(source), {}
		if data.toType == 'newdrop' then
			local fromSlot = playerInventory.items[data.fromSlot]
			local toSlot = table.clone(fromSlot)
			toSlot.slot = data.toSlot
			local items = {[data.fromSlot] = false}
			playerInventory.items[data.fromSlot] = nil
			Inventory.SyncInventory(ESX.GetPlayerFromId(playerInventory.id), playerInventory, items)
			playerInventory.weight = playerInventory.weight - toSlot.weight
			TriggerEvent('ox_inventory:createDrop', source, data.toSlot, toSlot, function(drop, coords)
				if fromSlot == playerInventory.weapon then playerInventory.weapon = nil end
				TriggerClientEvent('ox_inventory:createDrop', -1, {drop, coords}, source, fromSlot)
			end)
			return cb(true, {weight=playerInventory.weight, items=items})
		else
			local toInventory = data.toType == 'player' and playerInventory or Inventory(playerInventory.open)
			local fromInventory = data.fromType == 'player' and playerInventory or Inventory(playerInventory.open)
			if toInventory and fromInventory and (fromInventory.id ~= toInventory.id or data.fromSlot ~= data.toSlot) then
				local movedWeapon = fromInventory.weapon == data.fromSlot
				local fromSlot, toSlot = fromInventory.items[data.fromSlot], toInventory.items[data.toSlot]
				if movedWeapon then
					if data.toType == 'player' then fromInventory.weapon = data.toSlot else TriggerClientEvent('ox_inventory:disarm', source) end
				end
				if fromSlot and fromSlot.metadata.container ~= toInventory.id then
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
						toSlot = table.clone(fromSlot)
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
						Inventory.SyncInventory(ESX.GetPlayerFromId(playerInventory.id), playerInventory, items)
					end
					if fromInventory.changed ~= nil then fromInventory:set('changed', true) end
					if toInventory.changed ~= nil then toInventory:set('changed', true) end
					return cb(true, ret, movedWeapon and fromInventory.weapon)
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
		local xPlayer = ESX.GetPlayerFromId(source)
		local split = player.open:match('^.*() ')
		local shop = Shops[player.open:sub(0, split-1)][tonumber(player.open:sub(split+1))]
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
					toSlot = table.clone(fromSlot)
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

ox.RegisterServerCallback('ox_inventory:buyLicense', function(source, cb, license)
	local price = Config.Licenses[license]
	if price then
		local inventory = Inventory(source)
		exports.oxmysql:scalar('SELECT 1 FROM user_licenses WHERE type = ? AND owner = ?', { license, inventory.owner }, function(result)
			if result then
				cb({false, 'has_weapon_license'})
			elseif Inventory.GetItem(inventory, 'money', false, true) < price then
				cb({false, 'poor_weapon_license'})
			else
				Inventory.RemoveItem(inventory, 'money', price)
				TriggerEvent('esx_license:addLicense', source, 'weapon', function()
					cb({'bought_weapon_license'})
				end)
			end
		end)
	else cb() end
end)

ox.RegisterServerCallback('ox_inventory:openShop', function(source, cb, inv, data) 
	local left, shop = Inventory(source)
	if data then
		shop = Shops[data.type][data.id]
		shop.type = inv
		left:set('open', shop.id)
	end
	cb({id=left.label, type=left.type, slots=left.slots, weight=left.weight, maxWeight=left.maxWeight}, shop)
end)

ox.RegisterServerCallback('ox_inventory:getItemCount', function(source, cb, item, metadata, target)
	local inventory = target and Inventory(target) or Inventory(source)
	cb((inventory and Inventory.GetItem(inventory, item, metadata, true)) or 0)
end)

ox.RegisterServerCallback('ox_inventory:getInventory', function(source, cb, id)
	local inventory = Inventory(id)
	if inventory then
		return cb({
			id = inventory.id,
			label = inventory.label,
			type = inventory.type,
			slots = inventory.slots,
			weight = inventory.weight,
			maxWeight = inventory.weight,
			owned = inventory.owner and true or false,
			items = inventory.items
		})
	end
	cb()
end)

RegisterServerEvent('ox_inventory:updateWeapon', function(action, value, slot)
	local inventory = Inventory(source)
	local weapon = inventory.items[inventory.weapon or slot]
	if weapon.metadata then
	if weapon and weapon.metadata then
		if action == 'load' then
			weapon.metadata.ammo = value
		elseif action == 'throw' then
			Inventory.RemoveItem(inventory, weapon.name, 1, weapon.metadata, weapon.slot)
		elseif weapon.metadata.ammo then
			if value < weapon.metadata.ammo then
				weapon.metadata.ammo = value
				weapon.metadata.durability = weapon.metadata.durability - Items(weapon.name).durability
			end
		elseif weapon.metadata.durability then
			weapon.metadata.durability = weapon.metadata.durability - (Items(weapon.name).durability or 1)
		end
		if action ~= 'throw' then TriggerClientEvent('ox_inventory:updateInventory', source, {{item = weapon}}, {left=inventory.weight}) end
	end
end)

ox.RegisterServerCallback('ox_inventory:useItem', function(source, cb, item, slot, metadata)
	local inventory = Inventory(source)
	local item, type = Items(item)
	local data = item and (slot and inventory.items[slot] or Inventory.GetItem(source, item, metadata))
	if item and data and data.count > 0 and data.name == item.name then
		data = {name=data.name, label=data.label, count=data.count, slot=slot or data.slot, metadata=data.metadata}
		if type == 1 then -- weapon
			inventory.weapon = data.slot
			return cb(data)
		elseif type == 2 then -- ammo
			return cb(data)
		elseif type == 3 then -- attachment
			data.consume = item.consume
			return cb(data)
		elseif ESX.UsableItemsCallbacks[item.name] then
			ESX.UseItem(source, item.name)
		else
			if item.consume and data.count >= item.consume then
				return cb(data)
			else
				TriggerClientEvent('ox_inventory:Notify', source, {type = 'error', text = ox.locale('item_not_enough'), duration = 2500})
			end
		end
	end
	cb(false)
end)