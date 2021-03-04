Config = Config or {}
Config.PlayerSlot = 51          -- Slots in the player inventory
Config.EnableBlur = true        -- Blur the screen while accessing the inventory
Config.MaxWeight = 24000        -- Max weight as grams
Config.DurabilityDecreaseAmount = { ['WEAPON_PISTOL'] = 0.6, ['WEAPON_ADVANCEDRIFLE'] = 0.6, ['WEAPON_APPISTOL'] = 0.4, ['WEAPON_ASSAULTRIFLE'] = 0.8, ['WEAPON_ASSAULTRIFLE_MK2'] = 0.6, ['WEAPON_ASSAULTSMG'] = 0.6, ['WEAPON_BALL'] = 1.0, ['WEAPON_BAT'] = 1.0, ['WEAPON_BATTLEAXE'] = 5.0, ['WEAPON_BOTTLE'] = 5.0, ['WEAPON_BULLPUPRIFLE'] = 0.9, ['WEAPON_BULLPUPRIFLE_MK2'] = 0.7, ['WEAPON_CARBINERIFLE'] = 0.8, ['WEAPON_CARBINERIFLE_MK2'] = 0.7, ['WEAPON_COMBATPDW'] = 3.0, ['WEAPON_COMBATPISTOL'] = 0.5, ['WEAPON_COMPACTRIFLE'] = 0.7, ['WEAPON_CROWBAR'] = 1.0, ['WEAPON_DAGGER'] = 1.0, ['WEAPON_DOUBLEACTION'] = 0.8, ['WEAPON_FLAREGUN'] = 1.0, ['WEAPON_FLASHLIGHT'] = 1.0, ['WEAPON_GOLFCLUB'] = 1.0, ['WEAPON_GUSENBERG'] = 0.8, ['WEAPON_HAMMER'] = 1.0, ['WEAPON_HATCHET'] = 1.0, ['WEAPON_HEAVYPISTOL'] = 0.6, ['WEAPON_KNIFE'] = 1.0, ['WEAPON_KNUCKLE'] = 1.0, ['WEAPON_MACHETE'] = 1.0, ['WEAPON_MACHINEPISTOL'] = 0.7, ['WEAPON_MARKSMANPISTOL'] = 4.0, ['WEAPON_MICROSMG'] = 0.6, ['WEAPON_MINISMG'] = 0.6, ['WEAPON_MOLOTOV'] = 5.0, ['WEAPON_MUSKET'] = 1.0, ['WEAPON_NIGHTSTICK'] = 1.0, ['WEAPON_PISTOL50'] = 0.8, ['WEAPON_PISTOL_MK2'] = 0.5, ['WEAPON_PUMPSHOTGUN'] = 0.8, ['WEAPON_PUMPSHOTGUN_MK2'] = 0.7, ['WEAPON_REVOLVER'] = 0.8, ['WEAPON_REVOLVER_MK2'] = 0.7, ['WEAPON_SAWNOFFSHOTGUN'] = 0.9, ['WEAPON_SMG'] = 0.8, ['WEAPON_SMG_MK2'] = 0.7, ['WEAPON_SNSPISTOL'] = 0.7, ['WEAPON_SNSPISTOL_MK2'] = 0.6, ['WEAPON_SPECIALCARBINE'] = 0.8, ['WEAPON_SPECIALCARBINE_MK2'] = 0.7, ['WEAPON_STONE_HATCHET'] = 1.0, ['WEAPON_STUNGUN'] = 0.6, ['WEAPON_SWITCHBLADE'] = 1.0, ['WEAPON_VINTAGEPISTOL'] = 0.7, ['WEAPON_WRENCH'] = 1.0 }
Config.Accounts = {['money']=1, ['black_money']=1}

