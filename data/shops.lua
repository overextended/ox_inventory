return {

	PoliceArmoury = {
		name = 'Police Armoury',
		groups = shared.police,
		blip = {
			--id = 110, colour = 84, scale = 0.8
		}, inventory = {
			{ name = 'ammo-9', price = 0, metadata = { description = "Police Property" }, },
			{ name = 'ammo-rifle', price = 0, metadata = { description = "Police Property" }, },
			{ name = 'ammo-45', price = 0, metadata = { description = "Police Property" }, },
			{ name = 'ammo-shotgun', price = 0, metadata = { description = "Police Property" }, },
			{ name = 'ammo-emp', price = 0, metadata = { description = "Police Property" }, },
			{ name = 'handcuffs', price = 0, metadata = { description = "Police Property" }, },
			{ name = 'gps_tracker', price = 0, metadata = { description = "Police Property" }, },
			{ name = 'camera', price = 0, metadata = { description = "Police Property" }, },
			{ name = 'armour', price = 0, metadata = { description = "Police Property" }, },
			{ name = 'ifaks', price = 0, metadata = { description = "Police Property" }, },
			{ name = 'briefcase', price = 0, metadata = { description = "Police Property" }, },
			{ name = 'pdcamera', price = 0, metadata = { description = "Police Property" }, },
			{ name = 'WEAPON_PISTOL', price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight', 'at_scope_holo'}, tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL' }},
			{ name = 'WEAPON_COMBATPISTOL', price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight'}, tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL'},  },
			{ name = 'WEAPON_CERAMICPISTOL', price = 0, metadata = { registered = true, description = "Police Property", tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL'},  },
			{ name = 'WEAPON_PISTOLXM3', price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight'}, tint = 22, weapontint = "LSPD Tint",  police_property = true, serial = 'POL'},  },
			{ name = 'WEAPON_REVOLVER_MK2', price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight'}, tint = 22, weapontint = "Bold LSPD Tint", police_property = true, serial = 'POL'},  },
			{ name = 'WEAPON_SNSPISTOL_MK2', price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight'}, tint = 22, weapontint = "Bold LSPD Tint", police_property = true, serial = 'POL'},  },
			{ name = 'WEAPON_STUNGUN', price = 0, metadata = { registered = true, description = "Police Property", tint = 5, weapontint = "LSPD Tint",  police_property = true, serial = 'POL'}, },
			{ name = 'WEAPON_PUMPSHOTGUN', price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight'}, tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL'}, grade = 1, },
			{ name = 'WEAPON_SMG', price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight', 'at_scope_macro'}, tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL'}, grade = 6, },
			{ name = 'WEAPON_CARBINERIFLE', price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight', 'at_scope_medium', 'at_grip'}, tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL'}, grade = 3 },
			{ name = 'WEAPON_MILITARYRIFLE', price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight', 'at_scope_small'}, tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL'}, grade = 5 },
			{ name = 'WEAPON_TACTICALRIFLE', price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight', 'at_scope_small'}, tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL'}, grade = 7 },
			{ name = 'WEAPON_NIGHTSTICK', price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight'}, tint = 5, weapontint = "LSPD Tint", police_property = true } },
			{ name = 'WEAPON_EMPLAUNCHER', price = 0, metadata = { description = "Police Property", serial = 'POL' } },
			{ name = 'WEAPON_PROLASER4', price = 0, metadata = { description = "Police Property", serial = 'POL' } },
			{ name = 'WEAPON_FLASHLIGHT', price = 0, metadata = { description = "Police Property", serial = 'POL' } },
			{ name = 'empty_evidence_bag', price = 0, metadata = { description = "Police Property" } },
		}, locations = {
			vec3(461.34, -982.75, 30.69),
			vec3(456.62, -982.75, 30.69),
			vec3(458.23, -978.38, 30.69),
			vec3(460.01, -978.33, 30.69),
			vec3(462.05, -979.1, 30.69),
			vec3(462.05, -981.88, 30.69),
		}, targets = {
			{ loc = vec3(456.76, -983.18, 30.25), length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 },
			{ loc = vec3(461.73, -983.12, 30.24), length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 },
			{ loc = vec3(462.36, -979.06, 30.16), length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 },
			{ loc = vec3(460.0, -977.94, 30.15), length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 },
			{ loc = vec3(458.04, -978.01, 30.15), length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 },
			{ loc = vec3(462.05, -981.88, 30.69), length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 },
		}
	},

	Ammunation = {
		name = 'Ammunation',
		blip = {
			id = 110, colour = 0, scale = 0.6
		}, inventory = {
			{ name = 'WEAPON_KNIFE', price = 300 },
			{ name = 'WEAPON_BAT', price = 300 },
			{ name = 'ammo-9', price = 30 },
			{ name = 'WEAPON_PISTOL', price = 15000, metadata = { registered = true }, license = 'weaponlicense' },
		}, locations = {
			vec3(816.84, -2156.22, 29.77),
			vec3(1693.44, 3760.16, 34.71),
			vec3(-330.24, 6083.88, 31.45),
			vec3(252.63, -50.00, 69.94),
			vec3(22.56, -1109.89, 29.80),
			vec3(2567.69, 294.38, 108.73),
			vec3(-1117.58, 2698.61, 18.55),
			vec3(842.44, -1033.42, 28.19)
		}, targets = {
			{ loc = vec3(816.84, -2156.22, 29.77), length = 0.6, width = 0.5, heading = 270.62, minZ = 29.6, maxZ = 30.0, distance = 0.71 },
			{ loc = vec3(1693.57, 3761.60, 34.82), length = 0.6, width = 0.5, heading = 227.39, minZ = 34.7, maxZ = 35.1, distance = 2.0 },
			{ loc = vec3(-330.29, 6085.54, 31.57), length = 0.6, width = 0.5, heading = 225.0, minZ = 31.4, maxZ = 31.8, distance = 2.0 },
			{ loc = vec3(252.85, -51.62, 70.0), length = 0.6, width = 0.5, heading = 70.0, minZ = 69.9, maxZ = 70.3, distance = 2.0 },
			{ loc = vec3(15.46, -1105.62, 29.97), length = 0.6, width = 0.5, heading = 70.53, minZ = 29.8, maxZ = 30.2, distance = 0.81 },
			{ loc = vec3(2566.59, 293.13, 108.85), length = 0.6, width = 0.5, heading = 360.0, minZ = 108.7, maxZ = 109.1, distance = 2.0 },
			{ loc = vec3(-1117.61, 2700.26, 18.67), length = 0.6, width = 0.5, heading = 221.82, minZ = 18.5, maxZ = 18.9, distance = 2.0 },
			{ loc = vec3(841.05, -1034.76, 28.31), length = 0.6, width = 0.5, heading = 360.0, minZ = 28.2, maxZ = 28.6, distance = 2.0 }
		}
	},

	Medicine = {
		name = 'Medicine Cabinet',
		groups = {
			['ambulance'] = 0
		},
		blip = {
			id = 403, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'bandage',    label = 'Bandage', 		price = 0, metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'prescription_pad',    label = 'Prescription Pad', price = 0, metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'medbag',     label = 'Medical Bag',   price = 0, metadata = { description = "Property of Los Santos Medical Center" } }, -- Pretty self explanatory, price may be set to 'false' to make free
			{ name = 'medikit',    label = 'First-Aid Kit', price = 0, metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'morphine10', label = 'Morphine 10MG', price = 0, metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'tylenol',    label = 'Tylenol', 		price = 0, metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'peptobismol', label = 'Peptobismol',  price = 0, metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'loperamide', label = 'Loperamide',  	price = 0, metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'aspirin',    label = 'Aspirin',   	price = 0, metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'ibuprofen',  label = 'Ibuprofen',  	price = 0, metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'dramamine',  label = 'Dramamine',  	price = 0, metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'covidvaccine', label = 'Covid Vaccine', price = 0, metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'needle', label = 'Needle', price = 0, metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'painkillers', label = 'Pain Killers', price = 0, metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'radio', price = 0, metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'WEAPON_STUNGUN', price = 0, metadata = { registered = true, description = "Property of Los Santos Medical Center", tint = 3, weapontint = "EMS Tint", serial = 'EMS' } },
			{ name = 'WEAPON_FLASHLIGHT', price = 0, metadata = { registered = true, description = "Property of Los Santos Medical Center", serial = 'EMS' } },
			{ name = 'weapon_fireextinguisher', price = 0, metadata = { description = "Property of Los Santos Medical Center" } },
		}, locations = {
			vec3(330.34, -599.69, 42.79)
		}, targets = {
			{ loc = vec3(330.34, -599.69, 42.79), length = 1.5, width = 3.0, heading = 270.0, minZ = 41.5, maxZ = 43.0, distance = 3 }

		}
	},

	BlackMarketArms = {
		name = 'Black Market',
		inventory = {
			{ name = 'WEAPON_DAGGER', price = 5000, metadata = { registered = false	}, currency = 'black_money' },
			{ name = 'WEAPON_CERAMICPISTOL', price = 50000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_APPISTOL', price = 65000, metadata = { registered = false	}, currency = 'black_money' },
			{ name = 'WEAPON_ASSAULTRIFLE', price = 100000, metadata = { registered = false	}, currency = 'black_money' },
			{ name = 'WEAPON_ASSAULTSMG', price = 85000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_BULLPUPSHOTGUN', price = 75000, metadata = { registered = false	}, currency = 'black_money' },
			{ name = 'WEAPON_PISTOLXM3', price = 50000, metadata = { registered = false	}, currency = 'black_money' },
			{ name = 'WEAPON_COMBATPDW', price = 85000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_COMBATPISTOL', price = 50000, metadata = { registered = false	}, currency = 'black_money' },
			{ name = 'WEAPON_COMPACTRIFLE', price = 100000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_DBSHOTGUN', price = 65000, metadata = { registered = false	}, currency = 'black_money' },
			{ name = 'WEAPON_GUSENBERG', price = 85000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_HEAVYRIFLE', price = 100000, metadata = { registered = false	}, currency = 'black_money' },
			{ name = 'WEAPON_HEAVYPISTOL', price = 50000, metadata = { registered = false	}, currency = 'black_money' },
			{ name = 'WEAPON_KNUCKLE', price = 8000, metadata = { registered = false	}, currency = 'black_money' },
			{ name = 'WEAPON_MACHETE', price = 8000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_MICROSMG', price = 85000, metadata = { registered = false	}, currency = 'black_money' },
			{ name = 'WEAPON_MINISMG', price = 85000, metadata = { registered = false	}, currency = 'black_money' },
			{ name = 'WEAPON_MOLOTOV', price = 12000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_PISTOL', price = 50000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_PISTOL50', price = 50000, metadata = { registered = false	}, currency = 'black_money' },
			{ name = 'WEAPON_RAYCARBINE', price = 1000000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_SMG', price = 85000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_SMOKEGRENADE', price = 50000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_STICKYBOMB', price = 40000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_SWITCHBLADE', price = 4000, metadata = { registered = false	}, currency = 'black_money' },
			{ name = 'WEAPON_VINTAGEPISTOL', price = 50000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_TACTICALRIFLE', price = 100000, metadata = { registered = false	}, currency = 'black_money' },
			{ name = 'keya', price = 4000, currency = 'black_money' },
			{ name = 'moneywash_key', price = 6000, currency = 'black_money' },
			{ name = 'at_flashlight', price = 2000, currency = 'black_money' },
			{ name = 'at_suppressor_light', price = 5000, currency = 'black_money' },
			{ name = 'at_suppressor_heavy', price = 5000, currency = 'black_money' },
			{ name = 'at_grip', price = 5000, currency = 'black_money' },
			{ name = 'at_barrel', price = 5000, currency = 'black_money' },
			{ name = 'at_clip_extended_pistol', price = 5000, currency = 'black_money' },
			{ name = 'at_clip_extended_smg', price = 5000, currency = 'black_money' },
			{ name = 'at_clip_extended_shotgun', price = 5000, currency = 'black_money' },
			{ name = 'at_clip_extended_rifle', price = 5000, currency = 'black_money' },
			{ name = 'at_clip_extended_mg', price = 5000, currency = 'black_money' },
			{ name = 'at_clip_extended_sniper', price = 5000, currency = 'black_money' },
			{ name = 'at_clip_drum_smg', price = 5000, currency = 'black_money' },
			{ name = 'at_clip_drum_shotgun', price = 5000, currency = 'black_money' },
			{ name = 'at_clip_drum_rifle', price = 5000, currency = 'black_money' },
			{ name = 'at_compensator', price = 5000, currency = 'black_money' },
			{ name = 'at_scope_macro', price = 5000, currency = 'black_money' },
			{ name = 'at_scope_small', price = 5000, currency = 'black_money' },
			{ name = 'at_scope_medium', price = 5000, currency = 'black_money' },
			{ name = 'at_scope_large', price = 5000, currency = 'black_money' },
			{ name = 'at_scope_advanced', price = 5000, currency = 'black_money' },
			{ name = 'at_scope_nv', price = 5000, currency = 'black_money' },
			{ name = 'at_scope_thermal', price = 5000, currency = 'black_money' },
			{ name = 'at_scope_holo', price = 5000, currency = 'black_money' },
			{ name = 'at_muzzle_flat', price = 5000, currency = 'black_money' },
			{ name = 'at_muzzle_tactical', price = 5000, currency = 'black_money' },
			{ name = 'at_muzzle_fat', price = 5000, currency = 'black_money' },
			{ name = 'at_muzzle_precision', price = 5000, currency = 'black_money' },
			{ name = 'at_muzzle_heavy', price = 5000, currency = 'black_money' },
			{ name = 'at_muzzle_slanted', price = 5000, currency = 'black_money' },
			{ name = 'at_muzzle_split', price = 5000, currency = 'black_money' },
			{ name = 'at_muzzle_squared', price = 5000, currency = 'black_money' },
			{ name = 'at_muzzle_bell', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_luxe', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_wood', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_metal', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_pearl', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_ballas', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_diamond', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_dollar', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_hate', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_king', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_love', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_pimp', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_player', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_vagos', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_blagueurs', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_splatter', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_bulletholes', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_burgershot', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_cluckinbell', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_fatalincursion', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_luchalibre', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_trippy', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_tiedye', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_wall', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_vip', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_bodyguard', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_festive', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_security', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_camo', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_brushstroke', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_woodland', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_skull', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_sessanta', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_perseus', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_leopard', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_zebra', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_geometric', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_boom', price = 5000, currency = 'black_money' },
			{ name = 'at_skin_patriotic', price = 5000, currency = 'black_money' },
			{ name = 'ammo-rifle', price = 25, currency = 'black_money' },
			{ name = 'ammo-rifle2', price = 25, currency = 'black_money' },
			{ name = 'ammo-22', price = 15, currency = 'black_money' },
			{ name = 'ammo-38', price = 15, currency = 'black_money' },
			{ name = 'ammo-44', price = 15, currency = 'black_money' },
			{ name = 'ammo-45', price = 15, currency = 'black_money' },
			{ name = 'ammo-50', price = 15, currency = 'black_money' },
			{ name = 'ammo-9', price = 15, currency = 'black_money' },
			{ name = 'ammo-shotgun', price = 50, currency = 'black_money' },
			{ name = 'trojan_usb', price = 2000, currency = 'black_money' }
		}, locations = {
			vec3(504.7122, 2603.0120, 43.9762),
			vec3(143.1517, -1965.5575, 18.8556),
			vec3(1012.2678, -3248.0315, -17.7455)
		}, targets = {
			{ loc = vec3(504.7122, 2603.0120, 43.9762), length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 },
			{ loc = vec3(1012.2678, -3248.0315, -17.7455), length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 }
		}
	},

	BlackMarketTwo = {
		name = 'Black Market',
		inventory = {
			{ name = 'houselaptop', price = 800, currency = 'black_money' },
			{ name = 'mansionlaptop', price = 1200, currency = 'black_money' },
			{ name = 'armour', price = 1200, currency = 'black_money' }
		}, locations = {
			vec3(-491.66, -1030.0, 52.48)
		}, targets = {
			{ loc = vec3(-491.66, -1030.0, 52.48), length = 0.6, width = 0.5, heading = 3.02, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	VendingMachineDrinks = {
		name = 'Vending Machine',
		inventory = {
			{ name = 'water', price = 10 },
			{ name = 'cola', price = 10 },
			{ name = 'sprunk', price = 10 },
		},
		model = {
			`prop_vend_soda_02`, `prop_vend_fridge01`, `prop_vend_water_01`, `prop_vend_soda_01`
		}
	}
}
