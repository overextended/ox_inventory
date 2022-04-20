return {
	['testburger'] = {
		label = 'Test Burger',
		weight = 220,
		degrade = 60,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			export = 'ox_inventory_examples.testburger'
		},
		server = {
			export = 'ox_inventory_examples.testburger',
			test = 'what an amazingly delicious burger, amirite?'
		},
		buttons = {
			{
				label = 'Lick it',
				action = function(slot)
					print('You licked the burger')
				end
			},
			{
				label = 'Squeeze it',
				action = function(slot)
					print('You squeezed the burger :(')
				end
			}
		}
	},

	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		}
	},

	['black_money'] = {
		label = 'Dirty Money',
	},

	['burger'] = {
		label = 'Burger',
		weight = 220,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'You ate a delicious burger'
		},
	},

	['cola'] = {
		label = 'eCola',
		weight = 350,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ecola_can`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'You quenched your thirst with cola'
		}
	},

	['parachute'] = {
		label = 'Parachute',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	['garbage'] = {
		label = 'Garbage',
	},

	['paperbag'] = {
		label = 'Paper Bag',
		weight = 1,
		stack = false,
		close = false,
		consume = 0
	},

	['identification'] = {
		label = 'Identification',
	},

	['knickers'] = {
		label = 'Knickers',
		weight = 10,
		consume = 0,
		client = {
			status = { thirst = -100000, stress = -25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
			usetime = 2500,
		}
	},

	['lockpick'] = {
		label = 'Lockpick',
		weight = 160,
		consume = 0,
		client = {
			anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
			disable = { move = true, car = true, combat = true },
			usetime = 5000,
			cancel = true
		}
	},

	['phone'] = {
		label = 'Phone',
		weight = 190,
		stack = false,
		consume = 0,
		client = {
			add = function(total)
				if total > 0 and GetResourceState('npwd') == 'started' then
					exports.npwd:setPhoneDisabled(false)
				end
			end,

			remove = function(total)
				if total < 1 and GetResourceState('npwd') == 'started' then
					exports.npwd:setPhoneDisabled(true)
				end
			end
		}
	},

	['money'] = {
		label = 'Money',
	},

	['mustard'] = {
		label = 'Mustard',
		weight = 500,
		client = {
			status = { hunger = 25000, thirst = 25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'You.. drank mustard'
		}
	},

	['water'] = {
		label = 'Water',
		weight = 500,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			notification = 'l\'eau, c\'est la vie'
		}
	},

	['radio'] = {
		label = 'Radio',
		weight = 1000,
		stack = false,
		consume = 0,
		allowArmed = true
	},

	['armour'] = {
		label = 'Bulletproof Vest',
		weight = 3000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
            usetime = 3500
		}
	},
	
	-- CUSTOM ADDITIONS	
	['bandage2'] = {
		label = 'Bandage',
		description = 'Permet de soigner les saignements.',
		weight = 10,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
			export = 'mista_overlay.bandage2'
		},
	},
	
	['joint'] = {
		label = 'Joint de marijuana',
		description = 'Naturel, calme le stress.',
		weight = 10,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			usetime = 2500,
			export = 'mista_overlay.smoke_joint'
		},
	},
	
	['beer'] = {
		label = 'Beer',
		weight = 250,
		client = {
			status = { thirst = 250000, hunger = 50000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_beer_pissh`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'Rien de tel qu\'une bonne bière'
		}
	},
	
	['carokit'] = {
		label = 'Kit de réparation',
		stack = false,
		description = 'Un kit de réparation de véhicule, peut faire des miracles paraît-il !',
		weight = 5000,
		client = {
			anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
			disable = { move = true, car = true, combat = true },
			-- prop = { model = `prop_tool_adjspanner`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 30000,
			cancel = true,
			export = 'mista_overlay.fix_car'
		}
	},
	
	['mollis'] = {
		label = 'Mollis',
		description = 'Destiné à combattre les troubles de l\'érection chez le mâle humain.',
		weight = 150,
		client = {
			status = { thirst = -150000, stress = 200000 },
			anim = 'eating',
			-- prop = { model = `ng_proc_drug01a002` },
			usetime = 2500,
			cancel = true,
			notification = 'SCHWING !'
		}
	},
	
	['laxomax'] = {
		label = 'Lax O Max',
		description = 'Des suppositoires composés d\'un laxatif un peu douteux..',
		weight = 150,
		client = {
			status = { thirst = -150000 },
			anim = 'eating',
			-- prop = { model = `ng_proc_drug01a002` },
			usetime = 2500,
			cancel = true,
			notification = 'Ou sont les toilettes ?!'
		}
	},
	
	['alcopatch'] = {
		label = 'Alco Patch',
		description = 'Des patchs pour arrêter de boire.. mouai',
		weight = 150,
		client = {
			status = { thirst = -150000 },
			anim = 'eating',
			-- prop = { model = `ng_proc_drug01a002` },
			usetime = 2500,
			cancel = true,
			notification = 'Ou sont les bières ?'
		}
	},
	
	['delladamol'] = {
		label = 'Delladamol',
		description = 'Un anti-douleur puissant, trop puissant',
		weight = 150,
		client = {
			status = { thirst = -150000 },
			anim = 'eating',
			-- prop = { model = `ng_proc_drug01a002` },
			usetime = 2500,
			cancel = true,
			notification = 'ouf, ça soulage..'
		}
	},
	
	['antibiotics'] = {
		label = 'Antibiotiques',
		description = 'Pas automatique, certes, mais efficace en cas d\'infection !',
		weight = 150,
		client = {
			status = { infection = -200000, thirst = -150000 },
			anim = 'eating',
			usetime = 1500,
			notification = 'Pour l\'instant, je ne sens rien..'
		}
	},
	
	['donut'] = {
		label = 'donut',
		weight = 220,
		client = {
			status = { hunger = 150000 },
			anim = 'eating',
			prop = 'prop_donut_01',
			usetime = 2500,
			notification = 'Humm des donuts..'
		},
	},
	
	['medikit'] = {
		label = 'Trousse de soin',
		description = 'Permet de soigner les infections, les saignements et restaure la santé.',
		weight = 300,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			-- prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 6000,
			export = 'mista_overlay.medikit'
		},
	},
	
	['hotdog'] = {
		label = 'hotdog',
		weight = 220,
		client = {
			status = { hunger = 180000 },
			anim = 'eating',
			prop = 'prop_cs_hotdog_01',
			usetime = 2500,
			notification = 'Même froid, un hotdog c\'est cool'
		},
	},
	
	['chipscheese'] = {
		label = 'Chips au fromage',
		weight = 220,
		client = {
			status = { hunger = 100000, thirst = -50000 },
			anim = 'eating',
			prop = 'v_ret_ml_chips4',
			usetime = 2500,
			notification = 'ça va mieux, mais ça donne soif !'
		},
	},
	
	['chipshabanero'] = {
		label = 'Chips Habanero',
		weight = 220,
		client = {
			status = { hunger = 100000, thirst = -50000 },
			anim = 'eating',
			prop = 'v_ret_ml_chips2',
			usetime = 2500,
			notification = 'ça va mieux, mais ça donne soif !'
		},
	},
	
	['chipsribs'] = {
		label = 'Chips au porc',
		weight = 220,
		client = {
			status = { hunger = 100000, thirst = -50000 },
			anim = 'eating',
			prop = 'v_ret_ml_chips1',
			usetime = 2500,
			notification = 'ça va mieux, mais ça donne soif !'
		},
	},
	
	['chipssalt'] = {
		label = 'Chips salées',
		weight = 220,
		client = {
			status = { hunger = 100000, thirst = -50000 },
			anim = 'eating',
			prop = 'v_ret_ml_chips3',
			usetime = 2500,
			notification = 'ça va mieux, mais ça donne soif !'
		},
	},
	
	['candy'] = {
		label = 'Paquet de bombecs',
		weight = 220,
		client = {
			status = { hunger = 100000, stress = -100000  },
			anim = 'eating',
			prop = 'prop_cs_burger_01',
			usetime = 2500,
			notification = 'Putain, le sucre c\'est bon !'
		},
	},
	
	['panties'] = {
		label = 'Culotte sale',
		description = 'Il y a certainement un fétichiste dans le coin..',	
	},
	
	['binoculars'] = {
		label = 'Jumelles',
		description = 'Une paire de jumelle, que dire de plus..',
		weight = 1500,
		stack = false,
		consume = 0,
		client = {
			add = function(total)
				if total > 0 and GetResourceState('binoculars') == 'started' then
					exports.binoculars:setEnabled(true)	
				end
			end,

			remove = function(total)
				if total < 1 and GetResourceState('binoculars') == 'started' then
					exports.binoculars:setEnabled(false)
				end
			end
		}
	},
	
	['vehicles_map'] = {
		label = 'Carte annotée',
		description = 'Une carte annotée par un survivant, il ou elle y a marqué des emplacements de véhicules.',
		weight = 250,
		stack = false,
		consume = 0,
		client = {
			add = function(total)
				if total > 0 and GetResourceState('vehicle_spawn') == 'started' then
					exports.vehicle_spawn:setBlipsEnabled(true)	
				end
			end,

			remove = function(total)
				if total < 1 and GetResourceState('vehicle_spawn') == 'started' then
					exports.vehicle_spawn:setBlipsEnabled(false)
				end
			end
		}
	},
	
	['backpack'] = {
		label = 'Sac à dos',
		description = 'Un sac à dos bien pratique.',
		weight = 2500,
		stack = false,
		close = false,
		consume = 0,
		client = {
			add = function(total)
				if total > 0 and GetResourceState('mista_overlay') == 'started' then
					exports.mista_overlay:equipBackpack(total)	
				end
			end,
			remove = function(total)
				if total < 1 and GetResourceState('mista_overlay') == 'started' then
					exports.mista_overlay:dropBackpack(total)
				end
			end
		}
	},
	
}
