local Inventory = require 'modules.inventory.server'
local Items = require 'modules.items.server'

AddEventHandler('esx:playerDropped', server.playerDropped)

AddEventHandler('esx:setJob', function(source, job, lastJob)
	local inventory = Inventory(source)
	if not inventory then return end
	inventory.player.groups[lastJob.name] = nil
	inventory.player.groups[job.name] = job.grade
end)

local ESX

SetTimeout(500, function()
    lib.checkDependency('es_extended', '1.6.0', true)

	ESX = exports.es_extended:getSharedObject()
    local customInventory = ESX.GetConfig().CustomInventory

	if customInventory ~= nil and customInventory ~= "ox" then
        error('es_extended has not been configured to enable support for ox_inventory!\nEnsure Config.CustomInventory has been set to "ox" in your es_extended resource config.')
    end

	server.UseItem = ESX.UseItem
	server.GetPlayerFromId = ESX.GetPlayerFromId

	for _, player in pairs(ESX.Players) do
		server.setPlayerInventory(player, player?.inventory)
	end
end)

server.accounts.black_money = 0

---@diagnostic disable-next-line: duplicate-set-field
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

---@diagnostic disable-next-line: duplicate-set-field
function server.syncInventory(inv)
	local accounts = Inventory.GetAccountItemCounts(inv)

    if accounts then
        local player = server.GetPlayerFromId(inv.id)
        player.syncInventory(inv.weight, inv.maxWeight, inv.items, accounts)
    end
end

---@diagnostic disable-next-line: duplicate-set-field
function server.hasLicense(inv, name)
	return MySQL.scalar.await('SELECT 1 FROM `user_licenses` WHERE `type` = ? AND `owner` = ?', { name, inv.owner })
end

---@diagnostic disable-next-line: duplicate-set-field
function server.buyLicense(inv, license)
	if server.hasLicense(inv, license.name) then
		return false, 'already_have'
	elseif Inventory.GetItemCount(inv, 'money') < license.price then
		return false, 'can_not_afford'
	end

	Inventory.RemoveItem(inv, 'money', license.price)
	TriggerEvent('esx_license:addLicense', inv.id, license.name)

	return true, 'have_purchased'
end

--- Takes traditional item data and updates it to support ox_inventory, i.e.
--- ```
--- Old: {"cola":1, "burger":3}
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

---@diagnostic disable-next-line: duplicate-set-field
function server.isPlayerBoss(playerId)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	return xPlayer.job.grade_name == 'boss'
end

MySQL.ready(function()
	MySQL.insert('INSERT IGNORE INTO `licenses` (`type`, `label`) VALUES (?, ?)', { 'weapon', 'Weapon License'})
end)
