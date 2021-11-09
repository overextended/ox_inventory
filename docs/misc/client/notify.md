---
title: Notify
---
Triggers the builtin notification system, utilising [react-hot-toast](https://github.com/timolins/react-hot-toast).

!!! info
	```lua
	Notify(data)
	```
	```lua
	exports.ox_inventory:notify(data)
	```
	```lua
	TriggerEvent('ox_inventory:notify', data)
	```
	This event is networked and can be triggered from the server.

	| Options  | Explanation |
	| -------- | ----------- |
	| type     | undefined, success, error |
	| text     | Message to display |
	| duration | Display time of notification |
	| position | Where to display the notification |
	| style    | Custom CSS styling to apply |

!!! example
	```lua
	TriggerEvent('ox_inventory:notify', {type = 'error', text = 'Lost access to the target inventory'})
	```