function server.hasGroup(inv, group)
	if type(group) == 'table' then
		for name, rank in pairs(group) do
			local groupRank = inv.player.groups[name]
			if groupRank and groupRank >= (rank or 0) then
				return name, groupRank
			end
		end
	else
		local groupRank = inv.player.groups[group]
		if groupRank then
			return group, groupRank
		end
	end
end

function server.setPlayerData(player)
	if not player.groups then
		shared.warning(("server.setPlayerData did not receive any groups for '%s'"):format(player?.name or GetPlayerName(player)))
	end

	return {
		source = player.source,
		name = player.name,
		groups = player.groups or {},
		sex = player.sex,
		dateofbirth = player.dateofbirth,
	}
end

function server.buyLicense()
	shared.warning('Licenses are not yet supported without esx or qb. Available soon™.')
end

local Inventory
local Items

SetTimeout(0, function()
	Inventory = server.inventory
	Items = server.items
end)

local function playerDropped(source)
	local inv = Inventory(source)

	if inv then
		local openInventory = inv.open and Inventories[inv.open]

		if openInventory then
			openInventory:set('open', false)
		end

		if shared.framework ~= 'esx' then
			db.savePlayer(inv.owner, json.encode(inv:minimal()))
		end

		Inventory.Remove(source)
	end
end

if shared.framework == 'ox' then
	AddEventHandler('ox:playerLogout', playerDropped)

	AddEventHandler('ox:setGroup', function(source, name, grade)
		local inventory = Inventory(source)
		if not inventory then return end
		inventory.player.groups[name] = grade
	end)
