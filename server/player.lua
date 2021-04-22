checkPlayer = function(xPlayer)
	if xPlayer.get('linventory') ~= true then Citizen.Wait(1500) count = 0 while true do if count > 3 then return false end Citizen.Wait(1000) end count = count + 1 else return true end
end

getInventoryItem = function(xPlayer, name, metadata)
	if checkPlayer(xPlayer) ~= true then return end
	if name then
		local xItem = Items[name]
		if not xItem then print(('^1[error]^7 %s does not exist'):format(name)) return end
		xItem.count = 0
		for k, v in pairs(Inventories[xPlayer.source].inventory) do
			if v.name == name then
				if not v.metadata then v.metadata = {} end
				if not metadata or is_table_equal(v.metadata, metadata) then
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
	if checkPlayer(xPlayer) ~= true then return end
	local xItem = Items[item]
	if xPlayer and xItem and count > 0 then
		if metadata == 'setname' then metadata = {description = xPlayer.getName()} else metadata = setMetadata(metadata) end
		local toSlot, existing
		if slot then slot = getPlayerSlot(xPlayer, slot, item, metadata).slot
		else
			for i=1, Config.PlayerSlots do
				if xItem.stackable and Inventories[xPlayer.source].inventory[i] and Inventories[xPlayer.source].inventory[i].name == item and is_table_equal(Inventories[xPlayer.source].inventory[i].metadata, metadata) then toSlot = i existing = true break
				elseif not toSlot and Inventories[xPlayer.source].inventory[i] == nil then toSlot = i existing = false end
			end
			slot = toSlot
		end
		if item:find('WEAPON_') then
			xItem.stackable = false
			if Config.Throwable[item] then
				metadata = {throwable=1}
				xItem.stackable = true
			elseif Config.Melee[item] or Config.Miscellaneous[item] then
				count = 1
				metadata = {}
				if not metadata.durability then metadata.durability = 100 end
			else
				count = 1
				if type(metadata) ~= 'table' then metadata = {} end
				if not metadata.durability then metadata.durability = 100 end
				if xItem.ammoType then metadata.ammo = 0 end
				if not metadata.components then metadata.components = {} end
				metadata.serial = GenerateSerial(metadata.serial)
				if metadata.registered == true then metadata.registered = xPlayer.getName() end
			end
			Inventories[xPlayer.source].inventory[slot] = {name = item, label = xItem.label, weight = xItem.weight, slot = slot, count = count, description = xItem.description, metadata = metadata, stackable = xItem.stackable, closeonuse = true}
			if xItem.ammoType then Inventories[xPlayer.source].inventory[slot].ammoType = xItem.ammoType end
			if xItem.weight > 0 or xItem.name:find('money') then updateWeight(xPlayer) end
			ItemNotify(xPlayer, Inventories[xPlayer.source].inventory[slot], count, slot, 'Added')
		elseif item:find('identification') then
			count = 1
			if next(metadata) == nil then
				metadata = {}
				metadata.type = xPlayer.getName()
				metadata.description = GetPlayerIdentification(xPlayer)
			end
			local added = count
			if existing then count = Inventories[xPlayer.source].inventory[slot].count + count end
			Inventories[xPlayer.source].inventory[slot] = {name = item, label = xItem.label, weight = xItem.weight, slot = slot, count = count, description = xItem.description, metadata = metadata, stackable = xItem.stackable, closeonuse = true}
			if xItem.weight > 0 or xItem.name:find('money') then updateWeight(xPlayer) end
			ItemNotify(xPlayer, Inventories[xPlayer.source].inventory[slot], added, slot, 'Added')
		elseif slot then
			local added = count
			if existing then count = Inventories[xPlayer.source].inventory[slot].count + count end
			Inventories[xPlayer.source].inventory[slot] = {name = item, label = xItem.label, weight = xItem.weight, slot = slot, count = count, description = xItem.description, metadata = metadata or {}, stackable = xItem.stackable, closeonuse = xItem.closeonuse}
			if xItem.weight > 0 or xItem.name:find('money') then updateWeight(xPlayer) end
			ItemNotify(xPlayer, Inventories[xPlayer.source].inventory[slot], added, slot, 'Added')
		end
		if slot then TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source]) end
	end
end
exports('addInventoryItem', addInventoryItem)


