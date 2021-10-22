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
			jobs = shopDetails.jobs,
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
		if shop.jobs then
			local playerJob = ESX.GetPlayerFromId(source).job
			local shopGrade = shop.jobs[playerJob.name]
			if not shopGrade or shopGrade < playerJob.grade then
				return cb()
			end
		end
		left.open = shop.id
	end
	cb({id=left.label, type=left.type, slots=left.slots, weight=left.weight, maxWeight=left.maxWeight}, shop)
end)

local Log <const> = module('logs')
Utils.RegisterServerCallback('ox_inventory:buyItem', function(source, cb, data)
	if data.toType == 'player' then
		if data.count == nil then data.count = 1 end
		local player = Inventory(source)
		local xPlayer = ESX.GetPlayerFromId(source)
		local split = player.open:match('^.*() ')
		local shop = M[player.open:sub(0, split-1)][tonumber(player.open:sub(split+1))]
		local fromData = shop.items[data.fromSlot]
		local toData = player.items[data.toSlot]
		if fromData then
			if fromData.count then
				if fromData.count == 0 then
					return cb(false, nil, {type = 'error', text = ox.locale('shop_nostock')})
				elseif data.count > fromData.count then
					data.count = fromData.count
				end
			elseif fromData.license and not exports.oxmysql:scalarSync('SELECT 1 FROM user_licenses WHERE type = ? AND owner = ?', { fromData.license, player.owner }) then
				return cb(false, nil, {type = 'error', text = ox.locale('item_unlicensed')})
			elseif fromData.grade and xPlayer.job.grade < fromData.grade then
				return cb(false, nil, {type = 'error', text = ox.locale('stash_lowgrade')})
			end
			local currency = fromData.currency or 'money'
			local fromItem = Items(fromData.name)
			local toItem = toData and Items(toData.name)
			local metadata, count = Items.Metadata(xPlayer, fromItem, fromData.metadata or {}, data.count)
			local price = count * fromData.price
			if toData == nil or (fromItem.name == toItem.name and fromItem.stack and Utils.MatchTables(toData.metadata, metadata)) then
				local canAfford = Inventory.GetItem(source, currency, false, true) >= price
				if canAfford then
					local newWeight = player.weight + (fromItem.weight + (metadata?.weight or 0)) * count
					if newWeight > player.maxWeight then
						return cb(false, nil, {type = 'error', text = { ox.locale('cannot_carry')}})
					else
						Inventory.SetSlot(player, fromItem, count, metadata, data.toSlot)
						if fromData.count then shop.items[data.fromSlot].count = fromData.count - count end
						player.weight = newWeight
					end
					Inventory.RemoveItem(source, currency, price)
					Inventory.SyncInventory(xPlayer, player)

					local message = ox.locale('purchased_for', count, fromItem.label, (currency == 'money' and ox.locale('$') or price), (currency == 'money' and price or ' '..currency))
					Log(player, player.open, message)
					return cb(true, {data.toSlot, player.items[data.toSlot], weight}, {type = 'success', text = message})
				else
					return cb(false, nil, {type = 'error', text = ox.locale('cannot_afford', ('%s%s'):format((currency == 'money' and ox.locale('$') or price), (currency == 'money' and price or ' '..currency)))})
				end
			end
			return cb(false, nil, {type = 'error', text = { ox.locale('unable_stack_items')}})
		end
	end
	cb(false)
end)

return M