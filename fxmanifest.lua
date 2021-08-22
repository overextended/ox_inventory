fx_version 'cerulean'
game 'gta5'
author 'Overextended'
description 'https://github.com/overextended/ox_inventory'
versioncheck 'https://raw.githubusercontent.com/overextended/ox_inventory/main/fxmanifest.lua'
version '2.0.0'

dependencies {
	'es_extended'
}

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua',
	'modules/*.lua'
}

client_scripts {
	'cl*.lua'
}

server_scripts {
	'server.lua'
}

ui_page 'web/build/index.html'

files {
	'web/build/index.html',
	'web/build/**/*',
	'modules/**/shared.lua',
	'modules/**/client.lua',
	'data/*.lua',
	'data/**/*.lua'
}
