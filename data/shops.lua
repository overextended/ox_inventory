local Data = {}
Data.General = {
	name = 'Shop',
	blip = {
		id = 52, colour = 69, scale = 0.8
	}, inventory = {
		{ name = 'burger', price = 10 },
		{ name = 'water', price = 10 },
		{ name = 'cola', price = 10 },
		{ name = 'bandage', price = 10 }
	}, locations = {

	}, targets = {

	}
}

Data.Liquor = {
	name = 'Liquor Store',
	blip = {
		id = 93, colour = 69, scale = 0.8
	}, inventory = {
		{ name = 'water', price = 10 },
		{ name = 'cola', price = 10 }
	}, locations = {
		vector3(1135.808, -982.281, 46.415),
		vector3(-1222.915, -906.983, 12.326),
		vector3(-1487.553, -379.107, 40.163),
		vector3(-2968.243, 390.910, 15.043),
		vector3(1166.024, 2708.930, 38.157),
		vector3(1392.562, 3604.684, 34.980),
		vector3(-1393.409, -606.624, 30.319)
	}, targets = {
		{ loc = vector3(1134.9, -982.34, 46.41), length = 0.5, width = 0.5, heading = 96.0, minZ = 46.4, maxZ = 46.8, distance = 1.5 },
		{ loc = vector3(-1222.33, -907.82, 12.43), length = 0.6, width = 0.5, heading = 32.7, minZ = 12.3, maxZ = 12.7, distance = 1.5 },
		{ loc = vector3(-1486.67, -378.46, 40.26), length = 0.6, width = 0.5, heading = 133.77, minZ = 40.1, maxZ = 40.5, distance = 1.5 },
		{ loc = vector3(-2967.0, 390.9, 15.14), length = 0.7, width = 0.5, heading = 85.23, minZ = 15.0, maxZ = 15.4, distance = 1.5 },
		{ loc = vector3(1165.95, 2710.20, 38.26), length = 0.6, width = 0.5, heading = 178.84, minZ = 38.1, maxZ = 38.5, distance = 1.5 },
		{ loc = vector3(1393.0, 3605.95, 35.11), length = 0.6, width = 0.6, heading = 200.0, minZ = 35.0, maxZ = 35.4, distance = 1.5 }
	}
}

Data.YouTool = {
	name = 'YouTool',
	blip = {
		id = 402, colour = 69, scale = 0.8
	}, inventory = {
		{ name = 'lockpick', price = 10 }
	}, locations = {
		vector3(2748.0, 3473.0, 55.67),
		vector3(342.99, -1298.26, 32.51)
	}, targets = {
		{ loc = vector3(2746.8, 3473.13, 55.67), length = 0.6, width = 3.0, heading = 65.0, minZ = 55.0, maxZ = 56.8, distance = 3.0 }
	}
}

Data.Ammunation = {
	name = 'Ammunation',
	blip = {
		id = 110, colour = 69, scale = 0.8
	}, inventory = {
		{ name = 'ammo-9', price = 5, },
		{ name = 'WEAPON_KNIFE', price = 200 },
		{ name = 'WEAPON_BAT', price = 100 },
		{ name = 'WEAPON_PISTOL', price = 1000, metadata = { registered = true }, license = 'weapon' }
	}, locations = {
		vector3(-662.180, -934.961, 21.829),
		vector3(810.25, -2157.60, 29.62),
		vector3(1693.44, 3760.16, 34.71),
		vector3(-330.24, 6083.88, 31.45),
		vector3(252.63, -50.00, 69.94),
		vector3(22.56, -1109.89, 29.80),
		vector3(2567.69, 294.38, 108.73),
		vector3(-1117.58, 2698.61, 18.55),
		vector3(842.44, -1033.42, 28.19)
	}, targets = {
		{ loc = vector3(-660.92, -934.10, 21.94), length = 0.6, width = 0.5, heading = 180.0, minZ = 21.8, maxZ = 22.2, distance = 2.0 },
		{ loc = vector3(808.86, -2158.50, 29.73), length = 0.6, width = 0.5, heading = 360.0, minZ = 29.6, maxZ = 30.0, distance = 2.0 },
		{ loc = vector3(1693.57, 3761.60, 34.82), length = 0.6, width = 0.5, heading = 227.39, minZ = 34.7, maxZ = 35.1, distance = 2.0 },
		{ loc = vector3(-330.29, 6085.54, 31.57), length = 0.6, width = 0.5, heading = 225.0, minZ = 31.4, maxZ = 31.8, distance = 2.0 },
		{ loc = vector3(252.85, -51.62, 70.0), length = 0.6, width = 0.5, heading = 70.0, minZ = 69.9, maxZ = 70.3, distance = 2.0 },
		{ loc = vector3(23.68, -1106.46, 29.91), length = 0.6, width = 0.5, heading = 160.0, minZ = 29.8, maxZ = 30.2, distance = 2.0 },
		{ loc = vector3(2566.59, 293.13, 108.85), length = 0.6, width = 0.5, heading = 360.0, minZ = 108.7, maxZ = 109.1, distance = 2.0 },
		{ loc = vector3(-1117.61, 2700.26, 18.67), length = 0.6, width = 0.5, heading = 221.82, minZ = 18.5, maxZ = 18.9, distance = 2.0 },
		{ loc = vector3(841.05, -1034.76, 28.31), length = 0.6, width = 0.5, heading = 360.0, minZ = 28.2, maxZ = 28.6, distance = 2.0 }
	}
}

Data.PoliceArmoury = {
	name = 'Police Armoury',
	job = { ['police'] = 1 },
	blip = { 
		id = 110, colour = 84, scale = 0.8
	}, inventory = {
		{ name = 'ammo-9', price = 5, },
		{ name = 'ammo-rifle', price = 5, },
		{ name = 'WEAPON_FLASHLIGHT', price = 200 },
		{ name = 'WEAPON_NIGHTSTICK', price = 100 },
		{ name = 'WEAPON_PISTOL', price = 500, metadata = { registered = true, serial = 'POL' }, license = 'weapon' },
		{ name = 'WEAPON_CARBINERIFLE', price = 1000, metadata = { registered = true, serial = 'POL' }, license = 'weapon', grade = 3 },
		{ name = 'WEAPON_STUNGUN', price = 500, metadata = { registered = true, serial = 'POL'} }
	}, locations = {
		vector3(451.51, -979.44, 30.68)
	}, targets = {
		{ loc = vector3(453.21, -980.03, 30.68), length = 0.5, width = 3.0, heading = 270.0, minZ = 30.5, maxZ = 32.0, distance = 6 }
	}
}

Data.Medicine = {
	name = 'Medicine Cabinet',
	job = 'ambulance',
	blip = {
		id = 403, colour = 69, scale = 0.8
	}, inventory = {
		{ name = 'medikit', price = 26 },
		{ name = 'bandage', price = 5 }
	}, locations = {
		vector3(306.3687, -601.5139, 43.28406)
	}, targets = {
		
	}
}

Data.BlackMarketArms = {
	name = 'Black Market (Arms)',
	inventory = {
		{ name = 'WEAPON_DAGGER', price = 5000, metadata = { registered = false	}, },
		{ name = 'WEAPON_CERAMICPISTOL', price = 50000, metadata = { registered = false }, },
		{ name = 'at_suppressor_pistol', price = 50000, },
		{ name = 'ammo-rifle', price = 1000 },
		{ name = 'ammo-rifle2', price = 1000 }
	}, locations = {
		vector3(309.09, -913.75, 56.46)
	}, targets = {
		
	}
}