if ox.esx then
    local ESX = exports['es_extended']:getSharedObject()

    -- ESX.ServerCallbacks does not exist in the Overextended fork of ESX, so throw an error
    if ESX.ServerCallbacks then
        ox.error('Ox Inventory requires a modified version of ESX, refer to the documentation.')
    end

    ESX = {
        GetUsableItems = ESX.GetUsableItems,
        GetPlayerFromId = ESX.GetPlayerFromId,
        UseItem = ESX.UseItem
    }

    ox.UseItem = ESX.UseItem
    ox.UsableItemsCallbacks = ESX.GetUsableItems
    ox.GetPlayerFromId = ESX.GetPlayerFromId

    RegisterServerEvent('ox_inventory:requestPlayerInventory', function()
        local source = source
        local player = ox.GetPlayerFromId(source)

        if player and player.inventory then
            exports.ox_inventory:setPlayerInventory(player, player.inventory)
        else
            MySQL.scalar('SELECT inventory FROM users WHERE identifier = ?', { player.identifier }, function(result)
                exports.ox_inventory:setPlayerInventory(player, result and json.decode(result))
            end)
        end
    end)
end
