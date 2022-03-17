local function newItem(data)
	data.weight = data.weight or 0
	data.close = data.close or true

	if data.stack == nil then
		data.stack = true
	end

	if data.client then
		if not data.consume and (data.client.status or data.client.usetime) then
			data.consume = 1
		end
	end

	if IsDuplicityVersion then data.client = nil else
		data.server = nil
		data.count = 0
	end

	shared.items[data.name] = data
end

do
	local ItemList = {}

	for type, data in pairs(data('weapons')) do
		for k, v in pairs(data) do
			v.name = k
			v.close = type == 'Ammo' and true or false
			if type == 'Weapons' then
				v.hash = joaat(v.hashname)
				v.stack = v.throwable and true or false
				v.durability = v.durability or 1
			else
				v.stack = true
			end
			
			if type == 'Tints' then
				if v.name:find('mk2') then
					v.description = 'MK2 Weapon tint'
				else
					v.description = 'Non-MK2 Weapon tint'
				end
			end

			if IsDuplicityVersion then v.client = nil else
				v.count = 0
				v.server = nil
			end

			ItemList[k] = v
		end
	end

	shared.items = ItemList

	for k, v in pairs(data 'items') do
		v.name = k
		newItem(v)
	end
end
