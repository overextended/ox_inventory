--[[ FX Information ]]--
fx_version   'cerulean'
use_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'

--[[ Resource Information ]]--
name         'ox_inventory'
author       'Overextended'
version      '2.0.0'
repository   'https://github.com/overextended/ox_inventory'
description  'local function ReleaseDate() local soon_tm = promise.new(); Citizen.Await(soon_tm); end'

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
	'config.lua',
}

server_script 'modules/player/server.lua'
shared_script 'modules/main.lua'

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
	'server.lua'
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
