return {
	{ --ID-TABLE: 1 Weed
	items = {
		{
			name = 'afghan',
			ingredients = {
				afghandry = 20
			},
			duration = 60000,
			count = 10,
		},
		{
			name = 'afghan_joint',
			ingredients = {
				afghan = 20,
				eblaettchen = 20
			},
			duration = 60000,
			count = 10,
		},
	}
	},
	{ --ID-TABLE: 2 Kokain
		items = {
			{
				name = 'kokapaste',
				ingredients = {
					kokablatt = 20
				},
				duration = 60000,
				count = 10,
			},
			{
				name = 'kokain',
				ingredients = {
					kokapaste = 20
				},
				duration = 60000,
				count = 20,
			},
		}
	},

	{ --ID:3 Cayo Kokatable 03
		items = {
			{
				name = 'kokapaste',
				ingredients = {
					kokablatt = 20
				},
				duration = 60000,
				count = 10,
			},
			{
				name = 'kokain',
				ingredients = {
					kokapaste = 20
				},
				duration = 60000,
				count = 20,
			},
		},
		points = {
			vec3(5212.926,-5130.925,6.0081)
		},
		zones = {
			{
				coords = vec3(5212.926,-5130.925,6.008),
				size = vec3(1.5, 1.5, 1.5),
				distance = 5.5,
				rotation = 0.0,
			},
		},
		blip = { id = 467, colour = 1, scale = 0.5 },
	},
	{ --ID:4 Falschgeld Schnittstation Triads
		items = {
			{
				name = 'frische5dollarfalsch',
				ingredients = {
					blatt5dollarnoten = 1
				},
				duration = 120000,
				count = {12,35},
			},
		},
		points = {
			vec3(1122.0965, -3198.5737, -40.4030)
		},
		zones = {
			{
				coords = vec3(1122.0965, -3198.5737, -40.4030),
				size = vec3(1.5, 1.5, 1.5),
				distance = 3.0,
				rotation = 0.0,
			},
		},
		--blip = { id = 467, colour = 1, scale = 0.5 },
	},
	{ --ID:5 tuch, aramid, farbfasern
		items = {
			{
				name = 'tuch',
				ingredients = {
					wolle = 20
				},
				duration = 20000,
				count = {1,2},
			},
			{
				name = 'aramid',
				ingredients = {
					aramidfasern = 20
				},
				duration = 20000,
				count = {1,2},
			},
			{
				name = 'farbfasern',
				ingredients = {
					farbe = 2,
					wolle = 4,
				},
				duration = 20000,
				count = {1,2},
			},
		},
		points = {
			vec3(718.7047, -963.1607, 30.5998)
		},
		zones = {
			{
				coords = vec3(718.7047, -963.1607, 30.5998),
				size = vec3(1.0, 1.0, 1.0),
				distance = 2.0,
				rotation = 0.0,
			},
		},
		blip = { id = 651, colour = 2, scale = 0.5 },
	},
	{ --ID:6 bandage, kevlar
		items = {
			{
				name = 'kevlars',
				ingredients = {
					tuch = 5,
					aramid = 10,
				},
				duration = 30000,
				count = {1,2},
			},
			{
				name = 'kevlarm',
				ingredients = {
					tuch = 8,
					aramid = 14,
				},
				duration = 350000,
				count = {1,2},
			},
			{
				name = 'kevlar',
				ingredients = {
					tuch = 12,
					aramid = 20,
				},
				duration = 40000,
				count = {1,2},
			},
			{
				name = 'bandage',
				ingredients = {
					tuch = 5,
				},
				duration = 15000,
				count = {1,2},
			},
		},
		points = {
			vec3(714.2952, -972.1632, 30.3924)
		},
		zones = {
			{
				coords = vec3(714.2952, -972.1632, 30.3924),
				size = vec3(1.0, 1.0, 1.0),
				distance = 2.0,
				rotation = 0.0,
			},
		},
		--blip = { id = 651, colour = 2, scale = 0.5 },
	},
	{ --ID:7 kautschuck, gummi, plastik
		items = {
			{
				name = 'gummi',
				ingredients = {
					kautschuk = 5
				},
				duration = 18000,
				count = {1,2},
			},
			{
				name = 'plastik',
				ingredients = {
					kautschuk = 1,
					gummi = 3,
				},
				duration = 30000,
				count = {1,2},
			},
			{
				name = 'holzfasern',
				ingredients = {
					holz = 2,
				},
				duration = 30000,
				count = {1,2},
			},
		},
		points = {
			vec3(1812.7816, 4604.3369, 37.5922)
		},
		zones = {
			{
				coords = vec3(1812.7816, 4604.3369, 37.5922),
				size = vec3(4, 4, 4),
				distance = 8.0,
				rotation = 0.0,
			},
		},
		blip = { id = 651, colour = 2, scale = 0.5 },
	},
	{ --ID:8 Afghandry Zuschneiden
		items = {
			{
				name = 'afghan',
				ingredients = {
					afghandry = 1
				},
				duration = 12000,
				count = {2, 3},
			},
		},
		points = {
			vec3(1033.7921, -3206.0498, -38.1231)
		},
		zones = {
			{
				coords = vec3(1033.7921, -3206.0498, -38.1231),
				size = vec3(1.5, 1.5, 1.5),
				distance = 3.0,
				rotation = 0.0,
			},
		},
		--blip = { id = 467, colour = 1, scale = 0.5 },
	},
	{ --ID:8 Joint drehen/packen
	items = {
		{
			name = 'afghan_joint',
			ingredients = {
				afghan = 2,
				eblaettchen = 2
			},
			duration = 5000,
			count = 1,
		},
	},
	points = {
		vec3(1038.3824, -3205.8552, -38.1231)
	},
	zones = {
		{
			coords = vec3(1038.3824, -3205.8552, -38.1231),
			size = vec3(1.5, 1.5, 1.5),
			distance = 3.0,
			rotation = 0.0,
		},
	},
	--blip = { id = 467, colour = 1, scale = 0.5 },
	},
	{
		items = {
			{
				name = 'gewuerz',
				ingredients = {
					zwiebel = 4
				},
				duration = 8000,
				count = 2,
			},
			{
				name = 'saft',
				ingredients = {
					apfel = 2,
					orange = 2
				},
				duration = 8000,
				count = {1,2},
			},
			{
				name = 'sauce',
				ingredients = {
					tomate = 4
				},
				duration = 8000,
				count = {1,2},
			},
			{
				name = 'salatgeschnitten',
				ingredients = {
					salat = 3
				},
				duration = 8000,
				count = {3,4},
			},
		},
		points = {
			vec3(2516.596, 4215.706, 39.933)
		},
		zones = {
			{
				coords = vec3(2516.596, 4215.706, 39.933),
				size = vec3(1.5, 1.5, 1.5),
				distance = 3.0,
				rotation = 0.0,
			},
		},
		blip = { id = 651, colour = 2, scale = 0.5 },
	},
}
