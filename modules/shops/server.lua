if not lib then return end

local Items = server.items
local Inventory = server.inventory
local Shops = {}
local locations = shared.target and 'targets' or 'locations'

---@class OxShopItem
---@field name string
---@field slot number
---@field weight number
---@field price number
---@field metadata? { [string]: any }
---@field license? string
---@field currency? string
---@field grade? number

---@class OxShopServer : OxShop
---@field id string
---@field coords vector3
---@field items OxShopItem[]

---@param shopName string
---@param shopDetails OxShop
local function createShop(shopName, shopDetails)
	Shops[shopName] = {}
	local shopLocations = shopDetails[locations] or shopDetails.locations

	if shopLocations then
		---@diagnostic disable-next-line: undefined-field
		local groups = shopDetails.groups or shopDetails.jobs

		for i = 1, #shopLocations do
			---@type OxShopServer
			Shops[shopName][i] = {
				label = shopDetails.name,
				id = shopName..' '..i,
				groups = groups,
				items = table.clone(shopDetails.inventory),
				slots = #shopDetails.inventory,
				type = 'shop',
				coords = shared.target and shopDetails.targets?[i]?.loc or shopLocations[i],
				distance = shared.target and shopDetails.targets?[i]?.distance,
			}

			for j = 1, Shops[shopName][i].slots do
				local slot = Shops[shopName][i].items[j]

				if slot.grade and not groups then
					print(('^1attempted to restrict slot %s (%s) to grade %s, but %s has no job restriction^0'):format(i, slot.name, slot.grade, shopDetails.name))
					slot.grade = nil
				end

				local Item = Items(slot.name)

				if Item then
					---@type OxShopItem
					slot = {
						name = Item.name,
						slot = j,
						weight = Item.weight,
						count = slot.count,
						price = (server.randomprices and not slot.currency or slot.currency == 'money') and (math.ceil(slot.price * (math.random(80, 120)/100))) or slot.price or 0,
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
		---@diagnostic disable-next-line: undefined-field
		local groups = shopDetails.groups or shopDetails.jobs

		---@type OxShopServer
		Shops[shopName] = {
			label = shopDetails.name,
			id = shopName,
			groups = groups,
			items = shopDetails.inventory,
			slots = #shopDetails.inventory,
			type = 'shop',
		}

		for i = 1, Shops[shopName].slots do
			local slot = Shops[shopName].items[i]

			if slot.grade and not groups then
				print(('^1attempted to restrict slot %s (%s) to grade %s, but %s has no job restriction^0'):format(i, slot.name, slot.grade, shopDetails.name))
				slot.grade = nil
			end

			local Item = Items(slot.name)

			if Item then
				---@type OxShopItem
				slot = {
					name = Item.name,
					slot = i,
					weight = Item.weight,
					count = slot.count,
					price = (server.randomprices and not slot.currency or slot.currency == 'money') and (math.ceil(slot.price * (math.random(90, 110)/100))) or slot.price,
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

for shopName, shopDetails in pairs(data('shops')) do
	createShop(shopName, shopDetails)
end

---@param shopName string
---@param shopDetails OxShop
exports('RegisterShop', function(shopName, shopDetails)
	createShop(shopName, shopDetails)
end)

-- exports.ox_inventory:RegisterShop('TestShop', {
-- 	name = 'Test shop',
-- 	inventory = {
-- 		{ name = 'burger', price = 10 },
-- 		{ name = 'water', price = 10 },
-- 		{ name = 'cola', price = 10 },
-- 	}, locations = {
-- 		vec3(223.832962, -792.619751, 30.695190),
-- 	},
-- 	groups = {
-- 		police = 0
-- 	},
-- })
-- Open on client with `exports.ox_inventory:openInventory('shop', {id=1, type='TestShop'})`

lib.callback.register('ox_inventory:openShop', function(source, data)
	local left, shop = Inventory(source)

	if data then
		shop = data.id and Shops[data.type][data.id] or Shops[data.type] --[[@as OxShopServer]]

		if not shop.items then return end

		if shop.groups then
			local group = server.hasGroup(left, shop.groups)
			if not group then return end
		end

		if type(shop.coords) == 'vector3' and #(GetEntityCoords(GetPlayerPed(source)) - shop.coords) > 10 then
			return
		end

		left.open = shop.id
	end

	return {label=left.label, type=left.type, slots=left.slots, weight=left.weight, maxWeight=left.maxWeight}, shop
end)

local table = lib.table

-- http://lua-users.org/wiki/FormattingNumbers
-- credit http://richard.warburton.it
local function comma_value(n)
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

lib.callback.register('ox_inventory:buyItem', function(source, data)
	if data.toType == 'player' then
		if data.count == nil then data.count = 1 end
		local playerInv = Inventory(source)
		local split = playerInv.open:match('^.*() ')
		local shop = split and Shops[playerInv.open:sub(0, split-1)][tonumber(playerInv.open:sub(split+1))] or Shops[playerInv.open]
		local fromData = shop.items[data.fromSlot]
		local toData = playerInv.items[data.toSlot]

		if fromData then
			if fromData.count then
				if fromData.count == 0 then
					return false, false, { type = 'error', description = locale('shop_nostock') }
				elseif data.count > fromData.count then
					data.count = fromData.count
				end
			elseif fromData.license and server.hasLicense and not server.hasLicense(playerInv, fromData.license) then
				return false, false, { type = 'error', description = locale('item_unlicensed') }

			elseif fromData.grade then
				local _, rank = server.hasGroup(playerInv, shop.groups)
				if fromData.grade > rank then
					return false, false, { type = 'error', description = locale('stash_lowgrade') }
				end
			end

			local currency = fromData.currency or 'money'
			local fromItem = Items(fromData.name)

			local result = fromItem.cb and fromItem.cb('buying', fromItem, playerInv, data.fromSlot, shop)
			if result == false then return false end

			local toItem = toData and Items(toData.name)
			local metadata, count = Items.Metadata(playerInv, fromItem, fromData.metadata and table.clone(fromData.metadata) or {}, data.count)
			local price = count * fromData.price

			if toData == nil or (fromItem.name == toItem.name and fromItem.stack and table.matches(toData.metadata, metadata)) then
				local newWeight = playerInv.weight + (fromItem.weight + (metadata?.weight or 0)) * count

				if newWeight > playerInv.maxWeight then
					return false, false, { type = 'error', description = locale('cannot_carry') }
				end

				local canAfford = price >= 0 and Inventory.GetItem(source, currency, false, true) >= price

				if not canAfford then
					return false, false, { type = 'error', description = locale('cannot_afford', ('%s%s'):format((currency == 'money' and locale('$') or comma_value(price)), (currency == 'money' and comma_value(price) or ' '..Items(currency).label))) }
				end

				Inventory.SetSlot(playerInv, fromItem, count, metadata, data.toSlot)
				playerInv.weight = newWeight
				Inventory.RemoveItem(source, currency, price)

				if fromData.count then
					shop.items[data.fromSlot].count = fromData.count - count
				end

				if server.syncInventory then server.syncInventory(playerInv) end

				local message = locale('purchased_for', count, fromItem.label, (currency == 'money' and locale('$') or comma_value(price)), (currency == 'money' and comma_value(price) or ' '..Items(currency).label))

				if server.loglevel > 0 then
					if server.loglevel > 1 or fromData.price >= 500 then
						lib.logger(playerInv.owner, 'buyItem', ('"%s" %s'):format(playerInv.label, message:lower()), ('shop:%s'):format(shop.label))
					end
				end

				return true, {data.toSlot, playerInv.items[data.toSlot], shop.items[data.fromSlot].count and shop.items[data.fromSlot], playerInv.weight}, { type = 'success', description = message }
			end

			return false, false, { type = 'error', description = locale('unable_stack_items') }
		end
	end
end)

server.shops = Shops
