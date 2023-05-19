lib.locale()

-- Don't be an idiot and change these convar getters (yes, people do that).
-- https://overextended.github.io/docs/ox_inventory/Getting%20Started/config

shared = {
	resource = GetCurrentResourceName(),
	framework = GetConvar('inventory:framework', 'esx'),
	playerslots = GetConvarInt('inventory:slots', 50),
	playerweight = GetConvarInt('inventory:weight', 30000),
	target = GetConvarInt('inventory:target', 0) == 1,
	police = json.decode(GetConvar('inventory:police', '["police", "sheriff"]')),
}

do
	if type(shared.police) == 'string' then
		shared.police = { shared.police }
	end

	local police = table.create(0, shared.police and #shared.police or 0)

	for i = 1, #shared.police do
		police[shared.police[i]] = 0
	end

	shared.police = police
end

if IsDuplicityVersion() then
	server = {
		loglevel = GetConvarInt('inventory:loglevel', 1),
		randomprices = GetConvarInt('inventory:randomprices', 0) == 1,
		randomloot = GetConvarInt('inventory:randomloot', 1) == 1,
		evidencegrade = GetConvarInt('inventory:evidencegrade', 2),
		trimplate = GetConvarInt('inventory:trimplate', 1) == 1,
		vehicleloot = json.decode(GetConvar('inventory:vehicleloot', [[
			[
				["cola", 1, 1],
				["water", 1, 1],
				["garbage", 1, 2, 50],
				["panties", 1, 1, 5],
				["money", 1, 50],
				["money", 200, 400, 5],
				["bandage", 1, 1]
			]
		]])),
		dumpsterloot = json.decode(GetConvar('inventory:dumpsterloot', [[
			[
				["mustard", 1, 1],
				["garbage", 1, 3],
				["money", 1, 10],
				["burger", 1, 1]
			]
		]])),
	}
else
	PlayerData = {}
	client = {
		autoreload = GetConvarInt('inventory:autoreload', 0) == 1,
		screenblur = GetConvarInt('inventory:screenblur', 1) == 1,
		keys = json.decode(GetConvar('inventory:keys', '')) or { 'F2', 'K', 'TAB' },
		enablekeys = json.decode(GetConvar('inventory:enablekeys', '[249]')),
		aimedfiring = GetConvarInt('inventory:aimedfiring', 0) == 1,
		giveplayerlist = GetConvarInt('inventory:giveplayerlist', 0) == 1,
		weaponanims = GetConvarInt('inventory:weaponanims', 1) == 1,
		itemnotify = GetConvarInt('inventory:itemnotify', 1) == 1,
		imagepath = GetConvar('inventory:imagepath', 'nui://ox_inventory/web/images'),
		dropprops = GetConvarInt('inventory:dropprops', 0) == 1,
		dropmodel = joaat(GetConvar('inventory:dropmodel', 'prop_med_bag_01b')),
		weaponmismatch = GetConvarInt('inventory:weaponmismatch', 1) == 1,
		ignoreweapons = json.decode(GetConvar('inventory:ignoreweapons', '[]')),
		suppresspickups = GetConvarInt('inventory:suppresspickups', 1) == 1,
	}

	local ignoreweapons = table.create(0, (client.ignoreweapons and #client.ignoreweapons or 0) + 3)

	for i = 1, #client.ignoreweapons do
		local weapon = client.ignoreweapons[i]
		ignoreweapons[tonumber(weapon) or joaat(weapon)] = true
	end

	ignoreweapons[`WEAPON_UNARMED`] = true
	ignoreweapons[`WEAPON_HANDCUFFS`] = true
	ignoreweapons[`WEAPON_GARBAGEBAG`] = true

	client.ignoreweapons = ignoreweapons
end

function shared.print(...) print(string.strjoin(' ', ...)) end

function shared.info(...) shared.print('^2[info]^7', ...) end

---Throws a formatted type error.
---```lua
---error("expected %s to have type '%s' (received %s)")
---```
---@param variable string
---@param expected string
---@param received string
function TypeError(variable, expected, received)
    error(("expected %s to have type '%s' (received %s)"):format(variable, expected, received))
end

-- People like ignoring errors for some reason
local function spamError(err)
	lib = nil
	shared.ready = false
	CreateThread(function()
		while true do
			Wait(2000)
			CreateThread(function()
				error(err, 0)
			end)
		end
	end)
	error(err, 0)
end

CreateThread(function()
	if shared.framework == 'ox' then
		local file = ('imports/%s.lua'):format(lib.context)
		local import = LoadResourceFile('ox_core', file)
		local func, err = load(import, ('@@ox_core/%s'):format(file))

		if not func or err then
			shared.ready = false
			return spamError(err)
		end

		func()

		Ox = Ox or {}
	end
end)

---@param name string
---@return table
function data(name)
	if shared.server and shared.ready == nil then return {} end
	local file = ('data/%s.lua'):format(name)
	local datafile = LoadResourceFile(shared.resource, file)
	local path = ('@@%s/%s'):format(shared.resource, file)

	if not datafile then
		warn(('no datafile found at path %s'):format(path:gsub('@@', '')))
		return {}
	end

	local func, err = load(datafile, path)

	if not func or err then
		shared.ready = false
		---@diagnostic disable-next-line: return-type-mismatch
		return spamError(err)
	end

	return func()
end

if not lib then
	return spamError('ox_inventory requires the ox_lib resource, refer to the documentation.')
end

local success, msg = lib.checkDependency('oxmysql', '2.4.0')

if not success then return spamError(msg) end

success, msg = lib.checkDependency('ox_lib', '3.2.0')

if not success then spamError(msg) end

if not LoadResourceFile(shared.resource, 'web/build/index.html') then
	return spamError('UI has not been built, refer to the documentation or download a release build.\n	^3https://overextended.github.io/docs/ox_inventory/^0')
end

if shared.target then
	local ox_target = GetResourceState('ox_target'):find('start')
	local qtarget = GetResourceState('qtarget'):find('start')

	if not ox_target and not qtarget then
		shared.target = false
		warn('targeting resource is not loaded - it should start before ox_inventory')
	else
		shared.target = ox_target and 'ox_target' or 'qtarget'
	end
end

if lib.context == 'server' then
	shared.ready = false
	return require 'server'
end

require 'client'
