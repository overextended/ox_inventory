---
title: Common Issues
---

#### When I die I am unable to open my inventory
- You are not triggering the proper ESX event when spawning after death `TriggerEvent('esx:onPlayerSpawn')`

#### I receive an error about calling a nil function (setAccount)
- You have not applied the necessary modifications to ESX or are not using my fork

#### Calling my inventory from another resource returns empty
- You need to use `xPlayer.getInventory()` to retrieve the player inventory

#### Buying items does not remove my money
- Shops will remove money from your bank account by default
