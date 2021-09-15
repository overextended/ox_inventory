local M = {}
local Items <const>, Weapons <const> = table.unpack(module('items', true))

local GetItem = function(item)
	local type
	if item then
		item = string.lower(item)
		if item:find('weapon_') then type, item = 1, string.upper(item)
		elseif item:find('ammo-') then type = 2
		elseif item:sub(0, 3) == 'at_' then type = 3 end
		return Items[item] or false, type
	end
	return M
end

local metatable = setmetatable(M, {
	__call = function(self, item)
		if item then return GetItem(item) end
		return self
	end
})

CreateThread(function()
	if ESX == nil or SetInterval == nil then return ox.error('Unable to locate dependencies - refer to the documentation') end
	local OneSync = GetConvar('onesync_enabled', false) == 'true'
	local Infinity = GetConvar('onesync_enableInfinity', false) == 'true'
	if not OneSync and not Infinity then return ox.error('OneSync is not enabled on this server - refer to the documentation')
	elseif Infinity then ox.info('Server is running OneSync Infinity') else ox.info('Server is running OneSync Legacy') end
	local items = exports.oxmysql:fetchSync('SELECT * FROM items', {})
	if items then
		local query = {}
		for i=1, #items do
			local v = items[i]
			if i == 1 then query[i] = "DELETE FROM items WHERE name = '"..v.name.."'"
			else query[i] = "OR name='"..v.name.."'" end
			v.close = v.closeonuse or true
			v.stack = v.stackable or true
			v.description = v.description or ''
			v.weight = v.weight or 0
			Items[v.name] = v
		end
		if next(query) then
			query = table.concat(query, ' ')
			local sql = io.open(GetResourcePath(ox.name):gsub('//', '/')..'/setup/dump.sql', 'a+')
			local file = io.open(GetResourcePath(ox.name):gsub('//', '/')..'/data/items.lua', 'a+')
			local dump, dump2 = {}, {}
			for i=1, #items do
				local i = items[i]
				table.insert(dump, "('"..i.name.."', ".."'"..i.name.."', "..i.weight.."),\n")
				table.insert(dump2, [[

	Data[']]..i.name..[['] = {
		label = ']]..i.label..[[',
		weight = ]]..tonumber(i.weight)..[[,
		stack = ]]..tostring(i.stackable)..[[,
		close = ]]..tostring(i.closeonuse)..[[,
		description = ']]..tostring(i.description)..[['
	}
	]])
			end
			sql:write(table.concat(dump))
			file:write(table.concat(dump2))
			sql:close()
			file:close()
			exports.oxmysql:execute(query, {
			}, function(result)
				if result > 0 then
					ox.info('Removed', result, 'items from the database')
				end
			end)
		end
	end
	Wait(2000)
	TriggerEvent('ox_inventory:itemList', Items)
	if Config.DBCleanup then exports.oxmysql:executeSync('DELETE FROM ox_inventory WHERE lastupdated < (NOW() - INTERVAL '..Config.DBCleanup..') OR data = "[]"') end
	ESX.UsableItemsCallbacks = ESX.GetUsableItems()
	local count = 0
	for k, v in pairs(Items) do
		if v.consume and v.consume > 0 and ESX.UsableItemsCallbacks[v.name] then ESX.UsableItemsCallbacks[v.name] = nil end
		count += 1
	end
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

local GenerateText = function(num)
	local str
	repeat str = {}
		for i=1, num do str[i] = string.char(math.random(65, 90)) end
		str = table.concat(str)
	until str ~= 'POL' and str ~= 'EMS'
	return str
end

local GenerateSerial = function(text)
	text = text == nil and GenerateText(3) or text:len() > 3 and text
	return ('%s%s%s'):format(math.random(100000,999999), text, math.random(100000,999999))
end

M.Metadata = function(xPlayer, item, metadata, count)
	local isWeapon = item.name:find('WEAPON_')
	if isWeapon == nil then metadata = metadata == nil and {} or type(metadata) == 'string' and {type=metadata} or metadata end
	if isWeapon then
		if not item.ammoname then
			metadata = {}
			if not item.throwable then count, metadata.durability = 1, 100 end
		else
			count = 1
			if type(metadata) ~= 'table' then metadata = {} end
			if not metadata.durability then metadata.durability = 100 end
			if item.ammoname then metadata.ammo = 0 end
			if not metadata.components then metadata.components = {} end
			if metadata.registered ~= false then
				metadata.registered = xPlayer.name
				metadata.serial = GenerateSerial(metadata.serial)
			end
		end
	elseif item.name:find('identification') then
		count = 1
		if next(metadata) == nil then
			metadata = {}
			metadata.type = xPlayer.name
			metadata.description = ('Sex: %s\nDate of birth: %s'):format((xPlayer.variables.sex or xPlayer.sex) and ox.locale('male') or ox.locale('female'), xPlayer.variables.dateofbirth or xPlayer.dateofbirth)
		end
	elseif item.name:find('paperbag') then
		count = 1
		metadata = {}
		metadata.container = GenerateText(3)..os.time(os.date('!*t'))
		metadata.size = {5, 1000}
	elseif item.name:find('burger') then
		metadata.durability = os.time(os.date('!*t'))+36
	end
	return metadata, count
end

exports('Items', GetItem)
return M