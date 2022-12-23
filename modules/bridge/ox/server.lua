local playerDropped = ...
local Inventory

CreateThread(function()
	Inventory = server.inventory
end)

AddEventHandler('ox:playerLogout', playerDropped)

AddEventHandler('ox:setGroup', function(source, name, grade)
	local inventory = Inventory(source)
	if not inventory then return end
	inventory.player.groups[name] = grade
end)

function server.hasLicense(inv, name)
	local player = Ox.GetPlayer(inv.id)
	return player.getLicense(name)
end

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
