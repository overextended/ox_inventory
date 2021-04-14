getInventoryItem = function(xPlayer, name, metadata)
	local xItem = Items[name]
	if not xItem then print(('^1[error]^7 %s does not exist'):format(name)) return end
	xItem.count = 0
	xItem.metadata = setMetadata(metadata)
	for k, v in pairs(Inventories[xPlayer.source].inventory) do
		if v.name == name then
			if not v.metadata then v.metadata = {} end
			if is_table_equal(v.metadata, xItem.metadata) then
				xItem.count = xItem.count + v.count
			end
		end
	end
	return xItem
end
exports('getInventoryItem', getInventoryItem)


addInventoryItem = function(xPlayer, name, count, metadata, slot)
	if Items[name] and count > 0 then
		count = ESX.Math.Round(count)
		AddPlayerInventory(xPlayer, name, count, slot, metadata)
	end
end
exports('addInventoryItem', addInventoryItem)


removeInventoryItem = function(xPlayer, name, count, metadata, slot)
	local item = getInventoryItem(xPlayer, name)
	if item and count > 0 then
		count = ESX.Math.Round(count)
		if count > item.count then count = item.count end
		RemovePlayerInventory(xPlayer, item.name, count, slot, metadata)
	end
end
exports('removeInventoryItem', removeInventoryItem)


setInventoryItem = function(xPlayer, name, count, metadata)
	local item = getInventoryItem(xPlayer, name)
	if item and count >= 0 then
		count = ESX.Math.Round(count)
		if count > item.count then
			count = count - item.count
			AddPlayerInventory(xPlayer, item.name, count, false, metadata)
		else
			count = item.count - count
			RemovePlayerInventory(xPlayer, item.name, count, false, metadata)
		end
	end
end
exports('setInventoryItem', setInventoryItem)


updateWeight = function(xPlayer)
	Inventories[xPlayer.source].weight = getWeight(xPlayer)
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


canSwapItem = function(firstItem, firstItemCount, testItem, testItemCount)
	local curWeight = Inventories[xPlayer.source].weight
	local firstItemObject = getInventoryItem(xPlayer, firstItem)
	if firstItemObject.count >= firstItemCount then
		local weightWithoutFirstItem = curWeight - (firstItemObject.weight * firstItemCount)
		local weightWithTestItem = weightWithoutFirstItem + (testItemObject.weight * testItemCount)
		return weightWithTestItem <= Inventories[xPlayer.source].maxWeight
	end
	return false
end
exports('canSwapItem', canSwapItem)


getPlayerInventory = function(xPlayer, minimal)
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
exports('getPlayerInventory', getPlayerInventory)


getPlayerSlot = function(xPlayer, slot, item, metadata)
	if slot > Config.PlayerSlots then return nil end
	local getSlot = Inventories[xPlayer.source].inventory[slot]
	if item and getSlot and getSlot.name ~= item then slot = nil end
	if slot and metadata and not is_table_equal(getSlot.metadata, metadata) then slot = nil end
	if getSlot then return getSlot end return {}
end
exports('getPlayerSlot', getPlayerSlot)


getInventoryItemSlots = function(xPlayer, name, metadata)
	local xItem = Items[name]
	if not xItem then print(('^1[error]^7 %s does not exist'):format(name)) return end
	local totalCount, slots, emptySlots = 0, {}, Config.PlayerSlots
	for k, v in pairs(Inventories[xPlayer.source].inventory) do
		emptySlots = emptySlots - 1
		if v.name == name then
			if not v.metadata then v.metadata = {} end
			if is_table_equal(v.metadata, metadata) then
				totalCount = totalCount + v.count
				slots[k] = v.count
			end
		end
	end
	return slots, totalCount, emptySlots
end
exports('getInventoryItemSlots', getInventoryItemSlots)
