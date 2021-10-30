---
title: Common issues
---

### Inventory doesn't open and screen is blurry
You most likely downloaded the source code and didn't download the release zip of the inventory or you didn't build the UI.
!!! check "Solution"
	Either download the release zip from [here](https://github.com/overextended/ox_inventory/releases/latest) or build the UI yourself using `yarn`.

	Although if you're reading this you probably shouldn't attempt to build the UI yourself.

### Unable to access inventory after death
You are not triggering the correct event after respawning, so the variable to store if you are dead is set as true.  
This is usually due to using outdated resources for ESX 1.1.
!!! check "Solution"
	You can either update your resource, or trigger the following event where appropriate.
	```lua
	TriggerEvent('esx:onPlayerSpawn')
	```
