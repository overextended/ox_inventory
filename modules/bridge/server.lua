---@todo separate module into smaller submodules to handle each framework
---starting to get bulky

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
		local openInventory = inv.open and Inventory(inv.open)

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

	AddEventHandler('esx:setJob', function(source, job, lastJob)
		local inventory = Inventory(source)
		if not inventory then return end
		inventory.player.groups[lastJob.name] = nil
		inventory.player.groups[job.name] = job.grade
	end)

	SetTimeout(500, function()
		ESX = exports.es_extended:getSharedObject()

		if ESX.CreatePickup then
			error('ox_inventory requires a ESX Legacy v1.6.0 or above, refer to the documentation.')
		end

		server.UseItem = ESX.UseItem
		server.GetPlayerFromId = ESX.GetPlayerFromId

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

	function server.hasLicense(inv, license)
		return db.selectLicense(license, inv.owner)
	end

	function server.buyLicense(inv, license)
		if db.selectLicense(license.name, inv.owner) then
			return false, 'has_weapon_license'
		elseif Inventory.GetItem(inv, 'money', false, true) < license.price then
			return false, 'poor_weapon_license'
		end

		Inventory.RemoveItem(inv, 'money', license.price)
		TriggerEvent('esx_license:addLicense', inv.id, 'weapon')

		return true, 'bought_weapon_license'
	end

	--- Takes traditional item data and updates it to support ox_inventory, i.e.
	--- ```
	--- Old: {"cola":1, "burger":3}
	--- New: [{"slot":1,"name":"cola","count":1}, {"slot":2,"name":"burger","count":3}]
	---```
	function server.convertInventory(playerId, items)
		if type(items) == 'table' then
			local player = server.GetPlayerFromId(playerId)
			local returnData, totalWeight = table.create(#items, 0), 0
			local slot = 0

			if player then
				for name in pairs(server.accounts) do
					if not items[name] then
						local account = player.getAccount(name)

						if account.money then
							items[name] = account.money
						end
					end
				end
			end

			for name, count in pairs(items) do
				local item = Items(name)

				if item and count > 0 then
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
		for _, Player in pairs(QBCore.Functions.GetQBPlayers()) do setupPlayer(Player) end

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

	AddEventHandler('QBCore:Server:OnMoneyChange', function(src, account, amount, changeType)
		if account ~= "cash" then return end
		local item = Inventory.GetItem(src, 'money', nil, false)
		Inventory.SetItem(src, 'money', changeType == "set" and amount or changeType == "remove" and item.count - amount or changeType == "add" and item.count + amount)
	end)

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
else
	AddEventHandler('playerDropped', function()
		playerDropped(source)
	end)
end

if server.convertInventory then exports('ConvertItems', server.convertInventory) end
