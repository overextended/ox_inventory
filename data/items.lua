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

	['clothing'] = {
		label = 'Clothing',
		consume = 0,
	},

	['weapon_golfclub'] = {
		label = 'golfclub',
		weight = 1000,
		stack = true,
		close = true,
		description = "A club used to hit the ball in golf"
	},

	['weapon_snspistol'] = {
		label = 'sns pistol',
		weight = 1000,
		stack = true,
		close = true,
		description = "A very small firearm designed to be easily concealed"
	},

	['heavysniper_defaultclip'] = {
		label = 'sniper clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Heavy Sniper Default Clip"
	},

	['empty_weed_bag'] = {
		label = 'empty weed bag',
		weight = 0,
		stack = false,
		close = true,
		description = "A small empty bag"
	},

	['weed_skunk_seed'] = {
		label = 'skunk seed',
		weight = 0,
		stack = false,
		close = true,
		description = "A weed seed of Skunk"
	},

	['smg_luxuryfinish'] = {
		label = 'smg finish',
		weight = 1000,
		stack = false,
		close = true,
		description = "SMG Luxury Finish"
	},

	['weapon_navyrevolver'] = {
		label = 'navy revolver',
		weight = 1000,
		stack = true,
		close = true,
		description = "Weapon Navyrevolver"
	},

	['electronickit'] = {
		label = 'electronic kit',
		weight = 100,
		stack = false,
		close = true,
		description = "If you've always wanted to build a robot you can maybe start here. Maybe you'll be the new Elon Musk?"
	},

	['rifle_suppressor'] = {
		label = 'rifle suppressor',
		weight = 1000,
		stack = false,
		close = true,
		description = "Rifle Suppressor Attachment"
	},

	['shotgun_suppressor'] = {
		label = 'shotgun suppressor',
		weight = 1000,
		stack = false,
		close = true,
		description = "Shotgun Suppressor Attachment"
	},

	['pistol_flashlight'] = {
		label = 'pistol flashlight',
		weight = 1000,
		stack = false,
		close = true,
		description = "Pistol Flashlight Attachment"
	},

	['copper'] = {
		label = 'copper',
		weight = 100,
		stack = false,
		close = false,
		description = "Nice piece of metal that you can probably use for something"
	},

	['tablet'] = {
		label = 'tablet',
		weight = 2000,
		stack = false,
		close = true,
		description = "Expensive tablet"
	},

	['water_bottle'] = {
		label = 'bottle of water',
		weight = 500,
		stack = false,
		close = true,
		description = "For all the thirsty out there"
	},

	['weapon_combatpdw'] = {
		label = 'combat pdw',
		weight = 1000,
		stack = true,
		close = true,
		description = "A combat version of a handheld lightweight machine gun"
	},

	['compactrifle_defaultclip'] = {
		label = 'rifle clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Compact Rifle Default Clip"
	},

	['trojan_usb'] = {
		label = 'trojan usb',
		weight = 0,
		stack = false,
		close = true,
		description = "Handy software to shut down some systems"
	},

	['weapon_minigun'] = {
		label = 'minigun',
		weight = 1000,
		stack = true,
		close = true,
		description = "A portable machine gun consisting of a rotating cluster of six barrels and capable of variable rates of fire of up to 6,000 rounds per minute"
	},

	['weapon_grenadelauncher_smoke'] = {
		label = 'smoke grenade launcher',
		weight = 1000,
		stack = true,
		close = true,
		description = "A bomb that produces a lot of smoke when it explodes"
	},

	['glass'] = {
		label = 'glass',
		weight = 100,
		stack = false,
		close = false,
		description = "It is very fragile, watch out"
	},

	['microsmg_scope'] = {
		label = 'smg scope',
		weight = 1000,
		stack = false,
		close = true,
		description = "Micro SMG Scope Attachment"
	},

	['weapon_smg'] = {
		label = 'smg',
		weight = 1000,
		stack = true,
		close = true,
		description = "A handheld lightweight machine gun"
	},

	['pistol_defaultclip'] = {
		label = 'pistol clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Pistol Default Clip"
	},

	['smg_extendedclip'] = {
		label = 'smg ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "SMG Extended Clip"
	},

	['id_card'] = {
		label = 'id card',
		weight = 0,
		stack = true,
		close = false,
		description = "A card containing all your information to identify yourself"
	},

	['weapon_musket'] = {
		label = 'musket',
		weight = 1000,
		stack = true,
		close = true,
		description = "An infantryman's light gun with a long barrel, typically smooth-bored, muzzleloading, and fired from the shoulder"
	},

	['drill'] = {
		label = 'drill',
		weight = 20000,
		stack = false,
		close = false,
		description = "The real deal..."
	},

	['casinochips'] = {
		label = 'casino chips',
		weight = 0,
		stack = false,
		close = false,
		description = "Chips For Casino Gambling"
	},

	['marksmanrifle_defaultclip'] = {
		label = 'sniper clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Marksman Rifle Default Clip"
	},

	['combatpistol_extendedclip'] = {
		label = 'pistol ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Combat Pistol Extended Clip"
	},

	['weapon_revolver'] = {
		label = 'revolver',
		weight = 1000,
		stack = true,
		close = true,
		description = "A pistol with revolving chambers enabling several shots to be fired without reloading"
	},

	['appistol_defaultclip'] = {
		label = 'pistol clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "APPistol Default Clip"
	},

	['bullpuprifle_luxuryfinish'] = {
		label = 'rifle finish',
		weight = 1000,
		stack = false,
		close = true,
		description = "Bullpup Rifle Luxury Finish"
	},

	['fitbit'] = {
		label = 'fitbit',
		weight = 500,
		stack = true,
		close = true,
		description = "I like fitbit"
	},

	['grape'] = {
		label = 'grape',
		weight = 100,
		stack = false,
		close = false,
		description = "Mmmmh yummie, grapes"
	},

	['weapon_raycarbine'] = {
		label = 'unholy hellbringer',
		weight = 1000,
		stack = true,
		close = true,
		description = "Weapon Raycarbine"
	},

	['minismg_extendedclip'] = {
		label = 'smg ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Mini SMG Extended Clip"
	},

	['firework4'] = {
		label = 'weeping willow',
		weight = 1000,
		stack = false,
		close = true,
		description = "Fireworks"
	},

	['advancedrifle_extendedclip'] = {
		label = 'rifle ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Advanced Rifle Extended Clip"
	},

	['mastercard'] = {
		label = 'master card',
		weight = 0,
		stack = true,
		close = false,
		description = "MasterCard can be used via ATM"
	},

	['rolex'] = {
		label = 'golden watch',
		weight = 1500,
		stack = false,
		close = true,
		description = "A golden watch seems like the jackpot to me!"
	},

	['weed_brick'] = {
		label = 'weed brick',
		weight = 1000,
		stack = false,
		close = true,
		description = "1KG Weed Brick to sell to large customers."
	},

	['weapon_bullpuprifle_mk2'] = {
		label = 'bullpup rifle mk ii',
		weight = 1000,
		stack = true,
		close = true,
		description = "Bull Puprifle MK2"
	},

	['labkey'] = {
		label = 'key',
		weight = 500,
		stack = true,
		close = true,
		description = "Key for a lock...?"
	},

	['firstaid'] = {
		label = 'first aid',
		weight = 2500,
		stack = false,
		close = true,
		description = "You can use this First Aid kit to get people back on their feet"
	},

	['weapon_autoshotgun'] = {
		label = 'auto shotgun',
		weight = 1000,
		stack = true,
		close = true,
		description = "A shotgun capable of rapid continous fire"
	},

	['binoculars'] = {
		label = 'binoculars',
		weight = 600,
		stack = false,
		close = true,
		description = "Sneaky Breaky..."
	},

	['combatpdw_grip'] = {
		label = 'smg grip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Combat PDW Grip Attachment"
	},

	['cryptostick'] = {
		label = 'crypto stick',
		weight = 200,
		stack = true,
		close = true,
		description = "Why would someone ever buy money that doesn't exist.. How many would it contain..?"
	},

	['snipermax_scope'] = {
		label = 'sniper max scope',
		weight = 1000,
		stack = false,
		close = true,
		description = "Sniper Rifle Max Scope Attachment"
	},

	['driver_license'] = {
		label = 'drivers license',
		weight = 0,
		stack = true,
		close = false,
		description = "Permit to show you can drive a vehicle"
	},

	['revolver_defaultclip'] = {
		label = 'pistol clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Revovler Default Clip"
	},

	['weapon_molotov'] = {
		label = 'molotov',
		weight = 1000,
		stack = true,
		close = true,
		description = "A crude bomb made of a bottle filled with a flammable liquid and fitted with a wick for lighting"
	},

	['weapon_gadgetpistol'] = {
		label = 'perico pistol',
		weight = 1000,
		stack = true,
		close = true,
		description = "Weapon Gadgetpistol"
	},

	['weapon_compactrifle'] = {
		label = 'compact rifle',
		weight = 1000,
		stack = true,
		close = true,
		description = "A compact version of an assault rifle"
	},

	['machinepistol_drum'] = {
		label = 'smg drum',
		weight = 1000,
		stack = false,
		close = true,
		description = "Machine Pistol Drum"
	},

	['weapon_flaregun'] = {
		label = 'flare gun',
		weight = 1000,
		stack = true,
		close = true,
		description = "A handgun for firing signal rockets"
	},

	['cleaningkit'] = {
		label = 'cleaning kit',
		weight = 250,
		stack = false,
		close = true,
		description = "A microfiber cloth with some soap will let your car sparkle again!"
	},

	['rolling_paper'] = {
		label = 'rolling paper',
		weight = 0,
		stack = false,
		close = true,
		description = "Paper made specifically for encasing and smoking tobacco or cannabis."
	},

	['assaultsmg_extendedclip'] = {
		label = 'smg ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Assault SMG Extended Clip"
	},

	['heavypistol_defaultclip'] = {
		label = 'pistol clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Heavy Pistol Default Clip"
	},

	['sniper_grip'] = {
		label = 'sniper grip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Sniper Rifle Grip Attachment"
	},

	['sniper_scope'] = {
		label = 'sniper scope',
		weight = 1000,
		stack = false,
		close = true,
		description = "Sniper Rifle Scope Attachment"
	},

	['sniperrifle_defaultclip'] = {
		label = 'sniper suppressor',
		weight = 1000,
		stack = false,
		close = true,
		description = "Sniper Rifle Default Clip"
	},

	['assaultsmg_luxuryfinish'] = {
		label = 'smg finish',
		weight = 1000,
		stack = false,
		close = true,
		description = "Assault SMG Luxury Finish"
	},

	['weapon_raypistol'] = {
		label = 'up-n-atomizer',
		weight = 1000,
		stack = true,
		close = true,
		description = "Weapon Raypistol"
	},

	['weapon_carbinerifle'] = {
		label = 'carbine rifle',
		weight = 1000,
		stack = true,
		close = true,
		description = "A lightweight automatic rifle"
	},

	['weapon_heavysniper_mk2'] = {
		label = 'heavy sniper mk ii',
		weight = 1000,
		stack = true,
		close = true,
		description = "Weapon Heavysniper MK2"
	},

	['weapon_machinepistol'] = {
		label = 'tec-9',
		weight = 1000,
		stack = true,
		close = true,
		description = "A self-loading pistol capable of burst or fully automatic fire"
	},

	['combatpdw_defaultclip'] = {
		label = 'smg clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Combat PDW Default Clip"
	},

	['mg_ammo'] = {
		label = 'mg ammo',
		weight = 1000,
		stack = false,
		close = true,
		description = "Ammo for Machine Guns"
	},

	['weed_amnesia_seed'] = {
		label = 'amnesia seed',
		weight = 0,
		stack = false,
		close = true,
		description = "A weed seed of Amnesia"
	},

	['gusenberg_extendedclip'] = {
		label = 'rifle ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Gusenberg Extended Clip"
	},

	['lighter'] = {
		label = 'lighter',
		weight = 0,
		stack = false,
		close = true,
		description = "On new years eve a nice fire to stand next to"
	},

	['pumpshotgun_luxuryfinish'] = {
		label = 'shotgun finish',
		weight = 1000,
		stack = false,
		close = true,
		description = "Pump Shotgun Luxury Finish"
	},

	['weapon_unarmed'] = {
		label = 'fists',
		weight = 1000,
		stack = true,
		close = true,
		description = "Fisticuffs"
	},

	['weapon_pistol_mk2'] = {
		label = 'pistol mk ii',
		weight = 1000,
		stack = true,
		close = true,
		description = "An upgraded small firearm designed to be held in one hand"
	},

	['weed_og-kush_seed'] = {
		label = 'ogkush seed',
		weight = 0,
		stack = false,
		close = true,
		description = "A weed seed of OG Kush"
	},

	['weapon_assaultrifle'] = {
		label = 'assault rifle',
		weight = 1000,
		stack = true,
		close = true,
		description = "A rapid-fire, magazine-fed automatic rifle designed for infantry use"
	},

	['vintagepistol_defaultclip'] = {
		label = 'pistol clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Vintage Pistol Default Clip"
	},

	['microsmg_extendedclip'] = {
		label = 'smg ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Micro SMG Extended Clip"
	},

	['weapon_ball'] = {
		label = 'ball',
		weight = 1000,
		stack = true,
		close = true,
		description = "A solid or hollow spherical or egg-shaped object that is kicked, thrown, or hit in a game"
	},

	['vodka'] = {
		label = 'vodka',
		weight = 500,
		stack = false,
		close = true,
		description = "For all the thirsty out there"
	},

	['empty_evidence_bag'] = {
		label = 'empty evidence bag',
		weight = 0,
		stack = false,
		close = false,
		description = "Used a lot to keep DNA from blood, bullet shells and more"
	},

	['weapon_marksmanrifle_mk2'] = {
		label = 'marksman rifle mk ii',
		weight = 1000,
		stack = true,
		close = true,
		description = "Weapon Marksmanrifle MK2"
	},

	['weapon_heavypistol'] = {
		label = 'heavy pistol',
		weight = 1000,
		stack = true,
		close = true,
		description = "A hefty firearm designed to be held in one hand (or attempted)"
	},

	['heavyshotgun_drum'] = {
		label = 'shotgun drum',
		weight = 1000,
		stack = false,
		close = true,
		description = "Heavy Shotgun Drum"
	},

	['tunerlaptop'] = {
		label = 'tunerchip',
		weight = 2000,
		stack = true,
		close = true,
		description = "With this tunerchip you can get your car on steroids... If you know what you're doing"
	},

	['rifle_grip'] = {
		label = 'rifle grip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Rifle Grip Attachment"
	},

	['weapon_grenadelauncher'] = {
		label = 'grenade launcher',
		weight = 1000,
		stack = true,
		close = true,
		description = "A weapon that fires a specially-designed large-caliber projectile, often with an explosive, smoke or gas warhead"
	},

	['gatecrack'] = {
		label = 'gatecrack',
		weight = 0,
		stack = false,
		close = true,
		description = "Handy software to tear down some fences"
	},

	['heavypistol_grip'] = {
		label = 'pistol grip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Heavy Pistol Grip Attachment"
	},

	['weapon_mg'] = {
		label = 'machinegun',
		weight = 1000,
		stack = true,
		close = true,
		description = "An automatic gun that fires bullets in rapid succession for as long as the trigger is pressed"
	},

	['crack_baggy'] = {
		label = 'bag of crack',
		weight = 0,
		stack = false,
		close = true,
		description = "To get happy faster"
	},

	['weapontint_orange'] = {
		label = 'orange tint',
		weight = 1000,
		stack = false,
		close = true,
		description = "Orange Weapon Tint"
	},

	['combatpdw_extendedclip'] = {
		label = 'smg ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Combat PDW Extended Clip"
	},

	['weapon_microsmg'] = {
		label = 'micro smg',
		weight = 1000,
		stack = true,
		close = true,
		description = "A handheld lightweight machine gun"
	},

	['weapon_rpg'] = {
		label = 'rpg',
		weight = 1000,
		stack = true,
		close = true,
		description = "A rocket-propelled grenade launcher"
	},

	['iron'] = {
		label = 'iron',
		weight = 100,
		stack = false,
		close = false,
		description = "Handy piece of metal that you can probably use for something"
	},

	['armor'] = {
		label = 'armor',
		weight = 5000,
		stack = false,
		close = true,
		description = "Some protection won't hurt... right?"
	},

	['weapon_stickybomb'] = {
		label = 'c4',
		weight = 1000,
		stack = true,
		close = true,
		description = "An explosive charge covered with an adhesive that when thrown against an object sticks until it explodes"
	},

	['weapon_militaryrifle'] = {
		label = 'military rifle',
		weight = 1000,
		stack = true,
		close = true,
		description = "Weapon Militaryrifle"
	},

	['diamond'] = {
		label = 'diamond',
		weight = 1000,
		stack = false,
		close = true,
		description = "A diamond seems like the jackpot to me!"
	},

	['weapon_nightstick'] = {
		label = 'nightstick',
		weight = 1000,
		stack = true,
		close = true,
		description = "A police officer's club or billy"
	},

	['coffee'] = {
		label = 'coffee',
		weight = 200,
		stack = false,
		close = true,
		description = "Pump 4 Caffeine"
	},

	['weapon_switchblade'] = {
		label = 'switchblade',
		weight = 1000,
		stack = true,
		close = true,
		description = "A knife with a blade that springs out from the handle when a button is pressed"
	},

	['ironoxide'] = {
		label = 'iron powder',
		weight = 100,
		stack = false,
		close = false,
		description = "Some powder to mix with."
	},

	['weapon_marksmanrifle'] = {
		label = 'marksman rifle',
		weight = 1000,
		stack = true,
		close = true,
		description = "A very accurate single-fire rifle"
	},

	['weapon_machete'] = {
		label = 'machete',
		weight = 1000,
		stack = true,
		close = true,
		description = "A broad, heavy knife used as a weapon"
	},

	['radioscanner'] = {
		label = 'radio scanner',
		weight = 1000,
		stack = false,
		close = true,
		description = "With this you can get some police alerts. Not 100% effective however"
	},

	['weapon_heavysniper'] = {
		label = 'heavy sniper',
		weight = 1000,
		stack = true,
		close = true,
		description = "An upgraded high-precision, long-range rifle"
	},

	['iphone'] = {
		label = 'iphone',
		weight = 1000,
		stack = false,
		close = true,
		description = "Very expensive phone"
	},

	['firework1'] = {
		label = '2brothers',
		weight = 1000,
		stack = false,
		close = true,
		description = "Fireworks"
	},

	['gusenberg_defaultclip'] = {
		label = 'rifle clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Gusenberg Default Clip"
	},

	['walkstick'] = {
		label = 'walking stick',
		weight = 1000,
		stack = false,
		close = true,
		description = "Walking stick for ya'll grannies out there.. HAHA"
	},

	['advancedlockpick'] = {
		label = 'advanced lockpick',
		weight = 500,
		stack = false,
		close = true,
		description = "If you lose your keys a lot this is very useful... Also useful to open your beers"
	},

	['kurkakola'] = {
		label = 'cola',
		weight = 500,
		stack = false,
		close = true,
		description = "For all the thirsty out there"
	},

	['weapon_bread'] = {
		label = 'baquette',
		weight = 1000,
		stack = true,
		close = true,
		description = "Bread...?"
	},

	['shotgun_ammo'] = {
		label = 'shotgun ammo',
		weight = 500,
		stack = false,
		close = true,
		description = "Ammo for Shotguns"
	},

	['weapon_garbagebag'] = {
		label = 'garbage bag',
		weight = 1000,
		stack = true,
		close = true,
		description = "A garbage bag"
	},

	['assaultsmg_defaultclip'] = {
		label = 'smg clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Assault SMG Default Clip"
	},

	['snspistol_grip'] = {
		label = 'pistol grip',
		weight = 1000,
		stack = false,
		close = true,
		description = "SNS Pistol Grip Attachment"
	},

	['pistol_ammo'] = {
		label = 'pistol ammo',
		weight = 200,
		stack = false,
		close = true,
		description = "Ammo for Pistols"
	},

	['weapon_pipebomb'] = {
		label = 'pipe bomb',
		weight = 1000,
		stack = true,
		close = true,
		description = "A homemade bomb, the components of which are contained in a pipe"
	},

	['rubber'] = {
		label = 'rubber',
		weight = 100,
		stack = false,
		close = false,
		description = "Rubber, I believe you can make your own rubber ducky with it :D"
	},

	['weapon_assaultsmg'] = {
		label = 'assault smg',
		weight = 1000,
		stack = true,
		close = true,
		description = "An assault version of a handheld lightweight machine gun"
	},

	['assaultrifle_extendedclip'] = {
		label = 'rifle ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Assault Rifle Extended Clip"
	},

	['weapon_appistol'] = {
		label = 'ap pistol',
		weight = 1000,
		stack = true,
		close = true,
		description = "A small firearm designed to be held in one hand that is automatic"
	},

	['metalscrap'] = {
		label = 'metal scrap',
		weight = 100,
		stack = false,
		close = false,
		description = "You can probably make something nice out of this"
	},

	['weed_ak47_seed'] = {
		label = 'ak47 seed',
		weight = 0,
		stack = false,
		close = true,
		description = "A weed seed of AK47"
	},

	['weapon_assaultrifle_mk2'] = {
		label = 'assault rifle mk ii',
		weight = 1000,
		stack = true,
		close = true,
		description = "Assault Rifle MK2"
	},

	['meth'] = {
		label = 'meth',
		weight = 100,
		stack = false,
		close = true,
		description = "A baggie of Meth"
	},

	['weapon_heavyshotgun'] = {
		label = 'heavy shotgun',
		weight = 1000,
		stack = true,
		close = true,
		description = "A large smoothbore gun for firing small shot at short range"
	},

	['rifle_flashlight'] = {
		label = 'rifle flashlight',
		weight = 1000,
		stack = false,
		close = true,
		description = "Rifle Flashlight Attachment"
	},

	['carbinerifle_defaultclip'] = {
		label = 'rifle clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Carbine Rifle Default Clip"
	},

	['smg_drum'] = {
		label = 'smg drum',
		weight = 1000,
		stack = false,
		close = true,
		description = "SMG Drum"
	},

	['weapon_bat'] = {
		label = 'bat',
		weight = 1000,
		stack = true,
		close = true,
		description = "Used for hitting a ball in sports (or other things)"
	},

	['weapon_bottle'] = {
		label = 'broken bottle',
		weight = 1000,
		stack = true,
		close = true,
		description = "A broken bottle"
	},

	['weed_skunk'] = {
		label = 'skunk 2g',
		weight = 200,
		stack = false,
		close = false,
		description = "A weed bag with 2g Skunk"
	},

	['weed_og-kush'] = {
		label = 'ogkush 2g',
		weight = 200,
		stack = false,
		close = false,
		description = "A weed bag with 2g OG Kush"
	},

	['dendrogyra_coral'] = {
		label = 'dendrogyra',
		weight = 1000,
		stack = false,
		close = true,
		description = "Its also known as pillar coral"
	},

	['weapon_knuckle'] = {
		label = 'knuckle',
		weight = 1000,
		stack = true,
		close = true,
		description = "A metal guard worn over the knuckles in fighting, especially to increase the effect of the blows"
	},

	['sandwich'] = {
		label = 'sandwich',
		weight = 200,
		stack = false,
		close = true,
		description = "Nice bread for your stomach"
	},

	['visa'] = {
		label = 'visa card',
		weight = 0,
		stack = true,
		close = false,
		description = "Visa can be used via ATM"
	},

	['weed_white-widow'] = {
		label = 'white widow 2g',
		weight = 200,
		stack = false,
		close = false,
		description = "A weed bag with 2g White Widow"
	},

	['weapon_revolver_mk2'] = {
		label = 'violence',
		weight = 1000,
		stack = true,
		close = true,
		description = "da Violence"
	},

	['weapon_bullpupshotgun'] = {
		label = 'bullpup shotgun',
		weight = 1000,
		stack = true,
		close = true,
		description = "A compact smoothbore gun for firing small shot at short range"
	},

	['weapon_doubleaction'] = {
		label = 'double action revolver',
		weight = 1000,
		stack = true,
		close = true,
		description = "Double Action Revolver"
	},

	['weapon_bullpuprifle'] = {
		label = 'bullpup rifle',
		weight = 1000,
		stack = true,
		close = true,
		description = "A compact automatic assault rifle"
	},

	['stickynote'] = {
		label = 'sticky note',
		weight = 0,
		stack = true,
		close = false,
		description = "Sometimes handy to remember something :)"
	},

	['snspistol_extendedclip'] = {
		label = 'pistol ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "SNS Pistol Extended Clip"
	},

	['combatpdw_scope'] = {
		label = 'smg scope',
		weight = 1000,
		stack = false,
		close = true,
		description = "Combat PDW Scope Attachment"
	},

	['weapon_bzgas'] = {
		label = 'bz gas',
		weight = 1000,
		stack = true,
		close = true,
		description = "A cannister of gas that causes extreme pain"
	},

	['coke_small_brick'] = {
		label = 'coke package',
		weight = 350,
		stack = true,
		close = true,
		description = "Small package of cocaine, mostly used for deals and takes a lot of space"
	},

	['weapon_minismg'] = {
		label = 'mini smg',
		weight = 1000,
		stack = true,
		close = true,
		description = "A mini handheld lightweight machine gun"
	},

	['harness'] = {
		label = 'race harness',
		weight = 1000,
		stack = true,
		close = true,
		description = "Racing Harness so no matter what you stay in the car"
	},

	['appistol_luxuryfinish'] = {
		label = 'pistol finish',
		weight = 1000,
		stack = false,
		close = true,
		description = "APPistol Luxury Finish"
	},

	['machinepistol_extendedclip'] = {
		label = 'smg ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Machine Pistol Extended Clip"
	},

	['weapon_battleaxe'] = {
		label = 'battle axe',
		weight = 1000,
		stack = true,
		close = true,
		description = "A large broad-bladed axe used in ancient warfare"
	},

	['laptop'] = {
		label = 'laptop',
		weight = 4000,
		stack = false,
		close = true,
		description = "Expensive laptop"
	},

	['weed_amnesia'] = {
		label = 'amnesia 2g',
		weight = 200,
		stack = false,
		close = false,
		description = "A weed bag with 2g Amnesia"
	},

	['pinger'] = {
		label = 'pinger',
		weight = 1000,
		stack = false,
		close = true,
		description = "With a pinger and your phone you can send out your location"
	},

	['heavyshotgun_extendedclip'] = {
		label = 'shotgun ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Heavy Shotgun Extended Clip"
	},

	['heavypistol_extendedclip'] = {
		label = 'pistol ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Heavy Pistol Extended Clip"
	},

	['weapon_hatchet'] = {
		label = 'hatchet',
		weight = 1000,
		stack = true,
		close = true,
		description = "A small axe with a short handle for use in one hand"
	},

	['assaultrifle_drum'] = {
		label = 'rifle drum',
		weight = 1000,
		stack = false,
		close = true,
		description = "Assault Rifle Drum"
	},

	['weapon_flare'] = {
		label = 'flare pistol',
		weight = 1000,
		stack = true,
		close = true,
		description = "A small pyrotechnic devices used for illumination and signalling"
	},

	['weapontint_green'] = {
		label = 'green tint',
		weight = 1000,
		stack = false,
		close = true,
		description = "Green Weapon Tint"
	},

	['plastic'] = {
		label = 'plastic',
		weight = 100,
		stack = false,
		close = false,
		description = "RECYCLE! - Greta Thunberg 2019"
	},

	['marksmanrifle_scope'] = {
		label = 'sniper scope',
		weight = 1000,
		stack = false,
		close = true,
		description = "Marksman Rifle Scope Attachment"
	},

	['weapon_firework'] = {
		label = 'firework launcher',
		weight = 1000,
		stack = true,
		close = true,
		description = "A device containing gunpowder and other combustible chemicals that causes a spectacular explosion when ignited"
	},

	['weapon_knife'] = {
		label = 'knife',
		weight = 1000,
		stack = true,
		close = true,
		description = "An instrument composed of a blade fixed into a handle, used for cutting or as a weapon"
	},

	['revolver_bodyguardvariant'] = {
		label = 'pistol variant',
		weight = 1000,
		stack = false,
		close = true,
		description = "Revovler Variant"
	},

	['jerry_can'] = {
		label = 'jerrycan 20l',
		weight = 20000,
		stack = false,
		close = true,
		description = "A can full of Fuel"
	},

	['machinepistol_defaultclip'] = {
		label = 'smg clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Machine Pistol Default Clip"
	},

	['antipatharia_coral'] = {
		label = 'antipatharia',
		weight = 1000,
		stack = false,
		close = true,
		description = "Its also known as black corals or thorn corals"
	},

	['weapon_fireextinguisher'] = {
		label = 'fire extinguisher',
		weight = 1000,
		stack = true,
		close = true,
		description = "A portable device that discharges a jet of water, foam, gas, or other material to extinguish a fire"
	},

	['weapon_ceramicpistol'] = {
		label = 'ceramic pistol',
		weight = 1000,
		stack = true,
		close = true,
		description = "Weapon Ceramicpistol"
	},

	['weapon_combatmg_mk2'] = {
		label = 'combat mg mk ii',
		weight = 1000,
		stack = true,
		close = true,
		description = "Weapon Combatmg MK2"
	},

	['smg_scope'] = {
		label = 'smg scope',
		weight = 1000,
		stack = false,
		close = true,
		description = "SMG Scope Attachment"
	},

	['moneybag'] = {
		label = 'money bag',
		weight = 0,
		stack = true,
		close = true,
		description = "A bag with cash"
	},

	['aluminum'] = {
		label = 'aluminium',
		weight = 100,
		stack = false,
		close = false,
		description = "Nice piece of metal that you can probably use for something"
	},

	['snowball'] = {
		label = 'snowball',
		weight = 0,
		stack = false,
		close = true,
		description = "Should have catched it :D"
	},

	['weapon_pistol'] = {
		label = 'walther p99',
		weight = 1000,
		stack = true,
		close = true,
		description = "A small firearm designed to be held in one hand"
	},

	['pistol_luxuryfinish'] = {
		label = 'pistol finish',
		weight = 1000,
		stack = false,
		close = true,
		description = "Pistol Luxury Finish"
	},

	['pistol_extendedclip'] = {
		label = 'pistol ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Pistol Extended Clip"
	},

	['weed_purple-haze_seed'] = {
		label = 'purple haze seed',
		weight = 0,
		stack = false,
		close = true,
		description = "A weed seed of Purple Haze"
	},

	['assaultshotgun_extendedclip'] = {
		label = 'shotgun ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Assault Shotgun Extended Clip"
	},

	['aluminumoxide'] = {
		label = 'aluminium powder',
		weight = 100,
		stack = false,
		close = false,
		description = "Some powder to mix with"
	},

	['weapon_specialcarbine_mk2'] = {
		label = 'special carbine mk ii',
		weight = 1000,
		stack = true,
		close = true,
		description = "Weapon Wpecialcarbine MK2"
	},

	['firework3'] = {
		label = 'wipeout',
		weight = 1000,
		stack = false,
		close = true,
		description = "Fireworks"
	},

	['heavyshotgun_defaultclip'] = {
		label = 'shotgun clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Heavy Shotgun Default Clip"
	},

	['weapon_dagger'] = {
		label = 'dagger',
		weight = 1000,
		stack = true,
		close = true,
		description = "A short knife with a pointed and edged blade, used as a weapon"
	},

	['lawyerpass'] = {
		label = 'lawyer pass',
		weight = 0,
		stack = true,
		close = false,
		description = "Pass exclusive to lawyers to show they can represent a suspect"
	},

	['bullpuprifle_extendedclip'] = {
		label = 'rifle ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Bullpup Rifle Extended Clip"
	},

	['coke_brick'] = {
		label = 'coke brick',
		weight = 1000,
		stack = true,
		close = true,
		description = "Heavy package of cocaine, mostly used for deals and takes a lot of space"
	},

	['weapon_advancedrifle'] = {
		label = 'advanced rifle',
		weight = 1000,
		stack = true,
		close = true,
		description = "An assault version of a rapid-fire, magazine-fed automatic rifle designed for infantry use"
	},

	['assaultrifle_luxuryfinish'] = {
		label = 'rifle finish',
		weight = 1000,
		stack = false,
		close = true,
		description = "Assault Rifle Luxury Finish"
	},

	['combatpistol_luxuryfinish'] = {
		label = 'pistol finish',
		weight = 1000,
		stack = false,
		close = true,
		description = "Combat Pistol Luxury Finish"
	},

	['weapontint_plat'] = {
		label = 'platinum tint',
		weight = 1000,
		stack = false,
		close = true,
		description = "Platinum Weapon Tint"
	},

	['specialcarbine_extendedclip'] = {
		label = 'rifle ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Special Carbine Extended Clip"
	},

	['revolver_vipvariant'] = {
		label = 'pistol variant',
		weight = 1000,
		stack = false,
		close = true,
		description = "Revovler Variant"
	},

	['handcuffs'] = {
		label = 'handcuffs',
		weight = 100,
		stack = false,
		close = true,
		description = "Comes in handy when people misbehave. Maybe it can be used for something else?"
	},

	['steel'] = {
		label = 'steel',
		weight = 100,
		stack = false,
		close = false,
		description = "Nice piece of metal that you can probably use for something"
	},

	['weapon_briefcase'] = {
		label = 'briefcase',
		weight = 1000,
		stack = true,
		close = true,
		description = "A briefcase for storing important documents"
	},

	['weapontint_pink'] = {
		label = 'pink tint',
		weight = 1000,
		stack = false,
		close = true,
		description = "Pink Weapon Tint"
	},

	['weapon_carbinerifle_mk2'] = {
		label = 'carbine rifle mk ii',
		weight = 1000,
		stack = true,
		close = true,
		description = "Carbine Rifle MK2"
	},

	['printerdocument'] = {
		label = 'document',
		weight = 500,
		stack = true,
		close = true,
		description = "A nice document"
	},

	['microsmg_defaultclip'] = {
		label = 'smg clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Micro SMG Default Clip"
	},

	['specialcarbine_luxuryfinish'] = {
		label = 'rifle finish',
		weight = 1000,
		stack = false,
		close = true,
		description = "Special Carbine Luxury Finish"
	},

	['sawnoffshotgun_luxuryfinish'] = {
		label = 'shotgun finish',
		weight = 1000,
		stack = false,
		close = true,
		description = "Sawn Off Shotgun Luxury Finish"
	},

	['vintagepistol_extendedclip'] = {
		label = 'pistol ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Vintage Pistol Default Clip"
	},

	['weapon_hammer'] = {
		label = 'hammer',
		weight = 1000,
		stack = true,
		close = true,
		description = "Used for jobs such as breaking things (legs) and driving in nails"
	},

	['wine'] = {
		label = 'wine',
		weight = 300,
		stack = false,
		close = false,
		description = "Some good wine to drink on a fine evening"
	},

	['minismg_defaultclip'] = {
		label = 'smg clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Mini SMG Default Clip"
	},

	['filled_evidence_bag'] = {
		label = 'evidence bag',
		weight = 200,
		stack = true,
		close = false,
		description = "A filled evidence bag to see who committed the crime >:("
	},

	['weapon_gusenberg'] = {
		label = 'thompson smg',
		weight = 1000,
		stack = true,
		close = true,
		description = "An automatic rifle commonly referred to as a tommy gun"
	},

	['microsmg_luxuryfinish'] = {
		label = 'smg finish',
		weight = 1000,
		stack = false,
		close = true,
		description = "Micro SMG Luxury Finish"
	},

	['weapon_rayminigun'] = {
		label = 'widowmaker',
		weight = 1000,
		stack = true,
		close = true,
		description = "Weapon Rayminigun"
	},

	['weapon_stone_hatchet'] = {
		label = 'stone hatchet',
		weight = 1000,
		stack = true,
		close = true,
		description = "Stone ax"
	},

	['twerks_candy'] = {
		label = 'twerks',
		weight = 100,
		stack = false,
		close = true,
		description = "Some delicious candy :O"
	},

	['grapejuice'] = {
		label = 'grape juice',
		weight = 200,
		stack = false,
		close = false,
		description = "Grape juice is said to be healthy"
	},

	['cokebaggy'] = {
		label = 'bag of coke',
		weight = 0,
		stack = false,
		close = true,
		description = "To get happy real quick"
	},

	['weed_nutrition'] = {
		label = 'plant fertilizer',
		weight = 2000,
		stack = false,
		close = true,
		description = "Plant nutrition"
	},

	['thermite'] = {
		label = 'thermite',
		weight = 1000,
		stack = false,
		close = true,
		description = "Sometimes you'd wish for everything to burn"
	},

	['weapon_stungun'] = {
		label = 'taser',
		weight = 1000,
		stack = true,
		close = true,
		description = "A weapon firing barbs attached by wires to batteries, causing temporary paralysis"
	},

	['weapon_dbshotgun'] = {
		label = 'double-barrel shotgun',
		weight = 1000,
		stack = true,
		close = true,
		description = "A shotgun with two parallel barrels, allowing two single shots to be fired in quick succession"
	},

	['snspistol_defaultclip'] = {
		label = 'pistol clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "SNS Pistol Default Clip"
	},

	['compactrifle_drum'] = {
		label = 'rifle drum',
		weight = 1000,
		stack = false,
		close = true,
		description = "Compact Rifle Drum"
	},

	['weapon_pumpshotgun_mk2'] = {
		label = 'pumpshotgun mk ii',
		weight = 1000,
		stack = true,
		close = true,
		description = "Pumpshotgun MK2"
	},

	['weed_white-widow_seed'] = {
		label = 'white widow seed',
		weight = 0,
		stack = false,
		close = false,
		description = "A weed seed of White Widow"
	},

	['weapon_pistol50'] = {
		label = 'pistol .50',
		weight = 1000,
		stack = true,
		close = true,
		description = "A .50 caliber firearm designed to be held with both hands"
	},

	['combatpdw_drum'] = {
		label = 'smg drum',
		weight = 1000,
		stack = false,
		close = true,
		description = "Combat PDW Drum"
	},

	['diving_gear'] = {
		label = 'diving gear',
		weight = 30000,
		stack = true,
		close = true,
		description = "An oxygen tank and a rebreather"
	},

	['weapontint_gold'] = {
		label = 'gold tint',
		weight = 1000,
		stack = false,
		close = true,
		description = "Gold Weapon Tint"
	},

	['whiskey'] = {
		label = 'whiskey',
		weight = 500,
		stack = false,
		close = true,
		description = "For all the thirsty out there"
	},

	['police_stormram'] = {
		label = 'stormram',
		weight = 18000,
		stack = false,
		close = true,
		description = "A nice tool to break into doors"
	},

	['weapon_crowbar'] = {
		label = 'crowbar',
		weight = 1000,
		stack = true,
		close = true,
		description = "An iron bar with a flattened end, used as a lever"
	},

	['compactrifle_extendedclip'] = {
		label = 'rifle ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Compact Rifle Extended Clip"
	},

	['weapontint_lspd'] = {
		label = 'lspd tint',
		weight = 1000,
		stack = false,
		close = true,
		description = "LSPD Weapon Tint"
	},

	['painkillers'] = {
		label = 'painkillers',
		weight = 0,
		stack = false,
		close = true,
		description = "For pain you can't stand anymore, take this pill that'd make you feel great again"
	},

	['security_card_01'] = {
		label = 'security card a',
		weight = 0,
		stack = false,
		close = true,
		description = "A security card... I wonder what it goes to"
	},

	['weapon_combatpistol'] = {
		label = 'combat pistol',
		weight = 1000,
		stack = true,
		close = true,
		description = "A combat version small firearm designed to be held in one hand"
	},

	['pistol50_luxuryfinish'] = {
		label = 'pistol finish',
		weight = 1000,
		stack = false,
		close = true,
		description = ".50 Pistol Luxury Finish"
	},

	['combatpistol_defaultclip'] = {
		label = 'pistol clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Combat Pistol Default Clip"
	},

	['emp_ammo'] = {
		label = 'emp ammo',
		weight = 200,
		stack = false,
		close = true,
		description = "Ammo for EMP Launcher"
	},

	['advancedrifle_defaultclip'] = {
		label = 'rifle clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Advanced Rifle Default Clip"
	},

	['weapon_snowball'] = {
		label = 'snowball',
		weight = 1000,
		stack = true,
		close = true,
		description = "A ball of packed snow, especially one made for throwing at other people for fun"
	},

	['pistol_suppressor'] = {
		label = 'pistol suppressor',
		weight = 1000,
		stack = false,
		close = true,
		description = "Pistol Suppressor Attachment"
	},

	['weapon_marksmanpistol'] = {
		label = 'marksman pistol',
		weight = 1000,
		stack = true,
		close = true,
		description = "A very accurate small firearm designed to be held in one hand"
	},

	['repairkit'] = {
		label = 'repairkit',
		weight = 2500,
		stack = false,
		close = true,
		description = "A nice toolbox with stuff to repair your vehicle"
	},

	['rifle_ammo'] = {
		label = 'rifle ammo',
		weight = 1000,
		stack = false,
		close = true,
		description = "Ammo for Rifles"
	},

	['weapon_grenade'] = {
		label = 'grenade',
		weight = 1000,
		stack = true,
		close = true,
		description = "A handheld throwable bomb"
	},

	['certificate'] = {
		label = 'certificate',
		weight = 0,
		stack = false,
		close = true,
		description = "Certificate that proves you own certain stuff"
	},

	['weed_ak47'] = {
		label = 'ak47 2g',
		weight = 200,
		stack = false,
		close = false,
		description = "A weed bag with 2g AK47"
	},

	['weapon_briefcase_02'] = {
		label = 'suitcase',
		weight = 1000,
		stack = true,
		close = true,
		description = "Wonderfull for nice vacation to Liberty City"
	},

	['weapon_snspistol_mk2'] = {
		label = 'sns pistol mk ii',
		weight = 1000,
		stack = true,
		close = true,
		description = "SNS Pistol MK2"
	},

	['weapon_wrench'] = {
		label = 'wrench',
		weight = 1000,
		stack = true,
		close = true,
		description = "A tool used for gripping and turning nuts, bolts, pipes, etc"
	},

	['joint'] = {
		label = 'joint',
		weight = 0,
		stack = false,
		close = true,
		description = "Sidney would be very proud at you"
	},

	['carbinerifle_scope'] = {
		label = 'rifle scope',
		weight = 1000,
		stack = false,
		close = true,
		description = "Carbine Rifle Scope"
	},

	['beer'] = {
		label = 'beer',
		weight = 500,
		stack = false,
		close = true,
		description = "Nothing like a good cold beer!"
	},

	['assaultshotgun_defaultclip'] = {
		label = 'shotgun clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Assault Shotgun Default Clip"
	},

	['weapon_smg_mk2'] = {
		label = 'smg mk ii',
		weight = 1000,
		stack = true,
		close = true,
		description = "SMG MK2"
	},

	['smg_ammo'] = {
		label = 'smg ammo',
		weight = 500,
		stack = false,
		close = true,
		description = "Ammo for Sub Machine Guns"
	},

	['weapontint_army'] = {
		label = 'army tint',
		weight = 1000,
		stack = false,
		close = true,
		description = "Army Weapon Tint"
	},

	['smg_defaultclip'] = {
		label = 'smg clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "SMG Default Clip"
	},

	['diamond_ring'] = {
		label = 'diamond ring',
		weight = 1500,
		stack = false,
		close = true,
		description = "A diamond ring seems like the jackpot to me!"
	},

	['weapon_sniperrifle'] = {
		label = 'sniper rifle',
		weight = 1000,
		stack = true,
		close = true,
		description = "A high-precision, long-range rifle"
	},

	['10kgoldchain'] = {
		label = '10k gold chain',
		weight = 2000,
		stack = false,
		close = true,
		description = "10 carat golden chain"
	},

	['weapontint_black'] = {
		label = 'default tint',
		weight = 1000,
		stack = false,
		close = true,
		description = "Default/Black Weapon Tint"
	},

	['weapon_petrolcan'] = {
		label = 'petrol can',
		weight = 1000,
		stack = true,
		close = true,
		description = "A robust liquid container made from pressed steel"
	},

	['weapon_poolcue'] = {
		label = 'poolcue',
		weight = 1000,
		stack = true,
		close = true,
		description = "A stick used to strike a ball, usually the cue ball (or other things)"
	},

	['appistol_extendedclip'] = {
		label = 'pistol ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "APPistol Extended Clip"
	},

	['weed_purple-haze'] = {
		label = 'purple haze 2g',
		weight = 200,
		stack = false,
		close = false,
		description = "A weed bag with 2g Purple Haze"
	},

	['carbinerifle_drum'] = {
		label = 'rifle drum',
		weight = 1000,
		stack = false,
		close = true,
		description = "Carbine Rifle Drum"
	},

	['heavyarmor'] = {
		label = 'heavy armor',
		weight = 5000,
		stack = false,
		close = true,
		description = "Some protection won't hurt... right?"
	},

	['pistol50_extendedclip'] = {
		label = 'pistol ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = ".50 Pistol Extended Clip"
	},

	['screwdriverset'] = {
		label = 'toolkit',
		weight = 1000,
		stack = false,
		close = false,
		description = "Very useful to screw... screws..."
	},

	['weapon_compactlauncher'] = {
		label = 'compact launcher',
		weight = 1000,
		stack = true,
		close = true,
		description = "A compact grenade launcher"
	},

	['nitrous'] = {
		label = 'nitrous',
		weight = 1000,
		stack = false,
		close = true,
		description = "Speed up, gas pedal! :D"
	},

	['weapon_remotesniper'] = {
		label = 'remote sniper',
		weight = 1000,
		stack = true,
		close = true,
		description = "A portable high-precision, long-range rifle"
	},

	['weapon_assaultshotgun'] = {
		label = 'assault shotgun',
		weight = 1000,
		stack = true,
		close = true,
		description = "An assault version of asmoothbore gun for firing small shot at short range"
	},

	['marksmanrifle_extendedclip'] = {
		label = 'sniper ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Marksman Rifle Extended Clip"
	},

	['weapon_railgun'] = {
		label = 'railgun',
		weight = 1000,
		stack = true,
		close = true,
		description = "A weapon that uses electromagnetic force to launch high velocity projectiles"
	},

	['weapon_specialcarbine'] = {
		label = 'special carbine',
		weight = 1000,
		stack = true,
		close = true,
		description = "An extremely versatile assault rifle for any combat situation"
	},

	['weapon_hazardcan'] = {
		label = 'hazardous jerry can',
		weight = 1000,
		stack = true,
		close = true,
		description = "Weapon Hazardcan"
	},

	['marksmanrifle_luxuryfinish'] = {
		label = 'sniper finish',
		weight = 1000,
		stack = false,
		close = true,
		description = "Marksman Rifle Luxury Finish"
	},

	['bullpuprifle_defaultclip'] = {
		label = 'rifle clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Bullpup Rifle Default Clip"
	},

	['weapon_pumpshotgun'] = {
		label = 'pump shotgun',
		weight = 1000,
		stack = true,
		close = true,
		description = "A pump-action smoothbore gun for firing small shot at short range"
	},

	['oxy'] = {
		label = 'prescription oxy',
		weight = 0,
		stack = false,
		close = true,
		description = "The Label Has Been Ripped Off"
	},

	['pistol50_defaultclip'] = {
		label = 'pistol clip',
		weight = 1000,
		stack = false,
		close = true,
		description = ".50 Pistol Default Clip"
	},

	['advancedrepairkit'] = {
		label = 'advanced repairkit',
		weight = 4000,
		stack = false,
		close = true,
		description = "A nice toolbox with stuff to repair your vehicle"
	},

	['goldbar'] = {
		label = 'gold bar',
		weight = 7000,
		stack = false,
		close = true,
		description = "Looks pretty expensive to me"
	},

	['goldchain'] = {
		label = 'golden chain',
		weight = 1500,
		stack = false,
		close = true,
		description = "A golden chain seems like the jackpot to me!"
	},

	['tosti'] = {
		label = 'grilled cheese sandwich',
		weight = 200,
		stack = false,
		close = true,
		description = "Nice to eat"
	},

	['markedbills'] = {
		label = 'marked money',
		weight = 1000,
		stack = true,
		close = true,
		description = "Money?"
	},

	['assaultrifle_defaultclip'] = {
		label = 'rifle clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Assault Rifle Default Clip"
	},

	['firework2'] = {
		label = 'poppelers',
		weight = 1000,
		stack = false,
		close = true,
		description = "Fireworks"
	},

	['samsungphone'] = {
		label = 'samsung s10',
		weight = 1000,
		stack = false,
		close = true,
		description = "Very expensive phone"
	},

	['ifaks'] = {
		label = 'ifaks',
		weight = 200,
		stack = false,
		close = true,
		description = "ifaks for healing and a complete stress remover."
	},

	['weapon_combatmg'] = {
		label = 'combat mg',
		weight = 1000,
		stack = true,
		close = true,
		description = "A combat version of an automatic gun that fires bullets in rapid succession for as long as the trigger is pressed"
	},

	['snp_ammo'] = {
		label = 'sniper ammo',
		weight = 1000,
		stack = false,
		close = true,
		description = "Ammo for Sniper Rifles"
	},

	['advancedrifle_luxuryfinish'] = {
		label = 'rifle finish',
		weight = 1000,
		stack = false,
		close = true,
		description = "Advanced Rifle Luxury Finish"
	},

	['weaponlicense'] = {
		label = 'weapon license',
		weight = 0,
		stack = true,
		close = true,
		description = "Weapon License"
	},

	['carbinerifle_luxuryfinish'] = {
		label = 'rifle finish',
		weight = 1000,
		stack = false,
		close = true,
		description = "Carbine Rifle Luxury Finish"
	},

	['security_card_02'] = {
		label = 'security card b',
		weight = 0,
		stack = false,
		close = true,
		description = "A security card... I wonder what it goes to"
	},

	['carbinerifle_extendedclip'] = {
		label = 'rifle ext clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Carbine Rifle Extended Clip"
	},

	['snikkel_candy'] = {
		label = 'snikkel',
		weight = 100,
		stack = false,
		close = true,
		description = "Some delicious candy :O"
	},

	['xtcbaggy'] = {
		label = 'bag of xtc',
		weight = 0,
		stack = false,
		close = true,
		description = "Pop those pills baby"
	},

	['weapon_vintagepistol'] = {
		label = 'vintage pistol',
		weight = 1000,
		stack = true,
		close = true,
		description = "An antique firearm designed to be held in one hand"
	},

	['weapon_combatshotgun'] = {
		label = 'combat shotgun',
		weight = 1000,
		stack = true,
		close = true,
		description = "Weapon Combatshotgun"
	},

	['weapon_flashlight'] = {
		label = 'flashlight',
		weight = 1000,
		stack = true,
		close = true,
		description = "A battery-operated portable light"
	},

	['weapon_sawnoffshotgun'] = {
		label = 'sawn-off shotgun',
		weight = 1000,
		stack = true,
		close = true,
		description = "A sawn-off smoothbore gun for firing small shot at short range"
	},

	['weapon_hominglauncher'] = {
		label = 'homing launcher',
		weight = 1000,
		stack = true,
		close = true,
		description = "A weapon fitted with an electronic device that enables it to find and hit a target"
	},

	['weapon_smokegrenade'] = {
		label = 'smoke grenade',
		weight = 1000,
		stack = true,
		close = true,
		description = "An explosive charge that can be remotely detonated"
	},

	['specialcarbine_defaultclip'] = {
		label = 'rifle clip',
		weight = 1000,
		stack = false,
		close = true,
		description = "Special Carbine Default Clip"
	},

	['weapon_proxmine'] = {
		label = 'proxmine grenade',
		weight = 1000,
		stack = true,
		close = true,
		description = "A bomb placed on the ground that detonates when going within its proximity"
	},

	['weapon_handcuffs'] = {
		label = 'handcuffs',
		weight = 1000,
		stack = true,
		close = true,
		description = "A pair of lockable linked metal rings for securing a prisoner's wrists"
	},

	['specialcarbine_drum'] = {
		label = 'rifle drum',
		weight = 1000,
		stack = false,
		close = true,
		description = "Special Carbine Drum"
	},
}