setAccountMoney = function(xPlayer, accountName, money)
	if money >= 0 then
		local account = xPlayer.getAccount(accountName)
		if account then
			local prevMoney = account.money
			local newMoney = ESX.Math.Round(money)
			account.money = newMoney

			xPlayer.triggerEvent('esx:setAccountMoney', account)
			if accountName:find('money') then setInventoryItem(xPlayer, accountName, money) end
		end
	end
end
exports('setAccountMoney', setAccountMoney)


addAccountMoney = function(xPlayer, accountName, money)
	if money > 0 then
		local account = xPlayer.getAccount(accountName)
		if account then
			local newMoney = account.money + ESX.Math.Round(money)
			account.money = newMoney

			xPlayer.triggerEvent('esx:setAccountMoney', account)
			if accountName:find('money') then addInventoryItem(xPlayer, accountName, money) end
		end
	end
end
exports('addAccountMoney', addAccountMoney)


removeAccountMoney = function(xPlayer, accountName, money)
	if money > 0 then
		local account = xPlayer.getAccount(accountName)
		if account then
			local newMoney = account.money - ESX.Math.Round(money)
			account.money = newMoney

			xPlayer.triggerEvent('esx:setAccountMoney', account)
			if accountName:find('money') then removeInventoryItem(xPlayer, accountName, money) end
		end
	end
end
exports('removeAccountMoney', removeAccountMoney)


getInventoryItem = function(xPlayer, name, metadata)
	local xItem = Items[name]
	if not xItem then print(('^1[error]^7 %s does not exist'):format(name)) return end
	metadata = setMetadata(metadata)
	xItem.count = 0
	for k, v in ipairs(Inventories['Player-'..xPlayer.source].inventory) do
		if v.name == name then
			if not v.metadata then v.metadata = {} end
			if is_table_equal(v.metadata, metadata) then
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


removeInventoryItem = function(xPlayer, name, count, metadata)
	local item = getInventoryItem(xPlayer, name)
	if item and count > 0 then
		count = ESX.Math.Round(count)
		local newCount = item.count - count

		if newCount >= 0 then
			RemovePlayerInventory(xPlayer, item.name, count, slot, metadata)
		end
	end
end
exports('removeInventoryItem', removeInventoryItem)


setInventoryItem = function(xPlayer, name, count, metadata)
	local item = getInventoryItem(xPlayer, name)
	if item and count > 0 then
		count = ESX.Math.Round(count)
		if count > item.count then
			AddPlayerInventory(xPlayer, item.name, count, metadata, slot)
		else
			RemovePlayerInventory(xPlayer, item.name, count, metadata, slot)
		end
	end
end
exports('setInventoryItem', setInventoryItem)


updateWeight = function(xPlayer)
	Inventories['Player-'..xPlayer.source].weight = getWeight(xPlayer)
end


getWeight = function(xPlayer)
	local weight = 0
	if Inventories['Player-'..xPlayer.source] then
		for k, v in ipairs(Inventories['Player-'..xPlayer.source].inventory) do
			weight = weight + (v.weight * v.count)
		end
	end
	return weight
end
exports('getWeight', getWeight)


getMaxWeight = function(xPlayer)
	return Inventories['Player-'..xPlayer.source].maxWeight
end
exports('getMaxWeight', getMaxWeight)


setMaxWeight = function(xPlayer, newWeight)
	Inventories['Player-'..xPlayer.source].maxWeight = newWeight
end
exports('setMaxWeight', setMaxWeight)


canCarryItem = function(xPlayer, name, count)
	local xItem = Items[name]
	if xItem then
		if count == nil then count = 1 end
		local curWeight, itemWeight = Inventories['Player-'..xPlayer.source].weight, xItem.weight
		local newWeight = curWeight + (itemWeight * count)
		return newWeight <= Inventories['Player-'..xPlayer.source].maxWeight
	end
	return false
end
exports('canCarryItem', canCarryItem)


canSwapItem = function(firstItem, firstItemCount, testItem, testItemCount)
	local curWeight = Inventories['Player-'..xPlayer.source].weight
	local firstItemObject = getInventoryItem(xPlayer, firstItem)
	if firstItemObject.count >= firstItemCount then
		local weightWithoutFirstItem = curWeight - (firstItemObject.weight * firstItemCount)
		local weightWithTestItem = weightWithoutFirstItem + (testItemObject.weight * testItemCount)
		return weightWithTestItem <= Inventories['Player-'..xPlayer.source].maxWeight
	end
	return false
end
exports('canSwapItem', canSwapItem)


getPlayerInventory = function(xPlayer)
	local inventory = Inventories['Player-'..xPlayer.source] or {}
	return getInventory(inventory)
end
exports('getPlayerInventory', getPlayerInventory)


getPlayerSlot = function(xPlayer, slot)
	if slot > Config.PlayerSlots then return nil end
	local getSlot = Inventories['Player-'..xPlayer.source].inventory[slot]
	if getSlot and getSlot.name ~= item then slot = nil end
	return slot
end
exports('getPlayerSlot', getPlayerSlot)


getInventoryItemSlots = function(xPlayer, name, metadata)
	local xItem = Items[name]
	if not xItem then print(('^1[error]^7 %s does not exist'):format(name)) return end
	xItem.count = 0
	for k, v in ipairs(Inventories['Player-'..xPlayer.source].inventory) do
		if v.name == name then
			if not v.metadata then v.metadata = {} end
			if is_table_equal(v.metadata, metadata) then
				xItem.total = xItem.count + v.count
				xItem.slot = { [v.slot] = v.count }
			end
		end
	end
	return xItem
end
exports('getInventoryItemSlots', getInventoryItemSlots)
