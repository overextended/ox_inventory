local M = {}
local Shops <const> = data('shops')
local Utils <const>, Items <const> = module('utils'), module('items')

local Stores = {}

for i=1, #Shops.Stores do
	local v = Shops.Stores[i]
	if not v.type then v.type = Shops.General end
	v.label = v.type.name
	local inventory = {}
	local copy = table.clone(v.type.inventory)
	for k=1, #copy do
		local Item = Items(copy[k].name)
		if Item then
			local item = {
				price = (math.floor(copy[k].price * (math.random(8, 12)/10))),
				slot = k,
				name = Item.name,
				weight = Item.weight,
				count = copy[k].count
			}
			inventory[k] = item
		end
	end
	v.type = nil
	v.id = 'shop'..i
	Stores[i] = v
	Stores[i].items = inventory
	Stores[i].slots = #inventory
end

local metatable = setmetatable(M, {
	__index = Stores
})

return M