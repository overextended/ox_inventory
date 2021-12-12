---
title: Item events
---
It is possible to setup a function triggered by certain item "events". These will be triggered when an item is being used, bought, or after it was used.  

!!! info
    ```lua
    Item('testburger', function(event, item, inventory, slot, data)
        if event == 'usingItem' then
            if Inventory.GetItem(inventory, item, inventory.items[slot].metadata, true) > 100 then
                return {
                    inventory.label, inventory.owner, event,
                    'so many delicious burgers'
                }
            end

        elseif event == 'usedItem' then
            print(('%s just ate a %s from slot %s'):format(inventory.label, item.label, slot))
            TriggerClientEvent('ox_inventory:notify', inventory.id, {text = item.server.test})

        elseif event == 'buying' then
            print(data.id, data.coords, json.encode(data.items[slot], {indent=true}))
        end
    end)
    ```

