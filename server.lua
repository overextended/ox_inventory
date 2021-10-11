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
				right = Inventory.Create('police-'..data.id, ox.locale('police_evidence'), inv, 100, 0, 100000, false)
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
		if right then
			if right.open == true then return cb(false) end
			if right.coords == nil or #(right.coords - GetEntityCoords(GetPlayerPed(source))) < 20 then
				right.open = source
				left.open = right.id
			else return cb(false) end
		end
	else left.open = true end
	cb({id=left.label, type=left.type, slots=left.slots, weight=left.weight, maxWeight=left.maxWeight}, right)
end)

Utils.RegisterServerCallback('ox_inventory:swapItems', function(source, cb, data)
	if data.count > 0 and data.toType ~= 'shop' then
		local playerInventory, items, ret = Inventory(source), {}, nil

		if data.toType == 'newdrop' then
			local fromData = playerInventory.items[data.fromSlot]
			local toData = table.clone(fromData)
			toData.slot = data.toSlot
			local items = {[data.fromSlot] = false}
			playerInventory.items[data.fromSlot] = nil
			Inventory.SyncInventory(ESX.GetPlayerFromId(playerInventory.id), playerInventory)
			playerInventory.weight = playerInventory.weight - toData.weight

			TriggerEvent('ox_inventory:createDrop', source, data.toSlot, toData, function(drop, coords)
				if fromData == playerInventory.weapon then playerInventory.weapon = nil end
				TriggerClientEvent('ox_inventory:createDrop', -1, {drop, coords}, playerInventory.open and source, fromData.slot)
			end)

			return cb(true, {weight=playerInventory.weight, items=items})
		else
			local toInventory = (data.toType == 'player' and playerInventory) or Inventory(playerInventory.open)
			local fromInventory = (data.fromType == 'player' and playerInventory) or Inventory(playerInventory.open)
			local sameInventory = fromInventory.id == toInventory.id or false

			if toInventory and fromInventory and (fromInventory.id ~= toInventory.id or data.fromSlot ~= data.toSlot) then
				local movedWeapon = fromInventory.weapon == data.fromSlot
				local fromData = fromInventory.items[data.fromSlot]
				local toData = toInventory.items[data.toSlot]
				if movedWeapon then
					if data.toType == 'player' then fromInventory.weapon = data.toSlot else TriggerClientEvent('ox_inventory:disarm', source) end
				end

				if fromData and (not fromData.metadata.container or fromData.metadata.container and toInventory.type ~= 'container') then
					if data.count > fromData.count then data.count = fromData.count end

					if toData and ((toData.name ~= fromData.name) or not toData.stack or (not Utils.MatchTables(toData.metadata, fromData.metadata))) then
						-- Swap items
						toData, fromData = Inventory.SwapSlots(fromInventory, toInventory, data.fromSlot, data.toSlot)
						if not sameInventory then
							local newWeight = toInventory.weight + toData.weight
							if newWeight <= toInventory.maxWeight then
								if not sameInventory then
									fromInventory.weight = fromInventory.weight - toData.weight
									toInventory.weight = newWeight
								end
							else return cb(false) end
						end
					elseif toData and toData.name == fromData.name and Utils.MatchTables(toData.metadata, fromData.metadata) then
						-- Stack items
						toData.count = toData.count + data.count
						local weight = Inventory.SlotWeight(Items(toData.name), toData)
						local newWeight = toInventory.weight + weight
						if sameInventory or newWeight <= toInventory.maxWeight then
							toData.weight = weight
							fromData.count = fromData.count - data.count
							fromData.weight = Inventory.SlotWeight(Items(fromData.name), fromData)
							if not sameInventory then
								fromInventory.weight = fromInventory.weight - toData.weight
								toInventory.weight = newWeight
							end
						else
							toData.count = toData.count - data.count
							return cb(false)
						end
					elseif data.count <= fromData.count then
						-- Move item to an empty slot
						toData = table.clone(fromData)
						toData.count = data.count
						toData.slot = data.toSlot
						toData.weight = Inventory.SlotWeight(Items(toData.name), toData)
						if sameInventory or (toInventory.weight + toData.weight <= toInventory.maxWeight) then
							fromData.count = fromData.count - data.count
							fromData.weight = Inventory.SlotWeight(Items(fromData.name), fromData)
							if not sameInventory then
								fromInventory.weight = fromInventory.weight - toData.weight
								toInventory.weight = toInventory.weight + toData.weight
							end
						else return cb(false) end
					end

					if fromData.count < 1 then fromData = nil end
					if data.fromType == 'player' then items[data.fromSlot] = fromData or false end
					if data.toType == 'player' then items[data.toSlot] = toData or false end
					fromInventory.items[data.fromSlot] = fromData
					toInventory.items[data.toSlot] = toData

					if next(items) then
						ret = {weight=playerInventory.weight, items=items}
						Inventory.SyncInventory(ESX.GetPlayerFromId(playerInventory.id), playerInventory)
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

Utils.RegisterServerCallback('ox_inventory:useItem', function(source, cb, item, slot, metadata)
	local inventory = Inventory(source)
	local item, type = Items(item)
	local data = item and (slot and inventory.items[slot] or Inventory.GetItem(source, item, metadata))
	local durability = data.metadata.durability
	if durability then
		if durability > 100 then
			if os.time() > durability then
				inventory.items[slot].metadata.durability = 0
				TriggerClientEvent('ox_inventory:Notify', source, {type = 'error', text = ox.locale('no_durability', data.name), duration = 2500})
				return cb(false)
			end
		elseif durability <= 0 then 
			TriggerClientEvent('ox_inventory:Notify', source, {type = 'error', text = ox.locale('no_durability', data.name), duration = 2500})
			return cb(false)
		end
	end
	if item and data and data.count > 0 and data.name == item.name then
		data = {name=data.name, label=data.label, count=data.count, slot=slot or data.slot, metadata=data.metadata, consume=item.consume}
		if type == 1 then -- weapon
			inventory.weapon = data.slot
			return cb(data)
		elseif type == 2 then -- ammo
			data.consume = nil
			return cb(data)
		elseif type == 3 then -- component
			data.consume = 1
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