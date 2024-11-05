
---wip types

---@class OxStash
---@field name string
---@field label string
---@field owner? boolean | string | number
---@field slots number
---@field weight number
---@field groups? string | string[] | { [string]: number }
---@field blip? { id: number, colour: number, scale: number }
---@field coords? vector3
---@field target? { loc: vector3, length: number, width: number, heading: number, minZ: number, maxZ: number, distance: number, debug?: boolean, drawSprite?: boolean }

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

	{
		coords = vec3(-513.16, -32.99, 45.70),
		target = {
			loc = vec3(-512.5, -33.0, 45.8),
			length = 0.8,
			width = 1.0,
			heading = 356.5,
			minZ = 43.34,
			maxZ = 44.74,
			label = 'Lager öffnen'
		},
		name = 'lager_teapot',
		label = 'Teapot Lager',
		owner = false,
		slots = 70,
		weight = 150000,
		groups = {['teapot'] = 0}
	},

	{
		coords = vec3(-1569.67, -376.19, 38.09),
		target = {
			loc = vec3(-1570.41, -375.43, 38.09),
			length = 1.9,
			width = 1.1,
			heading = 316.0,
			minZ = 37.09,
			maxZ = 38.29,
			label = 'Lager öffnen'
		},
		name = 'lager_bloods',
		label = 'Bloods Lager',
		owner = false,
		slots = 70,
		weight = 250000,
		groups = {['bloods'] = 0}
	},

	{
		coords = vec3(-315.04,-2698.05,7.55),
		target = {
			loc = vec3(-315.04, -2698.05, 6.55),
			length = 1.0,
			width = 1.0,
			heading = 45.0,
			minZ = 5.55,
			maxZ = 7.55,
			label = 'Lager öffnen'
		},
		name = 'lager_volky1',
		label = 'Volky Lager',
		owner = false,
		slots = 140,
		weight = 540000,
		groups = {['volky'] = 0}
	},

	{
		coords = vec3(-292.97,-2689.93,6.34),
		target = {
			loc = vec3(-292.97, -2689.93, 5.34),
			length = 1.0,
			width = 1.0,
			heading = 315.00,
			minZ = 4.34,
			maxZ = 6.34,
			label = 'Lager öffnen'
		},
		name = 'lager_volky2',
		label = 'Volky Lager 2',
		owner = false,
		slots = 70,
		weight = 280000,
		groups = {['volky'] = 0}
	},

	{
		coords = vec3(266.5, -999.4, -99.01),
		target = {
			loc = vec3(266.5, -999.4, -99.01),
			length = 1.6,
			width = 0.6,
			heading = 359.0,
			minZ = -100.21,
			maxZ = -98.41,
			label = 'Lager öffnen'
		},
		name = 'lager_ipl',
		label = 'Lager',
		owner = true,
		slots = 70,
		weight = 250000
	},

	{
		coords = vec3(2894.22, 4374.49, 50.33),
		target = {
			loc = vec3(2894.22, 4374.49, 50.33),
			length = 2.8,
			width = 0.6,
			heading = 24.0,
			minZ = 49.43,
			maxZ = 52.43,
			label = 'Lager öffnen'
		},
		name = 'job_stash_9',
		label = 'Brauerei Lager',
		owner = false,
		slots = 70,
		weight = 1000000,
		groups = {['brauerei'] = 0}
	},

	{ --GWA
		coords = vec3(934.8,-1460.9,33.61),
		target = {
			loc = vec3(934.31, -1460.21, 33.61),
			length = 1.0,
			width = 1.0,
			heading = 305,
			minZ = 32.61,
			maxZ = 34.61,
			label = 'Öffne Tresor'
		},
		name = 'gwa_tresor',
		label = 'GWA Tresor',
		owner = false,
		slots = 10,
		weight = 70000,
		groups = {['gwa'] = 11}
	},

	{ --GWA
		coords = vec3(946.23,-1481.74,30.4),
		target = {
			loc = vec3(947.99, -1481.96, 30.4),
			length = 2.2,
			width = 1.8,
			heading = 355,
			minZ = 29.4,
			maxZ = 32.6,
			label = 'Öffne Sammel Lager'
		},
		name = 'gwa_lager',
		label = 'GWA Sammel Lager',
		owner = false,
		slots = 120,
		weight = 800000,
		groups = {['gwa'] = 0}
	},

	{ --GWA
		coords = vec3(945.09, -1476.13, 29.1),
		target = {
			loc = vec3(945.09, -1476.13, 29.1),
			length = 2.0,
			width = 1.8,
			heading = 0,
			minZ = 28.7,
			maxZ = 30.0,
			label = 'Öffne Schmuck Lager'
		},
		name = 'gwa_schmuck',
		label = 'GWA Schmuck Lager',
		owner = false,
		slots = 70,
		weight = 300000,
		groups = {['gwa'] = 0}
	},

	{ --GWA
		coords = vec3(936.48, -1466.54, 30.1),
		target = {
			loc = vec3(936.48, -1466.54, 29.1),
			length = 1.0,
			width = 1.8,
			heading = 20,
			minZ = 29.10,
			maxZ = 30.10,
			label = 'Öffne Ankaufs Lager'
		},
		name = 'gwaankauf',
		label = 'GWA Ankauf',
		owner = false,
		slots = 90,
		weight = 1000000,
		groups = {['gwa'] = 9}
	},

	--[[{ --GWA EXPORT-Ankauf
		coords = vec3(1227.25, -3283.69, 5.5),
		target = {
			loc = vec3(1227.25, -3283.69, 5.5),
			length = 1.0,
			width = 1.6,
			heading = 0,
			minZ = 4.7,
			maxZ = 6.5,
			label = 'Öffne EXPORT-Ankauf Lager'
		},
		name = 'exportlager',
		label = 'Ankauf Export Lager',
		owner = false,
		slots = 90,
		weight = 1000000,
		groups = {['gwa'] = 11}
	},]]

	{ --GWA
		coords = vec3(945.09, -1476.13, 30.5),
		target = {
			loc = vec3(944.91, -1476.16, 30.5),
			length = 2.2,
			width = 1.8,
			heading = 0,
			minZ = 31.5,
			maxZ = 32.6,
			label = 'Öffne Falschgeld Lager'
		},
		name = 'gwafalschgeld',
		label = 'GWA Falschgeld',
		owner = false,
		slots = 30,
		weight = 200000,
		groups = {['gwa'] = 0}
	},

	{ --GWA
		coords = vec3(944.84, -1473.38, 29.1),
		target = {
			loc = vec3(944.84, -1473.38, 29.1),
			length = 2.2,
			width = 1.6,
			heading = 0,
			minZ = 28.7,
			maxZ = 30.0,
			label = 'Öffne Drogen Lager'
		},
		name = 'gwadrogen',
		label = 'GWA Drogen',
		owner = false,
		slots = 70,
		weight = 200000,
		groups = {['gwa'] = 0}
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
		coords = vec3(264.14,-879.66,28.12),
		target = {
			loc = vec3(264.12, -879.75, 29.15),
			length = 0.8,
			width = 0.6,
			heading = 339,
			minZ = 28.35,
			maxZ = 29.55,
			label = 'psst...'
		},
		name = 'TBriefkastenWP',
		label = 'psst...',
		owner = false,
		slots = 2,
		weight = 50
	},
	{
		coords = vec3(720.34, -972.36, 30.4),
		target = {
			loc = vec3(720.34, -972.36, 30.4),
			length = 1.0,
			width = 1.0,
			heading = 0,
			minZ = 30.2,
			maxZ = 31.2,
			label = 'Schneiderlein'
		},
		name = 'Schneider Lager Any',
		label = 'Klein aber fein',
		owner = true,
		slots = 10,
		weight = 200000
	},
	{  -- Out of Order, aber wird bestimmt noch benötigt.
		coords = vec3(961.2563,-1543.6,-29.72),
		target = {
			loc = vec3(961.2563,-1543.6,-29.72),
			length = 1.5,
			width = 1.5,
			heading = 0,
			minZ = 29.2,
			maxZ = 31.2,
			label = 'Johnsonlager'
		},
		name = 'johnsonlager',
		label = 'Johnsonlager',
		owner = true,
		slots = 10,
		weight = 100000
	},
	{
		coords = vec3(-266.3508,233.9774,89.76888),
		target = {
			loc = vec3(-266.3508,233.9774,89.76888),
			length = 1.5,
			width = 1.5,
			heading = 0,
			minZ = 88.5,
			maxZ = 90.5,
			label = 'Verkaufslager'
		},
		name = 'pawnsellstash',
		label = 'Verkaufslager',
		owner = false,
		slots = 100,
		weight = 500000,
		groups = {['gwa'] = 10}
	},
	{
		coords = vec3(-264.8761,234.0471,89.56666),
		target = {
			loc = vec3(-264.8761,234.0471,89.56666),
			length = 1.5,
			width = 1.5,
			heading = 0,
			minZ = 88.5,
			maxZ = 90.5,
			label = 'Lager'
		},
		name = 'pawnstash',
		label = 'Lager',
		owner = false,
		slots = 100,
		weight = 500000,
		groups = {['gwa'] = 10}
	},
	{
		coords = vec3(-348.93,-160.12,38.01),
		target = {
			loc = vec3(-348.93,-160.12,38.01),
			length = 1.5,
			width = 1.5,
			heading = 0,
			minZ = 37.1,
			maxZ = 39.5,
			label = 'Lager'
		},
		name = 'lsclager01',
		label = 'Lager',
		owner = false,
		slots = 100,
		weight = 500000,
		groups = {['lsc'] = 1}
	},
	{
		coords = vec3(281.8080, -1010.0781, 28.1627),
		target = {
			loc = vec3(281.8080, -1010.0781, 28.1627),
			length = 1.5,
			width = 1.5,
			heading = 0,
			minZ = 29.1,
			maxZ = 31.5,
			label = 'Pipe Lager'
		},
		name = 'pipedownlager01',
		label = 'Lager',
		owner = false,
		slots = 100,
		weight = 500000,
		groups = {['pipedown'] = 1}
	},
	{
		coords = vec3(-1202.347,-892.0333,13.69917),
		target = {
			loc = vec3(-1202.347,-892.0333,13.69917),
			length = 1.5,
			width = 1.5,
			heading = 40.01066,
			minZ = 13.1,
			maxZ = 14.5,
			label = 'Burgershot Lager'
		},
		id = 'burgershotlager',
		name = 'burgershotlager',
		label = 'Lager',
		owner = false,
		slots = 100,
		weight = 500000
	},
	{
		coords = vec3(-1196.727,-895.5957,13.59235),
		target = {
			loc = vec3(-1196.727,-895.5957,13.59235),
			length = 1.5,
			width = 1.5,
			heading = 123.3694,
			minZ = 13.7,
			maxZ = 15.7,
			label = 'Burgershot Kasse'
		},
		id = 'burgershotkasse',
		name = 'burgershotkasse',
		label = 'Kasse',
		owner = 'char1:22bbbb7f22a0918c342540d3559dc4bf5a74cf48',
		slots = 2,
		weight = 500
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
