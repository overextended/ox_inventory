fx_version 'cerulean'
game 'gta5'
author 'Overextended'
description 'https://github.com/overextended/ox_inventory'
versioncheck 'https://raw.githubusercontent.com/overextended/ox_inventory/main/fxmanifest.lua'
version '2.0.0'

dependencies {
	'/server:4394',
	'/onesync',
	'es_extended'
}

shared_scripts {
	'@es_extended/imports.lua',
	'modules/*.lua'
}

--server_script 'setup/convert.lua'

ui_page 'web/build/index.html'

files {
	'web/build/index.html',
	'web/build/**/*',
	'conf*.lua',
	'modules/**/shared.lua',
	'modules/**/client.lua',
	'data/*.lua',
	'data/**/*.lua',
	'cl*.lua'
}
