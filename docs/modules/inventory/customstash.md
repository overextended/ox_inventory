---
title: Creating custom stashes
---
The client can request inventory data from any inventory type and id and the server will create one if the id is valid.  
Stashes will not always have a defined template, so it is necessary to register them on the server before a client can request it.  

!!! info
	```lua
	exports.ox_inventory:RegisterStash(id, label, slots, maxWeight, owner)
	exports.ox_inventory:RegisterStash('someid', 'Inventory label', 10, 10000, true)
	```
	
	| Argument  | Type    | Optional | Explanation |
	| --------- | ------- | -------- | ----------- |
	| id        | str/int | no       | A unique identifier used to access and store the stash |
	| label     | string  | no       | The text to display when the stash is opened |
	| slots     | integer | no       | The number of slots for storing items |
	| maxWeight | integer | no       | The maximum amount of weight that can be held |
	| owner     | string  | yes      | The identifier of the stash owner, or true for personal stashes |

	The reasoning for this function is to provide easier integration with other resources and prevention of arbitrarily created stashes defined by the client.


You can reference [esx_property](https://github.com/thelindat/esx_property/commit/0dfe120ac4401dce17946b79b12c1b6049851d98#diff-d4503a9550899ea7880582e02d5404019dbce696d1b27a7c63f18b99eddeb088) for a sample of utilising this export.