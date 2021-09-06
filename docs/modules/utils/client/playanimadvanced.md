---
title: Utils.PlayAnimAdvanced
---
Requests and plays an advanced animation on the player asynchronously.

!!! info
	```lua
	Utils.PlayAnimAdvanced(wait, ...)
	```
	
	| Argument | Type         | Optional | Explanation |
	| -------- | ------------ | -------- | ----------- |
	| wait     | integer      | no       | Time to wait until clearing task and animdict |
	| args     | any          | no       | [TaskPlayAnimAdvanced](https://docs.fivem.net/natives/?_0x83CDB10EA29B370B)

!!! example
	```lua
	Utils.PlayAnimAdvanced(800, false, 'reaction@intimidation@1h', 'intro', GetEntityCoords(ESX.PlayerData.ped, true), 0, 0, GetEntityHeading(ESX.PlayerData.ped), 8.0, 3.0, -1, 50, 1, 0, 0)
	```