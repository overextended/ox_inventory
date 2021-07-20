DefaultWeight = ESX.GetConfig().MaxWeight

CheckPlayer = function(xPlayer)
	if not xPlayer or not xPlayer.source then
		print(('^1[error]^7 Specified xPlayer does not exist so stop trying to perform functions on them'):format(name))
		return false
	end
	local count = 0
	while not Inventories[xPlayer.source] do
		Citizen.Wait(500)
		count = count + 1
		if count == 10 then return false end
	end
	return true
end


getInventoryItem = function(xPlayer, name, metadata)
	if CheckPlayer(xPlayer) ~= true then return end
	if name then
		local xItem = Items[name]
		if not xItem then print(('^1[error]^7 %s does not exist'):format(name)) return end
		xItem.count = 0
		for k, v in pairs(Inventories[xPlayer.source].inventory) do
			if v.name == name then
				if not v.metadata then v.metadata = {} end
				if not metadata or func.matchtables(v.metadata, metadata) then
					xItem.count = xItem.count + v.count
				end
			end
		end
		return xItem
	end
	return
end
exports('getInventoryItem', getInventoryItem)


addInventoryItem = function(xPlayer, item, count, metadata, slot)
	if CheckPlayer(xPlayer) ~= true then return end
	local xItem = Items[item]
	if xPlayer and xItem and count > 0 then
		local isWeapon = item:find('WEAPON_')
		if metadata == 'setname' then metadata = {description = xPlayer.getName()} elseif not isWeapon then metadata = setMetadata(metadata) end
		local toSlot, existing
		if slot then slot = getPlayerSlot(xPlayer, slot, item, metadata).slot
		else
			for i=1, Config.PlayerSlots do
				if xItem.stack and Inventories[xPlayer.source].inventory[i] and Inventories[xPlayer.source].inventory[i].name == item and func.matchtables(Inventories[xPlayer.source].inventory[i].metadata, metadata) then toSlot = i existing = true break
				elseif not toSlot and Inventories[xPlayer.source].inventory[i] == nil then toSlot = i existing = false end
			end
			slot = toSlot
		end
		if isWeapon then
			if not xItem.ammoname then
				metadata = {}
				if not xItem.throwable then count = 1 metadata.durability = 100 end
			else
				count = 1
				if type(metadata) ~= 'table' then metadata = {} end
				if not metadata.durability then metadata.durability = 100 end
				if xItem.ammoname then metadata.ammo = 0 end
				if not metadata.components then metadata.components = {} end
				if metadata.registered ~= false then
					metadata.registered = xPlayer.getName()
					metadata.serial = GenerateSerial(metadata.serial)
				end
			end
			Inventories[xPlayer.source].inventory[slot] = {name = item, label = xItem.label, weight = xItem.weight, slot = slot, count = count, description = xItem.description, metadata = metadata, stack = xItem.stack, close = true}
			if xItem.ammoname then Inventories[xPlayer.source].inventory[slot].ammoname = xItem.ammoname end
			ItemNotify(xPlayer, Inventories[xPlayer.source].inventory[slot], count, slot, 'added')
		else
			if item:find('identification') then
				count = 1
				if next(metadata) == nil then
					metadata = {}
					metadata.type = xPlayer.getName()
					metadata.description = GetPlayerIdentification(xPlayer)
				end
			elseif item:find('paperbag') then
				count = 1
				metadata = {}
				metadata.bag = GenerateText(3)..os.time(os.date("!*t"))
			end

			local added = count
			if existing then count = Inventories[xPlayer.source].inventory[slot].count + count end
			Inventories[xPlayer.source].inventory[slot] = {name = item, label = xItem.label, weight = xItem.weight, slot = slot, count = count, description = xItem.description, metadata = metadata or {}, stack = xItem.stack, close = xItem.close}
			ItemNotify(xPlayer, Inventories[xPlayer.source].inventory[slot], added, slot, 'added')
		end
		syncInventory(xPlayer)
		if slot then TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source]) end
	end
