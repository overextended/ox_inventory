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
* ESX Framework ([v1 Final](https://github.com/esx-framework/es_extended/tree/v1-final) or [ExtendedMode](https://github.com/extendedmode/extendedmode))

#### If you want to try ExtendedMode
* I have a [modified release](https://github.com/thelindat/extendedmode) with several bug fixes, added features, and required changes already made
* You can also try an experimental [branch](https://github.com/thelindat/extendedmode/tree/kashacters) for use with [kashacters](https://github.com/thelindat/esx_kashacter)

#### Pre-configured ESX
* You can ignore the framework edits and download this file shared on my discord, if you prefer  
[Download](https://cdn.discordapp.com/attachments/816673612621938759/839690298493108234/es_extended.zip)



<h2 align='center'>Updating from hsn-inventory</h2>
Revert any changes from the previous version of the inventory (you can start fresh or use my included framework edits)
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
<br><br>
<h2 align='center'>Modifying your framework</h2>
<a href='exm'>ExtendedMode</a><br>
<a href='esx'>ESX v1 Final<a>
<br><br>


<h2 align='center'>F.A.Qs</h2>

> Why doesn't my money go down after buying an item?  

By default, the shops are set to take money from a players bank. If they don't have enough in the bank, it will check their money.
You can modify shops to accept a specific currency by defining `currency = 'money'` (only accept money).
You can define any item (dirty money, water, a literal rock) - so black markets or exchanging items is possible.


> How can I set up a property stash or police body search?  

Click the Snippets link above for examples using `esx_property` and `esx_policejob`.


> Why does x resource show my inventory as empty?  

If a resource such as `esx_drugs` displays your inventory to sell or convert items, you need to modify the event.
Using `ESX.PlayerData.inventory` isn't going to display anything, you need to use a callback to get the inventory from the server.
Again, click the Snippets link above for an example.