Config.ItemList = {
    ['money'] = {},
    ['black_money'] = {},
    ['keys'] = {},
    ['identification'] = {},
    ['at_flashlight_pistol'] = { component = `COMPONENT_AT_PI_FLSH`, consume = 1, useTime = 2500 },
    ['at_flashlight_rifle'] = { component = `COMPONENT_AT_AR_FLSH`, consume = 1, useTime = 2500 },

    ['burger'] = {
        thirst = 0,
        hunger = 200000,
        animDict = "mp_player_inteat@burger",
        anim = "mp_player_int_eat_burger_fp",
        model = "prop_cs_burger_01",
        coords = { x = 0.02, y = 0.022, z = -0.02 },
        rotation = { x = 0.0, y = 5.0, z = 0.0 },
        useTime = 2500,
        consume = 1,
    },

    ['water'] = {
        thirst = 200000,
        hunger = 0,
        animDict = "mp_player_intdrink",
        anim = "loop_bottle",
        model = "prop_ld_flow_bottle",
        coords = { x = 0.03, y = 0.0, z = 0.02 },
        rotation = { x = 0.0, y = -13.5, z = -1.5 },
        useTime = 2500,
        consume = 1,
    },

    ['cola'] = {
        thirst = 200000,
        hunger = 0,
        animDict = "mp_player_intdrink",
        anim = "loop_bottle",
        model = "prop_ecola_can",
        coords = { x = 0.01, y = 0.0, z = 0.06 },
        rotation = { x = 5.0, y = -1.5, z = -180.5 },
        useTime = 2500,
        consume = 1,
    },

    ['bandage'] = {
        animDict = "missheistdockssetup1clipboard@idle_a",
        anim = "idle_a",
        flags = 49,
        model = "prop_rolled_sock_02",
        coords = { x = -0.14, y = 0.02, z = -0.08 },
        rotation = { x = -50.0, y = -50.0, z = 0.0 },
        useTime = 2500,
        consume = 1,
    },

    ['identification'] = {  
        useTime = 0,
        consume = 0
    },

    ['lockpick'] = {
        disableMove = true,
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
        anim = "machinic_loop_mechandplayer",
        useTime = 2000,
        consume = 0   
    },

}


Config.Stashes = {
    { coords = vector3(474.2242, -990.7516, 26.2638), slots = 71, name = 'Police Evidence', job = 'police' },
    { coords = vector3(301.4374, -599.2748, 43.2821), slots = 71, name = 'Hospital Cloakroom', job = 'ambulance'  }
}


