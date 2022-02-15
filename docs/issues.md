---
title: Common issues
---

### Inventory does not open
If the inventory is not displaying after starting the resource, either an error has occurred (view the console) or you have downloaded the source code.
You most likely downloaded the source code and didn't download the release zip of the inventory or you didn't build the UI.
!!! check "Solution"
	Download the [latest release](https://github.com/overextended/ox_inventory/releases/latest) and not the file marked `-src`, or build the UI manually with `yarn`.

	If the cause was an error, view the source of the error; if you are unable to determine the cause, post an [issue](https://github.com/overextended/ox_inventory/issues/new) with all relevent information (error message, the code throwing an error).


<br><br>

### Unable to access inventory after death
You are not triggering the correct event after respawning, so the variable to store if you are dead is set as true.  
This is usually due to using outdated resources for ESX 1.1.
!!! check "Solution"
	You can either update your resource, or trigger the following event where appropriate.
	```lua
	TriggerEvent('esx:onPlayerSpawn')
	```
