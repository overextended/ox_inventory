--[[ FX Information ]] --
fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

--[[ Resource Information ]] --
name 'ox_inventory'
author 'Overextended'
version      '2.25.0'
repository 'https://github.com/overextended/ox_inventory'
description 'Slot-based inventory with item metadata support'

--[[ Manifest ]] --
dependencies {
	'/server:6116',
	'/onesync',
	'oxmysql',
	'ox_lib',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
}

shared_scripts {
	'@ox_lib/init.lua',
	'modules/init.lua'
}

ui_page 'web/build/index.html'

files {
	'client.lua',
	'server.lua',
	'locales/*.json',
	'web/build/index.html',
	'web/build/assets/*.js',
	'web/build/assets/*.css',
	'web/images/*.png',
	'modules/**/shared.lua',
	'modules/**/client.lua',
	'modules/bridge/**/client.lua',
	'data/*.lua',
}
