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
					count = slot.count or 5,
					price = (math.floor(slot.price * (math.random(8, 12)/10))),
					metadata = slot.metadata,
					license = slot.license,
					currency = slot.currency
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
	if data.toType == 'player' and data.fromSlot ~= data.toSlot then
		if data.count == nil then data.count = 1 end
		local player, items = Inventory(source), {}
		local xPlayer = ESX.GetPlayerFromId(source)
		local split = player.open:match('^.*() ')
		local shop = M[player.open:sub(0, split-1)][tonumber(player.open:sub(split+1))]
		local fromSlot, toSlot = shop.items[data.fromSlot], player.items[data.toSlot]
		if fromSlot then
			if fromSlot.count == 0 then
				return cb(false, nil, {type = 'error', text = ox.locale('shop_nostock')})
			elseif fromSlot.license and not exports.oxmysql:scalarSync('SELECT 1 FROM user_licenses WHERE type = ? AND owner = ?', { fromSlot.license, player.owner }) then
				-- Change this later, querying the database each time is silly
				return cb(false, nil, {type = 'error', text = ox.locale('item_unlicensed')})
			elseif fromSlot.grade and xPlayer.job.grade < fromSlot.grade then
				-- Needs new/updated locale
				return cb(false, nil, {type = 'error', text = ox.locale('stash_lowgrade')})
			end
			local currency = fromSlot.currency or 'money'
			local fromItem, toItem = Items(fromSlot.name), toSlot and Items(toSlot.name)
			if fromSlot.count and data.count > fromSlot.count then data.count = fromSlot.count end
			local metadata, count = Items.Metadata(xPlayer, fromItem, fromSlot.metadata or {}, data.count)
			local price = count * fromSlot.price
			local playerMoney = Inventory.GetItem(source, currency, false, true)
			if playerMoney >= price and (toSlot and Utils.MatchTables(toSlot.metadata, metadata) or toSlot == nil) then
				if toSlot and toSlot.name == fromSlot.name then
					if fromSlot.count then fromSlot.count = fromSlot.count - count end
					toSlot.count = toSlot.count + count
					toSlot.weight = Inventory.SlotWeight(toItem, toSlot)
					player.weight = player.weight + toSlot.weight
				elseif fromSlot.count == nil or count <= fromSlot.count then
					if fromSlot.count then fromSlot.count = fromSlot.count - count end
					toSlot = table.clone(fromItem)
					toSlot.count = count
					toSlot.slot = data.toSlot
					toSlot.weight = Inventory.SlotWeight(fromItem, toSlot)
					player.weight = player.weight + toSlot.weight
				else
					print('buyItem', data.fromType, data.fromSlot, 'to', data.toType, data.toSlot)
					return cb(false)
				end
				toSlot.metadata = metadata
				shop.items[data.fromSlot], player.items[data.toSlot] = fromSlot, toSlot
				Inventory.RemoveItem(source, currency, price)
				Inventory.SyncInventory(xPlayer, player, items)
				return cb(true, {data.toSlot, toSlot, weight}, {type = 'success', text = ('Purchased %sx %s for %s%s'):format(count, fromItem.label, (currency == 'money' and '$' or price), (currency == 'money' and price or ' '..currency))})
			end
			return cb(false, nil, {type = 'error', text = ox.locale('cannot_afford', '$'..price-playerMoney)})
		end
	end
	cb(false)
end)

return M