---
title: Creating custom property stashes
---

First we must define our stash and it's properties.

!!! example
    ```lua
    local stash = {
        -- Personal stash
        id = 'example_stash_3',
        label = 'Your Stash',
        slots = 50,
        weight = 100000,
        owner = 'bobsmith',
    }
    ```
`owner` should be set to the identifier of the stash owner, setting it to true
would make the stash personal meaning that everyone would see their own items they put in into the stash.
While setting owner to false will make the stash public.

After creating a table for our stash it needs to be registered in the `server` script of your resource.

!!! example
    ```lua
    local GetCurrentResourceName = GetCurrentResourceName()
    AddEventHandler('onServerResourceStart', function(resourceName)
        if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName then
            Wait(0)
            exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner, stash.jobs)
        end
    end)
    ```
We have the `onServerResourceStart` event handler to make sure we register the stash when ox_inventory starts or restarts to avoid
no such export issues.

Now that we have the stash registered we can open it with the `openInventory` export:
!!! example
    ```lua
    exports.ox_inventory:openInventory('stash', 'example_stash_3')
    ```
First param being the inventory type and the second being our unique stash id we have set.

Ideally you would have a distance or zone check paired with a key check to trigger the export to open the stash.