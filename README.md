# hsn-inventory
Advanced Inventory System for Fivem
### [For installation instructions, read the wiki](https://github.com/thelindat/hsn-inventory/wiki)


# Info
hsn is no longer supporting the inventory and has put it on the back burner. I'm attempting to fix any major issues with it. This should work 100% and have no issues. Please report anything that comes up and I'll attempt to fix it. 

Thanks for the inventory hsn.

<hr>

-- Stash Trigger

TriggerServerEvent("hsn-inventory:server:openStash", {name = 'Motel',slots = 15, type = 'stash'})

Showcase --> https://streamable.com/kpvdj3

Setup -- > https://streamable.com/esytcq

You can contact with me for inventory bugs or dupes...
https://discord.gg/6FQhKDXBJ6

Add this code ghmattimysql server.lua

exports("ready", function (callback)
  Citizen.CreateThread(function ()
      -- add some more error handling
      while GetResourceState('ghmattimysql') ~= 'started' do
          Citizen.Wait(0)
      end
      callback()
  end)
end)

es_extended server / main.lua
https://imgur.com/a/L6zmAIf

##Use (/addItem playerId item count) command for give item.

Server Side Remove Item

TriggerEvent("hsn-inventory:server:removeItem",playerId,itemname,count)

Server Side Add Item

TriggerEvent("hsn-inventory:server:addItem",playerId,itemname,count)

Client Side Add Item

TriggerServerEvent("hsn-inventory:client:addItem",itemname,count)

Client Side Remove Item

TriggerServerEvent("hsn-inventory:client:removeItem",itemname,count)


