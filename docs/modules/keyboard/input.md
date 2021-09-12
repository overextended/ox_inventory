---
title: Keyboard.Input
---

Window component that retuns values of input fields

!!! info
    ```lua
    Keyboard.Input(header, rows)
    ```
    ```lua
    exports.ox_inventory:Keyboard(header, rows)
    ```

    | Argument  | Type     | Optional | Explanation |
	| --------- | ------   | -------- | ----------- |
	| header   | string    | no       | Header title of the window |
    | rows | table | no       | Table of strings, each adding a new row |

!!! info 
    The function is **sync**, returned value is a `table` if at least one input field had a value in it upon submitting, otherwise returned value is `nil`

!!! example
    ```lua
    local data = Keyboard.Input('Evidence Locker', {'Locker number'})

    if data then
        local lockerNum = data[1]
    else
        print('No value was entered into the field!')
    end
    ```