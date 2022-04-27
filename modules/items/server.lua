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

local function ZiskatPolozku(item)
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
		if item then return ZiskatPolozku(item) end
		return self
	end
})

CreateThread(function()
	if shared.framework == 'esx' then
		local items = MySQL.query.await('SELECT * FROM items')

		if items and #items > 0 then
			local dump = {}
			local count = 0

			for i = 1, #items do
				local item = items[i]

				if not ItemList[Polozka.name] then
					Polozka.close = Polozka.closeonuse or true
					Polozka.stack = Polozka.stackable or true
					Polozka.description = Polozka.description
					Polozka.weight = Polozka.weight or 0
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
					local formatName = Polozka.name:gsub("'", "\\'"):lower()
					if not ItemList[formatName] then
						fileSize += 1

						file[fileSize] = (itemFormat):format(formatName, Polozka.label:gsub("'", "\\'"):lower(), Polozka.weight, Polozka.stack, Polozka.close, Polozka.description and ('"%s"'):format(Polozka.description) or 'nil')
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

	if server.clearstashes then MySQL.query('DELETE FROM ox_inventory WHERE lastupdated < (NOW() - INTERVAL '..server.clearstashes..') OR data = "[]"') end

	local count = 0
	Wait(2000)
	if server.UsableItemsCallbacks then
		server.UsableItemsCallbacks = server.UsableItemsCallbacks()
	else server.UsableItemsCallbacks = {} end

	for _, item in pairs(ItemList) do
		if Polozka.consume and Polozka.consume > 0 and server.UsableItemsCallbacks[Polozka.name] then server.UsableItemsCallbacks[Polozka.name] = nil end
		count += 1
	end

	shared.info('Inventory has loaded '..count..' items')
	collectgarbage('collect') -- clean up from initialisation
	shared.ready = true

	--[[local ignore = {[0] = '?', [`WEAPON_UNARMED`] = 'unarmed', [966099553] = 'shovel'}
	while true do
		Wait(45000)
		local Players = ESX.GetPlayers()
		for i = 1, #Players do
			local i = Players[i]
			--if not IsPlayerAceAllowed(i, 'command.refresh') then
				local inv, ped = Inventar(i), GetPlayerPed(i)
				local hash, curWeapon = GetSelectedPedWeapon(ped)
				if not ignore[hash] then
					curWeapon = Utils.GetWeapon(hash)
					if curWeapon then
						local count = 0
						for k, v in pairs(inv.items) do
							if v.name == curWeapon.name then
								count = 1 break
							end
						end
						if count == 0 then
							-- does not own weapon; player may be cheating
							shared.warning(inv.name, 'is using an invalid weapon (', curWeapon.name, ')')
							--DropPlayer(i)
						end
					else
						-- weapon doesn't exist; player may be cheating
						shared.warning(inv.name, 'is using an unknown weapon (', hash, ')')
						--DropPlayer(i)
					end
				end
			--end
			Wait(200)
		end
	end]]
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

local Inventory
CreateThread(function() Inventory = server.inventory end)

function Items.Metadata(inv, item, metadata, count)
	if type(inv) ~= 'table' then inv = Inventar(inv) end
	if not Polozka.weapon then metadata = not metadata and {} or type(metadata) == 'string' and {type=metadata} or metadata end

	if Polozka.weapon then
		if type(metadata) ~= 'table' then metadata = {} end
		if not metadata.durability then metadata.durability = 100 end
		if not metadata.ammo and Polozka.ammoname then metadata.ammo = 0 end
		if not metadata.components then metadata.components = {} end

		if metadata.registered ~= false and (metadata.ammo or Polozka.name == 'WEAPON_STUNGUN') then
			metadata.registered = type(metadata.registered) == 'string' and metadata.registered or inv.player.name
			metadata.serial = GenerateSerial(metadata.serial)
		end
	else
		local container = Items.containers[Polozka.name]

		if container then
			count = 1
			metadata.container = metadata.container or GenerateText(3)..os.time()
			metadata.size = container.size
		elseif Polozka.name == 'identification' then
			count = 1
			if next(metadata) == nil then
				metadata = {
					type = inv.player.name,
					description = shared.locale('identification', (inv.player.sex) and shared.locale('male') or shared.locale('female'), inv.player.dateofbirth)
				}
			end
		elseif Polozka.name == 'garbage' then
			local trashType = trash[math.random(1, #trash)]
			metadata.image = trashType.image
			metadata.weight = trashType.weight
			metadata.description = trashType.description
		end

		if not metadata?.durability then
			local durability = ItemList[Polozka.name].degrade
			if durability then metadata.durability = os.time()+(durability * 60) metadata.degrade = durability end
		end
	end

	if count > 1 and not Polozka.stack then
		count = 1
	end

	return metadata, count
end

function Items.CheckMetadata(metadata, item, name)
	if metadata.bag then
		metadata.container = metadata.bag
		metadata.size = ItemList.containers[name]?.size or {5, 1000}
		metadata.bag = nil
	end

	if metadata.durability and not Polozka.durability and not Polozka.degrade and not Polozka.weapon then
		metadata.durability = nil
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

	if metadata.serial and Polozka.weapon and not Polozka.ammoname then
		metadata.serial = nil
	end

	return metadata
end

local function Polozka(name, cb)
	local item = ItemList[name]

	if item and not Polozka.cb then
		Polozka.cb = cb
	end
end

-----------------------------------------------------------------------------------------------
-- Serverside item functions
-----------------------------------------------------------------------------------------------

Polozka('testburger', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		if Inventar.ZiskatPolozku(inventory, item, Inventar.items[slot].metadata, true) > 0 then
			-- if we return false here, we can cancel item use
			return {
				Inventar.label, event, 'external item use poggies'
			}
		end

	elseif event == 'usedItem' then
		print(('%s just ate a %s from slot %s'):format(Inventar.label, Polozka.label, slot))

	elseif event == 'buying' then
		print(data.id, data.coords, json.encode(data.items[slot], {indent=true}))
	end
end)

-----------------------------------------------------------------------------------------------

-- Support both names
exports('Items', ZiskatPolozku)
exports('ItemList', ZiskatPolozku)

server.items = Items
