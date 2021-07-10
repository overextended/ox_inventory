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

I recommend downloading [my fork](https://github.com/thelindat/es_extended) for ease of use, otherwise you can manually modify the [official release](https://github.com/esx-framework/esx-legacy) instead.

If you are modifying your framework, reference [this page](framework) for instructions.


<h2 align='center'> Server Config </h2>

```lua
set mysql_connection_string "mysql://user:password@localhost/database?waitForConnections=true&charset=utf8mb4"
set onesync legacy		# do not use infinity unless you know what you're doing
set sv_enforceGameBuild 2060	# enable Los Santos Summer Special build, or use 2189 for Cayo Perico

add_ace resource.es_extended command.add_ace allow
add_ace resource.es_extended command.add_principal allow
add_ace resource.es_extended command.remove_principal allow
add_ace resource.es_extended command.stop allow

ensure chat
ensure spawnmanager
ensure sessionmanager
ensure hardcap

ensure mysql-async
ensure ghmattimysql
ensure cron
ensure es_extended

ensure esx_menu_default
ensure esx_menu_list
ensure esx_menu_dialog

ensure skinchanger
ensure esx_skin
ensure esx_identity
#
#
#
#
#
ensure linden_inventory		# load after resources that register items, or just last
```