Config.Shops = {
    { -- 24/7
        coords = vector3(-531.14, -1221.33, 18.48),
        blip = {
            id = 52,
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Xero Gas', 
        inventory = {
            {
                name = 'burger',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(2557.458,  382.282, 108.622),
        blip = {
            id = 52,
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = '24/7', 
        inventory = {
            {
                name = 'burger',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(-3038.939, 585.954, 7.908),
        blip = {
            id = 52,
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = '24/7', 
        inventory = {
            {
                name = 'burger',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(-3241.927, 1001.462, 12.830),
        blip = {
            id = 52,
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = '24/7', 
        inventory = {
            {
                name = 'burger',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(547.431, 2671.710, 42.156),
        blip = {
            id = 52,
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = '24/7', 
        inventory = {
            {
                name = 'burger',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(1961.464, 3740.672, 32.343),
        blip = {
            id = 52,
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = '24/7', 
        inventory = {
            {
                name = 'burger',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(2678.916, 3280.671, 55.241),
        blip = {
            id = 52,
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = '24/7', 
        inventory = {
            {
                name = 'burger',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(1729.216, 6414.131, 35.037),
        blip = {
            id = 52,
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = '24/7', 
        inventory = {
            {
                name = 'burger',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(-48.519, -1757.514, 29.421),
        blip = {
            id = 52,
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Davis LTD', 
        inventory = {
            {
                name = 'burger',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(1163.373, -323.801, 69.205),
        blip = {
            id = 52,
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Mirror Park LTD', 
        inventory = {
            {
                name = 'burger',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(-707.501, -914.260, 19.215),
        blip = {
            id = 52,
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Little Seoul LTD', 
        inventory = {
            {
                name = 'burger',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(-1820.523, 792.518, 138.118),
        blip = {
            id = 52,
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Richman Glen LTD', 
        inventory = {
            {
                name = 'burger',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(1698.388, 4924.404, 42.063),
        blip = {
            id = 52,
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Grapeseed LTD', 
        inventory = {
            {
                name = 'burger',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(25.723, -1346.966, 29.497),
        blip = {
            id = 52,
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = '24/7', 
        inventory = {
            {
                name = 'burger',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(373.875, 325.896, 103.566),
        blip = {
            id = 52,
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = '24/7', 
        inventory = {
            {
                name = 'burger',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(-2544.092, 2316.184, 33.2),
        blip = {
            id = 52,
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Lago Zancudo RON', 
        inventory = {
            {
                name = 'burger',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
        },
    },
    --LIQUOR
    {
        coords = vector3(1135.808, -982.281, 46.415),
        blip = {
            id = 93,
            name = "Robs Liquor",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Robs Liquor', 
        inventory = {
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(-1222.915, -906.983,  12.326),
        blip = {
            id = 93,
            name = "Robs Liquor",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Robs Liquor', 
        inventory = {
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(-1487.553, -379.107,  40.163),
        blip = {
            id = 93,
            name = "Robs Liquor",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Robs Liquor', 
        inventory = {
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(-2968.243, 390.910, 15.043),
        blip = {
            id = 93,
            name = "Robs Liquor",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Robs Liquor', 
        inventory = {
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(1166.024, 2708.930, 38.157),
        blip = {
            id = 93,
            name = "Robs Liquor",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Robs Liquor', 
        inventory = {
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(1392.562, 3604.684, 34.980),
        blip = {
            id = 93,
            name = "Robs Liquor",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Robs Liquor', 
        inventory = {
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(-1393.409, -606.624, 30.319),
        blip = {
            id = 93,
            name = "Robs Liquor",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Robs Liquor', 
        inventory = {
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cola',
                price = 10,
                count = 200
            },
        },
    },-- YouTOOL
    {
        coords = vector3(2748.0, 3473.0, 55.67),
        blip = {
            id = 402,
            name = "YouTool",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'YouTool', 
        inventory = {
            {
                name = 'lockpick',
                price = 200,
                count = 200,
            },
            {
                name = 'WEAPON_PETROLCAN',
                price = 100,
                count = 1,
                metadata = {}
            },
        },
    },
    {
        coords = vector3(342.99, -1298.26, 32.51),
        blip = {
            id = 402,
            name = "YouTool",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'YouTool', 
        inventory = {
            {
                name = 'lockpick',
                price = 200,
                count = 200,
            },
            {
                name = 'WEAPON_PETROLCAN',
                price = 100,
                count = 1,
                metadata = {}
            },
        },
    },
    -- Police
    {
        job = 'police',
        coords = vector3(452.40, -980.04, 30.68), -- vector3(487.235, -997.108, 30.69) for gabz
        name = 'Police Armoury',
        blip = {
            id = 110,
            name = 'Police Armoury',
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        inventory = {
            {
                name = 'keys',
                price = 15,
                count = 200,
                metadata = { type = 'lspd' }
            },
            {
                name = 'identification',
                price = 15,
                count = 200,
            },
            {
                name = 'burger',
                price = 15,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'ammo-9',
                price = 250,
                count = 200
            },
            {
                name = 'ammo-50',
                price = 250,
                count = 200
            },
            {
                name = 'ammo-shotgun',
                price = 15,
                count = 200
            },
            {
                name = 'ammo-rifle',
                price = 15,
                count = 200
            },
            {
                name = 'WEAPON_STUNGUN',
                price = 150,
                count = 1,
                metadata = {
                    weaponlicense = 'POL',
                    weapontint = 5
                },
            },
            {
                name = 'WEAPON_COMBATPISTOL',
                price = 250,
                count = 1,
                metadata = {
                    weaponlicense = 'POL',
                    components = { 'flashlight' },
                    weapontint = 5
                },
            },
            {
                name = 'WEAPON_PISTOL50',
                price = 400,
                count = 1,
                metadata = {
                    weaponlicense = 'POL',
                    components = { 'flashlight' },
                    weapontint = 5
                },
            },
            {
                name = 'WEAPON_PUMPSHOTGUN',
                price = 500,
                count = 1,
                metadata = {
                    weaponlicense = 'POL',
                    components = { 'flashlight' },
                    weapontint = 5
                },
            },
            {
                name = 'WEAPON_CARBINERIFLE',
                price = 500,
                count = 1,
                metadata = {
                    weaponlicense = 'POL',
                    components = { 'flashlight' },
                    weapontint = 5
                },
            },
            {
                name = 'WEAPON_NIGHTSTICK',
                price = 50,
                count = 1,
                metadata = {
                    weaponlicense = 'POL',
                    weapontint = 5
                },
            },
            {
                name = 'WEAPON_KNIFE',
                price = 20,
                count = 1,
                metadata = {
                    weaponlicense = 'POL',
                    components = { 'flashlight' },
                    weapontint = 5
                },
            },
            {
                name = 'WEAPON_FLASHLIGHT',
                price = 15,
                count = 1,
                metadata = {
                    weaponlicense = 'POL',
                    weapontint = 5
                },
            },
        },
    },--WeaponShop
    {
        coords = vector3(-662.180, -934.961, 21.829),
        blip = {
            id = 110,
            name = "Ammunation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Ammunation', 
        inventory = {
            {
                name = 'ammo-9',
                price = 250,
                count = 10
            },
            {
                name = 'WEAPON_KNIFE',
                price = 200,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_BAT',
                price = 100,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_FLASHLIGHT',
                price = 75,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_STUNGUN',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
        },
    },
    {
        coords = vector3(810.25, -2157.60, 29.62),
        blip = {
            id = 110,
            name = "Ammunation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Ammunation', 
        inventory = {
            {
                name = 'ammo-9',
                price = 250,
                count = 10
            },
            {
                name = 'WEAPON_KNIFE',
                price = 200,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_BAT',
                price = 100,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_FLASHLIGHT',
                price = 75,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_STUNGUN',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
        },
    },
    {
        coords = vector3(1693.44, 3760.16, 34.71),
        blip = {
            id = 110,
            name = "Ammunation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Ammunation', 
        inventory = {
            {
                name = 'ammo-9',
                price = 250,
                count = 10
            },
            {
                name = 'WEAPON_KNIFE',
                price = 200,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_BAT',
                price = 100,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_FLASHLIGHT',
                price = 75,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_STUNGUN',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
        },
    },
    {
        coords = vector3(-330.24, 6083.88, 31.45),
        blip = {
            id = 110,
            name = "Ammunation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Ammunation', 
        inventory = {
            {
                name = 'ammo-9',
                price = 250,
                count = 10
            },
            {
                name = 'WEAPON_KNIFE',
                price = 200,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_BAT',
                price = 100,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_FLASHLIGHT',
                price = 75,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_STUNGUN',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
        },
    },
    {
        coords = vector3(252.63, -50.00, 69.94),
        blip = {
            id = 110,
            name = "Ammunation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Ammunation', 
        inventory = {
            {
                name = 'ammo-9',
                price = 250,
                count = 10
            },
            {
                name = 'WEAPON_KNIFE',
                price = 200,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_BAT',
                price = 100,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_FLASHLIGHT',
                price = 75,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_STUNGUN',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
        },
    },
    {
        coords = vector3(22.56, -1109.89, 29.80),
        blip = {
            id = 110,
            name = "Ammunation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Ammunation', 
        inventory = {
            {
                name = 'ammo-9',
                price = 250,
                count = 10
            },
            {
                name = 'WEAPON_KNIFE',
                price = 200,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_BAT',
                price = 100,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_FLASHLIGHT',
                price = 75,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_STUNGUN',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
        },
    },
    {
        coords = vector3(2567.69, 294.38, 108.73),
        blip = {
            id = 110,
            name = "Ammunation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Ammunation', 
        inventory = {
            {
                name = 'ammo-9',
                price = 250,
                count = 10
            },
            {
                name = 'WEAPON_KNIFE',
                price = 200,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_BAT',
                price = 100,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_FLASHLIGHT',
                price = 75,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_STUNGUN',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
        },
    },
    {
        coords = vector3(-1117.58, 2698.61, 18.55),
        blip = {
            id = 110,
            name = "Ammunation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Ammunation', 
        inventory = {
            {
                name = 'ammo-9',
                price = 250,
                count = 10
            },
            {
                name = 'WEAPON_KNIFE',
                price = 200,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_BAT',
                price = 100,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_FLASHLIGHT',
                price = 75,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_STUNGUN',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
        },
    },
    {
        coords = vector3(842.44, -1033.42, 28.19),
        blip = {
            id = 110,
            name = "Ammunation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Ammunation', 
        inventory = {
            {
                name = 'ammo-9',
                price = 250,
                count = 10
            },
            {
                name = 'WEAPON_KNIFE',
                price = 200,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_BAT',
                price = 100,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_FLASHLIGHT',
                price = 75,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_STUNGUN',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = { registered = 'setname' },
            },
        },
    },
}


Config.Ammos = {
    ['ammo-38'] = { -- .38 long colt
            `WEAPON_DOUBLEACTION`
    },

    ['ammo-44'] = { -- .44 magnum
            `WEAPON_REVOLVER`,
            `WEAPON_REVOLVER_MK2`
    },

    ['ammo-45'] = { -- 45 acp
            `WEAPON_GUSENBERG`,
            `WEAPON_HEAVYPISTOL`,
            `WEAPON_MICROSMG`,
            `WEAPON_SNSPISTOL`,
            `WEAPON_SNSPISTOL_MK2`
    },

    ['ammo-9'] = { -- 9mm variants (parabellum, makarov, etc)
            `WEAPON_APPISTOL`,
            `WEAPON_COMBATPDW`,
            `WEAPON_COMBATPISTOL`,
            `WEAPON_MACHINEPISTOL`,
            `WEAPON_MINISMG`,
            `WEAPON_PISTOL`,
            `WEAPON_PISTOL_MK2`,
            `WEAPON_SMG`,
            `WEAPON_SMG_MK2`,
            `WEAPON_VINTAGEPISTOL`
    },

    ['ammo-flare'] = {
            `WEAPON_FLAREGUN`
    },

    ['ammo-musket'] = {
            `WEAPON_MUSKET`
    },

    ['ammo-rifle'] = { -- 5.56
            `WEAPON_ADVANCEDRIFLE`,
            `WEAPON_ASSAULTSMG`,
            `WEAPON_BULLPUPRIFLE`,
            `WEAPON_BULLPUPRIFLE_MK2`,
            `WEAPON_CARBINERIFLE`,
            `WEAPON_CARBINERIFLE_MK2`,
            `WEAPON_COMBATMG`,
            `WEAPON_SPECIALCARBINE`,
            `WEAPON_SPECIALCARBINE_MK2`,
    },

    ['ammo-rifle2'] = { -- 7.62 soviet
            `WEAPON_ASSAULTRIFLE`,
            `WEAPON_ASSAULTRIFLE_MK2`,
            `WEAPON_COMBATMG_MK2`,
            `WEAPON_COMPACTRIFLE`,
            `WEAPON_MG`,
    },

    ['ammo-22'] = { -- .22 long rifle
            `WEAPON_MARKSMANPISTOL`
    },

    ['ammo-50'] = { -- .50 action express
            `WEAPON_PISTOL50`
    },

    ['ammo-sniper'] = { -- 7.62 NATO
            `WEAPON_MARKSMANRIFLE`,
            `WEAPON_MARKSMANRIFLE_MK2`,
            `WEAPON_SNIPERRIFLE`
    },

    ['ammo-heavysniper'] = { -- .50 BMG
            `WEAPON_HEAVYSNIPER`,
            `WEAPON_HEAVYSNIPER_MK2`
    },

    ['ammo-shotgun'] = { -- 12 gauge
            `WEAPON_ASSAULTSHOTGUN`,
            `WEAPON_BULLPUPSHOTGUN`,
            `WEAPON_DBSHOTGUN`,
            `WEAPON_HEAVYSHOTGUN`,
            `WEAPON_PUMPSHOTGUN`,
            `WEAPON_PUMPSHOTGUN_MK2`,
            `WEAPON_SAWNOFFSHOTGUN`,
            `WEAPON_SWEEPERSHOTGUN`
    },
}
