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


<h2 align='center'>Updating from hsn-inventory</h2>
Revert any changes from the previous version of the inventory (you can start fresh or use my included framework edits)
<br><br>
<h2 align='center'>Modifying your framework</h2>
<h3 align='center'>| <a href='exm'>ExtendedMode</a> | <a href='esx'>ESX v1 Final<a> |
<br><br>
<h2 align='center'>Modifying third-party resources</h2>

* Delete `config.json` to fallback to using the MySQL connection string in server.cfg
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

Look at [Snippets](snippets) or [Other Resources](resources) for modifying other resources
