Citizen.CreateThread(function()
    local shopKeeps = {
        `mp_m_shopkeep_01`
    }

    exports['labrp_Eye']:AddTargetModel(shopKeeps, {
        options = {
            {
                event = 'linden_inventory:openShopInventory',
                icon = 'fas fa-shopping-basket',
                label = '24/7 Store'
            },
        },
        job = {'all'},
        distance = 3.0
    })
end)

AddEventHandler('linden_inventory:openShopInventory', function()
    for i = 1, #Config.Shops, 1 do
        for k,v in pairs(Config.Shops[i].type) do
            if Config.Shops[i].type['name'] == 'Shop' then
                if #(GetEntityCoords(PlayerPedId()) - Config.Shops[i].coords) <= 1.8 then
                    OpenShop(i)
                    break
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    local AmmunationKeeps = {
        `csb_cletus`
    }

    exports['labrp_Eye']:AddTargetModel(AmmunationKeeps, {
        options = {
            {
                event = 'linden_inventory:openAmmuInventory',
                icon = 'fas fa-bomb',
                label = 'Ammunation'
            },
        },
        job = {'all'},
        distance = 3.0
    })
end)

AddEventHandler('linden_inventory:openAmmuInventory', function()
    for i = 1, #Config.Shops, 1 do
        for k,v in pairs(Config.Shops[i].type) do
            if Config.Shops[i].type['name'] == 'Ammunation' then
                if #(GetEntityCoords(PlayerPedId()) - Config.Shops[i].coords) <= 1.8 then
                    OpenShop(i)
                    break
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    local YouToolKeeps = {
        `s_m_m_autoshop_01`
    }

    exports['labrp_Eye']:AddTargetModel(YouToolKeeps, {
        options = {
            {
                event = 'linden_inventory:openYTInventory',
                icon = 'fas fa-hammer',
                label = 'YouTool'
            },
        },
        job = {'all'},
        distance = 3.0
    })
end)

AddEventHandler('linden_inventory:openYTInventory', function()
    for i = 1, #Config.Shops, 1 do
        for k,v in pairs(Config.Shops[i].type) do
            if Config.Shops[i].type['name'] == 'YouTool' then
                if #(GetEntityCoords(PlayerPedId()) - Config.Shops[i].coords) <= 1.8 then
                    OpenShop(i)
                    break
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    local LiquorKeeps = {
        `s_m_m_cntrybar_01`
    }

    exports['labrp_Eye']:AddTargetModel(LiquorKeeps, {
        options = {
            {
                event = 'linden_inventory:openLiquorInventory',
                icon = 'fas fa-glass-martini-alt',
                label = 'Liquor Store'
            },
        },
        job = {'all'},
        distance = 3.0
    })
end)

AddEventHandler('linden_inventory:openLiquorInventory', function()
    for i = 1, #Config.Shops, 1 do
        for k,v in pairs(Config.Shops[i].type) do
            if Config.Shops[i].type['name'] == 'Liquor' then
                if #(GetEntityCoords(PlayerPedId()) - Config.Shops[i].coords) <= 1.8 then
                    OpenShop(i)
                    break
                end
            end
        end
    end
end)


Citizen.CreateThread(function()
        
    
    
    exports['labrp_Eye']:AddBoxZone("PoliceArmoury", vector3(481.5, -994.8, 30.6), 3.0, 0.8, {
    name="PoliceArmoury",
    heading=91,
    debugPoly=false,
    minZ=29.6,
    maxZ=31.6
    }, {
        options = {
            {
                event = "linden_inventory:openPoliceArmouryInventory",
                icon = "far fa-clipboard",
                label = "Police Armoury",
            },
        },
        job = {"police"},
        distance = 1.5
    })


    
end)

AddEventHandler('linden_inventory:openPoliceArmouryInventory', function()
    for i = 1, #Config.Shops, 1 do
        for k,v in pairs(Config.Shops[i].type) do
            if Config.Shops[i].type['name'] == 'Police Armoury' then
                if #(GetEntityCoords(PlayerPedId()) - Config.Shops[i].coords) <= 1.8 then
                    OpenShop(i)
                    break
                end
            end
        end
    end
end)