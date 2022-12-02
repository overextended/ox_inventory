if not lib then return end

local Query = {
	SELECT_STASH = 'SELECT data FROM ox_inventory WHERE owner = ? AND name = ?',
	UPDATE_STASH = 'INSERT INTO ox_inventory (owner, name, data) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE data = VALUES(data)',
	SELECT_GLOVEBOX = 'SELECT plate, glovebox FROM `{vehicle_table}` WHERE `{vehicle_column}` = ?',
	SELECT_TRUNK = 'SELECT plate, trunk FROM `{vehicle_table}` WHERE `{vehicle_column}` = ?',
	SELECT_PLAYER = 'SELECT inventory FROM `{user_table}` WHERE `{user_column}` = ?',
	UPDATE_TRUNK = 'UPDATE `{vehicle_table}` SET trunk = ? WHERE `{vehicle_column}` = ?',
	UPDATE_GLOVEBOX = 'UPDATE `{vehicle_table}` SET glovebox = ? WHERE `{vehicle_column}` = ?',
	UPDATE_PLAYER = 'UPDATE `{user_table}` SET inventory = ? WHERE `{user_column}` = ?',
}

Citizen.CreateThreadNow(function()
	local playerTable, playerColumn, vehicleTable, vehicleColumn

	if shared.framework == 'ox' then
		playerTable = 'character_inventory'
		playerColumn = 'charid'
		vehicleTable = 'vehicles'
		vehicleColumn = 'id'
	elseif shared.framework == 'esx' then
		playerTable = 'users'
		playerColumn = 'identifier'
		vehicleTable = 'owned_vehicles'
		vehicleColumn = 'plate'
	elseif shared.framework == 'qb' then
		playerTable = 'players'
		playerColumn = 'citizenid'
		vehicleTable = 'player_vehicles'
		vehicleColumn = 'plate'
	elseif shared.framework == 'nd' then
		playerTable = 'characters'
		playerColumn = 'character_id'
		vehicleTable = 'vehicles'
		vehicleColumn = 'id'
	end

	for k, v in pairs(Query) do
		Query[k] = v:gsub('{user_table}', playerTable):gsub('{user_column}', playerColumn):gsub('{vehicle_table}', vehicleTable):gsub('{vehicle_column}', vehicleColumn)
	end

	local success, result = pcall(MySQL.scalar.await, 'SELECT 1 FROM ox_inventory')

	if not success then
		MySQL.query([[CREATE TABLE `ox_inventory` (
			`owner` varchar(60) DEFAULT NULL,
			`name` varchar(100) NOT NULL,
			`data` longtext DEFAULT NULL,
			`lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
			UNIQUE KEY `owner` (`owner`,`name`)
		)]])
	else
		result = MySQL.query.await("SELECT owner, name FROM ox_inventory WHERE NOT owner = ''")

		if result and next(result) then
			local parameters = {}
			local count = 0

			for i = 1, #result do
				local data = result[i]
				local snip = data.name:sub(-#data.owner, #data.name)

				if data.owner == snip then
					local name = data.name:sub(0, #data.name - #snip)

					count += 1
					parameters[count] = { query = 'UPDATE ox_inventory SET `name` = ? WHERE `owner` = ? AND `name` = ?', values = { name, data.owner, data.name } }
				end
			end

			if #parameters > 0 then
				MySQL.transaction(parameters)
			end
		end
	end

	result = MySQL.query.await(('SHOW COLUMNS FROM `%s`'):format(vehicleTable))

	if result then
		local glovebox, trunk

		for i = 1, #result do
			local column = result[i]
			if column.Field == 'glovebox' then
				glovebox = true
			elseif column.Field == 'trunk' then
				trunk = true
			end
		end

		if not glovebox then
			MySQL.query(('ALTER TABLE `%s` ADD COLUMN `glovebox` LONGTEXT NULL'):format(vehicleTable))
		end

		if not trunk then
			MySQL.query(('ALTER TABLE `%s` ADD COLUMN `trunk` LONGTEXT NULL'):format(vehicleTable))
		end
	end

	success, result = pcall(MySQL.scalar.await, ('SELECT inventory FROM `%s`'):format(playerTable))

	if not success then
		return MySQL.query(('ALTER TABLE `%s` ADD COLUMN `inventory` LONGTEXT NULL'):format(playerTable))
	end
end)

db = {}

function db.loadPlayer(identifier)
	local inventory = MySQL.prepare.await(Query.SELECT_PLAYER, { identifier }) --[[@as string?]]
	return inventory and json.decode(inventory)
end

function db.savePlayer(owner, inventory)
	return MySQL.prepare(Query.UPDATE_PLAYER, { inventory, owner })
end

function db.saveStash(owner, dbId, inventory)
	return MySQL.prepare(Query.UPDATE_STASH, { owner or '', dbId, inventory })
end

function db.loadStash(owner, name)
	return MySQL.prepare.await(Query.SELECT_STASH, { owner or '', name })
end

function db.saveGlovebox(id, inventory)
	return MySQL.prepare(Query.UPDATE_GLOVEBOX, { inventory, id })
end

function db.loadGlovebox(id)
	return MySQL.prepare.await(Query.SELECT_GLOVEBOX, { id })
end

function db.saveTrunk(id, inventory)
	return MySQL.prepare(Query.UPDATE_TRUNK, { inventory, id })
end

function db.loadTrunk(id)
	return MySQL.prepare.await(Query.SELECT_TRUNK, { id })
end

function db.saveInventories(players, trunks, gloveboxes, stashes)
	local numPlayer, numTrunk, numGlove, numStash = #players, #trunks, #gloveboxes, #stashes

	if numPlayer > 0 then
		MySQL.prepare(Query.UPDATE_PLAYER, players)
	end

	if numTrunk > 0 then
		MySQL.prepare(Query.UPDATE_TRUNK, trunks)
	end

	if numGlove > 0 then
		MySQL.prepare(Query.UPDATE_GLOVEBOX, gloveboxes)
	end

	if numStash > 0 then
		MySQL.prepare(Query.UPDATE_STASH, stashes)
	end

	local total = numPlayer + numTrunk + numGlove + numStash

	if total > 0 then
		shared.info(('Saving %s inventories to the database'):format(total))
	end
end

function db.selectLicense(name, owner)
	return MySQL.scalar.await('SELECT 1 FROM user_licenses WHERE type = ? AND owner = ?', { name, owner })
end
