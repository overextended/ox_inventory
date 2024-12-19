
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
