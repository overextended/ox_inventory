---
title: Getting Started
---
!!! danger
	This resource is being designed with ease of use and advanced functionality as a core principal, however that doesn't mean it is intended for _config kings_.  
	If you do not possess a basic understanding of coding - nor the ability to read documentation - then turn back now and go use a drag-n-drop resource instead.

##Requirements
###OxMySQL
A new lightweight database wrapper utilising [node-mysql2](https://github.com/sidorares/node-mysql2), unlike the abandoned ghmattimysql and mysql-async resources.

- Improved performance and compatibility
- Resolves issues when using MySQL 8.0
- Returns callbacks immediately, removing up to 50ms overhead
- Lua sync wrappers utilise promises to remove additional overhead

!!! attention
	Config is currently hardcoded! Modify your connection settings inside oxmysql.js

!!! note
	When starting for the first time dependencies will be downloaded by [yarn](https://github.com/citizenfx/cfx-server-data/tree/master/resources/%5Bsystem%5D/%5Bbuilders%5D/yarn). You may need to restart your server upon completion.

[Download :fontawesome-solid-download:](https://github.com/overextended/oxmysql/archive/refs/heads/main.zip){ .md-button .md-button--primary }	[Documentation :fontawesome-solid-book:](https://overextended.github.io/oxmysql){ .md-button .md-button--primary }

<br>

###Framework
The inventory has been designed to work for a _modified_ version of **ESX Legacy** and will not work with anything else.  
For convenience, we provide a fork with all necessary changes.

- Standard: Minimal changes to maintain near-complete compatibility with other resources
- Ox: Experimental branch to add new features and modify existing features, regardless of breaking compatibility

!!! tip "Modifying your framework"
	If you _insist_ on manually applying changes to your framework, you will need to manually reference changes in the [github diff](https://github.com/overextended/es_extended/commit/c232ff157e219c111e7b484af2375a2859ac331d). No guide is provided.

[Standard :fontawesome-solid-archive:](https://github.com/overextended/es_extended){ .md-button .md-button--primary }	[Experimental :fontawesome-solid-exclamation-triangle:](https://github.com/overextended/es_extended/tree/ox){ .md-button .md-button--primary }


##Installation
Once you have downloaded and configured the required resources, you will need to update your server config.
```
ensure oxmysql
ensure es_extended
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
	- Comment out the conversion file

Keep the following tips in mind while developing your server

- ESX loadouts do not exist - resources that use them need to remove references or be modified to look for the item
- Built-in stashes should replace inventories used by resources such as esx_policejob, esx_taxijob, etc.
- Built-in shops should replace esx_shops and the esx_policejob armory, etc.
- You shouldn't be using esx_trunkinventory, esx_inventoryhud, or any other resources that provide conflicting functionality

**You should restart your server after the first startup to ensure everything has been correctly setup.**

##Common issues
??? help "Unable to access inventory after death"
	You are not triggering the correct event after respawning, so the variable to store if you are dead is set as true. This is usually due to using outdated resources for ESX 1.1.

	You can either update your resource, or trigger the following event where appropriate.

	```lua
	TriggerEvent('esx:onPlayerSpawn')
	```