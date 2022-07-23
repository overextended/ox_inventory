if not lib then return end

local Items = {}
local ItemList = shared.items

TriggerEvent('ox_inventory:itemList', ItemList)

-- Slot count and maximum weight for containers
-- Whitelist and blacklist: ['item_name'] = true
Items.containers = {
	['paperbag'] = {
		size = {5, 1000},
		blacklist = {
			['testburger'] = true -- No burgers!
		}
	},
	['pizzabox'] = {
		size = {1, 1000},
		whitelist = {
			['pizza'] = true -- Pizza box for pizza only
		}
	}
}

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

local function GetItem(item)
	if item then
		item = string.lower(item)

		if item:sub(0, 7) == 'weapon_' then
			item = string.upper(item)
		end

		return ItemList[item] or false, type
	end

	return ItemList
end

setmetatable(Items, {
	__call = function(self, item)
		if item then return GetItem(item) end
		return self
	end
})

local Inventory

CreateThread(function()
	Inventory = server.inventory

	if shared.framework == 'esx' then
		local success, items = pcall(MySQL.query.await, 'SELECT * FROM items')

		if success and #items > 0 then
			local dump = {}
			local count = 0

			for i = 1, #items do
				local item = items[i]

				if not ItemList[item.name] then
					item.close = item.closeonuse or true
					item.stack = item.stackable or true
					item.description = item.description
					item.weight = item.weight or 0
					dump[i] = item
					count += 1
				end
			end

			if next(dump) then
				local file = {string.strtrim(LoadResourceFile(shared.resource, 'data/items.lua'))}
				file[1] = file[1]:gsub('}$', '')

				local itemFormat = [[

	['%s'] = {
		label = '%s',
		weight = %s,
		stack = %s,
		close = %s,
		description = %s
	},
]]
				local fileSize = #file

				for _, item in pairs(items) do
					local formatName = item.name:gsub("'", "\\'"):lower()
					if not ItemList[formatName] then
						fileSize += 1

						file[fileSize] = (itemFormat):format(formatName, item.label:gsub("'", "\\'"):lower(), item.weight, item.stack, item.close, item.description and ('"%s"'):format(item.description) or 'nil')
						ItemList[formatName] = v
					end
				end

				file[fileSize+1] = '}'

				SaveResourceFile(shared.resource, 'data/items.lua', table.concat(file), -1)
				shared.info(count, 'items have been copied from the database')
			end

			shared.warning('Database contains', #items, 'items.')
			shared.warning('These items should be removed, and any queries for items should instead reference ESX.Items')
			shared.warning('These entries are no longer removed to satisfy the creators of obfuscated and encrypted resources.')
			shared.warning('Note: Any items that exist in item data and not the database will not work in said resources.')
			shared.warning('Apparently indexing ESX.Items is too big brain, or something.')
		end
	end

	local clearStashes = GetConvar('inventory:clearstashes', '6 MONTH')

	if clearStashes ~= '' then
		MySQL.query(('DELETE FROM ox_inventory WHERE lastupdated < (NOW() - INTERVAL %s) OR data = "[]"'):format(clearStashes))
	end

	local count = 0

	Wait(1500)

	for _, item in pairs(ItemList) do
		if item.consume and item.consume > 0 and server.UsableItemsCallbacks and server.UsableItemsCallbacks[item.name] then
			server.UsableItemsCallbacks[item.name] = nil
		end

		count += 1
	end

	shared.info('Inventory has loaded '..count..' items')
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

function Items.Metadata(inv, item, metadata, count)
	if type(inv) ~= 'table' then inv = Inventory(inv) end
	if not item.weapon then metadata = not metadata and {} or type(metadata) == 'string' and {type=metadata} or metadata end

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

		if item.hash == `WEAPON_PETROLCAN` or item.hash == `WEAPON_HAZARDCAN` or item.hash == `WEAPON_FIREEXTINGUISHER` then
			metadata.ammo = metadata.durability
		end
	else
		local container = Items.containers[item.name]

		if container then
			count = 1
			metadata.container = metadata.container or GenerateText(3)..os.time()
			metadata.size = container.size
		elseif item.name == 'identification' then
			count = 1
			if next(metadata) == nil then
				metadata = {
					type = inv.player.name,
					description = shared.locale('identification', (inv.player.sex) and shared.locale('male') or shared.locale('female'), inv.player.dateofbirth)
				}
			end
		elseif item.name == 'garbage' then
			local trashType = trash[math.random(1, #trash)]
			metadata.image = trashType.image
			metadata.weight = trashType.weight
			metadata.description = trashType.description
		end

		if not metadata?.durability then
			local durability = ItemList[item.name].degrade
			if durability then metadata.durability = os.time()+(durability * 60) metadata.degrade = durability end
		end
	end

	if count > 1 and not item.stack then
		count = 1
	end

	return metadata, count
end

function Items.CheckMetadata(metadata, item, name, ostime)
	if metadata.bag then
		metadata.container = metadata.bag
		metadata.size = ItemList.containers[name]?.size or {5, 1000}
		metadata.bag = nil
	end

	local durability = metadata.durability

	if durability then
		if not item.durability and not item.degrade and not item.weapon then
			metadata.durability = nil
		elseif durability > 100 and ostime >= durability then
			metadata.durability = 0
		end
	end

	if metadata.components then
		if table.type(metadata.components) == 'array' then
			for i = 1, #metadata.components do
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

	if metadata.serial and item.weapon and not item.ammoname then
		metadata.serial = nil
	end

	return metadata
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

Item('testburger', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		if Inventory.GetItem(inventory, item, inventory.items[slot].metadata, true) > 0 then
			-- if we return false here, we can cancel item use
			return {
				inventory.label, event, 'external item use poggies'
			}
		end

	elseif event == 'usedItem' then
		print(('%s just ate a %s from slot %s'):format(inventory.label, item.label, slot))

	elseif event == 'buying' then
		print(data.id, data.coords, json.encode(data.items[slot], {indent=true}))
	end
end)

-----------------------------------------------------------------------------------------------

-- Support both names
exports('Items', GetItem)
exports('ItemList', GetItem)

server.items = Items
