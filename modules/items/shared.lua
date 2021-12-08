local Items = data 'items'

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
	if IsDuplicityVersion then
		v.client = nil
	else v.server = nil end
end

for type, data in pairs(data('weapons')) do
	if type == 'Weapons' then
		for k, v in pairs(data) do
			v.name = k
			v.hash = joaat(k)
			v.stack = v.stack or false
			v.close = true
			if IsDuplicityVersion then
				v.client = nil
			else
				v.server = nil
			end
			if not v.durability then v.durability = 1 end
			Items[k] = v
		end
	else
		for k, v in pairs(data) do
			v.name = k
			v.consume = 1
			v.stack = true
			v.close = type == 'Components' and true or false
			if IsDuplicityVersion then
				v.client = nil
			else
				v.server = nil
			end
			Items[k] = v
		end
	end
end

return Items
