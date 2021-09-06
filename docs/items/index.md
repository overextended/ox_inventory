---
title: Overview
---
All static item data is loaded from files in the `data` folder rather than the database.  
The item table defines a basic template to reference when working with an instance of that item name, and can contain custom data.

!!! example
	=== "Standard Burger"
		A normal burger item, as it appears in data/items.lua
		```lua
		['burger'] = {
			label = 'Burger',
			weight = 220,
			stack = true,
			close = true,
			client = {
				status = { hunger = 200000 },
				anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
				prop = { model = 'prop_cs_burger_01', pos = { x = 0.02, y = 0.02, y = -0.02}, rot = { x = 0.0, y = 0.0, y = 0.0} },
				usetime = 2500,
			}
		}
		```
	=== "Custom Burger"
		A modified burger item, with a description and custom crafting table.
		```lua
		['burger'] = {
			label = 'Burger',
			description = 'Just what is the secret formula?'
			weight = 220,
			stack = true,
			close = true,
			client = {
				status = { hunger = 200000 },
				anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
				prop = { model = 'prop_cs_burger_01', pos = { x = 0.02, y = 0.02, y = -0.02}, rot = { x = 0.0, y = 0.0, y = 0.0} },
				usetime = 2500,
			}
			crafting = {
				['bun'] = 2,
				['ketchup'] = 1,
				['mustard'] = 1,
				['cheese'] = 1,
				['pickles'] = 1,
				['lettuce'] = 1,
				['tomato'] = 1,
				['onion'] = 1, 
			}
		}
		```
		Combined with several new functions and events you could easily create a crafting system.

!!! summary "Standard options"
	=== "Shared"
		| Argument    | Optional | Default | Explanation |
		| ----------- | -------- | ------- | ----------- |
		| label       | no       | -       | The display text for an item |
		| weight      | yes      | 0       | The weight of an item in grams |
		| stack       | yes      | true    | Does the item stack with others of the same type |
		| close       | yes      | true    | Does the item close the inventory if used |
		| description | yes      | -       | Text to display in the item tooltip |
		| consume     | yes      | 1       | Number of an item needed to use it, and removed after use |
		| client      | yes      | -       | Options accessible only to the client |
		| server      | yes      | -       | Options accessible only to the server |
	=== "Client"
		| Argument | Explanation |
		| -------- | ----------- |
		| event    | Trigger a client event after use |
		| status   | Adjust esx_status values after use |
		| anim     | Animation during progress bar |
		| prop     | Attached entity during progress bar |
		| disable  | Disable actions during progress bar |
		| usetime  | Time for progress bar to complete |
		| cancel   | Able to cancel progress bar |