return {
	{
		coords = vec3(456.43, -987.72, 30.69),
		target = {
			loc = vec3(456.43, -987.72, 30.69),
			length = 0.45,
			width = 2.6,
			heading = 0,
			minZ = 30.09,
			maxZ = 32.14,
			label = 'Öffne persönlichen Spint'
		},
		name = 'policelocker',
		label = 'Persönlichen Spint',
		owner = true,
		slots = 70,
		weight = 70000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(485.44,-995.44,30.69),
		target = {
			loc = vec3(485.42, -994.77, 30.69),
			length = 0.4,
			width = 1.0,
			heading = 0,
			minZ = 29.69,
			maxZ = 31.69,
			label = 'Öffne Waffenlager'
		},
		name = 'policeweaponstorage1',
		label = 'Waffenschrank Polizei',
		owner = false,
		slots = 140,
		weight = 500000,
		groups = {['police'] = 3}
	},

	{
		coords = vec3(452.38,-980.11,30.69),
		target = {
			loc = vec3(453.03, -980.05, 30.69),
			length = 1.6,
			width = 0.6,
			heading = 0,
			minZ = 30.29,
			maxZ = 31.69,
			label = 'Öffne Waffenausgabe'
		},
		name = 'policeweapons1',
		label = 'Waffenausgabe Polizei',
		owner = false,
		slots = 140,
		weight = 500000,
		groups = {['police'] = 0}
	},

	{
		coords = vec3(306.05, -602.43, 43.28),
		target = {
			loc = vec3(306.05, -602.43, 43.28),
			length = 1.0,
			width = 1.2,
			heading = 340,
			minZ = 42.28,
			maxZ = 44.68,
			label = 'Öffne Krankenhaus-Apotheke'
		},
		name = 'apotheke',
		label = 'Apotheke',
		owner = false,
		slots = 140,
		weight = 300000,
		groups = {['ambulance'] = 0}
	},

	{ --Falschgeld // Triads ?? OX
		coords = vec3(1132.972, -3198.321, -41.221),
		target = {
			loc = vec3(1132.972, -3198.321, -41.221),
			length = 2.0,
			width = 2.0,
			heading = 0,
			minZ = -41.0,
			maxZ = -39.0,
			label = 'Öffne Druckerpresse'
		},
		name = 'fgpresseanfang',
		label = 'Falschgeldpresse',
		owner = false,
		slots = 5,
		weight = 200000,
		groups = {['triads'] = 1}
	},

	{ --Falschgeld // Triads ?? OX
		coords = vec3(1126.030, -3198.294, -41.048),
		target = {
			loc = vec3(1126.030, -3198.294, -41.048),
			length = 2.0,
			width = 2.0,
			heading = 0,
			minZ = -41.0,
			maxZ = -39.0,
			label = 'Öffne Druckerpresse'
		},
		name = 'fgpresseende',
		label = 'Falschgeldpresse Ausgabe',
		owner = false,
		slots = 2,
		weight = 200000,
		groups = {['triads'] = 1}
	},

	{ --Falschgeld Wäsche // Triads ?? OX
		coords = vec3(1122.3732, -3193.4743, -41.4030),
		target = {
			loc = vec3(1122.3732, -3193.4743, -41.4030),
			length = 2.0,
			width = 2.0,
			heading = 0,
			minZ = -38.0,
			maxZ = -42.0,
			label = 'Befülle die Waschmaschine'
		},
		name = 'fgwaschanfang',
		label = 'Waschmaschine',
		owner = false,
		slots = 2,
		weight = 120000,
		groups = {['triads'] = 1}
	},

	{ --Falschgeld Wäsche // Triads ?? OX
		coords = vec3(1126.9450, -3193.3142, -41.4030),
		target = {
			loc = vec3(1126.9450, -3193.3142, -41.4030),
			length = 2.0,
			width = 2.0,
			heading = 0,
			minZ = -38.0,
			maxZ = -42.0,
			label = 'Leere die Waschmaschine'
		},
		name = 'fgwaschende',
		label = 'Waschmaschine',
		owner = false,
		slots = 2,
		weight = 140000,
		groups = {['triads'] = 1}
	},

	{ --Falschgeld // Triads ?? OX
		coords = vec3(1139.0526, -3193.9165, -40.9904),
		target = {
			loc = vec3(1139.0526, -3193.9165, -40.9904),
			length = 2.0,
			width = 2.0,
			heading = 0,
			minZ = -41.0,
			maxZ = -39.0,
			label = 'Öffne Lager'
		},
		name = 'fgtriadslager',
		label = 'Lager',
		owner = false,
		slots = 30,
		weight = 100000,
		groups = {['triads'] = 1}
	},

	{
		coords = vec3(360.69, -1384.66, 32.43),
		target = {
			loc = vec3(360.69, -1384.66, 32.43),
			length = 2.0,
			width = 1.4,
			heading = 51,
			minZ = 31.43,
			maxZ = 33.03,
			label = 'Öffne Lager'
		},
		name = 'EMS Lager LS',
		label = 'Lager',
		owner = false,
		slots = 70,
		weight = 1000000,
		groups = {['ambulance'] = 0}
	},

	{
		coords = vec3(364.87, -1406.66, 32.94),
		target = {
			loc = vec3(364.87, -1406.66, 32.94),
			length = 2.8,
			width = 1.0,
			heading = 50,
			minZ = 31.94,
			maxZ = 34.14,
			label = 'Öffne Lager'
		},
		name = 'EMS LS PersSpint',
		label = 'Lager',
		owner = true,
		slots = 70,
		weight = 120000,
		groups = {['ambulance'] = 0}
	},

	{
		coords = vec3(1036.3435, -3202.9565, -39.1231),
		target = {
			loc = vec3(1036.3435, -3202.9565, -39.1231),
			length = 1.0,
			width = 1.0,
			heading = 0,
			minZ = -41.94,
			maxZ = -38.14,
			label = 'Öffne Trocknung'
		},
		name = 'vagos_feuchtablage',
		label = 'Trocknung',
		owner = false,
		slots = 5,
		weight = 40000,
		groups = {['vagos'] = 0}
	},

	{
		coords = vec3(1033.7821, -3202.9565, -39.1231),
		target = {
			loc = vec3(1033.7821, -3202.9565, -39.1231),
			length = 1.0,
			width = 1.0,
			heading = 0,
			minZ = -41.94,
			maxZ = -38.14,
			label = 'Öffne Getrocknetes'
		},
		name = 'vagos_trocken',
		label = 'Getrocknetes',
		owner = false,
		slots = 6,
		weight = 50000,
		groups = {['vagos'] = 0}
	},
	---------- Staatliche Lager ----------
	{
		name = 'staatslager01', --legales
		label = 'Staatslager 01',
		slots = 50,
		weight = 1000000,
	},
	{
		name = 'staatslager02', --illegales
		label = 'Staatslager 02',
		slots = 50,
		weight = 1000000,
	},

	---------- Lagerräume ----------
	{
		name = 'lager01',
		label = 'Lager 01',
		slots = 30,
		weight = 400000,
	},
	{
		name = 'lager02',
		label = 'Lager 02',
		slots = 40,
		weight = 600000,
	},
	{
		name = 'lager03',
		label = 'Lager 03',
		slots = 32,
		weight = 380000,
	},
	{
		name = 'lager04',
		label = 'Lager 04',
		slots = 50,
		weight = 1000000,
	},
	{
		name = 'lager05',
		label = 'Lager 05',
		slots = 30,
		weight = 400000,
	},
	{
		name = 'lager06',
		label = 'Lager 06',
		slots = 30,
		weight = 400000,
	},
	{
		name = 'lager07',
		label = 'Lager 07',
		slots = 30,
		weight = 420000,
	},
	{
		name = 'lager08',
		label = 'Lager 08',
		slots = 30,
		weight = 400000,
	},
	{
		name = 'lager09',
		label = 'Lager 09',
		slots = 35,
		weight = 480000,
	},
	{
		name = 'lager10',
		label = 'Lager 10',
		slots = 35,
		weight = 480000,
	},

	--[[{
		coords = vec3(62.5555, -1004.9807, 28.3574),
		target = {
			loc = vec3(62.5555, -1004.9807, 28.3574),
			length = 1.5,
			width = 1.5,
			heading = 0.0,
			minZ = 27.7,
			maxZ = 29.7,
			label = 'TestLager'
		},
		id = 'testlager',
		name = 'testlager',
		label = 'Lager',
		owner = false,
		slots = 10,
		weight = 500000
	},]]
}
