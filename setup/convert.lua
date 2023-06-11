local Items = require 'modules.items.server'
local started

local function Print(arg)
	print(('^3=================================================================\n^0%s\n^3=================================================================^0'):format(arg))
end

local function Upgrade()
	if started then
		return warn('Data is already being converted, please wait..')
	end

	started = true

	local trunk = MySQL.query.await('SELECT owner, name, data FROM ox_inventory WHERE name LIKE ?', {'trunk-%'})
	local glovebox = MySQL.query.await('SELECT owner, name, data FROM ox_inventory WHERE name LIKE ?', {'glovebox-%'})

	if trunk and glovebox then
		local vehicles = {}

		for _, v in pairs(trunk) do
			vehicles[v.owner] = vehicles[v.owner] or {}
			local subbedName = v.name:sub(7, #v.name)
			vehicles[v.owner][subbedName] = vehicles[v.owner][subbedName] or {trunk=v.data or '[]', glovebox='[]'}
		end

		for _, v in pairs(glovebox) do
			vehicles[v.owner] = vehicles[v.owner] or {}
			local subbedName = v.name:sub(10, #v.name)
			vehicles[v.owner][subbedName] = {trunk=vehicles[v.owner][subbedName].trunk ~= '[]' and vehicles[v.owner][subbedName].trunk or '[]', glovebox=vehicles[v.owner][subbedName].glovebox ~= '[]' and vehicles[v.owner][subbedName].glovebox or v.data or '[]'}
		end

		Print(('Moving ^3%s^0 trunks and ^3%s^0 gloveboxes to owned_vehicles table'):format(#trunk, #glovebox))
		local parameters = {}
		local count = 0

		for owner, v in pairs(vehicles) do
			for plate, v2 in pairs(v) do
				count += 1
				parameters[count] = {
					v2.trunk,
					v2.glovebox,
					plate,
					owner
				}
			end
		end

		MySQL.prepare.await('UPDATE owned_vehicles SET trunk = ?, glovebox = ? WHERE plate = ? AND owner = ?', parameters)
		MySQL.prepare.await('DELETE FROM ox_inventory WHERE name LIKE ? OR name LIKE ?', {'trunk-%', 'glovebox-%'})

		Print('Successfully converted trunks and gloveboxes')
	else
		Print('No inventories need to be converted')
	end

	started = false
end

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

local function ConvertESX()
	if started then
		return warn('Data is already being converted, please wait..')
	end

	local users = MySQL.query.await('SELECT identifier, inventory, loadout, accounts FROM users')

	if not users then return end

	started = true
	local total = #users
	local count = 0
	local parameters = {}

	Print(('Converting %s user inventories to new data format'):format(total))

	for i = 1, total do
		count += 1
		local inventory, slot = {}, 0
		local items = users[i].inventory and json.decode(users[i].inventory) or {}
		local accounts = users[i].accounts and json.decode(users[i].accounts) or {}
		local loadout = users[i].loadout and json.decode(users[i].loadout) or {}

		for k, v in pairs(accounts) do
			if type(v) == 'table' then break end
			if server.accounts[k] and Items(k) and v > 0 then
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
	Print('Successfully converted user inventories')
	started = false
end

local function ConvertQB()
	if started then
		return warn('Data is already being converted, please wait..')
	end

	started = true
	local users = MySQL.query.await('SELECT citizenid, inventory, money FROM players')
	if not users then return end
	local count = 0
	local parameters = {}

	for i = 1, #users do
		local inventory, slot = {}, 0
		local user = users[i]
		local items = user.inventory and json.decode(user.inventory) or {}
		local accounts = user.money and json.decode(user.money) or {}

		for k, v in pairs(accounts) do
			if type(v) == 'table' then break end
			if k == 'cash' then k = 'money' end

			if server.accounts[k] and Items(k) and v > 0 then
				slot += 1
				inventory[slot] = {slot=slot, name=k, count=v}
			end
		end

		local shouldConvert = false

		for _, v in pairs(items) do
			if Items(v?.name) then
				slot += 1
				inventory[slot] = {slot=slot, name=v.name, count=v.amount, metadata = type(v.info) == 'table' and v.info or {}}
				if v.type == "weapon" then
					inventory[slot].metadata.durability = v.info.quality or 100
					inventory[slot].metadata.ammo = v.info.ammo or 0
					inventory[slot].metadata.components = {}
					inventory[slot].metadata.serial = GenerateSerial()
					inventory[slot].metadata.quality = nil
				end
			end

			shouldConvert = v.amount and true
		end

		if shouldConvert then
			count += 1
			parameters[count] = { 'UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode(inventory), user.citizenid } }
		end
	end

	Print(('Converting %s user inventories to new data format'):format(count))

	if count > 0 then
		if not MySQL.transaction.await(parameters) then
			return Print('An error occurred while converting player inventories')
		end
		Wait(100)
	end

	local plates = MySQL.query.await('SELECT plate, citizenid FROM player_vehicles')

	if plates then
		for i = 1, #plates do
			plates[plates[i].plate] = plates[i].citizenid
		end

		local trunk = MySQL.query.await('SELECT plate, items FROM trunkitems')

		if trunk then
			table.wipe(parameters)
			count = 0
			local vehicles = {}

			for _, v in pairs(trunk) do
				local owner = plates[v.plate]

				if owner then
					if not vehicles[owner] then
						vehicles[owner] = {}
					end

					if not vehicles[owner][v.plate] then
						local items = json.decode(v.items) or {}
						local inventory, slot = {}, 0

						for _, v in pairs(items) do
							if Items(v?.name) then
								slot += 1
								inventory[slot] = {slot=slot, name=v.name, count=v.amount, metadata = type(v.info) == 'table' and v.info or {}}
								if v.type == "weapon" then
									inventory[slot].metadata.durability = v.info.quality or 100
									inventory[slot].metadata.ammo = v.info.ammo or 0
									inventory[slot].metadata.components = {}
									inventory[slot].metadata.serial = GenerateSerial()
									inventory[slot].metadata.quality = nil
								end
							end
						end

						vehicles[owner][v.plate] = true
						count += 1
						parameters[count] = { 'UPDATE player_vehicles SET trunk = ? WHERE plate = ? AND citizenid = ?', { json.encode(inventory), v.plate, owner } }
					end
				end
			end

			Print(('Moving ^3%s^0 trunks to the player_vehicles table'):format(count))

			if count > 0 then
				if not MySQL.transaction.await(parameters) then
					return Print('An error occurred while converting trunk inventories')
				end

				Wait(100)
			end
		end

		local glovebox = MySQL.query.await('SELECT plate, items FROM gloveboxitems')

		if glovebox then
			table.wipe(parameters)
			count = 0
			local vehicles = {}

			for _, v in pairs(glovebox) do
				local owner = plates[v.plate]

				if owner then
					if not vehicles[owner] then
						vehicles[owner] = {}
					end

					if not vehicles[owner][v.plate] then
						local items = json.decode(v.items) or {}
						local inventory, slot = {}, 0

						for _, v in pairs(items) do
							if Items(v?.name) then
								slot += 1
								inventory[slot] = {slot=slot, name=v.name, count=v.amount, metadata = type(v.info) == 'table' and v.info or {}}

								if v.type == "weapon" then
									inventory[slot].metadata.durability = v.info.quality or 100
									inventory[slot].metadata.ammo = v.info.ammo or 0
									inventory[slot].metadata.components = {}
									inventory[slot].metadata.serial = GenerateSerial()
									inventory[slot].metadata.quality = nil
								end
							end
						end

						vehicles[owner][v.plate] = true
						count += 1
						parameters[count] = { 'UPDATE player_vehicles SET glovebox = ? WHERE plate = ? AND citizenid = ?', { json.encode(inventory), v.plate, owner } }
					end
				end
			end

			Print(('Moving ^3%s^0 gloveboxes to the player_vehicles table'):format(count))

			if count > 0 then
				if not MySQL.transaction.await(parameters) then
					return Print('An error occurred while converting glovebox inventories')
				end
			end
		end
	end

	local qbEvidence = MySQL.query.await("SELECT stash, items FROM stashitems WHERE stash LIKE '% | Drawer%'")

	if qbEvidence then
		table.wipe(parameters)
		count = 0

		---@type table<string, OxItem[]> maps stash name to inventory
		local oxEvidence = {}

		for i = 1, #qbEvidence do
			local qbStash = qbEvidence[i]
			local name = 'evidence-'..qbStash.stash:sub(12)
			local items = server.convertInventory(nil, (qbStash.items and json.decode(qbStash.items) or {}))

			--- evidence numbers can be shared between locations, so need to maintain map and merge.
			if oxEvidence[name] then
				for k = 1, #items do
					oxEvidence[name][#oxEvidence[name]+1] = items[k]
				end
			else
				oxEvidence[name] = items
			end
		end

		for name, items in pairs(oxEvidence) do
			count += 1
			parameters[count] = { "INSERT INTO ox_inventory (owner, name, data) VALUES ('', ?, ?) ON DUPLICATE KEY UPDATE name = VALUES(name), data = VALUES(data)", {
				name, json.encode(items)
			}}
		end

		Print(('Creating ^3%s^0 evidence lockers from ^3%s^0 lockers by merging duplicate locker numbers'):format(count, #qbEvidence))
		if count > 0 then
			if not MySQL.transaction.await(parameters) then
				return Print('An error occurred while converting evidence lockers')
			end
		end
	end

	Print('Successfully converted user and vehicle inventories')
	started = false
end

local function Convert_Old_ESX_Property()
	if started then
		return warn('Data is already being converted, please wait..')
	end

	local inventories = MySQL.query.await('select distinct owner from ( select owner from addon_inventory_items WHERE inventory_name = "property" union all select owner from datastore_data WHERE NAME = "property" union all select owner from addon_account_data WHERE account_name = "property_black_money") a ')

	if not inventories then return end

	started = true
	local total = #inventories
	local count = 0
	local parameters = {}

	Print(('Converting %s user property inventories to new data format'):format(total))

	for i = 1, #inventories do
		count += 1
		local inventory, slot = {}, 0

		local addoninventory = MySQL.query.await('SELECT name,count FROM addon_inventory_items WHERE owner = ? AND inventory_name = "property"', {inventories[i].owner})

		for k,v in pairs(addoninventory) do
			if Items(v.name) and v.count > 0 then
				slot += 1
				inventory[slot] = {slot=slot, name=v.name, count=v.count}
			end
		end

		local addonaccount = MySQL.query.await('SELECT money FROM addon_account_data WHERE owner = ? AND account_name = "property_black_money"', {inventories[i].owner})

		for k,v in pairs(addonaccount) do
			if v.money > 0 then
				slot += 1
				inventory[slot] = {slot=slot, name="black_money", count=v.money}
			end
		end

		local datastore = MySQL.query.await('SELECT data FROM datastore_data WHERE owner = ? AND name = "property"', {inventories[i].owner})

		for k,v in pairs(datastore) do
			local obj = json.decode(v['data'])
			if obj then
				for b = 1, #obj['weapons'] do
					local item = Items(obj['weapons'][b].name)
					if item then
						slot += 1
						inventory[slot] = {slot=slot, name=obj['weapons'][b].name, count=1, metadata = {durability=100}}
						if item.ammoname then
							inventory[slot].metadata.ammo = obj['weapons'][b].ammo
							inventory[slot].metadata.components = {}
							inventory[slot].metadata.serial = GenerateSerial()
						end
					end
				end
			end
		end
		parameters[count] = {inventories[i].owner,"property"..inventories[i].owner,json.encode(inventory,{indent=false})}
	end
	MySQL.prepare.await('INSERT INTO ox_inventory (owner,name,data) VALUES (?,?,?)', parameters)
	Print('Successfully converted user property inventories')
	started = false
end

return {
	linden = Upgrade,
	esx = ConvertESX,
	qb = ConvertQB,
	esxproperty = Convert_Old_ESX_Property,
}
