local M = {}
local Shops <const> = data('shops')
local Utils <const>, Items <const> = module('utils'), module('items')

local Stores = {}

for shopName, shopDetails in pairs(Shops) do
	local inventory = {}
	local copy = Utils.Copy(shopDetails.inventory)
	for i=1, #copy do
		local Item = Items(copy[i].name)
		if (Item) then
			local item = {
				price = (math.floor(copy[i].price * (math.random(8, 12)/10))),
				slot = i,
				name = Item.name,
				weight = Item.weight,
				count = copy[i].count
			}
			inventory[i] = item
		end
	end

	Stores[shopName] = shopDetails
	Stores[shopName].items = inventory
	Stores[shopName].slots = #inventory
end

-- for i=1, #Shops.Stores do
-- 	local v = Shops.Stores[i]
-- 	if not v.type then v.type = Shops.General end
-- 	v.label = v.type.name
-- 	local inventory = {}
-- 	local copy = Utils.Copy(v.type.inventory)
-- 	for k=1, #copy do
-- 		local Item = Items(copy[k].name)
-- 		if Item then
-- 			local item = {
-- 				price = (math.floor(copy[k].price * (math.random(8, 12)/10))),
-- 				slot = k,
-- 				name = Item.name,
-- 				weight = Item.weight,
-- 				count = copy[k].count
-- 			}
-- 			inventory[k] = item
-- 		end
-- 	end
-- 	v.type = nil
-- 	v.id = 'shop'..i
-- 	Stores[i] = v
-- 	Stores[i].items = inventory
-- 	Stores[i].slots = #inventory
-- end

local metatable = setmetatable(M, {
	__index = Stores
})

return M