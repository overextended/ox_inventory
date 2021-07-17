---
title: Introduction
---

<h2 align='center'> Requirements </h2>


* ESX Legacy (Read more below)
* GHMattiMySQL [[Download]](https://github.com/GHMatti/ghmattimysql/releases)
* Mythic Notify [[Download]](https://github.com/thelindat/mythic_notify)
* Mythic Progbar [[Download]](https://github.com/thelindat/mythic_progbar)
* OneSync must be enabled (Legacy or Infinity)
* The ability to follow instructions and learn
* Delete `ghmattimysql/config.json` to fallback to using the MySQL connection string in server.cfg


<h2 align='center'> Framework </h2>


ESX 1.1 (running essentials) has _never_ been compatible, and if you were planning on running it then I don't recommend you bother trying to use this inventory (or running a server, for that matter).  
As of version 1.5.0 you are required to use **ESX Legacy** to use this resource, however the inventory **will not work by default**.

I recommend downloading [my fork](https://github.com/thelindat/es_extended) for ease of use, otherwise you can manually modify the [official release](https://github.com/esx-framework/esx-legacy/tree/main/%5Besx%5D/es_extended) instead.

**If you are modifying your framework, reference [this page](framework) for instructions.**


<h2 align='center'> Server Config </h2>

```lua
# Only change the IP if you're using a server with multiple network interfaces, otherwise change the port only.
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"


sv_hostname "Unconfigured ESX Server"
set steam_webApiKey ""
sv_licenseKey ""
sv_maxclients 10   # Allow access to features usually locked behind a FiveM patreon key

sets sv_projectName "ESX Legacy"
sets sv_projectDesc ""
sets locale "root-AQ"
sets tags "default, esx"
sv_scriptHookAllowed 0

set onesync legacy   # Infinity is not recommended for ESX
set mysql_connection_string "mysql://user:password@localhost/es_extended?waitForConnections=true&charset=utf8mb4"


## These resources will start by default.
ensure chat
ensure spawnmanager
ensure sessionmanager

## Add system admins
add_ace group.admin command allow # allow all commands
add_ace group.admin command.quit deny # but don't allow quit
add_ace resource.es_extended command.add_ace allow
add_ace resource.es_extended command.add_principal allow
add_ace resource.es_extended command.remove_principal allow
add_ace resource.es_extended command.stop allow

## ESX Legacy
ensure mysql-async
ensure cron
ensure skinchanger
ensure es_extended
ensure esx_menu_default
ensure esx_menu_dialog
ensure esx_menu_list
ensure esx_identity
ensure esx_skin

## ESX Addons
ensure linden_inventory            # You may need to load this after resources using ESX.RegisterUsableItem
```
