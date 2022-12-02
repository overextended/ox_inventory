local playerDropped = ...
local Inventory, Items

CreateThread(function()
	Inventory = server.inventory
	Items = server.items
end)

local QBCore

AddEventHandler('QBCore:Server:OnPlayerUnload', playerDropped)

AddEventHandler('QBCore:Server:OnJobUpdate', function(source, job)
	local inventory = Inventory(source)
	if not inventory then return end
	inventory.player.groups[inventory.player.job] = nil
	inventory.player.job = job.name
	inventory.player.groups[job.name] = job.grade.level
end)

AddEventHandler('QBCore:Server:OnGangUpdate', function(source, gang)
	local inventory = Inventory(source)
	if not inventory then return end
	inventory.player.groups[inventory.player.gang] = nil
	inventory.player.gang = gang.name
	inventory.player.groups[gang.name] = gang.grade.level
end)

AddEventHandler('onResourceStart', function(resource)
	if resource ~= 'qb-weapons' or resource ~= 'qb-shops' then return end
	StopResource(resource)
end)

local function setupPlayer(Player)
	QBCore.Functions.AddPlayerField(Player.PlayerData.source, 'syncInventory', function(_, _, items, money)
		Player.Functions.SetPlayerData('items', items)

		if money.money then
			Player.Functions.SetMoney('cash', money.money, "Sync money with inventory")
		end
	end)

	Player.PlayerData.inventory = Player.PlayerData.items
	Player.PlayerData.identifier = Player.PlayerData.citizenid

	server.setPlayerInventory(Player.PlayerData)

	Inventory.SetItem(Player.PlayerData.source, 'money', Player.PlayerData.money.cash)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, "AddItem", function(item, amount, slot, info)
		return Inventory.AddItem(Player.PlayerData.source, item, amount, info, slot)
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, "RemoveItem", function(item, amount, slot)
		return Inventory.RemoveItem(Player.PlayerData.source, item, amount, nil, slot)
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, "GetItemBySlot", function(slot)
		return Inventory.GetSlot(Player.PlayerData.source, slot)
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, "GetItemByName", function(item)
		return Inventory.GetItem(Player.PlayerData.source, item, nil, false)
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, "GetItemsByName", function(item)
		return Inventory.Search(Player.PlayerData.source, 'slots', item)
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, "ClearInventory", function(filterItems)
		Inventory.Clear(Player.PlayerData.source, filterItems)
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, "SetInventory", function()
		-- ox_inventory's item structure is not compatible with qb-inventory's one so we don't support it
		shared.info('Player.Functions.SetInventory is unsupported for ox_inventory, please use exports.ox_inventory:setPlayerInventory instead.')
	end)
end

AddEventHandler('QBCore:Server:PlayerLoaded', setupPlayer)

SetTimeout(500, function()
	QBCore = exports['qb-core']:GetCoreObject()
	server.GetPlayerFromId = QBCore.Functions.GetPlayer
	local weapState = GetResourceState('qb-weapons')

	if weapState ~= 'missing' and (weapState == 'started' or weapState == 'starting') then
		StopResource('qb-weapons')
	end

	local shopState = GetResourceState('qb-shops')

	if shopState ~= 'missing' and (shopState == 'started' or shopState == 'starting') then
		StopResource('qb-shops')
	end

	for _, Player in pairs(QBCore.Functions.GetQBPlayers()) do setupPlayer(Player) end
end)

-- Accounts that need to be synced with physical items
server.accounts = {
	money = 0
}

function server.UseItem(source, itemName, data)
	local cb = QBCore.Functions.CanUseItem(itemName)
	return cb and cb(source, data)
end

AddEventHandler('QBCore:Server:OnMoneyChange', function(src, account, amount, changeType)
	if account ~= "cash" then return end
	local item = Inventory.GetItem(src, 'money', nil, false)
	Inventory.SetItem(src, 'money', changeType == "set" and amount or changeType == "remove" and item.count - amount or changeType == "add" and item.count + amount)
end)

function server.setPlayerData(player)
	local groups = {
		[player.job.name] = player.job.grade.level,
		[player.gang.name] = player.gang.grade.level
	}

	return {
		source = player.source,
		name = ('%s %s'):format(player.charinfo.firstname, player.charinfo.lastname),
		groups = groups,
		sex = player.charinfo.gender,
		dateofbirth = player.charinfo.birthdate,
		job = player.job.name,
		gang = player.gang.name,
	}
end

function server.syncInventory(inv)
	local money = table.clone(server.accounts)

	for _, v in pairs(inv.items) do
		if money[v.name] then
			money[v.name] += v.count
		end
	end

	local player = server.GetPlayerFromId(inv.id)
	player.syncInventory(inv.weight, inv.maxWeight, inv.items, money)
end

function server.hasLicense(inv, license)
	local player = server.GetPlayerFromId(inv.id)
	return player and player.PlayerData.metadata.licences[license]
end

function server.buyLicense(inv, license)
	local player = server.GetPlayerFromId(inv.id)
	if not player then return end

	if player.PlayerData.metadata.licences[license] then
		return false, 'has_weapon_license'
	elseif Inventory.GetItem(inv, 'money', false, true) < license.price then
		return false, 'poor_weapon_license'
	end

	Inventory.RemoveItem(inv, 'money', license.price)
	player.PlayerData.metadata.licences.weapon = true
	player.Functions.SetMetaData('licences', player.PlayerData.metadata.licences)

	return true, 'bought_weapon_license'
end

--- Takes traditional item data and updates it to support ox_inventory, i.e.
--- ```
--- Old: {1:{"name": "cola", "amount": 1, "label": "Cola", "slot": 1}, 2:{"name": "burger", "amount": 3, "label": "Burger", "slot": 2}}
--- New: [{"slot":1,"name":"cola","count":1}, {"slot":2,"name":"burger","count":3}]
---```
function server.convertInventory(playerId, items)
	if type(items) == 'table' then
		local player = server.GetPlayerFromId(playerId)
		local returnData, totalWeight = table.create(#items, 0), 0
		local slot = 0

		if player then
			for name in pairs(server.accounts) do
				local hasThis = false
				for _, data in pairs(items) do
					if data.name == name then
						hasThis = true
					end
				end

				if not hasThis then
					local amount = player.Functions.GetMoney(name == 'money' and 'cash' or name)

					if amount then
						items[#items + 1] = { name = name, amount = amount }
					end
				end
			end
		end

		for _, data in pairs(items) do
			local item = Items(data.name)

			if item?.name then
				local metadata, count = Items.Metadata(playerId, item, data.info, data.amount or data.count or 1)
				local weight = Inventory.SlotWeight(item, {count = count, metadata = metadata})
				totalWeight += weight
				slot += 1
				returnData[slot] = {name = item.name, label = item.label, weight = weight, slot = slot, count = count, description = item.description, metadata = metadata, stack = item.stack, close = item.close}
			end
		end

		return returnData, totalWeight
	end
end

function server.setPlayerStatus(playerId, values)
	local Player = QBCore.Functions.GetPlayer(playerId)

	if not Player then return end

	local playerMetadata = player.PlayerData.metadata

	for name, value in pairs(values) do
		if playerMetadata[name] then
			if value > 100 or value < 100 then value *= 0.0001 end

			Player.Functions.SetMetaData(name, playerMetadata[name] + value)
		end
	end
end

