local M = {}
local Shops = data('shops')

-- for i=1, #Shops.Stores do
-- 	local v = Shops.Stores[i]
-- 	v.type = v.type or Shops.General
-- 	v.name = v.type.name
-- 	v.blip = v.type.blip or nil
-- 	v.type = nil
-- 	M[i] = v
-- end

for shopName, shopDetails in pairs(Shops) do
	M[shopName] = shopDetails
end

return M