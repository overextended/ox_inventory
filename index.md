---
title: Installation
---

| [Installation](index) | [Usage](usage) | [Snippets](snippets) | [Other Resources](resources) | [Media](media)

<h1 align='center'>Requirements</h1>

* OneSync must be enabled on your server (Legacy or Infinity)
* You can use OneSync for up to 32 slots without being a FiveM patron
* [ghmattimysql](https://github.com/GHMatti/ghmattimysql/releases)
* [mythic_progbar](https://github.com/thelindat/mythic_progbar)
* [mythic_notify](https://github.com/thelindat/mythic_notify)
* ESX Framework ([ExtendedMode](https://github.com/extendedmode/extendedmode/tree/dev) or [v1 Final](https://github.com/esx-framework/es_extended/tree/v1-final))
* Or download my modified [ExtendedMode](https://github.com/thelindat/extendedmode) or [v1 Final](https://github.com/thelindat/es_extended)

<br>

<h2 align='center'>Updating from hsn-inventory</h2>
Revert any changes from the previous version of the inventory (you can start fresh or use my included framework edits)


<h2 align='center'>Modifying third-party resources</h2>

* Add the following code to ghmattimysql-server.lua
```lua
exports("ready", function (callback)
	Citizen.CreateThread(function ()
		while GetResourceState('ghmattimysql') ~= 'started' do
			Citizen.Wait(0)
		end
		callback()
	end)
end)
```
* Delete `config.json` to fallback to using the MySQL connection string in server.cfg

Moving items around while the inventory is refreshing can cause the client to desync; while I do plan to resolve the cause I recommend locking the inventory during certain situations.
* [esx_jobs] When the Work() function is running for a player, trigger `TriggerEvent('linden_inventory:busy', true)`; toggle it off once their task is complete
* When an item is added or removed from the player inventory while they are moving it (typically going to use a progressbar, I recommend the above)


<h2 align='center'>Framework Modifications Guides</h2>
<h3 align='center'>| <a href='todo'>ExtendedMode</a> | <a href='esx'>ESX v1 Final<a> |
