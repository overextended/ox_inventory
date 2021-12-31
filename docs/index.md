---
title: Getting Started
---
!!! warning
	**Documentation is still being improved - you may find some information lacking or missing.**

	This resource is being designed with the intention of providing advanced functionality while remaining easy to use, however it is not recommended for beginners.
	You must possess a basic understanding of coding and the ability to _read_; otherwise you should not install this resource.

## Dependencies

### FXServer
The minimum required version of FXServer is build [5104](https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/5104-5ebb6dfe826667c841027d6dbc7390e42abfb196/server.7z), anything earlier will prevent the resource from starting.

### OxMySQL
We utilise our own resource to communicate with MySQL databases via the [node-mysql2](https://github.com/sidorares/node-mysql2) package. The backend is actively maintained and updated unlike the package used by mysql-async, providing improved performance, security, and features. We provide full backwards compatibility with mysql-async and build for the current Cfx architecture.  


[GitHub :fontawesome-brands-github:](https://github.com/overextended/oxmysql/releases){ .md-button .md-button--primary }	[Documentation :fontawesome-solid-book:](https://overextended.github.io/oxmysql){ .md-button .md-button--primary }

<br>

### Lua Library
A resource designed to provide reusable functions that can be loaded into any resource with simple variable declarations rather than through fxmanifest.  
Still a work in progress.  

**Currently used for**  

- SetInterval
- Server Callbacks
- Table utilities (contains, matches)
- Requesting models, animations, etc.
- Disabling control actions

[GitHub :fontawesome-brands-github:](https://github.com/project-error/pe-lualib){ .md-button .md-button--primary }

<br>

### "Ox" ESX
The inventory is being moved towards a _standalone_ design, with compatibility for a modified version of **ESX Legacy**.  
For convenience, we provide a fork with all the necessary changes as well as several new features and performance improvements.  

There should be no changes which break compatibility with other resources with the exception of what is necessary to support the inventory and new item system.  

- Loadouts do not exist, so errors may occur if a third-party resource attempts to manipulate them
- Inventories are slot-based and items can exist in multiple slots, which can throw off item counting
- Resources attempting to iterate through inventories in order will not work if a slot is empty

We are in the process of converting some common [ESX resources](https://github.com/overextended/esx-legacy) to better support our releases.  
Some code is being changed for later reference while a txAdmin recipe is prepared.  
- esx_status: fixed some bugs and rework for oxmysql
- esx_addoninventory: registers addon_inventory inventories as valid stash targets

!!! tip "Modifying your framework"
	We do not provide a guide for manually converting your ESX to support Ox Inventory; instead you will need to manually reference changes in the [github diff](https://github.com/overextended/es_extended/compare/58042fb6926769aeab35fe26fa98d568971ba0be...main).
	This _may_ change sometime after release when we have finalised the necessary changes.

[GitHub :fontawesome-brands-github:](https://github.com/overextended/es_extended){ .md-button .md-button--primary }

<br>

### Ox Inventory build
The interface is written in TypeScript using the React framework, so the code included in the repository _will not do anything_. You either need to build he package yourself (more information in [guides](./guides), or download a release.

[GitHub :fontawesome-brands-github:](https://github.com/overextended/ox_inventory/releases){ .md-button .md-button--primary }

## Optional resources
### qtarget
A high performance targeting solution based on bt-target, and the basis for qb-target.  
It is being updated alongside Ox Inventory to improve support as well as add compatibility when using QBCore or migrating from bt-target.  
All stashes and shops will utilise PolyZone's instead of markers to interact with them.

!!! attention
	If you wish to use it first you must ensure that qtarget is enabled in the resource convars.
	You will need to enable compatibility manually by adjusting your config - more information provided below.

	You must start qtarget _before_ the inventory and _after_ es_extended.

[GitHub :fontawesome-brands-github:](https://github.com/overextended/qtarget){ .md-button .md-button--primary }

## Configuration
Default inventory settings are stored in `config.lua`, however the recommended method of overriding them is through convars.  
You can either add these directly to your `server.cfg`, or create a file called `.cfg` in the resource folder.  
You can add these settings directly to your 'server.cfg', or create a new (or multiple) file to load with 'exec'
```
setr ox_inventory {
    "esx": true,
    "trimplate": true,
    "qtarget": false,
    "playerslots": 50,
    "blurscreen": true,
    "autoreload": true,
    "keys": [
        "F2", "K", "TAB"
    ],
    "enablekeys": [
        249
    ],
    "playerweight": 30000,
    "police": "police",
    "locale": "en"
}

set ox_inventory_server {
    "versioncheck": true,
    "clearstashes": "6 MONTH",
    "logs": false,
    "randomprice": true,
    "evidencegrade": 2,
    "randomloot": true
}

set ox_inventory_loot {
    "vehicle": [
        ["cola", 1, 1],
        ["water", 1, 1],
        ["garbage", 1, 2, 50],
        ["panties", 1, 1, 5],
        ["money", 1, 50],
        ["money", 200, 400, 5],
        ["bandage", 1, 1]
    ],

    "dumpster": [
    	["mustard", 1, 1],
        ["garbage", 1, 3],
        ["money", 1, 10],
        ["burger", 1, 1]
    ]
}

add_principal group.admin ox_inventory
add_ace resource.ox_inventory command.add_principal allow
add_ace resource.ox_inventory command.remove_principal allow

ensure ox_inventory
```

## Installation
=== "Fresh ESX"
	- Download [our fork of ESX](#esx-framework)
	- Execute the query inside [install.sql](https://github.com/overextended/ox_inventory/blob/main/setup/install.sql)

=== "Convert ESX"
	- Download [our fork of ESX](#esx-framework)
	- Execute the query inside [install.sql](https://github.com/overextended/ox_inventory/blob/main/setup/install.sql)
	- Open `fxmanifest.lua` and uncomment `server_script 'setup/convert.lua'`
	- Start the server and execute the `convertinventory` command from the console
	- Remove the conversion file

=== "Upgrade from Linden Inventory"
	- Execute the query inside [upgrade.sql](https://github.com/overextended/ox_inventory/blob/main/setup/upgrade.sql)
	- Open `fxmanifest.lua` and uncomment `server_script 'setup/convert.lua'`
	- Start the server and execute the `convertinventory linden` command from the console
	- Remove the conversion file

	This will not update your items file and old items may be incompatible; refer to documentation for item creation

!!! attention
	You should restart your server after the first startup to ensure everything has been correctly setup


## Upgrading ESX
Ox Inventory provides a complete suite of tools to replace the built-in items and inventory system from ESX, and is not intended to be used with resources designed around it.

- ESX loadouts do not exist - resources that use them need to remove references or be modified to look for the weapon as an item
- Stashes from resources such as esx_policejob, esx_ambulancejob, etc. should be removed
- Shops from esx_shops or the armoury from esx_policejob should be removed
- Resources like esx_inventoryhud, esx_trunkinventory, esx_addoninventory, etc. should be removed

### xPlayer vs exports.ox_inventory
All item related functions from xPlayer, such as `xPlayer.getInventoryItem`, have been modified for compatibility purposes; however they are considered deprecated.

The reasoning is fairly simple - there's now additional function references and overhead to consider. Fortunately, the new Inventory functions can be used directly and offer a great deal of improvements over the old ones.

You should read through the modules section for further information, but the following should give you a decent idea.

!!! example "xPlayer.getInventoryItem and xPlayer.removeInventoryItem"
	=== "ESX"
		```lua
		if xPlayer.getInventoryItem('acetone').count > 2 and xPlayer.getInventoryItem('antifreeze').count > 4 and xPlayer.getInventoryItem('sudo').count > 9 then 
			xPlayer.removeInventoryItem("acetone", 3)
			xPlayer.removeInventoryItem("antifreeze", 5)
			xPlayer.removeInventoryItem("sudo", 10)
		end
		```

	=== "Inventory"
		Add the following code somewhere in your resource to cache the exports metatable.
		```lua
		local ox_inventory = exports.ox_inventory
		```

		You will be able to reference any functions exposed through the export.
		```lua
		local items = ox_inventory:Search(source, 'count', {'acetone', 'antifreeze', 'sudo'})
		if items and items.acetone > 2 and items.antifreeze > 4 and items.sudo > 9 then
			ox_inventory:RemoveItem(source, 'acetone', 3)
			ox_inventory:RemoveItem(source, 'antifreeze', 5)
			ox_inventory:RemoveItem(source, 'sudo', 10)
		end
		```
