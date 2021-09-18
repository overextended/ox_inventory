local Items = data('items')
local Data = data('weapons')
local Weapons = {}

for k, v in pairs(Items) do
	v.name = k
	v.weight = v.weight or 0
	if ox.server then
		v.client = nil
	else
		v.server = nil
	end
end

for k, v in pairs(Data.Weapons) do
	v.name = k
	v.hash = joaat(k)
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