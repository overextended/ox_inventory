local Items = server.items
local Inventory = server.inventory

local Shops = {}

local locations = ox.qtarget and 'targets' or 'locations'

for shopName, shopDetails in pairs(data('shops')) do
	Shops[shopName] = {}
	if shopDetails[locations] then
		for i=1, #shopDetails[locations] do
			Shops[shopName][i] = {
				label = shopDetails.name,
				id = shopName..' '..i,
				jobs = shopDetails.jobs,
				items = table.clone(shopDetails.inventory),
				slots = #shopDetails.inventory,
				type = 'shop',
				coords = ox.qtarget and shopDetails[locations][i].loc or shopDetails[locations][i]
			}
			for j=1, Shops[shopName][i].slots do
				local slot = Shops[shopName][i].items[j]
				local Item = Items(slot.name)
				if Item then
					slot = {
						name = Item.name,
						slot = j,
						weight = Item.weight,
						count = slot.count,
						price = ox.randomprices and (math.floor(slot.price * (math.random(8, 12)/10))) or slot.price,
						metadata = slot.metadata,
						license = slot.license,
						currency = slot.currency,
						grade = slot.grade
					}
					Shops[shopName][i].items[j] = slot
				end
			end
		end
	else
		Shops[shopName] = {
			label = shopDetails.name,
			id = shopName,
			jobs = shopDetails.jobs,
			items = shopDetails.inventory,
			slots = #shopDetails.inventory,
			type = 'shop',
		}
		for i=1, Shops[shopName].slots do
			local slot = Shops[shopName].items[i]
			local Item = Items(slot.name)
			if Item then
				slot = {
					name = Item.name,
					slot = i,
					weight = Item.weight,
					count = slot.count,
					price = ox.randomprices and (math.floor(slot.price * (math.random(9, 11)/10))) or slot.price,
					metadata = slot.metadata,
					license = slot.license,
					currency = slot.currency,
					grade = slot.grade
				}
				Shops[shopName].items[i] = slot
			end
		end
	end
end

local ServerCallback = import 'callbacks'

ServerCallback.Register('openShop', function(source, cb, data)
	local left, shop = Inventory(source)
	if data then
		shop = data.id and Shops[data.type][data.id] or Shops[data.type]

		if shop.jobs then
			local playerJob = left.player.job
			local shopGrade = shop.jobs[playerJob.name]
			if not shopGrade or shopGrade > playerJob.grade then
				return cb()
			end
		end

		if shop.coords and #(GetEntityCoords(GetPlayerPed(source)) - shop.coords) > 10 then
			return cb()
		end

		left.open = shop.id
	end

	cb({id=left.label, type=left.type, slots=left.slots, weight=left.weight, maxWeight=left.maxWeight}, shop)
end)

local table = import 'table'
local Log = server.logs

ServerCallback.Register('buyItem', function(source, cb, data)
	if data.toType == 'player' then
		if data.count == nil then data.count = 1 end
		local player = Inventory(source)
		local split = player.open:match('^.*() ')
		local shop = split and Shops[player.open:sub(0, split-1)][tonumber(player.open:sub(split+1))] or Shops[player.open]
		local fromData = shop.items[data.fromSlot]
		local toData = player.items[data.toSlot]

		if fromData then
			if fromData.count then
				if fromData.count == 0 then
					return cb(false, nil, {type = 'error', text = ox.locale('shop_nostock')})
				elseif data.count > fromData.count then
					data.count = fromData.count
				end

			elseif fromData.license and not MySQL.Sync.fetchScalar('SELECT 1 FROM user_licenses WHERE type = ? AND owner = ?', { fromData.license, player.owner }) then
				return cb(false, nil, {type = 'error', text = ox.locale('item_unlicensed')})

			elseif fromData.grade and player.data.job.grade < fromData.grade then
				return cb(false, nil, {type = 'error', text = ox.locale('stash_lowgrade')})
			end

			local currency = fromData.currency or 'money'
			local fromItem = Items(fromData.name)

			local result = Items[fromItem.name] and Items[fromItem.name]('buying', fromItem, player, data.fromSlot, shop)
			if result == false then return cb(false) end

			local toItem = toData and Items(toData.name)
			local metadata, count = Items.Metadata(player, fromItem, fromData.metadata and table.clone(fromData.metadata) or {}, data.count)
			local price = count * fromData.price

			local _, totalCount, _ = Inventory.GetItemSlots(player, fromItem, fromItem.metadata)
			if fromItem.limit and (totalCount + data.count) > fromItem.limit then
				return cb(false, nil, {type = 'error', text = { ox.locale('cannot_carry')}})
			end

			if toData == nil or (fromItem.name == toItem.name and fromItem.stack and table.matches(toData.metadata, metadata)) then
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
					if ox.esx then Inventory.SyncInventory(player) end
					local message = ox.locale('purchased_for', count, fromItem.label, (currency == 'money' and ox.locale('$') or price), (currency == 'money' and price or ' '..currency))

					-- Only log purchases for items worth $500 or more
					if fromData.price >= 500 then
						Log(
							player.open,
							('%s [%s] - %s'):format(player.label, player.id, player.owner),
							message, metadata.serial and ('(%s)'):format(metadata.serial)
						)
					end

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

server.shops = Shops
