---
title: Common issues
---
### Unable to access inventory after death
You are not triggering the correct event after respawning, so the variable to store if you are dead is set as true.  
This is usually due to using outdated resources for ESX 1.1.
!!! check "Solution"
	You can either update your resource, or trigger the following event where appropriate.
	```lua
	TriggerEvent('esx:onPlayerSpawn')
	```