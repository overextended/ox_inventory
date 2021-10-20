local M = {}
local Items <const> = module('items', true)[1]

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

setmetatable(M, {
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
	local items = exports.oxmysql:fetchSync('SELECT * FROM items')
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
		end
		if next(query) then
			query = table.concat(query, ' ')
			local sql = io.open(GetResourcePath(ox.name):gsub('//', '/')..'/setup/dump.sql', 'a+')
			if not sql then error('Unable to open "setup/dump.sql - check file system permissions', 1) end
			local file = {LoadResourceFile(ox.name, 'data/items.lua')}
			file[1] = file[1]:gsub('}$', '')
			local dump = {}
local itemFormat = [[

	['%s'] = {
		label = %s,
		weight = %s,
		stack = %s,
		close = %s,
		description = '%s'
	},
]]
			for _, v in pairs(items) do
				if not Items[v.name] then
					dump[#dump+1] = ("('%s', '%s', %s),\n"):format(v.name, v.label, v.weight)
					file[#file+1] = (itemFormat):format(v.name, v.label, v.weight, v.stack, v.close, v.description)
					Items[v.name] = v
				end
				sql:write(table.concat(dump))
				sql:close()
				file[#file+1] = '}'
				SaveResourceFile(ox.name, 'data/items.lua', table.concat(file), -1)
				exports.oxmysql:update(query, {}, function(result)
					if result > 0 then
						ox.info('Removed '..result..' items from the database')
					end
				end)
			end
		end
	end
	Wait(2000)
	TriggerEvent('ox_inventory:itemList', Items)
	if Config.DBCleanup then exports.oxmysql:executeSync('DELETE FROM ox_inventory WHERE lastupdated < (NOW() - INTERVAL '..Config.DBCleanup..') OR data = "[]"') end
	ESX.UsableItemsCallbacks = ESX.GetUsableItems()
	local count = 0
	for _, v in pairs(Items) do
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

local containers = {
	['paperbag'] = {5, 1000}
}

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
			if not metadata.ammo and item.ammoname then metadata.ammo = 0 end
			if not metadata.components then metadata.components = {} end
			if metadata.registered ~= false then
				metadata.registered = type(metadata.registered) == 'string' and metadata.registered or xPlayer.name
				metadata.serial = metadata.serial or GenerateSerial(metadata.serial)
			end
		end
	else
		local container = containers[item.name]
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
					type = xPlayer.name,
					description = ox.locale('identification', (xPlayer.variables.sex or xPlayer.sex) and ox.locale('male') or ox.locale('female'), xPlayer.variables.dateofbirth or xPlayer.dateofbirth)
				}
			end
		end
		if not metadata?.durability then
			local durability = Items[item.name].degrade
			if durability then metadata.durability = os.time()+(durability * 60) metadata.degrade = durability end
		end
	end
	return metadata, count
end

exports('Items', GetItem)
return M
