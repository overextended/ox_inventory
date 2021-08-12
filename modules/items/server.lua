local M = {}
local Items = module('items', true)
local metatable = setmetatable(M, {
	__call = function(self, item)
		if item then
			item = string.lower(item)
			if item:find('weapon_') then item = string.upper(item) end
			item = Items[item] or false
			return item
		end
		return self
	end
})

CreateThread(function()
	Wait(200)
	repeat Citizen.Wait(100) until GetResourceState('ghmattimysql') == 'started'
	if ESX == nil or SetInterval == nil then return ox.error('Unable to locate dependencies - refer to the documentation') end
	local OneSync = GetConvar('onesync_enabled', false) == 'true'
	local Infinity = GetConvar('onesync_enableInfinity', false) == 'true'
	if not OneSync and not Infinity then return ox.error('OneSync is not enabled on this server - refer to the documentation')
	elseif Infinity then ox.info('Server is running OneSync Infinity') else ox.info('Server is running OneSync Legacy') end
	local items, query = exports.ghmattimysql:executeSync('SELECT * FROM items', {})
	for i=1, #items do
		local i = items[i]
		if not query then query = "DELETE FROM items WHERE name = '"..i.name.."'"
		else query = ox.concat(' ', query, "OR name='"..i.name.."'") end
		i.close = i.closeonuse or true
		i.stack = i.stackable or true
		i.description = i.description or ''
		Items[i.name] = i
	end
	if query then
		local sql = io.open(GetResourcePath(ox.name):gsub('//', '/')..'/setup/dump.sql', 'a+')
		local file = io.open(GetResourcePath(ox.name):gsub('//', '/')..'/shared/items.lua', 'a+')
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
		exports.ghmattimysql:execute(query, {
		}, function(result)
			if result and result.affectedRows > 0 then
				ox.info('Removed', result.affectedRows, 'items from the database')
			end
		end)
	end
	TriggerEvent('ox_inventory:itemList', Items)
	Wait(2000)
	ox.ready = true
	ox.items = count
	ESX.UsableItemsCallbacks = exports.es_extended:UsableItems()
	local count = 0 for k, v in pairs(Items) do
		if v.consume and ESX.UsableItemsCallbacks[v.name] then ESX.UsableItemsCallbacks[v.name] = nil end
		count = count + 1
	end
	ox.info('Inventory has fully loaded with '..count..' items')
	exports.ghmattimysql:executeSync('DELETE FROM `linden_inventory` WHERE `lastupdated` < (NOW() - INTERVAL '..Config.DBCleanup..') OR `data` = "[]"')
	collectgarbage('collect') -- clean up from initialisation
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

return M