<div align='center'><img src='https://user-images.githubusercontent.com/65407488/147992899-93998c0a-75fb-4055-8c06-8da8c49342d6.png'/>
<h2><a href='https://overextended.dev/ox_inventory'>Documentation</a></h3></div>

## Config

Resource configuration is handled using convars. Refer to the documentation for more information.

## Framework

The inventory was designed with limited reliability on frameworks, preferring frameworks _designed to use ox_inventory_. A framework is still necessary for handling certain features such as

- Loading player inventories.
- Owned vehicles.
- Licenses.
- Group/job systems.

Compatibility for frameworks is handled in the "bridge" module, and by default includes

- [ox_core](https://github.com/overextended/ox_core)
- [es_extended](https://github.com/esx-framework/esx_core)
- [qbx-core](https://github.com/Qbox-project/qbx_core) or [qb-core](https://github.com/qbcore-framework/qb-core)
- [nd_core](https://github.com/ND-Framework/ND_Core)

Do not expect 100% compatibility or support for third party frameworks.

## Features

## Logging

Logging is built-in using ox_lib's [logger](https://overextended.dev/ox_lib/Modules/Logger/Server#liblogger) module, using Datadog or Grafana Loki. Discord is not and will not be supported.

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

<br><div><h4 align='center'><a href='https://discord.gg/hmcmv3P7YW'>Discord Server</a></h4></div><br>

<table><tr><td><h3 align='center'>License</h3></tr></td>
<tr><td>
Ox Inventory


Copyright © 2023 Overextended (https://github.com/overextended)

Linden (https://github.com/thelindat)

Luke (https://github.com/LukeWasTakenn)

Dunak (https://github.com/dunak-debug)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.
If not, see <https://www.gnu.org/licenses/>

</td></tr></table>
