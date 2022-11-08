---wip types

---@class OxShop
---@field name string
---@field blip? { id: number, colour: number, scale: number }
---@field inventory { name: string, price: number, count?: number, currency?: string }
---@field locations? vector3[]
---@field targets? { loc: vector3, length: number, width: number, heading: number, minZ: number, maxZ: number, distance: number, debug?: boolean, drawSprite?: boolean }[]
---@field groups? string | string[] | { [string]: number }

return {
  Tests = {
    name = 'TESTING PURPOSE',
    blip = {
      id = 59, colour = 69, scale = 0.8
    }, inventory = {
      { name = 'ammo-556', price = 1 },
      { name = 'WEAPON_BATTLEAXE', price = 1 },
      { name = 'at_shotgun_handguard_mk2', price = 1 },
      { name = 'at_smg_scope_mk1', price = 1 },
      { name = 'at_rifle_pistolgrip_mk3', price = 1 },
      { name = 'at_rifle_grip_mk3', price = 1 },
      { name = 'at_pistol_suppressor_mk4', price = 1 },
      { name = 'at_sniper_laser_mk1', price = 1 },
      { name = 'bandage', price = 1 },
      { name = 'WEAPON_STONE_HATCHET', price = 1 },
      { name = 'at_sniper_clip_mk3', price = 1 },
      { name = 'at_rifle_grip_mk2', price = 1 },
      { name = 'speedbomb', price = 1 },
      { name = 'at_rifle_clip_mk6', price = 1 },
      { name = 'weed_fertilizer', price = 1 },
      { name = 'radio', price = 1 },
      { name = 'at_rifle_suppressor_mk1', price = 1 },
      { name = 'at_smg_suppressor_mk2', price = 1 },
      { name = 'WEAPON_NIGHTSTICK', price = 1 },
      { name = 'WEAPON_DAGGER', price = 1 },
      { name = 'at_rifle_suppressor_mk4', price = 1 },
      { name = 'at_shotgun_supressor_mk2', price = 1 },
      { name = 'WEAPON_AXMC', price = 1 },
      { name = 'at_rifle_handguard_mk2', price = 1 },
      { name = 'at_rifle_holo_mk2', price = 1 },
      { name = 'WEAPON_STUNGUN_MP', price = 1 },
      { name = 'WEAPON_CROWBAR', price = 1 },
      { name = 'cv_repas', price = 1 },
      { name = 'WEAPON_FLARE', price = 1 },
      { name = 'at_rifle_clip_mk3', price = 1 },
      { name = 'coca_seed', price = 1 },
      { name = 'WEAPON_BENELLIM2', price = 1 },
      { name = 'at_pistol_slide_mk3', price = 1 },
      { name = 'at_rifle_flashlight_mk2', price = 1 },
      { name = 'bait', price = 1 },
      { name = 'at_rifle_holo_mk1', price = 1 },
      { name = 'money', price = 1 },
      { name = 'WEAPON_MK18', price = 1 },
      { name = 'ammo-9', price = 1 },
      { name = 'ammo-762', price = 1 },
      { name = 'at_rifle_dustcover_mk2', price = 1 },
      { name = 'phone', price = 1 },
      { name = 'WEAPON_GOLFCLUB', price = 1 },
      { name = 'at_rifle_stock_mk5', price = 1 },
      { name = 'at_shotgun_scope', price = 1 },
      { name = 'WEAPON_MINIUZI', price = 1 },
      { name = 'cv_boisson', price = 1 },
      { name = 'fishingrod', price = 1 },
      { name = 'at_rifle_clip_mk5', price = 1 },
      { name = 'pochon', price = 1 },
      { name = 'at_rifle_handguard_mk4', price = 1 },
      { name = 'at_rifle_stock_mk6', price = 1 },
      { name = 'at_rifle_handguard_mk3', price = 1 },
      { name = 'at_smg_clip_mk3', price = 1 },
      { name = 'WEAPON_SNOWBALL', price = 1 },
      { name = 'WEAPON_POOLCUE', price = 1 },
      { name = 'ammo-50', price = 1 },
      { name = 'WEAPON_AKM', price = 1 },
      { name = 'at_rifle_clip_mk4', price = 1 },
      { name = 'at_rifle_suppressor_mk3', price = 1 },
      { name = 'sim', price = 1 },
      { name = 'WEAPON_G17', price = 1 },
      { name = 'WEAPON_SMOKEGRENADE', price = 1 },
      { name = 'defibrilator', price = 1 },
      { name = 'ammo-flare', price = 1 },
      { name = 'WEAPON_GRENADE', price = 1 },
      { name = 'WEAPON_BAT', price = 1 },
      { name = 'at_sniper_barrel4_mk2', price = 1 },
      { name = 'WEAPON_MACHETE', price = 1 },
      { name = 'cubancigar', price = 1 },
      { name = 'at_pistol_scope_reflex', price = 1 },
      { name = 'at_pistol_scope_reddot', price = 1 },
      { name = 'at_pistol_scope_holo', price = 1 },
      { name = 'WEAPON_2011', price = 1 },
      { name = 'at_rifle_reflex_mk1', price = 1 },
      { name = 'at_rifle_stock_mk9', price = 1 },
      { name = 'WEAPON_BALL', price = 1 },
      { name = 'at_sniper_handguard_mk2', price = 1 },
      { name = 'at_pistol_barrel_mk2', price = 1 },
      { name = 'WEAPON_PETROLCAN', price = 1 },
      { name = 'parachute', price = 1 },
      { name = 'black_money', price = 1 },
      { name = 'screwdriver', price = 1 },
      { name = 'marlborocig', price = 1 },
      { name = 'WEAPON_MOLOTOV', price = 1 },
      { name = 'at_smg_stock_mk2', price = 1 },
      { name = 'briefcasemoney', price = 1 },
      { name = 'at_pistol_extented_clip_mk2', price = 1 },
      { name = 'coke_pooch', price = 1 },
      { name = 'at_rifle_stock_mk8', price = 1 },
      { name = 'at_sniper_barrel8_silencecieux_mk2', price = 1 },
      { name = 'at_rifle_frame_mk2', price = 1 },
      { name = 'marijuana', price = 1 },
      { name = 'WEAPON_MP5', price = 1 },
      { name = 'illegal_medical_pass', price = 1 },
      { name = 'at_smg_clip_mk2', price = 1 },
      { name = 'WEAPON_NSR9', price = 1 },
      { name = 'jumelles', price = 1 },
      { name = 'fixtool', price = 1 },
      { name = 'at_rifle_stock_mk3', price = 1 },
      { name = 'ammo-45', price = 1 },
      { name = 'at_sniper_grip1_bipod', price = 1 },
      { name = 'WEAPON_FLAREGUN', price = 1 },
      { name = 'instantbomb', price = 1 },
      { name = 'weed_seed', price = 1 },
      { name = 'spike', price = 1 },
      { name = 'remotebomb', price = 1 },
      { name = 'davidoffcigar', price = 1 },
      { name = 'ammo-shotgun', price = 1 },
      { name = 'handcuff', price = 1 },
      { name = 'mastercard', price = 1 },
      { name = 'marlboro', price = 1 },
      { name = 'at_rifle_flashlight_mk1', price = 1 },
      { name = 'at_sniper_clip_mk2', price = 1 },
      { name = 'lighter', price = 1 },
      { name = 'WEAPON_HATCHET', price = 1 },
      { name = 'coca_leaf', price = 1 },
      { name = 'braceletgps', price = 1 },
      { name = 'at_pistol_muzzle_mk2', price = 1 },
      { name = 'armour', price = 1 },
      { name = 'cannabis', price = 1 },
      { name = 'timerbomb', price = 1 },
      { name = 'hat', price = 1 },
      { name = 'at_rifle_grip_mk1', price = 1 },
      { name = 'at_smg_suppressor_mk1', price = 1 },
      { name = 'at_shotgun_supressor_mk1_02', price = 1 },
      { name = 'coupebracelet', price = 1 },
      { name = 'lockpick', price = 1 },
      { name = 'WEAPON_KNUCKLE', price = 1 },
      { name = 'fakeplate', price = 1 },
      { name = 'at_pistol_suppressor_mk2', price = 1 },
      { name = 'at_smg_scope_mk2', price = 1 },
      { name = 'at_pistol_suppressor_mk3', price = 1 },
      { name = 'mask', price = 1 },
      { name = 'WEAPON_BOTTLE', price = 1 },
      { name = 'WEAPON_WRENCH', price = 1 },
      { name = 'WEAPON_M9', price = 1 },
      { name = 'at_shotgun_supressor_mk2_02', price = 1 },
      { name = 'at_pistol_slide_mk4', price = 1 },
      { name = 'at_rifle_stock_mk7', price = 1 },
      { name = 'WEAPON_KNIFE', price = 1 },
      { name = 'WEAPON_DOUBLEBARRELFM', price = 1 },
      { name = 'at_rifle_stock_mk4', price = 1 },
      { name = 'WEAPON_M870', price = 1 },
      { name = 'WEAPON_GUSENBERG', price = 1 },
      { name = 'at_shotgun_flashlight', price = 1 },
      { name = 'WEAPON_M4', price = 1 },
      { name = 'at_shotgun_supressor_mk1', price = 1 },
      { name = 'at_sniper_barrel5_silencieux_mk1', price = 1 },
      { name = 'at_pistol_frame_mk2', price = 1 },
      { name = 'at_pistol_flashlight', price = 1 },
      { name = 'at_rifle_clip_mk7', price = 1 },
      { name = 'at_rifle_frame_mk3', price = 1 },
      { name = 'WEAPON_L5', price = 1 },
      { name = 'at_rifle_suppressor_mk2', price = 1 },
      { name = 'at_shotgun_barrel_mk2', price = 1 },
      { name = 'WEAPON_SWITCHBLADE', price = 1 },
      { name = 'braceletgps_off', price = 1 },
      { name = 'at_shotgun_stock', price = 1 },
      { name = 'WEAPON_HAMMER', price = 1 },
      { name = 'at_pistol_muzzle_mk1', price = 1 },
      { name = 'at_rifle_stock_mk2', price = 1 },
      { name = 'at_rifle_acog_mk1', price = 1 },
      { name = 'at_rifle_clip_mk2', price = 1 },
      { name = 'at_rifle_pistolgrip_mk2', price = 1 },
      { name = 'at_pistol_slide_mk2', price = 1 },
      { name = 'WEAPON_FLASHLIGHT', price = 1 },
      { name = 'at_pistol_barrel_mk3', price = 1 },
      { name = 'ammo-sniper', price = 1 },
    }, locations = {
      vec3(234.8596, -785.7424, 30.6173)
    }
  },

  General = {
    name = '24/7 Superette',
    blip = {
      id = 59, colour = 69, scale = 0.8
    }, inventory = {
      { name = 'water', price = 2 },
      { name = 'cubancigar', price = 10 },
      { name = 'marlboro', price = 20 },
      { name = 'lighter', price = 6 },
    }, locations = {
      vec3(373.8, 325.8, 103.5), vec3(2557.4, 382.2, 108.6), vec3(-3038.9, 585.9, 7.9),
      vec3(-3241.9, 1001.4, 12.8), vec3(547.4, 2671.7, 42.1), vec3(1961.4, 3740.6, 32.3),
      vec3(2678.9, 3280.6, 55.2), vec3(1729.2, 6414.1, 35.0),
      vec3(25.747049331665, -1346.6291503906, 29.497022628784), vec3(1135.8, -982.2, 46.4),
      vec3(-1222.9, -906.9, 12.3),
      vec3(-1487.5, -379.1, 40.1), vec3(-2968.2, 390.9, 15.0), vec3(1166.0, 2708.9, 38.1),
      vec3(1392.5, 3604.6, 34.9),
      vec3(-48.5, -1757.5, 29.4), vec3(1163.3, -323.8, 69.2), vec3(-707.5, -914.2, 19.2),
      vec3(-1820.5, 792.5, 138.1),
      vec3(1698.3, 4924.4, 42.0), vec3(161.7914, 6641.0703, 31.6989), vec3(814.2743, -781.0761, 26.1750),
      vec3(303.5167, -580.4360, 47.2809), vec3(-160.4574, 6322.7124, 31.5869)
    }, targets = {
    }
  },

  Ammunation = {
    name = 'Ammunation',
    blip = {
      id = 110, colour = 69, scale = 0.8
    }, inventory = {
      -- { name = 'weapon_heavypistol', price = 200, metadata = { registered = true }, license = 'weapon' },
      -- { name = 'weapon_knuckle', price = 200 },
    }, locations = {
      vec3(-660.8675, -939.4791, 21.8293),
      vec3(810.2, -2157.3, 29.6),
      vec3(1693.4, 3759.5, 34.7),
      vec3(-330.2, 6083.8, 31.4),
      vec3(252.3, -50.0, 69.9),
      vec3(22.0, -1107.2, 29.8),
      vec3(2567.6, 294.3, 108.7),
      vec3(-1117.5, 2698.6, 18.5),
      vec3(842.4, -1033.4, 28.1)
    }, targets = {

    }
  },

  Medicine = {
    name = 'Réceptionniste Intendant',
    groups = {
      ['ambulance'] = 0
    },
    blip = {
      id = 403, colour = 69, scale = 0.8
    }, inventory = {
      { name = 'defibrilator', price = 26 },
      { name = 'bandage', price = 5 },
      -- { name = 'tourniquet', price = 5 },
      -- { name = 'quickclot', price = 5 },
      -- { name = 'packing_bandage', price = 5 },
      -- { name = 'elastic_bandage', price = 5 },
      -- { name = 'surgical_kit', price = 5 },
      -- { name = 'epinephrine', price = 5 },
      -- { name = 'atropine', price = 5 },
      -- { name = 'morphin', price = 5 },
      -- { name = 'painkillers', price = 5 },
      -- { name = 'blood_250', price = 5 },
      -- { name = 'blood_500', price = 5 },
      -- { name = 'blood_1000', price = 5 },
    }, locations = {
      vec3(309.5337, -578.8837, 43.2654),
      vec3(-249.5674, 6334.8374, 32.4272)
    }, targets = {
    }
  },

  HopitalIllegal = {
    name = 'Gunter les doigts de fée',
    blip = {
      id = 403, colour = 69, scale = 0.8
    }, inventory = {
      { name = 'illegal_medical_pass', price = 26, isIllegal = true },
    }, locations = {
      vec3(260.7488, -1358.6775, 24.5378),
    }, targets = {

    }
  },

  ArmesIllegales = {
    name = 'Black Market (Arms)',
    inventory = {
      -- { name = 'WEAPON_DAGGER', price = 5000, metadata = { registered = false }, isIllegal = true },
    }, locations = {
      vec3(309.09, -913.75, 56.46)
    }, targets = {

    }
  },

  Weed = {
    name = 'Joey gros nuage',
    inventory = {
      { name = 'weed_seed', price = 5000, isIllegal = true },
      { name = 'weed_fertilizer', price = 5000, isIllegal = true },
    }, locations = {
      vec3(-1472.2466, 2130.8174, 39.8866)
    }, targets = {

    }
  },

  Cocaine = {
    name = 'Mike le poudré',
    inventory = {
      { name = 'coca_seed', price = 5000, isIllegal = true },
      { name = 'weed_fertilizer', price = 5000, isIllegal = true },
    }, locations = {
      vec3(1977.2164, -2606.6401, 2.7394)
    }, targets = {

    }
  },

  ObjetIllegaux = {
    name = 'Mamie les bons tuyaux',
    inventory = {
      { name = 'lockpick', price = 5000, isIllegal = true },
      -- { name = 'hack_usb', price = 5000, isIllegal = true },
      -- { name = 'cutter', price = 5000, isIllegal = true },
      { name = 'spike', price = 5000, isIllegal = true },
    }, locations = {
      vec3(2940.1358, 4624.7635, 48.34)
    }, targets = {

    }
  },

  DigitalDen = {
    name = 'Digital Den',
    inventory = {
      { name = 'phone', price = 5000 },
      { name = 'sim', price = 5000 },
      -- { name = 'laptop', price = 5000 },
    }, locations = {
      vec3(-1209.1213, -1503.2405, 4.3739)
    }, targets = {

    }
  },
}
