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
		coords = vec3(301.3, -600.23, 43.28),
		target = {
			loc = vec3(301.82, -600.99, 43.29),
			length = 0.6,
			width = 1.8,
			heading = 340,
			minZ = 43.34,
			maxZ = 44.74,
			label = 'Open personal locker'
		},
		name = 'emslocker',
		label = 'Personal Locker',
		owner = true,
		slots = 70,
		weight = 70000,
		groups = {['ambulance'] = 0}
	},

	{--Example of a stash that items do not degrade in. Could be used as refrigerator or long term storage for items that degrade over time?
		coords = vec3(32.44, -1342.32, 29.48),
		target = {
			loc = vec3(32.44, -1342.32, 29.48),
			length = 3.6,
			width = 1.8,
			heading = 3.8,
			minZ = 29.0,
			maxZ = 30.74,
			label = 'Open Cooler'
		},
		name = '247Cooler',
		label = 'Cooler',
		owner = false,
		slots = 70,
		weight = 70000,
		degrade = false --This is the flag to disable item degrading in this stash
	},
}
