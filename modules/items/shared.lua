local function useExport(resource, export)
	return function(...)
		return exports[resource][export](nil, ...)
	end
end

local ItemList = {}
local isServer = IsDuplicityVersion()

local function setImagePath(path)
    if path then
        return path:match('^[%w]+://') and path or ('%s/%s'):format(client.imagepath, path)
    end
end

---@param data OxItem
local function newItem(data)
	data.weight = data.weight or 0

	if data.close == nil then
		data.close = true
	end

	if data.stack == nil then
		data.stack = true
	end

	local clientData, serverData = data.client, data.server
	---@cast clientData -nil
	---@cast serverData -nil

	if not data.consume and (clientData and (clientData.status or clientData.usetime or clientData.export) or serverData?.export) then
		data.consume = 1
	end

	if isServer then
        ---@cast data OxServerItem
        serverData = data.server
		data.client = nil

		if not data.durability then
			if data.degrade or (data.consume and data.consume ~= 0 and data.consume < 1) then
				data.durability = true
			end
		end

        if not serverData then goto continue end

        if serverData.export then
            data.cb = useExport(string.strsplit('.', serverData.export))
        end
	else
        ---@cast data OxClientItem
        clientData = data.client
		data.server = nil
		data.count = 0

        if not clientData then goto continue end

        if clientData.export then
            data.export = useExport(string.strsplit('.', clientData.export))
        end

        clientData.image = setImagePath(clientData.image)

        if clientData.propTwo then
            clientData.prop = clientData.prop and { clientData.prop, clientData.propTwo } or clientData.propTwo
            clientData.propTwo = nil
        end
	end

    ::continue::
	ItemList[data.name] = data
end

for type, data in pairs(lib.load('data.weapons') or {}) do
	for k, v in pairs(data) do
		v.name = k
		v.close = type == 'Ammo' and true or false
        v.weight = v.weight or 0

		if type == 'Weapons' then
			---@cast v OxWeapon
			v.model = v.model or k -- actually weapon type or such? model for compatibility
			v.hash = joaat(v.model)
			v.stack = v.throwable and true or false
			v.durability = v.durability or 0.05
			v.weapon = true
		else
			v.stack = true
		end

		v[type == 'Ammo' and 'ammo' or type == 'Components' and 'component' or type == 'Tints' and 'tint' or 'weapon'] = true

		if isServer then v.client = nil else
			v.count = 0
			v.server = nil
			local clientData = v.client

			if clientData?.image then
                clientData.image = setImagePath(clientData.image)
			end
		end

		ItemList[k] = v
	end
end

for k, v in pairs(lib.load('data.items') or {}) do
	v.name = k
	local success, response = pcall(newItem, v)

    if not success then
        warn(('An error occurred while creating item "%s" callback!\n^1SCRIPT ERROR: %s^0'):format(k, response))
    end
end

ItemList.cash = ItemList.money

return ItemList
