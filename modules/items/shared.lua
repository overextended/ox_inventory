local function useExport(resource, export)
	return function(...)
		return exports[resource][export](nil, ...)
	end
end

local function newItem(data)
	data.weight = data.weight or 0

	if data.close == nil then
		data.close = true
	end

	if data.stack == nil then
		data.stack = true
	end

	local client, server = data.client, data.server

	if not data.consume and (client and (client.status or client.usetime or client.export) or server?.export) then
		data.consume = 1
	end

	if IsDuplicityVersion then
		data.client = nil

		if server?.export then
			data.cb = useExport(string.strsplit('.', server.export))
		end
	else
		data.server = nil
		data.count = 0

		if client?.export then
			data.export = useExport(string.strsplit('.', client.export))
		end
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
				v.hash = joaat(v.model or k)
				v.stack = v.throwable and true or false
				v.durability = v.durability or 1
				v.weapon = true
			else
				v.stack = true
			end

			v[type == 'Ammo' and 'ammo' or type == 'Components' and 'component' or type == 'Tints' and 'tint' or 'weapon'] = true

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
