---
title: Progress.Start
---

```lua
Progress.Start(options, completed)
```

```lua
exports.ox_inventory:Progress(options, completed)
```

This function will run the built in progress bar.

| Argument  | Data Type | Optional | Explanation                                             |
| --------- | --------- | -------- | ------------------------------------------------------- |
| options   | table     | no       | Option parameters for progress bar behaviour            |
| completed | function  | no       | Callback function that checks if progress was completed |

Arguments that the options table can take:

| Argument     | Data Type | Optional | Explanation                                                                      |
| ------------ | --------- | -------- | -------------------------------------------------------------------------------- |
| duration     | integer   | no       | Duration of the progress bar                                                     |
| label        | string    | no       | Text inside the progress bar                                                     |
| useWhileDead | boolean   | no       | If set to true the progress bar can run while ped is dead                        |
| canCancel    | boolean   | yes      | If set to true the player can cancell the progress bar                           |
| Disable      | table     | yes      | Setting values true in the table will disable specified player actions           |
| anim         | table     | yes      | Animation or scenario that will play on the player ped while progress is running |
| prop         | table     | yes      | Prop that will be attached to the player while the progress is running           |
| propTwo      | table     | yes      | Second prop that can be attached to the ped                                      |

The Disable table takes `move` `car` `combat` `mouse` as keys, which are all boolean type.

The anim table takes `dict` `clip` `flag` as keys where dict and clip are strings and flag is a integer. If neither of those keys are provided you can use add a `scenario` key which is a string and will play a scenario task on the ped.

prop and propTwo take the exact same keys. `model` `bone` `pos` `rot`, bone, pos and rot are optional while model isn't. Model is a string while bone is a integer and both pos and rot take a xyz integer table.

**Example**

```lua
Progress.Start({
    duration = 5000,
    label = 'Using Water',
    useWhileDead = false,
    canCancel = false,
    Disable = {
        move = false,
        car = true,
        combat = true,
        mouse = false
    },
    anim = {dict = 'mp_player_intdrink', clip = 'loop_bottle'},
    prop = { model = 'prop_ld_flow_bottle', pos = { x = 0.03, y = 0.03, y = 0.02}, rot = { x = 0.0, y = 0.0, y = -1.5}},
}, function(cancel)
    if cancel then
        used = false
    else
        used = true
    end
end)
```

You can use `Progress.Active` to see if the progress is still running or not.
