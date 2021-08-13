local Inventory = module('inventory')
local Utils = module('utils', true)
local Items = module('items')

RegisterNetEvent('equip', function(weapon)
	local inv = Inventory(source)
	inv.weapon = weapon
end)

RegisterNetEvent('ox_inventory:requestPlayerInventory', function()
	local xPlayer, inventory = ESX.GetPlayerFromId(source)
	Wait(math.random(0, 1000)) -- slow down queries if resource restarts
	local result = exports.ghmattimysql:scalarSync('SELECT inventory FROM users WHERE identifier = ?', {
		xPlayer.identifier
	})
	if result then inventory = json.decode(result) end
	repeat Wait(500) until ox.ready
	TriggerEvent('ox_inventory:setPlayerInventory', xPlayer, inventory)
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

AddEventHandler('ox_inventory:createDrop', function(source, slot, toSlot)
	local drop
	repeat
		drop = math.random(100000, 999999)
		Wait(5)
	until not Inventory(drop)
	Inventory.Create(drop, 'Drop '..drop, 'drop', Config.PlayerSlots, 0, Config.DefaultWeight, false, {[slot] = Utils.Copy(toSlot)})
	local coords = GetEntityCoords(GetPlayerPed(source))
	Inventory(drop):set('coords', coords)
	TriggerClientEvent('ox_inventory:createDrop', -1, {drop, coords}, source)
end)

local Stash = data('stashes')
local Vehicle = data('vehicles')
ox.RegisterServerCallback('ox_inventory:openInventory', function(source, cb, inv, data) 
	local left, right = Inventory(source)
	if data then
		right = Inventory(data.id)
		if not right then
			if data.class then
				local vehicle = Vehicle[inv][data.class]
				if data.owner == true then data.owner = left:player().identifier else data.owner = left:player().identifier end
				Inventory.Create(data.id, data.id, inv, vehicle[1], 0, vehicle[2], data.owner)
				right = Inventory(data.id)
			end
		end
		if not right.open then
			right.open = source
			left.open = data.id
		end
	end
	cb({id=left.name, type=left.type, slots=left.slots, weight=left.weight, maxWeight=left.maxWeight}, right)
end)

ox.RegisterServerCallback('ox_inventory:swapItems', function(source, cb, data)
	if data.count > 0 and data.fromSlot ~= data.toSlot then
		local playerInventory, items, ret = Inventory(source) or false, {}
		if data.toType == 'newdrop' then
			local fromSlot = playerInventory.items[data.fromSlot]
			local toSlot = Utils.Copy(fromSlot)
			toSlot.slot = data.toSlot
			TriggerEvent('ox_inventory:createDrop', source, data.toSlot, toSlot)
			local items = {[data.fromSlot] = false}
			playerInventory.items[data.fromSlot] = nil
			Inventory.SyncInventory(playerInventory:player(), playerInventory, items)
			return cb(1, {weight=playerInventory.weight, items=items})
		else
			local toInventory = data.toType == 'player' and playerInventory or Inventory(playerInventory.open)
			local fromInventory = data.fromType == 'player' and playerInventory or Inventory(playerInventory.open)
			local fromSlot, toSlot = fromInventory.items[data.fromSlot], toInventory.items[data.toSlot]
			if fromSlot then
				if data.count > fromSlot.count then data.count = fromSlot.count end
				if toSlot and toSlot.name == fromSlot.name then
					fromSlot.count = fromSlot.count - data.count
					toSlot.count = toSlot.count + data.count
				elseif toSlot and ((toSlot.name ~= fromSlot.name) or (not Utils.MatchTables(toSlot.metadata, fromSlot.metadata))) then
					toSlot, fromSlot = Inventory.SwapSlots({fromInventory, toInventory}, {data.fromSlot, data.toSlot})
				elseif data.count <= fromSlot.count then
					fromSlot.count = fromSlot.count - data.count
					toSlot = Utils.Copy(fromSlot)
					toSlot.count = data.count
					toSlot.slot = data.toSlot
				else
					return print('swapItems', data.fromType, data.fromSlot, 'to', data.toType, data.toSlot)
				end
				if fromSlot.count < 1 then fromSlot = nil end
				if data.fromType == 'player' then items[data.fromSlot] = fromSlot or false end
				if data.toType == 'player' then items[data.toSlot] = toSlot or false end
				if next(items) then
					ret = {weight=playerInventory.weight, items=items}
					Inventory.SyncInventory(playerInventory:player(), playerInventory, items)
				end
				if fromInventory.changed ~= nil then fromInventory:set('changed', true) end
				if toInventory.changed ~= nil then toInventory:set('changed', true) end
				fromInventory.items[data.fromSlot], toInventory.items[data.toSlot] = fromSlot, toSlot
				return cb(1, ret)
			end
		end
	end
	cb(0)
end)