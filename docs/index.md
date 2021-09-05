---
title: Getting Started
---

## Requirements
#### OxMySQL
A new lightweight database wrapper utilising node-mysql2.

Unlike ghmattimysql/mysql-async, we utilise [https://github.com/sidorares/node-mysql2]node-mysql2 and have a solution for delayed function callbacks. You can expect responses to resolve ~50ms sooner, and no additional overhead when using the Sync export wrappers.

!!! attention
	Config is currently hardcoded! Modify your connection settings inside oxmysql.js

[Download](https://github.com/overextended/oxmysql) | [Documentation](https://overextended.github.io/oxmysql)

#### Framework
While the inventory is technically designed for use with **ESX Legacy**, it will not work without modifications.

- For your convenience, we provide a standard fork of ESX to maintain compatibility and add support when using Ox Inventory.
	- [Standard fork](https://github.com/overextended/es_extended)

- We also provide a modified ESX that contains some breaking changes - this is _not_ recommended for beginners.
	- [Experimental](https://github.com/overextended/es_extended/tree/ox)



!!! tip
	If you prefer to modify your copy of ESX Legacy you will need to reference the changes in the [github diff](https://github.com/overextended/es_extended/commit/c232ff157e219c111e7b484af2375a2859ac331d)


!!! info "Load order"
	```
	ensure es_extended
	ensure oxmysql
	ensure ox_inventory
	```



## Common issues
??? help "Unable to access inventory after death"
	You have not triggered the correct event after respawning, so your PlayerData recognises you as dead (often due to an outdated esx_ambulancejob).
	Modify the function or event used to respawn/revive your character to also trigger the following event.
	```lua
	TriggerEvent('esx:onPlayerSpawn')
	```