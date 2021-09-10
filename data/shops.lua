local Data = {}
Data.General = {
	name = 'Shop',
	blip = {
		id = 52, colour = 69, scale = 0.6
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
		id = 93, colour = 69, scale = 0.6
	}, inventory = {
		{ name = 'water', price = 10 },
		{ name = 'cola', price = 10 }
	}, locations = {
		vector3(1135.808, -982.281, 46.415), 
		vector3(-1222.915, -906.983,  12.326),
		vector3(-1487.553, -379.107,  40.163),
		vector3(-2968.243, 390.910, 15.043),
		vector3(1166.024, 2708.930, 38.157),
		vector3(1392.562, 3604.684, 34.980),
		vector3(-1393.409, -606.624, 30.319)
	}, targets = {

	}
}

Data.YouTool = {
	name = 'YouTool',
	blip = {
		id = 402, colour = 69, scale = 0.6
	}, inventory = {
		{ name = 'lockpick', price = 10 }
	}, locations = {
		vector3(2748.0, 3473.0, 55.67),
		vector3(342.99, -1298.26, 32.51)
	}, targets = {

	}
}

Data.Ammunation = {
	name = 'Ammunation',
	blip = {
		id = 110, colour = 69, scale = 0.6
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

	}
}

Data.PoliceArmoury = {
	name = 'Police Armoury',
	job = { ['police'] = 1 },
	blip = { 
		id = 110, colour = 84, scale = 0.6
	}, inventory = {
		{ name = 'ammo-9', price = 5, },
		{ name = 'ammo-rifle', price = 5, },
		{ name = 'WEAPON_FLASHLIGHT', price = 200 },
		{ name = 'WEAPON_NIGHTSTICK', price = 100 },
		{ name = 'WEAPON_PISTOL', price = 500, metadata = { registered = true, serial = 'POL' }, license = 'weapon' },
		{ name = 'WEAPON_CARBINERIFLE', price = 1000, metadata = { registered = true, serial = 'POL' }, license = 'weapon', grade = 3 },
		{ name = 'WEAPON_STUNGUN', price = 500, metadata = { registered = true, serial = 'POL'} }
	}, locations = {
		vector3(487.235, -997.108, 30.69)
	}, targets = {
		{ loc = vector3(487.235, -997.108, 30.69), length = 0.5, width = 3.0, heading = 60.0, minZ = 29.0, maxZ = 31.0, distance = 6 }
	}
}

Data.Medicine = {
	name = 'Medicine Cabinet',
	job = 'ambulance',
	blip = {
		id = 403, colour = 69, scale = 0.6
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