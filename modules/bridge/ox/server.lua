local playerDropped = ...
local Inventory = require 'modules.inventory.server'

AddEventHandler('ox:playerLogout', playerDropped)

AddEventHandler('ox:setGroup', function(source, name, grade)
	local inventory = Inventory(source)
	if not inventory then return end
	inventory.player.groups[name] = grade
end)

---@diagnostic disable-next-line: duplicate-set-field
function server.hasLicense(inv, name)
	local player = Ox.GetPlayer(inv.id)
	return player.getLicense(name)
end

---@diagnostic disable-next-line: duplicate-set-field
function server.buyLicense(inv, license)
	local player = Ox.GetPlayer(inv.id)

	if player.getLicense(license.name) then
		return false, 'already_have'
	elseif Inventory.GetItem(inv, 'money', false, true) < license.price then
		return false, 'can_not_afford'
	end

	Inventory.RemoveItem(inv, 'money', license.price)
	player.addLicense(license.name)

	return true, 'have_purchased'
end

---@diagnostic disable-next-line: duplicate-set-field
function server.isPlayerBoss(playerId, group, grade)
	local groupData = GlobalState[('group.%s'):format(group)]

	return groupData and grade >= groupData.adminGrade
end

---@param entityId number
---@return number | string
function server.getOwnedVehicleId(entityId)
    return Ox.GetVehicle(entityId)?.id
end