end
exports('addInventoryItem', addInventoryItem)


removeInventoryItem = function(xPlayer, item, count, metadata, slot)
	if CheckPlayer(xPlayer) ~= true then return end
	local xItem = Items[item]
	if xPlayer and xItem and count > 0 then
		if metadata then metadata = setMetadata(metadata) end
		if slot and Inventories[xPlayer.source].inventory[slot].count == count and Inventories[xPlayer.source].inventory[slot].name == xItem.name then
			ItemNotify(xPlayer, Inventories[xPlayer.source].inventory[slot], count, slot, 'removed')
			Inventories[xPlayer.source].inventory[slot] = nil
			TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source])
		elseif slot and Inventories[xPlayer.source].inventory[slot].count > count and Inventories[xPlayer.source].inventory[slot].name == xItem.name then
			local newCount = Inventories[xPlayer.source].inventory[slot].count - count
			ItemNotify(xPlayer, Inventories[xPlayer.source].inventory[slot], count, slot, 'removed')
			Inventories[xPlayer.source].inventory[slot] = {name = item, label = xItem.label, weight = xItem.weight, slot = slot, count = newCount, description = xItem.description, metadata = Inventories[xPlayer.source].inventory[slot].metadata, stack = xItem.stack, close = xItem.close}
			TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source])
		else
			local itemSlots, totalCount = getInventoryItemSlots(xPlayer, item, metadata)
			if itemSlots and totalCount > 0 then
				if count > totalCount then count = totalCount end
				local removed, total = 0, count
				for k, v in pairs(itemSlots) do -- k = slot, v = count
					if removed < total then
						if v == count then
							removed = total
							Inventories[xPlayer.source].inventory[k] = nil
						elseif v > count then
							removed = total
							count = v - count
							Inventories[xPlayer.source].inventory[k] = {name = item, label = xItem.label, weight = xItem.weight, slot = k, count = count, description = xItem.description, metadata = Inventories[xPlayer.source].inventory[k].metadata, stack = xItem.stack, close = xItem.close}
						else -- v < count
							removed = v
							count = count - v
							Inventories[xPlayer.source].inventory[k] = nil
						end
					end
				end
				ItemNotify(xPlayer, xItem, removed, itemSlots, 'removed')
				TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source])
			end
		end
		syncInventory(xPlayer)
	end
end
exports('removeInventoryItem', removeInventoryItem)


setInventoryItem = function(xPlayer, name, count, metadata)
	if CheckPlayer(xPlayer) ~= true then return end
	local item = getInventoryItem(xPlayer, name, metadata)
	if item and count >= 0 then
		count = ESX.Math.Round(count)
		if count > item.count then
			count = count - item.count
			addInventoryItem(xPlayer, item.name, count, metadata, false)
		else
			count = item.count - count
			removeInventoryItem(xPlayer, item.name, count, metadata, false)
		end
	end
end
exports('setInventoryItem', setInventoryItem)


syncInventory = function(xPlayer, force, metaweight, slot)
	local newWeight = getWeight(xPlayer)
	if force or newWeight ~= Inventories[xPlayer.source].weight then
		Inventories[xPlayer.source].weight = newWeight
		TriggerClientEvent('linden_inventory:updateStorage', xPlayer.source, {newWeight, Inventories[xPlayer.source].maxWeight, Inventories[xPlayer.source].slots})
	end
	if slot and Inventories[xPlayer.source].inventory[slot] and metaweight then
		Inventories[xPlayer.source].inventory[slot].weight = Items[Inventories[xPlayer.source].inventory[slot].name].weight + metaweight
		Inventories[xPlayer.source].inventory[slot].metadata.weight = metaweight
	end
	local money = getInventoryItem(xPlayer, 'money').count
	local dirty = getInventoryItem(xPlayer, 'black_money').count
	xPlayer.syncInventory(money, dirty, Inventories[xPlayer.source].inventory, Inventories[xPlayer.source].weight, Inventories[xPlayer.source].maxWeight)
end


