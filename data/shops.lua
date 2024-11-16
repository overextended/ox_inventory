---wip types

---@class OxShop
---@field name string
---@field blip? { id: number, colour: number, scale: number }
---@field inventory { name: string, price: number, count?: number, currency?: string }
---@field locations? vector3[]
---@field targets? { loc: vector3, length: number, width: number, heading: number, minZ: number, maxZ: number, distance: number, debug?: boolean, drawSprite?: boolean }[]
---@field groups? string | string[] | { [string]: number }

return {
	General = {
		name = 'Kiosk 24/7',
		blip = {
			id = 59, colour = 69, scale = 0.5
		},
		inventory = {
			{ name = 'wasser', price = 9 },
			{ name = 'sprunk', price = 12 },
			{ name = 'cola', price = 13 },
			{ name = 'brot', price = 6 },
			{ name = 'sandwich', price = 9 },
			{ name = 'blaettchen', price = 7 },
		},
		targets = {
			{ ped = `mp_m_shopkeep_01`, scenario = 'WORLD_HUMAN_AA_SMOKE', loc = vec3(372.4016, 325.8542, 102.5664), heading = 254.9931},
			{ ped = `S_F_Y_Shop_LOW`, scenario = 'WORLD_HUMAN_AA_COFFEE', loc = vec3(24.4929, -1347.7172, 28.4970), heading = 270.9123},
			{ ped = `mp_m_shopkeep_01`, scenario = 'WORLD_HUMAN_AA_COFFEE', loc = vec3(-3038.4473, 584.7329, 6.9089), heading = 15.3747},
			{ ped = `S_F_Y_Shop_MID`, scenario = 'WORLD_HUMAN_STAND_MOBILE', loc = vec3(-3243.9590, 1000.1609, 11.8307), heading = 355.6625},
			{ ped = `S_F_Y_Shop_LOW`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(1728.6068, 6416.6738, 34.0372), heading = 246.4818},
			{ ped = `mp_m_shopkeep_01`, scenario = 'WORLD_HUMAN_SMOKE', loc = vec3(1959.1354, 3741.5833, 31.3437), heading = 302.0530},
			{ ped = `S_F_Y_Shop_MID`, scenario = 'WORLD_HUMAN_AA_COFFEE', loc = vec3(549.2695, 2669.6155, 41.1565), heading = 98.3292},
			{ ped = `mp_m_shopkeep_01`, scenario = 'WORLD_HUMAN_STAND_MOBILE', loc = vec3(2676.5181, 3280.2109, 54.2411), heading = 329.0159},
			{ ped = `S_F_Y_Shop_LOW`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(2555.4841, 380.9057, 107.6229), heading = 3.5361},
			{ ped = `mp_m_shopkeep_01`, scenario = 'WORLD_HUMAN_AA_COFFEE', loc = vec3(159.9670, 6641.0176, 30.6985), heading = 225.7307},
			{ ped = `S_M_Y_Shop_MASK`, scenario = 'WORLD_HUMAN_SMOKE', loc = vec3(4466.2109, -4463.9351, 3.2490), heading = 201.4549},
			{ ped = `S_F_Y_Shop_LOW`, scenario = 'WORLD_HUMAN_AA_COFFEE', loc = vec3(-890.0961, 2837.0989, 22.5810), heading = 182.3876},
			{ ped = `S_F_Y_Shop_LOW`, scenario = 'WORLD_HUMAN_AA_COFFEE', loc = vec3(377.5449, -1787.0211, 28.5232), heading = 320.3656},
		}
	},
	Liquor = {
		name = 'Rob`s Schnaps Laden',
		blip = {
			id = 59, colour = 1, scale = 0.5
		}, inventory = {
			{ name = 'bier', price = 12 },
			{ name = 'cola', price = 15 },
			{ name = 'burger', price = 27 },
			{ name = 'whiskey_flasche', price = 142 },
			{ name = 'scratch_ticket', price = 2 },
		},
		targets = {
			{ ped = `mp_m_shopkeep_01`, scenario = 'WORLD_HUMAN_DRINKING', loc = vec3(-1486.7439, -377.5307, 39.1634), heading = 131.8548},
			{ ped = `S_F_Y_Shop_LOW`, scenario = 'WORLD_HUMAN_AA_SMOKE', loc = vec3(1134.3135, -983.2003, 44.4158), heading = 275.9501},
			{ ped = `S_F_Y_Shop_MID`, scenario = 'WORLD_HUMAN_DRINKING', loc = vec3(-1221.4283, -907.9989, 11.3263), heading = 33.5436},
			{ ped = `mp_m_shopkeep_01`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(-2966.3926, 391.5766, 14.0433), heading = 85.4508},
			{ ped = `S_F_Y_Shop_LOW`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(1166.8092, 2710.7844, 37.1577), heading = 181.9506},
			{ ped = `mp_m_shopkeep_01`, scenario = 'WORLD_HUMAN_DRINKING', loc = vec3(1392.4359, 3606.2634, 33.9809), heading = 197.8445},
		}
	},

	Hackershop = {
		name = 'Hackershop',
		blip = {
			id = 606, colour = 35, scale = 0.4
		}, inventory = {
			{ name = 'laptop_h', price = 5000, currency = 'black_money' },
			{ name = 'id_card', price = 3700, currency = 'black_money' },
		}, locations = {
			vec3(1276.28, -1710.22, 54.77)
		}, targets = {
			{ loc = vec3(1276.28, -1710.22, 54.77), length = 2.4, width = 0.1, heading = 25.0, minZ = 54.37, maxZ = 55.37, distance = 3.0 }
		}
	},

	Bauernhof = {
		name = 'Bauernhof',
		blip = {
			id = 59, colour = 35, scale = 0.5
		}, inventory = {
			{ name = 'rinderkeule', price = 50 },
			--{ name = 'id_card', price = 3700 },
		}, targets = {
			{ ped = `A_M_M_Farmer_01`, scenario = 'WORLD_HUMAN_AA_SMOKE', loc = vec3(2309.0313, 4884.0757, 40.8082), heading = 39.0941},
		}
	},

	Apotheke = {
		name = 'Apotheke',
		blip = {
			id = 51, colour = 2, scale = 0.5
		}, inventory = {
			{ name = 'bandage', price = 30 },
			{ name = 'ibu_400_akut', price = 25 },
			{ name = 'orthomol', price = 20 },
			{ name = 'reddragon', price = 27 },
		}, targets = {
			{ ped = `S_M_M_Doctor_01`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(93.2920, -235.8007, 53.5712), heading = 339.8984},
		}
	},

	YouTool = {
		name = 'Baumarkt',
		blip = {
			id = 59, colour = 38, scale = 0.6
		}, inventory = {
			{ name = 'lockpick', price = 500 },
			{ name = 'schere', price = 100 },
			{ name = 'handcuffs', price = 250 },
			{ name = 'blowpipe', price = 500 },
			{ name = 'klebeband', price = 10 },
			{ name = 'lithium', price = 15 },
			{ name = 'presslufthammer', price = 800 },
			{ name = 'schuerfpfanne', price = 150 },
			{ name = 'spitzhacke', price = 300 },
			{ name = 'parachute', price = 3450 },
			{ name = 'axt', price = 250 },
			{ name = 'binoculars', price = 350 },
			{ name = 'schlachtermesser', price = 480 },
			{ name = 'WEAPON_FLASHLIGHT', price = 295 },
			{ name = 'spray', price = 60 },
			{ name = 'spray_remover', price = 80 },
			{ name = 'drill', price = 400 },
			{ name = 'gas_mask', price = 500 },
			{ name = 'fishingrod', price = 2000 },
			{ name = 'fishbait', price = 10 },
			{ name = 'turtlebait', price = 50 },
		    { name = 'waschset', price = 200 },
			{ name = 'radio', price = 350 },
		}, targets = {
			{ ped = `S_M_Y_Construct_01`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(2748.3401, 3474.2588, 54.6724), heading = 226.0162},
			{ ped = `S_M_Y_Construct_01`, scenario = 'WORLD_HUMAN_AA_SMOKE', loc = vec3(342.5627, -1297.8639, 31.5101), heading = 166.5375},
		}
	},

	Ltd = {
		name = 'Ron`s Shop',
		blip = {
			id = 628, colour = 69, scale = 0.5
		}, inventory = {
			{ name = 'brot', price = 7 },
			{ name = 'cola', price = 13 },
			{ name = 'blaettchen', price = 3 },
			{ name = 'lithium', price = 18 },
			{ name = 'lighter', price = 4 },
			{ name = 'warndreieck', price = 50 },
			{ name = 'warnweste', price = 25 },
			{ name = 'waschset', price = 320 },
			{ name = 'weapon_petrolcan', price = 220 },
		},  targets = {
			{ ped = `S_M_M_AutoShop_01`, scenario = 'WORLD_HUMAN_DRINKING', loc = vec3(1697.3727, 4923.4312, 41.0637), heading = 322.3297},
			{ ped = `S_M_M_AutoShop_01`, scenario = 'WORLD_HUMAN_AA_SMOKE', loc = vec3(-706.1183, -914.5864, 18.2156), heading = 86.8069},
			{ ped = `S_M_M_AutoShop_01`, scenario = 'WORLD_HUMAN_AA_SMOKE', loc = vec3(-47.3256, -1758.6655, 28.4209), heading = 45.0096},
			--{ ped = `S_M_M_AutoShop_01`, scenario = 'WORLD_HUMAN_AA_SMOKE', loc = vec3(241.1945, -897.9530, 28.6232), heading = 164.5896}, CentralPark
		}
	},

	Ammunation = {
		name = 'Waffenladen',
		blip = {
			id = 110, colour = 69, scale = 0.5
		}, inventory = {
			{ name = 'ammo-9', price = 5, },
			{ name = 'WEAPON_KNIFE', price = 200 },
			{ name = 'WEAPON_BAT', price = 100 },
			{ name = 'kevlars', price = 1000 },
			{ name = 'kevlarm', price = 1500 },
			{ name = 'kevlar', price = 2100 },
			{ name = 'WEAPON_PISTOL', price = 1000, metadata = { registered = true }, license = 'weapon' },
		}, targets = {
			{ ped = `S_M_M_AmmuCountry`, scenario = 'WORLD_HUMAN_DRINKING', loc = vec3(-661.6767, -933.5714, 20.8292), heading = 175.5425},
			{ ped = `S_M_Y_AmmuCity_01`, scenario = 'WORLD_HUMAN_AA_SMOKE', loc = vec3(810.3133, -2159.0464, 28.6190), heading = 358.9748},
			{ ped = `S_M_M_AmmuCountry`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(1694.8267, 3761.2852, 33.7054), heading = 135.4213},
			{ ped = `S_M_M_AmmuCountry`, scenario = 'WORLD_HUMAN_AA_SMOKE', loc = vec3(-331.2310, 6085.4409, 30.4548), heading = 224.5500},
			{ ped = `S_M_Y_AmmuCity_01`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(250.1848, -51.6053, 68.9411), heading = 30.6571},
			{ ped = `S_M_Y_AmmuCity_01`, scenario = 'WORLD_HUMAN_AA_SMOKE', loc = vec3(23.9163, -1107.6727, 28.7970), heading = 70.7882},
			{ ped = `S_M_M_AmmuCountry`, scenario = 'WORLD_HUMAN_DRINKING', loc = vec3(2568.2502, 292.5665, 106.7348), heading = 359.9678},
			{ ped = `S_M_M_AmmuCountry`, scenario = 'WORLD_HUMAN_AA_SMOKE', loc = vec3(-1118.7694, 2700.0195, 16.5541), heading = 220.6967},
			{ ped = `S_M_Y_AmmuCity_01`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(844.5178, -1035.2571, 27.1948), heading = 1.6867},
		}
	},

	PoliceArmoury = {
		name = 'Police Armoury',
		groups = {
			['police'] = 3
		},
		blip = {
			id = 110, colour = 84, scale = 0.5
		}, inventory = {
			{ name = 'ammo-9', price = 5, grade = 3 },
			{ name = 'ammo-rifle', price = 5, grade = 3 },
			{ name = 'WEAPON_FLASHLIGHT', price = 200 },
			{ name = 'WEAPON_NIGHTSTICK', price = 100 },
			{ name = 'uvlight', price = 100, grade = 3 },
			{ name = 'nikkit', price = 1, grade = 3 },
			{ name = 'handcuffs', price = 30 },
			{ name = 'kevlars', price = 800 },
			{ name = 'kevlarm', price = 1200 },
			{ name = 'kevlar', price = 1750 },
			{ name = 'WEAPON_PISTOL', price = 500, grade = 1, metadata = { registered = true, serial = 'POL' }, license = 'weapon' },
			{ name = 'WEAPON_CARBINERIFLE', price = 1000, metadata = { registered = true, serial = 'POL' }, license = 'weapon', grade = 3 },
			{ name = 'WEAPON_STUNGUN', price = 500, metadata = { registered = true, serial = 'POL'} }
		}, locations = {
			vec3(449.6307, -978.3926, 30.5637)
		}, targets = {
			{ ped = `S_M_Y_AmmuCity_01`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(480.3083, -996.7000, 29.6898), heading = 85.7288},
		}
	},

	Medicine = {
		name = 'Ambulance Shop',
		groups = {
			['ambulance'] = 2
		},
		blip = {
			id = 403, colour = 69, scale = 0.5
		}, inventory = {
			--{ name = 'defibrillator', price = 200 },
			{ name = 'medikit', price = 100 },
			{ name = 'bandage', price = 10 }
		}, locations = {
			vec3(1140.0309, -1563.4537, 35.3805)
		}, targets = {
			{ loc = vec3(1140.0309, -1563.4537, 35.3805), length = 1.3, width = 1.0, heading = 0, minZ = 34.28, maxZ = 36.48, distance = 3 }
		}
	},

	--[[BlackMarketArms = {
		name = 'SM Equip',
		inventory = {
			{ name = 'thermal_charge', price = 4000, currency = 'black_money' },
			{ name = 'c4', price = 7500, currency = 'black_money' }
			--{ name = 'WEAPON_CERAMICPISTOL', price = 50000, metadata = { registered = false }, currency = 'black_money' },
			--{ name = 'at_suppressor_light', price = 50000, currency = 'black_money' },
			--{ name = 'ammo-rifle', price = 1000, currency = 'black_money' },
			--{ name = 'ammo-rifle2', price = 1000, currency = 'black_money' }
		}, locations = {
			vec3(-593.91, 220.41, 74.15)
		}, targets = {
			{ loc = vec3(-593.28, 220.41, 74.15), length = 1.2, width = 0.8, heading = 1.0, minZ = 73.15, maxZ = 75.15, distance = 3 }
		}
	},

	BlackMarketPstolen = {
		name = 'SM Pistolen',
		inventory = {
			{ name = 'WEAPON_CERAMICPISTOL', price = 2550000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_APPISTOL', price = 140000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_COMBATPISTOL', price = 120000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_MARKSMANPISTOL', price = 700000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_FLAREGUN', price = 40000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_HEAVYPISTOL', price = 80000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_NAVYREVOLVER', price = 300000, metadata = { registered = false }, currency = 'black_money' },
			--{ name = 'WEAPON_PERICOPISTOL', price = 500000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_PISTOL', price = 60000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_PISTOL50', price = 180000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_PISTOL_MK2', price = 80000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_REVOLVER', price = 280000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_REVOLVER_MK2', price = 340000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_SNSPISTOL', price = 35000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_SNSPISTOL_MK2', price = 45000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_VINTAGEPISTOL', price = 1200000, metadata = { registered = false }, currency = 'black_money' }
		}, locations = {
			vec3(-597.24, 222.36, 74.15)
		}, targets = {
			{ loc = vec3(-596.62, 222.44, 74.15), length = 1.2, width = 0.8, heading = 0.0, minZ = 73.15, maxZ = 74.0, distance = 3 }
		}
	},

	BlackMarketComponents = {
		name = 'SM Komponenten',
		inventory = {
			{ name = 'at_flashlight', price = 15, currency = 'black_money' },
			{ name = 'at_suppressor_light', price = 15, currency = 'black_money' },
			{ name = 'at_suppressor_heavy', price = 15, currency = 'black_money' },
			{ name = 'at_grip', price = 15, currency = 'black_money' },
			{ name = 'at_barrel', price = 15, currency = 'black_money' },
			{ name = 'at_clip_extended_pistol', price = 15, currency = 'black_money' },
			{ name = 'at_clip_extended_smg', price = 15, currency = 'black_money' },
			{ name = 'at_clip_extended_shotgun', price = 15, currency = 'black_money' },
			{ name = 'at_clip_extended_rifle', price = 15, currency = 'black_money' },
			{ name = 'at_clip_extended_mg', price = 15, currency = 'black_money' },
			{ name = 'at_clip_extended_sniper', price = 15, currency = 'black_money' },
			{ name = 'at_clip_drum_smg', price = 15, currency = 'black_money' },
			{ name = 'at_clip_drum_shotgun', price = 15, currency = 'black_money' },
			{ name = 'at_clip_drum_rifle', price = 15, currency = 'black_money' },
			{ name = 'at_compensator', price = 15, currency = 'black_money' },
			{ name = 'at_scope_small', price = 15, currency = 'black_money' },
			{ name = 'at_scope_medium', price = 15, currency = 'black_money' },
			{ name = 'at_scope_advanced', price = 15, currency = 'black_money' },
			{ name = 'at_scope_zoom', price = 15, currency = 'black_money' },
			{ name = 'at_scope_nv', price = 15, currency = 'black_money' },
			{ name = 'at_scope_thermal', price = 15, currency = 'black_money' },
			{ name = 'at_muzzle_squared', price = 15, currency = 'black_money' },
			{ name = 'at_muzzle_bell', price = 15, currency = 'black_money' },
			{ name = 'at_muzzle_flat', price = 15, currency = 'black_money' },
			{ name = 'at_muzzle_tactical', price = 15, currency = 'black_money' },
			{ name = 'at_muzzle_fat', price = 15, currency = 'black_money' },
			{ name = 'at_muzzle_precision', price = 15, currency = 'black_money' },
			{ name = 'at_muzzle_heavy', price = 15, currency = 'black_money' },
			{ name = 'at_muzzle_slanted', price = 15, currency = 'black_money' },
			{ name = 'at_muzzle_split', price = 15, currency = 'black_money' },
			{ name = 'at_skin_gold', price = 15, currency = 'black_money' },
			{ name = 'at_muzzle_fat', price = 15, currency = 'black_money' },
			{ name = 'at_skin_gold', price = 15, currency = 'black_money' },
			{ name = 'at_skin_camo', price = 15, currency = 'black_money' },
			{ name = 'at_skin_brushstroke', price = 15, currency = 'black_money' },
			{ name = 'at_skin_woodland', price = 15, currency = 'black_money' },
			{ name = 'at_skin_skull', price = 15, currency = 'black_money' },
			{ name = 'at_skin_sessanta', price = 15, currency = 'black_money' },
			{ name = 'at_skin_perseus', price = 15, currency = 'black_money' },
			{ name = 'at_skin_leopard', price = 15, currency = 'black_money' },
			{ name = 'at_skin_zebra', price = 15, currency = 'black_money' },
			{ name = 'at_skin_geometric', price = 15, currency = 'black_money' },
			{ name = 'at_skin_boom', price = 15, currency = 'black_money' },
			{ name = 'at_skin_patriotic', price = 15, currency = 'black_money' }
		}, locations = {
			vec3(-597.84, 220.9, 74.15)
		}, targets = {
			{ loc = vec3(-598.78, 220.53, 74.15), length = 1.0, width = 1.0, heading = 0.0, minZ = 73.35, maxZ = 74.95, distance = 3 }
		}
	},

	BlackMarketMuni = {
		name = 'SM Munition',
		inventory = {
			{ name = 'ammo-22', price = 10, currency = 'black_money' },
			{ name = 'ammo-38', price = 11, currency = 'black_money' },
			{ name = 'ammo-45', price = 12, currency = 'black_money' },
			{ name = 'ammo-50', price = 12, currency = 'black_money' },
			{ name = 'ammo-9', price = 9, currency = 'black_money' },
			{ name = 'ammo-flare', price = 20, currency = 'black_money' },
			{ name = 'ammo-heavysniper', price = 224, currency = 'black_money' },
			{ name = 'ammo-musket', price = 6, currency = 'black_money' },
			{ name = 'ammo-rifle', price = 25, currency = 'black_money' },
			{ name = 'ammo-rifle2', price = 28, currency = 'black_money' },
			{ name = 'ammo-shotgun', price = 10, currency = 'black_money' },
			{ name = 'ammo-sniper', price = 50, currency = 'black_money' },
			{ name = 'ammo-44', price = 15, currency = 'black_money' }
		}, locations = {
			vec3(-596.41, 225.38, 74.15)
		}, targets = {
			{ loc = vec3(-596.34, 224.83, 74.15), length = 0.8, width = 1.2, heading = 1.0, minZ = 73.95, maxZ = 74.55, distance = 3 }
		}
	},

	BlackMarketSMG = {
		name = 'SM SMG',
		inventory = {
			{ name = 'WEAPON_MICROSMG', price = 400000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_SMG', price = 430000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_SMG_MK2', price = 480000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_ASSAULTSMG', price = 435000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_COMBATPDW', price = 430000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_MACHINEPISTOL', price = 480000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_MINISMG', price = 440000, metadata = { registered = false }, currency = 'black_money' }
		}, locations = {
			vec3(-596.65, 223.69, 74.15)
		}, targets = {
			{ loc = vec3(-596.65, 223.69, 74.15), length = 1.35, width = 0.8, heading = 1.0, minZ = 73.75, maxZ = 74.15, distance = 3 }
		}
	},

	BlackMarketPump = {
		name = 'SM Schrotflinten',
		inventory = {
			{ name = 'WEAPON_PUMPSHOTGUN', price = 410000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_PUMPSHOTGUN_MK2', price = 445000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_SAWNOFFSHOTGUN', price = 470000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_ASSAULTSHOTGUN', price = 480000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_BULLPUPSHOTGUN', price = 465000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_MUSKET', price = 480000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_HEAVYSHOTGUN', price = 510000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_DBSHOTGUN', price = 380000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_COMBATSHOTGUN', price = 470000, metadata = { registered = false }, currency = 'black_money' }
		}, locations = {
			vec3(-599.2, 224.79, 74.15)
		}, targets = {
			{ loc = vec3(-599.2, 224.79, 74.15), length = 1.45, width = 0.8, heading = 1.0, minZ = 73.75, maxZ = 74.15, distance = 3 }
		}
	},

	BlackMarketAssault = {
		name = 'SM Sturmgewehre',
		inventory = {
			{ name = 'WEAPON_ASSAULTRIFLE', price = 610000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_ASSAULTRIFLE_MK2', price = 645000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_CARBINERIFLE', price = 670000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_CARBINERIFLE_MK2', price = 680000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_ADVANCEDRIFLE', price = 665000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_SPECIALCARBINE', price = 680000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_SPECIALCARBINE_MK2', price = 710000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_BULLPUPRIFLE', price = 645000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_BULLPUPRIFLE_MK2', price = 670000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_COMPACTRIFLE', price = 635000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_MILITARYRIFLE', price = 690000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_HEAVYRIFLE', price = 635000, metadata = { registered = false }, currency = 'black_money' }
		}, locations = {
			vec3(-593.29, 221.83, 74.15)
		}, targets = {
			{ loc = vec3(-593.29, 221.83, 74.15), length = 1.4, width = 0.8, heading = 0.0, minZ = 73.75, maxZ = 74.15, distance = 3 }
		}
	},

	BlackMarketLMG = {
		name = 'SM Maschinengewehre',
		inventory = {
			{ name = 'WEAPON_COMBATMG', price = 710000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_COMBATMG_MK2', price = 760000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_MG', price = 740000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_GUSENBERG', price = 735000, metadata = { registered = false }, currency = 'black_money' }
		}, locations = {
			vec3(-593.4, 223.7, 74.15)
		}, targets = {
			{ loc = vec3(-593.4, 223.7, 74.15), length = 1.45, width = 0.9, heading = 0.0, minZ = 73.75, maxZ = 74.15, distance = 3 }
		}
	},

	BlackMarketSniper = {
		name = 'SM Scharfschützengewehre',
		inventory = {
			{ name = 'WEAPON_SNIPERRIFLE', price = 1710000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_HEAVYSNIPER', price = 1760000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_HEAVYSNIPER_MK2', price = 1790000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_MARKSMANRIFLE', price = 1735000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_MARKSMANRIFLE_MK2', price = 1790000, metadata = { registered = false }, currency = 'black_money' }
		}, locations = {
			vec3(-599.24, 222.63, 74.15)
		}, targets = {
			{ loc = vec3(-599.24, 222.63, 74.15), length = 2.55, width = 0.8, heading = 1.0, minZ = 73.55, maxZ = 73.95, distance = 3 }
		}
	},]]

	MallLieferanten1 = {
		name = 'Mall Lieferanten1',
		inventory = {
			{ name = 'teeblaetter', price = 3, currency = 'money' },
			{ name = 'sauce', price = 1, currency = 'money' },
			{ name = 'filet', price = 5, currency = 'money' },
			{ name = 'bread', price = 3, currency = 'money' },
			{ name = 'salat', price = 2, currency = 'money' },
			{ name = 'water', price = 4, currency = 'money' }
		}, locations = {
			vec3(95.80, -1811.02, 27.07)
		}, targets = {
			{ loc = vec3(95.46, -1810.66, 27.07), length = 1.2, width = 0.4, heading = 316.0, minZ = 25.97, maxZ = 27.97, distance = 3 }
		}, groups = {
			['teapot'] = 11
		}
	},

	MallLieferanten2 = {
		name = 'Mall Lieferanten2',
		inventory = {
			{ name = 'gewuerze', price = 1, currency = 'money' },
			{ name = 'sauce', price = 1, currency = 'money' },
			{ name = 'filet', price = 5, currency = 'money' },
			{ name = 'getreide', price = 2, currency = 'money' },
			{ name = 'salat', price = 2, currency = 'money' },
			{ name = 'kaese', price = 2, currency = 'money' },
			{ name = 'bohnen', price = 2, currency = 'money' },
			{ name = 'water', price = 4, currency = 'money' }
		}, locations = {
			vec3(95.80, -1811.02, 27.07)
		}, targets = {
			{ loc = vec3(95.46, -1810.66, 27.07), length = 1.2, width = 0.4, heading = 316.0, minZ = 25.97, maxZ = 27.97, distance = 3 }
		}, groups = {
			['tequilala'] = 11
		}
	},

	VendingMachineDrinks = {
		name = 'Getränke Automat',
		inventory = {
			{ name = 'wasser', price = 10 },
			{ name = 'cola', price = 10 },
			{ name = 'sprunk', price = 8 }
		},
		model = {
			`prop_vend_soda_02`, `prop_vend_fridge01`, `prop_vend_water_01`, `prop_vend_soda_01`
		}
	},
	Hamburgerstand = {
		name = 'Burger Stand',
		inventory = {
			{ name = 'hamburger', price = 24 },
			{ name = 'cola', price = 10 }
		},
		model = {
			`prop_burgerstand_01`
		}
	},
	HotDogstand = {
		name = 'Hotdog Stand',
		inventory = {
			{ name = 'hotdog', price = 22 },
			{ name = 'sprunk', price = 10 }
		},
		model = {
			`prop_hotdogstand_01`
		}
	},
	Snackautomat = {
		name = 'Snack Automat',
		inventory = {
			{ name = 'chips', price = 5 },
		},
		model = {
			`prop_vend_snak_01`
		}
	},
	Wasserspender = {
		name = 'Wasserspender',
		inventory = {
			{ name = 'wasser', price = 6 },
		},
		model = {
			`prop_watercooler`
		}
	},
	Zigarettenautomat = {
		name = 'Zigarettenautomat',
		inventory = {
			{ name = 'redwoodgold2', price = 30 },
		},
		model = {
			`prop_vend_fags_01`
		}
	},

	Export = {
		name = 'Exporteur (Verkauf)',
		blip = {
			id = 642, colour = 3, scale = 0.5
		}, inventory = {
			{ name = 'money', price = 1, currency = 'salat' },
			{ name = 'money', price = 1, currency = 'zwiebel' },
			{ name = 'money', price = 1, currency = 'orange' },
		}, targets = {
			{ ped = `IG_RoosterMcCraw`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(1013.0371, -2902.2998, 4.9006), heading = 187.0048},
		}
	},



	--[[TestShop = {
		name = 'TestShop',
		blip = {
			id = 832, colour = 2, scale = 0.5
		}, inventory = {
			--{ name = 'bandage', price = 30 },
			{ name = 'sandwich', price = 25, count = 0 },
			--{ name = 'orthomol', price = 20 },
			--{ name = 'reddragon', price = 27 },
		}, targets = {
			{ ped = `S_M_M_Doctor_01`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(62.5555, -1004.9807, 28.3574), heading = 344.1503},
		}
	},]]
}