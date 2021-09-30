local Stashes <const> = data('stashes')
local Vehicle <const> = data('vehicles')
local Licenses <const> = data('licenses')
local Shops <const> = module('shops')
local Items <const> = module('items')
local Utils <const> = module('utils')
local Inventory <const> = module('inventory')

RegisterServerEvent('ox_inventory:requestPlayerInventory', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	while not ox.ready do Wait(0) end
	if next(xPlayer.inventory) then
		TriggerEvent('ox_inventory:setPlayerInventory', xPlayer)
	else
		exports.oxmysql:scalar('SELECT inventory FROM users WHERE identifier = ?', { xPlayer.identifier }, function(result)
			if result then inventory = json.decode(result) end
			TriggerEvent('ox_inventory:setPlayerInventory', xPlayer, result and json.decode(result))
		end)
	end
end)

RegisterServerEvent('ox_inventory:closeInventory', function()
	local inventory, secondary = Inventory(source)
	if inventory.open then secondary = Inventory(inventory.open) end
	if secondary then secondary:set('open', false) end
	inventory:set('open', false)
end)

AddEventHandler('ox_inventory:setPlayerInventory', function(xPlayer, data)
	local money, inventory, totalWeight = {money=0, black_money=0}, {}, 0
	for _, v in pairs(data or xPlayer.inventory) do
		if type(v) == 'number' then break end
		local item = Items(v.name)
		if item then
			local weight = Inventory.SlotWeight(item, v)
			totalWeight = totalWeight + weight
			if v.metadata and v.metadata.bag then
				v.metadata.container = v.metadata.bag
				v.metadata.size = {5, 1000}
				v.metadata.bag = nil
			end
			inventory[v.slot] = {name = v.name, label = item.label, weight = weight, slot = v.slot, count = v.count, description = item.description, metadata = v.metadata, stack = item.stack, close = item.close}
			if money[v.name] then money[v.name] = money[v.name] + v.count end
		end
	end
	Inventory.Create(xPlayer.source, xPlayer.name, 'player', Config.PlayerSlots, totalWeight, Config.DefaultWeight, xPlayer.identifier, inventory)
	xPlayer.syncInventory(totalWeight, Config.DefaultWeight, inventory, money)
	TriggerClientEvent('ox_inventory:setPlayerInventory', xPlayer.source, Inventory.Drops, inventory, totalWeight, ESX.UsableItemsCallbacks, ('%s - %s'):format(xPlayer.name, xPlayer.job.name))
end)

Utils.RegisterServerCallback('ox_inventory:openInventory', function(source, cb, inv, data)
	local left, right = Inventory(source)
	if data then
		if inv == 'policeevidence' then
			right = Inventory('police-'..data.id)
			if not right then
				right = Inventory.Create('police-'..data.id, 'Police evidence', inv, 100, 0, 100000, false)
			end
		elseif inv == 'stash' then
			local stash = Stashes[data.id]
			if not stash then
				stash = data
				stash.name = stash.name
				stash.slots = tonumber(stash.slots)
				stash.weight = tonumber(stash.weight)
				stash.coords = stash.coords
			end
			stash.owner = stash.owner == true and left.owner or stash.owner
			right = Inventory(stash.owner and stash.name..stash.owner or stash.name)
			if not right then
				right = Inventory.Create(stash.owner and stash.name..stash.owner or stash.name, stash.label or stash.name, inv, stash.slots, 0, stash.weight, stash.owner or false)
				right.coords = stash.coords
			end
		elseif inv == 'container' then
			data = left.items[data]
			right = Inventory(data.metadata.container)
			if not right then
				right = Inventory.Create(data.metadata.container, data.label, inv, data.metadata.size[1], 0, data.metadata.size[2], false)
			end
		elseif inv == 'dumpster' then
			right = Inventory(data.id)
			if not right then
				right = Inventory.Create(data.id, 'Dumpster', inv, 15, 0, 100000, false)
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
		if right.open == true then return cb(false) end
		if right.coords == nil or #(right.coords - GetEntityCoords(GetPlayerPed(source))) < 20 then
			right.open = source
			left.open = right.id
		else return cb(false) end
	else left.open = true end
	cb({id=left.label, type=left.type, slots=left.slots, weight=left.weight, maxWeight=left.maxWeight}, right)
end)

