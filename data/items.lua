return {
	['testburger'] = {
		label = 'Test Burger',
		weight = 220,
		degrade = 4320,
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

	['burger'] = {
		label = 'Burger',
		weight = 220,
		degrade = 4320,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			--notification = 'You ate a delicious Burger.'
		},
	},

	['water'] = {
		label = 'Water',
		weight = 500,
		degrade = 4320,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, - 1.5) },
			usetime = 2500,
			cancel = true,
			--notification = 'You drank some refreshing Water.'
		}
	},

	['cola'] = {
		label = 'Cola',
		weight = 350,
		degrade = 4320,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ecola_can`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, - 180.5) },
			usetime = 2500,
			--notification = 'You quenched your thirst with Cola.'
		}
	},

	['snickers'] = {
		label = 'Snickers',
		weight = 220,
		degrade = 4320,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = { model = `prop_choc_ego`, pos = vec3(0, 0, 0), rot = vec3(0, 0, 0) },
			usetime = 2500,
			--notification = 'You ate a delicious Snickers chocolate bar.'
		},
	},

	['donut'] = {
		label = 'Donut',
		weight = 220,
		degrade = 4320,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = { model = `prop_donut_02`, pos = vec3(0, 0, 0), rot = vec3(0, 0, 0) },
			usetime = 2500,
			--notification = 'You ate a delicious Donut.'
		},
	},

	['beer'] = {
		label = 'Beer',
		weight = 350,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_amb_beer_bottle`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, - 180.5) },
			usetime = 2500,
			--notification = 'You drank a refreshing Beer.'
		}
	},

	['taco'] = {
		label = 'Taco',
		weight = 220,
		degrade = 4320,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = { model = `prop_taco_01`, pos = vec3(0, 0, 0), rot = vec3(0, 0, 0) },
			usetime = 2500,
			--notification = 'You ate a delicious Taco.'
		},
	},

	['bsfries'] = {
		label = 'Burgershot Fries',
		weight = 220,
		degrade = 4320,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = { model = `prop_food_bs_chips`, pos = vec3(0, 0, 0), rot = vec3(0, 0, 0) },
			usetime = 2500,
			--notification = 'You ate some delicious Burgershot fries.'
		},
	},

	['candy'] = {
		label = 'Candy',
		weight = 220,
		degrade = 4320,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = { model = `prop_candy_pqs`, pos = vec3(0, 0, 0), rot = vec3(0, 0, 0) },
			usetime = 2500,
			--notification = 'You ate some delicious Candy.'
		},
	},

	['hotdog'] = {
		label = 'Hotdog',
		weight = 220,
		degrade = 4320,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = { model = `prop_cs_hotdog_01`, pos = vec3(0, 0, 0), rot = vec3(0, 0, 0) },
			usetime = 2500,
			--notification = 'You ate a delicious Hotdog.'
		},
	},

	['ramen'] = {
		label = 'Cup Noodles',
		weight = 220,
		degrade = 4320,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = { model = `v_ret_247_noodle1`, pos = vec3(0, 0, 0), rot = vec3(0, 0, 0) },
			usetime = 2500,
			--notification = 'You ate some delicious Cup Noodles.'
		},
	},

	['cheesechips'] = {
		label = 'Cheese Chips',
		weight = 220,
		degrade = 4320,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = { model = `v_ret_ml_chips4`, pos = vec3(0, 0, 0), rot = vec3(0, 0, 0) },
			usetime = 2500,
			--notification = 'You ate some delicious Cheese Chips.'
		},
	},

	['ribchips'] = {
		label = 'Rib Chips',
		weight = 220,
		degrade = 4320,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = { model = `v_ret_ml_chips1`, pos = vec3(0, 0, 0), rot = vec3(0, 0, 0) },
			usetime = 2500,
			--notification = 'You ate some delicious Rib Chips.'
		},
	},

	['saltchips'] = {
		label = 'Salt Chips',
		weight = 220,
		degrade = 4320,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = { model = `v_ret_ml_chips3`, pos = vec3(0, 0, 0), rot = vec3(0, 0, 0) },
			usetime = 2500,
			--notification = 'You ate some delicious Salt Chips.'
		},
	},

	['habanerochips'] = {
		label = 'Habanero Chips',
		weight = 220,
		degrade = 4320,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = { model = `v_ret_ml_chips2`, pos = vec3(0, 0, 0), rot = vec3(0, 0, 0) },
			usetime = 2500,
			--notification = 'You ate some delicious Habanero Chips.'
		},
	},

	['fanta'] = {
		label = 'Fanta',
		weight = 350,
		degrade = 4320,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_can_01`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, - 180.5) },
			usetime = 2500,
			--notification = 'You quenched your thirst with Fanta.'
		}
	},

	-------------------------------------------------------------------------------
	-- Core
	-------------------------------------------------------------------------------
	['money'] = {
		label = 'Money',
	},

	['black_money'] = {
		label = 'Dirty Money',
	},

	['garbage'] = {
		label = 'Garbage',
	},

	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		description = 'Woven strip of material with absorbent barrier to prevent adhering to wounds.',
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.04, 0, - 0.05), rot = vec3(-50.0, - 50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
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

	['panties'] = {
		label = 'Knickers',
		weight = 10,
		consume = 0,
		client = {
			status = { thirst = -100000, stress = -25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, - 13.5, - 1.5) },
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
				if total > 0 and GetResourceState('high_phone') == 'started' then
					exports.high_phone:openPhone(false)
				end
			end,

			remove = function(total)
				if total < 1 and GetResourceState('high_phone') == 'started' then
					exports.high_phone:openPhone(true)
				end
			end
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

	-------------------------------------------------------------------------------
	-- Containers
	-------------------------------------------------------------------------------
	['paperbag'] = {
		label = 'Paper Bag',
		weight = 1,
		stack = false,
		close = false,
		consume = 0
	},

	['backpack'] = {
		label = 'Backpack',
		weight = 1,
		stack = false,
		close = false,
		description = 'Also called rucksack, knapsack, packsack, pack, Haversack, or Berge. Used to carry things in it, and it often has many pockets or compartments to carry things.',
		client = {
			add = function(total)
				if total > 0 and GetResourceState('ybn_essential') == 'started' then
					exports.ybn_essential:setBackpackOn()
				end
			end,
			remove = function(total)
				if total < 1 and GetResourceState('ybn_essential') == 'started' then
					exports.ybn_essential:setBackpackOff()
				end
			end
		}
	},

	-------------------------------------------------------------------------------
	-- Extra
	-------------------------------------------------------------------------------
	['binoculars'] = {
		label = 'Binoculars',
		weight = 850,
		stack = false,
		close = true,
		description = 'A useful tool to spy on people or perhaps go sight seeing.',
		client = {
			export = 'ybn_essential.binoculars'
		}
	},

	['amongus'] = {
		label = 'Imposter',
		weight = 1,
		stack = false,
		close = true,
		description = 'Absolutely not the impostor ඞ.',
	},

	-------------------------------------------------------------------------------
	-- drugs
	-------------------------------------------------------------------------------
	['joint'] = {
		label = 'joint',
		weight = 2,
		stack = true,
		close = true,
		description = 'Prerolled Joint: 2 Grams',
		client = {
			export = 'ybn_essential.smokeJoint'
		}
	},

	['meth'] = {
		label = 'Meth 5G',
		weight = 5,
		stack = true,
		close = true,
		description = 'Methamphetamine: 5 Grams'
	},

	['cocaine'] = {
		label = 'Cocaine 3G',
		weight = 3,
		stack = true,
		close = true,
		description = 'Cocaine: 3 Grams'
	},

	['cerealmilk'] = {
		label = 'Cereal Milk 3.5G',
		weight = 3.5,
		stack = true,
		close = true,
		description = 'Marijuana: 3.5 Grams'
	},

	['cerealmilk1g'] = {
		label = 'Cereal Milk 1G',
		weight = 1,
		stack = true,
		close = true,
		description = 'Marijuana: 1 Gram'
	},

	['jefe'] = {
		label = 'Jefe 3.5G',
		weight = 3.5,
		stack = true,
		close = true,
		description = 'Marijuana: 3.5 Grams'
	},

	['jefe1g'] = {
		label = 'Jefe 1G',
		weight = 1,
		stack = true,
		close = true,
		description = 'Marijuana: 1 Gram'
	},

	['codeine'] = {
		label = 'Pint of Codeine',
		weight = 473,
		stack = true,
		close = true,
		description = 'Codeine: 16 Ounces'
	},
}
