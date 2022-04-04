if not lib then return end

lib.versionCheck('overextended/ox_inventory')

local Inventory = server.inventory
local Items = server.items

---@param player table
---@param data table
--- player requires source, identifier, and name
--- optionally, it should contain jobs/groups, sex, and dateofbirth
local function setPlayerInventory(player, data)
	while not shared.ready do Wait(0) end

	if not data then
		data = MySQL:loadPlayer(player.identifier)
	end

	local inventory = {}
	local totalWeight = 0

	if data then
		for _, v in pairs(data) do
			if type(v) == 'number' then break end
			local item = Items(v.name)

			if item then
				if v.metadata then
					v.metadata = Items.CheckMetadata(v.metadata, item, v.name)
				end

				local weight = Inventory.SlotWeight(item, v)
				totalWeight = totalWeight + weight

				inventory[v.slot] = {name = v.name, label = item.label, weight = weight, slot = v.slot, count = v.count, description = item.description, metadata = v.metadata, stack = item.stack, close = item.close}
			end
		end
	end

	player.source = tonumber(player.source)
	local inv = Inventory.Create(player.source, player.name, 'player', shared.playerslots, totalWeight, shared.playerweight, player.identifier, inventory)
	inv.player = server.setPlayerData(player)

	if shared.framework == 'esx' then Inventory.SyncInventory(inv) end
	TriggerClientEvent('ox_inventory:setPlayerInventory', player.source, Inventory.Drops, inventory, totalWeight, server.UsableItemsCallbacks, inv.player, player.source)
end
exports('setPlayerInventory', setPlayerInventory)
AddEventHandler('ox_inventory:setPlayerInventory', setPlayerInventory)

local Vehicles = data 'vehicles'

lib.callback.register('ox_inventory:openInventory', function(source, inv, data)
	local left = Inventory(source)
	local right = left.open and Inventory(left.open)

	if right then
		if right.open ~= source then return end
		right:set('open', false)
		left:set('open', false)
		right = nil
	end

	if data then
		if inv == 'stash' then
			right = Inventory(data, left)
			if right == false then return false end
		elseif type(data) == 'table' then
			if data.class and data.model then
				right = Inventory(data.id)
				if not right then
					local vehicle = Vehicles[inv]['models'][data.model] or Vehicles[inv][data.class]
					right = Inventory.Create(data.id, Inventory.GetPlateFromId(data.id), inv, vehicle[1], 0, vehicle[2], false)
				end
			elseif inv == 'drop' then
				right = Inventory(data.id)
			else
				return
			end

		elseif inv == 'policeevidence' then
			if server.hasGroup(left, shared.police) then
				data = ('evidence-%s'):format(data)
				right = Inventory(data)
				if not right then
					right = Inventory.Create(data, shared.locale('police_evidence'), inv, 100, 0, 100000, false)
				end
			end

		elseif inv == 'dumpster' then
			right = Inventory(data)
			if not right then
				right = Inventory.Create(data, shared.locale('dumpster'), inv, 15, 0, 100000, false)
			end

		elseif inv == 'container' then
			left.containerSlot = data
			data = left.items[data]

			if data then
				right = Inventory(data.metadata.container)

				if not right then
					right = Inventory.Create(data.metadata.container, data.label, inv, data.metadata.size[1], 0, data.metadata.size[2], false)
				end
			else left.containerSlot = nil end

		else right = Inventory(data) end

		if right then
			if right.open or (right.groups and not server.hasGroup(left, right.groups)) then return end

			local otherplayer = right.type == 'player'
			if otherplayer then right.coords = GetEntityCoords(GetPlayerPed(right.id)) end

			if right.coords == nil or #(right.coords - GetEntityCoords(GetPlayerPed(source))) < 10 then
				right.open = source
				left.open = right.id
				if otherplayer then
					right:set('type', 'otherplayer')
				end

			else return end
		else return end

	else left.open = true end

	return {id=left.id, label=left.label, type=left.type, slots=left.slots, weight=left.weight, maxWeight=left.maxWeight}, right and {id=right.id, label=right.label, type=right.type, slots=right.slots, weight=right.weight, maxWeight=right.maxWeight, items=right.items, coords=right.coords}
end)

local Licenses = data 'licenses'

lib.callback.register('ox_inventory:buyLicense', function(source, id)
	if shared.framework == 'esx' then
		local license = Licenses[id]
		if license then
			local inventory = Inventory(source)
			local result = MySQL:selectLicense(license.name, inventory.owner)

			if result then
				return false, 'has_weapon_license'
			elseif Inventory.GetItem(inventory, 'money', false, true) < license.price then
				return false, 'poor_weapon_license'
			else
				Inventory.RemoveItem(inventory, 'money', license.price)
				TriggerEvent('esx_license:addLicense', source, 'weapon')

				return true, 'bought_weapon_license'
			end
		end
	else
		shared.warning('Licenses can only be purchased when using es_extended and esx_licenses. Integrated functionality will be added soon.')
	end
end)

lib.callback.register('ox_inventory:getItemCount', function(source, item, metadata, target)
	local inventory = target and Inventory(target) or Inventory(source)
	return (inventory and Inventory.GetItem(inventory, item, metadata, true)) or 0
end)

lib.callback.register('ox_inventory:getInventory', function(source, id)
	local inventory = Inventory(id or source)
	return inventory and {
		id = inventory.id,
		label = inventory.label,
		type = inventory.type,
		slots = inventory.slots,
		weight = inventory.weight,
		maxWeight = inventory.maxWeight,
		owned = inventory.owner and true or false,
		items = inventory.items
	}
end)

lib.callback.register('ox_inventory:useItem', function(source, item, slot, metadata)
	local inventory = Inventory(source)
	if inventory.type == 'player' then
		local item, type = Items(item)
		local data = item and (slot and inventory.items[slot] or Inventory.GetItem(source, item, metadata))
		local durability = type ~= 1 and data.metadata?.durability

		if durability then
			if durability > 100 then
				if os.time() > durability then
					inventory.items[slot].metadata.durability = 0
					TriggerClientEvent('ox_inventory:notify', source, {type = 'error', text = shared.locale('no_durability', data.label), duration = 2500})
					return
				end
			elseif durability <= 0 then
				TriggerClientEvent('ox_inventory:notify', source, {type = 'error', text = shared.locale('no_durability', data.label), duration = 2500})
				return
			end
		end

		if item and data and data.count > 0 and data.name == item.name then
			inventory.usingItem = slot
			data = {name=data.name, label=data.label, count=data.count, slot=slot or data.slot, metadata=data.metadata, consume=item.consume}

			if item.weapon then
				inventory.weapon = data.slot
				return data
			elseif item.ammo then
				if inventory.weapon then
					local weapon = inventory.items[inventory.weapon]

					if weapon and weapon?.metadata.durability > 0 then
						data.consume = nil
						return data
					end
				end

				return false
			elseif item.component or item.tint then
				data.consume = 1
				data.component = true
				return data
			elseif server.UsableItemsCallbacks[item.name] then
				server.UseItem(source, data.name, data)
			else
				if item.consume and data.count >= item.consume then
					local result = item.cb and item.cb('usingItem', item, inventory, slot)

					if result == false then return end

					if result ~= nil then
						data.server = result
					end

					return data
				else
					TriggerClientEvent('ox_inventory:notify', source, {type = 'error', text = shared.locale('item_not_enough', item.name), duration = 2500})
				end
			end
		end
	end
end)
