Config = Config or {}
Config.PlayerSlot = 51
Config.DurabilityDecraseAmount = {
    ['WEAPON_PISTOL'] = 0.3,
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
    {
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
                price = 25,
                count = 1,
                metadata = {}
            },
        },
    },
}



Config.Ammos = {
    ['hsn_pistol_ammo'] = {
        count = 40,
        weapons = {
            `WEAPON_PISTOL`,
            `WEAPON_APPISTOL`,
            `WEAPON_HEAVYPISTOL`,
            `WEAPON_COMBATPISTOL`,
            `WEAPON_SNSPISTOL`,
            `WEAPON_VINTAGEPISTOL`,
        },

    },
    ['hsn_pistol_ammo_big'] = {
        count = 30,
        weapons = {
            `WEAPON_PISTOL`,
            `WEAPON_APPISTOL`,
            `WEAPON_HEAVYPISTOL`,
            `WEAPON_COMBATPISTOL`,
            `WEAPON_SNSPISTOL`,
            `WEAPON_VINTAGEPISTOL`,
        },
    },
}

