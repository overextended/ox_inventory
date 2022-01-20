function server.isPolice(inv)
    return shared.police[inv.player.job.name] ~= nil
end

function server.setPlayerData(player)
    return {
		name = player.name,
		job = player.job,
		sex = player.sex,
		dateofbirth = player.dateofbirth,
	}
end

server.accounts = {
    money = 0,
}

if shared.framework == 'esx' then
    local ESX = exports['es_extended']:getSharedObject()

    -- ESX.ServerCallbacks does not exist in the Overextended fork of ESX, so throw an error
    if ESX.ServerCallbacks then
        shared.error('Ox Inventory requires a modified version of ESX, refer to the documentation.')
    end

    ESX = {
        GetUsableItems = ESX.GetUsableItems,
        GetPlayerFromId = ESX.GetPlayerFromId,
        UseItem = ESX.UseItem
    }

    server.UseItem = ESX.UseItem
    server.UsableItemsCallbacks = ESX.GetUsableItems
    server.GetPlayerFromId = ESX.GetPlayerFromId

    server.accounts.black_money = 0

    function server.setPlayerData(player)
        return {
            name = player.name,
            job = player.job,
            sex = player.sex or player.variables.sex,
            dateofbirth = player.dateofbirth or player.variables.dateofbirth,
        }
    end

    RegisterServerEvent('ox_inventory:requestPlayerInventory', function()
        local source = source
        local player = server.GetPlayerFromId(source)

        if player and player.inventory then
            exports.ox_inventory:setPlayerInventory(player, player.inventory)
        else
            MySQL.scalar('SELECT inventory FROM users WHERE identifier = ?', { player.identifier }, function(result)
                exports.ox_inventory:setPlayerInventory(player, result and json.decode(result))
            end)
        end
    end)
end
