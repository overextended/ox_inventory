---wip types

---@class OxItem
---@field name string
---@field label string
---@field weight number Weight of the item in grams.
---@field description? string Text to display in the item tooltip.
---@field consume? number Number of items to remove on use.<br>Using a value under 1 will remove durability, if the item cannot be stacked.
---@field degrade? number Amount of time for the item durability to degrade to 0, in minutes.
---@field stack? boolean Set to false to prevent the item from stacking.
---@field close? boolean Set to false to keep the inventory open on item use.
---@field allowArmed? boolean Set to true to allow an item to be used while a weapon is equipped.
---@field buttons? { label: string, action: fun(slot: number) }[] Add interactions when right-clicking an item.
---@field [string] any

---@class OxClientProps
---@field status? { [string]: number }
---@field anim? string | { dict?: string, clip: string, flag?: number, blendIn?: number, blendOut?: number, duration?: number, playbackRate?: number, lockX?: boolean, lockY?: boolean, lockZ?: boolean, scenario?: string, playEnter?: boolean }
---@field prop? string | ProgressPropProps
---@field usetime? number
---@field label? string
---@field useWhileDead? boolean
---@field canCancel? boolean
---@field disable? { move?: boolean, car?: boolean, combat?: boolean, mouse?: boolean }
---@field export string
---@field [string] any

---@class OxClientItem : OxItem
---@field client? OxClientProps

---@class OxServerItem : OxItem
---@field server? { export: string, [string]: any }

---@class OxWeapon : OxItem
---@field hash number
---@field durability number
---@field weapon? true
---@field ammo? true
---@field component? true
---@field throwable? boolean
---@field model? string

GlobalState.NewUsableItem = {}

local function useExport(resource, export)
	return function(...)
		return exports[resource][export](nil, ...)
	end
end

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

	local client, server = data.client, data.server
	---@cast client -nil
	---@cast server -nil

	if not data.consume and (client and (client.status or client.usetime or client.export) or server?.export) then
		data.consume = 1
	end

	if isServer then
		data.client = nil

		if server?.export then
			data.cb = useExport(string.strsplit('.', server.export))
		end

		if not data.durability then
			if data.degrade or (data.consume and data.consume ~= 0 and data.consume < 1) then
				data.durability = true
			end
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
				---@cast v OxWeapon
				v.hash = joaat(v.model or k)
				v.stack = v.throwable and true or false
				v.durability = v.durability or 1
				v.weapon = true
			else
				v.stack = true
			end

			v[type == 'Ammo' and 'ammo' or type == 'Components' and 'component' or type == 'Tints' and 'tint' or 'weapon'] = true

			if isServer then v.client = nil else
				v.count = 0
				v.server = nil
			end

			ItemList[k] = v
		end
	end
	
	--GlobalState.NewItemcache = nil
	shared.items = ItemList
	local itemdata = data('items')
	local itemcache = GlobalState.NewItemcache
	if IsDuplicityVersion and not itemcache then
		GlobalState.NewItemcache = {}
	elseif not IsDuplicityVersion and itemcache then
		for k,v in pairs(itemcache) do
			itemdata[k] = v
		end
	end
	for k, v in pairs(itemdata) do
		v.name = k
		newItem(v)
	end

	GlobalState.NewUsableItem = ItemList
	
	local AddUsableItem = function(name, data)
		if not name then return end
		if not data then return end
		if not data.label then return end
		if not weight then weight = 1 end
		if shared.items[name] then return end
		data.name = name
		newItem(lib.table.deepclone(data))
		if IsDuplicityVersion then
			server.updateitems(shared.items)
			server.updateserveritems(name,shared.items[name])
			server.updateserverinventory(name,shared.items[name])
			GlobalState.NewUsableItem = {name = name , item = data}
			local itemcache = GlobalState.NewItemcache
			shared.items[name].client = data.client
			itemcache[name] = shared.items[name]
			GlobalState.NewItemcache = itemcache
			local file = {string.strtrim(LoadResourceFile(shared.resource, 'data/items.lua'))}
			file[1] = file[1]:gsub('}$', '')
			local item = shared.items[name]
			local itemFormat = [[
	['%s'] = {
		label = '%s',
		weight = %s,
		stack = %s,
		close = %s,
		description = %s,
		client = %s,
	},
]]
			local fileSize = #file

			fileSize += 1
			local formatName = item.name:gsub("'", "\\'"):lower()
			file[fileSize] = (itemFormat):format(formatName, item.label:gsub("'", "\\'"):lower(), item.weight, item.stack, item.close, item.description and json.encode(item.description) or 'nil', item.client and tableFormatter(item.client) or 'nil')

			file[fileSize+1] = '}'
			SaveResourceFile(shared.resource, 'data/items.lua', table.concat(file), -1)
			shared.info(1, 'New item has been added')
		end
	end
	if IsDuplicityVersion then
		exports('AddUsableItem', AddUsableItem)
		-- @ Usage
		-- exports.ox_inventory:AddUsableItem('cheeseburger', {
		-- 	label = 'Cheese Burger',
		-- 	description = 'Burger with Cheese',
		-- 	weight = 1,
		-- 	client = {
		-- 		anim = 'eating',
		-- 		prop = 'burger',
		-- 		usetime = 2500,
		-- 		notification = 'You ate a delicious burger',
		-- 	}
		-- })
	else
		AddStateBagChangeHandler("NewUsableItem", "global", function(bagName, key, value)
			Wait(0)
			if not value then return end
			--shared.items[value.name] = value.item
			AddUsableItem(value.name,value.item)
			client.updateitems(shared.items)
			client.updateclientdata(shared.items)
		end)
		shared.GetItems = function()
			return shared.items
		end
	end

	tableFormatter = function(tbl, indent)
		if not indent then indent = 0 end
		local toprint = string.rep(" ", indent) .. "{\r\n"
		indent = indent + 12
		for k, v in pairs(tbl) do
			toprint = toprint .. string.rep(" ", indent)
			if (type(k) == "number") then
				toprint = toprint .. "[" .. k .. "] = "
			elseif (type(k) == "string") then
				toprint = toprint  .. k ..  "= "   
			end
			if (type(v) == "number") then
				toprint = toprint .. v .. ",\r\n"
			elseif (type(v) == "string") then
				toprint = toprint .. "\"" .. v .. "\",\r\n"
			elseif (type(v) == "table") then
				toprint = toprint .. tableFormatter(v, indent + 2) .. ",\r\n"
			else
				toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
			end
		end
		toprint = toprint .. string.rep(" ", indent-2) .. "}"
		return toprint
	end
end
