---
title: Getting Started
---
!!! danger
	**Not ready for production servers - this resource is still being developed**

	This resource is being designed with the intention of providing advanced functionality while remaining easy to use, however it is not recommended for beginners.
	You must possess a basic understanding of coding and the ability to _read documentation_; otherwise you should not install this resource.

## Dependencies

### FXServer
Currently incompatible with the recommended build (4394 was released August 21st); you can either download the optional build or just the latest.

### OxMySQL
Our spin on a database wrapper utilising [node-mysql2](https://github.com/sidorares/node-mysql2), providing improved performance and enhanced features.

- Improved performance and compatibility
- Resolves issues when using MySQL 8.0
- Returns callbacks immediately, removing up to 50ms overhead
- Lua sync wrappers utilise promises to remove additional overhead
- Optional import file to provide compatibility with MySQL-async style usage

[GitHub :fontawesome-brands-github:](https://github.com/overextended/oxmysql/releases){ .md-button .md-button--primary }	[Documentation :fontawesome-solid-book:](https://overextended.github.io/oxmysql){ .md-button .md-button--primary }

<br>

### Lua Library
A resource designed to provide reusable functions that can be loaded into any resource with simple variable declarations rather than through fxmanifest.

Still a work in progress.  

**Currently used for**
- [x] Server Callbacks
- [x] Table utilities (contains, matches)

[GitHub :fontawesome-brands-github:](https://github.com/project-error/pe-lualib){ .md-button .md-button--primary }

<br>

### Framework
The inventory has been designed to work for a _modified_ version of **ESX Legacy** and will not work with anything else.  
For convenience, we provide a fork with all the necessary changes as well as several new features and performance changes.  

There should be no changes which break compatibility with other resources with the exception of what is necessary to support the inventory and new item system.

- Loadouts do not exist, so errors will occur in third-party resources attempting to manipulate them
- Inventories are slot-based and items can exist in multiple slots, which can throw off item counting
- Resources attempting to iterate through inventories in order will not work if a slot is empty

!!! tip "Modifying your framework"
	We do not provide a guide for manually converting your ESX to support Ox Inventory; instead you will need to manually reference changes in the [github diff](https://github.com/overextended/es_extended/compare/58042fb6926769aeab35fe26fa98d568971ba0be...ox).

[GitHub :fontawesome-brands-github:](https://github.com/overextended/es_extended){ .md-button .md-button--primary }


## Installation
Once you have downloaded and configured the required resources, you will need to update your server config.
```
ensure oxmysql
ensure es_extended
ensure pe-lualib
ensure ox_inventory
```

??? summary "Fresh ESX install"
	- Run the query inside setup/install.sql
	- That is all?

??? summary "Converting ESX inventories"
	- Run the query inside setup/install.sql
	- Open fxmanifest.lua and uncomment `server_script 'setup/convert.lua'`
	- Start the server and type `convertinventory` into the server console
	- Comment out the conversion file

??? summary "Upgrading from Linden Inventory"
	- Run the query inside setup/upgrade.sql
	- Open fxmanifest.lua and uncomment `server_script 'setup/convert.lua'`
	- Start the server and type `convertinventory linden` into the server console
	- Comment out or remove the conversion file
	
	This will not update your items file and old items may be incompatible; refer to documentation for item creation

Keep the following in mind while developing your server

- ESX loadouts do not exist - resources that use them need to remove references or be modified to look for the item
- Built-in stashes should replace inventories used by resources such as esx_policejob, esx_taxijob, etc.
- Built-in shops should replace esx_shops and the esx_policejob armory, etc.
- You shouldn't be using esx_trunkinventory, esx_inventoryhud, or any other resources that provide conflicting functionality

!!! attention
	You should restart your server after the first startup to ensure everything has been correctly setup


## Recommendations
Ox Inventory provides a complete suite of tools to replace the built-in items and inventory system from ESX, and is not intended to be used with resources designed around it.

- ESX loadouts do not exist - resources that use them need to remove references or be modified to look for the weapon as an item
- Stashes from resources such as esx_policejob, esx_ambulancejob, etc. should be entirely replaced
- Shops from esx_shops or the armoury from esx_policejob should be removed
- Resources like esx_inventoryhud, esx_trunkinventory, esx_addoninventory, etc. should be removed

### xPlayer vs Inventory
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
		```lua
		local Inventory = exports.ox_inventory:Inventory()
		...
		...
		local items = Inventory.Search(source, 2, {'acetone', 'antifreeze', 'sudo'})
		if items and items.acetone > 2 and items.antifreeze > 4 and items.sudo > 9 then
			Inventory.RemoveItem(source, 'acetone', 3)
			Inventory.RemoveItem(source, 'antifreeze', 5)
			Inventory.RemoveItem(source, 'sudo', 10)
		end
		```
