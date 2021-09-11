local M = {}
local Shops <const> = data('shops')
local Utils <const>, Items <const> = module('utils'), module('items')


for shopName, shopDetails in pairs(Shops) do
	M[shopName] = {}
	for i=1, #shopDetails.locations do
		M[shopName][i] = {
			label = shopDetails.name,
			id = shopName..' '..i,
			job = shopDetails.job,
			items = table.clone(shopDetails.inventory),
			slots = #shopDetails.inventory
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
				}
				M[shopName][i].items[j] = slot
			end
		end
	end	
end

return M