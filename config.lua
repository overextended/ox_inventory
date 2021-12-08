-- This file is intended for setting default config values.
-- Modifying the values here changes the resource hash (requiring players to download everything again).
-- It's also just convenient to leave it alone for the sake of git source control.
-- Details will be added to the documentation at some point, but you can utilise it like so...
-- Create the file '.cfg' and add the following
--[[
	setr ox_inventory {
		"locale": "cs",
		"qtarget": true,
		"keys": [
        	"F2", "K", "TAB"
		]
	}

	set ox_inventory_server {
		"logs": true,
		"pricevariation": false,
		"dumpsterloot": {
			['mustard', 0, 1],
			['garbage', 1, 7],
			['burger', 0, 1]
		}
	}

	ensure ox_inventory
]]
-- Replace 'ensure ox_inventory' in your 'server.cfg' with 'exec @ox_inventory/.cfg'

local ox = json.decode(GetConvar('ox_inventory', '{}'))

ox = {
    locale = ox.locale or 'en',

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
    }
}

ox.resource = GetCurrentResourceName()
ox.playerweight = ESX.GetConfig().MaxWeight
IsDuplicityVersion = IsDuplicityVersion()

if IsDuplicityVersion then
	local server = json.decode(GetConvar('ox_inventory_server', '{}'))
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

	-- Items that can be acquired, with minimum and maxiumum count to be generated
	ox.loottable = server.loottable or {
		{'cola', 0, 1},
		{'water', 0, 2},
		{'garbage', 0, 1},
		{'panties', 0, 1},
		{'money', 0, 50},
		{'bandage', 0, 1}
	}

	-- Separate loot table for dumpsters
	ox.dumpsterloot = server.dumpsterloot or {
		{'mustard', 0, 1},
		{'garbage', 1, 3},
		{'panties', 0, 1},
		{'money', 0, 10},
		{'burger', 0, 1}
	}

	_G.server = table.wipe(server)
end

_G.ox = ox