removeInventoryItem = function(xPlayer, item, count, metadata, slot)
	if checkPlayer(xPlayer) ~= true then return end
	local xItem = Items[item]
	if xPlayer and xItem and count > 0 then
		if metadata then metadata = setMetadata(metadata) end
		if slot and Inventories[xPlayer.source].inventory[slot].count == count and Inventories[xPlayer.source].inventory[slot].name == xItem.name then
			ItemNotify(xPlayer, Inventories[xPlayer.source].inventory[slot], count, slot, 'Removed')
			Inventories[xPlayer.source].inventory[slot] = nil
			if xItem.weight > 0 or xItem.name:find('money') then updateWeight(xPlayer) end
			TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source])
		elseif slot and Inventories[xPlayer.source].inventory[slot].count > count and Inventories[xPlayer.source].inventory[slot].name == xItem.name then
			local newCount = Inventories[xPlayer.source].inventory[slot].count - count
			ItemNotify(xPlayer, Inventories[xPlayer.source].inventory[slot], count, slot, 'Removed')
			Inventories[xPlayer.source].inventory[slot] = {name = item, label = xItem.label, weight = xItem.weight, slot = slot, count = newCount, description = xItem.description, metadata = metadata, stackable = xItem.stackable, closeonuse = xItem.closeonuse}
			if xItem.weight > 0 or xItem.name:find('money') then updateWeight(xPlayer) end
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
							Inventories[xPlayer.source].inventory[k] = {name = item, label = xItem.label, weight = xItem.weight, slot = k, count = count, description = xItem.description, metadata = metadata, stackable = xItem.stackable, closeonuse = xItem.closeonuse}
						else -- v < count
							removed = v
							count = count - v
							Inventories[xPlayer.source].inventory[k] = nil
						end
					end
				end
				if xItem.weight > 0 or xItem.name:find('money') then updateWeight(xPlayer) end
				ItemNotify(xPlayer, xItem, removed, itemSlots, 'Removed')
				TriggerClientEvent('linden_inventory:refreshInventory', xPlayer.source, Inventories[xPlayer.source])
			end
		end
	end
end
exports('removeInventoryItem', removeInventoryItem)


setInventoryItem = function(xPlayer, name, count, metadata)
	if checkPlayer(xPlayer) ~= true then return end
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


updateWeight = function(xPlayer, force)
	local newWeight = getWeight(xPlayer)
	if force or newWeight ~= Inventories[xPlayer.source].weight then
		Inventories[xPlayer.source].weight = newWeight
		TriggerClientEvent('linden_inventory:updateStorage', xPlayer.source, {newWeight, Inventories[xPlayer.source].maxWeight, Inventories[xPlayer.source].slots})
	end
	SyncAccounts(xPlayer, 'money')
	SyncAccounts(xPlayer, 'black_money')
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
	if not Inventories[xPlayer.source] then return Config.PlayerWeight
	else return Inventories[xPlayer.source].maxWeight end
end
exports('getMaxWeight', getMaxWeight)


setMaxWeight = function(xPlayer, newWeight)
	Inventories[xPlayer.source].maxWeight = newWeight
end
exports('setMaxWeight', setMaxWeight)


canCarryItem = function(xPlayer, name, count, metadata)
	if checkPlayer(xPlayer) ~= true then return end
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
	if checkPlayer(xPlayer) ~= true then return end
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
		local inventory = {}
		for k, v in pairs(Inventories[xPlayer.source].inventory) do
			if v.count > 0 then
				if minimal and v.metadata and next(v.metadata) == nil then v.metadata = nil end
				inventory[#inventory+1] = {
					name = v.name,
					count = v.count,
					slot = k,
					metadata = v.metadata
				}
			end
		end
		return inventory
	end
end
exports('getPlayerInventory', getPlayerInventory)


getPlayerSlot = function(xPlayer, slot, item, metadata)
	if checkPlayer(xPlayer) ~= true then return end
	if slot > Config.PlayerSlots then return nil end
	local getSlot = Inventories[xPlayer.source].inventory[slot]
	if item and getSlot and getSlot.name ~= item then slot = nil end
	if slot and metadata and not is_table_equal(getSlot.metadata, metadata) then slot = nil end
	if getSlot then return getSlot end return {}
end
exports('getPlayerSlot', getPlayerSlot)


getInventoryItemSlots = function(xPlayer, name, metadata)
	if checkPlayer(xPlayer) ~= true then return end
	local xItem = Items[name]
	if not xItem then print(('^1[error]^7 %s does not exist'):format(name)) return end
	local totalCount, slots, emptySlots = 0, {}, Config.PlayerSlots
	for k, v in pairs(Inventories[xPlayer.source].inventory) do
		emptySlots = emptySlots - 1
		if v.name == name then
			if metadata and not v.metadata then v.metadata = {} end
			if not metadata or is_table_equal(v.metadata, metadata) then
				totalCount = totalCount + v.count
				slots[k] = v.count
			end
		end
	end
	return slots, totalCount, emptySlots
end
exports('getInventoryItemSlots', getInventoryItemSlots)
