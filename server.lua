local Inventory = server.inventory
local Items = server.items

---@param player table
---@param data table
--- player requires source, identifier, and name
--- optionally, it should contain job, sex, and dateofbirth
local function setPlayerInventory(player, data)
	while not shared.ready do Wait(0) end
	local inventory = {}
	local totalWeight = 0

	if data then
		for _, v in pairs(data) do
			if type(v) == 'number' then break end
			local item = Items(v.name)

			if item then
				local weight = Inventory.SlotWeight(item, v)
				totalWeight = totalWeight + weight

				if v.metadata then
					-- Update old bag items to container items
					if v.metadata.bag then
						v.metadata.container = v.metadata.bag
						v.metadata.size = Items.containers[v.name] or {5, 1000}
						v.metadata.bag = nil
					end

					-- Remove invalid durability
					if v.metadata.durability and not item.durability and not item.degrade and not v.name:find('WEAPON_') then
						v.metadata.durability = nil
					end
				end

				inventory[v.slot] = {name = v.name, label = item.label, weight = weight, slot = v.slot, count = v.count, description = item.description, metadata = v.metadata, stack = item.stack, close = item.close}
			end
		end
	end

	local inv = Inventory.Create(player.source, player.name, 'player', shared.playerslots, totalWeight, shared.playerweight, player.identifier, inventory)
	inv.player = server.setPlayerData(player)

	if shared.framework == 'esx' then Inventory.SyncInventory(inv) end
	TriggerClientEvent('ox_inventory:setPlayerInventory', player.source, Inventory.Drops, inventory, totalWeight, server.UsableItemsCallbacks, player)
end
exports('setPlayerInventory', setPlayerInventory)
AddEventHandler('ox_inventory:setPlayerInventory', setPlayerInventory)

local Stashes = data 'stashes'
local Vehicles = data 'vehicles'
local ServerCallback = import 'callbacks'
local table = import 'table'

ServerCallback.Register('openInventory', function(source, inv, data)
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
			local stash = Stashes[data.id]
			if stash then

				if not stash.jobs or (stash.jobs[left.player.job.name] and left.player.job.grade >= stash.jobs[left.player.job.name]) then
					local owner = stash.owner and left.owner or stash.owner
					right = Inventory(owner and stash.name..owner or stash.name)

					if not right then
						right = Inventory.Create(owner and stash.name..owner or stash.name, stash.label or stash.name, inv, stash.slots, 0, stash.weight, owner or false)
					end
				end

			else
				stash = Inventory.CustomStash[data.id or data]
				if stash then
					if not stash.jobs or (stash.jobs[left.player.job.name] and (type(stash.jobs) == 'table' and left.player.job.grade >= stash.jobs[left.player.job.name]) or stash.jobs == left.player.job.name) then
						local owner = (stash.owner == nil and nil) or (type(stash.owner) == 'string' and stash.owner) or data.owner or stash.owner and left.owner
						data = (owner and ('%s%s'):format(data.id or data, owner)) or data.id or data

						right = Inventory(data)
						if not right then
							right = Inventory.Create(data, stash.label or stash.name, inv, stash.slots, 0, stash.weight, owner or false)
						end
					end

				else return false end
			end

		elseif type(data) == 'table' then
			if data.class and data.model then
				right = Inventory(data.id)
				if not right then
					local vehicle = Vehicles[inv]['models'][data.model] or Vehicles[inv][data.class]
					right = Inventory.Create(data.id, data.id:sub(6), inv, vehicle[1], 0, vehicle[2], false)
				end
			elseif inv == 'drop' then
				right = Inventory(data.id)
			else
				return
			end

		elseif inv == 'policeevidence' then
			if server.isPolice(left) then
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
			if right.open then return end

			local otherplayer = right.type == 'player'
			if otherplayer then right.coords = GetEntityCoords(GetPlayerPed(right.id)) end

			if right.coords == nil or #(right.coords - GetEntityCoords(GetPlayerPed(source))) < 10 then
				right.open = source
				left.open = right.id
				if otherplayer then
					right:set('type', 'otherplayer')
				end

			else return end
		end

	else left.open = true end

	return {id=left.id, label=left.label, type=left.type, slots=left.slots, weight=left.weight, maxWeight=left.maxWeight}, right and {id=right.id, label=right.label, type=right.type, slots=right.slots, weight=right.weight, maxWeight=right.maxWeight, items=right.items, coords=right.coords}
end)

