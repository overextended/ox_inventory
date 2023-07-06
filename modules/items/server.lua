if not lib then return end

local Items = {}
local ItemList = require 'modules.items.shared' --[[@as table<string, OxServerItem>]]
local Utils = require 'modules.utils.server'

TriggerEvent('ox_inventory:itemList', ItemList)

Items.containers = require 'modules.items.containers'

-- Possible metadata when creating garbage
local trash = {
	{description = 'An old rolled up newspaper.', weight = 200, image = 'trash_newspaper'},
	{description = 'A discarded burger shot carton.', weight = 50, image = 'trash_burgershot'},
	{description = 'An empty soda can.', weight = 20, image = 'trash_can'},
	{description = 'A mouldy piece of bread.', weight = 70, image = 'trash_bread'},
	{description = 'An empty ciggarette carton.', weight = 10, image = 'trash_fags'},
	{description = 'A slightly used pair of panties.', weight = 20, image = 'panties'},
	{description = 'An empty coffee cup.', weight = 20, image = 'trash_coffee'},
	{description = 'A crumpled up piece of paper.', weight = 5, image = 'trash_paper'},
	{description = 'An empty chips bag.', weight = 5, image = 'trash_chips'},
}

---@param _ table?
---@param name string?
---@return table?
local function getItem(_, name)
    if not name then return ItemList end

	if type(name) ~= 'string' then return end

    name = name:lower()

    if name:sub(0, 7) == 'weapon_' then
        name = name:upper()
    end

    return ItemList[name]
end

setmetatable(Items --[[@as table]], {
	__call = getItem
})

---@cast Items +fun(itemName: string): OxServerItem
---@cast Items +fun(): table<string, OxServerItem>

-- Support both names
exports('Items', function(item) return getItem(nil, item) end)
exports('ItemList', function(item) return getItem(nil, item) end)

local Inventory

