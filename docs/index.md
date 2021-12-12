---
title: Getting Started
---
!!! danger
	**Not ready for production servers - this resource is still being developed**

	This resource is being designed with the intention of providing advanced functionality while remaining easy to use, however it is not recommended for beginners.
	You must possess a basic understanding of coding and the ability to _read documentation_; otherwise you should not install this resource.

## Dependencies

### FXServer
The minimum required version of FXServer is build [5053](https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/5053-fb44d7add0afa5021d32057164ac3930738d65b4/server.7z), anything earlier will prevent the resource from starting.

### OxMySQL
We utilise our own resource to communicate with MySQL databases via the [node-mysql2](https://github.com/sidorares/node-mysql2) package. The backend is actively maintained and updated unlike the package used by mysql-async, providing improved performance, security, and features. We provide full backwards compatibility with mysql-async and build for the current Cfx architecture.  
- Improved performance, stability, and compatibility with MySQL 8.0
- Support for prepared statements, providing increased security
- Import library provides full compatibility with mysql-async
- Schedule resource ticks to improve export response times by 50ms
- Utilise promises to further improve export response times by 100%
- No overhead when using sync export variants

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

### ESX Framework
The inventory is being moved towards a _standalone_ design, with compatibility for a modified version of **ESX Legacy**.  
For convenience, we provide a fork with all the necessary changes as well as several new features and performance improvements.  

There should be no changes which break compatibility with other resources with the exception of what is necessary to support the inventory and new item system.  
- Loadouts do not exist, so errors will occur in third-party resources attempting to manipulate them
- Inventories are slot-based and items can exist in multiple slots, which can throw off item counting
- Resources attempting to iterate through inventories in order will not work if a slot is empty

!!! tip "Modifying your framework"
	We do not provide a guide for manually converting your ESX to support Ox Inventory; instead you will need to manually reference changes in the [github diff](https://github.com/overextended/es_extended/compare/58042fb6926769aeab35fe26fa98d568971ba0be...main).
	This _may_ change sometime after release when we have finalised the necessary changes.

[GitHub :fontawesome-brands-github:](https://github.com/overextended/es_extended){ .md-button .md-button--primary }

## Optional resources
### qtarget
A high performance targeting solution based on bt-target, and the basis for qb-target.  
It is being updated alongside Ox Inventory to improve support as well as add compatibility when using QBCore or migrating from bt-target.  
All stashes and shops will utilise PolyZone's instead of markers to interact with them.

!!! attention
	If you wish to use it first you must ensure that `Config.Target` is set to true in the config.lua file of the inventory.
	You will need to enable compatibility manually by adjusting your config - more information provided below.

	You must start qtarget _before_ the inventory and _after_ es_extended.

[GitHub :fontawesome-brands-github:](https://github.com/overextended/qtarget){ .md-button .md-button--primary }

## Configuration
Default inventory settings are stored in `config.lua`, however the recommended method of overriding them is through convars.  
You can either add these directly to your `server.cfg`, or create a file called `.cfg` in the resource folder.
```
setr ox_inventory {
    "locale": "en",
    "qtarget": true,
    "keys": [
        "F2", "K", "TAB"
    ]
}
set ox_inventory_server {
    "logs": true,
    "pricevariation": false
}
ensure ox_inventory
```
If you create your own config file you can load it with `exec @ox_inventory/.cfg` instead of ensure.

## Installation
=== "Fresh ESX"
	- Execute the query inside [install.sql](https://github.com/overextended/ox_inventory/blob/main/setup/install.sql)

=== "Convert ESX"
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

### ESX xPlayer vs Inventory
All item related functions from xPlayer, such as `xPlayer.getInventoryItem`, have been modified for compatibility purposes; however they are considered deprecated.

The reasoning is fairly simple - there's now additional function references and overhead to consider. Fortunately, the new Inventory functions can be used directly and offer a great deal of improvements over the old ones.

You should read through the modules section for further information, but the following should give you a decent idea.

!!! example "xPlayer.getInventoryItem and xPlayer.removeInventoryItem"
	=== "Deprecated"
		```lua
		if xPlayer.getInventoryItem('acetone').count > 2 and xPlayer.getInventoryItem('antifreeze').count > 4 and xPlayer.getInventoryItem('sudo').count > 9 then 
			xPlayer.removeInventoryItem("acetone", 3)
			xPlayer.removeInventoryItem("antifreeze", 5)
			xPlayer.removeInventoryItem("sudo", 10)
		end
		```
	=== "New function"
		Add the following code somewhere in your resource
		```lua
		Inventory = GetResourceState('ox_inventory') == 'started' and exports.ox_inventory:Inventory()
		AddEventHandler('ox_inventory:loadInventory', function(module)
			Inventory = module
		end)
		```

		You will be able to reference any functions exposed through the exported table.
		```lua
		local items = Inventory.Search(source, 2, {'acetone', 'antifreeze', 'sudo'})
		if items and items.acetone > 2 and items.antifreeze > 4 and items.sudo > 9 then
			Inventory.RemoveItem(source, 'acetone', 3)
			Inventory.RemoveItem(source, 'antifreeze', 5)
			Inventory.RemoveItem(source, 'sudo', 10)
		end
		```
