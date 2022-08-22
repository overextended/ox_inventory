--[[ FX Information ]]--
fx_version   'cerulean'
use_experimental_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'

--[[ Resource Information ]]--
name         'ox_inventory'
author       'Overextended'
version      '2.10.3'
repository   'https://github.com/overextended/ox_inventory'
description  'Slot-based inventory with item metadata support'

--[[ Manifest ]]--
dependencies {
	'/server:5181',
	'/onesync',
	'oxmysql',
	'ox_lib',
}

shared_scripts {
	'@ox_lib/init.lua',
	'modules/init.lua'
}

server_script 'modules/bridge/server.lua'

shared_scripts {
	'modules/**/shared.lua'
}

client_scripts {
	'modules/items/client.lua',
	'modules/utils/client.lua',
	'modules/weapon/client.lua',
	'modules/bridge/client.lua',
	'modules/interface/client.lua',
	'modules/shops/client.lua',
	'modules/inventory/client.lua',
	'client.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'modules/mysql/server.lua',
	'modules/logs/server.lua',
	'modules/items/server.lua',
	'modules/inventory/server.lua',
	'modules/shops/server.lua',
	'server.lua',
	-- 'setup/convert.lua',
	'setup/dbcleanup.lua',
}

ui_page 'web/build/index.html'

files {
	'web/build/index.html',
	'web/build/**/*',
	'modules/**/shared.lua',
	'data/*.lua',
	'data/**/*.lua'
}
