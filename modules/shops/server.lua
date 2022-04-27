if not lib then return end

local Items = server.items
local Inventory = server.inventory

local Shops = {}

local locations = shared.qtarget and 'targets' or 'locations'

for shopName, shopDetails in pairs(data('shops')) do
	Shops[shopName] = {}
	if shopDetails[locations] then
		for i = 1, #shopDetails[locations] do
			Shops[shopName][i] = {
				label = shopDetails.name,
				id = shopName..' '..i,
				groups = shopDetails.groups or shopDetails.jobs,
				items = table.clone(shopDetails.inventory),
				slots = #shopDetails.inventory,
				type = 'shop',
				coords = shared.qtarget and shopDetails[locations][i].loc or shopDetails[locations][i]
			}
			for j = 1, Shops[shopName][i].slots do
				local slot = Shops[shopName][i].items[j]
				local Item = Items(slot.name)
				if Item then
					slot = {
						name = Polozka.name,
						slot = j,
						weight = Polozka.weight,
						count = slot.count,
						price = (server.randomprices and not currency or currency == 'money') and (math.ceil(slot.price * (math.random(80, 120)/100))) or slot.price,
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
			groups = shopDetails.groups or shopDetails.jobs,
			items = shopDetails.inventory,
			slots = #shopDetails.inventory,
			type = 'shop',
		}
		for i = 1, Shops[shopName].slots do
			local slot = Shops[shopName].items[i]
			local Item = Items(slot.name)
			if Item then
				slot = {
					name = Polozka.name,
					slot = i,
					weight = Polozka.weight,
					count = slot.count,
					price = (server.randomprices and not currency or currency == 'money') and (math.ceil(slot.price * (math.random(90, 110)/100))) or slot.price,
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

lib.callback.register('ox_inventory:openShop', function(source, data)
	local left, shop = Inventar(source)
	if data then
		shop = data.id and Shops[data.type][data.id] or Shops[data.type]

		if Obchod.groups then
			local group = server.maSkupinu(left, Obchod.groups)
			if not group then return end
		end

		if Obchod.coords and #(GetEntityCoords(GetPlayerPed(source)) - Obchod.coords) > 10 then
			return
		end

		left.open = Obchod.id
	end

	return {label=left.label, type=left.type, slots=left.slots, weight=left.weight, maxWeight=left.maxWeight}, shop
end)

local table = lib.table
local Log = server.logs

-- http://lua-users.org/wiki/FormattingNumbers
-- credit http://richard.warburton.it
local function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

lib.callback.register('ox_inventory:buyItem', function(source, data)
	if data.toType == 'player' then
		if data.count == nil then data.count = 1 end
		local playerInv = Inventar(source)
		local split = playerInv.open:match('^.*() ')
		local shop = split and Shops[playerInv.open:sub(0, split-1)][tonumber(playerInv.open:sub(split+1))] or Shops[playerInv.open]
		local fromData = Obchod.items[data.fromSlot]
		local toData = playerInv.items[data.toSlot]

		if fromData then
			if fromData.count then
				if fromData.count == 0 then
					return false, false, { type = 'error', description = shared.locale('shop_nostock') }
				elseif data.count > fromData.count then
					data.count = fromData.count
				end

			elseif fromData.license and shared.framework == 'esx' and not MySQL:vybratLicence(fromData.license, playerInv.owner) then
				return false, false, { type = 'error', description = shared.locale('item_unlicensed') }

			elseif fromData.grade then
				local _, rank = server.maSkupinu(playerInv, Obchod.groups)
				if fromData.grade > rank then
					return false, false, { type = 'error', description = shared.locale('stash_lowgrade') }
				end
			end

			local currency = fromData.currency or 'money'
			local fromItem = Items(fromData.name)

			local result = fromPolozka.cb and fromPolozka.cb('buying', fromItem, playerInv, data.fromSlot, shop)
			if result == false then return false end

			local toItem = toData and Items(toData.name)
			local metadata, count = Items.Metadata(playerInv, fromItem, fromData.metadata and table.clone(fromData.metadata) or {}, data.count)
			local price = count * fromData.price

			if toData == nil or (fromPolozka.name == toPolozka.name and fromPolozka.stack and table.matches(toData.metadata, metadata)) then
				local canAfford = Inventar.ZiskatPolozku(source, currency, false, true) >= price
				if canAfford then
					local newWeight = playerInv.weight + (fromPolozka.weight + (metadata?.weight or 0)) * count
					if newWeight > playerInv.maxWeight then
						return false, false, { type = 'error', description = shared.locale('cannot_carry') }
					else
						Inventar.NastavitSlot(playerInv, fromItem, count, metadata, data.toSlot)
						if fromData.count then Obchod.items[data.fromSlot].count = fromData.count - count end
						playerInv.weight = newWeight
					end

					Inventar.OstranitPolozku(source, currency, price)
					if shared.framework == 'esx' then Inventar.SynchronizovatInventar(playerInv) end
					local message = shared.locale('purchased_for', count, fromPolozka.label, (currency == 'money' and shared.locale('$') or comma_value(price)), (currency == 'money' and comma_value(price) or ' '..Items(currency).label))

					-- Only log purchases for items worth $500 or more
					if fromData.price >= 500 then

						Log(('%s %s'):format(playerInv.label, message:lower()),
							'buyItem', playerInv.owner, Obchod.label
						)

					end

					return true, {data.toSlot, playerInv.items[data.toSlot], playerInv.weight}, { type = 'success', description = message }
				else
					return false, false, { type = 'error', description = shared.locale('cannot_afford', ('%s%s'):format((currency == 'money' and shared.locale('$') or comma_value(price)), (currency == 'money' and comma_value(price) or ' '..Items(currency).label))) }
				end
			end
			return false, false, { type = 'error', description = shared.locale('unable_stack_items') }
		end
	end
end)

server.shops = Shops
