-- This file is intended for setting default config values.
-- Modifying the values here changes the resource hash (requiring players to download everything again).
-- It's also just convenient to leave it alone for the sake of git source control.
-- Details will be added to the documentation at some point, but you can utilise it like so...
--[[
setr ox_inventory {
    "locale": "en",
    "qtarget": true,
    "keys": [
        "F2", "K", "TAB"
    ]
}

set ox_inventory_server {
    "logs": true,
    "pricevariation": false
}

add_ace group.admin ox_inventory allow
add_ace resource.ox_inventory command.add_principal allow
add_ace resource.ox_inventory command.remove_principal allow
ensure ox_inventory
]]
-- Save the file to the resource directory as ".cfg"
-- Replace 'ensure ox_inventory' in your 'server.cfg' with 'exec @ox_inventory/.cfg'

local function loadConvar(name)
	local convar = json.decode(GetConvar(name, '{}'))
	if type(convar) == 'nil' then
		CreateThread(function()
			error(('^1Convar setting `%s` is malformed, ensure you are using a valid JSON format.^0'):format(name))
		end)
	end
	return convar or {}
end

local ox = loadConvar('ox_inventory')

ox = {
	-- Enable support for es_extended (defaults to true, for now)
	esx = ox.esx or true,

	-- If vehicle plates are stored with a trailing space, set to false (i.e. `XXX 000 `)
	trimplate = ox.trimplate or true,

	-- Adds compatibility for qtarget (https://github.com/overextended/qtarget)
	qtarget = ox.qtarget or false,

	-- Number of slots in the player inventory
	playerslots = ox.playerslots or 50,

	-- Blurs the screen while the inventory is open
	blurscreen = ox.blurscreen or true,

	-- Reload empty weapons automatically
	autoreload = ox.autoreload or true,

	-- Enable sentry logging (this reports UI errors and general performance statistics to the Ox team, anonymously)
	sentry = ox.sentry or true,

	-- Set the keybinds for primary, secondary, and hotbar
	keys = ox.keys or {
		'F2', 'K', 'TAB'
	},

	enablekeys = ox.enablekeys or {
		249
	},

	playerweight = ox.playerweight or 30000,

	locale = ox.locale or 'en'
}

ox.resource = GetCurrentResourceName()
IsDuplicityVersion = IsDuplicityVersion()

if IsDuplicityVersion then
	local server = loadConvar('ox_inventory_server')

	-- Check the latest available release
	ox.versioncheck = server.versioncheck or false

	-- Removes stashes from the database if they haven't been used
	ox.clearstashes = server.clearstashes or '6 MONTH'

	-- Enables text-file logging
	ox.logs = server.logs or false

	-- Prices of items will fluctuate between 80% and 120%
	ox.randomprice = server.randomprice or true

	-- Police grade required to take items from evidence
	ox.evidencegrade = server.evidencegrade or 2

	-- Fills generated inventories with random items
	ox.randomloot = server.randomloot or true

	-- Minimum chance for an inventory to generate an item
	ox.lootchance = server.lootchance or 50

	_G.server = table.wipe(server)
else client = {} end

_G.ox = ox
