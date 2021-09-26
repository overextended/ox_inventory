---
title: Getting Started
---
!!! danger
	**Not ready for production servers - this resource is still being developed**

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
	Modify your server config with a URI-style connection string. You can also set a warning for slow queries.
	```
	set mysql_connection_string "mysql://user:password@host/database?charset=utf8mb4"
	set mysql_slow_query_warning 100
	```

[Download :fontawesome-solid-download:](https://github.com/overextended/oxmysql/releases){ .md-button .md-button--primary }	[Documentation :fontawesome-solid-book:](https://overextended.github.io/oxmysql){ .md-button .md-button--primary }

<br>

###Framework
The inventory has been designed to work for a _modified_ version of **ESX Legacy** and will not work with anything else.  
For convenience, we provide a fork with all necessary changes.

####Standard
Minimal changes to maintain near-complete compatibility with other resources. This matches the behaviour of Linden ESX.

- Loadouts do not exist, so errors will occur in third-party resources attempting to manipulate them
- Inventories are slot-based and items can exist in multiple slots, which can throw off item counting
- Resources attempting to iterate through inventories in order will not work if a slot is empty

####Ox
Experimental branch to add new features and modify existing features, regardless of breaking compatibility.

- Jobs are loaded from a data file instead of the database
- Grades start from 1 instead of 0, and are stored as integers rather than strings

!!! tip "Modifying your framework"
	If you _insist_ on manually applying changes to your framework, you will need to manually reference changes in the [github diff](https://github.com/overextended/es_extended/compare/58042fb6926769aeab35fe26fa98d568971ba0be...main). No guide is provided.

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

Keep the following in mind while developing your server

- ESX loadouts do not exist - resources that use them need to remove references or be modified to look for the item
- Built-in stashes should replace inventories used by resources such as esx_policejob, esx_taxijob, etc.
- Built-in shops should replace esx_shops and the esx_policejob armory, etc.
- You shouldn't be using esx_trunkinventory, esx_inventoryhud, or any other resources that provide conflicting functionality

!!! attention
	You should restart your server after the first startup to ensure everything has been correctly setup
