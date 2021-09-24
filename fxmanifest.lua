fx_version 'cerulean'
game 'gta5'
author 'Overextended'
description 'https://github.com/overextended/ox_inventory'
versioncheck 'https://raw.githubusercontent.com/overextended/ox_inventory/main/fxmanifest.lua'
version '2.0.0'
lua54 'yes'
use_fxv2_oal 'yes'

dependencies {
	'es_extended'
}

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua',
	'modules/*.lua'
}

--server_script 'setup/convert.lua'

ui_page 'web/build/index.html'

files {
	'web/build/index.html',
	'web/build/**/*',
	'modules/**/shared.lua',
	'modules/**/client.lua',
	'data/*.lua',
	'data/**/*.lua',
	'cl*.lua'
}