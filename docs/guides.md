---
title: Guides
---

# Guides

!!! info "Example resource"
    If you have trouble understanding how some of the inventory API works, we have created
    an examples [resource](https://github.com/overextended/ox_inventory_examples/blob/main) you can reference to get an idea of how some of it may work.

## Building the inventory UI

!!! info "Requirements to build:"

    * Node.js
    * Yarn

!!! info "Installing Node.js:"

    * Download the LTS version of Node.js from [here](https://www.nodejs.org).
    * Go through the install and make sure you install all of the features.
    * Run node --version in cmd and make sure that it gives you the version number. If it doesn't then you didn't install it correctly.

!!! info "Installing Yarn:"

    * Now that you've installed Node.js you can install Yarn by running `npm install --global yarn` in cmd.

!!! info "Building the inventory UI:"

    * cd into the web directory of ox_inventory
    * In your cmd type `yarn` and in will start downloading the node modules.
    * After it's done downloading node modules you can run `yarn build` to build the UI.

!!! tip "Hot reloads"
    When working in the browser you can run `yarn start`, which supports hot reloads meaning that
    you will see your changes after saving your file.

    If you want to work in game you can run `yarn start:game` which writes changes to disk, so
    the only thing you have to do is restart the resource for it take affect. 

## Creating custom property stashes

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