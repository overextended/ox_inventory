local playerDropped = ...
local Inventory

CreateThread(function()
	Inventory = server.inventory
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
		Inventory.AddItem(Player.PlayerData.source, item, amount, info, slot)
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, "RemoveItem", function(item, amount, slot)
		Inventory.RemoveItem(Player.PlayerData.source, item, amount, nil, slot)
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
