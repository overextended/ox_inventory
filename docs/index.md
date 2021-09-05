---
title: Getting Started
---
##Requirements
###OxMySQL
A new lightweight database wrapper utilising [node-mysql2](https://github.com/sidorares/node-mysql2), unlike the abandoned ghmattimysql and mysql-async resources.

- Improved performance and compatibility
- Resolves issues when using MySQL 8.0
- Returns callbacks immediately, removing up to 50ms overhead
- Lua sync wrappers utilise promises to remove additional overhead

!!! attention
	Config is currently hardcoded! Modify your connection settings inside oxmysql.js

[Download :fontawesome-solid-download:](https://github.com/overextended/oxmysql){ .md-button .md-button--primary }	[Documentation :fontawesome-solid-book:](https://overextended.github.io/oxmysql){ .md-button .md-button--primary }

<br><br>

###Framework
The inventory has been designed to work for a _modified_ version of **ESX Legacy** and will not work with anything else.  
For convenience, we provide a fork with all necessary changes.

- Standard: Minimal changes to maintain near-complete compatibility with other resources
- Ox: Experimental branch to add new features and modify existing features, regardless of breaking compatibility

[Standard :fontawesome-solid-archive:](https://github.com/overextended/es_extended){ .md-button .md-button--primary }	[Experimental :fontawesome-solid-exclamation-triangle:](https://github.com/overextended/es_extended/tree/ox){ .md-button .md-button--primary }

!!! tip "Modifying your framework"
	If you _insist_ on manually applying changes to your framework, you will need to manually reference changes in the [github diff](https://github.com/overextended/es_extended/commit/c232ff157e219c111e7b484af2375a2859ac331d). No guide is provided.

!!! info "Load order"
	```
	ensure oxmysql
	ensure es_extended
	ensure ox_inventory
	```


##Common issues
??? help "Unable to access inventory after death"
	You are not triggering the correct event after respawning, so the variable to store if you are dead is set as true. This is usually due to using outdated resources for ESX 1.1.

	You can either update your resource, or trigger the following event where appropriate.

	```lua
	TriggerEvent('esx:onPlayerSpawn')
	```