if not lib then return end

function client.setPlayerData(key, value)
	PlayerData[key] = value
	OnPlayerData(key, value)
end

function client.hasGroup(group)
	if not PlayerData.loaded then return end

	if type(group) == 'table' then
		for name, rank in pairs(group) do
			local groupRank = PlayerData.groups[name]
			if groupRank and groupRank >= (rank or 0) then
				return name, groupRank
			end
		end
	else
		local groupRank = PlayerData.groups[group]
		if groupRank then
			return group, groupRank
		end
	end
end

local Utils = client.utils
local Weapon = client.weapon

local function onLogout()
	if not PlayerData.loaded then return end

	if client.parachute then
		Utils.DeleteObject(client.parachute)
		client.parachute = false
	end

	client.closeInventory()
	PlayerData.loaded = false
	ClearInterval(client.interval)
	ClearInterval(client.tick)
	Weapon.Disarm()
end

local scriptPath = ('modules/bridge/%s/client.lua'):format(shared.framework)
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

func(onLogout, client.weapon)
