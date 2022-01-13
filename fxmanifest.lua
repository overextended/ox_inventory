--[[ FX Information ]]--
fx_version   'cerulean'
use_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'

--[[ Resource Information ]]--
name         'ox_inventory'
author       'Overextended'
version      '2.1.8'
repository   'https://github.com/overextended/ox_inventory'
description  'Slot-based inventory with metadata'

--[[ Manifest ]]--
dependencies {
	'/server:5104',
	'/onesync',
	'oxmysql',
	'es_extended',
	'pe-lualib'
}

shared_scripts {
	'@pe-lualib/init.lua',
	'config.lua'
}

server_script 'modules/player/server.lua'

shared_scripts {
	'modules/init.lua',
	'modules/**/shared.lua'
}

client_scripts {
	'modules/items/client.lua',
	'modules/utils/client.lua',
	'modules/player/client.lua',
	'modules/interface/client.lua',
	'modules/shops/client.lua',
	'modules/inventory/client.lua',
	'client.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'modules/logs/server.lua',
	'modules/items/server.lua',
	'modules/inventory/server.lua',
	'modules/shops/server.lua',
	'server.lua',
	'version.lua'
}

--server_script 'setup/convert.lua'

ui_page 'web/build/index.html'

files {
	'web/build/index.html',
	'web/build/**/*',
	'modules/**/shared.lua',
	'data/*.lua',
	'data/**/*.lua'
}

-- FxDK settings
convar_category 'shared' {
	'Shared inventory settings',
	{
		{'Activate specific event handlers and functions', '$inventory:framework', 'CV_MULTI', {
			false, 'esx'
		}},
		{'Load specific language file from data/locales', '$inventory:locale', 'CV_MULTI', {
			'en', 'cs', 'da', 'es', 'fr', 'it', 'nl', 'pt-br'
		}},
		{'Number of slots for player inventories', '$inventory:slots', 'CV_INT', 50},
		{'Maximum carry capacity for players, in kilograms', '$inventory:weight', 'CV_INT', 30000},
		{'Weapons will reload after reaching 0 ammo', '$inventory:autoreload', 'CV_BOOL', false},
		{'Blur the screen while accessing the inventory', '$inventory:screenblur', 'CV_BOOL', true},
		{'Trim whitespace from vehicle plates when checking owned vehicles', '$inventory:trimplate', 'CV_BOOL', true},
		{'Integrated support for qtarget stashes, shops, etc', '$inventory:qtarget', 'CV_BOOL', true},
		{'Default hotkeys to access primary and secondary inventories, and hotbar', '$inventory:keys', 'CV_STRING', '["F2", "K", "TAB"]'},
		{'Enable control action when inventory is open', '$inventory:enablekeys', 'CV_STRING', '[249]'},
		{'Jobs with access to police armoury, evidence lockers, etc', '$inventory:police', 'CV_STRING', '["police",	"sheriff"]'}
	}
}

convar_category 'server' {
	'Server inventory settings',
	{
		{'Basic text-file logging (improvements are planned)', 'inventory:logs', 'CV_BOOL', true},
		{'Item prices fluctuate in shops', 'inventory:randomprices', 'CV_BOOL', true},
		{'Compare current version to latest release on GitHub', 'inventory:versioncheck', 'CV_BOOL', true},
		{'Loot will randomly generate inside unowned vehicles and dumpsters', 'inventory:randomloot', 'CV_BOOL', true},
		{'Minimum job grade to remove items from evidence lockers', 'inventory:evidencegrade', 'CV_INT', 2},
		{'Stashes will be wiped after remaining unchanged for the given time', 'inventory:clearstashes', 'CV_STRING', "6 MONTH"},
		{'Set the contents of randomly generated inventories', 'inventory:loot', 'CV_STRING', {[[
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
		]]}}
	}
}
