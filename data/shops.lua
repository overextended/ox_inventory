return {

	PoliceArmoury = {
		name = 'Police Armoury',
		groups = shared.police,
		blip = {
			--id = 110, colour = 84, scale = 0.8
		},
		inventory = {
			{ name = 'ammo-9',               price = 0, metadata = { description = "Police Property" }, },
			{ name = 'ammo-rifle',           price = 0, metadata = { description = "Police Property" }, },
			{ name = 'ammo-45',              price = 0, metadata = { description = "Police Property" }, },
			{ name = 'ammo-shotgun',         price = 0, metadata = { description = "Police Property" }, },
			{ name = 'ammo-emp',             price = 0, metadata = { description = "Police Property" }, },
			{ name = 'handcuffs',            price = 0, metadata = { description = "Police Property" }, },
			{ name = 'cuffkeys',             price = 0, metadata = { description = "Police Property" }, },
			{ name = 'alcoholtester',        price = 0, metadata = { description = "Police Property" }, },
			{ name = 'rag',                  price = 0, metadata = { description = "Police Property" }, },
			{ name = 'leo-gps',              price = 0, metadata = { description = "Police Property" }, },
			{ name = 'armour',               price = 0, metadata = { description = "Police Property" }, },
			{ name = 'ifaks',                price = 0, metadata = { description = "Police Property" }, },
			{ name = 'radio',                price = 0, metadata = { description = "Police Property" }, },
			{ name = 'briefcase',            price = 0, metadata = { description = "Police Property" }, },
			{ name = 'pdcamera',             price = 0, metadata = { description = "Police Property" }, },
			{ name = 'empty_evidence_bag',   price = 0, metadata = { description = "Police Property" } },
			{ name = 'evidencecleaningkit',  price = 0, metadata = { description = "Police Property" } },
			{ name = 'WEAPON_PISTOL',        price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight', 'at_scope_holo' }, tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL' } },
			{ name = 'WEAPON_COMBATPISTOL',  price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight' }, tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL' }, },
			{ name = 'WEAPON_CERAMICPISTOL', price = 0, metadata = { registered = true, description = "Police Property", tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL' }, },
			{ name = 'WEAPON_PISTOLXM3',     price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight' }, tint = 22, weapontint = "LSPD Tint", police_property = true, serial = 'POL' }, },
			{ name = 'WEAPON_REVOLVER_MK2',  price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight' }, tint = 22, weapontint = "Bold LSPD Tint", police_property = true, serial = 'POL' }, },
			{ name = 'WEAPON_SNSPISTOL_MK2', price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight' }, tint = 22, weapontint = "Bold LSPD Tint", police_property = true, serial = 'POL' }, },
			{ name = 'WEAPON_STUNGUN',       price = 0, metadata = { registered = true, description = "Police Property", tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL' }, },
			{ name = 'WEAPON_PUMPSHOTGUN',   price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight' }, tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL' },                               grade = 1, },
			{ name = 'WEAPON_SMG',           price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight', 'at_scope_macro' }, tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL' },             grade = 6, },
			{ name = 'WEAPON_CARBINERIFLE',  price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight', 'at_scope_medium', 'at_grip' }, tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL' }, grade = 3 },
			{ name = 'WEAPON_MILITARYRIFLE', price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight', 'at_scope_small' }, tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL' },             grade = 5 },
			{ name = 'WEAPON_TACTICALRIFLE', price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight', 'at_scope_small' }, tint = 5, weapontint = "LSPD Tint", police_property = true, serial = 'POL' },             grade = 7 },
			{ name = 'WEAPON_NIGHTSTICK',    price = 0, metadata = { registered = true, description = "Police Property", components = { 'at_flashlight' }, tint = 5, weapontint = "LSPD Tint", police_property = true } },
			{ name = 'WEAPON_EMPLAUNCHER',   price = 0, metadata = { description = "Police Property", serial = 'POL' } },
			{ name = 'WEAPON_PROLASER4',     price = 0, metadata = { description = "Police Property", serial = 'POL' } },
			{ name = 'WEAPON_FLASHLIGHT',    price = 0, metadata = { description = "Police Property", serial = 'POL' } },
		},
		locations = {
			vec3(461.34, -982.75, 30.69),
			vec3(456.62, -982.75, 30.69),
			vec3(458.23, -978.38, 30.69),
			vec3(460.01, -978.33, 30.69),
			vec3(462.05, -979.01, 30.69),
			vec3(462.05, -981.88, 30.69),
			vec3(1840.92, 3691.63, 34.25),
			vec3(-437.77, 5988.26, 31.71),
		},
		targets = {
			{ loc = vec3(456.76, -983.18, 30.25),  length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 },
			{ loc = vec3(461.73, -983.12, 30.24),  length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 },
			{ loc = vec3(462.36, -979.06, 30.16),  length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 },
			{ loc = vec3(460.01, -977.94, 30.15),  length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 },
			{ loc = vec3(458.04, -978.01, 30.15),  length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 },
			{ loc = vec3(462.05, -981.88, 30.69),  length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 },
			{ loc = vec3(1840.92, 3691.63, 34.25), length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 },
			{ loc = vec3(-437.77, 5988.26, 31.71), length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 },
		}
	},

	Ammunation = {
		name = 'Ammunation',
		blip = {
			id = 110, colour = 0, scale = 0.6
		},
		inventory = {
			{ name = 'WEAPON_KNIFE',  price = 300 },
			{ name = 'WEAPON_BAT',    price = 300 },
			{ name = 'ammo-9',        price = 30 },
			{ name = 'WEAPON_PISTOL', price = 15000, metadata = { registered = true }, license = 'weapon' },
		},
		locations = {
			vec3(816.84, -2156.22, 29.77),
			vec3(1693.44, 3760.16, 34.71),
			vec3(-330.24, 6083.88, 31.45),
			vec3(252.63, -50.00, 69.94),
			vec3(22.56, -1109.89, 29.80),
			vec3(2567.69, 294.38, 108.73),
			vec3(-1117.58, 2698.61, 18.55),
			vec3(842.44, -1033.42, 28.19)
		},
		targets = {
			{ ped = `s_m_y_ammucity_01`, scenario = 'WORLD_HUMAN_COP_IDLES', distance = 5.0, loc = vec3(817.5814, -2157.4331, 28.5905),  heading = 82.1826 },
			{ ped = `s_m_y_ammucity_01`, scenario = 'WORLD_HUMAN_COP_IDLES', distance = 5.0, loc = vec3(1692.1895, 3760.8982, 33.7053),  heading = 223.9017 },
			{ ped = `s_m_y_ammucity_01`, scenario = 'WORLD_HUMAN_COP_IDLES', distance = 5.0, loc = vec3(-331.5031, 6085.0454, 30.4548),  heading = 216.0496 },
			{ ped = `s_m_y_ammucity_01`, scenario = 'WORLD_HUMAN_COP_IDLES', distance = 5.0, loc = vec3(253.8864, -50.2578, 68.9411),    heading = 66.4031 },
			{ ped = `s_m_y_ammucity_01`, scenario = 'WORLD_HUMAN_COP_IDLES', distance = 5.0, loc = vec3(15.2496, -1104.2432, 28.7897),   heading = 247.0457 },
			{ ped = `s_m_y_ammucity_01`, scenario = 'WORLD_HUMAN_COP_IDLES', distance = 5.0, loc = vec3(2567.6060, 292.6360, 107.7348),  heading = 352.9428 },
			{ ped = `s_m_y_ammucity_01`, scenario = 'WORLD_HUMAN_COP_IDLES', distance = 5.0, loc = vec3(-1118.5908, 2700.0757, 17.5541), heading = 216.9921 },
			{ ped = `s_m_y_ammucity_01`, scenario = 'WORLD_HUMAN_COP_IDLES', distance = 5.0, loc = vec3(841.9879, -1035.2577, 27.1948),  heading = 350.8371 }
		}
	},

	Ammunation2 = {
		name = 'Ammunation',
		inventory = {
			{ name = 'WEAPON_KNIFE',   price = 600 },
			{ name = 'WEAPON_BAT',     price = 300 },
			{ name = 'weapon_hatchet', price = 250 },
		},
		targets = {
			{
				ped = `s_m_y_ammucity_01`,
				scenario = 'WORLD_HUMAN_COP_IDLES',
				loc = vec3(-544.9167, -584.1287, 33.6818),
				heading = 266.2583,
			}
		}
	},

	GeneralStore = {
		name = 'General Store',
		inventory = {
			{ name = 'flour',                price = 10,  currency = 'money' },
			{ name = 'bcoffeebeans',         price = 10,  currency = 'money' },
			{ name = 'bcream',               price = 10,  currency = 'money' },
			{ name = 'bstrawberry',          price = 10,  currency = 'money' },
			{ name = 'bhotchocolatepowder',  price = 10,  currency = 'money' },
			{ name = 'extrato-baunilha',     price = 10,  currency = 'money' },
			{ name = 'bhoney',               price = 10,  currency = 'money' },
			{ name = 'bice',                 price = 10,  currency = 'money' },
			{ name = 'bcaramelsyrup',        price = 10,  currency = 'money' },
			{ name = 'tortillas',            price = 10,  currency = 'money' },
			{ name = 'taco-tomato',          price = 10,  currency = 'money' },
			{ name = 'lettuce',              price = 10,  currency = 'money' },
			{ name = 'barra-manteiga',       price = 10,  currency = 'money' },
			{ name = 'tortilla-chips',       price = 10,  currency = 'money' },
			{ name = 'cheddar-cheese',       price = 10,  currency = 'money' },
			{ name = 'caixa-amoras',         price = 10,  currency = 'money' },
			{ name = 'chocolate',            price = 10,  currency = 'money' },
			{ name = 'carbonated-water',     price = 10,  currency = 'money' },
			{ name = 'sugar-cubes',          price = 10,  currency = 'money' },
			{ name = 'pacote-acucar',        price = 10,  currency = 'money' },
			{ name = 'pacote-oreo',          price = 10,  currency = 'money' },
			{ name = 'extrato-menta',        price = 10,  currency = 'money' },
			{ name = 'frasco-nutela',        price = 10,  currency = 'money' },
			{ name = 'burger-potato',        price = 10,  currency = 'money' },
			{ name = 'burger-mshakeformula', price = 10,  currency = 'money' },
			{ name = 'burger-sodasyrup',     price = 10,  currency = 'money' },
			{ name = 'bhighcoffeeglasscup',  price = 10,  currency = 'money' },
			{ name = 'bcoffeeglass',         price = 10,  currency = 'money' },
			{ name = 'bespressocoffeecup',   price = 10,  currency = 'money' },
			{ name = 'orange',               price = 10,  currency = 'money' },
			{ name = 'banana',               price = 10,  currency = 'money' },
			{ name = 'apple',                price = 10,  currency = 'money' },
			{ name = 'limao',                price = 10,  currency = 'money' },
			{ name = 'burger-bun',           price = 10,  currency = 'money' },
			{ name = 'water',                price = 10,  currency = 'money' },
			{ name = 'mustard',              price = 10,  currency = 'money' },
			{ name = 'ketchup',              price = 10,  currency = 'money' },
			{ name = 'raw_meat',             price = 20,  currency = 'money' },
			{ name = 'burger-raw',           price = 20,  currency = 'money' },
			{ name = 'ground-beef',          price = 20,  currency = 'money' },
			{ name = 'chicken',              price = 20,  currency = 'money' },
			{ name = 'milk',                 price = 10,  currency = 'money' },
			{ name = 'sandwich',             price = 10,  currency = 'money' },
			{ name = 'bandage',              price = 25,  currency = 'money' },
			{ name = 'lighter',              price = 2,   currency = 'money' },
			{ name = 'rolling_paper',        price = 2,   currency = 'money' },
			{ name = 'soda',                 price = 10,  currency = 'money' },
			{ name = 'sprunk',               price = 10,  currency = 'money' },
			{ name = 'cigbox',               price = 100, currency = 'money' },
			{ name = 'egobar',               price = 10,  currency = 'money' },
			{ name = 'crisps',               price = 10,  currency = 'money' },
			{ name = 'bakingsoda',           price = 7,   currency = 'money' },
			{ name = 'beer',                 price = 7,   currency = 'money' },
			{ name = 'whiskey',              price = 10,  currency = 'money' },
			{ name = 'vodka',                price = 12,  currency = 'money' },
		},
		targets = {
			{
				ped = `mp_m_shopkeep_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-548.9540, -582.9260, 33.6818),
				heading = 181.4278,
			}
		}
	},

	GeneralStore2 = {
		name = 'General Store',
		blip = {
			id = 52, colour = 0, scale = 0.6
		},
		inventory = {
			{ name = 'water',         price = 10 },
			{ name = 'sandwich',      price = 10 },
			{ name = 'bandage',       price = 25 },
			{ name = 'lighter',       price = 2 },
			{ name = 'rolling_paper', price = 2 },
			{ name = 'soda',          price = 10 },
			{ name = 'sprunk',        price = 10 },
			{ name = 'cigbox',        price = 100 },
			{ name = 'egobar',        price = 10 },
			{ name = 'crisps',        price = 10 },
			{ name = 'bakingsoda',    price = 7 },
			{ name = 'beer',          price = 7 },
			{ name = 'whiskey',       price = 10 },
			{ name = 'vodka',         price = 12 },
		},
		locations = {
			vec3(24.47, -1346.62, 29.5),
			vec3(-3039.54, 584.38, 7.91),
			vec3(-3242.97, 1000.01, 12.83),
			vec3(1728.07, 6415.63, 35.04),
			vec3(1959.82, 3740.48, 32.34),
			vec3(549.13, 2670.85, 42.16),
			vec3(2677.47, 3279.76, 55.24),
			vec3(2556.66, 380.84, 108.62),
			vec3(372.66, 326.98, 103.57),
		},
		targets = {
			{ loc = vec3(24.47, -1346.62, 29.5),    length = 1.5, width = 3.0, heading = 271.66, minZ = 41.5, maxZ = 43.0, distance = 3 },
			{ loc = vec3(-3039.54, 584.38, 7.91),   length = 1.5, width = 3.0, heading = 17.27,  minZ = 41.5, maxZ = 43.0, distance = 3 },
			{ loc = vec3(-3242.97, 1000.01, 12.83), length = 1.5, width = 3.0, heading = 357.57, minZ = 41.5, maxZ = 43.0, distance = 3 },
			{ loc = vec3(1728.07, 6415.63, 35.04),  length = 1.5, width = 3.0, heading = 242.95, minZ = 41.5, maxZ = 43.0, distance = 3 },
			{ loc = vec3(1959.82, 3740.48, 32.34),  length = 1.5, width = 3.0, heading = 301.57, minZ = 41.5, maxZ = 43.0, distance = 3 },
			{ loc = vec3(549.13, 2670.85, 42.16),   length = 1.5, width = 3.0, heading = 99.39,  minZ = 41.5, maxZ = 43.0, distance = 3 },
			{ loc = vec3(2677.47, 3279.76, 55.24),  length = 1.5, width = 3.0, heading = 335.08, minZ = 41.5, maxZ = 43.0, distance = 3 },
			{ loc = vec3(2556.66, 380.84, 108.62),  length = 1.5, width = 3.0, heading = 356.67, minZ = 41.5, maxZ = 43.0, distance = 3 },
			{ loc = vec3(372.66, 326.98, 103.57),   length = 1.5, width = 3.0, heading = 253.73, minZ = 41.5, maxZ = 43.0, distance = 3 }
		}
	},

	LTDGas = {
		name = 'LTD Store',
		inventory = {
			{ name = 'water',         price = 10 },
			{ name = 'sandwich',      price = 10 },
			{ name = 'bandage',       price = 25 },
			{ name = 'lighter',       price = 2 },
			{ name = 'rolling_paper', price = 2 },
			{ name = 'soda',          price = 10 },
			{ name = 'sprunk',        price = 10 },
			{ name = 'cigbox',        price = 100 },
			{ name = 'egobar',        price = 10 },
			{ name = 'crisps',        price = 10 },
			{ name = 'bakingsoda',    price = 7 },
			{ name = 'beer',          price = 7 },
			{ name = 'whiskey',       price = 10 },
			{ name = 'vodka',         price = 12 },
		},
		locations = {
			vec3(-47.02, -1758.23, 28.42),
			vec3(-706.06, -913.97, 19.22),
			vec3(-1820.02, 794.03, 138.09),
			vec3(1164.71, -322.94, 69.21),
			vec3(1697.87, 4922.96, 42.06),
		},
		targets = {
			{ loc = vec3(-47.02, -1758.23, 28.42),  length = 1.5, width = 3.0, heading = 45.05,  minZ = 41.5, maxZ = 43.0, distance = 3 },
			{ loc = vec3(-706.06, -913.97, 19.22),  length = 1.5, width = 3.0, heading = 88.04,  minZ = 41.5, maxZ = 43.0, distance = 3 },
			{ loc = vec3(-1820.02, 794.03, 138.09), length = 1.5, width = 3.0, heading = 135.45, minZ = 41.5, maxZ = 43.0, distance = 3 },
			{ loc = vec3(1164.71, -322.94, 69.21),  length = 1.5, width = 3.0, heading = 101.72, minZ = 41.5, maxZ = 43.0, distance = 3 },
			{ loc = vec3(1697.87, 4922.96, 42.06),  length = 1.5, width = 3.0, heading = 324.71, minZ = 41.5, maxZ = 43.0, distance = 3 }
		}
	},

	Medicine = {
		name = 'Medicine Cabinet',
		groups = {
			['ambulance'] = 0
		},
		blip = {
			id = 403, colour = 69, scale = 0.8
		},
		inventory = {
			{ name = 'bandage',                 label = 'Bandage',          price = 0,                                                                                                                                 metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'prescription_pad',        label = 'Prescription Pad', price = 0,                                                                                                                                 metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'medbag',                  label = 'Medical Bag',      price = 0,                                                                                                                                 metadata = { description = "Property of Los Santos Medical Center" } }, -- Pretty self explanatory, price may be set to 'false' to make free
			{ name = 'medikit',                 label = 'First-Aid Kit',    price = 0,                                                                                                                                 metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'morphine10',              label = 'Morphine 10MG',    price = 0,                                                                                                                                 metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'tylenol',                 label = 'Tylenol',          price = 0,                                                                                                                                 metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'peptobismol',             label = 'Peptobismol',      price = 0,                                                                                                                                 metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'loperamide',              label = 'Loperamide',       price = 0,                                                                                                                                 metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'aspirin',                 label = 'Aspirin',          price = 0,                                                                                                                                 metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'ibuprofen',               label = 'Ibuprofen',        price = 0,                                                                                                                                 metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'dramamine',               label = 'Dramamine',        price = 0,                                                                                                                                 metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'covidvaccine',            label = 'Covid Vaccine',    price = 0,                                                                                                                                 metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'needle',                  label = 'Needle',           price = 0,                                                                                                                                 metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'painkillers',             label = 'Pain Killers',     price = 0,                                                                                                                                 metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'radio',                   price = 0,                  metadata = { description = "Property of Los Santos Medical Center" } },
			{ name = 'WEAPON_STUNGUN',          price = 0,                  metadata = { registered = true, description = "Property of Los Santos Medical Center", tint = 3, weapontint = "EMS Tint", serial = 'EMS' } },
			{ name = 'WEAPON_FLASHLIGHT',       price = 0,                  metadata = { registered = true, description = "Property of Los Santos Medical Center", serial = 'EMS' } },
			{ name = 'weapon_fireextinguisher', price = 0,                  metadata = { description = "Property of Los Santos Medical Center" } },
		},
		locations = {
			vec3(330.34, -599.69, 42.79)
		},
		targets = {
			{ loc = vec3(330.34, -599.69, 42.79), length = 1.5, width = 3.0, heading = 270.0, minZ = 41.5, maxZ = 43.0, distance = 3 }

		}
	},

	MechanicShop = {
		name = 'Mechanic Shop',
		groups = {
			['mechanic'] = 0
		},
		inventory = {
			{ name = 'engine_oil',           label = 'Engine Oil',           price = 0 },
			{ name = 'tyre_replacement',     label = 'Tyre Replacement',     price = 0 },
			{ name = 'clutch_replacement',   label = 'Clutch Replacement',   price = 0 },
			{ name = 'air_filter',           label = 'Air Filter',           price = 0 },
			{ name = 'spark_plug',           label = 'Spark Plug',           price = 0 },
			{ name = 'brakepad_replacement', label = 'Brakepad Replacement', price = 0 },
			{ name = 'suspension_parts',     label = 'Suspension Parts',     price = 0 },
			{ name = 'i4_engine',            label = 'I4 Engine',            price = 0 },
			{ name = 'v6_engine',            label = 'V6 Engine',            price = 0 },
			{ name = 'v8_engine',            label = 'V8 Engine',            price = 0 },
			{ name = 'v12_engine',           label = 'V12 Engine',           price = 0 },
			{ name = 'turbocharger',         label = 'Turbocharger',         price = 0 },
			{ name = 'ev_motor',             label = 'EV Motor',             price = 0 },
			{ name = 'ev_battery',           label = 'EV Battery',           price = 0 },
			{ name = 'ev_coolant',           label = 'EV Coolant',           price = 0 },
			{ name = 'awd_drivetrain',       label = 'AWD Drivetrain',       price = 0 },
			{ name = 'rwd_drivetrain',       label = 'RWD Drivetrain',       price = 0 },
			{ name = 'fwd_drivetrain',       label = 'FWD Drivetrain',       price = 0 },
			{ name = 'slick_tyres',          label = 'Slick Tyres',          price = 0 },
			{ name = 'semi_slick_tyres',     label = 'Semi Slick Tyres',     price = 0 },
			{ name = 'offroad_tyres',        label = 'Offroad Tyres',        price = 0 },
			{ name = 'drift_tuning_kit',     label = 'Drift Tuning Kit',     price = 0 },
			{ name = 'lighting_controller',  label = 'Lighting Controller',  price = 0 },
			{ name = 'stancing_kit',         label = 'Stancer Kit',          price = 0 },
			{ name = 'cosmetic_part',        label = 'Cosmetic Parts',       price = 0 },
			{ name = 'respray_kit',          label = 'Respray Kit',          price = 0 },
			{ name = 'vehicle_wheels',       label = 'Vehicle Wheels Set',   price = 0 },
			{ name = 'tyre_smoke_kit',       label = 'Tyre Smoke Kit',       price = 0 },
			{ name = 'bulletproof_tyres',    label = 'Bulletproof Tyres',    price = 0 },
			{ name = 'extras_kit',           label = 'Extras Kit',           price = 0 },
			{ name = 'nitrous_bottle',       label = 'Nitrous Bottle',       price = 0 },
			{ name = 'empty_nitrous_bottle', label = 'Empty Nitrous Bottle', price = 0 },
			{ name = 'nitrous_install_kit',  label = 'Nitrous Install Kit',  price = 0 },
			{ name = 'cleaning_kit',         label = 'Cleaning Kit',         price = 0 },
			{ name = 'repair_kit',           label = 'Repair Kit',           price = 0 },
			{ name = 'duct_tape',            label = 'Duct Tape',            price = 0 },
			{ name = 'performance_part',     label = 'Performance Parts',    price = 0 },
			{ name = 'mechanic_tablet',      label = 'Mechanic Tablet',      price = 0 },

		},
		locations = {
			vec3(-319.3883, -131.5472, 38.9818),
			vec3(124.1108, -3047.4905, 7.0405),
		},
		targets = {
			{ loc = vec3(-319.3883, -131.5472, 38.9818), length = 1.5, width = 3.0, heading = 117.3, minZ = 41.5, maxZ = 43.0, distance = 3 },
			{ loc = vec3(124.1108, -3047.4905, 7.0405),  length = 1.5, width = 3.0, heading = 93.81, minZ = 41.5, maxZ = 43.0, distance = 3 },
		}
	},

	BlackMarketArms = {
		name = 'Black Market',
		inventory = {
			{ name = 'WEAPON_DAGGER',            price = 5000,    metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_CERAMICPISTOL',     price = 50000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_APPISTOL',          price = 65000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_ASSAULTRIFLE',      price = 100000,  metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_ASSAULTSMG',        price = 85000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_BULLPUPSHOTGUN',    price = 75000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_PISTOLXM3',         price = 50000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_COMBATPDW',         price = 85000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_COMBATPISTOL',      price = 50000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_COMPACTRIFLE',      price = 100000,  metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_DBSHOTGUN',         price = 65000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_GUSENBERG',         price = 85000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_HEAVYRIFLE',        price = 100000,  metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_HEAVYPISTOL',       price = 50000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_KNUCKLE',           price = 8000,    metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_MACHETE',           price = 8000,    metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_MICROSMG',          price = 85000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_MINISMG',           price = 85000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_MOLOTOV',           price = 12000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_PISTOL',            price = 50000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_PISTOL50',          price = 50000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_RAYCARBINE',        price = 1000000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_SMG',               price = 85000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_SMOKEGRENADE',      price = 50000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_STICKYBOMB',        price = 40000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_SWITCHBLADE',       price = 4000,    metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_VINTAGEPISTOL',     price = 50000,   metadata = { registered = false }, currency = 'black_money' },
			{ name = 'WEAPON_TACTICALRIFLE',     price = 100000,  metadata = { registered = false }, currency = 'black_money' },
			{ name = 'rag',                      price = 800,     currency = 'black_money' },
			{ name = 'keya',                     price = 4000,    currency = 'black_money' },
			{ name = 'moneywash_key',            price = 6000,    currency = 'black_money' },
			{ name = 'at_flashlight',            price = 2000,    currency = 'black_money' },
			{ name = 'at_suppressor_light',      price = 5000,    currency = 'black_money' },
			{ name = 'at_suppressor_heavy',      price = 5000,    currency = 'black_money' },
			{ name = 'at_grip',                  price = 5000,    currency = 'black_money' },
			{ name = 'at_barrel',                price = 5000,    currency = 'black_money' },
			{ name = 'at_clip_extended_pistol',  price = 5000,    currency = 'black_money' },
			{ name = 'at_clip_extended_smg',     price = 5000,    currency = 'black_money' },
			{ name = 'at_clip_extended_shotgun', price = 5000,    currency = 'black_money' },
			{ name = 'at_clip_extended_rifle',   price = 5000,    currency = 'black_money' },
			{ name = 'at_clip_extended_mg',      price = 5000,    currency = 'black_money' },
			{ name = 'at_clip_extended_sniper',  price = 5000,    currency = 'black_money' },
			{ name = 'at_clip_drum_smg',         price = 5000,    currency = 'black_money' },
			{ name = 'at_clip_drum_shotgun',     price = 5000,    currency = 'black_money' },
			{ name = 'at_clip_drum_rifle',       price = 5000,    currency = 'black_money' },
			{ name = 'at_compensator',           price = 5000,    currency = 'black_money' },
			{ name = 'at_scope_macro',           price = 5000,    currency = 'black_money' },
			{ name = 'at_scope_small',           price = 5000,    currency = 'black_money' },
			{ name = 'at_scope_medium',          price = 5000,    currency = 'black_money' },
			{ name = 'at_scope_large',           price = 5000,    currency = 'black_money' },
			{ name = 'at_scope_advanced',        price = 5000,    currency = 'black_money' },
			{ name = 'at_scope_nv',              price = 5000,    currency = 'black_money' },
			{ name = 'at_scope_thermal',         price = 5000,    currency = 'black_money' },
			{ name = 'at_scope_holo',            price = 5000,    currency = 'black_money' },
			{ name = 'at_muzzle_flat',           price = 5000,    currency = 'black_money' },
			{ name = 'at_muzzle_tactical',       price = 5000,    currency = 'black_money' },
			{ name = 'at_muzzle_fat',            price = 5000,    currency = 'black_money' },
			{ name = 'at_muzzle_precision',      price = 5000,    currency = 'black_money' },
			{ name = 'at_muzzle_heavy',          price = 5000,    currency = 'black_money' },
			{ name = 'at_muzzle_slanted',        price = 5000,    currency = 'black_money' },
			{ name = 'at_muzzle_split',          price = 5000,    currency = 'black_money' },
			{ name = 'at_muzzle_squared',        price = 5000,    currency = 'black_money' },
			{ name = 'at_muzzle_bell',           price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_luxe',             price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_wood',             price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_metal',            price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_pearl',            price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_ballas',           price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_diamond',          price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_dollar',           price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_hate',             price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_king',             price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_love',             price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_pimp',             price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_player',           price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_vagos',            price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_blagueurs',        price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_splatter',         price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_bulletholes',      price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_burgershot',       price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_cluckinbell',      price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_fatalincursion',   price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_luchalibre',       price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_trippy',           price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_tiedye',           price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_wall',             price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_vip',              price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_bodyguard',        price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_festive',          price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_security',         price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_camo',             price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_brushstroke',      price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_woodland',         price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_skull',            price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_sessanta',         price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_perseus',          price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_leopard',          price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_zebra',            price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_geometric',        price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_boom',             price = 5000,    currency = 'black_money' },
			{ name = 'at_skin_patriotic',        price = 5000,    currency = 'black_money' },
			{ name = 'ammo-rifle',               price = 25,      currency = 'black_money' },
			{ name = 'ammo-rifle2',              price = 25,      currency = 'black_money' },
			{ name = 'ammo-22',                  price = 15,      currency = 'black_money' },
			{ name = 'ammo-38',                  price = 15,      currency = 'black_money' },
			{ name = 'ammo-44',                  price = 15,      currency = 'black_money' },
			{ name = 'ammo-45',                  price = 15,      currency = 'black_money' },
			{ name = 'ammo-50',                  price = 15,      currency = 'black_money' },
			{ name = 'ammo-9',                   price = 15,      currency = 'black_money' },
			{ name = 'ammo-shotgun',             price = 50,      currency = 'black_money' },
			{ name = 'trojan_usb',               price = 2000,    currency = 'black_money' },
		},
		locations = {
			vec3(504.7122, 2603.0120, 43.9762),
			vec3(143.1517, -1965.5575, 18.8556),
			vec3(1012.2678, -3248.0315, -17.7455)
		},
		targets = {
			{ loc = vec3(504.7122, 2603.0120, 43.9762),    length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 },
			{ loc = vec3(1012.2678, -3248.0315, -17.7455), length = 0.5, width = 3.0, heading = 270.0, minZ = 28.5, maxZ = 31.0, distance = 3 }
		}
	},

	BlackMarketTwo = {
		name = 'Black Market',
		inventory = {
			{ name = 'houselaptop',   price = 800,  currency = 'black_money' },
			{ name = 'mansionlaptop', price = 1200, currency = 'black_money' },
			{ name = 'armour',        price = 1200, currency = 'black_money' },
			{ name = 'rag',           price = 800,  currency = 'black_money' },
		},
		locations = {
			vec3(-491.66, -1030.0, 52.48)
		},
		targets = {
			{ loc = vec3(-491.66, -1030.0, 52.48), length = 0.6, width = 0.5, heading = 3.02, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	MetalDetect = {
		name = 'Metal Detect Shop',
		inventory = {
			{ name = 'metaldetector', price = 500, currency = 'money' },
		},
		targets = {
			{
				ped = `a_m_m_mexcntry_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-1114.2350, -1689.48, 3.3753),
				heading = 34.0019,
			}
		}
	},

	CigarShop = {
		name = 'Cigar Shop',
		inventory = {
			{ name = 'rolling_paper', price = 5,   currency = 'money' },
			{ name = 'joint_roller',  price = 200, currency = 'money' },
			{ name = 'lighter',       price = 200, currency = 'money' },
			{ name = 'butane',        price = 200, currency = 'money' },
			{ name = 'weedgrinder',   price = 200, currency = 'money' },
			{ name = 'mdwoods',       price = 20,  currency = 'money' },
			{ name = 'cigar',         price = 20,  currency = 'money' },
		},
		targets = {
			{
				ped = `a_m_m_hasjew_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(1215.2317, -463.2733, 65.4308),
				heading = 161.9085,
			}
		}
	},

	SmokeShop = {
		name = 'Smoke Shop',
		groups = {
			['whitewidow'] = 0
		},
		inventory = {
			{ name = 'rolling_paper',         price = 0, currency = 'money' },
			{ name = 'joint_roller',          price = 0, currency = 'money' },
			{ name = 'lighter',               price = 0, currency = 'money' },
			{ name = 'butane',                price = 0, currency = 'money' },
			{ name = 'weedgrinder',           price = 0, currency = 'money' },
			{ name = 'dabrig',                price = 0, currency = 'money' },
			{ name = 'vape',                  price = 0, currency = 'money' },
			{ name = 'mdwoods',               price = 0, currency = 'money' },
			{ name = 'empty_weed_bag',        price = 0, currency = 'money' },
			{ name = 'weedscissors',          price = 0, currency = 'money' },
			{ name = 'sour_diesel_joint',     price = 0, currency = 'money' },
			{ name = 'strawberry_kush_joint', price = 0, currency = 'money' },
			{ name = 'golden_goat_joint',     price = 0, currency = 'money' },
			{ name = 'female_seed',           price = 0, currency = 'money' },
			{ name = 'weedgrinder',           price = 0, currency = 'money' },
			{ name = 'dabrig',                price = 0, currency = 'money' },
			{ name = 'bong',                  price = 0, currency = 'money' },
			{ name = 'vape',                  price = 0, currency = 'money' },
			{ name = 'mdwoods',               price = 0, currency = 'money' },
			{ name = 'empty_weed_bag',        price = 0, currency = 'money' },
			{ name = 'weedscissors',          price = 0, currency = 'money' },
		},
		locations = {
			vec3(185.17, -242.75, 54.12)
		},
		targets = {
			{ loc = vec3(185.17, -242.75, 54.12), length = 0.6, width = 0.5, heading = 60.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	SmokeShop2 = {
		name = 'Smoke Shop',
		blip = {
			id = 140, colour = 0, scale = 0.6
		},
		inventory = {
			{ name = 'rolling_paper',  price = 5,   currency = 'money' },
			{ name = 'joint_roller',   price = 200, currency = 'money' },
			{ name = 'lighter',        price = 200, currency = 'money' },
			{ name = 'butane',         price = 200, currency = 'money' },
			{ name = 'weedgrinder',    price = 200, currency = 'money' },
			{ name = 'dabrig',         price = 200, currency = 'money' },
			{ name = 'vape',           price = 200, currency = 'money' },
			{ name = 'mdwoods',        price = 20,  currency = 'money' },
			{ name = 'empty_weed_bag', price = 10,  currency = 'money' },
		},
		targets = {
			{
				ped = `a_f_y_hippie_01`,
				scenario = 'WORLD_HUMAN_SMOKING_POT',
				loc = vec3(-1168.1553, -1572.5336, 3.6635),
				heading = 118.1103,
			}
		}
	},

	Bennys = {
		name = 'Bennys Shop',
		inventory = {
			{ name = 'repair_kit',          price = 350,  currency = 'money' },
			{ name = 'driftkit',            price = 4500, currency = 'money' },
			{ name = 'cleaning_kit',        price = 150,  currency = 'money' },
			{ name = 'engine_oil',          price = 400,  currency = 'money' },
			{ name = 'stancing_kit',        price = 2500, currency = 'money' },
			{ name = 'customizableplate',   price = 2000, currency = 'money' },
			{ name = 'nitrous_bottle',      price = 3000, currency = 'money' },
			{ name = 'lighting_controller', price = 2500, currency = 'money' },
		},
		targets = {
			{
				ped = `mp_m_waremech_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(148.0863, -3018.7139, 6.1131),
				heading = 267.2463,
			}
		}
	},

	Bennys2 = {
		name = 'Auto Sunset Shop',
		inventory = {
			{ name = 'repair_kit',          price = 350,  currency = 'money' },
			{ name = 'driftkit',            price = 4500, currency = 'money' },
			{ name = 'cleaning_kit',        price = 150,  currency = 'money' },
			{ name = 'engine_oil',          price = 400,  currency = 'money' },
			{ name = 'stancing_kit',        price = 2500, currency = 'money' },
			{ name = 'customizableplate',   price = 2000, currency = 'money' },
			{ name = 'nitrous_bottle',      price = 3000, currency = 'money' },
			{ name = 'lighting_controller', price = 2500, currency = 'money' },
		},
		targets = {
			{
				ped = `a_m_y_business_02`,
				scenario = 'PROP_HUMAN_SEAT_DECKCHAIR',
				loc = vec3(-30.14, -1114.58, 24.89),
				heading = 333.25,
			}
		}
	},

	WeedShop = {
		name = 'Weed Shop',
		inventory = {
			{ name = 'female_seed',        price = 3000, currency = 'money' },
			{ name = 'male_seed',          price = 3000, currency = 'money' },
			{ name = 'dryingrack',         price = 2500, currency = 'money' },
			{ name = 'dryingrackadvanced', price = 5000, currency = 'money' },
		},
		targets = {
			{
				ped = `a_f_y_hippie_01`,
				scenario = 'WORLD_HUMAN_SMOKING_POT',
				loc = vec3(1066.0449, -3185.5044, -40.1648),
				heading = 44.4327,
			}
		}
	},

	Pharmacy = {
		name = 'Pharmacy',
		inventory = {
			{ name = 'tylenol',     price = 20,  currency = 'money' },
			{ name = 'aspirin',     price = 20,  currency = 'money' },
			{ name = 'ibuprofen',   price = 20,  currency = 'money' },
			{ name = 'bandage',     price = 20,  currency = 'money' },
			{ name = 'painkillers', price = 50,  currency = 'money' },
			{ name = 'emptyvial',   price = 100, currency = 'money' },
			{ name = 'needle',      price = 200, currency = 'money' },
		},
		targets = {
			{
				ped = `s_f_y_scrubs_01`,
				scenario = 'WORLD_HUMAN_CLIPBOARD',
				loc = vec3(-1830.1310, -380.7285, 48.4044),
				heading = 49.1458,
			}
		}
	},

	Pharmacy2 = {
		name = 'Pharmacy',
		inventory = {
			{ name = 'tylenol',     price = 20,  currency = 'money' },
			{ name = 'aspirin',     price = 20,  currency = 'money' },
			{ name = 'ibuprofen',   price = 20,  currency = 'money' },
			{ name = 'bandage',     price = 20,  currency = 'money' },
			{ name = 'painkillers', price = 50,  currency = 'money' },
			{ name = 'emptyvial',   price = 100, currency = 'money' },
			{ name = 'needle',      price = 200, currency = 'money' },
		},
		targets = {
			{
				ped = `s_f_y_scrubs_01`,
				scenario = 'WORLD_HUMAN_CLIPBOARD',
				loc = vec3(-1118.8988, -2803.4570, 20.3616),
				heading = 52.3698,
			}
		}
	},

	Pharmacy3 = {
		name = 'Pharmacy',
		blip = {
			id = 403, colour = 0, scale = 0.6
		},
		inventory = {
			{ name = 'tylenol',     price = 20,  currency = 'money' },
			{ name = 'aspirin',     price = 20,  currency = 'money' },
			{ name = 'ibuprofen',   price = 20,  currency = 'money' },
			{ name = 'bandage',     price = 20,  currency = 'money' },
			{ name = 'painkillers', price = 50,  currency = 'money' },
			{ name = 'emptyvial',   price = 100, currency = 'money' },
			{ name = 'needle',      price = 200, currency = 'money' },
		},
		targets = {
			{
				ped = `s_f_y_scrubs_01`,
				scenario = 'WORLD_HUMAN_CLIPBOARD',
				loc = vec3(375.3012, -829.8359, 28.2914),
				heading = 266.2341,
			}
		}
	},

	Hookies = {
		name = 'Hookies',
		blip = {
			id = 105, colour = 0, scale = 0.6
		},
		inventory = {
			{ name = 'hotdog',        price = 20, currency = 'money' },
			{ name = 'mustard',       price = 10, currency = 'money' },
			{ name = 'ketchup',       price = 10, currency = 'money' },
			{ name = 'cola',          price = 25, currency = 'money' },
			{ name = 'water',         price = 15, currency = 'money' },
			{ name = 'fr_fries',      price = 15, currency = 'money' },
			{ name = 'coffee',        price = 15, currency = 'money' },
			{ name = 'sandwich',      price = 2,  currency = 'money' },
			{ name = 'pizza_pep',     price = 25, currency = 'money' },
			{ name = 'pizza_chs',     price = 25, currency = 'money' },
			{ name = 'pizza_msh',     price = 50, currency = 'money' },
			{ name = 'pizza_mgt',     price = 15, currency = 'money' },
			{ name = 'pizza_dmt',     price = 50, currency = 'money' },
			{ name = 'burger',        price = 15, currency = 'money' },
			{ name = 'burger_chs',    price = 25, currency = 'money' },
			{ name = 'burger_chsbcn', price = 50, currency = 'money' },
		},
		targets = {
			{
				ped = `ig_chef`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-2182.8179, 4287.4985, 48.1822),
				heading = 323.5141,
			}
		}
	},

	Coffee = {
		name = 'Coffee Shop',
		inventory = {
			{ name = 'coffee',        price = 15, currency = 'money' },
			{ name = 'coffeefrap',    price = 50, currency = 'money' },
			{ name = 'coffee_black',  price = 25, currency = 'money' },
			{ name = 'coffee_mocha',  price = 30, currency = 'money' },
			{ name = 'coffee_cpcno',  price = 20, currency = 'money' },
			{ name = 'coffee_amrcno', price = 20, currency = 'money' },
		},
		targets = {
			{
				ped = `s_f_y_clubbar_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-1024.3473, -2761.0957, 20.3679),
				heading = 153.9287,
			}
		}
	},

	Coffee2 = {
		name = 'Coffee Shop',
		inventory = {
			{ name = 'coffee',        price = 15, currency = 'money' },
			{ name = 'coffeefrap',    price = 50, currency = 'money' },
			{ name = 'coffee_black',  price = 25, currency = 'money' },
			{ name = 'coffee_mocha',  price = 30, currency = 'money' },
			{ name = 'coffee_cpcno',  price = 20, currency = 'money' },
			{ name = 'coffee_amrcno', price = 20, currency = 'money' },
		},
		targets = {
			{
				ped = `s_f_y_clubbar_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(280.4868, -973.1031, 28.4216),
				heading = 355.0703,
			}
		}
	},

	--[[Coffee3 = {
		name = 'Coffee Shop',
		inventory = {
			{ name = 'coffee',        price = 15, currency = 'money' },
			{ name = 'coffeefrap',    price = 50, currency = 'money' },
			{ name = 'coffee_black',  price = 25, currency = 'money' },
			{ name = 'coffee_mocha',  price = 30, currency = 'money' },
			{ name = 'coffee_cpcno',  price = 20, currency = 'money' },
			{ name = 'coffee_amrcno', price = 20, currency = 'money' },
		},
		targets = {
			{
				ped = `s_f_y_clubbar_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-1217.7596, -1494.8092, 3.3739),
				heading = 37.6277,
			}
		}
	},---]]

	Pizza = {
		name = 'Pizza',
		blip = {
			id = 267, colour = 0, scale = 0.6
		},
		inventory = {
			{ name = 'pizza_pep',     price = 20, currency = 'money' },
			{ name = 'pizza_chs',     price = 20, currency = 'money' },
			{ name = 'pizza_msh',     price = 20, currency = 'money' },
			{ name = 'pizza_mgt',     price = 15, currency = 'money' },
			{ name = 'pizza_dmt',     price = 20, currency = 'money' },
			{ name = 'box_pizza_pep', price = 45, currency = 'money' },
			{ name = 'box_pizza_chs', price = 45, currency = 'money' },
			{ name = 'box_pizza_msh', price = 50, currency = 'money' },
			{ name = 'box_pizza_mgt', price = 45, currency = 'money' },
			{ name = 'box_pizza_dmt', price = 50, currency = 'money' },
			{ name = 'cola',          price = 25, currency = 'money' },
			{ name = 'water',         price = 15, currency = 'money' },
		},
		targets = {
			{
				ped = `u_m_m_partytarget`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-570.1756, -411.5357, 33.9170),
				heading = 356.9491,
			}
		}
	},

	Burger = {
		name = 'Burger Shot',
		inventory = {
			{ name = 'burger',        price = 15, currency = 'money' },
			{ name = 'burger_chs',    price = 25, currency = 'money' },
			{ name = 'burger_chsbcn', price = 50, currency = 'money' },
			{ name = 'fr_fries',      price = 15, currency = 'money' },
			{ name = 'mustard',       price = 10, currency = 'money' },
			{ name = 'ketchup',       price = 10, currency = 'money' },
			{ name = 'cola',          price = 15, currency = 'money' },
			{ name = 'sprunk_bottle', price = 15, currency = 'money' },
		},
		targets = {
			{
				ped = `csb_burgerdrug`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-586.0440, -612.7896, 33.6818),
				heading = 270.5720,
			}
		}
	},

	Noodle = {
		name = 'Noodle Exchange',
		inventory = {
			{ name = 'noodles', price = 15, currency = 'money' },
			{ name = 'pho',     price = 25, currency = 'money' },
		},
		targets = {
			{
				ped = `a_f_m_ktown_02`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-534.6153, -610.6002, 33.6818),
				heading = 89.1039,
			}
		}
	},

	Hotdog = {
		name = 'Chihuahua Hotdogs',
		blip = {
			id = 96, colour = 0, scale = 0.6
		},
		inventory = {
			{ name = 'hotdog',   price = 20, currency = 'money' },
			{ name = 'mustard',  price = 10, currency = 'money' },
			{ name = 'ketchup',  price = 10, currency = 'money' },
			{ name = 'cola',     price = 25, currency = 'money' },
			{ name = 'water',    price = 15, currency = 'money' },
			{ name = 'fr_fries', price = 15, currency = 'money' },
		},
		targets = {
			{
				ped = `a_m_m_indian_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(43.6034, -1005.3742, 28.2879),
				heading = 335.6183,
			}
		}
	},

	Bar = {
		name = 'Bar',
		blip = {
			id = 93, colour = 0, scale = 0.6
		},
		inventory = {
			{ name = 'beer',    price = 7,  currency = 'money' },
			{ name = 'whiskey', price = 10, currency = 'money' },
			{ name = 'vodka',   price = 12, currency = 'money' },
		},
		targets = {
			{
				ped = `s_f_y_clubbar_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(1989.3605, 3046.8394, 46.2093),
				heading = 321.9189,
			}
		}
	},

	Bar2 = {
		name = 'Bar',
		inventory = {
			{ name = 'beer',    price = 7,  currency = 'money' },
			{ name = 'whiskey', price = 10, currency = 'money' },
			{ name = 'vodka',   price = 12, currency = 'money' },
		},
		targets = {
			{
				ped = `s_f_y_clubbar_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-1150.0485, -2798.3713, 20.3616),
				heading = 236.2220,
			}
		}
	},

	Bar3 = {
		name = 'Bar',
		inventory = {
			{ name = 'beer',    price = 7,  currency = 'money' },
			{ name = 'whiskey', price = 10, currency = 'money' },
			{ name = 'vodka',   price = 12, currency = 'money' },
		},
		targets = {
			{
				ped = `s_f_y_clubbar_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-561.7548, 286.5161, 81.1765),
				heading = 266.7521,
			}
		}
	},

	Bar4 = {
		name = 'Bar',
		inventory = {
			{ name = 'beer',    price = 7,  currency = 'money' },
			{ name = 'whiskey', price = 10, currency = 'money' },
			{ name = 'vodka',   price = 12, currency = 'money' },
		},
		targets = {
			{
				ped = `s_f_y_clubbar_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(105.2639, -1311.4591, 19.2986),
				heading = 286.8842,
			}
		}
	},

	Bar5 = {
		name = 'Bar',
		inventory = {
			{ name = 'beer',    price = 7,  currency = 'money' },
			{ name = 'whiskey', price = 10, currency = 'money' },
			{ name = 'vodka',   price = 12, currency = 'money' },
		},
		targets = {
			{
				ped = `s_f_y_clubbar_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(4905.3931, -4941.3301, 2.3829),
				heading = 33.4660,
			}
		}
	},

	Bar6 = {
		name = 'Bar',
		inventory = {
			{ name = 'beer',    price = 7,  currency = 'money' },
			{ name = 'whiskey', price = 10, currency = 'money' },
			{ name = 'vodka',   price = 12, currency = 'money' },
		},
		targets = {
			{
				ped = `s_f_y_clubbar_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(147.0628, -3052.7607, 10.0240),
				heading = 354.8377,
			}
		}
	},

	Bar7 = {
		name = 'Bar',
		groups = {
			['lux'] = 0
		},
		inventory = {
			{ name = 'beer',    price = 7,  currency = 'money' },
			{ name = 'whiskey', price = 10, currency = 'money' },
			{ name = 'vodka',   price = 12, currency = 'money' },
		},
		locations = {
			vec3(-285.1, 233.24, 78.87)
		},
		targets = {
			{ loc = vec3(-285.1, 233.24, 78.87), length = 0.6, width = 0.5, heading = 278.56, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	Bar8 = {
		name = 'Liquor Store',
		inventory = {
			{ name = 'beer',    price = 7,  currency = 'money' },
			{ name = 'whiskey', price = 10, currency = 'money' },
			{ name = 'vodka',   price = 12, currency = 'money' },
		},
		targets = {
			{
				ped = `s_f_y_clubbar_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-1207.7667, -1509.2434, 3.3739),
				heading = 24.9195,
			}
		}
	},

	Fishing = {
		name = 'Fishing Shop',
		blip = {
			id = 68, colour = 0, scale = 0.6
		},
		inventory = {
			{ name = 'fishingrod', price = 100, currency = 'money' },
			{ name = 'worm_bait',  price = 20,  currency = 'money' },
		},
		targets = {
			{
				ped = `s_m_m_migrant_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-1592.6177, 5197.5156, 3.3590),
				heading = 18.1384,
			}
		}
	},

	Electronics = {
		name = 'Electronics Store',
		blip = {
			id = 606, colour = 0, scale = 0.6
		},
		inventory = {
			{ name = 'radio',        price = 100,  currency = 'money' },
			{ name = 'laptop',       price = 1000, currency = 'money' },
			{ name = 'keeptablet',   price = 1000, currency = 'money' },
			{ name = 'fitbit',       price = 600,  currency = 'money' },
			{ name = 'powerbank',    price = 150,  currency = 'money' },
			{ name = 'phone',        price = 800,  currency = 'money' },
			{ name = 'black_phone',  price = 800,  currency = 'money' },
			{ name = 'yellow_phone', price = 800,  currency = 'money' },
			{ name = 'red_phone',    price = 800,  currency = 'money' },
			{ name = 'green_phone',  price = 800,  currency = 'money' },
			{ name = 'white_phone',  price = 800,  currency = 'money' },
		},
		targets = {
			{
				ped = `a_f_y_smartcaspat_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-1142.2053, -2785.9011, 20.3616),
				heading = 326.0868,
			}
		}
	},

	Electronics2 = {
		name = 'Electronics Store',
		blip = {
			id = 606, colour = 0, scale = 0.6
		},
		inventory = {
			{ name = 'radio',        price = 100,  currency = 'money' },
			{ name = 'laptop',       price = 1000, currency = 'money' },
			{ name = 'keeptablet',   price = 1000, currency = 'money' },
			{ name = 'fitbit',       price = 600,  currency = 'money' },
			{ name = 'powerbank',    price = 150,  currency = 'money' },
			{ name = 'phone',        price = 800,  currency = 'money' },
			{ name = 'black_phone',  price = 800,  currency = 'money' },
			{ name = 'yellow_phone', price = 800,  currency = 'money' },
			{ name = 'red_phone',    price = 800,  currency = 'money' },
			{ name = 'green_phone',  price = 800,  currency = 'money' },
			{ name = 'white_phone',  price = 800,  currency = 'money' },
		},
		targets = {
			{
				ped = `a_f_y_smartcaspat_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-529.1374, -582.7440, 33.6818),
				heading = 176.3681,
			}
		}
	},

	Electronics3 = {
		name = 'Electronics Store',
		inventory = {
			{ name = 'radio',        price = 100,  currency = 'money' },
			{ name = 'laptop',       price = 1000, currency = 'money' },
			{ name = 'keeptablet',   price = 1000, currency = 'money' },
			{ name = 'fitbit',       price = 600,  currency = 'money' },
			{ name = 'powerbank',    price = 150,  currency = 'money' },
			{ name = 'phone',        price = 800,  currency = 'money' },
			{ name = 'black_phone',  price = 800,  currency = 'money' },
			{ name = 'yellow_phone', price = 800,  currency = 'money' },
			{ name = 'red_phone',    price = 800,  currency = 'money' },
			{ name = 'green_phone',  price = 800,  currency = 'money' },
			{ name = 'white_phone',  price = 800,  currency = 'money' },
		},
		targets = {
			{
				ped = `a_f_y_smartcaspat_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-1207.8755, -1502.5751, 3.3739),
				heading = 124.1069,
			}
		}
	},

	Skateshop = {
		name = 'Skateboard Shop',
		blip = {
			id = 120, colour = 0, scale = 0.6
		},
		inventory = {
			{ name = 'skateboard', price = 50, currency = 'money' },
		},
		targets = {
			{
				ped = `u_m_y_caleb`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-1126.2932, -1439.3589, 4.2283),
				heading = 302.7450,
			}
		}
	},

	Hunting = {
		name = 'Hunting Shop',
		blip = {
			id = 313, colour = 0, scale = 0.6
		},
		inventory = {
			{ name = 'hunting_guide',        price = 5,    currency = 'money' },
			{ name = 'huntingbait',          price = 25,   currency = 'money' },
			{ name = 'weapon_musket',        price = 2500, currency = 'money' },
			{ name = 'ammo-musket',          price = 50,   currency = 'money' },
			{ name = 'weapon_marksmanrifle', price = 8000, currency = 'money' },
			{ name = 'ammo-sniper',          price = 80,   currency = 'money' },
			{ name = 'weapon_knife',         price = 150,  currency = 'money' },
			{ name = 'animal_tracker',       price = 1200, currency = 'money' },
		},
		targets = {
			{
				ped = `cs_hunter`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-775.8988, 5603.3223, 32.7408),
				heading = 252.4488,
			}
		}
	},

	YouTool = {
		name = 'YouTool Store',
		blip = {
			id = 566, colour = 0, scale = 0.6
		},
		inventory = {
			{ name = 'miningdrill',      price = 15000, currency = 'money' },
			{ name = 'mininglaser',      price = 65000, currency = 'money' },
			{ name = 'campfire',         price = 400,   currency = 'money' },
			{ name = 'drillbit',         price = 100,   currency = 'money' },
			{ name = 'goldpan',          price = 800,   currency = 'money' },
			{ name = 'cwnotepad',        price = 500,   currency = 'money' },
			{ name = 'repair_kit',       price = 250,   currency = 'money' },
			{ name = 'megaphone',        price = 500,   currency = 'money' },
			{ name = 'yogamat',          price = 800,   currency = 'money' },
			{ name = 'diving_gear',      price = 500,   currency = 'money' },
			{ name = 'diving_fill',      price = 500,   currency = 'money' },
			{ name = 'sprayremover',     price = 600,   currency = 'money' },
			{ name = 'wallet',           price = 500,   currency = 'money' },
			{ name = 'keyring',          price = 200,   currency = 'money' },
			{ name = 'gps',              price = 500,   currency = 'money' },
			{ name = 'pickaxe',          price = 1500,  currency = 'money' },
			{ name = 'fertilizer',       price = 500,   currency = 'money' },
			{ name = 'wateringcan',      price = 500,   currency = 'money' },
			{ name = 'backpack1',        price = 1000,  currency = 'money' },
			{ name = 'backpack2',        price = 1000,  currency = 'money' },
			{ name = 'duffle1',          price = 1000,  currency = 'money' },
			{ name = 'backpack4',        price = 1000,  currency = 'money' },
			{ name = 'backpack5',        price = 1000,  currency = 'money' },
			{ name = 'backpack6',        price = 1000,  currency = 'money' },
			{ name = 'jerrycan',         price = 350,   currency = 'money' },
			{ name = 'syphoningkit',     price = 800,   currency = 'money' },
			{ name = 'bolt_cutter',      price = 800,   currency = 'money' },
			{ name = 'ziptie',           price = 650,   currency = 'money' },
			{ name = 'flush_cutter',     price = 600,   currency = 'money' },
			{ name = 'advancedlockpick', price = 600,   currency = 'money' },
			{ name = 'weapon_wrench',    price = 250,   currency = 'money' },
			{ name = 'weapon_hammer',    price = 250,   currency = 'money' },
			{ name = 'screwdriverset',   price = 350,   currency = 'money' },
			{ name = 'radio',            price = 250,   currency = 'money' },
			{ name = 'binoculars',       price = 100,   currency = 'money' },
			{ name = 'firework1',        price = 50,    currency = 'money' },
			{ name = 'firework2',        price = 50,    currency = 'money' },
			{ name = 'firework3',        price = 50,    currency = 'money' },
			{ name = 'firework4',        price = 50,    currency = 'money' },
			{ name = 'fitbit',           price = 400,   currency = 'money' },
			{ name = 'cleaningkit',      price = 150,   currency = 'money' },
			{ name = 'cleaning_kit',     price = 150,   currency = 'money' },
			{ name = 'drone',            price = 10000, currency = 'money' },
			{ name = 'boombox',          price = 500,   currency = 'money' },
			{ name = 'umbrella',         price = 50,    currency = 'money' },
			{ name = 'camera',           price = 150,   currency = 'money' },
		},
		targets = {
			{
				ped = `a_m_m_golfer_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(2749.4592, 3483.7598, 54.6663),
				heading = 65.3780,
			}
		}
	},

	MovieShop = {
		name = 'Movie Shop',
		inventory = {
			{ name = 'popcorn',  price = 10, currency = 'money' },
			{ name = 'hotdog',   price = 10, currency = 'money' },
			{ name = 'mustard',  price = 10, currency = 'money' },
			{ name = 'ketchup',  price = 10, currency = 'money' },
			{ name = 'cola',     price = 25, currency = 'money' },
			{ name = 'water',    price = 8,  currency = 'money' },
			{ name = 'fr_fries', price = 8,  currency = 'money' },
		},
		targets = {
			{
				ped = `a_f_y_business_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(343.0839, 197.4672, 101.9963),
				heading = 152.8247,
			}
		}
	},

	MovieShop2 = {
		name = 'Movie Shop',
		inventory = {
			{ name = 'popcorn',  price = 10, currency = 'money' },
			{ name = 'hotdog',   price = 10, currency = 'money' },
			{ name = 'mustard',  price = 10, currency = 'money' },
			{ name = 'ketchup',  price = 10, currency = 'money' },
			{ name = 'cola',     price = 25, currency = 'money' },
			{ name = 'water',    price = 8,  currency = 'money' },
			{ name = 'fr_fries', price = 8,  currency = 'money' },
		},
		targets = {
			{
				ped = `a_f_y_business_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(351.1995, 194.5133, 101.9962),
				heading = 152.7675,
			}
		}
	},

	JewelryStore = {
		name = 'Jewelery Store',
		inventory = {
			{ name = 'engagementring', price = 65000,  currency = 'money' },
			{ name = 'weddingring',    price = 180000, currency = 'money' },
		},
		targets = {
			{
				ped = `a_f_y_business_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-622.3835, -229.7804, 37.0570),
				heading = 295.9651,
			}
		}
	},

	burgershot = {
		name = 'Burgershot',
		groups = {
			['burgershot'] = 0
		},
		inventory = {
			{ name = 'burger-bun',           price = 0 },
			{ name = 'burger-raw',           price = 0 },
			{ name = 'taco-tomato',          price = 0 },
			{ name = 'lettuce',              price = 0 },
			{ name = 'burger-potato',        price = 0 },
			{ name = 'burger-mshakeformula', price = 0 },
			{ name = 'burger-sodasyrup',     price = 0 },
		},
	},

	burgershot2 = {
		name = 'Burgershot Menu',
		inventory = {
			{ name = 'burgershot_menu', price = 0 },
		},
		locations = {
			vec3(-1185.1094, -893.1072, 13.8862),
			vec3(-1186.3790, -885.4500, 13.8862),
			vec3(-1189.1805, -887.4291, 13.8862),
			vec3(-1182.3574, -891.2164, 13.8862)
		},
		targets = {
			{ loc = vec3(-1185.1094, -893.1072, 13.8862), length = 0.6, width = 0.5, heading = 3.02, minZ = 28.2, maxZ = 28.6, distance = 2 },
			{ loc = vec3(-1182.3574, -891.2164, 13.8862), length = 0.6, width = 0.5, heading = 3.02, minZ = 28.2, maxZ = 28.6, distance = 2 },
			{ loc = vec3(-1189.1805, -887.4291, 13.8862), length = 0.6, width = 0.5, heading = 3.02, minZ = 28.2, maxZ = 28.6, distance = 2 },
			{ loc = vec3(-1186.3790, -885.4500, 13.8862), length = 0.6, width = 0.5, heading = 3.02, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	beanmenu = {
		name = 'Beanmachine Menu',
		groups = {
			['beanmachine'] = 0
		},
		inventory = {
			{ name = 'beanmachine_menu', price = 0 },
		},
		locations = {
			vec3(-636.6, 233.79, 82.41)
		},
		targets = {
			{ loc = vec3(-636.6, 233.79, 82.41), length = 0.6, width = 0.5, heading = 3.02, minZ = 28.2, maxZ = 28.6, distance = 2 }

		}
	},

	tacomenu = {
		name = 'Taco Menu',
		groups = {
			['taco'] = 0
		},
		inventory = {
			{ name = 'taco_menu', price = 0 },
		},
		locations = {
			vec3(20.2, -1600.78, 29.39)
		},
		targets = {
			{ loc = vec3(20.2, -1600.78, 29.39), length = 0.6, width = 0.5, heading = 3.02, minZ = 28.2, maxZ = 28.6, distance = 2 }

		}
	},

	taco = {
		name = 'taco',
		groups = {
			['taco'] = 0
		},
		inventory = {
			{ name = 'tortillas',        price = 0 },
			{ name = 'ground-beef',      price = 0 },
			{ name = 'cheddar-cheese',   price = 0 },
			{ name = 'barra-manteiga',   price = 0 },
			{ name = 'chicken',          price = 0 },
			{ name = 'lettuce',          price = 0 },
			{ name = 'tortilla-chips',   price = 0 },
			{ name = 'carbonated-water', price = 0 },
			{ name = 'sugar-cubes',      price = 0 },
			{ name = 'taco-tomato',      price = 0 },
		},
	},

	GroceryStore = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'milk', price = 10, currency = 'money' },
		},
		locations = {
			vec3(2701.4509, 3340.7742, 57.1335)
		},
		targets = {
			{ loc = vec3(2701.4509, 3340.7742, 57.1335), length = 1.0, width = 0.8, heading = 160.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStore2 = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'raw_meat',    price = 20, currency = 'money' },
			{ name = 'burger-raw',  price = 20, currency = 'money' },
			{ name = 'ground-beef', price = 20, currency = 'money' },
			{ name = 'chicken',     price = 20, currency = 'money' },
		},
		locations = {
			vec3(2708.58, 3337.56, 57.13)
		},
		targets = {
			{ loc = vec3(2708.58, 3337.56, 57.13), length = 1.0, width = 0.8, heading = 160.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStore3 = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'flour', price = 10, currency = 'money' },
		},
		locations = {
			vec3(2707.9121, 3360.9836, 57.1163)
		},
		targets = {
			{ loc = vec3(2707.9121, 3360.9836, 57.1163), length = 1.0, width = 0.8, heading = 160.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStore4 = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'orange', price = 10, currency = 'money' },
			{ name = 'banana', price = 10, currency = 'money' },
			{ name = 'apple',  price = 10, currency = 'money' },
			{ name = 'limao',  price = 10, currency = 'money' },
		},
		locations = {
			vec3(2709.59, 3346.98, 57.11)
		},
		targets = {
			{ loc = vec3(2709.59, 3346.98, 57.11), length = 1.0, width = 0.8, heading = 160.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStore5 = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'phatc_rib', price = 10, currency = 'money' },
			{ name = 'phatc_bch', price = 10, currency = 'money' },
		},
		locations = {
			vec3(2699.0164, 3357.7441, 57.1413)
		},
		targets = {
			{ loc = vec3(2699.0164, 3357.7441, 57.1413), length = 1.0, width = 0.8, heading = 58.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStore6 = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'egochaser', price = 10, currency = 'money' },
		},
		locations = {
			vec3(2694.4700, 3371.3442, 57.1163)
		},
		targets = {
			{ loc = vec3(2694.4700, 3371.3442, 57.1163), length = 1.0, width = 0.8, heading = 69.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStore7 = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'ps_qs', price = 10, currency = 'money' },
		},
		locations = {
			vec3(2693.3928, 3360.2017, 57.1312)
		},
		targets = {
			{ loc = vec3(2693.3928, 3360.2017, 57.1312), length = 1.0, width = 0.8, heading = 158.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStore8 = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'box_rancho_beer',  price = 200, currency = 'money' },
			{ name = 'box_dusche_beer',  price = 200, currency = 'money' },
			{ name = 'box_blarny_beer',  price = 200, currency = 'money' },
			{ name = 'box_patriot_beer', price = 200, currency = 'money' },
			{ name = 'box_stronzo_beer', price = 200, currency = 'money' },
		},
		locations = {
			vec3(2699.9678, 3360.4292, 57.1353)
		},
		targets = {
			{ loc = vec3(2699.9678, 3360.4292, 57.1353), length = 1.0, width = 0.8, heading = 338.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStore9 = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'mustard', price = 10, currency = 'money' },
			{ name = 'ketchup', price = 10, currency = 'money' },
		},
		locations = {
			vec3(2705.4326, 3368.8691, 57.1163)
		},
		targets = {
			{ loc = vec3(2705.4326, 3368.8691, 57.1163), length = 1.0, width = 0.8, heading = 64.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStore10 = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'cola', price = 10, currency = 'money' },
		},
		locations = {
			vec3(2697.0181, 3356.8804, 57.1163)
		},
		targets = {
			{ loc = vec3(2697.0181, 3356.8804, 57.1163), length = 1.0, width = 0.8, heading = 246.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStore11 = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'sprunk', price = 10, currency = 'money' },
		},
		locations = {
			vec3(2696.0544, 3354.8660, 57.1163)
		},
		targets = {
			{ loc = vec3(2696.0544, 3354.8660, 57.1163), length = 1.0, width = 0.8, heading = 246.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStore12 = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'orangotang', price = 10, currency = 'money' },
		},
		locations = {
			vec3(2694.4458, 3351.2402, 57.1163)
		},
		targets = {
			{ loc = vec3(2694.4458, 3351.2402, 57.1163), length = 1.0, width = 0.8, heading = 238.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStore13 = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'water', price = 10, currency = 'money' },
		},
		locations = {
			vec3(2690.9436, 3345.3914, 57.1336)
		},
		targets = {
			{ loc = vec3(2690.9436, 3345.3914, 57.1336), length = 1.0, width = 0.8, heading = 151.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStore14 = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'ejunk', price = 10, currency = 'money' },
		},
		locations = {
			vec3(2691.9749, 3352.1606, 57.1163)
		},
		targets = {
			{ loc = vec3(2691.9749, 3352.1606, 57.1163), length = 1.0, width = 0.8, heading = 66.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStore15 = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'burger-bun', price = 10, currency = 'money' },
		},
		locations = {
			vec3(2707.1140, 3359.1091, 57.1163)
		},
		targets = {
			{ loc = vec3(2707.1140, 3359.1091, 57.1163), length = 1.0, width = 0.8, heading = 76.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStore16 = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'mre_1', price = 10, currency = 'money' },
			{ name = 'mre_2', price = 10, currency = 'money' },
			{ name = 'mre_3', price = 10, currency = 'money' },
			{ name = 'mre_4', price = 10, currency = 'money' },
			{ name = 'mre_5', price = 10, currency = 'money' },
		},
		locations = {
			vec3(2714.9424, 3366.5532, 57.1163)
		},
		targets = {
			{ loc = vec3(2714.9424, 3366.5532, 57.1163), length = 1.0, width = 0.8, heading = 153.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStore17 = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'box_bourgeoix_liquor', price = 200, currency = 'money' },
			{ name = 'box_cariaque_liquor',  price = 200, currency = 'money' },
			{ name = 'box_bleuterd_liquor',  price = 200, currency = 'money' },
			{ name = 'box_ragga_liquor',     price = 200, currency = 'money' },
			{ name = 'box_tequilya_liquor',  price = 200, currency = 'money' },
			{ name = 'box_nogo_liquor',      price = 200, currency = 'money' },
			{ name = 'box_mount_liquor',     price = 200, currency = 'money' },
			{ name = 'box_richards_liquor',  price = 200, currency = 'money' },
		},
		locations = {
			vec3(2700.3284, 3350.8506, 57.1163)
		},
		targets = {
			{ loc = vec3(2700.3284, 3350.8506, 57.1163), length = 1.0, width = 0.8, heading = 250.0, minZ = 28.2, maxZ = 28.6, distance = 2 }
		}
	},

	GroceryStoreFront = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'flour',                price = 10,  currency = 'money' },
			{ name = 'bcoffeebeans',         price = 10,  currency = 'money' },
			{ name = 'bcream',               price = 10,  currency = 'money' },
			{ name = 'bstrawberry',          price = 10,  currency = 'money' },
			{ name = 'bhotchocolatepowder',  price = 10,  currency = 'money' },
			{ name = 'extrato-baunilha',     price = 10,  currency = 'money' },
			{ name = 'bhoney',               price = 10,  currency = 'money' },
			{ name = 'bice',                 price = 10,  currency = 'money' },
			{ name = 'bcaramelsyrup',        price = 10,  currency = 'money' },
			{ name = 'tortillas',            price = 10,  currency = 'money' },
			{ name = 'taco-tomato',          price = 10,  currency = 'money' },
			{ name = 'lettuce',              price = 10,  currency = 'money' },
			{ name = 'barra-manteiga',       price = 10,  currency = 'money' },
			{ name = 'tortilla-chips',       price = 10,  currency = 'money' },
			{ name = 'cheddar-cheese',       price = 10,  currency = 'money' },
			{ name = 'caixa-amoras',         price = 10,  currency = 'money' },
			{ name = 'chocolate',            price = 10,  currency = 'money' },
			{ name = 'carbonated-water',     price = 10,  currency = 'money' },
			{ name = 'sugar-cubes',          price = 10,  currency = 'money' },
			{ name = 'pacote-acucar',        price = 10,  currency = 'money' },
			{ name = 'pacote-oreo',          price = 10,  currency = 'money' },
			{ name = 'extrato-menta',        price = 10,  currency = 'money' },
			{ name = 'frasco-nutela',        price = 10,  currency = 'money' },
			{ name = 'burger-potato',        price = 10,  currency = 'money' },
			{ name = 'burger-mshakeformula', price = 10,  currency = 'money' },
			{ name = 'burger-sodasyrup',     price = 10,  currency = 'money' },
			{ name = 'bhighcoffeeglasscup',  price = 10,  currency = 'money' },
			{ name = 'bcoffeeglass',         price = 10,  currency = 'money' },
			{ name = 'bespressocoffeecup',   price = 10,  currency = 'money' },
			{ name = 'orange',               price = 10,  currency = 'money' },
			{ name = 'banana',               price = 10,  currency = 'money' },
			{ name = 'apple',                price = 10,  currency = 'money' },
			{ name = 'limao',                price = 10,  currency = 'money' },
			{ name = 'burger-bun',           price = 10,  currency = 'money' },
			{ name = 'water',                price = 10,  currency = 'money' },
			{ name = 'water_bottle',         price = 10,  currency = 'money' },
			{ name = 'mustard',              price = 10,  currency = 'money' },
			{ name = 'ketchup',              price = 10,  currency = 'money' },
			{ name = 'raw_meat',             price = 20,  currency = 'money' },
			{ name = 'burger-raw',           price = 20,  currency = 'money' },
			{ name = 'ground-beef',          price = 20,  currency = 'money' },
			{ name = 'flour',                price = 10,  currency = 'money' },
			{ name = 'milk',                 price = 10,  currency = 'money' },
			{ name = 'sandwich',             price = 10,  currency = 'money' },
			{ name = 'bandage',              price = 25,  currency = 'money' },
			{ name = 'lighter',              price = 2,   currency = 'money' },
			{ name = 'rolling_paper',        price = 2,   currency = 'money' },
			{ name = 'soda',                 price = 10,  currency = 'money' },
			{ name = 'sprunk',               price = 10,  currency = 'money' },
			{ name = 'cigbox',               price = 100, currency = 'money' },
			{ name = 'egobar',               price = 10,  currency = 'money' },
			{ name = 'crisps',               price = 10,  currency = 'money' },
			{ name = 'bakingsoda',           price = 7,   currency = 'money' },
			{ name = 'beer',                 price = 7,   currency = 'money' },
			{ name = 'whiskey',              price = 10,  currency = 'money' },
			{ name = 'vodka',                price = 12,  currency = 'money' },
		},
		targets = {
			{
				ped = `a_f_y_business_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(2688.6577, 3386.3738, 56.1163),
				heading = 243.2518,
			}
		}
	},

	GroceryStoreBeach = {
		name = 'Grocery Store',
		inventory = {
			{ name = 'flour',                price = 10,  currency = 'money' },
			{ name = 'bcoffeebeans',         price = 10,  currency = 'money' },
			{ name = 'bcream',               price = 10,  currency = 'money' },
			{ name = 'bstrawberry',          price = 10,  currency = 'money' },
			{ name = 'bhotchocolatepowder',  price = 10,  currency = 'money' },
			{ name = 'extrato-baunilha',     price = 10,  currency = 'money' },
			{ name = 'bhoney',               price = 10,  currency = 'money' },
			{ name = 'bice',                 price = 10,  currency = 'money' },
			{ name = 'bcaramelsyrup',        price = 10,  currency = 'money' },
			{ name = 'tortillas',            price = 10,  currency = 'money' },
			{ name = 'taco-tomato',          price = 10,  currency = 'money' },
			{ name = 'lettuce',              price = 10,  currency = 'money' },
			{ name = 'barra-manteiga',       price = 10,  currency = 'money' },
			{ name = 'tortilla-chips',       price = 10,  currency = 'money' },
			{ name = 'cheddar-cheese',       price = 10,  currency = 'money' },
			{ name = 'caixa-amoras',         price = 10,  currency = 'money' },
			{ name = 'chocolate',            price = 10,  currency = 'money' },
			{ name = 'carbonated-water',     price = 10,  currency = 'money' },
			{ name = 'sugar-cubes',          price = 10,  currency = 'money' },
			{ name = 'pacote-acucar',        price = 10,  currency = 'money' },
			{ name = 'pacote-oreo',          price = 10,  currency = 'money' },
			{ name = 'extrato-menta',        price = 10,  currency = 'money' },
			{ name = 'frasco-nutela',        price = 10,  currency = 'money' },
			{ name = 'burger-potato',        price = 10,  currency = 'money' },
			{ name = 'burger-mshakeformula', price = 10,  currency = 'money' },
			{ name = 'burger-sodasyrup',     price = 10,  currency = 'money' },
			{ name = 'bhighcoffeeglasscup',  price = 10,  currency = 'money' },
			{ name = 'bcoffeeglass',         price = 10,  currency = 'money' },
			{ name = 'bespressocoffeecup',   price = 10,  currency = 'money' },
			{ name = 'orange',               price = 10,  currency = 'money' },
			{ name = 'banana',               price = 10,  currency = 'money' },
			{ name = 'apple',                price = 10,  currency = 'money' },
			{ name = 'limao',                price = 10,  currency = 'money' },
			{ name = 'burger-bun',           price = 10,  currency = 'money' },
			{ name = 'water',                price = 10,  currency = 'money' },
			{ name = 'mustard',              price = 10,  currency = 'money' },
			{ name = 'ketchup',              price = 10,  currency = 'money' },
			{ name = 'raw_meat',             price = 20,  currency = 'money' },
			{ name = 'burger-raw',           price = 20,  currency = 'money' },
			{ name = 'ground-beef',          price = 20,  currency = 'money' },
			{ name = 'flour',                price = 10,  currency = 'money' },
			{ name = 'milk',                 price = 10,  currency = 'money' },
			{ name = 'sandwich',             price = 10,  currency = 'money' },
			{ name = 'bandage',              price = 25,  currency = 'money' },
			{ name = 'lighter',              price = 2,   currency = 'money' },
			{ name = 'rolling_paper',        price = 2,   currency = 'money' },
			{ name = 'soda',                 price = 10,  currency = 'money' },
			{ name = 'sprunk',               price = 10,  currency = 'money' },
			{ name = 'cigbox',               price = 100, currency = 'money' },
			{ name = 'egobar',               price = 10,  currency = 'money' },
			{ name = 'crisps',               price = 10,  currency = 'money' },
			{ name = 'bakingsoda',           price = 7,   currency = 'money' },
			{ name = 'beer',                 price = 7,   currency = 'money' },
			{ name = 'whiskey',              price = 10,  currency = 'money' },
			{ name = 'vodka',                price = 12,  currency = 'money' },
		},
		targets = {
			{
				ped = `a_f_y_business_01`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-1225.5598, -1484.8701, 3.3739),
				heading = 30.0258,
			}
		}
	},

	MaskStore = {
		name = 'Mask Store',
		inventory = {
			{ name = 'terror',        price = 40, currency = 'money' },
			{ name = 'noselong',      price = 40, currency = 'money' },
			{ name = 'tshirtmask',    price = 40, currency = 'money' },
			{ name = 'clown',         price = 40, currency = 'money' },
			{ name = 'scarf',         price = 40, currency = 'money' },
			{ name = 'terrorwit',     price = 40, currency = 'money' },
			{ name = 'helm5',         price = 40, currency = 'money' },
			{ name = 'helm6',         price = 40, currency = 'money' },
			{ name = 'helm7',         price = 40, currency = 'money' },
			{ name = 'paardu',        price = 40, currency = 'money' },
			{ name = 'hockeymask',    price = 40, currency = 'money' },
			{ name = 'zwart2',        price = 40, currency = 'money' },
			{ name = 'helm1',         price = 40, currency = 'money' },
			{ name = 'skullmask',     price = 40, currency = 'money' },
			{ name = 'monkeymask',    price = 40, currency = 'money' },
			{ name = 'helm8',         price = 40, currency = 'money' },
			{ name = 'feest',         price = 40, currency = 'money' },
			{ name = 'scarecrowmask', price = 40, currency = 'money' },
			{ name = 'helm2',         price = 40, currency = 'money' },
			{ name = 'masker3',       price = 40, currency = 'money' },
			{ name = 'please',        price = 40, currency = 'money' },
			{ name = 'zak',           price = 40, currency = 'money' },
			{ name = 'helm3',         price = 40, currency = 'money' },
			{ name = 'zwart1',        price = 40, currency = 'money' },
			{ name = 'gorilla',       price = 40, currency = 'money' },
			{ name = 'groen',         price = 40, currency = 'money' },
			{ name = 'skullr',        price = 40, currency = 'money' },
			{ name = 'roodc',         price = 40, currency = 'money' },
			{ name = 'bandanab',      price = 40, currency = 'money' },
			{ name = 'skullzwart',    price = 40, currency = 'money' },
			{ name = 'helm4',         price = 40, currency = 'money' },
			{ name = 'sok',           price = 40, currency = 'money' },
			{ name = 'blauw',         price = 40, currency = 'money' },
			{ name = 'blackbandana',  price = 40, currency = 'money' },
			{ name = 'bivak1',        price = 40, currency = 'money' },
		},
		targets = {
			{
				ped = `u_m_o_dean`,
				scenario = 'WORLD_HUMAN_STAND_MOBILE',
				loc = vec3(-1335.0538, -1277.0011, 3.9636),
				heading = 110.1556,
			}
		}
	},

	Pharmacy4 = {
		name = 'Pharmacy',
		inventory = {
			{ name = 'tylenol',     price = 20,  currency = 'money' },
			{ name = 'aspirin',     price = 20,  currency = 'money' },
			{ name = 'ibuprofen',   price = 20,  currency = 'money' },
			{ name = 'bandage',     price = 20,  currency = 'money' },
			{ name = 'painkillers', price = 50,  currency = 'money' },
			{ name = 'emptyvial',   price = 100, currency = 'money' },
			{ name = 'needle',      price = 200, currency = 'money' },
		},
		targets = {
			{
				ped = `s_f_y_scrubs_01`,
				scenario = 'WORLD_HUMAN_CLIPBOARD',
				loc = vec3(-1227.1996, -1474.9130, 3.3739),
				heading = 124.3809,
			}
		}
	},

	--[[VendingMachineDrinks = {
		name = 'Vending Machine',
		inventory = {
			{ name = 'water',  price = 10 },
			{ name = 'cola',   price = 10 },
			{ name = 'sprunk', price = 10 },
		},
		model = {
			`prop_vend_soda_02`, `prop_vend_fridge01`, `prop_vend_water_01`, `prop_vend_soda_01`
		}
	}--]]
}
