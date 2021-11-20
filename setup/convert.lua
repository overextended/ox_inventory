local Items = include 'items'

--[[
	You should remove this file from fxmanifest.lua if it is not required
	Remember to backup your database in the event of errors

	This conversion process is designed for ESX v1 Final and ESX Legacy!
]]

local started = false

local Print = function(arg)
	print(('^3=================================================================\n^0%s\n^3=================================================================^0'):format(arg))
end

local Upgrade = function()
	exports.oxmysql:execute('SELECT name FROM linden_inventory', {}, function(result)
		if result ~= nil then
			Print('Please run upgrade.sql before upgrading')
		else
			local trunk = exports.oxmysql:executeSync('SELECT owner, name, data FROM ox_inventory WHERE name LIKE ?', {'trunk-%'})
			local glovebox = exports.oxmysql:executeSync('SELECT owner, name, data FROM ox_inventory WHERE name LIKE ?', {'glovebox-%'})
			local total = 0
			if #trunk > 0 or #glovebox > 0 then
				local vehicles = {}
				for _, v in pairs(trunk) do
					vehicles[v.owner] = vehicles[v.owner] or {}
					vehicles[v.owner][v.name:sub(7, #v.name)] = {trunk=v.data or '[]', glovebox='[]'}
					total += 1
				end
				for _, v in pairs(glovebox) do
					if not vehicles[v.owner] then
						vehicles[v.owner] = {}
						total += 1
					end
					vehicles[v.owner][v.name:sub(10, #v.name)] = vehicles[v.owner][v.name:sub(10, #v.name)] or {trunk='[]', glovebox=v.data or '[]'}
				end
				Print(('Moving ^3%s^0 trunks and ^3%s^0 gloveboxes to owned_vehicles table'):format(#trunk, #glovebox))
				local count = 0
				for owner, v in pairs(vehicles) do
					for plate, v in pairs(v) do
						exports.oxmysql:update('UPDATE owned_vehicles SET trunk = ?, glovebox = ? WHERE plate = ? AND owner = ?', {v.trunk, v.glovebox, plate, owner}, function()
							count += 1
							local pct = math.floor((count/total) * 100 + 0.5)
							if pct == '100' then
								exports.oxmysql:execute('DELETE FROM ox_inventory WHERE name LIKE ? OR name LIKE ?', {'trunk-%', 'glovebox-%'}, function()
									Print('Completed task - you can safely delete this file')
								end)
							elseif string.sub(pct, 2, 2) == '0' then
								Print('Task is ^3'..pct..'%^0 complete')
							end
						end)
					end
				end
			else
				Print('^3No inventories need to be moved! You can safely delete this file')
			end
		end
	end)
end

local GenerateText = function(num)
	local str
	repeat str = {}
		for i=1, num do str[i] = string.char(math.random(65, 90)) end
		str = table.concat(str)
	until str ~= 'POL' and str ~= 'EMS'
	return str
end

local GenerateSerial = function(text)
	if not text then GenerateText(3) elseif text:len() > 3 then return text end
	return ('%s%s%s'):format(math.random(100000,999999), text, math.random(100000,999999))
end

local Convert = function()
	local users = exports.oxmysql:executeSync('SELECT identifier, inventory, loadout, accounts FROM users')
	local total, count = #users, 0
	Print(('Converting %s user inventories to new data format'):format(total))
	for i=1, #users do
		local inventory, slot = {}, 0
		local items = users[i].inventory and json.decode(users[i].inventory) or {}
		local accounts = users[i].accounts and json.decode(users[i].accounts) or {}
		local loadout = users[i].loadout and json.decode(users[i].loadout) or {}
		for k, v in pairs(accounts) do
			if type(v) == 'table' then break end
			if Items(k) and v > 0 then
				slot += 1
				inventory[slot] = {slot=slot, name=k, count=v}
			end
		end
		for k in pairs(loadout) do
			local item = Items(k)
			if item then
				slot += 1
				inventory[slot] = {slot=slot, name=k, count=1, metadata = {durability=100}}
				if item.ammoname then
					inventory[slot].metadata.ammo = 0
					inventory[slot].metadata.components = {}
					inventory[slot].metadata.serial = GenerateSerial()
				end
			end
		end
		for k, v in pairs(items) do
			if type(v) == 'table' then break end
			if Items(k) and v > 0 then
				slot += 1
				inventory[slot] = {slot=slot, name=k, count=v}
			end
		end
		inventory = json.encode(inventory)
		exports.oxmysql:execute('UPDATE users SET inventory = ? WHERE identifier = ?', {inventory, users[i].identifier}, function()
			count += 1
			local pct = math.floor((count/total) * 100 + 0.5)
			if pct == '100' then
				Print('Completed task - you can safely delete this file')
			elseif string.sub(pct, 2, 2) == '0' then
				Print('Task is ^3'..pct..'%^0 complete')
			end
		end)
	end
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
