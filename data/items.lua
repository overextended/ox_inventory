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
			},
			{
				label = 'What do you call a vegan burger?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('A misteak.')
				end
			},
			{
				label = 'What do frogs like to eat with their hamburgers?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('French flies.')
				end
			},
			{
				label = 'Why were the burger and fries running?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('Because they\'re fast food.')
				end
			}
		},
		consume = 0.3
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

	['panties'] = {
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
	},

	['phone'] = {
		label = 'Phone',
		weight = 190,
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
			cancel = true,
			notification = 'You drank some refreshing water'
		}
	},

	['radio'] = {
		label = 'Radio',
		weight = 1000,
		stack = false,
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

	['clothing'] = {
		label = 'Clothing',
		consume = 0,
	},

	['mastercard'] = {
		label = 'Mastercard',
		stack = false,
		weight = 10,
	},

	['scrapmetal'] = {
		label = 'Scrap Metal',
		weight = 80,
	},

	["10kgoldchain"] = {
		label = "10k Gold Chain",
		weight = 2000,
		stack = true,
		close = true,
		description = "10 carat golden chain",
		client = {
			image = "10kgoldchain.png",
		}
	},

	["painkillers"] = {
		label = "Painkillers",
		weight = 0,
		stack = true,
		close = true,
		description = "For pain you can't stand anymore, take this pill that'd make you feel great again",
		client = {
			image = "painkillers.png",
		}
	},

	["empty_evidence_bag"] = {
		label = "Empty Evidence Bag",
		weight = 0,
		stack = true,
		close = false,
		description = "Used a lot to keep DNA from blood, bullet shells and more",
		client = {
			image = "evidence.png",
		}
	},

	["lighter"] = {
		label = "Lighter",
		weight = 0,
		stack = true,
		close = true,
		description = "On new years eve a nice fire to stand next to",
		client = {
			image = "lighter.png",
		}
	},

	["repairkit"] = {
		label = "Repairkit",
		weight = 2500,
		stack = true,
		close = true,
		description = "A nice toolbox with stuff to repair your vehicle",
		client = {
			image = "repairkit.png",
		}
	},

	["vodka"] = {
		label = "Vodka",
		weight = 500,
		stack = true,
		close = true,
		description = "For all the thirsty out there",
		client = {
			image = "vodka.png",
		}
	},

	["iphone"] = {
		label = "iPhone",
		weight = 1000,
		stack = true,
		close = true,
		description = "Very expensive phone",
		client = {
			image = "iphone.png",
		}
	},

	["firework3"] = {
		label = "WipeOut",
		weight = 1000,
		stack = true,
		close = true,
		description = "Fireworks",
		client = {
			image = "firework3.png",
		}
	},

	["metalscrap"] = {
		label = "Metal Scrap",
		weight = 100,
		stack = true,
		close = false,
		description = "You can probably make something nice out of this",
		client = {
			image = "metalscrap.png",
		}
	},

	["weed_white-widow"] = {
		label = "White Widow 2g",
		weight = 200,
		stack = true,
		close = false,
		description = "A weed bag with 2g White Widow",
		client = {
			image = "weed_baggy.png",
		}
	},

	["weed_skunk"] = {
		label = "Skunk 2g",
		weight = 200,
		stack = true,
		close = false,
		description = "A weed bag with 2g Skunk",
		client = {
			image = "weed_baggy.png",
		}
	},

	["empty_weed_bag"] = {
		label = "Empty Weed Bag",
		weight = 0,
		stack = true,
		close = true,
		description = "A small empty bag",
		client = {
			image = "weed_baggy_empty.png",
		}
	},

	["visa"] = {
		label = "Visa Card",
		weight = 0,
		stack = false,
		close = false,
		description = "Visa can be used via ATM",
		client = {
			image = "visacard.png",
		}
	},

	["screwdriverset"] = {
		label = "Toolkit",
		weight = 1000,
		stack = true,
		close = false,
		description = "Very useful to screw... screws...",
		client = {
			image = "screwdriverset.png",
		}
	},

	["gatecrack"] = {
		label = "Gatecrack",
		weight = 0,
		stack = true,
		close = true,
		description = "Handy software to tear down some fences",
		client = {
			image = "usb_device.png",
		}
	},

	["security_card_01"] = {
		label = "Security Card A",
		weight = 0,
		stack = true,
		close = true,
		description = "A security card... I wonder what it goes to",
		client = {
			image = "security_card_01.png",
		}
	},

	["firework1"] = {
		label = "2Brothers",
		weight = 1000,
		stack = true,
		close = true,
		description = "Fireworks",
		client = {
			image = "firework1.png",
		}
	},

	["id_card"] = {
		label = "ID Card",
		weight = 0,
		stack = false,
		close = false,
		description = "A card containing all your information to identify yourself",
		client = {
			image = "id_card.png",
		}
	},

	["cokebaggy"] = {
		label = "Bag of Coke",
		weight = 0,
		stack = true,
		close = true,
		description = "To get happy real quick",
		client = {
			image = "cocaine_baggy.png",
		}
	},

	["certificate"] = {
		label = "Certificate",
		weight = 0,
		stack = true,
		close = true,
		description = "Certificate that proves you own certain stuff",
		client = {
			image = "certificate.png",
		}
	},

	["armor"] = {
		label = "Armor",
		weight = 5000,
		stack = true,
		close = true,
		description = "Some protection won't hurt... right?",
		client = {
			image = "armor.png",
		}
	},

	["nitrous"] = {
		label = "Nitrous",
		weight = 1000,
		stack = true,
		close = true,
		description = "Speed up, gas pedal! :D",
		client = {
			image = "nitrous.png",
		}
	},

	["advancedrepairkit"] = {
		label = "Advanced Repairkit",
		weight = 4000,
		stack = true,
		close = true,
		description = "A nice toolbox with stuff to repair your vehicle",
		client = {
			image = "advancedkit.png",
		}
	},

	["security_card_02"] = {
		label = "Security Card B",
		weight = 0,
		stack = true,
		close = true,
		description = "A security card... I wonder what it goes to",
		client = {
			image = "security_card_02.png",
		}
	},

	["radioscanner"] = {
		label = "Radio Scanner",
		weight = 1000,
		stack = true,
		close = true,
		description = "With this you can get some police alerts. Not 100% effective however",
		client = {
			image = "radioscanner.png",
		}
	},

	["dendrogyra_coral"] = {
		label = "Dendrogyra",
		weight = 1000,
		stack = true,
		close = true,
		description = "Its also known as pillar coral",
		client = {
			image = "dendrogyra_coral.png",
		}
	},

	["firstaid"] = {
		label = "First Aid",
		weight = 2500,
		stack = true,
		close = true,
		description = "You can use this First Aid kit to get people back on their feet",
		client = {
			image = "firstaid.png",
		}
	},

	["police_stormram"] = {
		label = "Stormram",
		weight = 18000,
		stack = true,
		close = true,
		description = "A nice tool to break into doors",
		client = {
			image = "police_stormram.png",
		}
	},

	["weed_white-widow_seed"] = {
		label = "White Widow Seed",
		weight = 0,
		stack = true,
		close = false,
		description = "A weed seed of White Widow",
		client = {
			image = "weed_seed.png",
		}
	},

	["diving_gear"] = {
		label = "Diving Gear",
		weight = 30000,
		stack = false,
		close = true,
		description = "An oxygen tank and a rebreather",
		client = {
			image = "diving_gear.png",
		}
	},

	["rolex"] = {
		label = "Golden Watch",
		weight = 1500,
		stack = true,
		close = true,
		description = "A golden watch seems like the jackpot to me!",
		client = {
			image = "rolex.png",
		}
	},

	["tablet"] = {
		label = "Tablet",
		weight = 2000,
		stack = true,
		close = true,
		description = "Expensive tablet",
		client = {
			image = "tablet.png",
		}
	},

	["labkey"] = {
		label = "Key",
		weight = 500,
		stack = false,
		close = true,
		description = "Key for a lock...?",
		client = {
			image = "labkey.png",
		}
	},

	["water_bottle"] = {
		label = "Bottle of Water",
		weight = 500,
		stack = true,
		close = true,
		description = "For all the thirsty out there",
		client = {
			image = "water_bottle.png",
		}
	},

	["grapejuice"] = {
		label = "Grape Juice",
		weight = 200,
		stack = true,
		close = false,
		description = "Grape juice is said to be healthy",
		client = {
			image = "grapejuice.png",
		}
	},

	["weed_og-kush"] = {
		label = "OGKush 2g",
		weight = 200,
		stack = true,
		close = false,
		description = "A weed bag with 2g OG Kush",
		client = {
			image = "weed_baggy.png",
		}
	},

	["ironoxide"] = {
		label = "Iron Powder",
		weight = 100,
		stack = true,
		close = false,
		description = "Some powder to mix with.",
		client = {
			image = "ironoxide.png",
		}
	},

	["aluminum"] = {
		label = "Aluminium",
		weight = 100,
		stack = true,
		close = false,
		description = "Nice piece of metal that you can probably use for something",
		client = {
			image = "aluminum.png",
		}
	},

	["lawyerpass"] = {
		label = "Lawyer Pass",
		weight = 0,
		stack = false,
		close = false,
		description = "Pass exclusive to lawyers to show they can represent a suspect",
		client = {
			image = "lawyerpass.png",
		}
	},

	["plastic"] = {
		label = "Plastic",
		weight = 100,
		stack = true,
		close = false,
		description = "RECYCLE! - Greta Thunberg 2019",
		client = {
			image = "plastic.png",
		}
	},

	["cleaningkit"] = {
		label = "Cleaning Kit",
		weight = 250,
		stack = true,
		close = true,
		description = "A microfiber cloth with some soap will let your car sparkle again!",
		client = {
			image = "cleaningkit.png",
		}
	},

	["coke_small_brick"] = {
		label = "Coke Package",
		weight = 350,
		stack = false,
		close = true,
		description = "Small package of cocaine, mostly used for deals and takes a lot of space",
		client = {
			image = "coke_small_brick.png",
		}
	},

	["stickynote"] = {
		label = "Sticky note",
		weight = 0,
		stack = false,
		close = false,
		description = "Sometimes handy to remember something :)",
		client = {
			image = "stickynote.png",
		}
	},

	["wine"] = {
		label = "Wine",
		weight = 300,
		stack = true,
		close = false,
		description = "Some good wine to drink on a fine evening",
		client = {
			image = "wine.png",
		}
	},

	["rubber"] = {
		label = "Rubber",
		weight = 100,
		stack = true,
		close = false,
		description = "Rubber, I believe you can make your own rubber ducky with it :D",
		client = {
			image = "rubber.png",
		}
	},

	["iron"] = {
		label = "Iron",
		weight = 100,
		stack = true,
		close = false,
		description = "Handy piece of metal that you can probably use for something",
		client = {
			image = "iron.png",
		}
	},

	["thermite"] = {
		label = "Thermite",
		weight = 1000,
		stack = true,
		close = true,
		description = "Sometimes you'd wish for everything to burn",
		client = {
			image = "thermite.png",
		}
	},

	["beer"] = {
		label = "Beer",
		weight = 500,
		stack = true,
		close = true,
		description = "Nothing like a good cold beer!",
		client = {
			image = "beer.png",
		}
	},

	["ifaks"] = {
		label = "ifaks",
		weight = 200,
		stack = true,
		close = true,
		description = "ifaks for healing and a complete stress remover.",
		client = {
			image = "ifaks.png",
		}
	},

	["sandwich"] = {
		label = "Sandwich",
		weight = 200,
		stack = true,
		close = true,
		description = "Nice bread for your stomach",
		client = {
			image = "sandwich.png",
		}
	},

	["grape"] = {
		label = "Grape",
		weight = 100,
		stack = true,
		close = false,
		description = "Mmmmh yummie, grapes",
		client = {
			image = "grape.png",
		}
	},

	["firework2"] = {
		label = "Poppelers",
		weight = 1000,
		stack = true,
		close = true,
		description = "Fireworks",
		client = {
			image = "firework2.png",
		}
	},

	["casinochips"] = {
		label = "Casino Chips",
		weight = 0,
		stack = true,
		close = false,
		description = "Chips For Casino Gambling",
		client = {
			image = "casinochips.png",
		}
	},

	["heavyarmor"] = {
		label = "Heavy Armor",
		weight = 5000,
		stack = true,
		close = true,
		description = "Some protection won't hurt... right?",
		client = {
			image = "armor.png",
		}
	},

	["oxy"] = {
		label = "Prescription Oxy",
		weight = 0,
		stack = true,
		close = true,
		description = "The Label Has Been Ripped Off",
		client = {
			image = "oxy.png",
		}
	},

	["diving_fill"] = {
		label = "Diving Tube",
		weight = 3000,
		stack = false,
		close = true,
		client = {
			image = "diving_tube.png",
		}
	},

	["copper"] = {
		label = "Copper",
		weight = 100,
		stack = true,
		close = false,
		description = "Nice piece of metal that you can probably use for something",
		client = {
			image = "copper.png",
		}
	},

	["walkstick"] = {
		label = "Walking Stick",
		weight = 1000,
		stack = true,
		close = true,
		description = "Walking stick for ya'll grannies out there.. HAHA",
		client = {
			image = "walkstick.png",
		}
	},

	["antipatharia_coral"] = {
		label = "Antipatharia",
		weight = 1000,
		stack = true,
		close = true,
		description = "Its also known as black corals or thorn corals",
		client = {
			image = "antipatharia_coral.png",
		}
	},

	["weed_amnesia_seed"] = {
		label = "Amnesia Seed",
		weight = 0,
		stack = true,
		close = true,
		description = "A weed seed of Amnesia",
		client = {
			image = "weed_seed.png",
		}
	},

	["joint"] = {
		label = "Joint",
		weight = 0,
		stack = true,
		close = true,
		description = "Sidney would be very proud at you",
		client = {
			image = "joint.png",
		}
	},

	["advancedlockpick"] = {
		label = "Advanced Lockpick",
		weight = 500,
		stack = true,
		close = true,
		description = "If you lose your keys a lot this is very useful... Also useful to open your beers",
		client = {
			image = "advancedlockpick.png",
		}
	},

	["weed_nutrition"] = {
		label = "Plant Fertilizer",
		weight = 2000,
		stack = true,
		close = true,
		description = "Plant nutrition",
		client = {
			image = "weed_nutrition.png",
		}
	},

	["goldbar"] = {
		label = "Gold Bar",
		weight = 7000,
		stack = true,
		close = true,
		description = "Looks pretty expensive to me",
		client = {
			image = "goldbar.png",
		}
	},

	["diamond"] = {
		label = "Diamond",
		weight = 1000,
		stack = true,
		close = true,
		description = "A diamond seems like the jackpot to me!",
		client = {
			image = "diamond.png",
		}
	},

	["microwave"] = {
		label = "Microwave",
		weight = 46000,
		stack = false,
		close = true,
		description = "Microwave",
		client = {
			image = "placeholder.png",
		}
	},

	["coffee"] = {
		label = "Coffee",
		weight = 200,
		stack = true,
		close = true,
		description = "Pump 4 Caffeine",
		client = {
			image = "coffee.png",
		}
	},

	["markedbills"] = {
		label = "Marked Money",
		weight = 1000,
		stack = false,
		close = true,
		description = "Money?",
		client = {
			image = "markedbills.png",
		}
	},

	["laptop"] = {
		label = "Laptop",
		weight = 4000,
		stack = true,
		close = true,
		description = "Expensive laptop",
		client = {
			image = "laptop.png",
		}
	},

	["weed_ak47"] = {
		label = "AK47 2g",
		weight = 200,
		stack = true,
		close = false,
		description = "A weed bag with 2g AK47",
		client = {
			image = "weed_baggy.png",
		}
	},

	["rolling_paper"] = {
		label = "Rolling Paper",
		weight = 0,
		stack = true,
		close = true,
		description = "Paper made specifically for encasing and smoking tobacco or cannabis.",
		client = {
			image = "rolling_paper.png",
		}
	},

	["xtcbaggy"] = {
		label = "Bag of XTC",
		weight = 0,
		stack = true,
		close = true,
		description = "Pop those pills baby",
		client = {
			image = "xtc_baggy.png",
		}
	},

	["samsungphone"] = {
		label = "Samsung S10",
		weight = 1000,
		stack = true,
		close = true,
		description = "Very expensive phone",
		client = {
			image = "samsungphone.png",
		}
	},

	["weed_purple-haze_seed"] = {
		label = "Purple Haze Seed",
		weight = 0,
		stack = true,
		close = true,
		description = "A weed seed of Purple Haze",
		client = {
			image = "weed_seed.png",
		}
	},

	["driver_license"] = {
		label = "Drivers License",
		weight = 0,
		stack = false,
		close = false,
		description = "Permit to show you can drive a vehicle",
		client = {
			image = "driver_license.png",
		}
	},

	["printerdocument"] = {
		label = "Document",
		weight = 500,
		stack = false,
		close = true,
		description = "A nice document",
		client = {
			image = "printerdocument.png",
		}
	},

	["weaponlicense"] = {
		label = "Weapon License",
		weight = 0,
		stack = false,
		close = true,
		description = "Weapon License",
		client = {
			image = "weapon_license.png",
		}
	},

	["diamond_ring"] = {
		label = "Diamond Ring",
		weight = 1500,
		stack = true,
		close = true,
		description = "A diamond ring seems like the jackpot to me!",
		client = {
			image = "diamond_ring.png",
		}
	},

	["weed_amnesia"] = {
		label = "Amnesia 2g",
		weight = 200,
		stack = true,
		close = false,
		description = "A weed bag with 2g Amnesia",
		client = {
			image = "weed_baggy.png",
		}
	},

	["harness"] = {
		label = "Race Harness",
		weight = 1000,
		stack = false,
		close = true,
		description = "Racing Harness so no matter what you stay in the car",
		client = {
			image = "harness.png",
		}
	},

	["electronickit"] = {
		label = "Electronic Kit",
		weight = 100,
		stack = true,
		close = true,
		description = "If you've always wanted to build a robot you can maybe start here. Maybe you'll be the new Elon Musk?",
		client = {
			image = "electronickit.png",
		}
	},

	["weed_brick"] = {
		label = "Weed Brick",
		weight = 1000,
		stack = true,
		close = true,
		description = "1KG Weed Brick to sell to large customers.",
		client = {
			image = "weed_brick.png",
		}
	},

	["goldchain"] = {
		label = "Golden Chain",
		weight = 1500,
		stack = true,
		close = true,
		description = "A golden chain seems like the jackpot to me!",
		client = {
			image = "goldchain.png",
		}
	},

	["aluminumoxide"] = {
		label = "Aluminium Powder",
		weight = 100,
		stack = true,
		close = false,
		description = "Some powder to mix with",
		client = {
			image = "aluminumoxide.png",
		}
	},

	["pinger"] = {
		label = "Pinger",
		weight = 1000,
		stack = true,
		close = true,
		description = "With a pinger and your phone you can send out your location",
		client = {
			image = "pinger.png",
		}
	},

	["firework4"] = {
		label = "Weeping Willow",
		weight = 1000,
		stack = true,
		close = true,
		description = "Fireworks",
		client = {
			image = "firework4.png",
		}
	},

	["weed_purple-haze"] = {
		label = "Purple Haze 2g",
		weight = 200,
		stack = true,
		close = false,
		description = "A weed bag with 2g Purple Haze",
		client = {
			image = "weed_baggy.png",
		}
	},

	["steel"] = {
		label = "Steel",
		weight = 100,
		stack = true,
		close = false,
		description = "Nice piece of metal that you can probably use for something",
		client = {
			image = "steel.png",
		}
	},

	["weed_ak47_seed"] = {
		label = "AK47 Seed",
		weight = 0,
		stack = true,
		close = true,
		description = "A weed seed of AK47",
		client = {
			image = "weed_seed.png",
		}
	},

	["twerks_candy"] = {
		label = "Twerks",
		weight = 100,
		stack = true,
		close = true,
		description = "Some delicious candy :O",
		client = {
			image = "twerks_candy.png",
		}
	},

	["whiskey"] = {
		label = "Whiskey",
		weight = 500,
		stack = true,
		close = true,
		description = "For all the thirsty out there",
		client = {
			image = "whiskey.png",
		}
	},

	["kurkakola"] = {
		label = "Cola",
		weight = 500,
		stack = true,
		close = true,
		description = "For all the thirsty out there",
		client = {
			image = "cola.png",
		}
	},

	["tosti"] = {
		label = "Grilled Cheese Sandwich",
		weight = 200,
		stack = true,
		close = true,
		description = "Nice to eat",
		client = {
			image = "tosti.png",
		}
	},

	["weed_skunk_seed"] = {
		label = "Skunk Seed",
		weight = 0,
		stack = true,
		close = true,
		description = "A weed seed of Skunk",
		client = {
			image = "weed_seed.png",
		}
	},

	["toaster"] = {
		label = "Toaster",
		weight = 18000,
		stack = false,
		close = true,
		description = "Toast",
		client = {
			image = "placeholder.png",
		}
	},

	["jerry_can"] = {
		label = "Jerrycan 20L",
		weight = 20000,
		stack = true,
		close = true,
		description = "A can full of Fuel",
		client = {
			image = "jerry_can.png",
		}
	},

	["handcuffs"] = {
		label = "Handcuffs",
		weight = 100,
		stack = true,
		close = true,
		description = "Comes in handy when people misbehave. Maybe it can be used for something else?",
		client = {
			image = "handcuffs.png",
		}
	},

	["snikkel_candy"] = {
		label = "Snikkel",
		weight = 100,
		stack = true,
		close = true,
		description = "Some delicious candy :O",
		client = {
			image = "snikkel_candy.png",
		}
	},

	["moneybag"] = {
		label = "Money Bag",
		weight = 0,
		stack = false,
		close = true,
		description = "A bag with cash",
		client = {
			image = "moneybag.png",
		}
	},

	["cryptostick"] = {
		label = "Crypto Stick",
		weight = 200,
		stack = false,
		close = true,
		description = "Why would someone ever buy money that doesn't exist.. How many would it contain..?",
		client = {
			image = "cryptostick.png",
		}
	},

	["coke_brick"] = {
		label = "Coke Brick",
		weight = 1000,
		stack = false,
		close = true,
		description = "Heavy package of cocaine, mostly used for deals and takes a lot of space",
		client = {
			image = "coke_brick.png",
		}
	},

	["filled_evidence_bag"] = {
		label = "Evidence Bag",
		weight = 200,
		stack = false,
		close = false,
		description = "A filled evidence bag to see who committed the crime >:(",
		client = {
			image = "evidence.png",
		}
	},

	["crack_baggy"] = {
		label = "Bag of Crack",
		weight = 0,
		stack = true,
		close = true,
		description = "To get happy faster",
		client = {
			image = "crack_baggy.png",
		}
	},

	["glass"] = {
		label = "Glass",
		weight = 100,
		stack = true,
		close = false,
		description = "It is very fragile, watch out",
		client = {
			image = "glass.png",
		}
	},

	["small_tv"] = {
		label = "Small TV",
		weight = 30000,
		stack = false,
		close = true,
		description = "TV",
		client = {
			image = "placeholder.png",
		}
	},

	["trojan_usb"] = {
		label = "Trojan USB",
		weight = 0,
		stack = true,
		close = true,
		description = "Handy software to shut down some systems",
		client = {
			image = "usb_device.png",
		}
	},

	["meth"] = {
		label = "Meth",
		weight = 100,
		stack = true,
		close = true,
		description = "A baggie of Meth",
		client = {
			image = "meth_baggy.png",
		}
	},

	["binoculars"] = {
		label = "Binoculars",
		weight = 600,
		stack = true,
		close = true,
		description = "Sneaky Breaky...",
		client = {
			image = "binoculars.png",
		}
	},

	["weed_og-kush_seed"] = {
		label = "OGKush Seed",
		weight = 0,
		stack = true,
		close = true,
		description = "A weed seed of OG Kush",
		client = {
			image = "weed_seed.png",
		}
	},

	["drill"] = {
		label = "Drill",
		weight = 20000,
		stack = true,
		close = false,
		description = "The real deal...",
		client = {
			image = "drill.png",
		}
	},
	['morphine'] = {
		label = 'Morphine',
		weight = 100,
		description = 'A box of morphine',
	},
	['fentanyl'] = {
		label = 'Fentanyl',
		weight = 100,
		description = 'A box of Fentanyl',
	},

	-- Mechanic Stuff

	['mechanic_washing_kit'] = {
    	label = 'Car Wash Kit',
    	weight = 50,
		name = 'mechanic_washing_kit',
		description = "Car Washing Kit",
		useable = true,
    },

	['mechanic_paint_spray'] = {
    	label = 'Paint Spray',
    	weight = 50,
		name = 'mechanic_paint_spray',
		description = "Paint Spray",
		useable = true,
    },

	['mechanic_engine_lvl1'] = {
    	label = 'Engine LVL1',
    	weight = 100,
		name = 'mechanic_engine_lvl1',
		description = "Engine Level 1",
		useable = true,
    },

	['mechanic_engine_lvl2'] = {
    	label = 'Engine LVL2',
    	weight = 100,
		name = 'mechanic_engine_lvl2',
		description = "Engine Level 2",
		useable = true,
    },

	['mechanic_engine_lvl3'] = {
    	label = 'Engine LVL3',
    	weight = 100,
		name = 'mechanic_engine_lvl3',
		description = "Engine Level 3",
		useable = true,
    },
	
	['mechanic_engine_lvl4'] = {
    	label = 'Engine LVL4',
    	weight = 100,
		name = 'mechanic_engine_lvl4',
		description = "Engine Level 4",
		useable = true,
    },
		
	['mechanic_transmission_lvl1'] = {
    	label = 'Transmission LVL1',
    	weight = 100,
		name = 'mechanic_transmission_lvl1',
		description = "Transmission Level 1",
		useable = true,
    },
			
	['mechanic_transmission_lvl2'] = {
    	label = 'Transmission LVL2',
    	weight = 100,
		name = 'mechanic_transmission_lvl2',
		description = "Transmission Level 2",
		useable = true,
    },
				
	['mechanic_transmission_lvl3'] = {
    	label = 'Transmission LVL3',
    	weight = 100,
		name = 'mechanic_transmission_lvl3',
		description = "Transmission Level 3",
		useable = true,
    },
						
	['mechanic_suspension_lvl1'] = {
    	label = 'Suspension LVL1',
    	weight = 100,
		name = 'mechanic_suspension_lvl1',
		description = "Suspension Level 1",
		useable = true,
    },
							
	['mechanic_suspension_lvl2'] = {
    	label = 'Suspension LVL2',
    	weight = 100,
		name = 'mechanic_suspension_lvl1',
		description = "Suspension Level 2",
		useable = true,
    },
								
	['mechanic_suspension_lvl3'] = {
    	label = 'Suspension LVL3',
    	weight = 100,
		name = 'mechanic_suspension_lvl3',
		description = "Suspension Level 3",
		useable = true,
    },		

	['mechanic_suspension_lvl4'] = {
    	label = 'Suspension LVL4',
    	weight = 100,
		name = 'mechanic_suspension_lvl4',
		description = "Suspension Level 4",
		useable = true,
    },

	['mechanic_turbo'] = {
    	label = 'Turbo',
    	weight = 100,
		name = 'mechanic_turbo',
		description = "Turbo",
		useable = true,
    },

	['mechanic_armor'] = {
    	label = 'Armor',
    	weight = 100,
		name = 'mechanic_armor',
		description = "Armor",
		useable = true,
    },

	['mechanic_tools'] = {
    	label = 'Mechanic Tools',
    	weight = 100,
		name = 'mechanic_tools',
		description = "Mechanic Tools",
		useable = true,
    },

	['mechanic_toolbox'] = {
    	label = 'Portable Tool Box',
    	weight = 100,
		name = 'mechanic_toolbox',
		description = "Portable Tool Box",
		useable = true,
    },

	['mechanic_neons_controller'] = {
    	label = 'Neon Controller',
    	weight = 100,
		name = 'mechanic_neons_controller',
		description = "Neon Controller",
		useable = true,
    },

	['mechanic_brakes_lvl1'] = {
    	label = 'Brakes LVL1',
    	weight = 100,
		name = 'mechanic_brakes_lvl1',
		description = "Brakes Level 1",
		useable = true,
    },

	['mechanic_brakes_lvl2'] = {
    	label = 'Brakes LVL2',
    	weight = 100,
		name = 'mechanic_brakes_lvl2',
		description = "Brakes Level 2",
		useable = true,
    },

	['mechanic_brakes_lvl3'] = {
    	label = 'Brakes LVL3',
    	weight = 100,
		name = 'mechanic_brakes_lvl3',
		description = "Brakes Level 3",
		useable = true,
    },

	['mechanic_plate'] = {
    	label = 'License Plates',
    	weight = 100,
		name = 'mechanic_plate',
		description = "License Plates",
		useable = true,
    },

	['mechanic_window_tint'] = {
    	label = 'Window Tint',
    	weight = 100,
		name = 'mechanic_window_tint',
		description = "Windown Tint",
		useable = true,
    },

	['mechanic_livery'] = {
    	label = 'Stickers',
    	weight = 100,
		name = 'mechanic_livery',
		description = "Livery",
		useable = true,
    },

	['mechanic_drift_tyres'] = {
    	label = 'Drift Tires',
    	weight = 100,
		name = 'mechanic_drift_tyres',
		description = "Drift Tires",
		useable = true,
    },

	['mechanic_wheels'] = {
    	label = 'Wheels',
    	weight = 100,
		name = 'mechanic_wheels',
		description = "Wheels",
		useable = true,
    },

	['mechanic_bumpers'] = {
    	label = 'Bumpers',
    	weight = 100,
		name = 'mechanic_bumpers',
		description = "Bumpers",
		useable = true,
    },

	['mechanic_bonnet'] = {
    	label = 'Bonnet',
    	weight = 100,
		name = 'mechanic_bonnet',
		description = "Bonnet",
		useable = true,
    },

	['mechanic_skirt'] = {
    	label = 'Skirts',
    	weight = 100,
		name = 'mechanic_skirt',
		description = "Skirts",
		useable = true,
    },

	['mechanic_spoiler'] = {
    	label = 'Spoilers',
    	weight = 100,
		name = 'mechanic_spoiler',
		useable = true,
    },

	['mechanic_horn'] = {
    	label = 'Horn',
    	weight = 100,
		name = 'mechanic_horn',
		description = "Horn",
		useable = true,
    },

	['mechanic_grill'] = {
    	label = 'Grill',
    	weight = 100,
		name = 'mechanic_grill',
		description = "Grill",
		useable = true,
    },

	['mechanic_nitrous'] = {
    	label = 'Nitro',
    	weight = 100,
		name = 'mechanic_nitrous',
		description = "Nitro",
		useable = true,
    },

	['mechanic_exhaust'] = {
    	label = 'Exhaust',
    	weight = 100,
		name = 'mechanic_exhaust',
		description = "Exhaust",
		useable = true,
    },

	['mechanic_nitrous_empty'] = {
    	label = 'Empty Nitro',
    	weight = 100,
		name = 'mechanic_nitrous_empty',
		description = "Nitro Empty",
		useable = true,
    },
	
	['mechanic_mods_receipt'] = {
    	label = 'Receipt',
    	weight = 100,
		name = 'mechanic_mods_receipt',
		description = "List of Mods",
		useable = true,
    },

	['mechanic_roof'] = {
    	label = 'Roof',
    	weight = 100,
		name = 'mechanic_roof',
		description = "Roof",
		useable = true,
    },

	['mechanic_extras'] = {
    	label = 'Extras',
    	weight = 100,
		name = 'mechanic_extras',
		description = "Extras",
		useable = true,
    },

	['mechanic_interior'] = {
    	label = 'Interior',
    	weight = 100,
		name = 'mechanic_interior',
		description = "Interior",
		useable = true,
    },

	['mechanic_exterior'] = {
    	label = 'Exterior',
    	weight = 100,
		name = 'mechanic_exterior',
		description = "Exterior",
		useable = true,
    },

	['mechanic_repair_kit'] = {
    	label = 'Repair Kit',
    	weight = 100,
		name = 'mechanic_repair_kit',
		description = "Repair Kit",
		useable = true,
    },

	['redkey'] = {
    	label = 'Red Key',
    	weight = 100,
		name = 'redkey',
		description = "It's a key... thats red",
		useable = true,
    },

	['mission2package'] = {
    	label = 'Box',
    	weight = 100,
		name = 'mission2package',
		description = "This needs to go somewhere...",
		useable = true,
    },

	['red_sd_card'] = {
    	label = 'Red SD Card',
    	weight = 100,
		name = 'red_sd_card',
		description = "Whats on this drive?",
		useable = true,
		buttons = {
			{
				label = 'Plug into Tablet',
				action = function()
					TriggerServerEvent('o_blackmarket:server:canCraftBoosting')
				end
			},
    	},
	},

	['tablet'] = {
    	label = 'Tablet',
    	weight = 100,
		name = 'tablet',
		description = "Looks like it has room for a SD card...",
		useable = true,
	
    },

	--Boosting

	['boostingtablet'] = {
		label = 'Boosting tablet',
		weight = 0,
		description = "Seems like something's installed on this.",
		client = {
		export = 'rahe-boosting.boostingtablet',
		}
	},
	['hackingdevice'] = {
		label = 'Hacking device',
		weight = 0,
		description = 'Will allow you to bypass vehicle security systems.',
		client = {
		export = 'rahe-boosting.hackingdevice',
		}
	},
	['gpshackingdevice'] = {
		label = 'GPS hacking device',
		weight = 0,
		description = 'If you wish to disable vehicle GPS systems.',
		client = {
		export = 'rahe-boosting.gpshackingdevice',
		}
	},

	-- Druglabs

	['cokelab'] = {
    	label = 'Coke Lab',
    	weight = 100,
		description = "Let's get cookin!",
		useable = true,
		close = true,
    },

	['barrel'] = {
    	label = 'Barrel',
    	weight = 100,
		description = "It's a barrel...",
		useable = true,
		close = true,
    },

	['medbarrel'] = {
    	label = 'Plastic Barrel',
    	weight = 100,
		description = "It's a barrel but plastic...",
		useable = true,
		close = true,
    },

	['coke_leaves'] = {
    	label = 'Coca Leaves',
    	weight = 100,
		description = "Columbia's specialty!",
		useable = false,
    },

	['cement_powder_bag'] = {
    	label = 'Bag of Cement',
    	weight = 100,
		description = "Don't get it wet!",
		useable = true,
    },
	
	['cement_powder'] = {
    	label = 'Cement Powder',
    	weight = 100,
		description = "looks a lot like cocaine tbf",
		useable = false,
    },

	['car_battery'] = {
    	label = 'Car Battery',
    	weight = 100,
		description = "A battery that fits in a car!",
		useable = false,
    },

	['battery_acid'] = {
    	label = 'Battery Acid',
    	weight = 100,
		description = "Don't touch it!",
		useable = false,
    },

	['crushed_coke_leaves'] = {
    	label = 'Crush Coca Leaves',
    	weight = 100,
		description = "It'd Be tough to snort this!",
		useable = false,
    },

	['crack_cocaine_solution'] = {
    	label = 'Cocaine Solution',
    	weight = 100,
		description = "A chemical solution",
		useable = false,
    },

	['base_cocaine_solution'] = {
    	label = 'Cocaine Solution',
    	weight = 100,
		description = "A chemical solution",
		useable = false,
    },

	['pure_cocaine_solution'] = {
    	label = 'Cocaine Solution',
    	weight = 100,
		description = "A chemical solution",
		useable = false,
    },

	['cocaine_chemical_solution'] = {
    	label = 'Cocaine Solution',
    	weight = 100,
		description = "A chemical solution",
		useable = false,
    },

	['crack_cocaine'] = {
    	label = 'Crack Cocaine',
    	weight = 100,
		description = "It's Crack!",
		useable = false,
    },

	['base_cocaine'] = {
    	label = 'Cocaine',
    	weight = 100,
		description = "It'll get you going!",
		useable = false,
    },

	['pure_cocaine'] = {
    	label = 'Pure Cocaine',
    	weight = 100,
		description = "The Purest of the Pure!",
		useable = false,
    },

	['pure_cocaine_brick'] = {
    	label = 'Pure Cocaine',
    	weight = 100,
		description = "The Purest of the Pure!",
		useable = false,
    },

	['base_cocaine_brick'] = {
		label = 'Cocaine Brick',
		weight = 100,
		description = "It'll get you going!",
		useable = false,
	},







	['drone'] = {
		label = 'drone',
		weight = 100,
		description = "It'll get you going!",
		useable = false,
	},
	['drone_lspd'] = {
		label = 'drone',
		weight = 100,
		description = "It'll get you going!",
		useable = false,
	},


	-------- Jewellery store --------
	['gold_watch'] = {
		label = 'Gold Watch',
		weight = 100,
		description = "A gold watch",
		useable = false,
	},

	['silver_necklace'] = {
		label = 'Silver Necklace',
		weight = 100,
		description = "A silver necklace",
		useable = false,
	},

	['gold_chain'] = {
		label = 'Gold Chain',
		weight = 100,
		description = "A gold chain",
		useable = false,
	},
	
	['gold_ring'] = {
		label = 'Gold Ring',
		weight = 100,
		description = "A Gold Ring",
		useable = false,
	},

	['silver_ring'] = {
		label = 'Silver Ring',
		weight = 100,
		description = "A Silver Ring",
		useable = false,
	},

	['diamond_necklace'] = {
		label = 'Diamond Necklace',
		weight = 100,
		description = "A Necklace with a shiny diamond",
		useable = false,
	},

	['diamond_earrings'] = {
		label = 'Diamond Earrings',
		weight = 100,
		description = "This would look good on your ears",
		useable = false,
	},

	['sapphire_earrings'] = {
		label = 'Sapphire Earrings',
		weight = 100,
		description = "",
		useable = false,
	},

	['sapphire_necklace'] = {
		label = 'Sapphire Necklace',
		weight = 100,
		description = "",
		useable = false,
	},

	['ruby_earrings'] = {
		label = 'Ruby Earrings',
		weight = 100,
		description = "",
		useable = false,
	},

	['ruby_necklace'] = {
		label = 'Ruby Necklace',
		weight = 100,
		description = "",
		useable = false,
	},

	['glass_cutter'] = {
		label = 'Glass Cutter',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = false,
	},


	-- Medical Items

	['field_dressing'] = {
		label = 'Field Dressing',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['packing_bandage'] = {
		label = 'Packing Bandage',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['elastic_bandage'] = {
		label = 'Elastic Bandage',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['quickclot'] = {
		label = 'Quickclot Bandage',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['blood_100'] = {
		label = 'Blood Bag (100ml)',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['blood_250'] = {
		label = 'Blood Bag (250ml)',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['blood_500'] = {
		label = 'Blood Bag (500ml)',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['blood_750'] = {
		label = 'Blood Bag (750ml)',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['blood_1000'] = {
		label = 'Blood Bag (1000ml)',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['morphine'] = {
		label = 'Morphine',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['epinephrine'] = {
		label = 'Epinephrine',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['emergency_revive_kit'] = {
		label = 'Emergency Revive Kit',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['defibrillator'] = {
		label = 'Defibrillator',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['surgical_kit'] = {
		label = 'Surgical Kit',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['tourniquet'] = {
		label = 'tourniquet',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['ecg_monitor'] = {
		label = 'ecg_monitor',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['propofol_100'] = {
		label = 'Propofol 100mg',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['propofol_250'] = {
		label = 'Propofol 250mg',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},

	['bodybag'] = {
		label = 'Body Bag',
		weight = 100,
		description = "It look's sturdy enough to cut through tough glass",
		useable = true,
	},


}
