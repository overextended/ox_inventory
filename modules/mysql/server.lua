local Query = {
	SELECT_STASH = 'SELECT data FROM ox_inventory WHERE owner = ? AND name = ?',
	UPDATE_STASH = 'INSERT INTO ox_inventory (owner, name, data) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE data = VALUES(data)',
	SELECT_GLOVEBOX = 'SELECT plate, glovebox FROM `user_vehicles` WHERE plate = ?',
	SELECT_TRUNK = 'SELECT plate, trunk FROM `user_vehicles` WHERE plate = ?',
	SELECT_PLAYER = 'SELECT inventory FROM `characters` WHERE charid = ?',
	UPDATE_TRUNK = 'UPDATE `user_vehicles` SET trunk = ? WHERE plate = ?',
	UPDATE_GLOVEBOX = 'UPDATE `user_vehicles` SET glovebox = ? WHERE plate = ?',
	UPDATE_PLAYER = 'UPDATE `characters` SET inventory = ? WHERE charid = ?',
}

local function replace(playerColumn, vehicleColumn)
	for k, v in pairs(Query) do
		if v:find('user_vehicles') then
			Query[k] = v:gsub('user_vehicles', vehicleColumn)
		elseif v:find('characters') then
			Query[k] = v:gsub('characters', playerColumn)
		end
	end
end

if shared.framework == 'esx' then
	replace('users', 'owned_vehicles')
end

function MySQL:nacistHrace(identifier)
	local inventory = self.prepare.await(Query.SELECT_PLAYER, { identifier })
	return inventory and json.decode(inventory)
end

function MySQL:ulozitHrace(owner, inventory)
	return self.prepare(Query.UPDATE_PLAYER, { inventory, owner })
end

function MySQL:ulozitSkrys(owner, dbId, inventory)
	return self.prepare(Query.UPDATE_STASH, { owner or '', dbId, inventory })
end

function MySQL:nacistSkrys(owner, name)
	return self.prepare.await(Query.SELECT_STASH, { owner or '', name })
end

function MySQL:ulozitKaslik(plate, inventory)
	return self.prepare(Query.UPDATE_GLOVEBOX, { inventory, plate })
end

function MySQL:nacistKaslik(plate)
	return self.prepare.await(Query.SELECT_GLOVEBOX, { plate })
end

function MySQL:ulozitKufr(plate, inventory)
	return self.prepare(Query.UPDATE_TRUNK, { inventory, plate })
end

function MySQL:nacistKufr(plate)
	return self.prepare.await(Query.SELECT_TRUNK, { plate })
end

function MySQL:ulozitInventare(trunks, gloveboxes, stashes)
	if #trunks > 0 then
		self.prepare(Query.UPDATE_TRUNK, trunks)
	end

	if #gloveboxes > 0 then
		self.prepare(Query.UPDATE_GLOVEBOX, gloveboxes)
	end

	if #stashes > 0 then
		self.prepare(Query.UPDATE_STASH, stashes)
	end
end

function MySQL:vybratLicence(name, owner)
	return self.scalar.await('SELECT 1 FROM user_licenses WHERE type = ? AND owner = ?', { name, owner })
end
