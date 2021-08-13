local Items = data('items')
local Data = data('weapons')
local Weapons = {}

local count = 0
for k, v in pairs(Items) do
	v.name = k
	if not v.consume then
		if v.client and v.client.consume then
			v.consume = v.client.consume
			v.client.consume = nil
		else v.consume = 1 end
	end
	if ox.server then
		v.client = nil
		count = count + 1
	end
end

for k, v in pairs(Data.Weapons) do
	v.name = k
	v.hash = GetHashKey(k)
	v.stack = false
	v.close = false
	Items[k] = v
	Weapons[v.hash] = k
end

for k, v in pairs(Data.Components) do
	v.name = k
	v.consume = 1
	if ox.server then
		v.client = nil
	end
	Items[k] = v
end

for k, v in pairs(Data.Ammo) do
	v.name = k
	v.consume = 1
	v.stack = true
	v.close = false
	if ox.server then
		v.client = nil
	end
	Items[k] = v
end
return {Items, Weapons}