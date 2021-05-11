Config.General = {
	name = 'Shop',
	blip = {
		id = 52,
		colour = 69,
		scale = 0.6
	}, inventory = {
		{ name = 'burger', price = 10 },
		{ name = 'sandwich', price = 10 },
		{ name = 'water', price = 10 },
		{ name = 'cola', price = 10 },
		{ name = 'bandage', price = 10 },
	}
}

Config.Liquor = {
	name = 'Liquor Store',
	blip = {
		id = 93,
		colour = 69,
		scale = 0.6
	}, inventory = {
		{ name = 'water', price = 10 },
		{ name = 'cola', price = 10 },
	}
}

Config.YouTool = {
	name = 'YouTool',
	blip = {
		id = 402,
		colour = 69,
		scale = 0.6
	}, inventory = {
		{ name = 'lockpick', price = 10 },
	}
}

Config.Ammunation = {
	name = 'Ammunation',
	blip = {
		id = 110,
		colour = 69,
		scale = 0.6
	}, inventory = {
		{ name = 'ammo-9', price = 5, },
		{ name = 'WEAPON_KNIFE', price = 200 },
		{ name = 'WEAPON_BAT', price = 100 },
		{ name = 'WEAPON_PISTOL', price = 1000, metadata = { registered = true }, license = 'weapon' },
	}
}

Config.PoliceArmoury = {
	name = 'Police Armoury',
	blip = {
		id = 110,
		colour = 84,
		scale = 0.6
	}, inventory = {
		{ name = 'ammo-9', price = 5, },
		{ name = 'ammo-rifle', price = 5, },
		{ name = 'WEAPON_FLASHLIGHT', price = 200 },
		{ name = 'WEAPON_NIGHTSTICK', price = 100 },
		{ name = 'WEAPON_PISTOL', price = 500, metadata = { registered = true, serial = 'POL' }, license = 'weapon' },
		{ name = 'WEAPON_CARBINERIFLE', price = 1000, metadata = { registered = true, serial = 'POL' }, license = 'weapon', grade = 3 },
		{ name = 'WEAPON_STUNGUN', price = 500, metadata = { registered = true, serial = 'POL'} },
	}
}

Config.Medicine = {
	name = 'Medicine Cabinet',
	blip = {
		id = 403,
		colour = 69,
		scale = 0.6
	}, inventory = {
		{ name = 'medikit', price = 26 },
		{ name = 'WEAPON_STUNGUN', price = 500, metadata = { registered = true, serial = 'EMS' } },
	}
}

Config.BlackMarketArms = {
	name = 'Black Market (Arms)',
	inventory = {
		{
			name = 'WEAPON_DAGGER',
			price = 5000,
			metadata = {
				registered = false
			},
		},
		{
			name = 'WEAPON_CERAMICPISTOL',
			price = 50000,
			metadata = {
				registered = false
			},
		},
		{
			name = 'at_suppressor_pistol',
			price = 50000,
		},
		{
			name = 'ammo-rifle',
			price = 1000
		},
		{
			name = 'ammo-rifle2',
			price = 1000
		}
	}
}


Config.Shops = {
	{ type = Config.Ammunation, coords = vector3(-662.180, -934.961, 21.829)--[[, currency = 'money']] }, -- can set currency like so
	{ type = Config.Ammunation, coords = vector3(810.25, -2157.60, 29.62)--[[, currency = 'burger']] },
	{ type = Config.Ammunation, coords = vector3(1693.44, 3760.16, 34.71) },
	{ type = Config.Ammunation, coords = vector3(-330.24, 6083.88, 31.45) },
	{ type = Config.Ammunation, coords = vector3(252.63, -50.00, 69.94) },
	{ type = Config.Ammunation, coords = vector3(22.56, -1109.89, 29.80) },
	{ type = Config.Ammunation, coords = vector3(2567.69, 294.38, 108.73) },
	{ type = Config.Ammunation, coords = vector3(-1117.58, 2698.61, 18.55) },
	{ type = Config.Ammunation, coords = vector3(842.44, -1033.42, 28.19) },

	{ type = Config.Liquor, coords = vector3(1135.808, -982.281, 46.415), name = 'Rob\'s Liquor' },
	{ type = Config.Liquor, coords = vector3(-1222.915, -906.983,  12.326), name = 'Rob\'s Liquor' },
	{ type = Config.Liquor, coords = vector3(-1487.553, -379.107,  40.163), name = 'Rob\'s Liquor' },
	{ type = Config.Liquor, coords = vector3(-2968.243, 390.910, 15.043), name = 'Rob\'s Liquor' },
	{ type = Config.Liquor, coords = vector3(1166.024, 2708.930, 38.157), name = 'Rob\'s Liquor' },
	{ type = Config.Liquor, coords = vector3(1392.562, 3604.684, 34.980), name = 'Rob\'s Liquor' },
	{ type = Config.Liquor, coords = vector3(-1393.409, -606.624, 30.319), name = 'Rob\'s Liquor' },

	{ type = Config.YouTool, coords = vector3(2748.0, 3473.0, 55.67) },
	{ type = Config.YouTool, coords = vector3(342.99, -1298.26, 32.51) },

	{ coords = vector3(-531.14, -1221.33, 18.48), name = 'Xero Gas'},
	{ coords = vector3(2557.458,  382.282, 108.622), name = '24/7'},
	{ coords = vector3(-3038.939, 585.954, 7.908), name = '24/7'},
	{ coords = vector3(-3241.927, 1001.462, 12.830), name = '24/7'},
	{ coords = vector3(547.431, 2671.710, 42.156), name = '24/7'},
	{ coords = vector3(1961.464, 3740.672, 32.343), name = '24/7'},
	{ coords = vector3(2678.916, 3280.671, 55.241), name = '24/7'},
	{ coords = vector3(1729.216, 6414.131, 35.037), name = '24/7'},
	{ coords = vector3(-48.519, -1757.514, 29.421), name = 'LTD'},
	{ coords = vector3(1163.373, -323.801, 69.205), name = 'LTD'},
	{ coords = vector3(-707.501, -914.260, 19.215), name = 'LTD'},
	{ coords = vector3(-1820.523, 792.518, 138.118), name = 'LTD'},
	{ coords = vector3(1698.388, 4924.404, 42.063), name = 'LTD'},
	{ coords = vector3(25.723, -1346.966, 29.497), name = '24/7'},
	{ coords = vector3(373.875, 325.896, 103.566), name = '24/7'},
	{ coords = vector3(-2544.092, 2316.184, 33.2), name = 'RON'},

	
	{ type = Config.PoliceArmoury, job = 'police', coords = vector3(487.235, -997.108, 30.69) },
	{ type = Config.Medicine, job = 'ambulance', coords = vector3(306.3687, -601.5139, 43.28406) },

	{ type = Config.BlackMarketArms, coords = vector3(309.09, -913.75, 56.46), currency = 'black_money' },
}
