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

function server.setPlayerData(player)
	if not player.groups then
		shared.warning(("server.setPlayerData did not receive any groups for '%s'"):format(player?.name or GetPlayerName(player)))
	end

	return {
		source = player.source,
		name = player.name,
		groups = player.groups or {},
		sex = player.sex,
		dateofbirth = player.dateofbirth,
	}
end

function server.buyLicense()
	shared.warning('Licenses are not yet supported without esx or qb. Available soon™.')
end

local Inventory

CreateThread(function()
	Inventory = server.inventory
end)

local function playerDropped(source)
	local inv = Inventory(source)

	if inv then
		local openInventory = inv.open and Inventory(inv.open)

		if openInventory then
			openInventory:set('open', false)
		end

		if shared.framework ~= 'esx' then
			db.savePlayer(inv.owner, json.encode(inv:minimal()))
		end

		Inventory.Remove(source)
	end
end

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
