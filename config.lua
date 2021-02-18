Config = Config or {}
Config.PlayerSlot = 51
Config.DurabilityDecraseAmount = {
        ['WEAPON_PISTOL'] = 0.6,
    ['WEAPON_ADVANCEDRIFLE'] = 0.6,
    ['WEAPON_APPISTOL'] = 0.4,
    ['WEAPON_ASSAULTRIFLE'] = 0.8,
    ['WEAPON_ASSAULTRIFLE_MK2'] = 0.6,
    ['WEAPON_ASSAULTSMG'] = 0.6,
    ['WEAPON_BALL'] = 1.0,
    ['WEAPON_BAT'] = 1.0,
    ['WEAPON_BATTLEAXE'] = 5.0,
    ['WEAPON_BOTTLE'] = 5.0,
    ['WEAPON_BULLPUPRIFLE'] = 0.9,
    ['WEAPON_BULLPUPRIFLE_MK2'] = 0.7,
    ['WEAPON_CARBINERIFLE'] = 0.8,
    ['WEAPON_CARBINERIFLE_MK2'] = 0.7,
    ['WEAPON_COMBATPDW'] = 3.0,
    ['WEAPON_COMBATPISTOL'] = 0.5,
    ['WEAPON_COMPACTRIFLE'] = 0.7,
    ['WEAPON_CROWBAR'] = 1.0,
    ['WEAPON_DAGGER'] = 1.0,
    ['WEAPON_DOUBLEACTION'] = 0.8,
    ['WEAPON_FLAREGUN'] = 1.0,
    ['WEAPON_FLASHLIGHT'] = 1.0,
    ['WEAPON_GOLFCLUB'] = 1.0,
    ['WEAPON_GUSENBERG'] = 0.8,
    ['WEAPON_HAMMER'] = 1.0,
    ['WEAPON_HATCHET'] = 1.0,
    ['WEAPON_HEAVYPISTOL'] = 0.6,
    ['WEAPON_KNIFE'] = 1.0,
    ['WEAPON_KNUCKLE'] = 1.0,
    ['WEAPON_MACHETE'] = 1.0,
    ['WEAPON_MACHINEPISTOL'] = 0.7,
    ['WEAPON_MARKSMANPISTOL'] = 4.0,
    ['WEAPON_MICROSMG'] = 0.6,
    ['WEAPON_MINISMG'] = 0.6,
    ['WEAPON_MOLOTOV'] = 5.0,
    ['WEAPON_MUSKET'] = 1.0,
    ['WEAPON_NIGHTSTICK'] = 1.0,
    ['WEAPON_PISTOL50'] = 0.8,
    ['WEAPON_PISTOL_MK2'] = 0.5,
    ['WEAPON_PUMPSHOTGUN'] = 0.8,
    ['WEAPON_PUMPSHOTGUN_MK2'] = 0.7,
    ['WEAPON_REVOLVER'] = 0.8,
    ['WEAPON_REVOLVER_MK2'] = 0.7,
    ['WEAPON_SAWNOFFSHOTGUN'] = 0.9,
    ['WEAPON_SMG'] = 0.8,
    ['WEAPON_SMK_MK2'] = 0.7,
    ['WEAPON_SNSPISTOL'] = 0.7,
    ['WEAPON_SNSPISTOL_MK2'] = 0.6,
    ['WEAPON_SPECIALCARBINE'] = 0.8,
    ['WEAPON_SPECIALCARBINE_MK2'] = 0.7,
    ['WEAPON_STONE_HATCHET'] = 1.0,
    ['WEAPON_STUNGUN'] = 0.6,
    ['WEAPON_SWITCHBLADE'] = 1.0,
    ['WEAPON_VINTAGEPISTOL'] = 0.7,
    ['WEAPON_WRENCH'] = 1.0,
}

