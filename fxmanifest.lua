--[[ FX Information ]]--
fx_version   'cerulean'
use_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'

--[[ Resource Information ]]--
name         'ox_inventory'
author       'Overextended'
version      '2.0.0'
repository   'https://github.com/overextended/ox_inventory'
description  'local function ReleaseDate() local soon_tm = promise.new(); Citizen.Await(soon_tm); end'

--[[ Manifest ]]--
dependencies {
	'es_extended',
	'oxmysql',
	'pe-lualib'
}

shared_scripts {
	'@pe-lualib/init.lua',
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
