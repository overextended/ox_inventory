--[[ FX Information ]] --
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]] --
name 'ox_inventory'
author 'Overextended'
version      '2.17.4'
repository 'https://github.com/overextended/ox_inventory'
description 'Slot-based inventory with item metadata support'

--[[ Manifest ]] --
dependencies {
	'/server:5848',
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
	'modules/crafting/client.lua',
	'modules/shops/client.lua',
	'modules/inventory/client.lua',
	'client.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'modules/hooks/server.lua',
	'modules/mysql/server.lua',
	'modules/items/server.lua',
	'modules/inventory/server.lua',
	'modules/crafting/server.lua',
	'modules/shops/server.lua',
	'modules/pefcl/server.lua',
	'server.lua',
}

ui_page 'web/build/index.html'

files {
	'locales/*.json',
	'web/build/index.html',
	'web/build/assets/*.js',
	'web/build/assets/*.css',
	'web/images/*.png',
	'modules/**/shared.lua',
	'modules/bridge/**/client.lua',
	'data/*.lua',
}
