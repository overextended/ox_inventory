local ItemList = data 'items'

for k, v in pairs(data('items')) do
	v.name = k
	v.weight = v.weight or 0
	v.close = v.close or true
	v.stack = v.stack == nil and true or v.stack

	if v.client then
		if not v.consume and (v.client.consume or v.client.status or v.client.usetime) then
			v.consume = 1
		end
	end

    if IsDuplicityVersion then v.client = nil else v.server = nil end
	ItemList[k] = v
end

for type, data in pairs(data('weapons')) do
	for k, v in pairs(data) do
		v.name = k
		v.hash = type == 'Weapons' and joaat(k)
		v.stack = type == 'Weapons' and false or true
		v.close = type == 'Ammo' and true or false

		if type == 'Weapons' and not v.durability then
			v.durability = 1
		end

        if IsDuplicityVersion then v.client = nil else v.server = nil end
		ItemList[k] = v
	end
end

return ItemList