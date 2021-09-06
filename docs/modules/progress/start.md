---
title: Progress.Start
---
Starts the progress bar and prevents some actions such as opening the inventory, reloading, etc.
!!! info
	```lua
	Progress.Start(options, completed)
	```
	```lua
    exports.ox_inventory:Progress(options, completed)
	```

	| Argument  | Type     | Optional | Explanation |
	| --------- | ------   | -------- | ----------- |
	| options   | table    | no       | Change the progress bar behaviour |
    | completed | function | no       | Callback function after completing the progress timer |

!!! summary "Options"
	| Argument     | Type    | Optional | Explanation |
	| ------------ | ------- | -------- | ----------- |
	| duration     | integer | no       | Time it takes for the bar to callback in milliseconds |
    | label        | string  | no       | Text to display on progress bar |
    | useWhileDead | boolean | yes      | Able to perform an action while dead |
    | canCancel    | boolean | yes      | Can cancel the progress bar |
    | anim         | table   | yes      | Perform an animation or scenario |
    | prop         | table   | yes      | Attach a prop to the player |
    | propTwo      | table   | yes      | Attach a prop to the player |
    | disable      | table   | yes      | Disable control actions while active |


!!! example
    ```lua
    Progress.Start({
        duration = 2000,
        label = 'Drinking water',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = false,
            car = true,
            combat = true,
            mouse = false
        },
        anim = {
            dict = 'mp_player_intdrink',
            clip = 'loop_bottle',
            flags = 49,
        },
        prop = {
            model = 'prop_ld_flow_bottle',
            pos = { x = 0.03, y = 0.03, y = 0.02},
            rot = { x = 0.0, y = 0.0, y = -1.5},
            bone = 58866
        },
    }, function(cancel)
        if not cancel then
            print("You drank some water - that'll quench ya!")
        end
    end)
    ```