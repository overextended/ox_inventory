# ox_inventory

A complete inventory system for FiveM, implementing items, weapons, shops, and more without any strict framework dependency.

![](https://img.shields.io/github/downloads/overextended/ox_inventory/total?logo=github)
![](https://img.shields.io/github/downloads/overextended/ox_inventory/latest/total?logo=github)
![](https://img.shields.io/github/contributors/overextended/ox_inventory?logo=github)
![](https://img.shields.io/github/v/release/overextended/ox_inventory?logo=github) 

## 📚 Documentation

https://overextended.dev/ox_inventory

## 💾 Download

https://github.com/overextended/ox_inventory/releases/latest/download/ox_inventory.zip

## ✨ Features

- Server-side security ensures interactions with items, shops, and stashes are all validated.
- Logging for important events, such as purchases, item movement, and item creation or removal.
- Supports player-owned vehicles, licenses, and group systems implemented by frameworks.

### Supported frameworks
- [ox_core](https://github.com/overextended/ox_core)
- [es_extended](https://github.com/esx-framework/esx_core)
- [qbx-core](https://github.com/Qbox-project/qbx_core) or [qb-core](https://github.com/qbcore-framework/qb-core)
- [nd_core](https://github.com/ND-Framework/ND_Core)

### Items
- Inventory items are stored per-slot, with customisable metadata to support item uniqueness.
- Overrides default weapon-system with weapons as items.
- Weapon attachments and ammo system, including special ammo types.
- Durability, allowing items to be depleted or removed overtime.
- Internal item system provides secure and easy handling for item use effects.
- Compatibility with 3rd party framework item registration.

### Shops
  - Restricted access based on groups and licenses.
  - Support different currency for items (black money, poker chips, etc).

### Stashes
- Personal stashes, linking a stash with a specific identifier or creating per-player instances.
- Restricted access based on groups.
- Registration of new stashes from any resource.
- Containers allow access to small stashes when using an item, such as a paperbag.
- Access gloveboxes and trunks for any vehicle.
- Random item generation inside dumpsters and unowned vehicles.

## Copyright

Copyright © 2024 Overextended <https://github.com/overextended>

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
