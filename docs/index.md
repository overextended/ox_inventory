---
title: Getting Started
---

## Requirements
###OxMySQL
A new lightweight database wrapper utilising [node-mysql2](https://github.com/sidorares/node-mysql2), unlike the abandoned ghmattimysql and mysql-async resources.

- Improved performance and compatibility
- Resolves issues when using MySQL 8.0
- Returns callbacks immediately, removing up to 50ms overhead
- Lua sync wrappers utilise promises to remove additional overhead

!!! attention
	Config is currently hardcoded! Modify your connection settings inside oxmysql.js

[Download :fontawesome-solid-download:](https://github.com/overextended/oxmysql){ .md-button .md-button--primary }	[Documentation :fontawesome-solid-book:](https://overextended.github.io/oxmysql){ .md-button .md-button--primary }

###Framework
While the inventory is technically designed for use with **ESX Legacy**, it will not work without modifications.

- For your convenience, we provide a standard fork of ESX to maintain compatibility and add support when using Ox Inventory.
	- [Standard fork](https://github.com/overextended/es_extended)

- We also provide a modified ESX that contains some breaking changes - this is _not_ recommended for beginners.
	- [Experimental](https://github.com/overextended/es_extended/tree/ox)

!!! tip
	If you prefer to modify your copy of ESX Legacy you will need to reference the changes in the [github diff](https://github.com/overextended/es_extended/commit/c232ff157e219c111e7b484af2375a2859ac331d)

!!! info "Load order"
	```
	ensure oxmysql
	ensure es_extended
	ensure ox_inventory
	```


## Common issues
??? help "Unable to access inventory after death"
	You have not triggered the correct event after respawning, so your PlayerData recognises you as dead (often due to an outdated esx_ambulancejob).
	Modify the function or event used to respawn/revive your character to also trigger the following event.
	```lua
	TriggerEvent('esx:onPlayerSpawn')
	```