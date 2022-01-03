---
title: Creating custom stashes
---

We can setup custom stashes from outside the resource utilising the exported RegisterStash function. Firstly, we need to define the stashes properties.

!!! info

    | Argument   | Type     | Optional | Explanation |
	| ---------- | -------- | -------- | ----------- |
	| id         | string   | no       | A unique name to identify the stash in the database |
	| label      | string   | no       | A display name when viewing the inventory |
	| slots      | integer  | no       | Number of slots |
	| weight     | integer  | no       | Maximum weight |
	| owner      | string / boolean | yes      | See below |
	| job        | table    | yes      | Key-value pairs of job name and minimum grade to access |
    | coords     | vector   | yes      | A vector (or table) containing x, y, z coordinates |

    The owner field will set permissions for stash access, with stashes registering to specific identifiers.
        - true: Each player has their own unique stash, but can request to open the stash of another player
        - false: Only a single stash exists and is shared between all players
        - string: The stash explicitly belongs to the given owner, usually a player identifier

    ~~You can set the stash coordinates to prevent the stash from being opened if the player isn't close enough.~~ (will be added in the next update)


!!! example
    
    === "1"

        Below the value is hardset, but it could be loaded from the database (especially if there are unknown fields, i.e. owner)

        ```lua
        -- Server
        local stash = {
            id = '42wallabyway',
            label = '42 Wallaby Way',
            slots = 50,
            weight = 100000,
            owner = 'char1:license'
        }

        AddEventHandler('onServerResourceStart', function(resourceName)
            if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
                Wait(0)
                exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner)
            end
        end)

        -- Client
        exports.ox_inventory:openInventory('stash', {id='42wallabyway', owner=property.owner})
        ```
    
    === "2"
    
        The following sample is based on esx_property's db data.

        ```lua
        -- Server
        local properties

        MySQL.query('SELECT * FROM `properties`', {}, function(result)
            properties = result
        end

        RegisterNetEvent('ox:loadStashes', function(id)
            local stash = properties[id]
            if stash then
                -- id: 1, name: WhispymoundDrive, label: 2677 Whispymound Drive, coords: {"x":118.748,"y":566.573,"z":175.697}
                ox_inventory:RegisterStash(stash.name, stash.label, 50, 100000, true, false, json.encode(stash.room_menu))
            end
        end)

        -- Client
        if ox_inventory:openInventory('stash', property.id) == false then
            TriggerServerEvent('ox:loadStashes')
            ox_inventory:openInventory('stash', property.id)
        end
        ```
        For our actual implementation of esx_property support, you can refer to these files
            - [client](https://github.com/overextended/esx-legacy/blob/main/%5Besx_addons%5D/esx_property/client/main.lua#L588-L619)
            - [server](https://github.com/overextended/esx-legacy/blob/main/[esx_addons]/esx_property/server/main.lua#L62-L151)
