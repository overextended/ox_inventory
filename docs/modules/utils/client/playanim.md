---
title: Utils.PlayAnim
---
Requests and plays an animation on the player asynchronously.

!!! info
	```lua
	Utils.PlayAnim(wait, ...)
	```
	
	| Argument | Type         | Optional | Explanation |
	| -------- | ------------ | -------- | ----------- |
	| wait     | integer      | no       | Time to wait until clearing task and animdict |
	| args     | any          | no       | [TaskPlayAnim](TaskPlayAnimAdvanced)

!!! example
	```lua
	Utils.PlayAnim(1000, 'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
	```