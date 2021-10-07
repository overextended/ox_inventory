local Items <const> = module('items')
local Inventory <const> = module('inventory')
local Utils <const> = module('utils')

local M = {}

for shopName, shopDetails in pairs(data('shops')) do
	M[shopName] = {}
	for i=1, #shopDetails.locations do
		M[shopName][i] = {
			label = shopDetails.name,
			id = shopName..' '..i,
			job = shopDetails.job,
			items = table.clone(shopDetails.inventory),
			slots = #shopDetails.inventory,
			type = 'shop'
		}
		for j=1, M[shopName][i].slots do
			local slot = M[shopName][i].items[j]
			local Item = Items(slot.name)
			if Item then
				slot = {
					name = Item.name,
					slot = j,
					weight = Item.weight,
					count = slot.count,
					price = (math.floor(slot.price * (math.random(8, 12)/10))),
					metadata = slot.metadata,
					license = slot.license,
					currency = slot.currency,
					grade = slot.grade
				}
				M[shopName][i].items[j] = slot
			end
		end
	end
end

Utils.RegisterServerCallback('ox_inventory:openShop', function(source, cb, data)
	local left, shop = Inventory(source)
	if data then
		shop = M[data.type][data.id]
		left.open = shop.id
	end
	cb({id=left.label, type=left.type, slots=left.slots, weight=left.weight, maxWeight=left.maxWeight}, shop)
end)

Utils.RegisterServerCallback('ox_inventory:buyItem', function(source, cb, data)
	if data.toType == 'player' then
		if data.count == nil then data.count = 1 end
		local player, items = Inventory(source), {}
		local xPlayer = ESX.GetPlayerFromId(source)
		local split = player.open:match('^.*() ')
		local shop = M[player.open:sub(0, split-1)][tonumber(player.open:sub(split+1))]
		local fromData = shop.items[data.fromSlot]
		local toData = player.items[data.toSlot]
		if fromData then
			if fromData.count == 0 then
				return cb(false, nil, {type = 'error', text = ox.locale('shop_nostock')})
			elseif fromData.license and not exports.oxmysql:scalarSync('SELECT 1 FROM user_licenses WHERE type = ? AND owner = ?', { fromData.license, player.owner }) then
				-- Change this later, querying the database each time is silly
				return cb(false, nil, {type = 'error', text = ox.locale('item_unlicensed')})
			elseif fromData.grade and xPlayer.job.grade < fromData.grade then
				-- Needs new/updated locale
				return cb(false, nil, {type = 'error', text = ox.locale('stash_lowgrade')})
			end
			local currency = fromData.currency or 'money'
			local fromItem = Items(fromData.name)
			local toItem = toData and Items(toData.name)
			if fromData.count and data.count > fromData.count then data.count = fromData.count end
			local metadata, count = Items.Metadata(xPlayer, fromItem, fromData.metadata or {}, data.count)
			local price = count * fromData.price
			local playerMoney = Inventory.GetItem(source, currency, false, true)

			if playerMoney >= price and (toData and Utils.MatchTables(toData.metadata, metadata) or toData == nil) then
				if toData and toData.name == fromData.name then
					if fromData.count then fromData.count = fromData.count - count end
					toData.count = toData.count + count
					toData.weight = Inventory.SlotWeight(toItem, toSlot)
					player.weight = player.weight + toData.weight
				elseif fromData.count == nil or count <= fromData.count then
					if fromData.count then fromData.count = fromData.count - count end
					toData = table.clone(fromItem)
					toData.count = count
					toData.slot = data.toSlot
					toData.weight = Inventory.SlotWeight(fromItem, toData)
					player.weight = player.weight + toData.weight
				end
				toData.metadata = metadata
				shop.items[data.fromSlot], player.items[data.toSlot] = fromData, toData
				Inventory.RemoveItem(source, currency, price)
				Inventory.SyncInventory(xPlayer, player)

				return cb(true, {data.toSlot, toData, weight}, {type = 'success', text = ('Purchased %sx %s for %s%s'):format(count, fromItem.label, (currency == 'money' and '$' or price), (currency == 'money' and price or ' '..currency))})
			elseif playerMoney < price then
				return cb(false, nil, {type = 'error', text = ox.locale('cannot_afford', ('%s%s'):format((currency == 'money' and '$' or price), (currency == 'money' and price or ' '..currency)))})
			end
			return cb(false, nil, {type = 'error', text = {"You're unable to stack these items!"}})
		end
	end
	cb(false)
end)

return M