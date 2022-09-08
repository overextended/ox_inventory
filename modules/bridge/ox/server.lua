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
