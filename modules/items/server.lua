local Items = {}
local ItemList = shared 'items'

-- Slot count and maximum weight for containers
ox.containers = {
	['paperbag'] = {5, 1000}
}

-- Items that can be found, with minimum and maxiumum count to be generated
ox.loottable = {
	{'cola', 0, 1},
	{'water', 0, 2},
	{'garbage', 0, 1},
	{'panties', 0, 1},
	{'money', 0, 50},
	{'bandage', 0, 1}
}

-- Separate loot table for dumpsters
ox.dumpsterloot = {
	{'mustard', 0, 1},
	{'garbage', 1, 3},
	{'panties', 0, 1},
	{'money', 0, 10},
	{'burger', 0, 1}
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
	local OneSync = GetConvar('onesync_enabled', false) == 'true'
	local Infinity = GetConvar('onesync_enableInfinity', false) == 'true'
	if not OneSync and not Infinity then return error('OneSync is not enabled on this server - refer to the documentation')
	elseif Infinity then ox.info('Server is running OneSync Infinity') else ox.info('Server is running OneSync Legacy') end
	local items = MySQL.Sync.fetchAll('SELECT * FROM items')
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
			local sql = LoadResourceFile(ox.resource, 'setup/dump.sql')
			if not sql then error('Unable to load "setup/dump.sql', 1) end
			local file = {string.strtrim(LoadResourceFile(ox.resource, 'data/items.lua'))}
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
				SaveResourceFile(ox.resource, 'setup/dump.sql', dump, -1)
			end
			SaveResourceFile(ox.resource, 'data/items.lua', table.concat(file), -1)
			MySQL.Async.execute(query, function(result)
				if result > 0 then
					ox.info('Removed '..result..' items from the database')
				end
			end)
			if items then ox.info(#items..' items have been copied from the database') end
		end
	end

	if ox.clearstashes then
		MySQL.Sync.fetchAll('DELETE FROM ox_inventory WHERE lastupdated < (NOW() - INTERVAL '..ox.clearstashes..') OR data = "[]"')
	end

	local count = 0
	Wait(2000)
	if ox.UsableItemsCallbacks then
		ox.UsableItemsCallbacks = ox.UsableItemsCallbacks()
	else ox.UsableItemsCallbacks = {} end

	for _, v in pairs(ItemList) do
		if v.consume and v.consume > 0 and ox.UsableItemsCallbacks[v.name] then ox.UsableItemsCallbacks[v.name] = nil end
		count += 1
	end

	TriggerEvent('ox_inventory:itemList', ItemList)
	ox.info('Inventory has loaded '..count..' items')
	collectgarbage('collect') -- clean up from initialisation
	ox.ready = true
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
							ox.warning(inv.name, 'is using an invalid weapon (', curWeapon.name, ')')
							--DropPlayer(i)
						end
					else
						-- weapon doesn't exist; player may be cheating
						ox.warning(inv.name, 'is using an unknown weapon (', hash, ')')
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
	text = text == nil and GenerateText(3) or text:len() > 3 and text
	return ('%s%s%s'):format(math.random(100000,999999), text, math.random(100000,999999))
end

local Inventory
CreateThread(function() Inventory = server.inventory end)

function Items.Metadata(inv, item, metadata, count)
	if type(inv) ~= 'table' then inv = Inventory(inv) end
	local isWeapon = item.name:find('WEAPON_')
	if isWeapon == nil then metadata = not metadata and {} or type(metadata) == 'string' and {type=metadata} or metadata end
	if isWeapon then
		if not item.ammoname then
			metadata = {}
			if not item.throwable then count, metadata.durability = 1, 100 end
		else
			count = 1
			if type(metadata) ~= 'table' then metadata = {} end
			if not metadata.durability then metadata.durability = 100 end
			if not metadata.ammo and item.ammoname then metadata.ammo = 0 end
			if not metadata.components then metadata.components = {} end
			if metadata.registered ~= false then
				metadata.registered = type(metadata.registered) == 'string' and metadata.registered or inv.name
				metadata.serial = metadata.serial or GenerateSerial(metadata.serial)
			end
		end
	else
		local container = ox.containers[item.name]
		if container then
			count = 1
			metadata = {
				container = GenerateText(3)..os.time(),
				size = container
			}
		elseif item.name == 'identification' then
			count = 1
			if next(metadata) == nil then
				metadata = {
					type = inv.name,
					description = ox.locale('identification', (inv.player.sex) and ox.locale('male') or ox.locale('female'), inv.player.dateofbirth)
				}
			end
		end
		if not metadata?.durability then
			local durability = ItemList[item.name].degrade
			if durability then metadata.durability = os.time()+(durability * 60) metadata.degrade = durability end
		end
	end
	return metadata, count
end

local function Item(name, cb)
	if ItemList[name] then Items[name] = cb end
end
-----------------------------------------------------------------------------------------------
-- Serverside item functions
-----------------------------------------------------------------------------------------------

Item('testburger', function(event, item, inventory, slot, data)
	if event == 'usingItem' then
		if Inventory.GetItem(inventory, item, inventory.items[slot].metadata, true) > 100 then
			return {
				inventory.label, inventory.owner, event,
				'so many delicious burgers'
			}
		end

	elseif event == 'usedItem' then
		print(('%s just ate a %s from slot %s'):format(inventory.label, item.label, slot))
		TriggerClientEvent('ox_inventory:notify', inventory.id, {text = item.server.test})

	elseif event == 'buying' then
		print(data.id, data.coords, json.encode(data.items[slot], {indent=true}))
	end
end)

-----------------------------------------------------------------------------------------------

-- Support both names
exports('Items', GetItem)
exports('ItemList', GetItem)

server.items = Items
