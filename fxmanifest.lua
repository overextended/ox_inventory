fx_version 'adamant'
game 'gta5'
description 'https://github.com/thelindat/hsn-inventory'
version '1.5.5'

client_scripts {
	'config.lua',
	'client.lua'
}

server_scripts {
	'config.lua',
	'server.lua'
}

ui_page "html/index.html"
files {
	'html/index.html',
	'html/script.js',
	'html/style.css',
	'html/reset.css',
	'html/images/*.png',
}

exports {
	'OpenStash',
	'openTargetInventory'
}

server_exports {
	'removeItem',
	'addItem',
	'getItemCount',
	'getItem',
	'canCarryItem',
	'useItem'
}