local Log = server.logs

ServerCallback.Register('swapItems', function(source, data)
	-- TODO: requires re-re-re-refactor and helper functions to reduce repetition
	if data.count > 0 and data.toType ~= 'shop' then
		local playerInventory, items, ret = Inventory(source), {}, nil

		if data.toType == 'newdrop' then
			local fromData = playerInventory.items[data.fromSlot]
			if fromData then
				if data.count > fromData.count then data.count = fromData.count end
				local toData = table.clone(fromData)
				toData.slot = data.toSlot
				toData.count = data.count
				fromData.count = fromData.count - data.count
				fromData.weight = Inventory.SlotWeight(Items(fromData.name), fromData)
				toData.weight = Inventory.SlotWeight(Items(toData.name), toData)
				playerInventory.weight = playerInventory.weight - toData.weight

				local slot = fromData.slot
				if fromData.count < 1 then fromData = nil end
				items[data.fromSlot] = fromData or false
				playerInventory.items[data.fromSlot] = fromData

				if shared.framework == 'esx' then Inventory.SyncInventory(playerInventory) end

				Inventory.CreateDrop(source, data.toSlot, toData, function(drop, dropData)
					if fromData == playerInventory.weapon then playerInventory.weapon = nil end
					Log(('%sx %s transferred from %s to %s'):format(data.count, toData.name, playerInventory.label, drop),
						playerInventory.owner,
						'swapSlots', playerInventory.owner, drop
					)
					TriggerClientEvent('ox_inventory:createDrop', -1, drop, dropData, playerInventory.open and source, slot)
				end, data.instance)

				return true, {weight=playerInventory.weight, items=items}
			end
		else
			local toInventory = (data.toType == 'player' and playerInventory) or Inventory(playerInventory.open)
			local fromInventory = (data.fromType == 'player' and playerInventory) or Inventory(playerInventory.open)
			local sameInventory = fromInventory.id == toInventory.id or false
			local container = (not sameInventory and playerInventory.containerSlot) and (fromInventory.type == 'container' and fromInventory or toInventory)
			local containerItem = container and playerInventory.items[playerInventory.containerSlot]

			if not sameInventory and toInventory.type == 'player' or toInventory.type == 'otherplayer' then
				local fromData = fromInventory.items[data.fromSlot]
				if not fromData then
					TriggerClientEvent('ox_inventory:closeInventory', source, true)
					return
				end
				local fromItem = Items(fromData.name)
				local _, totalCount, _ = Inventory.GetItemSlots(toInventory, fromItem, fromItem.metadata)
				if fromItem.limit and (totalCount + data.count) > fromItem.limit then
					if toInventory.type == 'player' then
						TriggerClientEvent('ox_inventory:notify', source, {type = 'error', text = shared.locale('cannot_carry_limit', fromItem.limit, fromItem.label)})
					elseif toInventory.type == 'otherplayer' then
						TriggerClientEvent('ox_inventory:notify', source, {type = 'error', text = shared.locale('cannot_carry_limit_other', fromItem.limit, fromItem.label)})
					end
					return
				end
			end

			if fromInventory.type == 'policeevidence' and not sameInventory then
				if not server.isPolice(toInventory) then return end
				if server.evidencegrade > toInventory.player.job.grade then
					TriggerClientEvent('ox_inventory:notify', source, {type = 'error', text = shared.locale('evidence_cannot_take')})
					return
				end
			end

			if toInventory and fromInventory and (fromInventory.id ~= toInventory.id or data.fromSlot ~= data.toSlot) then
				local fromData = fromInventory.items[data.fromSlot]
				if fromData and (not fromData.metadata.container or fromData.metadata.container and toInventory.type ~= 'container') then
					if data.count > fromData.count then data.count = fromData.count end

					local toData = toInventory.items[data.toSlot]
					local movedWeapon = fromInventory.weapon == data.fromSlot

					if movedWeapon then
						fromInventory.weapon = data.toSlot
						fromInventory.weapon = data.fromSlot
						if fromInventory.type == 'otherplayer' then movedWeapon = false end
						TriggerClientEvent('ox_inventory:disarm', fromInventory.id)
					end

					if toData and ((toData.name ~= fromData.name) or not toData.stack or (not table.matches(toData.metadata, fromData.metadata))) then
						-- Swap items
						local toWeight = not sameInventory and (toInventory.weight - toData.weight + fromData.weight)
						local fromWeight = not sameInventory and (fromInventory.weight + toData.weight - fromData.weight)

						if not sameInventory then
							if toWeight <= toInventory.maxWeight and fromWeight <= fromInventory.maxWeight then
								toData, fromData = Inventory.SwapSlots(fromInventory, toInventory, data.fromSlot, data.toSlot)
								fromInventory.weight = fromWeight
								toInventory.weight = toWeight

								if container then Inventory.ContainerWeight(containerItem, toInventory.type == 'container' and toWeight or fromWeight) end

								Log(('%sx %s transferred from %s to %s for %sx %s'):format(fromData.count, fromData.name, fromInventory.owner and fromInventory.label or fromInventory.id, toInventory.owner and toInventory.label or toInventory.id, toData.count, toData.name),
									playerInventory.owner,
									'swapSlots', fromInventory.owner or fromInventory.id, toInventory.owner or toInventory.id
								)

							else return end
						else toData, fromData = Inventory.SwapSlots(fromInventory, toInventory, data.fromSlot, data.toSlot) end

					elseif toData and toData.name == fromData.name and table.matches(toData.metadata, fromData.metadata) then
						-- Stack items
						toData.count += data.count
						fromData.count -= data.count
						local toSlotWeight = Inventory.SlotWeight(Items(toData.name), toData)
						local totalWeight = toInventory.weight - toData.weight + toSlotWeight

						if sameInventory or totalWeight <= toInventory.maxWeight then
							local fromSlotWeight = Inventory.SlotWeight(Items(fromData.name), fromData)
							toData.weight = toSlotWeight
							if not sameInventory then
								fromInventory.weight = fromInventory.weight - fromData.weight + fromSlotWeight
								toInventory.weight = totalWeight

								if container then Inventory.ContainerWeight(containerItem, toInventory.type == 'container' and toInventory.weight or fromInventory.weight) end

								Log(('%sx %s transferred from %s to %s'):format(data.count, fromData.name, fromInventory.owner and fromInventory.label or fromInventory.id, toInventory.owner and toInventory.label or toInventory.id),
									playerInventory.owner,
									'swapSlots', fromInventory.owner or fromInventory.id, toInventory.owner or toInventory.id
								)

							end
							fromData.weight = fromSlotWeight
						else
							toData.count -= data.count
							fromData.count += data.count
							return
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

								if container then Inventory.ContainerWeight(containerItem, toInventory.type == 'container' and toInventory.weight or fromInventory.weight) end

								Log(('%sx %s transferred from %s to %s'):format(data.count, fromData.name, fromInventory.owner and fromInventory.label or fromInventory.id, toInventory.owner and toInventory.label or toInventory.id),
									playerInventory.owner,
									'swapSlots', fromInventory.owner or fromInventory.id, toInventory.owner or toInventory.id
								)

							else

							end
						else return end
					end

					if fromData.count < 1 then fromData = nil end

					if fromInventory.type == 'player' then
						items[data.fromSlot] = fromData or false
						if toInventory.type == 'container' then
							items[playerInventory.containerSlot] = containerItem
						end
					end

					if toInventory.type == 'player' then
						items[data.toSlot] = toData or false
						if fromInventory.type == 'container' then
							items[playerInventory.containerSlot] = containerItem
						end
					end

					fromInventory.items[data.fromSlot] = fromData
					toInventory.items[data.toSlot] = toData

					if fromInventory.changed ~= nil then fromInventory.changed = true end
					if toInventory.changed ~= nil then toInventory.changed = true end

					if sameInventory and fromInventory.type == 'otherplayer' then
						TriggerClientEvent('ox_inventory:updateSlots', fromInventory.id,{
							{
								item = fromInventory.items[data.toSlot] or {slot=data.toSlot},
								inventory = fromInventory.type
							},
							{
								item = fromInventory.items[data.fromSlot] or {slot=data.fromSlot},
								inventory = fromInventory.type
							}
						}, {left=fromInventory.weight})

					elseif toInventory.type == 'otherplayer' then
						TriggerClientEvent('ox_inventory:updateSlots', toInventory.id,{
							{
								item = toInventory.items[data.toSlot] or {slot=data.toSlot},
								inventory = toInventory.type
							}
						}, {left=toInventory.weight})

					elseif fromInventory.type == 'otherplayer' then
						TriggerClientEvent('ox_inventory:updateSlots', fromInventory.id,{
							{
								item = fromInventory.items[data.fromSlot] or {slot=data.fromSlot},
								inventory = fromInventory.type
							}
						}, {left=fromInventory.weight})
					end

					if next(items) then
						ret = {weight=playerInventory.weight, items=items}
						if shared.framework == 'esx' and fromInventory.type == 'player' or fromInventory.type == 'otherplayer' then
							Inventory.SyncInventory(fromInventory)
						end
						if shared.framework == 'esx' and not sameInventory and (toInventory.type == 'player' or toInventory.type == 'otherplayer') then
							Inventory.SyncInventory(toInventory)
						end
					end

					return container and containerItem.weight or true, ret, movedWeapon and fromInventory.weapon
				end
			end
		end
	end
end)

