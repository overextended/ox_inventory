local playerDropped = ...
local Inventory = require 'modules.inventory.server'
local Items = require 'modules.items.server'

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

---@param item SlotWithItem?
---@return SlotWithItem?
local function setItemCompatibilityProps(item)
	if not item then return end

	item.info = item.metadata
	item.amount = item.count

	return item
end

local function setupPlayer(Player)
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
		return setItemCompatibilityProps(Inventory.GetSlot(Player.PlayerData.source, slot))
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, "GetItemByName", function(itemName)
		return setItemCompatibilityProps(Inventory.GetSlotWithItem(Player.PlayerData.source, itemName))
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, "GetItemsByName", function(itemName)
		return setItemCompatibilityProps(Inventory.GetSlotsWithItem(Player.PlayerData.source, itemName))
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, "ClearInventory", function(filterItems)
		Inventory.Clear(Player.PlayerData.source, filterItems)
	end)

	QBCore.Functions.AddPlayerMethod(Player.PlayerData.source, "SetInventory", function()
		-- ox_inventory's item structure is not compatible with qb-inventory's one so we don't support it
		error('Player.Functions.SetInventory is unsupported for ox_inventory. Try ClearInventory, then add the desired items.')
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

function server.UseItem(source, itemName, data)
	local cb = QBCore.Functions.CanUseItem(itemName)
	return cb and cb(source, data)
end

AddEventHandler('QBCore:Server:OnMoneyChange', function(src, account, amount, changeType)
	if account ~= "cash" then return end

	local item = Inventory.GetItem(src, 'money', nil, false)

    if not item then return end

	Inventory.SetItem(src, 'money', changeType == "set" and amount or changeType == "remove" and item.count - amount or changeType == "add" and item.count + amount)
end)

---@diagnostic disable-next-line: duplicate-set-field
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

---@diagnostic disable-next-line: duplicate-set-field
function server.syncInventory(inv)
	local accounts = Inventory.GetAccountItemCounts(inv)

    if accounts then
        local player = server.GetPlayerFromId(inv.id)
        player.Functions.SetPlayerData('items', inv.items)

        if accounts.money and accounts.money ~= player.Functions.GetMoney('cash') then
			player.Functions.SetMoney('cash', accounts.money, "Sync money with inventory")
		end
	end
end

---@diagnostic disable-next-line: duplicate-set-field
function server.hasLicense(inv, license)
	local player = server.GetPlayerFromId(inv.id)
	return player and player.PlayerData.metadata.licences[license]
end

---@diagnostic disable-next-line: duplicate-set-field
function server.buyLicense(inv, license)
	local player = server.GetPlayerFromId(inv.id)
	if not player then return end

	if player.PlayerData.metadata.licences[license.name] then
		return false, 'already_have'
	elseif Inventory.GetItem(inv, 'money', false, true) < license.price then
		return false, 'can_not_afford'
	end

	Inventory.RemoveItem(inv, 'money', license.price)
	player.PlayerData.metadata.licences[license.name] = true
	player.Functions.SetMetaData('licences', player.PlayerData.metadata.licences)

	return true, 'have_purchased'
end

--- Takes traditional item data and updates it to support ox_inventory, i.e.
--- ```
--- Old: {1:{"name": "cola", "amount": 1, "label": "Cola", "slot": 1}, 2:{"name": "burger", "amount": 3, "label": "Burger", "slot": 2}}
--- New: [{"slot":1,"name":"cola","count":1}, {"slot":2,"name":"burger","count":3}]
---```
---@diagnostic disable-next-line: duplicate-set-field
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

---@diagnostic disable-next-line: duplicate-set-field
function server.isPlayerBoss(playerId)
	local Player = QBCore.Functions.GetPlayer(playerId)

	return Player.PlayerData.job.isboss or Player.PlayerData.gang.isboss
end

-- taken from qbox-core (https://github.com/Qbox-project/qb-core/blob/f4174f311aae8157181a48fa2e2bd30c8d13edb1/client/functions.lua#L25)
-- copied from client-side implementation and completely untested (have fun)
local function hasItem(source, items, amount)
    amount = amount or 1

    local count = Inventory.Search(source, 'count', items)

    if type(items) == 'table' and type(count) == 'table' then
        for _, v in pairs(count) do
            if v < amount then
                return false
            end
        end

        return true
    end

    return count >= amount
end

local function exportHandler(exportName, func)
    AddEventHandler(('__cfx_export_qb-inventory_%s'):format(exportName), function(setCB)
        setCB(func)
    end)
end

exportHandler('HasItem', hasItem)
