-- Configuration settings should be modified via convars, rather than modifying this file.
-- This file exists to load in convar settings and set defaults on any undefined settings.
-- You can add these settings directly to your 'server.cfg', or create a new (or multiple) file to load with 'exec'
-- Refer to the comments above a setting or documentation for more information.

--[[
setr ox_inventory {
    "esx": true,
    "trimplate": true,
    "qtarget": false,
    "playerslots": 50,
    "blurscreen": true,
    "autoreload": true,
    "keys": [
        "F2", "K", "TAB"
    ],
    "enablekeys": [
        249
    ],
    "playerweight": 30000,
    "police": "police",
    "locale": "en"
}

set ox_inventory_server {
    "versioncheck": true,
    "clearstashes": "6 MONTH",
    "logs": false,
    "randomprices": true,
    "evidencegrade": 2,
    "randomloot": true
}

set ox_inventory_loot {
    "vehicle": [
        ["cola", 1, 1],
        ["water", 1, 1],
        ["garbage", 1, 2, 50],
        ["panties", 1, 1, 5],
        ["money", 1, 50],
        ["money", 200, 400, 5],
        ["bandage", 1, 1]
    ],

    "dumpster": [
    	["mustard", 1, 1],
        ["garbage", 1, 3],
        ["money", 1, 10],
        ["burger", 1, 1]
    ]
}

add_principal group.admin ox_inventory
add_ace resource.ox_inventory command.add_principal allow
add_ace resource.ox_inventory command.remove_principal allow

ensure ox_inventory
]]

local function loadConvar(name)
	local convar = json.decode(GetConvar(name, '{}'))
	if type(convar) == 'nil' then
		CreateThread(function()
			error(('^1Convar setting `%s` is malformed, ensure you are using a valid JSON format.^0'):format(name))
		end)
	end
	return convar or {}
end

ox = loadConvar('ox_inventory')

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
	autoreload = ox.autoreload or false,

	-- Set the keybinds for primary, secondary, and hotbar
	keys = ox.keys or {
		'F2', 'K', 'TAB'
	},

	-- Additional keys to enable when the inventory is open (i.e. push-to-talk)
	enablekeys = ox.enablekeys or {
		249
	},

	-- Default max weight of player inventory
	playerweight = ox.playerweight or 30000,

	-- Name of your police job
	police = ox.police or 'police',

	-- Translations
	locale = ox.locale or 'en'
}

ox.resource = GetCurrentResourceName()
IsDuplicityVersion = IsDuplicityVersion()

if IsDuplicityVersion then
	server = loadConvar('ox_inventory_server')

	-- Check the latest available release
	ox.versioncheck = server.versioncheck or true

	-- Removes stashes from the database if they haven't been used
	ox.clearstashes = server.clearstashes or '6 MONTH'

	-- Enables text-file logging
	ox.logs = server.logs or false

	-- Prices of items will fluctuate between 80% and 120%
	ox.randomprices = server.randomprices or true

	-- Police grade required to take items from evidence
	ox.evidencegrade = server.evidencegrade or 2

	-- Fills generated inventories with random items
	ox.randomloot = server.randomloot or true

	----------------------
	-- Random loot tables
	----------------------
	-- Each entry is an array, where values are
	-- [1] itemName  [2] minimum  [3] maximum  [4] chance (optional, default is 80/100)

	local loot = loadConvar('ox_inventory_loot')

	ox.vehicleloot = loot.vehicle or {
		{'cola', 1, 1},
		{'water', 1, 2},
		{'garbage', 1, 1, 20},
		{'panties', 1, 1, 5},
		{'money', 1, 50},
		{'money', 200, 400, 1},
		{'bandage', 1, 1}
	}

	ox.dumpsterloot = loot.dumpster or {
		{'mustard', 1, 1},
		{'garbage', 1, 3},
		{'money', 1, 10},
		{'burger', 1, 1}
	}

	server = table.wipe(server)
else client = {} end
