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

	shared.items = ItemList

	for k, v in pairs(data 'items') do
		v.name = k
		newItem(v)
	end
end
