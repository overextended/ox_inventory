---@todo separate module into smaller submodules to handle each framework
---starting to get bulky

function server.hasGroup(inv, group)
	if type(group) == 'table' then
		for name, rank in pairs(group) do
			local groupRank = inv.player.groups[name]
			if groupRank and groupRank >= (rank or 0) then
				return name, groupRank
			end
		end
	else
		local groupRank = inv.player.groups[group]
		if groupRank then
			return group, groupRank
		end
	end
end

---@diagnostic disable-next-line: duplicate-set-field
function server.setPlayerData(player)
	if not player.groups then
		warn(("server.setPlayerData did not receive any groups for '%s'"):format(player?.name or GetPlayerName(player)))
	end

	return {
		source = player.source,
		name = player.name,
		groups = player.groups or {},
		sex = player.sex,
		dateofbirth = player.dateofbirth,
	}
end

---@diagnostic disable-next-line: duplicate-set-field
function server.buyLicense()
	warn('Licenses are not supported for the current framework.')
end

local Inventory = require 'modules.inventory.server'

local function playerDropped(source)
	local inv = Inventory(source) --[[@as OxInventory]]

	if inv?.player then
		inv:closeInventory()
		Inventory.Remove(inv)
	end
end

AddEventHandler('playerDropped', function()
	playerDropped(source)
end)

local scriptPath = ('modules/bridge/%s/server.lua'):format(shared.framework)
local resourceFile = LoadResourceFile(cache.resource, scriptPath)

if not resourceFile then
	lib = nil
	return error(("Unable to find framework bridge for '%s'"):format(shared.framework))
end

local func, err = load(resourceFile, ('@@%s/%s'):format(cache.resource, scriptPath))

if not func or err then
	lib = nil
	return error(err)
end

func(playerDropped)

if server.convertInventory then exports('ConvertItems', server.convertInventory) end
