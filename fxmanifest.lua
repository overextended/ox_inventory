fx_version 'cerulean'
game 'gta5'
author 'Linden'
description 'https://github.com/thelindat/linden_inventory'
versioncheck 'https://raw.githubusercontent.com/thelindat/linden_inventory/main/fxmanifest.lua'
version '1.2.6'

dependency 'es_extended'
dependency 'ghmattimysql'

client_scripts {
	'config.lua',
	'shared/*.lua',
	'client/*.lua'
}

server_scripts {
	'config.lua',
	'shared/*.lua',
	'server/*.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/script.js',
	'html/images/*.png',
	'html/reset.css',
	'html/style.css'
}
