local Data = {
	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = 'prop_rolled_sock_02', pos = { x = -0.14, y = -0.14, z = -0.08}, rot = { x = -50.0, y = -50.0, z = 0.0} },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		}
	},

	['black_money'] = {
		label = 'Dirty Money',
		weight = 0,
		stack = true,
		close = true,
	},

	['burger'] = {
		label = 'Burger',
		weight = 220,
		stack = true,
		close = true,
		client = {
			status = { hunger = 200000 },
			anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
			prop = { model = 'prop_cs_burger_01', pos = { x = 0.02, y = 0.02, z = -0.02}, rot = { x = 0.0, y = 0.0, z = 0.0} },
			usetime = 2500,
		}
	},

	['cola'] = {
		label = 'eCola',
		weight = 350,
		stack = true,
		close = true,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'prop_ecola_can', pos = { x = 0.01, y = 0.01, z = 0.06}, rot = { x = 5.0, y = 5.0, z = -180.5} },
			usetime = 2500,
		}
	},

	['parachute'] = {
		label = 'Parachute',
		weight = 8000,
		stack = false,
		close = true,
		server = {},
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	['garbage'] = {
		label = 'Garbage',
		weight = 0,
		stack = true,
		close = true,
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
		weight = 0,
		stack = true,
		close = true,
	},

	['panties'] = {
		label = 'Knickers',
		weight = 10,
		stack = true,
		close = true,
		consume = 0,
		client = {
			status = { thirst = -100000, stress = -25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'prop_cs_panties_02', pos = { x = 0.03, y = 0.0, z = 0.02 }, rot = { x = 0.0, y = -13.5, z = -1.5 } },
			usetime = 2500,
		}
	},

	['lockpick'] = {
		label = 'Lockpick',
		weight = 160,
		stack = true,
		close = true,
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
		close = true,
		consume = 0,
		client = {
			usetime = 0,
			event = 'gcPhone:forceOpenPhone'
		}
	},

	['money'] = {
		label = 'Money',
		weight = 0,
		stack = true,
		close = true,
	},

	['mustard'] = {
		label = 'Mustard',
		weight = 500,
		stack = true,
		close = true,
		client = {
			status = { hunger = 25000, thirst = 25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'prop_food_mustard', pos = { x = 0.01, y = 0.0, z = -0.07 }, rot = { x = 1.0, y = -1.0, z = -1.5 } },
			usetime = 2500,
		}
	},

	['water'] = {
		label = 'Water',
		weight = 500,
		stack = true,
		close = true,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = 'prop_ld_flow_bottle', pos = { x = 0.03, y = 0.03, z = 0.02}, rot = { x = 0.0, y = 0.0, z = -1.5} },
			usetime = 2500,
			cancel = true
		}
	},
}
