local Items = {}
local ItemList = items()

-- Slot count and maximum weight for containers
Items.containers = {
	['paperbag'] = {5, 1000}
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
		local type
		item = string.lower(item)
		if item:find('weapon_') then type, item = 1, string.upper(item)
		elseif item:find('ammo-') then type = 2
		elseif item:sub(0, 3) == 'at_' then type = 3 end
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

CreateThread(function()
	if shared.framework == 'esx' then
		local items = MySQL.query.await('SELECT * FROM items')
		if items then
			local query = {}
			for i=1, #items do
				local v = items[i]
				if i == 1 then query[i] = ('DELETE FROM items WHERE name = "%s"'):format(v.name) else query[i] = ('OR name = "%s"'):format(v.name) end
				v.name = v.name
				v.label = v.label
				v.close = v.closeonuse or true
				v.stack = v.stackable or true
				v.description = (v.description or '')
				v.weight = v.weight or 0
			end
			if next(query) then
				query = table.concat(query, ' ')
				local sql = LoadResourceFile(shared.resource, 'setup/dump.sql')
				if not sql then error('Unable to load "setup/dump.sql', 1) end
				local file = {string.strtrim(LoadResourceFile(shared.resource, 'data/items.lua'))}
				file[1] = file[1]:gsub('}$', '')
				local dump = {'INSERT INTO `items` (`name`, `label`, `weight`, `description`) VALUES'}
local itemFormat = [[

	['%s'] = {
		label = '%s',
		weight = %s,
		stack = %s,
		close = %s,
		description = '%s'
	},
]]
				local saveSql = false
				local dumpSize = #dump
				local fileSize = #file
				for _, v in pairs(items) do
					local formatName = v.name:gsub("'", "\\'"):lower()
					if not ItemList[formatName] then
						if not saveSql then saveSql = true end
						dumpSize += 1
						fileSize += 1
						dump[dumpSize] = ('\n	("%s", "%s", %s, "%s")'):format(v.name, v.label, v.weight, v.description)
						if dumpSize ~= 2 then dump[dumpSize] = ','..dump[dumpSize] end
						file[fileSize] = (itemFormat):format(formatName, v.label:gsub("'", "\\'"):lower(), v.weight, v.stack, v.close, v.description:gsub("'", "\\'"))
						ItemList[formatName] = v
					end
				end
				dump[dumpSize+1] = ';\n\n'
				file[fileSize+1] = '}'
				if saveSql then
					dump = ('%s%s'):format(sql, table.concat(dump))
					SaveResourceFile(shared.resource, 'setup/dump.sql', dump, -1)
				end
				SaveResourceFile(shared.resource, 'data/items.lua', table.concat(file), -1)
				MySQL.update(query, function(result)
					if result > 0 then
						shared.info('Removed '..result..' items from the database')
					end
				end)
				if items then shared.info(#items..' items have been copied from the database') end
			end
		end
	end

	if server.clearstashes then
		MySQL.query.await('DELETE FROM ox_inventory WHERE lastupdated < (NOW() - INTERVAL '..server.clearstashes..') OR data = "[]"')
	end

	local count = 0
	Wait(2000)
	if server.UsableItemsCallbacks then
		server.UsableItemsCallbacks = server.UsableItemsCallbacks()
	else server.UsableItemsCallbacks = {} end

	for _, v in pairs(ItemList) do
		if v.consume and v.consume > 0 and server.UsableItemsCallbacks[v.name] then server.UsableItemsCallbacks[v.name] = nil end
		count += 1
	end

	TriggerEvent('ox_inventory:itemList', ItemList)
	shared.info('Inventory has loaded '..count..' items')
	collectgarbage('collect') -- clean up from initialisation
	shared.ready = true
	--[[local ignore = {[0] = '?', [`WEAPON_UNARMED`] = 'unarmed', [966099553] = 'shovel'}
	while true do
		Wait(45000)
		local Players = ESX.GetPlayers()
		for i=1, #Players do
			local i = Players[i]
			--if not IsPlayerAceAllowed(i, 'command.refresh') then
				local inv, ped = Inventory(i), GetPlayerPed(i)
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
		for i=1, num do str[i] = string.char(math.random(65, 90)) end
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
	if type(inv) ~= 'table' then inv = Inventory(inv) end
	local isWeapon = item.name:find('WEAPON_')
	if not isWeapon then metadata = not metadata and {} or type(metadata) == 'string' and {type=metadata} or metadata end

	if isWeapon then
		if type(metadata) ~= 'table' then metadata = {} end
		if not metadata.durability then metadata.durability = 100 end
		if not metadata.ammo and item.ammoname then metadata.ammo = 0 end
		if not metadata.components then metadata.components = {} end

		if metadata.registered ~= false then
			metadata.registered = type(metadata.registered) == 'string' and metadata.registered or inv.player.name
			metadata.serial = GenerateSerial(metadata.serial)
		end
	else
		local container = Items.containers[item.name]

		if container then
			count = 1
			metadata.container = metadata.container or GenerateText(3)..os.time()
			metadata.size = container
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