elseif shared.framework == 'esx' then
	local ESX

	AddEventHandler('esx:playerDropped', playerDropped)

	AddEventHandler('esx:setJob', function(source, job)
		local inventory = Inventory(source)
		if not inventory then return end
		inventory.player.groups[job.name] = job.grade
	end)

	SetTimeout(4000, function()
		ESX = exports.es_extended:getSharedObject()

		if ESX.CreatePickup then
			error('ox_inventory requires a ESX Legacy v1.6.0 or above, refer to the documentation.')
		end

		server.UseItem = ESX.UseItem
		server.GetPlayerFromId = ESX.GetPlayerFromId
		server.UsableItemsCallbacks = ESX.GetUsableItems()

		for _, player in pairs(ESX.Players) do
			server.setPlayerInventory(player, player?.inventory)
		end
	end)

	-- Accounts that need to be synced with physical items
	server.accounts = {
		money = 0,
		black_money = 0,
	}

	function server.setPlayerData(player)
		local groups = {
			[player.job.name] = player.job.grade
		}

		return {
			source = player.source,
			name = player.name,
			groups = groups,
			sex = player.sex or player.variables.sex,
			dateofbirth = player.dateofbirth or player.variables.dateofbirth,
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

	function server.buyLicense(inv, license)
		if db.selectLicense(license.name, inv.owner) then
			return false, 'has_weapon_license'
		elseif Inventory.GetItem(inv, 'money', false, true) < license.price then
			return false, 'poor_weapon_license'
		end

		Inventory.RemoveItem(inv, 'money', license.price)
		TriggerEvent('esx_license:addLicense', source, 'weapon')

		return true, 'bought_weapon_license'
	end

	--- Takes traditional item data and updates it to support ox_inventory, i.e.
	--- ```
	--- Old: {"cola":1, "burger":3}
	--- New: [{"slot":1,"name":"cola","count":1}, {"slot":2,"name":"burger","count":3}]
	---```
	function server.convertInventory(playerId, items)
		if type(items) == 'table' then
			local returnData, totalWeight = table.create(#items, 0), 0
			local slot = 0

			for name, count in pairs(items) do
				local item = Items(name)

				if item then
					local metadata = Items.Metadata(playerId, item, false, count)
					local weight = Inventory.SlotWeight(item, {count=count, metadata=metadata})
					totalWeight = totalWeight + weight
					slot += 1
					returnData[slot] = {name = item.name, label = item.label, weight = weight, slot = slot, count = count, description = item.description, metadata = metadata, stack = item.stack, close = item.close}
				end
			end

			return returnData, totalWeight
		end
	end
elseif shared.framework == 'qb' then
	local QBCore = exports['qb-core']:GetCoreObject()

	AddEventHandler('QBCore:Server:OnPlayerUnload', playerDropped)

	AddEventHandler('QBCore:Server:OnJobUpdate', function(source, job)
		local inventory = Inventories[source]
		if not inventory then return end
		inventory.player.groups[job.name] = job.grade.level
	end)

	AddEventHandler('QBCore:Server:OnGangUpdate', function(source, gang)
		local inventory = Inventories[source]
		if not inventory then return end
		inventory.player.groups[gang.name] = gang.grade.level
	end)

	AddEventHandler('onResourceStart', function(resource)
		if resource ~= 'qb-weapons' or resource ~= 'qb-shops' then return end
		StopResource(resource)
	end)

	SetTimeout(4000, function()
		local qbPlayers = QBCore.Functions.GetQBPlayers()
		for _, Player in pairs(qbPlayers) do
			if Player then
				QBCore.Functions.AddPlayerField(Player.PlayerData.source, 'syncInventory', function(_, _, items, money)
					Player.Functions.SetPlayerData('items', items)
					Player.Functions.SetPlayerData('inventory', items)

					if money.money then Player.Functions.SetMoney('cash', money.money, "Sync money with inventory") end
				end)

				Player.Functions.SetPlayerData('inventory', Player.PlayerData.items)
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
		end

		local weapState = GetResourceState('qb-weapons')
		if  weapState ~= 'missing' and (weapState == 'started' or weapState == 'starting') then
			StopResource('qb-weapons')
		end

		local shopState = GetResourceState('qb-shops')
		if  shopState ~= 'missing' and (shopState == 'started' or shopState == 'starting') then
			StopResource('qb-shops')
		end
	end)

	local itemCallbacks = {}

	-- Accounts that need to be synced with physical items
	server.accounts = {
		money = 0
	}

	QBCore.Functions.SetMethod('CreateUseableItem', function(item, cb)
		itemCallbacks[item] = cb
	end)

	function server.UseItem(source, itemName, ...)
		local callback = type(itemCallbacks[itemName]) == 'function' and itemCallbacks[itemName] or type(itemCallbacks[itemName]) == 'table' and (rawget(itemCallbacks[itemName], '__cfx_functionReference') and itemCallbacks[itemName] or itemCallbacks[itemName].cb or itemCallbacks[itemName].callback)

		if not callback then return end

		callback(source, itemName, ...)
	end

	AddEventHandler('QBCore:Server:OnMoneyChange', function(src, account, amount)
		if account ~= "cash" then return end
		Inventory.SetItem(src, 'money', amount)
	end)

	AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
		QBCore.Functions.AddPlayerField(Player.PlayerData.source, 'syncInventory', function(_, _, items, money)
			Player.Functions.SetPlayerData('items', items)
			Player.Functions.SetPlayerData('inventory', items)

			if money.money then Player.Functions.SetMoney('cash', money.money, "Sync money with inventory") end
		end)

		Player.Functions.SetPlayerData('inventory', Player.PlayerData.items)
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
	end)

	local usableItems = {}

	for k, v in pairs(QBCore.Shared.Items) do
		if v.useable then usableItems[k] = true end
	end

	server.UsableItemsCallbacks = usableItems
	server.GetPlayerFromId = QBCore.Functions.GetPlayer

	function server.setPlayerData(player)
		local groups = {
			[player.job.name] = player.job.grade.level,
			[player.gang.name] = player.gang.grade.level
		}

		return {
			source = player.source,
			name = player.name,
			groups = groups,
			sex = player.charinfo.gender,
			dateofbirth = player.charinfo.birthdate,
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

	function server.buyLicense(inv, license)
		local player = server.GetPlayerFromId(source)
		if not player then return end

		if player.PlayerData.metadata.licences.weapon then
			return false, 'has_weapon_license'
		elseif Inventory.GetItem(inv, 'money', false, true) < license.price then
			return false, 'poor_weapon_license'
		end

		Inventory.RemoveItem(inv, 'money', license.price)
		player.PlayerData.metadata.licences.weapon = true
		player.Functions.SetMetaData('licences', player.PlayerData.metadata.licences)

		return true, 'bought_weapon_license'
	end
else
	AddEventHandler('playerDropped', function()
		playerDropped(source)
	end)
end

if server.convertInventory then exports('ConvertItems', server.convertInventory) end
