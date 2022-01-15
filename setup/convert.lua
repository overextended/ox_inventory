local Items = server.items

--[[
	You should remove this file from fxmanifest.lua if it is not required
	Remember to backup your database in the event of errors

	This conversion process is designed for ESX v1 Final and ESX Legacy!
]]

local started

local function Print(arg)
	print(('^3=================================================================\n^0%s\n^3=================================================================^0'):format(arg))
end

local function Upgrade()
	-- Throw an error if ox_inventory does not exist
	-- User needs to use upgrade.sql first
	MySQL.query.await('SELECT name FROM ox_inventory')

	local trunk = MySQL.query.await('SELECT owner, name, data FROM ox_inventory WHERE name LIKE ?', {'trunk-%'})
	local glovebox = MySQL.query.await('SELECT owner, name, data FROM ox_inventory WHERE name LIKE ?', {'glovebox-%'})
	if #trunk > 0 or #glovebox > 0 then
		local vehicles = {}
		for _, v in pairs(trunk) do
			vehicles[v.owner] = vehicles[v.owner] or {}
			vehicles[v.owner][v.name:sub(7, #v.name)] = {trunk=v.data or '[]', glovebox='[]'}
		end

		for _, v in pairs(glovebox) do
			if not vehicles[v.owner] then
				vehicles[v.owner] = {}
			end
			vehicles[v.owner][v.name:sub(10, #v.name)] = vehicles[v.owner][v.name:sub(10, #v.name)] or {trunk='[]', glovebox=v.data or '[]'}
		end

		Print(('Moving ^3%s^0 trunks and ^3%s^0 gloveboxes to owned_vehicles table'):format(#trunk, #glovebox))
		local parameters = {}
		local count = 0

		for owner, v in pairs(vehicles) do
			for plate, v in pairs(v) do
				count += 1
				parameters[count] = {
					v.trunk,
					v.glovebox,
					plate,
					owner
				}
			end
		end

		MySQL.prepare.await('UPDATE owned_vehicles SET trunk = ?, glovebox = ? WHERE plate = ? AND owner = ?', parameters)
		MySQL.prepare.await('DELETE FROM ox_inventory WHERE name LIKE ? OR name LIKE ?', {'trunk-%', 'glovebox-%'})

		Print('Completed task - you can safely remove setup/convert.lua')
	else
		Print('^3No inventories need to be moved! You can safely remove setup/convert.lua')
	end
end

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

local function Convert()
	local users = MySQL.query.await('SELECT identifier, inventory, loadout, accounts FROM users')
	local total = #users
	local count = 0
	local parameters = {}

	Print(('Converting %s user inventories to new data format'):format(total))

	for i = 1, #users do
		count += 1
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

		parameters[count] = {json.encode(inventory), users[i].identifier}
	end

	MySQL.prepare.await('UPDATE users SET inventory = ? WHERE identifier = ?', parameters)
	Print('Completed task - you can safely remove setup/convert.lua')
end

CreateThread(function()
	repeat Wait(50) until shared.ready
	shared.ready = false
	Print([[Currently running in setup mode
If you are upgrading from linden_inventory, type '/convertinventory linden'

To update standard ESX player inventories to support metadata, type '/convertinventory']])

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

end)
