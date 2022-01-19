<div align='center'><img src='https://user-images.githubusercontent.com/65407488/147992899-93998c0a-75fb-4055-8c06-8da8c49342d6.png'/></div>
<div align='center'><h3><a href='https://overextended.github.io/ox_inventory/'>Read the documentation for setup, installation, and integration</a></h3></div>


# Framework

Currently, this requires our _**[fork of ESX Legacy](https://github.com/overextended/es_extended/)**_ for some features, loading, and user data. The inventory was designed with the intention to move towards a more generic / standalone structure so it can be integrated into any framework without hassle, but that's for a future update.

I will be working on a guide for manually updating your own ESX _sometime soon™_, around the time I setup more event handlers to remove the last parts of the code that make ESX a dependency.

# Logging

The included logging module utilises datadog to store logging data, which can be expanded for improved analytics and metrics. Register an account at [datadoghq](https://www.datadoghq.com/).  
The _free plan_ is enough for most user's purposes and provides far more utility than the typical weird discord logs utilised in other resources.  

Once you have registered, generate an API key and add `set datadog:key 'apikey'` to your server config.


# Features

### Shops

- Creates different shops for 24/7, Ammunation, Liquor Stores, Vending Machines, etc.
- Job restricted shops, such as a Police Armoury.
- Items can be restricted to specific job grades and licenses.
- Define the price for each item, and even allow different currency (black money, poker chips, etc).


### Items

- Generic item data shared between objects.
- Specific data stored per-slot, with metadata to hold custom information.
- Weapons, attachments, and durability.
- Flexible item use allows for progress bars, server callbacks, and cancellation with simple functions and exports.
- Support for items registered with ESX.


### Stashes

- Server-side security prevents arbitrary access to any stash.
- Support personal stashes, able to be opened with different identifiers.
- Job-restricted stashes as well as a police evidence locker.
- Server exports allow for registration of stashes from any resource (see [here](https://github.com/overextended/ox_inventory_examples/blob/main/server.lua)).
- Access small stashes via containers, such as paperbags, from using an item.
- Vehicle gloveboxes and trunks, for both owned and unowned.


### Temporary stashes

- Dumpsters, drops, and non-player vehicles.
- Loot tables allow users to find random items in dumpsters and unowned vehicles.


<br><div><h4 align='center'><a href='https://discord.gg/overextended'>Discord Server</a></h4></div><br>


<table><tr><td><h3 align='center'>Legal Notices</h2></tr></td>
<tr><td>
Ox Inventory for ESX Legacy  

Copyright © 2022  [Linden](https://github.com/thelindat), [Dunak](https://github.com/dunak-debug), [Luke](https://github.com/LukeWasTakenn)


This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.  


This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.  


You should have received a copy of the GNU General Public License
along with this program.  
If not, see <https://www.gnu.org/licenses/>
</td></tr></table>
