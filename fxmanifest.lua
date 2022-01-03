--[[ FX Information ]]--
fx_version   'cerulean'
use_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'

--[[ Resource Information ]]--
name         'ox_inventory'
author       'Overextended'
version      '2.1.4'
repository   'https://github.com/overextended/ox_inventory'
description  'Overly complicated and filled with scope creep'

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
