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

if shared.framework == 'esx' then
	local ESX

	SetTimeout(4000, function()
		ESX = exports.es_extended:getSharedObject()

		if ESX.CreatePickup then
			error('ox_inventory requires a ESX Legacy v1.6.0 or above, refer to the documentation.')
		end

		server.UseItem = ESX.UseItem
		server.GetPlayerFromId = ESX.GetPlayerFromId
		server.UsableItemsCallbacks = ESX.GetUsableItems()

		for i = 1, #ESX.Players do
			local player = ESX.Players[i]
			exports.ox_inventory:setPlayerInventory(player, player?.inventory)
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

elseif shared.framework == 'qb' then
	local QBCore = exports['qb-core']:GetCoreObject()

	local itemCallbacks = {}

	QBCore.Functions.SetMethod('CreateUseableItem', function(item, cb)
		itemCallbacks[item] = cb
	end)

	server.UseItem = function(source, itemName, ...)
		local callback = itemCallbacks[itemName].callback or itemCallbacks[itemName].cb or type(itemCallbacks[itemName]) == "function" and itemCallbacks[itemName]

		if not callback then return end

		callback(source, itemName, ...)
	end

	AddEventHandler('__cfx_export_qb-inventory_LoadInventory', function(setCB)
		setCB(function() return {} end) -- ox_inventory loads the inventory itself so we send 0 items back and let ox_inventory do the rest
	end)

	AddEventHandler('__cfx_export_qb-inventory_SaveInventory', function(setCB)
		setCB(function() end) -- No need for qb-core to save the inventory
	end)

	AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
		QBCore.Functions.AddPlayerField(Player.PlayerData.source, 'syncInventory', function(_, _, items, money)
			Player.Functions.SetPlayerData('items', items)

			if money?.cash then Player.Functions.SetMoney('cash', money.cash, "Sync money with inventory") end
		end)

		exports.ox_inventory:setPlayerInventory(Player.PlayerData, Player?.PlayerData.items)
	end)

	local usableItems = {}

	for k, v in pairs(QBCore.Shared.Items) do
		if v.useable then usableItems[k] = true end
	end

	server.UsableItemsCallbacks = usableItems
	server.GetPlayerFromId = QBCore.Functions.GetPlayer

	-- Accounts that need to be synced with physical items
	server.accounts = {
		cash = 0
	}

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
end