local Inventory = module('inventory')
local Function = module('functions', true)
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
	if secondary then
		secondary:set('open', false)
	end
	inventory:set('open', false)
end)

AddEventHandler('ox_inventory:setPlayerInventory', function(xPlayer, data)
	local money, inventory, totalWeight = {money=0, black_money=0}, {}, 0
	if data and next(data) then
		for i=1, #data do
			local i = data[i]
			if type(i) == 'number' then break end
			local item = Items.List[i.name]
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
	Inventory.Create(drop, 'Drop '..drop, 'drop', Config.PlayerSlots, 0, Config.DefaultWeight, false, {[slot] = Function.Copy(toSlot)})
	local coords = GetEntityCoords(GetPlayerPed(source))
	Inventory(drop):set('coords', coords)
	TriggerClientEvent('ox_inventory:createDrop', -1, {drop, coords}, source)
end)

ox.RegisterServerCallback('ox_inventory:openInventory', function(source, cb, inv, data) 
	local left, right = Inventory(source)
	if data then
		right = Inventory(data.id)
		if right then
			right.open = source
			left.open = data.id
		end
		--Inventory.Create(data.id, data.label or data.id, inv, 20, 0, 2000, data.owner, {})
	else
		--[[if not Inventory('test') then Inventory.Create('test', 'Drop 6969', 'drop', Config.PlayerSlots, 0, Config.DefaultWeight, false, {}) end
		right = Inventory('test')
		right.open = source
		left.open = right.id]]
	end
	cb({id=left.name, type=left.type, slots=left.slots, weight=left.weight, maxWeight=left.maxWeight}, right)
end)

ox.RegisterServerCallback('ox_inventory:swapItems', function(source, cb, data)
	if data.count > 0 and data.fromSlot ~= data.toSlot then
		local playerInventory, items, ret = Inventory(source) or false, {}
		if data.toType == 'newdrop' then
			local fromSlot = playerInventory.items[data.fromSlot]
			local toSlot = Function.Copy(fromSlot)
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
				elseif toSlot and ((toSlot.name ~= fromSlot.name) or (not Function.MatchTables(toSlot.metadata, fromSlot.metadata))) then
					toSlot, fromSlot = Inventory.SwapSlots({fromInventory, toInventory}, {data.fromSlot, data.toSlot})
				elseif data.count <= fromSlot.count then
					fromSlot.count = fromSlot.count - data.count
					toSlot = Function.Copy(fromSlot)
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
				fromInventory.items[data.fromSlot], toInventory.items[data.toSlot] = fromSlot, toSlot
				return cb(1, ret)
			end
		end
	end
	cb(0)
end)