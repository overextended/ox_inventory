fx_version 'cerulean'
game 'gta5'
author 'Linden, Dunak'
description 'https://github.com/overextended/ox_inventory'
versioncheck 'https://raw.githubusercontent.com/overextended/ox_inventory/main/fxmanifest.lua'
version '2.0.0'

dependencies {
	'es_extended',
	'ghmattimysql'
}

shared_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'config.lua',
	'main.lua',
}

client_scripts {
	'client.lua'
}

server_scripts {
	'server.lua'
}

ui_page 'html/build/index.html'

files {
	'html/build/index.html',
	'html/build/**/*',
	'modules/*/shared.lua',
	'modules/*/client.lua',
	'data/*.lua'
}
