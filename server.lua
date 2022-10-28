if not lib then return end

if GetConvar('inventory:versioncheck', 'true') == 'true' then
	lib.versionCheck('overextended/ox_inventory')
end

local Inventory = server.inventory
local Items = server.items

---@param player table
---@param data table?
--- player requires source, identifier, and name
--- optionally, it should contain jobs/groups, sex, and dateofbirth
function server.setPlayerInventory(player, data)
	while not shared.ready do Wait(0) end

	if not data then
		data = db.loadPlayer(player.identifier)
	end

	local inventory = {}
	local totalWeight = 0

	if data and next(data) then
		local ostime = os.time()

		for _, v in pairs(data) do
			if type(v) == 'number' then
				if server.convertInventory then
					inventory, totalWeight = server.convertInventory(player.source, data)
					break
				else
					return error(('Inventory for player.%s (%s) contains invalid data. Ensure you have converted inventories to the correct format.'):format(player.source, GetPlayerName(player.source)))
				end
			else
				local item = Items(v.name)

				if item then
					if v.metadata then
						v.metadata = Items.CheckMetadata(v.metadata, item, v.name, ostime)
					end

					local weight = Inventory.SlotWeight(item, v)
					totalWeight = totalWeight + weight

					inventory[v.slot] = {name = item.name, label = item.label, weight = weight, slot = v.slot, count = v.count, description = item.description, metadata = v.metadata, stack = item.stack, close = item.close}
				end
			end
		end
	end

	player.source = tonumber(player.source)
	local inv = Inventory.Create(player.source, player.name, 'player', shared.playerslots, totalWeight, shared.playerweight, player.identifier, inventory)
	inv.player = server.setPlayerData(player)
	inv.player.ped = GetPlayerPed(player.source)

	if server.syncInventory then server.syncInventory(inv) end
	TriggerClientEvent('ox_inventory:setPlayerInventory', player.source, Inventory.Drops, inventory, totalWeight, inv.player, player.source)
end
exports('setPlayerInventory', server.setPlayerInventory)
AddEventHandler('ox_inventory:setPlayerInventory', server.setPlayerInventory)

lib.callback.register('ox_inventory:openInventory', function(source, inv, data)
	if Inventory.Lock then return false end

	local left = Inventory(source)
	local right = left.open and left.open ~= true and Inventory(left.open) or nil

	if right then
		if right.open ~= source then return end

		if right.player then
			TriggerClientEvent('ox_inventory:closeInventory', right.player.source, true)
		end

		right:set('open', false)
		left:set('open', false)
		right = nil
	end

	if data then
		if inv == 'stash' then
			right = Inventory(data, left)
			if right == false then return false end
		elseif type(data) == 'table' then
			if data.netid then
				data.type = inv
				right = Inventory(data)
			elseif inv == 'drop' then
				right = Inventory(data.id)
			else
				return
			end
		elseif inv == 'policeevidence' then
			if server.hasGroup(left, shared.police) then
				right = Inventory(('evidence-%s'):format(data))
			end
		elseif inv == 'dumpster' then
			right = Inventory(data)

			if not right then
				local netid = tonumber(data:sub(9))

				-- dumpsters do not work with entity lockdown. need to rewrite, but having to do
				-- distance checks to some ~7000 dumpsters and freeze the entities isn't ideal
				if netid and NetworkGetEntityFromNetworkId(netid) > 0 then
					right = Inventory.Create(data, locale('dumpster'), inv, 15, 0, 100000, false)
				end
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

	return {id=left.id, label=left.label, type=left.type, slots=left.slots, weight=left.weight, maxWeight=left.maxWeight}, right and {id=right.id, label=right.type == 'otherplayer' and '' or right.label, type=right.type, slots=right.slots, weight=right.weight, maxWeight=right.maxWeight, items=right.items, coords=right.coords, distance=right.distance}
end)

local Licenses = data 'licenses'

---@todo licenses functions as part of bridge (keep the callback here)
lib.callback.register('ox_inventory:buyLicense', function(source, id)
	local license = Licenses[id]
	if not license then return end

	local inventory = Inventory(source)
	if not inventory then return end

	return server.buyLicense(inventory, license)
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

---@param source number
---@param itemName string
---@param slot number?
---@param metadata table?
---@return table | boolean | nil
lib.callback.register('ox_inventory:useItem', function(source, itemName, slot, metadata)
	local inventory = Inventory(source)
	if inventory.type == 'player' then
		local item = Items(itemName)
		local data = item and (slot and inventory.items[slot] or Inventory.GetItem(source, item, metadata))

		if not data then return end

		local durability = data.metadata?.durability

		if durability then
			if durability > 100 then
				if os.time() > durability then
					inventory.items[slot].metadata.durability = 0
					TriggerClientEvent('ox_lib:notify', source, { type = 'error', description = locale('no_durability', data.label) })
					return
				end
			elseif durability <= 0 then
				TriggerClientEvent('ox_lib:notify', source, { type = 'error', description = locale('no_durability', data.label) })
				return
			end
		end

		if item and data and data.count > 0 and data.name == item.name then
			inventory.usingItem = slot
			data = {name=data.name, label=data.label, count=data.count, slot=slot or data.slot, metadata=data.metadata, consume=item.consume}

			if item.weapon then
				inventory.weapon = inventory.weapon ~= data.slot and data.slot or nil
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
			elseif item.consume then
				if data.count >= item.consume then
					local result = item.cb and item.cb('usingItem', item, inventory, slot)

					if result == false then return end

					if result ~= nil then
						data.server = result
					end

					return data
				else
					TriggerClientEvent('ox_lib:notify', source, { type = 'error', description = locale('item_not_enough', item.name) })
				end
			elseif server.UseItem then
				pcall(server.UseItem, source, data.name, data)
			end
		end
	end
end)

local function conversionScript()
	shared.ready = false

	local file = 'setup/convert.lua'
	local import = LoadResourceFile(shared.resource, file)
	local func = load(import, ('@@%s/%s'):format(shared.resource, file)) --[[@as function]]

	conversionScript = func()
end

RegisterCommand('convertinventory', function(source, args)
	if source ~= 0 then return shared.warning('This command can only be executed with the server console.') end
	if type(conversionScript) == 'function' then conversionScript() end
	local arg = args[1]

	local convert = arg and conversionScript[arg]

	if not convert then
		return shared.info('Invalid conversion argument. Valid options: esx, esxproperty, qb, linden')
	end

	CreateThread(convert)
end, true)
