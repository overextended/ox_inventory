return {
	{
		coords = vec3(452.3, -991.4, 30.7),
		target = {
			loc = vec3(451.25, -994.28, 30.69),
			length = 1.2,
			width = 5.6,
			heading = 0,
			minZ = 29.49,
			maxZ = 32.09,
			label = 'Open personal locker'
		},
		name = 'policelocker',
		label = 'Personal locker',
		owner = true,
		slots = 70,
		weight = 70000,
		groups = shared.police
	},
	{
		coords = vec3(310.45, -603.4, 42.51),
		target = {
			loc = vec3(310.45, -603.4, 42.51),
			length = 1.2,
			width = 5.6,
			heading = 340,
			minZ = 42.34,
			maxZ = 45.74,
			label = 'Open personal locker'
		},
		name = 'emslocker',
		label = 'Personal Locker',
		owner = true,
		slots = 70,
		weight = 500000,
		groups = {['ambulance'] = 0}
	},
}