getWeight = function(xPlayer)
	local weight = 0
	if Inventories[xPlayer.source] then
		for k, v in pairs(Inventories[xPlayer.source].inventory) do
			weight = weight + (v.weight * v.count)
		end
	end
	return weight
end
exports('getWeight', getWeight)


getMaxWeight = function(xPlayer)
	if not Inventories[xPlayer.source] then return DefaultWeight
	else return Inventories[xPlayer.source].maxWeight end
end
exports('getMaxWeight', getMaxWeight)


setMaxWeight = function(xPlayer, newWeight)
	Inventories[xPlayer.source].maxWeight = newWeight
end
exports('setMaxWeight', setMaxWeight)


canCarryItem = function(xPlayer, name, count, metadata)
	if CheckPlayer(xPlayer) ~= true then return end
	local xItem = Items[name]
	if xItem then
		local freeSlot = false
		local itemSlots, totalCount, emptySlots = getInventoryItemSlots(xPlayer, name, metadata)
		if #itemSlots > 0 or emptySlots > 0 then
			if xItem.weight == 0 then return true end
			if count == nil then count = 1 end
			local curWeight, itemWeight = Inventories[xPlayer.source].weight, xItem.weight
			local newWeight = curWeight + (itemWeight * count)
			return newWeight <= Inventories[xPlayer.source].maxWeight
		end
	end
	return false
end
exports('canCarryItem', canCarryItem)


canSwapItem = function(xPlayer, firstItem, firstItemCount, testItem, testItemCount)
	if CheckPlayer(xPlayer) ~= true then return end
	local curWeight = Inventories[xPlayer.source].weight
	local firstItemObject = getInventoryItem(xPlayer, firstItem)
	local testItemObject = getInventoryItem(xPlayer, testItem)
	if firstItemObject.count >= firstItemCount then
		local weightWithoutFirstItem = curWeight - (firstItemObject.weight * firstItemCount)
		local weightWithTestItem = weightWithoutFirstItem + (testItemObject.weight * testItemCount)
		return weightWithTestItem <= Inventories[xPlayer.source].maxWeight
	end
	return false
end
exports('canSwapItem', canSwapItem)


getPlayerInventory = function(xPlayer, minimal)
	if Inventories[xPlayer.source] then
		if minimal then
			local inventory = {}
			for k, v in pairs(Inventories[xPlayer.source].inventory) do
				if v.count > 0 then
					local metadata = v.metadata
					if v.metadata and next(v.metadata) == nil then metadata = nil end
					inventory[#inventory+1] = {
						name = v.name,
						count = v.count,
						slot = k,
						metadata = metadata
					}
				end
			end
			return inventory
		end
		return Inventories[xPlayer.source].inventory
	end
end
exports('getPlayerInventory', getPlayerInventory)


getPlayerSlot = function(xPlayer, slot, item, metadata)
	if CheckPlayer(xPlayer) ~= true then return end
	if slot > Config.PlayerSlots then return nil end
	local getSlot = Inventories[xPlayer.source].inventory[slot]
	if item and getSlot and getSlot.name ~= item then slot = nil end
	if slot and metadata and not func.matchtables(getSlot.metadata, metadata) then slot = nil end
	if getSlot then return getSlot end return {}
end
exports('getPlayerSlot', getPlayerSlot)


getInventoryItemSlots = function(xPlayer, name, metadata)
	if CheckPlayer(xPlayer) ~= true then return end
	local xItem = Items[name]
	if not xItem then print(('^1[error]^7 %s does not exist'):format(name)) return end
	local totalCount, slots, emptySlots = 0, {}, Config.PlayerSlots
	for k, v in pairs(Inventories[xPlayer.source].inventory) do
		emptySlots = emptySlots - 1
		if v.name == name then
			if metadata and not v.metadata then v.metadata = {} end
			if not metadata or func.matchtables(v.metadata, metadata) then
				totalCount = totalCount + v.count
				slots[k] = v.count
			end
		end
	end
	return slots, totalCount, emptySlots
end
exports('getInventoryItemSlots', getInventoryItemSlots)