Utils.RegisterServerCallback('ox_inventory:swapItems', function(source, cb, data)
	if data.count > 0 and data.toType ~= 'shop' then
		local playerInventory, items, ret = Inventory(source), {}, nil

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
				TriggerClientEvent('ox_inventory:createDrop', -1, {drop, coords}, playerInventory.open and source, fromSlot.slot)
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
					if toSlot and ((toSlot.name ~= fromSlot.name) or not toSlot.stack or (not Utils.MatchTables(toSlot.metadata, fromSlot.metadata))) then
						toSlot, fromSlot = Inventory.SwapSlots(fromInventory, toInventory, data.fromSlot, data.toSlot)
						local newWeight = toInventory.weight + toSlot.weight
						if newWeight <= toInventory.maxWeight then
							if fromInventory.id ~= toInventory.id then
								fromInventory.weight = fromInventory.weight - toSlot.weight
								toInventory.weight = newWeight
							end
						else return cb(false) end
					elseif toSlot and toSlot.name == fromSlot.name and Utils.MatchTables(toSlot.metadata, fromSlot.metadata) then
						toSlot.count = toSlot.count + data.count
						local weight = Inventory.SlotWeight(Items(toSlot.name), toSlot)
						local newWeight = toInventory.weight + weight
						if newWeight <= toInventory.maxWeight then
							toSlot.weight = weight
							fromSlot.count = fromSlot.count - data.count
							fromSlot.weight = Inventory.SlotWeight(Items(fromSlot.name), fromSlot)
							if fromInventory.id ~= toInventory.id then
								fromInventory.weight = fromInventory.weight - toSlot.weight
								toInventory.weight = newWeight
							end
						else
							toSlot.count = toSlot.count - data.count
							return cb(false)
						end
					elseif data.count <= fromSlot.count then
						toSlot = table.clone(fromSlot)
						toSlot.count = data.count
						toSlot.slot = data.toSlot
						toSlot.weight = Inventory.SlotWeight(Items(toSlot.name), toSlot)
						local newWeight = toInventory.weight + toSlot.weight
						if newWeight <= toInventory.maxWeight then
							fromSlot.count = fromSlot.count - data.count
							fromSlot.weight = Inventory.SlotWeight(Items(fromSlot.name), fromSlot)
							if fromInventory.id ~= toInventory.id then
								fromInventory.weight = fromInventory.weight - toSlot.weight
								toInventory.weight = toInventory.weight + toSlot.weight
							end
						else return cb(false) end
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
					if fromInventory.changed ~= nil then fromInventory.changed = true end
					if toInventory.changed ~= nil then toInventory.changed = true end
					return cb(true, ret, movedWeapon and fromInventory.weapon)
				end
			end
		end
	end
	cb(false)
end)

Utils.RegisterServerCallback('ox_inventory:buyLicense', function(source, cb, id)
	local license = Licenses[id]
	if license then
		local inventory = Inventory(source)
		exports.oxmysql:scalar('SELECT 1 FROM user_licenses WHERE type = ? AND owner = ?', { license.name, inventory.owner }, function(result)
			if result then
				cb(false, 'has_weapon_license')
			elseif Inventory.GetItem(inventory, 'money', false, true) < license.price then
				cb(false, 'poor_weapon_license')
			else
				Inventory.RemoveItem(inventory, 'money', license.price)
				TriggerEvent('esx_license:addLicense', source, 'weapon', function()
					cb('bought_weapon_license')
				end)
			end
		end)
	else cb() end
end)

Utils.RegisterServerCallback('ox_inventory:getItemCount', function(source, cb, item, metadata, target)
	local inventory = target and Inventory(target) or Inventory(source)
	cb((inventory and Inventory.GetItem(inventory, item, metadata, true)) or 0)
end)

Utils.RegisterServerCallback('ox_inventory:getInventory', function(source, cb, id)
	local inventory = Inventory(id or source)
	return inventory and cb({
		id = inventory.id,
		label = inventory.label,
		type = inventory.type,
		slots = inventory.slots,
		weight = inventory.weight,
		maxWeight = inventory.maxWeight,
		owned = inventory.owner and true or false,
		items = inventory.items
	}) or cb()
end)

RegisterServerEvent('ox_inventory:updateWeapon', function(action, value, slot)
	local inventory = Inventory(source)
	local weapon = inventory.items[inventory.weapon or slot]
	if weapon and weapon.metadata then
		if action == 'load' then
			local ammo = Items(weapon.name).ammoname
			local diff = value - weapon.metadata.ammo
			Inventory.RemoveItem(inventory, ammo, diff)
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

Utils.RegisterServerCallback('ox_inventory:useItem', function(source, cb, item, slot, metadata)
	local inventory = Inventory(source)
	local item, type = Items(item)
	local data = item and (slot and inventory.items[slot] or Inventory.GetItem(source, item, metadata))
	if item and data and data.count > 0 and data.name == item.name then
		data = {name=data.name, label=data.label, count=data.count, slot=slot or data.slot, metadata=data.metadata, consume=item.consume}
		if type == 1 then -- weapon
			inventory.weapon = data.slot
			return cb(data)
		elseif type == 2 then -- ammo
			data.consume = nil
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
				TriggerClientEvent('ox_inventory:Notify', source, {type = 'error', text = ox.locale('item_not_enough', item.name), duration = 2500})
			end
		end
	end
	cb(false)
end)