local Licenses = data 'licenses'

ServerCallback.Register('buyLicense', function(source, id)
	if shared.framework == 'esx' then
		local license = Licenses[id]
		if license then
			local inventory = Inventory(source)
			local result = MySQL.scalar.await('SELECT 1 FROM user_licenses WHERE type = ? AND owner = ?', { license.name, inventory.owner })
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

ServerCallback.Register('getItemCount', function(source, item, metadata, target)
	local inventory = target and Inventory(target) or Inventory(source)
	return (inventory and Inventory.GetItem(inventory, item, metadata, true)) or 0
end)

ServerCallback.Register('getInventory', function(source, id)
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

ServerCallback.Register('useItem', function(source, item, slot, metadata)
	local inventory = Inventory(source)
	if inventory.type == 'player' then
		local item, type = Items(item)
		local data = item and (slot and inventory.items[slot] or Inventory.GetItem(source, item, metadata))
		local durability = data.metadata?.durability

		if durability then
			if durability > 100 then
				if os.time() > durability then
					inventory.items[slot].metadata.durability = 0
					TriggerClientEvent('ox_inventory:notify', source, {type = 'error', text = shared.locale('no_durability', data.name), duration = 2500})
					return
				end
			elseif durability <= 0 then
				TriggerClientEvent('ox_inventory:notify', source, {type = 'error', text = shared.locale('no_durability', data.name), duration = 2500})
				return
			end
		end

		if item and data and data.count > 0 and data.name == item.name then
			data = {name=data.name, label=data.label, count=data.count, slot=slot or data.slot, metadata=data.metadata, consume=item.consume}
			if type == 1 then -- weapon
				inventory.weapon = data.slot
				return data
			elseif type == 2 then -- ammo
				if inventory.weapon then
					local weapon = inventory.items[inventory.weapon]
					if weapon?.metadata.durability > 0 then
						data.consume = nil
						return data
					end
				end
				return false
			elseif type == 3 then -- component
				data.consume = 1
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
