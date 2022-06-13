local Query = {
	SELECT_STASH = 'SELECT data FROM ox_inventory WHERE owner = ? AND name = ?',
	UPDATE_STASH = 'INSERT INTO ox_inventory (owner, name, data) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE data = VALUES(data)',
	SELECT_GLOVEBOX = 'SELECT plate, glovebox FROM `{vehicle_column}` WHERE plate = ?',
	SELECT_TRUNK = 'SELECT plate, trunk FROM `{vehicle_column}` WHERE plate = ?',
	SELECT_PLAYER = 'SELECT inventory FROM `{user_column}` WHERE charid = ?',
	UPDATE_TRUNK = 'UPDATE `{vehicle_column}` SET trunk = ? WHERE plate = ?',
	UPDATE_GLOVEBOX = 'UPDATE `{vehicle_column}` SET glovebox = ? WHERE plate = ?',
	UPDATE_PLAYER = 'UPDATE `{user_column}` SET inventory = ? WHERE charid = ?',
}

do
	local playerColumn, vehicleColumn

	if shared.framework == 'ox' then
		playerColumn = 'characters'
		vehicleColumn = 'vehicles'
	elseif shared.framework == 'esx' then
		playerColumn = 'users'
		vehicleColumn = 'owned_vehicles'
	end

	for k, v in pairs(Query) do
		Query[k] = v:gsub('{user_column}', playerColumn):gsub('{vehicle_column}', vehicleColumn)
	end
end

db = {}

function db.loadPlayer(identifier)
	local inventory = MySQL.prepare.await(Query.SELECT_PLAYER, { identifier })
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

function db.saveGlovebox(plate, inventory)
	return MySQL.prepare(Query.UPDATE_GLOVEBOX, { inventory, plate })
end

function db.loadGlovebox(plate)
	return MySQL.prepare.await(Query.SELECT_GLOVEBOX, { plate })
end

function db.saveTrunk(plate, inventory)
	return MySQL.prepare(Query.UPDATE_TRUNK, { inventory, plate })
end

function db.loadTrunk(plate)
	return MySQL.prepare.await(Query.SELECT_TRUNK, { plate })
end

function db.saveInventories(trunks, gloveboxes, stashes)
	if #trunks > 0 then
		MySQL.prepare(Query.UPDATE_TRUNK, trunks)
	end

	if #gloveboxes > 0 then
		MySQL.prepare(Query.UPDATE_GLOVEBOX, gloveboxes)
	end

	if #stashes > 0 then
		MySQL.prepare(Query.UPDATE_STASH, stashes)
	end
end

function db.selectLicense(name, owner)
	return MySQL.scalar.await('SELECT 1 FROM user_licenses WHERE type = ? AND owner = ?', { name, owner })
end
