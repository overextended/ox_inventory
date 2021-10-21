local Items = data('items')
local Data = data('weapons')
local Weapons = {}

for k, v in pairs(Items) do
	v.name = k
	v.weight = v.weight or 0
	v.close = v.close or true
	v.stack = v.stack == nil and true or v.stack
	if v.client then
		if not v.consume and (v.client.consume or v.client.status or v.client.usetime) then
			v.consume = 1
		end
	end
	if ox.server then
		v.client = nil
	else v.server = nil end
end

for k, v in pairs(Data.Weapons) do
	v.name = k
	v.hash = joaat(k)
	v.stack = v.stack or false
	v.close = true
	if ox.server then
		v.client = nil
	else v.server = nil end
	Items[k] = v
	Weapons[v.hash] = k
end

for k, v in pairs(Data.Components) do
	v.name = k
	v.consume = 1
	v.stack = true
	v.close = true
	if ox.server then
		v.client = nil
	else v.server = nil end
	Items[k] = v
end

for k, v in pairs(Data.Ammo) do
	v.name = k
	v.consume = 1
	v.stack = true
	v.close = false
	if ox.server then
		v.client = nil
	else v.server = nil end
	Items[k] = v
end
return {Items, Weapons}