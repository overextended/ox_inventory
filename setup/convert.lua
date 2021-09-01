--[[
	You should remove this file from fxmanifest.lua if it is not required
	Remember to backup your database in the event of errors

	This conversion process is designed for ESX v1 Final and ESX Legacy!
]]

local started, totalCount, currentCount = false, 0, 0
local identifier, inventory, loadout, accounts = {}, {}, {}, {}

local Print = function(arg)
	print(('^3=================================================================\n^0%s\n^3=================================================================^0'):format(arg))
end

Print([[Unable to start ox_inventory due to existence of setup file

^0If you are using a fresh database, delete
^3setup/convert.lua^0

If you are using this resource for the first time, use
^3/convertinventory^0

If you are upgrading from linden_inventory, use
^3/convertinventory linden^0]])

local Upgrade = function()
	exports.oxmysql:fetch('SELECT name FROM linden_inventory', {}, function(result)
		if result ~= nil then
			Print('Please run upgrade.sql before upgrading')
		else
			local trunk = exports.oxmysql:fetchSync('SELECT owner, name, data FROM ox_inventory WHERE name LIKE ?', {'trunk-%'})
			local glovebox = exports.oxmysql:fetchSync('SELECT owner, name, data FROM ox_inventory WHERE name LIKE ?', {'glovebox-%'})
			local total = 0
			if #trunk > 0 or #glovebox > 0 then
				local vehicles = {}
				for k, v in pairs(trunk) do
					vehicles[v.owner] = vehicles[v.owner] or {}
					vehicles[v.owner][v.name:sub(7, #v.name)] = {trunk=v.data or '[]', glovebox='[]'}
					total = total + 1
				end
				for k, v in pairs(glovebox) do
					if not vehicles[v.owner] then
						vehicles[v.owner] = {}
						total = total + 1
					end
					vehicles[v.owner][v.name:sub(10, #v.name)] = vehicles[v.owner][v.name:sub(10, #v.name)] or {trunk='[]', glovebox=v.data or '[]'}
				end
				Print(('Moving ^3%s^0 trunks and ^3%s^0 gloveboxes to owned_vehicles table'):format(#trunk, #glovebox))
				local count = 0
				for owner, v in pairs(vehicles) do
					for plate, v in pairs(v) do
						exports.oxmysql:execute('UPDATE owned_vehicles SET trunk = ?, glovebox = ? WHERE plate = ? AND owner = ?', {v.trunk, v.glovebox, plate, owner}, function()
							count = count + 1
							local pct = math.floor((count/total) * 100 + 0.5)
							if string.sub(pct, 2, 2) == '0' then
								Print('Task is ^3'..pct..'%^0 complete')
							end
						end)
					end
				end
				exports.oxmysql:execute('DELETE FROM ox_inventory WHERE name LIKE ? OR name LIKE ?', {'trunk-%', 'glovebox-%'}, function(result)
					Print('^3No inventories need to be moved! You can safely delete this file')
				end)
			else
				Print('^3No inventories need to be moved! You can safely delete this file')
			end
		end
	end)
end

local Convert = function()
	Print('WIP')
	-- need to update the old conversion function, and add optional support for vehicle inventory conversion
end

RegisterCommand('convertinventory', function(source, args, raw)
	if not started then
		if args and args[1] == 'linden' then
			Upgrade()
			started = true
		else
			Convert()
			started = true
		end
	end
end)