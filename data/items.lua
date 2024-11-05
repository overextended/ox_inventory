return {
	-- Anfang Container Items
	['wallet'] = {
		label = 'Portemonaie',
		weight = 30,
		stack = false,
		close = false,
		description = 'Zur Aufbewahrung von Karten'
	},
	['schluesselring'] = {
		label = 'Schlüsselring',
		weight = 1,
		stack = false,
		close = false,
		description = 'zum Schlüssel sammeln'
	},
	['holzkiste'] = {
		label = 'Holzkiste',
		weight = 2000,
		stack = true,
		close = true,
		description = 'Handelsgut'
	},
	['holzkiste2'] = {
		label = 'Erw. Holzkiste',
		weight = 4000,
		stack = false,
		close = false,
		description = 'Lagerbehälter',
		buttons = {
			{
				label = 'Anpassen',
				action = function(slot)
					TriggerEvent('mor_box:inputmenu', slot)
				end
			},
		},
		consume = 0
	},
	['paperbag'] = {
		label = 'Papiertüte',
		weight = 1,
		stack = false,
		close = false,
		consume = 0
	},
	-- Ende Container Items

	-- Anfang Essen Items useable
	['burger'] = {
		label = 'Burger',
		weight = 220,
		degrade = 1449,
		client = {
			status = { hunger = 330000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'sieht besser aus als er schmeckt.'
		},
	},
	['obstsalat'] = {
		label = 'Obstsalat',
		weight = 600,
		stack = true,
		close = true,
		degrade = 720,
		notification = nil,
		client = {
			status = { hunger = 480000, thirst = 80000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'apa_prop_cs_plastic_cup_01', pos = vec3(0.01, 0.01, 0.01), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 3500,
			cancel = true
		}
	},
	['brot'] = {
		label = 'Brot',
		weight = 150,
		stack = true,
		close = true,
		degrade = 1449,
		description = nil,
		client = {
			status = { hunger = 180000 },
			anim = 'eating',
			prop = 'sandwich',
			usetime = 2500
		},
	},
	['cheeseburger'] = {
		label = 'Cheeseburger',
		weight = 170,
		stack = true,
		close = true,
		degrade = 1449,
		description = nil,
		client = {
			status = { hunger = 260000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 3000
		},
	},
	['chickenburger'] = {
		label = 'Chickenburger',
		weight = 340,
		stack = true,
		close = true,
		degrade = 1449,
		description = nil,
		client = {
			status = { hunger = 400000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 3200
		},
	},
	['chips'] = {
		label = 'Chips',
		weight = 175,
		stack = true,
		close = true,
		degrade = 1449,
		description = nil,
		client = {
			status = { hunger = 130000 },
			anim = 'eating',
			prop = 'xs_prop_chips_tube_wl',
			usetime = 2000
		},
	},
	['pommes'] = {
		label = 'Pommes',
		weight = 360,
		stack = true,
		close = true,
		description = nil,
		degrade = 340,
		client = {
			status = { hunger = 250000 },
			anim = 'eating',
			prop = '',
			usetime = 2500
		}
	},
	['sandwich'] = {
		label = 'Sandwich',
		weight = 400,
		stack = true,
		close = true,
		degrade = 1449,
		description = 'Lecker Sandwich',
		client = {
			status = { hunger = 280000 },
			anim = 'eating',
			prop = 'sandwich',
			usetime = 2500,
			notification = 'Du hast ein leckeres Sandwich gegessen'
		},
	},
	['hotdog'] = {
		label = 'Hotdog',
		weight = 180,
		stack = true,
		close = true,
		degrade = 1440,
		description = nil,
		client = {
			status = { hunger = 360000 },
			anim = 'eating',
			prop = 'hotdog',
			usetime = 2500,
			notification = 'Lecker Hotdog'
		},
	},
	['apfelkuchen'] = {
		label = 'Stück Apfelkuchen',
		stack = false,
		weight = 600,
		degrade = 250,
		close = true,
		client = {
			status = { hunger = 370000, thirst = 20000, drunk = -3000 },
			--anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			--prop = { model = 'prop_ld_flow_bottle', pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 5000,
			cancel = true,
			notification = 'Hmmm, schmeckt wie selber gemacht.'
		}
	},
	['nusstorte'] = {
		label = 'Stück Nusstorte',
		stack = false,
		weight = 600,
		degrade = 250,
		close = true,
		client = {
			status = { hunger = 350000, thirst = 10000, drunk = -3000 },
			--anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			--prop = { model = 'prop_ld_flow_bottle', pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 5000,
			cancel = true,
			notification = 'Hmmm, schmeckt wie selber gemacht.'
		}
	},
	['taco'] = {
		label = 'Taco',
		weight = 500,
		stack = true,
		close = true,
		client = {
			status = { hunger = 320000 },
			anim = 'eating',
			prop = 'taco',
			usetime = 3000,
			cancel = true,
		}
	},
	['chilaquiles'] = {
		label = 'Chilaquiles',
		weight = 1200,
		stack = false,
		close = true,
		description = nil,
		client = {
			status = { hunger = 320000 },
			anim = 'eating',
			prop = { model = 'prop_taco_02', pos = vec3(0.01, 0.01, 0.06), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 3000,
			cancel = true,
		}
	},
	['pizza_hawaii'] = {
		label = 'Pizza Hawaii',
		weight = 1200,
		stack = false,
		close = true,
		description = nil,
		client = {
			status = { hunger = 370000 },
			anim = 'eating',
			prop = { model = 'prop_taco_02', pos = vec3(0.01, 0.01, 0.06), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 3000,
			cancel = true,
		}
	},
	['pizza_tonno'] = {
		label = 'Pizza Thunfisch',
		weight = 1200,
		stack = false,
		close = true,
		description = nil,
		client = {
			status = { hunger = 310000 },
			anim = 'eating',
			prop = { model = 'prop_taco_02', pos = vec3(0.01, 0.01, 0.06), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2900,
			cancel = true,
			--notification = 'Lecker Tee, der ist echt gut'
		}
	},
	['pizza_diavolo'] = {
		label = 'Pizza Teuflisch',
		weight = 1500,
		stack = false,
		close = true,
		description = nil,
		client = {
			status = { hunger = 310000 },
			anim = 'eating',
			prop = { model = 'prop_taco_02', pos = vec3(0.01, 0.01, 0.06), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 3800,
			cancel = true,
		}
	},
	['bleeder'] = {  --- Exclusiv Burgershot
		label = 'Bleeder',
		weight = 210,
		stack = true,
		close = true,
		degrade = 1449,
		description = nil,
		client = {
			status = { hunger = 350000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2800
		},
		metadata = {image = 'burger'}
	},
	-- Ende Essen Items useable

	-- Anfang Trinken Items useable
	['cola'] = {
		label = 'eCola',
		weight = 350,
		degrade = 1449,
		client = {
			status = { thirst = 250000 },
			anim = 'drinking',
			prop = 'ecola',
			usetime = 2000
		}
	},
	['wasser'] = {
		label = 'Wasser',
		weight = 330,
		degrade = 1449,
		client = {
			status = { thirst = 450000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'prop_ld_flow_bottle', pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true
		}
	},
	['apfelsaft'] = {
		label = 'Apfelsaft',
		weight = 500,
		degrade = 720,
		stack = true,
		client = {
			status = { thirst = 300000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'apa_prop_cs_plastic_cup_01', pos = vec3(0.01, 0.01, 0.01), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 3500
		}
	},
	['orangensaft'] = {
		label = 'Orangensaft',
		weight = 500,
		stack = true,
		close = true,
		degrade = 720,
		description = nil,
		client = {
			status = { thirst = 330000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'apa_prop_cs_plastic_cup_01', pos = vec3(0.01, 0.01, 0.01), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500
			}
	},
	['kaffee'] = {
		label = 'Kaffee',
		weight = 200,
		stack = true,
		close = true,
		description = nil,
		client = {
			status = { thirst = 220000, drunk = -10000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'prop_fib_coffee',
			pos = vec3(0.008, 0.0, 0.05), rot = vec3(0.0, 0.0, -40.0) },
			usetime = 7500
		}
	},
	['tasse_tee'] = {
		label = 'Tasse Tee',
		stack = false,
		weight = 300,
		degrade = 250,
		consume = 0.5,
		close = true,
		client = {
			status = { thirst = 150000, drunk = -3000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			--prop = { model = 'prop_ld_flow_bottle', pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 1300,
			cancel = true,
		}
	},
	['sprunk'] = {
		label = 'Sprunk',
		weight = 330,
		stack = true,
		close = true,
		degrade = 1449,
		description = nil,
		client = {
			status = { thirst = 280000 },
			anim = 'drinking',
			prop = 'sprunk',
			usetime = 2500
			}
	},
	['junk'] = {
		label = 'Junk',
		weight = 330,
		stack = true,
		close = true,
		degrade = 1449,
		description = 'Energy',
		client = {
			status = { thirst = 500000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'sf_prop_sf_can_01a', pos = vec3(0.01, 0.01, 0.01), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500
			}
	},
	['tequila_glas'] = {
		label = 'Tequila',
		weight = 270,
		stack = false,
		close = true,
		description = nil,
		degrade = 350,
		client = {
			status = { thirst = 30000, hunger = 12000, drunk = 50000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'prop_tequila', pos = vec3(0.01, 0.01, 0.06), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 3000,
			cancel = true,
		}
	},
	['bier'] = {
		label = 'Bier',
		weight = 330,
		stack = true,
		close = true,
		description = nil,
		consume = 0.2,
		client = {
			status = { thirst = 50000, drunk = 25000, },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'prop_cs_beer_bot_01', pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 7500
		}
	},
	['whiskey_glas'] = {
		label = 'Glas Whiskey',
		weight = 250,
		stack = false,
		close = true,
		description = nil,
		consume = 0.5,
		client = {
			status = { thirst = 100000, drunk = 25000, },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'prop_cs_shot_glass', pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 3500
		}
	},
	['whiskey_flasche'] = {
		label = 'Whiskey Flasche',
		weight = 940,
		stack = false,
		close = true,
		description = nil,
		consume = 0.1,
		client = {
			status = { thirst = 100000, drunk = 25000, },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'prop_cs_shot_glass', pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 3500
		}
	},
	['tomatensaft'] = {
		label = 'Tomatensaft',
		weight = 500,
		stack = true,
		close = true,
		degrade = 720,
		description = nil,
		client = {
			status = { thirst = 320000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'apa_prop_cs_plastic_cup_01', pos = vec3(0.01, 0.01, 0.01), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500
			}
	},
	['litschisaft'] = {
		label = 'Litschi Saft',
		weight = 500,
		stack = true,
		close = true,
		degrade = 720,
		description = nil,
		client = {
			status = { thirst = 500000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'apa_prop_cs_plastic_cup_01', pos = vec3(0.01, 0.01, 0.01), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500
			}
	},
	['limonadeglas'] = {
		label = 'Glas Limonade',
		weight = 500,
		stack = true,
		close = true,
		description = nil,
		client = {
			status = { thirst = 420000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'apa_prop_cs_plastic_cup_01', pos = vec3(0.01, 0.01, 0.01), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500
			}
	},
	['sexonthebeach'] = {
		label = 'Sex on the Beach',
		weight = 650,
		consume = 0.5,
		client = {
			status = { drunk = 100000, thirst = 75000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'prop_cocktail', pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'Lecker und uiuiui'
		}
	},
	['tequilasunrise'] = {
		label = 'Tequila Sunrise',
		weight = 650,
		consume = 0.5,
		client = {
			status = { drunk = 100000, thirst = 75000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'prop_cocktail', pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'Lecker und uiuiui'
		}
	},
	['caipirinha'] = {
		label = 'Caipirinha',
		weight = 650,
		consume = 0.5,
		client = {
			status = { drunk = 80000, thirst = 100000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'prop_cocktail', pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'Lecker und uiuiui'
		}
	},
	['rotwein'] = {
		label = 'Rotwein',
		stack = false,
		weight = 700,
		degrade = 350,
		consume = 0.2,
		close = true,
		client = {
			status = { thirst = 80000, drunk = 10000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			--prop = { model = 'prop_ld_flow_bottle', pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 1300,
			cancel = true,
			--notification = 'Lecker Tee, der ist echt gut'
		}
	},
	['weisswein'] = {
		label = 'Weißwein',
		stack = false,
		weight = 700,
		degrade = 350,
		consume = 0.2,
		close = true,
		client = {
			status = { thirst = 85000, drunk = 10000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			--prop = { model = 'prop_ld_flow_bottle', pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 1300,
			cancel = true,
			--notification = 'Lecker Tee, der ist echt gut'
		}
	},
	['kaffeeschwarz'] = {
		label = 'Kaffee schwarz',
		weight = 250,
		stack = false,
		close = true,
		degrade = 350,
		description = nil,
		client = {
			status = { drunk = -30000, thirst = 80000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'p_amb_coffeecup_01', pos = vec3(0.01, 0.0, 0.05), rot = vec3(1.0, 1.0, 0.0) },
			usetime = 2500
		}
	},
	['kaffeeweiss'] = {
		label = 'Kaffee mit Milch',
		weight = 250,
		stack = false,
		close = true,
		degrade = 350,
		description = nil,
		client = {
			status = { drunk = -30000, thirst = 80000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'p_amb_coffeecup_01', pos = vec3(0.01, 0.0, 0.05), rot = vec3(1.0, 1.0, 0.0) },
			usetime = 2500
		}
	},
	['kaffeezu'] = {
		label = 'Kaffee mit Zucker',
		weight = 250,
		stack = false,
		close = true,
		degrade = 350,
		description = nil,
		client = {
			status = { drunk = -30000, thirst = 80000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'p_amb_coffeecup_01', pos = vec3(0.01, 0.0, 0.05), rot = vec3(1.0, 1.0, 0.0) },
			usetime = 2500
		}
	},
	['kaffeezuwe'] = {
		label = 'Kaffee mit Milch und Zucker',
		weight = 250,
		stack = false,
		close = true,
		degrade = 350,
		description = nil,
		client = {
			status = { drunk = -30000, thirst = 80000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'p_amb_coffeecup_01', pos = vec3(0.01, 0.0, 0.05), rot = vec3(1.0, 1.0, 0.0) },
			usetime = 2500
		}
	},
	['cappuccino'] = {
		label = 'Cappuccino',
		weight = 250,
		stack = false,
		close = true,
		degrade = 350,
		description = nil,
		client = {
			status = { drunk = -30000, thirst = 80000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'p_amb_coffeecup_01', pos = vec3(0.01, 0.0, 0.05), rot = vec3(1.0, 1.0, 0.0) },
			usetime = 2500
		}
	},
	['lattemacchiato'] = {
		label = 'Latte Macchiato',
		weight = 250,
		stack = false,
		close = true,
		degrade = 350,
		description = nil,
		client = {
			status = { drunk = -30000, thirst = 80000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'p_amb_coffeecup_01', pos = vec3(0.01, 0.0, 0.05), rot = vec3(1.0, 1.0, 0.0) },
			usetime = 2500
		}
	},
	-- Ende Trinken Items useable

	-- Anfang Farming Items Grundlage fürs Crafting / Verkauf
	['bleierz'] = {
		label = 'Bleierz',
		description = nil,
		weight = 280,
		stack = true,
		close = true
	},
	['silbererz'] = {
		label = 'Silbererz',
		description = nil,
		weight = 190,
		stack = true,
		close = true
	},
	['selteneerden'] = {
		label = 'Seltene Erden',
		description = nil,
		weight = 250,
		stack = true,
		close = true
	},
	['bauxit'] = {
		label = 'Bauxit',
		description = nil,
		weight = 150,
		stack = true,
		close = true
	},
	['tabakblatt'] = {
		label = 'Tabakblatt',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},
	['sand'] = {
		label = 'Sand',
		description = nil,
		weight = 100,
		stack = true,
		close = true
	},
	['indigo'] = {
		label = 'Indigo',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},
	['kies'] = {
		label = 'Kies',
		description = nil,
		weight = 250,
		stack = true,
		close = true
	},
	['acetone'] = {
		label = 'Azeton',
		weight = 50,
		stack = true,
		close = true
	},
	['altglas'] = {
		label = 'Altglas',
		weight = 50,
		stack = true,
		close = true
	},
	['ammoniak'] = {
		label = 'Ammoniak',
		weight = 50,
		stack = true,
		close = true
	},
	['ammonium_nitrate'] = {
		label = 'Ammonium Nitrat',
		weight = 50,
		stack = true,
		close = true
	},
	['apfel'] = {
		label = 'Apfel',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},
	['aramidfasern'] = {
		label = 'Aramidfasern',
		weight = 20,
		stack = true,
		close = true,
		description = nil
	},
	['huhn'] = {
		label = 'Huhn',
		weight = 1500,
		stack = true,
		close = true
	},
	['thunfisch'] = {
		label = 'Thunfisch',
		weight = 1000,
		stack = true,
		close = true,
		description = nil
	},
	['lachs'] = {
		label = 'Lachs',
		weight = 1000,
		stack = true,
		close = true,
		description = nil
	},
	['forelle'] = {
		label = 'Forelle',
		weight = 700,
		stack = true,
		close = true,
		description = nil
	},
	['salat'] = {
		label = 'Salat',
		weight = 15,
		stack = true,
		close = true,
		description = nil
	},
	['kuerbis'] = {
		label = 'Kürbis',
		weight = 15,
		stack = true,
		close = true,
		description = nil
	},
	['zwiebel'] = {
		label = 'Zwiebel',
		weight = 20,
		stack = true,
		close = true,
		description = nil
	},
	['kupfererz'] = {
		label = 'Kupfererz',
		weight = 120,
		stack = true,
		close = true,
		description = nil
	},
	['kupferschrott'] = {
		label = 'Kupferschrott',
		weight = 80,
		stack = true,
		close = true,
		description = nil
	},
	['eisenerz'] = {
		label = 'Eisenerz',
		weight = 150,
		stack = true,
		close = true,
		description = nil
	},
	['eisenschrott'] = {
		label = 'Eisenschrott',
		weight = 100,
		stack = true,
		close = true,
		description = nil
	},
	['plastikmuell'] = {
		label = 'Plastikmüll',
		weight = 20,
		stack = true,
		close = true,
		description = nil
	},
	['pfandflasche'] = {
		label = 'Pfandflasche',
		weight = 20,
		stack = true,
		close = true,
		description = nil
	},
	['aluschrott'] = {
		label = 'Aluminiumschrott',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},
	['orange'] = {
		label = 'Orange',
		weight = 44,
		stack = true,
		close = true,
		description = nil
	},
	['nuesse'] = {
		label = 'Nüsse',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},
	['getreide'] = {
		label = 'Getreide',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},
	['safrol'] = {
		label = 'Safrol',
		stack = true,
		weight = 2,
		close = true,
		description = nil
	},
	['bromsaeure'] = {
		label = 'Bromsäure',
		stack = true,
		weight = 2,
		close = true,
		description = 'legal'
	},
	['bromsafrol'] = {
		label = 'Bromsafrol',
		stack = true,
		weight = 8,
		close = true,
		description = 'legal'
	},
	['methylamin'] = {
		label = 'Methylamin',
		stack = true,
		weight = 8,
		close = true,
		description = nil
	},
	['kaffeebohnen'] = {
		label = 'Kaffeebohnen',
		weight = 8,
		stack = true,
		close = true,
		description = nil
	},
	['teeblaetter'] = {
		label = 'Teeblätter',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},
	['projektil'] = {
		label = 'Projektil',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},
	['huelse'] = {
		label = 'Hülse',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},
	['tomate'] = {
		label = 'Tomate',
		weight = 20,
		stack = true,
		close = true,
		description = nil
	},
	['stein'] = {
		label = 'Stein',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},
	['kohle'] = {
		label = 'Kohle',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},
	['holz'] = {
		label = 'Holz',
		weight = 800,
		stack = true,
		close = true,
		description = nil
	},
	['wolle'] = {
		label = 'Wolle',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},
	['zitrone'] = {
		label = 'Zitrone',
		weight = 25,
		stack = true,
		close = true,
		description = nil
	},
	['eier'] = {
		label = 'Eier',
		weight = 20,
		stack = true,
		close = true,
		description = nil
	},
	['milch'] = {
		label = 'Milch',
		weight = 500,
		stack = true,
		close = true,
		description = nil
	},
	-- Ende Farming Items Grundlage fürs Crafting / Verkauf

	-- Anfang Zwischenprodukte Items Grundlage fürs Crafting / Verkauf
	['eisenbarren'] = {
		label = 'Eisenbarren',
		description = 'Barren',
		weight = 1000,
		stack = true,
		close = true
	},
	['bleibarren'] = {
		label = 'Bleibarren',
		description = 'Barren',
		weight = 1100,
		stack = true,
		close = true
	},
	['silberbarren'] = {
		label = 'Silberbarren',
		description = 'Barren',
		weight = 750,
		stack = true,
		close = true
	},
	['aluminiumbarren'] = {
		label = 'Aluminiumbarren',
		description = 'Barren',
		weight = 600,
		stack = true,
		close = true
	},
	['burgerpatty'] = {
		label = 'Patty',
		weight = 160,
		stack = true,
		close = true
	},
	['aramid'] = {
		label = 'Aramid',
		weight = 100,
		stack = true,
		close = true,
		description = nil
	},
	['kupferbarren'] = {
		label = 'Kupferbarren',
		weight = 900,
		stack = true,
		close = true,
		description = nil
	},
	['farbe'] = {
		label = 'Farbe',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},
	['plastik'] = {
		label = 'Plastik',
		weight = 250,
		stack = true,
		close = true,
		description = nil
	},
	['bretter'] = {
		label = 'Bretter',
		weight = 250,
		stack = true,
		close = true,
		description = nil
	},
	['mehl'] = {
		label = 'Mehl',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},
	-- Ende Zwischenprodukte Items Grundlage fürs Crafting / Verkauf

	-- Anfang Endprodukte Items Verkauf
	['silbermuenze'] = {
		label = 'Silbermünze',
		description = 'Illegal und Selten',
		weight = 5,
		stack = true,
		close = true
	},
	-- Ende Endprodukte Items Verkauf

	-- Anfang Medical Items useable
	['bandage'] = {
		label = 'Verband',
		weight = 10,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = 'prop_rolled_sock_02', pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0)},
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		}
	},
	-- Ende Medical Items useable



	-- Anfang Jobitems Items
	['elektrokoffer'] = {
		label = 'Elektriker Koffer',
		weight = 0,
		stack = false,
		close = true,
		description = 'Zur Reperatur von Elektrik, für den Job Elektriker benötigt.'
	},
	-- Ende Jobitems Items




	['keys'] = {
		label = 'Schlüssel',
		weight = 2,
		stack = false,
		close = true,
		description = 'Schlüssel'
	},
	['black_money'] = {
		label = 'Schwarzgeld',
		description = 'illegal'
	},
	['money'] = {
		label = 'Bargeld',
	},
	['identification'] = {
		label = 'Identification',
	},
	['garbage'] = {
		label = 'Müll'
	},
	['panties'] = {
		label = 'Knickers',
		weight = 10,
		consume = 0,
		client = {
			status = { thirst = -100000, stress = -25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'prop_cs_panties_02', pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
			usetime = 2500
		}
	},
	['defklammer'] = {
		label = 'kaputte Büroklammer',
		weight = 10,
	},
	['lockpick'] = {
		label = 'Dietrich',
		weight = 160,
		consume = 0.2,
		decay = true,
		client = {
			usetime = 1500
		}
	},
	['black_card'] = {
		label = 'Waschkarte',
		weight = 1,
		stack = false,
		close = true,
		consume = 0,
		description = 'illegal'
	},
	['mastercard'] = {
		label = 'Mastercard',
		weight = 1,
		stack = false,
		close = true,
		description = nil
	},
	['parachute'] = {
		label = 'Fallschirm',
		weight = 3000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},
	['bag'] = {
		label = 'Tasche',
		weight = 1500,
		stack = false,
		close = true,
		consume = 1,
		description = nil,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},
	['nobag'] = {
		label = 'keine Tasche',
		weight = 1,
		stack = false,
		close = true,
		consume = 0,
		description = nil,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},
	['bag2'] = {
		label = 'Tasche II',
		weight = 1300,
		stack = false,
		close = true,
		consume = 1,
		description = nil,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},
	['nobag2'] = {
		label = 'keine Tasche II',
		weight = 1,
		stack = false,
		close = true,
		consume = 0,
		description = nil,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},
	['kleidertasche'] = {
		label = "Kleidertasche",
		description = 'Eine kleine Tasche mit Deinen Outfits',
		weight = 2500,
		stack = false,
		close = true,
		consume = 0,
	},
	['waschset'] = {
		label = 'Waschset',
		weight = 1150,
		stack = true,
		close = true,
		client = {
			usetime = 0
		},
		description = nil
	},
	['fixkit'] = {
		label = 'Reparatur Set',
		weight = 2500,
		stack = true,
		close = true,
		description = nil
	},
	['blaettchen'] = {
		label = 'Packung Blättchen',
		weight = 50,
		stack = true,
		close = true,
		consume = 1,
		description = 'Packung'
	},
	['eblaettchen'] = {
		label = 'Blättchen',
		weight = 1,
		stack = true,
		close = true,
		consume = 1,
		description = 'einzelne Blättchen'
	},
	['fakeplate'] = {
		label = 'Falsches Kennzeichen',
		consume = 0,
	},
	['nikkit'] = {
		label = 'Drogentest',
		weight = 10,
		stack = true,
		close = true
	},
	['drogenpaket'] = {
		label = 'Drogenpaket',
		weight = 50,
		stack = true,
		close = true,
		description = 'illegal'
	},
	['usednikkit'] = {
		label = 'gebr. Drogentest',
		weight = 12,
		stack = false,
		close = true
	},
	['phone'] = {
		label = 'Handy',
		weight = 256,
		stack = false,
		consume = 0,
		client = {
			add = function(total)
				if total > 0 then
					pcall(function() return exports.npwd:setPhoneDisabled(false) end)
				end
			end,

			remove = function(total)
				if total < 1 then
					pcall(function() return exports.npwd:setPhoneDisabled(true) end)
				end
			end
		}
	},



	['wasser5l'] = {
		label = 'Wasserkanister 5L',
		weight = 2500,
		stack = true,
		consume = 0
	},

	['kanister5l'] = {
		label = '5L Kanister (leer)',
		weight = 50,
		stack = true,
		description = "Leerer Behälter für Flüssigkeiten"
	},

	['gps'] = {
		label = 'GPS System',
		weight = 500,
		stack = true,
		close = true
	},

	['stancerkit'] = {
		label = 'Dynamisches Fahrwerk',
		weight = 2500,
		stack = true,
		close = true
	},

	['notepad'] = {
		label = 'Notizblock',
		weight = 250,
		stack = true,
		close = true
	},

	['radio'] = {
		label = 'Funkgerät',
		weight = 980,
		stack = false,
		consume = 0,
		allowArmed = true
	},

	['belag'] = {
		label = 'Belag',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},



	['blowpipe'] = {
		label = 'Lötlampe',
		weight = 1700,
		stack = false,
		close = true,
		description = nil
	},



	['cannabis'] = {
		label = 'Cannabis',
		weight = 10,
		stack = true,
		close = true,
		description = 'Droge',
		buttons = {
			{
				label = 'Joint',
				action = function(item, count)
					TriggerServerEvent('ox_inventory:joint')
				end
			}
		}
	},

	['carbon'] = {
		label = 'Carbon',
		weight = 100,
		stack = true,
		close = true,
		description = nil
	},

	['carbonfasern'] = {
		label = 'Carbonfasern',
		weight = 20,
		stack = true,
		close = true,
		description = nil
	},



	['tuch'] = {
		label = 'Tuch',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},

	['codein'] = {
		label = 'Codein',
		weight = 2,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['diamond'] = {
		label = 'Diamant',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['ibu_400_akut'] = {
		label = 'Ibu 400 Akut',
		weight = 2,
		stack = true,
		close = true,
		description = 'Schmerztabletten legal',
		client = {
			status = { hunger = 0 },
			anim = 'eating',
			prop = '',
			usetime = 1000
		}
	},

	['orthomol'] = {
		label = 'Orthomol',
		weight = 5,
		stack = true,
		close = true,
		description = 'Imunsystemstärker legal',
		client = {
			anim = 'eating',
			prop = '',
			usetime = 4000
		}
	},

	['reddragon'] = {
		label = 'Red Dragon',
		weight = 225,
		stack = true,
		close = true,
		description = 'Energy Drink'
	},

	['drink_sprite'] = {
		label = 'Sprite +',
		weight = 500,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['drug_ecstasy'] = {
		label = 'Ecstasy',
		weight = 5,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['drug_lean'] = {
		label = 'Hustensaft',
		weight = 250,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['drug_lsd'] = {
		label = 'LSD',
		weight = 1,
		stack = true,
		close = true,
		description = 'Droge',
		client = {
			status = { thirst = -50000, hunger = 190000},
			--anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			--prop = { model = 'prop_ecola_can', pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500
			}
	},



	['elektokomponenten'] = {
		label = 'Elektokomponenten',
		weight = 100,
		stack = true,
		close = true,
		description = nil
	},

	['fass'] = {
		label = 'Fass 30L',
		weight = 3000,
		stack = false,
		close = true,
		description = 'Lagerbehälter Flüssigkeiten'
	},

	['fish'] = {
		label = 'Fisch',
		weight = 150,
		stack = true,
		close = true,
		description = nil
	},

	['flasche'] = {
		label = 'Flasche',
		weight = 25,
		stack = true,
		close = true,
		description = nil
	},

	['flusskrebs'] = {
		label = 'Flußkrebs',
		weight = 20,
		stack = true,
		close = true,
		description = nil
	},

	['folie'] = {
		label = 'Folie',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['gehaeuse'] = {
		label = 'Gehäuse',
		weight = 200,
		stack = true,
		close = true,
		description = nil
	},

	['goldbarren'] = {
		label = 'Goldbarren',
		weight = 900,
		stack = true,
		close = true,
		description = nil
	},

	['golderz'] = {
		label = 'Golderz',
		weight = 110,
		stack = true,
		close = true,
		description = nil
	},

	['goldschrott'] = {
		label = 'Goldschrott',
		weight = 110,
		stack = true,
		close = true,
		description = nil
	},

	['hamburger'] = {
		label = 'Hamburger',
		weight = 160,
		stack = true,
		close = true,
		description = nil,
		degrade = 1449,
		client = {
			status = { hunger = 210000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500
		}
	},

	['hammer'] = {
		label = 'Hammer',
		weight = 450,
		stack = false,
		close = true,
		description = nil
	},

	['wirecutter'] = {
		label = 'Seitenschneider',
		weight = 313,
		stack = false,
		close = true,
		description = nil
	},

	['handcuffs'] = {
		label = 'Handschellen',
		weight = 150,
		stack = true,
		close = true,
		description = nil
	},

	['heavy'] = {
		label = 'Schutzweste groß',
		weight = 2200,
		stack = true,
		close = true,
		description = nil
	},



	['ibo'] = {
		label = 'Ibo',
		weight = 4,
		stack = true,
		close = true,
		description = nil
	},

	['ice'] = {
		label = 'Eis',
		weight = 100,
		stack = true,
		close = true,
		description = nil
	},

	['driver_license'] = {
		label = 'Führerschein',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['weaponlicense'] = {
		label = 'Waffenschein',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['lawyerpass'] = {
		label = 'Anwalts Lizenz',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['id_card'] = {
		label = 'Ausweis',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['idgruppe6'] = {
		label = 'id karte gruppe6 boss',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['idgruppe62'] = {
		label = 'id karte gruppe6 klein',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['idgruppe622'] = {
		label = 'id karte gruppe6 vice',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['idgruppe63'] = {
		label = 'id karte gruppe6 mittel',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['joint'] = {
		label = 'Joint',
		weight = 4,
		stack = true,
		close = true,
		description = 'Droge',
		client = {
			status = { hunger = -50000 },
			anim = 'smokejoint',
			prop = 'joint',
			usetime = 20000,
			}
	},

	['kevlar'] = {
		label = 'Schwere Schutzweste',
		weight = 2500,
		stack = false,
		close = true,
		allowArmed = true,
		description = 'Bester Schutz',
		client = {
			status = { armour = 100 },
			anim = { dict = 'anim@heists@narcotics@funding@gang_idle', clip = 'gang_chatting_idle01'},
			usetime = 4000,
			}
	},

	['kevlarm'] = {
		label = 'Mittlere Schutzweste',
		weight = 2000,
		stack = false,
		close = true,
		allowArmed = true,
		description = nil,
		client = {
			status = { armour = 60 },
			anim = { dict = 'anim@heists@narcotics@funding@gang_idle', clip = 'gang_chatting_idle01'},
			usetime = 4000,
			}
	},

	['kevlars'] = {
		label = 'Leichte Schutzweste',
		weight = 1800,
		stack = false,
		close = true,
		allowArmed = true,
		description = nil,
		client = {
			status = { armour = 35 },
			anim = { dict = 'anim@heists@narcotics@funding@gang_idle', clip = 'gang_chatting_idle01'},
			usetime = 4000,
			}
	},

	['klebeband'] = {
		label = 'Klebeband',
		weight = 250,
		stack = true,
		close = true,
		description = nil
	},

	['kokablatt'] = {
		label = 'Kokablatt',
		weight = 5,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['kokain'] = {
		label = 'Kokain',
		weight = 1,
		stack = true,
		close = true,
		description = 'Droge',
		client = {
			status = { thirst = 20000 },
			anim = {scenario = 'WORLD_HUMAN_DRUG_PROCESSORS_COKE', clip = ''},
			--prop = 'kokain',
			usetime = 3000,
			}
	},

	['afghan_kush_500'] = {
		label = 'Afghan 0,5KG',
		weight = 500,
		stack = true,
		close = true,
		description = 'Droge',
	},

	['afghan_kush_1000'] = {
		label = 'Afghan 1,0KG',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Droge',
	},

	['kokain500'] = {
		label = 'Kokain 0,5KG',
		weight = 500,
		stack = true,
		close = true,
		description = 'Droge',
	},

	['kokain1000'] = {
		label = 'Kokain 1,0KG',
		weight = 1000,
		stack = true,
		close = true,
		description = 'Droge',
	},

	['cigarette'] = {
		label = 'Zigarette',
		weight = 1,
		stack = true,
		close = true,
		description = nil,
		client = {
			status = { drunk = -250000 },
			--anim = { dict = 'amb@world_human_smoking@male@male_a@enter', clip = 'enter' },
			--prop = { model = 'brum_joint_98_special', pos = { x = 0.07, y = 0.07, z = 0.07}, rot = { x = 0.0, y = -13.5, z = 90.5} },
			usetime = 1000,
			}
	},

	['cigar'] = {
		label = 'Zigarre',
		weight = 1,
		stack = true,
		close = true,
		description = nil,
		client = {
			status = { drunk = -350000 },
			--anim = { dict = 'amb@world_human_smoking@male@male_a@enter', clip = 'enter' },
			--prop = { model = 'brum_joint_98_special', pos = { x = 0.07, y = 0.07, z = 0.07}, rot = { x = 0.0, y = -13.5, z = 90.5} },
			usetime = 1000,
			}
	},

	['kokapaste'] = {
		label = 'Kokapaste',
		weight = 2,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['laptop_h'] = {
		label = 'Hacker Laptop',
		weight = 1800,
		stack = false,
		close = true,
		description = 'illegal'
	},

	['laptop'] = {
		label = 'Laptop',
		weight = 1800,
		stack = false,
		close = true,
		description = nil
	},

	['lauf'] = {
		label = 'Lauf',
		weight = 200,
		stack = true,
		close = true,
		description = nil
	},

	['playerbooth'] = {
		label = 'Verkaufsstand',
		weight = 3000,
		stack = true,
		close = true,
		description = 'legal'
	},

	['pasta'] = {
		label = 'Pasta',
		weight = 70,
		stack = true,
		close = true,
		description = nil
	},

	['lieferbestapfel'] = {
		label = 'Lieferbestätigung Apfel',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['lieferbestorange'] = {
		label = 'Lieferbestätigung Orange',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['light'] = {
		label = 'Schutzweste Klein',
		weight = 1000,
		stack = true,
		close = true,
		description = nil
	},

	['liquid_sulfur'] = {
		label = 'Liquid Sulfur',
		weight = 1.000,
		stack = true,
		close = true,
		description = nil
	},

	['lithium'] = {
		label = 'Lithium Batterien',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['marijuana'] = {
		label = 'Marijuana',
		weight = 1,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['medikit'] = {
		label = 'Erste Hilfe Set',
		weight = 1300,
		stack = true,
		close = true,
		description = nil,
		allowArmed = true
	},

	['medium'] = {
		label = 'Schutzweste mittel',
		weight = 2000,
		stack = true,
		close = true,
		description = nil
	},

	['meth'] = {
		label = 'Meth',
		weight = 1,
		stack = true,
		close = true,
		description = 'Droge',
		client = {
			status = { thirst = -200000 },
			usetime = 10000,
		}
	},

	['methanol'] = {
		label = 'Methanol',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['methlab'] = {
		label = 'Portable Methlab',
		weight = 4500,
		stack = false,
		close = true,
		description = 'illegales Mobile Methlabor'
	},

	['nitrogen'] = {
		label = 'Nitrogen',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},



	['opium'] = {
		label = 'Opium',
		weight = 1,
		stack = true,
		close = true,
		client = {
			status = { hunger = -200000 },
			usetime = 10000,
			},
		description = 'Droge'
	},

	['rohopium'] = {
		label = 'Rohopium',
		weight = 1,
		stack = true,
		close = true,
		description = 'Drogen-Grundstoff'
	},

	['vape'] = {
		label = 'Vape',
		weight = 50,
		stack = false,
		close = true,
		consume = 0.1,
		description = nil
	},

	['oxygenmask'] = {
		label = 'Sauerstoff Maske',
		weight = 5000,
		stack = false,
		close = true,
		description = 'Nur einmal zu verwenden. 10min. Sauerstoff.'
	},

	['parkingcard'] = {
		label = 'Parkkarte',
		weight = 1,
		stack = false,
		close = true,
		description = nil
	},

	['oel'] = {
		label = 'Öl',
		weight = 750,
		stack = true,
		close = true,
		description = 'aus Rohöl hergestellt.'
	},

	['presslufthammer'] = {
		label = 'Presslufthammer',
		weight = 3000,
		stack = false,
		close = true,
		description = nil
	},

	['pseudoephedrin'] = {
		label = 'Pseudoephedrin',
		weight = 1,
		stack = true,
		close = true,
		description = 'droge'
	},

	['rohoel'] = {
		label = 'Rohöl',
		weight = 1000,
		stack = true,
		close = true,
		description = nil
	},

	['roterschwefel'] = {
		label = 'Roter Schwefel',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},

	['schere'] = {
		label = 'Schere',
		weight = 100,
		stack = false,
		close = true,
		durability = 0.03,
		description = nil
	},

	['schuerfpfanne'] = {
		label = 'Schürfpfanne',
		weight = 500,
		stack = false,
		close = true,
		description = nil
	},

	['spitzhacke'] = {
		label = 'Spitzhacke',
		weight = 2000,
		stack = false,
		close = true,
		description = nil
	},

	['tatwaffe'] = {
		label = 'Tatwaffe',
		weight = 1000,
		stack = false,
		close = true,
		description = 'zwingend bei der Polizei abzugeben'
	},

	['wuerstchen'] = {
		label = 'Würstchen',
		weight = 120,
		stack = true,
		close = true,
		description = nil
	},

	['hackfleisch'] = {
		label = 'Hackfleisch',
		weight = 80,
		stack = true,
		close = true,
		description = nil
	},

	['tacoshells'] = {
		label = 'Taco-Schale',
		weight = 60,
		stack = true,
		close = true,
		description = nil
	},

	['warndreieck'] = {
		label = 'Warndreieck',
		weight = 500,
		stack = true,
		close = true,
		description = nil
	},

	['warnweste'] = {
		label = 'Warnweste',
		weight = 150,
		stack = true,
		close = true,
		description = nil
	},

	['gewaschener_stein'] = {
		label = 'Gewaschener Stein',
		weight = 40,
		stack = true,
		close = true,
		description = nil
	},

	['zimmerkarte'] = {
		label = 'Zimmerkarte Hotel',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['handschellen'] = {
		label = 'Handschellen',
		weight = 150,
		stack = true,
		close = true,
		description = nil
	},

	['mohn'] = {
		label = 'Mohn',
		weight = 10,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['heroin'] = {
		label = 'Heroin',
		weight = 1,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['fishingrod'] = {
		label = 'Angelrute',
		weight = 1500,
		stack = true,
		close = true,
		description = nil
	},



	['bretter_job'] = {
		label = 'Bretter',
		weight = 150,
		stack = true,
		close = true,
		description = 'Holzfäller Job'
	},

	['falschgeld'] = {
		label = 'Bargeld',
		weight = 0,
		stack = true,
		close = true,
		description = nil
	},

	['geldpapier'] = {
		label = 'Geldpapier',
		weight = 1,
		stack = true,
		close = true,
		description = 'illegal, wenn nicht im Staatsbesitz'
	},

	['druckplatten'] = {
		label = 'Druckplatten',
		weight = 1,
		stack = false,
		close = true,
		description = 'illegal, wenn nicht im Staatsbesitz'
	},

	['gewuerze'] = {
		label = 'Gewürze',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['ketchup'] = {
		label = 'Ketchup',
		weight = 750,
		stack = true,
		close = true,
		description = nil
	},

	['papier'] = {
		label = 'Papier',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['schmuck'] = {
		label = 'Schmuck',
		weight = 250,
		stack = true,
		close = true,
		description = nil
	},

	['wasserzeichen'] = {
		label = 'Wasserzeichen Blaupause',
		weight = 1,
		stack = true,
		close = true,
		description = 'illegal'
	},

	['tabak'] = {
		label = 'Tabak',
		weight = 2,
		stack = true,
		close = true,
		description = nil
	},

	['zigarette'] = {
		label = 'Zigarette',
		weight = 4,
		stack = true,
		close = true,
		description = nil
	},

	['zigarre'] = {
		label = 'Zigarre',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['black_blueprint'] = {
		label = 'Schwarze Karte',
		weight = 1,
		stack = false,
		close = true,
		description = nil
	},

	['money_blueprint'] = {
		label = 'Schwarzgeld Karte',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['kautschuk'] = {
		label = 'Kautschuk',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},

	['gummi'] = {
		label = 'Gummi',
		weight = 30,
		stack = true,
		close = true,
		description = nil
	},

	['letter'] = {
		label = 'Brief',
		weight = -1,
		stack = true,
		close = true,
		description = nil
	},

	['package'] = {
		label = 'Paket',
		weight = -1,
		stack = true,
		close = true,
		description = nil
	},

	['nitro'] = {
		label = 'Nitro',
		weight = 2500,
		stack = true,
		close = true,
		description = nil
	},

	['heroin05'] = {
		label = 'Heroin 0.5kg pack',
		weight = 520,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['marijuana05'] = {
		label = 'Marijuana 0.5kg pack',
		weight = 500,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['jewels'] = {
		label = 'Juwelen',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['usb_stick'] = {
		label = 'USB-Stick',
		weight = 50,
		stack = false,
		close = true,
		description = nil
	},

	['uncut_money'] = {
		label = 'uncut_money',
		weight = 1000,
		stack = true,
		close = true,
		description = 'illegal'
	},

	['repairkit'] = {
		label = 'Reparaturset',
		weight = 2500,
		stack = true,
		close = true,
		description = nil
	},

	['tyrekit'] = {
		label = 'Reifen Reparaturset',
		weight = 2500,
		stack = true,
		close = true,
		description = 'nur für Reifen'
	},

	['kohlefasern'] = {
		label = 'Kohlefasern',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},

	['uvlight'] = {
		label = 'UV Lampe',
		weight = 1.000,
		stack = true,
		close = true,
		description = 'nur für Polizei, sonst illegal'
	},

	['salat_seed'] = {
		label = 'Salat Samen',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['afghan_seed'] = {
		label = 'Afghan Kush Samen',
		weight = 1,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['sour_seed'] = {
		label = 'Sour Diesel Samen',
		weight = 1,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['purple_seed'] = {
		label = 'Purple Haze Samen',
		weight = 1,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['afghan'] = {
		label = 'Afghan Kush',
		weight = 1,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['afghanzweig'] = {
		label = 'Afghan Bud',
		weight = 1,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['koka_seed'] = {
		label = 'Koka Samen',
		weight = 1,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['mohn_seed'] = {
		label = 'Mohn Samen',
		weight = 1,
		stack = true,
		close = true,
		description = 'Droge'
	},

	['lighter'] = {
		label = 'Feuerzeug',
		weight = 1,
		stack = true,
		close = true,
		description = nil
	},

	['afghan_joint'] = {
		label = 'Afghan Joint',
		weight = 4,
		stack = true,
		close = true,
		description = 'Droge',
		client = {
			status = { hunger = -50000 },
			anim = 'smokejoint',
			prop = 'joint',
			usetime = 8000
		}
	},

	['tee'] = {
		label = 'Tee',
		weight = 10,
		stack = true,
		close = true,
		description = nil
	},

	['filet'] = {
		label = 'Hühnerfilet',
		weight = 250,
		stack = true,
		close = true,
		description = nil
	},

	['rinderfilet'] = {
		label = 'Rinderfilet',
		weight = 350,
		stack = true,
		close = true,
		description = nil
	},

	['angus'] = {
		label = 'Angusfilet',
		weight = 150,
		stack = true,
		close = true,
		description = nil
	},

	['sauce'] = {
		label = 'Sauce',
		weight = 3,
		stack = true,
		close = true,
		description = nil
	},

	['tortillas'] = {
		label = 'Tortillas',
		weight = 50,
		stack = true,
		close = true,
		description = nil
	},

	['kaese'] = {
		label = 'Käse',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['drug_meth'] = {
		label = 'Drug Meth',
		weight = 5,
		stack = true,
		close = true,
		description = 'nicht nutzen'
	},

	['kaffeebohnenget'] = {
		label = 'Kaffee gemahlen',
		weight = 4,
		stack = true,
		close = true,
		description = nil
	},

	['axt'] = {
		label = 'Axt',
		weight = 4500,
		stack = false,
		close = true,
		description = nil
	},

	['engelstrompete_seed'] = {
		label = 'Engelstrompete Samen',
		weight = 1,
		stack = true,
		close = true,
		description = "Droge"
	},

	['engelstrompete'] = {
		label = 'Engelstrompete',
		weight = 4,
		stack = true,
		close = true,
		description = "Droge"
	},

	['stechapfel'] = {
		label = 'Stechapfel',
		weight = 1,
		stack = true,
		close = true,
		description = "Droge-Hyoscyamin"
	},

	['hopfen'] = {
		label = 'Hopfen',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},
	['gerste'] = {
		label = 'Gerste',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['malz'] = {
		label = 'Malz',
		weight = 8,
		stack = true,
		close = true,
		description = nil
	},

	['schlachtermesser'] = {
		label = 'Schlachtermesser',
		weight = 700,
		stack = true,
		close = true,
		description = nil
	},

	['rinderkeule'] = {
		label = 'Rinderkeule',
		weight = 3000,
		stack = true,
		close = true,
		description = nil
	},

	['rinderfleisch'] = {
		label = 'Rinderfleisch',
		weight = 1000,
		stack = true,
		close = true,
		description = nil
	},

	['back_pulver'] = {
		label = 'Backpulver',
		weight = 5,
		stack = true,
		close = true,
		description = nil
	},

	['drill'] = {
		label = 'Bohrmaschine',
		weight = 4500,
		stack = false,
		close = true,
		description = nil
	},

	['nudeln'] = {
		label = 'Nudeln',
		weight = 150,
		stack = true,
		close = true,
		description = nil
	},

	['binoculars'] = {
		label = 'Fernglas',
		weight = 500,
		stack = false,
		close = true,
		consume = 0,
		description = nil,
		client = {
			export = 'rpemotes.toggleBinoculars',
			usetime = 500,
		},
	},

	['newscam'] = {
		label = 'Fernsehkamera',
		weight = 3500,
		stack = false,
		close = true,
		consume = 0,
		description = nil,
		client = {
			export = 'rpemotes.toggleNewscam',
			usetime = 500,
		},
	},

	['gas_mask'] = {
		label = 'Gasmaske',
		weight = 1500,
		stack = false,
		close = true,
		description = nil
	},

	['diamond_box'] = {
		label = 'Diamantenbox',
		weight = 100,
		stack = true,
		close = true,
		description = nil
	},

	['painting'] = {
		label = 'Gemälde',
		weight = 2500,
		stack = false,
		close = true,
		description = nil
	},

	['duenger'] = {
		label = 'Dünger',
		weight = 1500,
		stack = true,
		close = true,
		Consume = 0.2,
		description = nil
	},

	['fernseher'] = {
		label = 'Fernseher',
		weight = 12000,
		stack = false,
		close = true,
		description = nil
	},

	['teig'] = {
		label = 'Teig',
		weight = 400,
		stack = true,
		close = true,
		description = nil,
	},

	['scratch_ticket'] = {
		label = 'Rubbellos',
		stack = true,
		weight = 1,
		close = true,
		description = nil,
		client = {
			usetime = 0,
			event = 'dr-scratching:isActiveCooldown'
		}
	},

	['weaponrepairkit'] = {
		label = 'Waffen Rep. Kit',
		stack = true,
		weight = 400,
		close = true,
		description = 'Wird benötigt um Waffen zu reparieren.'
	},

	['mdma'] = {
		label = 'MDMA',
		stack = true,
		weight = 10,
		close = true,
		description = nil
	},

	['ecstasy'] = {
		label = 'Ecstasy',
		stack = true,
		weight = 10,
		close = true,
		client = {
			status = { thirst = 100000, hunger = 100000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'xm3_prop_xm3_pill_01a', pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'Lecker und uiuiui'
		},
		description = 'illegal'
	},

	['evidence'] = {
		label = 'evidence',
		weight = 20,
		stack = false,
		close = true,
		consume = 0,
		client = {
			export = 'renzu_evidence.useItem',
			disable = { move = true, car = true, combat = true },
			usetime = 1500,
		}
	},

	['fingerprintkit'] = {
		label = 'Latent Fingerprint Kit ',
		weight = 20,
		stack = true,
		close = true,
		consume = 0,
		client = {
			export = 'renzu_evidence.useItem',
			disable = { move = true, car = true, combat = true },
			usetime = 1500,
		}
	},

	['redwoodorg'] = {
		label = 'Redwood Original',
		weight = 1,
		stack = false,
		close = false,
		description = 'Schachtel'
	},

	['redwoodgold2'] = {
		label = 'Redwood Gold',
		weight = 300,
		stack = true,
		close = true,
		consume = 1,
		description = 'Schachtel',
		client = {
			--anim = 'schachtel',
			--prop = 'redwoodpack',
			usetime = 3500,
		}
	},

	['redwoodjr'] = {
		label = 'Redwood Jr.',
		weight = 1,
		stack = false,
		close = false,
		description = 'Schachtel'
	},
	['oxy_bottle'] = {
		label = 'Dose Oxycozin',
		description = 'Eine Dose voller Oxycodon Tabletten.',
		weight = 115,
		stack = true,
		close = true
	},
	['oxycontin'] = {
		label = 'Oxycontin Tablette',
		weight = 1,
		stack = true,
		close = true
	},
	['glas'] = {
		label = 'Glas',
		weight = 150,
		stack = true,
		close = true
	},
	['10gbag'] = {
		label = 'Beutel',
		weight = 1,
		stack = true,
		close = false
	},
	['licenseplate'] = {
        label = 'Kennzeichen',
        stack = false,
        weight = 100,
        close = true,
        description = "Vehicle license plate",
        client = {
            image = 'license_plate.png',
        }
    },

	----- Anfang Job Items -----
	['muell_job'] = {
		label = 'Müllsack',
		weight = 500,
		stack = true,
		close = false
	},
	----- Ende Job Items -----

	["police_stormram"] = {
		label = "Police Storm Ram",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_ak47"] = {
		label = "Ak74",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_ak47_seed"] = {
		label = "ak47 Seed",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_amnesia"] = {
		label = "Amnesia",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_amnesia_seed"] = {
		label = "Amnesia Seed",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_nutrition"] = {
		label = "Weed Nutrition",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_og-kush"] = {
		label = "OG Kush",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_og-kush_seed"] = {
		label = "OG Kush Seed",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_purple-haze"] = {
		label = "Purple Haze",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_purple-haze_seed"] = {
		label = "Purple Haze Seed",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_skunk"] = {
		label = "Skunk",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_skunk_seed"] = {
		label = "Skunk Seed",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_white-widow"] = {
		label = "White Widow",
		weight = 1,
		stack = true,
		close = true,
	},

	["weed_white-widow_seed"] = {
		label = "White Widow Seed",
		weight = 1,
		stack = true,
		close = true,
	},
	['polabsperrung01'] = {
		label = 'Abspereung 01',
		weight = 500,
		stack = true,
		close = true,
		description = 'Nur für Polizeibeamte. Sonst illegal.',
		buttons = {
			{label = 'Absperrung aufstellen',
			action = function(slot)
				TriggerServerEvent('mor_base:EinzelItemDrop','polabsperrung01', 'polabsperrung01', 1, 'prop_barrier_wat_03a')
			end},
		},
	},
}