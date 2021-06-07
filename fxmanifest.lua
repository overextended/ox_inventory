fx_version 'cerulean'
game 'gta5'
author 'Linden'
description 'https://github.com/thelindat/linden_inventory'
versioncheck 'https://raw.githubusercontent.com/thelindat/linden_inventory/main/fxmanifest.lua'
version '1.6.4'

dependencies {
	'es_extended',
	'ghmattimysql'
}

shared_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'shared/*.lua',
	'locales/*.lua'
}

client_scripts {
	'client/*.lua'
}

server_scripts {
	'server/*.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/script.js',
	'html/images/*.png',
	'html/style.css',
}
