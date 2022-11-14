if not lib then return end

local Items = server.items
local Inventory = server.inventory
local Shops = {}
local locations = shared.target and 'targets' or 'locations'
local AllShops = {}
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

local function createSingleShop(shopName,shopDetails,index,vendor)
	local groups = shopDetails.groups or shopDetails.jobs
	local data = Shops[shopName]
	local dist = shared.target and shopDetails.targets?[index]?.distance or 1.5
	local coord = shared.target and shopDetails.targets?[index]?.loc
	if not vendor then
		coord = shopDetails.coord or shopDetails?.locations[index]
		if not Shops[shopName][index] then Shops[shopName][index] = {} end
		data = Shops[shopName][index]
	end
	data = {
		label = shopDetails.name,
		groups = groups,
		items = table.clone(shopDetails.inventory),
		slots = #shopDetails.inventory,
		type = 'shop',
		coords = coord,
		distance = dist,
	}
	if vendor then data.coords = nil data.distance = nil data.id = shopName else data.id = shopName..' '..index end
	for j = 1, data.slots do
		local slot = data.items[j]

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

			data.items[j] = slot
		end
	end
	if vendor then
		Shops[shopName] = data
	else
		Shops[shopName][index] = data
	end
end

local function createShop(shopName, shopDetails)
	Shops[shopName] = {}
	AllShops[shopName] = shopDetails
	local shopLocations = shopDetails[locations] or shopDetails.locations

	if shopLocations then
		---@diagnostic disable-next-line: undefined-field
		local groups = shopDetails.groups or shopDetails.jobs
		for i = 1, #shopLocations do
			---@type OxShopServer
			createSingleShop(shopName, shopDetails, i)
		end
	else
		---@diagnostic disable-next-line: undefined-field
		local groups = shopDetails.groups or shopDetails.jobs
		---@type OxShopServer
		createSingleShop(shopName, shopDetails, i, true)
	end
end

for shopName, shopDetails in pairs(data('shops')) do
	createShop(shopName, shopDetails)
end

---@param shopName string
---@param shopDetails OxShop
GlobalState.AllShops = AllShops
exports('RegisterShop', function(shopName, shopDetails)
	createShop(shopName, shopDetails)
	GlobalState.AllShops = AllShops
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

exports('RegisterSingleShop', function(shopName, shopDetails, shopIndex, vendor, update)
	local index = shopIndex or #Shops[shopName]+1
	createSingleShop(shopName, shopDetails, shopIndex, vendor)
	if update then
		AllShops[shopName].locations[shopIndex] = shopDetails.coord
		GlobalState.AllShops = AllShops
	end
end)

-- @ name : string @ inventory : table @ coord : vec3 @ index : number @ vendor : bool
-- exports.ox_inventory:RegisterSingleShop(shopname, {
-- 	name = 'General Store 1', 
-- 	inventory = {
-- 		{ name = 'burger', price = 50 }, 
-- 		{ name = 'water', price = 50 }
-- 	},
-- 	coord = vec3(25.66,-1347.91,29.49)
-- }, 1, false) -- shop index or leave blank, vendor @ bool

exports('ModifyShop', function(data)
	if not Shops[data.shopname] then return end
	if not Shops[data.shopname][data.shopindex] then return end
	for i,item in pairs(Shops[data.shopname][data.shopindex].items or {}) do
		if item.metadata and item.metadata.name or item.name == data.item then
			if Shops[data.shopname][data.shopindex].items[i][data.parameter] and tonumber(data.value) and data.parameter == 'count' then
				Shops[data.shopname][data.shopindex].items[i][data.parameter] += data.value
			else
				Shops[data.shopname][data.shopindex].items[i][data.parameter] = data.value
			end
			break
		end
	end
end)

-- exports.ox_inventory:ModifyShop({
-- 	shopname = 'General',
-- 	shopindex = 1,
-- 	item = 'burger',
-- 	value = 5, -- can be string or number. eg if count should be number. currency are string. this
-- 	parameter = 'count' -- count, price, currency. or any shop parameter. count will add if item count is existed
-- })

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

			local hookPayload = {
				source = source,
				fromData = fromData,
				toData = toData,
				ShopName = playerInv.open:sub(0, split-1),
				ShopIndex = playerInv.open:sub(split+1),
				count = data.count,
				price = fromData.price,
				item = fromData.name,
				metadata = metadata,
				currency = fromData.currency or 'money'
				
			}
			
			if toData == nil or (fromItem.name == toItem.name and fromItem.stack and table.matches(toData.metadata, metadata)) then
				local newWeight = playerInv.weight + (fromItem.weight + (metadata?.weight or 0)) * count

				if newWeight > playerInv.maxWeight then
					return false, false, { type = 'error', description = locale('cannot_carry') }
				end

				local canAfford = price >= 0 and Inventory.GetItem(source, currency, false, true) >= price

				if not canAfford then
					return false, false, { type = 'error', description = locale('cannot_afford', ('%s%s'):format((currency == 'money' and locale('$') or comma_value(price)), (currency == 'money' and comma_value(price) or ' '..Items(currency).label))) }
				end

				if not TriggerEventHooks('buyItem', hookPayload) then return end

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
