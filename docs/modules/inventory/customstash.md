---
title: Creating custom stashes
---
The client can request inventory data from any inventory type and id and the server will attempt to create one if there is a data template.  
Stashes will not always have a defined template, so it is necessary to create them on the server before a client can request it.  

!!! info
	```lua
	exports.ox_inventory:CreateStash(id, label, slots, maxWeight, owner, items)
	exports.ox_inventory:CreateStash('someid', 'Inventory label', 10, 10000, true, {cola=1, bread=3})
	```
	
	| Argument  | Type    | Optional | Explanation |
	| --------- | ------- | -------- | ----------- |
	| id        | str/int | no       | A unique identifier used to access and store the stash |
	| label     | string  | no       | The text to display when the stash is opened |
	| slots     | integer | no       | The number of slots for storing items |
	| maxWeight | integer | no       | The maximum amount of weight that can be held |
	| owner     | string  | yes      | The identifier of the stash owner, or true for personal stashes |
	| items     | table   | yes      | Items to be loaded in the stash |

	Items should only be defined for newly created stashes and for converting key-value pairs into compatible items.  
	`{cola = 1, bread = 3}` will be converted to `{{slot = 1, name = cola, count = 1}, {slot = 2 name = bread, count = 3}}`


The reasoning for this function is to provide easier integration with other resources and prevention of arbitrarily created stashes defined by the client.