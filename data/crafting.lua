return {
	{
		items = {
			{
				name = 'lockpick',
				ingredients = {
					garbage = 3,
					WEAPON_HAMMER = 0.1
				},
				duration = 5000,
				amount = 3,
				metadata = { durability = 20 }
			},
			{
				name = 'garbage',
				ingredients = {
					cola = 1
				},
				metadata = { description = 'An empty soda can.', weight = 20, image = 'trash_can' }
			},
		},
		points = {
			vec3(-1147.083008, -2002.662109, 13.180260),
		},
		zones = {
			{
				coords = vec3(-1146.2, -2002.05, 13.2),
				size = vec3(3.8, 1.05, 0.15),
				distance = 1.5,
				rotation = 315.0,
			},
		},
		blip = { id = 566, colour = 31, scale = 0.8 },
	},
}