Config.CloseUiItems = {
	"WEAPON_KNUCKLE",
	"WEAPON_FLASHBANG",
	"WEAPON_DBSHOTGUN",
	"WEAPON_MACHINEPISTOL", 
	"WEAPON_GUSENBERG", 
	"WEAPON_ASSUALTRIFLE",
	"WEAPON_MINISMG", 
	"WEAPON_MICROSMG", 
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_VINTAGEPISTOL", 
	"WEAPON_COMBATPDW", 
	"WEAPON_COMPACTRIFLE", 
	"WEAPON_BULLPUPSHOTGUN", 
	"WEAPON_HEAVYPISTOL", 
	"WEAPON_PISTOL50", 
	"WEAPON_SAWNOFFSHOTGUN", 
	"WEAPON_CARBINERIFLE_MK2",
	"WEAPON_SG_PUMPSHOTGUN"
}

Config.Shops = {
    { -- 24/7
        coords = vector3(-531.14, -1221.33, 17.48),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(2557.458,  382.282, 107.622),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop2', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(-3038.939, 585.954, 6.908),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop3', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(-3241.927, 1001.462, 11.830),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop4', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(547.431, 2671.710, 41.156),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop5', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(1961.464, 3740.672, 31.343),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop6', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(2678.916, 3280.671, 54.241),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop7', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(1729.216, 6414.131, 34.037),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop8', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(-48.519, -1757.514, 28.421),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop9', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(1163.373, -323.801, 68.205),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop10', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(-707.501, -914.260, 18.215),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop11', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(-1820.523, 792.518, 137.118),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop12', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(1698.388, 4924.404, 41.063),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop13', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(25.723, -1346.966, 28.497),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop14', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(373.875, 325.896, 102.566),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop15', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(-2540.88, 2314.22, 32.42),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop16', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    {
        coords = vector3(161.27, 6640.28, 30.72),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop17', 
        inventory = {
            {
                name = 'sandwich',
                price = 10,
                count = 200
            },
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'donut',
                price = 10,
                count = 200
            },
            {
                name = 'redgull',
                price = 100,
                count = 200
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
        },
    },
    --LIQUOR
    {
        coords = vector3(1135.808, -982.281, 45.415),
        blip = {
            id = 93,
            name = "Robs Liquor",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop18', 
        inventory = {
            {
                name = 'water',
                price = 10,
                count = 200
            },
            {
                name = 'coffee',
                price = 20,
                count = 200,
            },
            {
                name = 'cocacola',
                price = 10,
                count = 200
            },
            {
                name = 'bandage',
                price = 10,
                count = 200,
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'plasticpouch',
                price = 25,
                count = 200,
            },
            {
                name = 'papers',
                price = 10,
                count = 200
            },
        },
        {
            coords = vector3(-1222.915, -906.983,  11.326),
            blip = {
                id = 93,
                name = "Robs Liquor",
                color = 5,
                scale = 0.6,
            },
            text = 'E - Open Shop',
            name = 'Shop19', 
            inventory = {
                {
                    name = 'water',
                    price = 10,
                    count = 200
                },
                {
                    name = 'coffee',
                    price = 20,
                    count = 200,
                },
                {
                    name = 'cocacola',
                    price = 10,
                    count = 200
                },
                {
                    name = 'bandage',
                    price = 10,
                    count = 200,
                },
                {
                    name = 'notepad',
                    price = 15,
                    count = 200
                },
                {
                    name = 'plasticpouch',
                    price = 25,
                    count = 200,
                },
                {
                    name = 'papers',
                    price = 10,
                    count = 200
                },
            },
        },
        {
            coords = vector3(-1487.553, -379.107,  39.163),
            blip = {
                id = 93,
                name = "Robs Liquor",
                color = 5,
                scale = 0.6,
            },
            text = 'E - Open Shop',
            name = 'Shop20', 
            inventory = {
                {
                    name = 'water',
                    price = 10,
                    count = 200
                },
                {
                    name = 'coffee',
                    price = 20,
                    count = 200,
                },
                {
                    name = 'cocacola',
                    price = 10,
                    count = 200
                },
                {
                    name = 'bandage',
                    price = 10,
                    count = 200,
                },
                {
                    name = 'notepad',
                    price = 15,
                    count = 200
                },
                {
                    name = 'plasticpouch',
                    price = 25,
                    count = 200,
                },
                {
                    name = 'papers',
                    price = 10,
                    count = 200
                },
            },
        },
        {
            coords = vector3(-2968.243, 390.910, 14.043),
            blip = {
                id = 93,
                name = "Robs Liquor",
                color = 5,
                scale = 0.6,
            },
            text = 'E - Open Shop',
            name = 'Shop21', 
            inventory = {
                {
                    name = 'water',
                    price = 10,
                    count = 200
                },
                {
                    name = 'coffee',
                    price = 20,
                    count = 200,
                },
                {
                    name = 'cocacola',
                    price = 10,
                    count = 200
                },
                {
                    name = 'bandage',
                    price = 10,
                    count = 200,
                },
                {
                    name = 'notepad',
                    price = 15,
                    count = 200
                },
                {
                    name = 'plasticpouch',
                    price = 25,
                    count = 200,
                },
                {
                    name = 'papers',
                    price = 10,
                    count = 200
                },
            },
        },
        {
            coords = vector3(1166.024, 2708.930, 37.157),
            blip = {
                id = 93,
                name = "Robs Liquor",
                color = 5,
                scale = 0.6,
            },
            text = 'E - Open Shop',
            name = 'Shop22', 
            inventory = {
                {
                    name = 'water',
                    price = 10,
                    count = 200
                },
                {
                    name = 'coffee',
                    price = 20,
                    count = 200,
                },
                {
                    name = 'cocacola',
                    price = 10,
                    count = 200
                },
                {
                    name = 'bandage',
                    price = 10,
                    count = 200,
                },
                {
                    name = 'notepad',
                    price = 15,
                    count = 200
                },
                {
                    name = 'plasticpouch',
                    price = 25,
                    count = 200,
                },
                {
                    name = 'papers',
                    price = 10,
                    count = 200
                },
            },
        },
        {
            coords = vector3(1392.562, 3604.684, 33.980),
            blip = {
                id = 93,
                name = "Robs Liquor",
                color = 5,
                scale = 0.6,
            },
            text = 'E - Open Shop',
            name = 'Shop23', 
            inventory = {
                {
                    name = 'water',
                    price = 10,
                    count = 200
                },
                {
                    name = 'coffee',
                    price = 20,
                    count = 200,
                },
                {
                    name = 'cocacola',
                    price = 10,
                    count = 200
                },
                {
                    name = 'bandage',
                    price = 10,
                    count = 200,
                },
                {
                    name = 'notepad',
                    price = 15,
                    count = 200
                },
                {
                    name = 'plasticpouch',
                    price = 25,
                    count = 200,
                },
                {
                    name = 'papers',
                    price = 10,
                    count = 200
                },
            },
        },
        {
            coords = vector3(-1393.409, -606.624, 29.319),
            blip = {
                id = 93,
                name = "Robs Liquor",
                color = 5,
                scale = 0.6,
            },
            text = 'E - Open Shop',
            name = 'Shop24', 
            inventory = {
                {
                    name = 'water',
                    price = 10,
                    count = 200
                },
                {
                    name = 'coffee',
                    price = 20,
                    count = 200,
                },
                {
                    name = 'cocacola',
                    price = 10,
                    count = 200
                },
                {
                    name = 'bandage',
                    price = 10,
                    count = 200,
                },
                {
                    name = 'notepad',
                    price = 15,
                    count = 200
                },
                {
                    name = 'plasticpouch',
                    price = 25,
                    count = 200,
                },
                {
                    name = 'papers',
                    price = 10,
                    count = 200
                },
            },
        },
        {
            coords = vector3(988.8, -96.72, 73.851),
            blip = {
                id = 93,
                name = "Robs Liquor",
                color = 5,
                scale = 0.6,
            },
            text = 'E - Open Shop',
            name = 'Shop25', 
            inventory = {
                {
                    name = 'water',
                    price = 10,
                    count = 200
                },
                {
                    name = 'coffee',
                    price = 20,
                    count = 200,
                },
                {
                    name = 'cocacola',
                    price = 10,
                    count = 200
                },
                {
                    name = 'bandage',
                    price = 10,
                    count = 200,
                },
                {
                    name = 'notepad',
                    price = 15,
                    count = 200
                },
                {
                    name = 'plasticpouch',
                    price = 25,
                    count = 200,
                },
                {
                    name = 'papers',
                    price = 10,
                    count = 200
                },
            },
        },
    },-- YouTOOL
    {
        coords = vector3(2748.0, 3473.0, 54.67),
        blip = {
            id = 402,
            name = "YouTool",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop26', 
        inventory = {
            {
                name = 'acetone',
                price = 100,
                count = 200
            },
            {
                name = 'blowtorch',
                price = 50,
                count = 200,
            },
            {
                name = 'lockpick',
                price = 200,
                count = 200
            },
            {
                name = 'bulletproof',
                price = 500,
                count = 200,
            },
            {
                name = 'notepad',
                price = 15,
                count = 200
            },
            {
                name = 'phone',
                price = 150,
                count = 200,
            },
            {
                name = 'radio',
                price = 420,
                count = 200,
            },
            {
                name = 'repairkit',
                price = 250,
                count = 200,
            },
            {
                name = 'handcuffs',
                price = 100,
                count = 200,
            },
            {
                name = 'fishingrod',
                price = 250,
                count = 200,
            },
            {
                name = 'fishbait',
                price = 20,
                count = 200,
            },
            {
                name = 'plastic',
                price = 150,
                count = 200,
            },
            {
                name = 'gloves',
                price = 100,
                count = 200,
            },
            {
                name = 'wateringcan',
                price = 100,
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
        coords = vector3(342.99, -1298.26, 31.51),
        blip = {
            id = 402,
            name = "YouTool",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop27', 
        inventory = {
            {
                name = 'acetone',
                price = 100,
                count = 200
            },
            {
                name = 'blowtorch',
                price = 50,
                count = 200,
            },
            {
                name = 'lockpick',
                price = 200,
                count = 200,
            },
            {
                name = 'bulletproof',
                price = 500,
                count = 200,
            },
            {
                name = 'notepad',
                price = 15,
                count = 200,
            },
            {
                name = 'phone',
                price = 150,
                count = 200,
            },
            {
                name = 'radio',
                price = 420,
                count = 200,
            },
            {
                name = 'repairkit',
                price = 250,
                count = 200,
            },
            {
                name = 'handcuffs',
                price = 100,
                count = 200,
            },
            {
                name = 'fishingrod',
                price = 250,
                count = 200,
            },
            {
                name = 'fishbait',
                price = 20,
                count = 200,
            },
            {
                name = 'plastic',
                price = 150,
                count = 200,
            },
            {
                name = 'gloves',
                price = 100,
                count = 200,
            },
            {
                name = 'wateringcan',
                price = 100,
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
    --Prison Shop
    {
        coords = vector3(1775.936, 2587.57, 44.713),
        blip = {
            id = 52,
            name = "Prison Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop28', 
        inventory = {
            {
                name = 'bread',
                price = 15,
                count = 200,
            },
            {
                name = 'water',
                price = 10,
                count = 200,
            },
            {
                name = 'cigarette',
                price = 15,
                count = 5,
            },
            {
                name = 'lighter',
                price = 25,
                count = 1,
            },
        },
    },
    -- Police
    {
        coords = vector3(487.235, -997.108, 30.69),
        blip = {
            id = 110,
            name = "One Stop Police Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop29', 
        inventory = {
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
                name = 'handcuffs',
                price = 15,
                count = 200
            },
            {
                name = 'coffee',
                price = 10,
                count = 200
            },
            {
                name = 'medkit',
                price = 15,
                count = 200
            },
            {
                name = 'radio',
                price = 15,
                count = 200
            },
            {
                name = 'bulletproofpd',
                price = 15,
                count = 200
            },
            {
                name = 'ammo_pistol',
                price = 250,
                count = 200
            },
            {
                name = 'ammo_shotgun',
                price = 15,
                count = 200
            },
            {
                name = 'ammo_rifle',
                price = 15,
                count = 200
            },
            {
                name = 'WEAPON_STUNGUN',
                price = 150,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_COMBATPISTOL',
                price = 250,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_PISTOL50',
                price = 400,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_PUMPSHOTGUN',
                price = 500,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_CARBINERIFLE',
                price = 500,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_NIGHTSTICK',
                price = 50,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_KNIFE',
                price = 20,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_FLASHLIGHT',
                price = 15,
                count = 1,
                metadata = {}
            },
        },
    },--WeaponShop
    {
        coords = vector3(-662.180, -934.961, 20.829),
        blip = {
            id = 110,
            name = "Ammu Nationnation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop30', 
        inventory = {
            {
                name = 'ammo_pistol',
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
                price = 400,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = {}
            },
        },
    },
    {
        coords = vector3(810.25, -2157.60, 28.62),
        blip = {
            id = 110,
            name = "Ammu Nation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop31', 
        inventory = {
            {
                name = 'ammo_pistol',
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
                price = 400,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = {}
            },
        },
    },
    {
        coords = vector3(1693.44, 3760.16, 33.71),
        blip = {
            id = 110,
            name = "Ammu Nation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop32', 
        inventory = {
            {
                name = 'ammo_pistol',
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
                price = 400,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = {}
            },
        },
    },
    {
        coords = vector3(-330.24, 6083.88, 30.45),
        blip = {
            id = 110,
            name = "Ammu Nation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop33', 
        inventory = {
            {
                name = 'ammo_pistol',
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
                price = 400,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = {}
            },
        },
    },
    {
        coords = vector3(252.63, -50.00, 68.94),
        blip = {
            id = 110,
            name = "Ammu Nation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop34', 
        inventory = {
            {
                name = 'ammo_pistol',
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
                price = 400,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = {}
            },
        },
    },
    {
        coords = vector3(22.56, -1109.89, 28.80),
        blip = {
            id = 110,
            name = "Ammu Nation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop35', 
        inventory = {
            {
                name = 'ammo_pistol',
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
                price = 400,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = {}
            },
        },
    },
    {
        coords = vector3(2567.69, 294.38, 107.73),
        blip = {
            id = 110,
            name = "Ammu Nation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop36', 
        inventory = {
            {
                name = 'ammo_pistol',
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
                price = 400,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = {}
            },
        },
    },
    {
        coords = vector3(-1117.58, 2698.61, 17.55),
        blip = {
            id = 110,
            name = "Ammu Nation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop37', 
        inventory = {
            {
                name = 'ammo_pistol',
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
                price = 400,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = {}
            },
        },
    },
    {
        coords = vector3(842.44, -1033.42, 27.19),
        blip = {
            id = 110,
            name = "Ammu Nation",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop38', 
        inventory = {
            {
                name = 'ammo_pistol',
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
                price = 400,
                count = 1,
                metadata = {}
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 1,
                metadata = {}
            },
        },
    },


    --[[{
        coords = vector3(316.3667, -200.783, 54.086),
        blip = {
            id = 52,
            name = "Shop",
            color = 5,
            scale = 0.6,
        },
        text = 'E - Open Shop',
        name = 'Shop', 
        inventory = {
            {
                name = 'bread',
                price = 15,
                count = 200
            },
            {
                name = 'WEAPON_PISTOL',
                price = 1000,
                count = 200,
                metadata = {}
            },
        },
    },]]
}


Config.Ammos = {
    ['hsn_pistol_ammo'] = {
        count = 40,
        weapons = {
            `WEAPON_PISTOL`,
			`WEAPON_PISTOL_MK2`,
            `WEAPON_APPISTOL`,
            `WEAPON_HEAVYPISTOL`,
            `WEAPON_COMBATPISTOL`,
            `WEAPON_SNSPISTOL`,
            `WEAPON_SNSPISTOL_MK2`,
            `WEAPON_PISTOL50`,
            `WEAPON_REVOLVER`,
            `WEAPON_REVOLVER_MK2`,
            `WEAPON_DOUBLEACTION`,
            `WEAPON_MARKSMANPISTOL`,
            `WEAPON_MACHINEPISTOL`,
            `WEAPON_VINTAGEPISTOL`,
        },

    },
    ['hsn_pistol_ammo_big'] = {
        count = 30,
        weapons = {
            `WEAPON_PISTOL`,
			`WEAPON_PISTOL_MK2`,
            `WEAPON_APPISTOL`,
            `WEAPON_HEAVYPISTOL`,
            `WEAPON_COMBATPISTOL`,
            `WEAPON_SNSPISTOL`,
            `WEAPON_SNSPISTOL_MK2`,
            `WEAPON_PISTOL50`,
            `WEAPON_REVOLVER`,
            `WEAPON_REVOLVER_MK2`,
            `WEAPON_DOUBLEACTION`,
            `WEAPON_MARKSMANPISTOL`,
            `WEAPON_MACHINEPISTOL`,
            `WEAPON_VINTAGEPISTOL`,
        },
		
    },
    ['hsn_rifle_ammo'] = {
        count = 40,
        weapons = {
            `WEAPON_ADVANCEDRIFLE`,
            `WEAPON_ASSAULTRIFLE`,
            `WEAPON_ASSAULTRIFLE_MK2`,
            `WEAPON_BULLPUPRIFLE`,
            `WEAPON_BULLPUPRIFLE_MK2`,
            `WEAPON_CARBINERIFLE`,
            `WEAPON_CARBINERIFLE_MK2`,
            `WEAPON_COMPACTRIFLE`,
            `WEAPON_SPECIALCARBINE`,
            `WEAPON_SPECIALCARBINE_MK2`,
        },
		
    },
    ['hsn_rpg_ammo'] = {
        count = 40,
        weapons = {
            `WEAPON_GRENADELAUNCHER`,
            `WEAPON_HOMINGLAUNCHER`,
            `WEAPON_RPG`,
            `WEAPON_COMPACTLAUNCHER`,
            `WEAPON_FIREWORK`,
        },
		
    },
    ['hsn_shotgun_ammo'] = {
        count = 40,
        weapons = {
            `WEAPON_ASSAULTSHOTGUN`,
            `WEAPON_AUTOSHOTGUN`,
            `WEAPON_BULLPUPSHOTGUN`,
            `WEAPON_DBSHOTGUN`,
            `WEAPON_SAWNOFFSHOTGUN`,
            `WEAPON_PUMPSHOTGUN`,
            `WEAPON_PUMPSHOTGUN_MK2`,
            `WEAPON_HEAVYSHOTGUN`,
        },
		
    },
    ['hsn_lmg_ammo'] = {
        count = 40,
        weapons = {
            `WEAPON_MG`,
            `WEAPON_MINIGUN`,
            `WEAPON_COMBATMG_MK2`,
            `WEAPON_COMBATMG`,
        },
		
    },
    ['hsn_snipe_ammo'] = {
        count = 40,
        weapons = {
            `WEAPON_SNIPERRIFLE`,
            `WEAPON_MUSKET`,
            `WEAPON_MARKSMANRIFLE_MK2`,
            `WEAPON_MARKSMANRIFLE`,
            `WEAPON_HEAVYSNIPER_MK2`,
            `WEAPON_HEAVYSNIPER`,
        },
		
    },
    ['hsn_smg_ammo'] = {
        count = 40,
        weapons = {
            `WEAPON_ASSAULTSMG`,
            `WEAPON_MICROSMG`,
            `WEAPON_MINISMG`,
            `WEAPON_SMG`,
            `WEAPON_SMG_MK2`,
            `WEAPON_COMBATPDW`,
            `WEAPON_GUSENBERG`,
        },
    },
}