CreateThread(function()
	Inventory = require 'modules.inventory.server'

	if shared.framework == 'esx' then
		local success, items = pcall(MySQL.query.await, 'SELECT * FROM items')

		if success and items and next(items) then
			local dump = {}
			local count = 0

			for i = 1, #items do
				local item = items[i]

				if not ItemList[item.name] then
					item.close = item.closeonuse == nil and true or item.closeonuse
					item.stack = item.stackable == nil and true or item.stackable
					item.description = item.description
					item.weight = item.weight or 0
					dump[i] = item
					count += 1
				end
			end

			if table.type(dump) ~= "empty" then
				local file = {string.strtrim(LoadResourceFile(shared.resource, 'data/items.lua'))}
				file[1] = file[1]:gsub('}$', '')

				---@todo separate into functions for reusability, properly handle nil values
				local itemFormat = [[

	[%q] = {
		label = %q,
		weight = %s,
		stack = %s,
		close = %s,
		description = %q
	},
]]
				local fileSize = #file

				for _, item in pairs(dump) do
					if not ItemList[item.name] then
						fileSize += 1

						local itemStr = itemFormat:format(item.name, item.label, item.weight, item.stack, item.close, item.description and json.encode(item.description) or 'nil')
						-- temporary solution for nil values
						itemStr = itemStr:gsub('[%s]-[%w]+ = "?nil"?,?', '')
						file[fileSize] = itemStr
						ItemList[item.name] = item
					end
				end

				file[fileSize+1] = '}'

				SaveResourceFile(shared.resource, 'data/items.lua', table.concat(file), -1)
				shared.info(count, 'items have been copied from the database.')
				shared.info('You should restart the resource to load the new items.')
			end

			shared.info('Database contains', #items, 'items.')
		end

		Wait(500)

	elseif shared.framework == 'qb' then
		local QBCore = exports['qb-core']:GetCoreObject()
		local items = QBCore.Shared.Items

		if items and table.type(items) ~= 'empty' then
			local dump = {}
			local count = 0
			local ignoreList = {
				"weapon_",
				"pistol_",
				"pistol50_",
				"revolver_",
				"smg_",
				"combatpdw_",
				"shotgun_",
				"rifle_",
				"carbine_",
				"gusenberg_",
				"sniper_",
				"snipermax_",
				"tint_",
				"_ammo"
			}

			local function checkIgnoredNames(name)
				for i = 1, #ignoreList do
					if string.find(name, ignoreList[i]) then
						return true
					end
				end
				return false
			end

			for k, item in pairs(items) do
				-- Explain why this wouldn't be table to me, because numerous people have been getting "attempted to index number" here
				if type(item) == 'table' then
					-- Some people don't assign the name property, but it seemingly always matches the index anyway.
					if not item.name then item.name = k end

					if not ItemList[item.name] and not checkIgnoredNames(item.name) then
						item.close = item.shouldClose == nil and true or item.shouldClose
						item.stack = not item.unique and true
						item.description = item.description
						item.weight = item.weight or 0
						dump[k] = item
						count += 1
					end
				end
			end

			if table.type(dump) ~= 'empty' then
				local file = {string.strtrim(LoadResourceFile(shared.resource, 'data/items.lua'))}
				file[1] = file[1]:gsub('}$', '')

				---@todo separate into functions for reusability, properly handle nil values
				local itemFormat = [[

	[%q] = {
		label = %q,
		weight = %s,
		stack = %s,
		close = %s,
		description = %q,
		client = {
			status = {
				hunger = %s,
				thirst = %s,
				stress = %s
			},
			image = %q,
		}
	},
]]

				local fileSize = #file

				for _, item in pairs(dump) do
					if not ItemList[item.name] then
						fileSize += 1

						---@todo cry
						local itemStr = itemFormat:format(item.name, item.label, item.weight, item.stack, item.close, item.description or 'nil', item.hunger or 'nil', item.thirst or 'nil', item.stress or 'nil', item.image or 'nil')
						-- temporary solution for nil values
						itemStr = itemStr:gsub('[%s]-[%w]+ = "?nil"?,?', '')
						-- temporary solution for empty status table
						itemStr = itemStr:gsub('[%s]-[%w]+ = %{[%s]+%},?', '')
						-- temporary solution for empty client table
						itemStr = itemStr:gsub('[%s]-[%w]+ = %{[%s]+%},?', '')
						file[fileSize] = itemStr
						ItemList[item.name] = item
					end
				end

				file[fileSize+1] = '}'

				SaveResourceFile(shared.resource, 'data/items.lua', table.concat(file), -1)
				shared.info(count, 'items have been copied from the QBCore.Shared.Items.')
				shared.info('You should restart the resource to load the new items.')
			end
		end

		Wait(500)
	end

	local count = 0

	Wait(1000)

	for _ in pairs(ItemList) do
		count += 1
	end

	shared.info(('Inventory has loaded %d items'):format(count))
	collectgarbage('collect') -- clean up from initialisation
	shared.ready = true
end)

local function GenerateText(num)
	local str
	repeat str = {}
		for i = 1, num do str[i] = string.char(math.random(65, 90)) end
		str = table.concat(str)
	until str ~= 'POL' and str ~= 'EMS'
	return str
end

local function GenerateSerial(text)
	if text and text:len() > 3 then
		return text
	end

	return ('%s%s%s'):format(math.random(100000,999999), text == nil and GenerateText(3) or text, math.random(100000,999999))
end

local function setItemDurability(item, metadata)
	local degrade = item.degrade

	if degrade then
		metadata.durability = os.time()+(degrade * 60)
		metadata.degrade = degrade
	elseif item.durability then
		metadata.durability = 100
	end

	return metadata
end

local TriggerEventHooks = require 'modules.hooks.server'

---@param inv inventory
---@param item OxServerItem
---@param metadata any
---@param count number
---@return table, number
---Generates metadata for new items being created through AddItem, buyItem, etc.
function Items.Metadata(inv, item, metadata, count)
	if type(inv) ~= 'table' then inv = Inventory(inv) end
	if not item.weapon then metadata = not metadata and {} or type(metadata) == 'string' and {type=metadata} or metadata end
	if not count then count = 1 end

	---@cast metadata table<string, any>

	if item.weapon then
		if type(metadata) ~= 'table' then metadata = {} end
		if not metadata.durability then metadata.durability = 100 end
		if not metadata.ammo and item.ammoname then metadata.ammo = 0 end
		if not metadata.components then metadata.components = {} end

		if metadata.registered ~= false and (metadata.ammo or item.name == 'WEAPON_STUNGUN') then
			local registered = type(metadata.registered) == 'string' and metadata.registered or inv?.player?.name

			if registered then
				metadata.registered = registered
				metadata.serial = GenerateSerial(metadata.serial)
			else
				metadata.registered = nil
			end
		end

		if item.hash == `WEAPON_PETROLCAN` or item.hash == `WEAPON_HAZARDCAN` or item.hash == `WEAPON_FERTILIZERCAN` or item.hash == `WEAPON_FIREEXTINGUISHER` then
			metadata.ammo = metadata.durability
		end
	else
		local container = Items.containers[item.name]

		if container then
			count = 1
			metadata.container = metadata.container or GenerateText(3)..os.time()
			metadata.size = container.size
		elseif not next(metadata) then
			if item.name == 'identification' then
				count = 1
				metadata = {
					type = inv.player.name,
					description = locale('identification', (inv.player.sex) and locale('male') or locale('female'), inv.player.dateofbirth)
				}
			elseif item.name == 'garbage' then
				local trashType = trash[math.random(1, #trash)]
				metadata.image = trashType.image
				metadata.weight = trashType.weight
				metadata.description = trashType.description
			end
		end

		if not metadata.durability then
			metadata = setItemDurability(ItemList[item.name], metadata)
		end
	end

	if count > 1 and not item.stack then
		count = 1
	end

	local response = TriggerEventHooks('createItem', {
		inventoryId = inv and inv.id,
		metadata = metadata,
		item = item,
		count = count,
	})

	if type(response) == 'table' then
		metadata = response
	end

	if metadata.imageurl and Utils.IsValidImageUrl then
		if Utils.IsValidImageUrl(metadata.imageurl) then
			Utils.DiscordEmbed('Valid image URL', ('Created item "%s" (%s) with valid url in "%s".\n%s\nid: %s\nowner: %s'):format(metadata.label or item.label, item.name, inv.label, metadata.imageurl, inv.id, inv.owner, metadata.imageurl), metadata.imageurl, 65280)
		else
			Utils.DiscordEmbed('Invalid image URL', ('Created item "%s" (%s) with invalid url in "%s".\n%s\nid: %s\nowner: %s'):format(metadata.label or item.label, item.name, inv.label, metadata.imageurl, inv.id, inv.owner, metadata.imageurl), metadata.imageurl, 16711680)
			metadata.imageurl = nil
		end
	end

	return metadata, count
end

---@param metadata table<string, any>
---@param item OxServerItem
---@param name string
---@param ostime number
---Validate (and in some cases convert) item metadata when an inventory is being loaded.
function Items.CheckMetadata(metadata, item, name, ostime)
	if metadata.bag then
		metadata.container = metadata.bag
		metadata.size = Items.containers[name]?.size or {5, 1000}
		metadata.bag = nil
	end

	local durability = metadata.durability

	if durability then
		if durability > 100 and ostime >= durability then
			metadata.durability = 0
		end
	else
		metadata = setItemDurability(item, metadata)
	end

	if item.weapon then
		if metadata.components then
			if table.type(metadata.components) == 'array' then
				for i = #metadata.components, 1, -1 do
					if not ItemList[metadata.components[i]] then
						table.remove(metadata.components, i)
					end
				end
			else
				local components = {}
				local size = 0

				for _, component in pairs(metadata.components) do
					if component and ItemList[component] then
						size += 1
						components[size] = component
					end
				end

				metadata.components = components
			end
		end

		if metadata.serial and item.throwable then
			metadata.serial = nil
		end

		if metadata.specialAmmo and type(metadata.specialAmmo) ~= 'string' then
			metadata.specialAmmo = nil
		end
	end

	return metadata
end

---Update item durability, and call `Inventory.RemoveItem` if it was removed from decay.
---@param inv OxInventory
---@param slot SlotWithItem
---@param item OxServerItem
---@param value? number
---@param ostime? number
---@return boolean? removed
function Items.UpdateDurability(inv, slot, item, value, ostime)
    local durability = slot.metadata.durability

    if not durability then return end

    if value then
        durability = value
    elseif ostime and durability > 100 and ostime >= durability then
        durability = 0
    end

    if item.decay and durability == 0 then
        return Inventory.RemoveItem(inv, slot.name, slot.count, nil, slot.slot)
    end

    if slot.metadata.durability == durability then return end

    inv.changed = true
    slot.metadata.durability = durability

    inv:syncSlotsWithClients({
        {
            item = slot,
            inventory = inv.id
        }
    }, { left = inv.weight }, true)
end

local function Item(name, cb)
	local item = ItemList[name]

	if item and not item.cb then
		item.cb = cb
	end
end

-----------------------------------------------------------------------------------------------
-- Serverside item functions
-----------------------------------------------------------------------------------------------

-- Item('testburger', function(event, item, inventory, slot, data)
-- 	if event == 'usingItem' then
-- 		if Inventory.GetItem(inventory, item, inventory.items[slot].metadata, true) > 0 then
-- 			-- if we return false here, we can cancel item use
-- 			return {
-- 				inventory.label, event, 'external item use poggies'
-- 			}
-- 		end

-- 	elseif event == 'usedItem' then
-- 		print(('%s just ate a %s from slot %s'):format(inventory.label, item.label, slot))

-- 	elseif event == 'buying' then
-- 		print(data.id, data.coords, json.encode(data.items[slot], {indent=true}))
-- 	end
-- end)

-----------------------------------------------------------------------------------------------

return Items
