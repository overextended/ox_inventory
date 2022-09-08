local playerDropped = ...
local Inventory, Items

CreateThread(function()
	Inventory = server.inventory
	Items = server.items
end)

AddEventHandler('esx:playerDropped', playerDropped)

AddEventHandler('esx:setJob', function(source, job, lastJob)
	local inventory = Inventory(source)
	if not inventory then return end
	inventory.player.groups[lastJob.name] = nil
	inventory.player.groups[job.name] = job.grade
end)

local ESX

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
