---
title: Utils.PlayAnim
---

```lua
Utils.PlayAnim(wait, ...)
```

Plays a animation on the player ped.

| Argument | Data Type | Optional | Explanation                                                       |
| -------- | --------- | -------- | ----------------------------------------------------------------- |
| wait     | integer   | no       | Wait timer before clearing and cancelling the ped animation       |
| ...      | any       | no       | Animation options arguments, first argument must be the anim dict |

**Example**

```lua
Utils.PlayAnim(1000, 'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
```
