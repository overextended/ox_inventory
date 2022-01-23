function items()
	local ItemList = {}

	for k, v in pairs(data 'items') do
		v.name = k
		v.weight = v.weight or 0
		v.close = v.close or true
		v.stack = v.stack == nil and true or v.stack

		if v.client then
			if not v.consume and (v.client.consume or v.client.status or v.client.usetime) then
				v.consume = 1
			end
		end

		if IsDuplicityVersion then v.client = nil else
			v.server = nil
			v.count = 0
		end
		ItemList[k] = v
	end

	for type, data in pairs(data('weapons')) do
		for k, v in pairs(data) do
			v.name = k
			v.close = type == 'Ammo' and true or false
			if type == 'Weapons' then
				v.hash = joaat(k)
				v.stack = v.throwable and true or false
				v.durability = v.durability or 1
			else
				v.stack = true
			end

			if IsDuplicityVersion then v.client = nil else
				v.count = 0
				v.server = nil
			end

			ItemList[k] = v
		end
	end

	items = nil
	return ItemList
end
