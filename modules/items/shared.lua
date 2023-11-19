local function useExport(resource, export)
	return function(...)
		return exports[resource][export](nil, ...)
	end
end

local ItemList = {}
local isServer = IsDuplicityVersion()

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
		data.client = nil

		if serverData?.export then
			data.cb = useExport(string.strsplit('.', serverData.export))
		end

		if not data.durability then
			if data.degrade or (data.consume and data.consume ~= 0 and data.consume < 1) then
				data.durability = true
			end
		end
	else
		data.server = nil
		data.count = 0

		if clientData?.export then
			data.export = useExport(string.strsplit('.', clientData.export))
		end

		if clientData?.image then
			clientData.image = clientData.image:match('^[%w]+://') and clientData.image or ('%s/%s'):format(client.imagepath, clientData.image)
		end
	end

	ItemList[data.name] = data
end

---@param resourceName string
---@return table?
local function getExternalItems(resourceName)
    local num = GetNumResourceMetadata(resourceName, "ox_inventory_items")
    if num < 1 then return end
    for i=0, num-1 do
        local file = GetResourceMetadata(resourceName, "ox_inventory_items", i)
        local path = ("@%s.%s"):format(resourceName, file:gsub(".lua", ""):gsub("/", "."))
        local items = require(path)
        if not items or type(items) ~= "table" then
            return lib.print.warn(("Items from resource (%s) unable to load!"):format(resourceName))
        end
        return items
    end
end

local function registerExternalItems()
    local resourceItems = {}
    local items = {}
    for i=0, GetNumResources() do
        local resourceName = GetResourceByFindIndex(i)
        if not resourceName or not GetResourceState(resourceName):find("start") then goto skip end

        local externalItems = getExternalItems(resourceName)
        if not externalItems then goto skip end
        for name, info in pairs(externalItems) do
            if items[name] then
                lib.print.warn(("Resource (%s) unable to register item (%s) because it's already registered by the resource (%s)"):format(resourceName, name, resourceItems[name]))
            elseif ItemList[name] then
                lib.print.warn(("Failed to register item (%s) from resource (%s), item already exists in inventory item data file!"):format(name, resourceName))
            else
                if not info.name then
                    info.name = name
                end
                local success, response = pcall(newItem, info)
                if not success then
                    warn(('An error occurred while creating item "%s" callback!\n^1SCRIPT ERROR: %s^0'):format(k, response))
                else
                    resourceItems[name] = resourceName
                    items[name] = info
                    lib.print.debug(("Successfully registered item (%s) from resource (%s)"):format(name, resourceName))
                end
            end
        end

        ::skip::
    end
end

for type, data in pairs(data('weapons')) do
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
				clientData.image = clientData.image:match('^[%w]+://') and ('url(%s)'):format(clientData.image) or ('url(%s/%s)'):format(client.imagepath, clientData.image)
			end
		end

		ItemList[k] = v
	end
end

for k, v in pairs(data 'items') do
	v.name = k
	local success, response = pcall(newItem, v)

    if not success then
        warn(('An error occurred while creating item "%s" callback!\n^1SCRIPT ERROR: %s^0'):format(k, response))
    end
end

registerExternalItems()
ItemList.cash = ItemList.money

return ItemList
