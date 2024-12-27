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
			{ name = 'money', price = 1, currency = 'salat' },
			{ name = 'money', price = 1, currency = 'zwiebel' },
			{ name = 'money', price = 1, currency = 'orange' },
			{ name = 'money', price = 1, currency = 'tomate' },
			{ name = 'money', price = 1, currency = 'aramidfasern' },
			{ name = 'money', price = 1, currency = 'wolle' },
		}, targets = {
			{ ped = `A_M_M_Farmer_01`, scenario = 'WORLD_HUMAN_AA_SMOKE', loc = vec3(2309.0313, 4884.0757, 40.8082), heading = 39.0941},
		}
	},

	TaschenLaden = {
		name = 'Taschen',
		blip = {
			id = 59, colour = 62, scale = 0.5
		}, inventory = {
			{ name = 'bag', price = 3000 },
			{ name = 'bag2', price = 5000 },
			{ name = 'kleidertasche', price = 8000},
		}, targets = {
			{ ped = `a_m_y_juggalo_01`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(-1612.281, -1075.265, 12.019), heading = 100.973},
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
			{ name = 'lithium', price = 15 },
			{ name = 'parachute', price = 3450 },
			{ name = 'axt', price = 250 },
			{ name = 'WEAPON_FLASHLIGHT', price = 295 },
		    { name = 'waschset', price = 200 },
			{ name = 'fixkit', price = 5000 },
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

	Exporteur = {
		name = 'Exporteur',
		blip = {
			id = 642, colour = 3, scale = 0.5
		}, inventory = {
			{ name = 'money', price = 1, currency = 'salat' },
		}, targets = {
			{ ped = `IG_RoosterMcCraw`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(1013.0371, -2902.2998, 4.9006), heading = 187.0048},
		}
	},

	Obststand = {
		name = 'Obststand',
		blip = {
			id = 642, colour = 3, scale = 0.5
		}, inventory = {
			{ name = 'money', price = 1, currency = 'salat' },
			{ name = 'money', price = 1, currency = 'zwiebel' },
			{ name = 'money', price = 1, currency = 'orange' },
			{ name = 'money', price = 1, currency = 'tomate' },
			{ name = 'money', price = 1, currency = 'wolle' },
			{ name = 'salat', price = 4, currency = 'money' },
			{ name = 'zwiebel', price = 3, currency = 'money' },
			{ name = 'orange', price = 4, currency = 'money' },
			{ name = 'tomate', price = 3, currency = 'money' },
		}, targets = {
			{ ped = `CS_Old_Man2`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(-1044.1439, 5327.8042, 43.5729), heading = 34.5952},
			{ ped = `CS_Old_Man2`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(2529.0789, 2037.7456, 18.8392), heading = 276.2651},
			{ ped = `CS_Old_Man2`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(-2510.8252, 3611.2319, 12.7502), heading = 233.5381},
			{ ped = `CS_Old_Man2`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(1789.913, 4589.738, 36.683), heading = 196.567},
			{ ped = `CS_Old_Man2`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(1266.762, 3549.688, 34.217), heading = 229.886},
			{ ped = `CS_Old_Man2`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(1477.270, 2723.627, 36.567), heading = 32.135},
		}
	},
	Muellabgabe = {
		name = 'Müllabgabe',
		blip = {
			id = 642, colour = 3, scale = 0.5
		}, inventory = {
			{ name = 'money', price = 1, currency = 'garbage' },
		}, targets = {
			{ ped = `CS_Old_Man2`, scenario = 'WORLD_HUMAN_CLIPBOARD', loc = vec3(-349.618, -1568.667, 24.227), heading = 335.995},
		}
	},
}