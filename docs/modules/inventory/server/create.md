---
title: Inventory.Create
---
Creates a new inventory from the given arguments. This is an _internal_ function only.

!!! info
	```lua
	Inventory.Create(id, label, type, slots, weight, maxWeight, owner, items)
	```

	| Argument  | Type    | Optional | Explanation |
	| --------- | ------- | -------- | ----------- |
	| id        | string / integer | no       | A unique identifier for the inventory to create |
	| label     | string  | yes      | A generic name for the inventory to display |
	| type      | string  | no       | The inventory's type (player, stash, etc) |
	| slots     | integer | no       | Total number of unique slots |
	| weight    | integer | no       | Weight of contents (usually 0) |
	| maxWeight | integer | no       | Total weight inventory can hold |
	| owner     | string  | yes      | Identifier for the inventory's owner |
	| items     | table   | yes      | Items to load into the inventory |

	If no value is submitted for items then it will attempt to load them from the database instead.


#### Class methods
These functions are self-referencing, and allow setting or getting data from other resources, or triggering effects when updating a value.
!!! info
	```lua
	Inventory:set(key, value)
	```
	Updates the key to reflect the new value. When closing an inventory it updates the time an inventory was last accessed, and deletes empty drops.

!!! info
	```lua
	Inventory:get(key)
	```
	Gets the current value of a key. Generally not needed (you can reference Inventory.key instead).

!!! info
	```lua
	Inventory:minimal()	
	```
	Returns a "minimal" inventory, with most data removed. Generally used when saving to the database.