---
title: Utils.PlayAnimAdvanced
---

```lua
Utils.PlayAnimAdvanced(wait, clear, ...)
```

Plays a advanced animation on the player ped.

| Argument | Data Type | Optional | Explanation                                                       |
| -------- | --------- | -------- | ----------------------------------------------------------------- |
| wait     | integer   | no       | Wait timer before clearing and cancelling the ped animation       |
| clear    | boolean   | yes      | If set to true will clear the animation on wait end               |
| ...      | any       | no       | Animation options arguments, first argument must be the anim dict |

**Example**

```lua
Utils.PlayAnimAdvanced(800, false, 'reaction@intimidation@cop@unarmed' or 'reaction@intimidation@1h', 'intro', GetEntityCoords(ESX.PlayerData.ped, true), 0, 0, GetEntityHeading(ESX.PlayerData.ped), 8.0, 3.0, -1, 50, 1, 0, 0)
```
