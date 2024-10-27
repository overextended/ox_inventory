return {
	{ --ID-TABLE: 1 Weed
		items = {
			{
				name = 'afghan',
				ingredients = {
					afghanzweig = 20
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
	{ -- ID:1 Schmelze
		items = {
			{
				name = 'eisenbarren',
				ingredients = {
					eisenerz = 20,
					kohle = 5,
				},
				duration = 60000,
				count = 10,
			},
			{
				name = 'kupferbarren',
				ingredients = {
					kupfererz = 20,
					kohle = 5,
				},
				duration = 60000,
				count = 10,
			},
			{
				name = 'silberbarren',
				ingredients = {
					silbererz = 30,
					kohle = 3,
				},
				duration = 60000,
				count = 8,
			},
			{
				name = 'goldbarren',
				ingredients = {
					golderz = 25,
					kohle = 3,
				},
				duration = 60000,
				count = 5,
			},
			{
				name = 'bleibarren',
				ingredients = {
					bleierz = 20,
					kohle = 3,
				},
				duration = 60000,
				count = 10,
			},{
				name = 'aluminiumbarren',
				ingredients = {
					bauxit = 25,
					kohle = 5,
				},
				duration = 60000,
				count = 10,
			},
		},
		points = {
			vec3(1109.89, -2008.25, 31.06)
		},
		zones = {
			{
				coords = vec3(1109.89, -2008.25, 31.06),
				size = vec3(3.8, 2.05, 2.15),
				distance = 2.0,
				rotation = 0.0,
			},
		},
		blip = { id = 467, colour = 2, scale = 0.5 },
	},
	{ -- ID:2 Schmelze2
		items = {
			{
				name = 'eisenbarren',
				ingredients = {
					eisenschrott = 7
				},
				duration = 60000,
				count = 13,
			},
			{
				name = 'kupferbarren',
				ingredients = {
					kupferschrott = 7
				},
				duration = 60000,
				count = 13,
			},
			{
				name = 'glas',
				ingredients = {
					altglas = 4
				},
				duration = 60000,
				count = 6,
			},
			{
				name = 'plastik',
				ingredients = {
					plastikmuell = 7
				},
				duration = 60000,
				count = 6,
			},
		},
		points = {
			vec3(1086.9218, -2004.2457, 31.3743)
		},
		zones = {
			{
				coords = vec3(1086.9218, -2004.2457, 31.3743),
				size = vec3(3.8, 2.05, 2.15),
				distance = 2.0,
				rotation = 0.0,
			},
		}
		--blip = { id = 467, colour = 2, scale = 0.0 },
	},
	{ --ID:3 Kieswerk Steinverarbeitung
		items = {
			{
				name = 'sand',
				ingredients = {
					stein = 25
				},
				duration = 60000,
				count = 10,
			},
			{
				name = 'kies',
				ingredients = {
					stein = 15
				},
				duration = 60000,
				count = 10,
			},
		},
		points = {
			vec3(303.9583, 2818.711, 42.23914)
		},
		zones = {
			{
				coords = vec3(303.9583, 2818.711, 42.23914),
				size = vec3(3.8, 5.05, 5.15),
				distance = 5.5,
				rotation = 0.0,
			},
		},
		blip = { id = 467, colour = 2, scale = 0.5 },
	},
	{ --ID:4 --Schneiderei
		items = {
			{
				name = 'tuch',
				ingredients = {
					wolle = 20
				},
				duration = 60000,
				count = 6,
			},
			{
				name = 'bandage',
				ingredients = {
					tuch = 10
				},
				duration = 60000,
				count = 5,
			},
			{
				name = 'aramid',
				ingredients = {
					aramidfasern = 40,
				},
				duration = 60000,
				count = 10,
			},
			{
				name = 'kevlars',
				ingredients = {
					aramid = 10,
					tuch = 2,
					aramidfasern = 2
				},
				duration = 60000,
				count = 1,
			},
			{
				name = 'kevlarm',
				ingredients = {
					aramid = 20,
					tuch = 4,
					aramidfasern = 3
				},
				duration = 60000,
				count = 1,
			},
			{
				name = 'kevlar',
				ingredients = {
					aramid = 30,
					tuch = 8,
					aramidfasern = 4
				},
				duration = 60000,
				count = 1,
			},
		},
		points = {
			vec3(713.2285, -972.3268, 30.3953)
		},
		zones = {
			{
				coords = vec3(713.2285, -972.3268, 30.3953),
				size = vec3(3.8, 5.05, 5.15),
				distance = 5.5,
				rotation = 0.0,
			},
		},
		blip = { id = 467, colour = 2, scale = 0.5 },
	},
	{ --ID:5 Farbproduktion
		items = {
			{
				name = 'farbe',
				ingredients = {
					indigo = 20
				},
				duration = 60000,
				count = 20,
			},
		},
		points = {
			vec3(1655.694,4820.89,41.98)
		},
		zones = {
			{
				coords = vec3(1655.694,4820.89,41.98),
				size = vec3(1.5, 1.5, 1.5),
				distance = 5.5,
				rotation = 0.0,
			},
		},
		blip = { id = 467, colour = 2, scale = 0.5 },
	},
	{ --ID:6 Bauernhof Verarbeiter
		items = {
			{
				name = 'mehl',
				ingredients = {
					getreide = 20
				},
				duration = 60000,
				count = 20,
			},
			{
				name = 'teig',
				ingredients = {
					mehl = 20,
					wasser5l = 1
				},
				duration = 60000,
				count = 15,
			},
			{
				name = 'sauce',
				ingredients = {
					tomate = 20
				},
				duration = 60000,
				count = 8,
			},
			{
				name = 'kaffeebohnenget',
				ingredients = {
					kaffeebohnen = 20
				},
				duration = 60000,
				count = 17,
			},
			{
				name = 'kaese',
				ingredients = {
					milch = 10
				},
				duration = 60000,
				count = 15,
			},
			{
				name = 'tabak',
				ingredients = {
					tabakblatt = 10
				},
				duration = 60000,
				count = 15,
			},
		},
		points = {
			vec3(1960.957, 4653.48, 40.7799)
		},
		zones = {
			{
				coords = vec3(1960.957, 4653.48, 40.7799),
				size = vec3(1.5, 1.5, 1.5),
				distance = 4.0,
				rotation = 0.0,
			},
		},
		blip = { id = 467, colour = 2, scale = 0.5 },
	},
	{ --ID:11 Cayo Kokatable 03
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
	{ --ID: 12GWA Drugtable01
		items = {
			{
				name = 'afghan',
				ingredients = {
					afghanzweig = 20
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
			}
		},
		points = {
			vec3(941.4359,-1460.1730,30.4007)
		},
		zones = {
			{
				coords = vec3(941.4359,-1460.1730,30.4007),
				size = vec3(1.5, 1.5, 1.5),
				distance = 5.5,
				rotation = 0.0,
			},
		},
		groups ={["gwa"]=0},
		--blip = { id = 467, colour = 1, scale = 0.0 },
	},
	{ -- ID: 13 Opium
		items = {
			{
				name = 'rohopium',
				ingredients = {
					mohn = 20
				},
				duration = 60000,
				count = 6,
			},
			{
				name = 'opium',
				ingredients = {
					rohopium = 12
				},
				duration = 60000,
				count = 20,
			},
		},
		points = {
			vec3(1389.805,3605.902,38.36157)
		},
		zones = {
			{
				coords = vec3(1389.805,3605.902,38.36157),
				size = vec3(1.5, 1.5, 1.5),
				distance = 5.5,
				rotation = 0.0,
			},
		},
		blip = { id = 467, colour = 1, scale = 0.5 },
	},
	{ --ID:14 Schlachterei City
		items = {
			{
				name = 'hackfleisch',
				ingredients = {
					rinderkeule = 1
				},
				duration = 30000,
				count = 20,
			},
		},
		points = {
			vec3(983.6545, -2111.26, 33.5151)
		},
		zones = {
			{
				coords = vec3(983.6545, -2111.26, 30.5151),
				size = vec3(1.5, 1.5, 1.5),
				distance = 5.5,
				rotation = 0.0,
			},
		},
		blip = { id = 467, colour = 2, scale = 0.5 },
	},
	{ --ID: 15 Sägewerk
		items = {
			{
				name = 'bretter',
				ingredients = {
					holz = 1
				},
				duration = 30000,
				count = 5,
			},
			{
				name = 'holzkiste',
				ingredients = {
					bretter = 12
				},
				duration = 30000,
				count = 1,
			},
			{
				name = 'papier',
				ingredients = {
					bretter = 3
				},
				duration = 30000,
				count = 10,
			},
			{
				name = 'blaettchen',
				ingredients = {
					papier = 3
				},
				duration = 30000,
				count = 2,
			},
			{
				name = 'paperbag',
				ingredients = {
					papier = 20
				},
				duration = 30000,
				count = 1,
			},
		},
		points = {
			vec3(-591.7764, 5342.365, 69.6569)
		},
		zones = {
			{
				coords = vec3(-591.7764, 5342.365, 69.6569),
				size = vec3(1.5, 1.5, 1.5),
				distance = 5.5,
				rotation = 0.0,
			},
		},
		blip = { id = 467, colour = 2, scale = 0.5 },
	},
	{ -- ID: 16 Schmuck Münzen Juwelier
		items = {
			{
				name = 'schmuck',
				ingredients = {
					goldbarren = 1,
					silberbarren = 1,
					diamond = 1
				},
				duration = 60000,
				count = 1,
			},
		},
		points = {
			vec3(-630.453, -230.5352, 38.0287)
		},
		zones = {
			{
				coords = vec3(-630.453, -230.5352, 38.0287),
				size = vec3(1.0, 1.0, 1.0),
				distance = 1.5,
				rotation = 0.0,
			},
		},
		blip = { id = 467, colour = 2, scale = 0.5 },
	},
	{ -- ID: 17 Pipe Down
		items = {
			{
				name = 'tabak',
				ingredients = {
					tabakblatt = 10
				},
				duration = 20000,
				count = 20,
			},
			{
				name = 'cigarette',
				ingredients = {
					tabakblatt = 10
				},
				duration = 20000,
				count = 20,
			},
			{
				name = 'cigar',
				ingredients = {
					tabakblatt = 10,
					tabak = 2,
				},
				duration = 20000,
				count = 10,
			},
		},
		points = {
			vec3(277.1918, -1010.4075, 29.2096)
		},
		zones = {
			{
				coords = vec3(277.1918, -1010.4075, 29.2096),
				size = vec3(1.0, 1.0, 1.0),
				distance = 1.5,
				rotation = 0.0,
			},
		},
		-- blip = { id = 467, colour = 2, scale = 0.5 },
		groups ={["pipedown"]=1},
	},
}