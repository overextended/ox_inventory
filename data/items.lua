return {
	['prop_cone_small'] = {
		label = 'Traffic cone',
		description = "Small traffic cone",
		prop = {`prop_mp_cone_02`, `prop_mp_cone_03`, `prop_roadcone02a`, `prop_roadcone02b`, `prop_roadcone02c`},
		vehiclesWillAvoid = true,
		weight = 1800,
		stack = true,
		close = true,
		allowArmed = false,
		client = {
			anim = { dict = "anim@mp_snowball", clip = "pickup_snowball" },
			disable = { move = true, car = true, combat = true },
			usetime = 900,
			cancel = true,
		},
		server = {
			export = 'itemcollection.use'
		}
	},
	['prop_cone_large'] = {
		label = 'Traffic cone',
		description = "Large traffic cone",
		prop = {`prop_mp_cone_01`, `prop_roadcone01a`, `prop_roadcone01b`, `prop_roadcone01c`},
		vehiclesWillAvoid = true,
		weight = 1800,
		stack = true,
		close = true,
		allowArmed = false,
		client = {
			anim = { dict = "anim@mp_snowball", clip = "pickup_snowball" },
			disable = { move = true, car = true, combat = true },
			usetime = 900,
			cancel = true,
		},
		server = {
			export = 'itemcollection.use'
		}
	},
	["prop_police_barrier"] = {
		label = 'Police barrier',
		description = "DO NOT CROSS POLICE DEPT.",
		prop = `prop_barrier_work05`,
		vehiclesWillAvoid = true,
		weight = 1800,
		stack = true,
		close = true,
		allowArmed = false,
		client = {
			anim = { dict = "anim@mp_snowball", clip = "pickup_snowball" },
			disable = { move = true, car = true, combat = true },
			usetime = 900,
			cancel = true,
		},
		server = {
			export = 'itemcollection.use'
		}
	},
	["prop_barrier_small"] = {
		label = 'Work barrier',
		description = "Small work barrier",
		prop = `prop_barrier_work01a`,
		vehiclesWillAvoid = true,
		weight = 1800,
		stack = true,
		close = true,
		allowArmed = false,
		client = {
			anim = { dict = "anim@mp_snowball", clip = "pickup_snowball" },
			disable = { move = true, car = true, combat = true },
			usetime = 900,
			cancel = true,
		},
		server = {
			export = 'itemcollection.use'
		}
	},
	["prop_barrier_medium"] = {
		label = 'Work barrier',
		description = "Medium work barrier",
		prop = `prop_barrier_work06a`,
		vehiclesWillAvoid = true,
		weight = 1800,
		stack = true,
		close = true,
		allowArmed = false,
		client = {
			anim = { dict = "anim@mp_snowball", clip = "pickup_snowball" },
			disable = { move = true, car = true, combat = true },
			usetime = 900,
			cancel = true,
		},
		server = {
			export = 'itemcollection.use'
		}
	},
	["prop_barrier_large"] = {
		label = 'Work barrier',
		description = "Large work barrier",
		prop = `prop_mp_barrier_02b`,
		vehiclesWillAvoid = true,
		weight = 1800,
		stack = true,
		close = true,
		allowArmed = false,
		client = {
			anim = { dict = "anim@mp_snowball", clip = "pickup_snowball" },
			disable = { move = true, car = true, combat = true },
			usetime = 900,
			cancel = true,
		},
		server = {
			export = 'itemcollection.use'
		}
	},
	["prop_worklight_large"] = {
		label = 'Worklight',
		description = "Large worklight",
		prop = `prop_worklight_03b`,
		vehiclesWillAvoid = true,
		weight = 1800,
		stack = true,
		close = true,
		allowArmed = false,
		client = {
			anim = { dict = "anim@mp_snowball", clip = "pickup_snowball" },
			disable = { move = true, car = true, combat = true },
			usetime = 900,
			cancel = true,
		},
		server = {
			export = 'itemcollection.use'
		}
	},
	["prop_worklight_small"] = {
		label = 'Worklight',
		description = "Small worklight",
		prop = `prop_worklight_02a`,
		vehiclesWillAvoid = true,
		weight = 1800,
		stack = true,
		close = true,
		allowArmed = false,
		client = {
			anim = { dict = "anim@mp_snowball", clip = "pickup_snowball" },
			disable = { move = true, car = true, combat = true },
			usetime = 900,
			cancel = true,
		},
		server = {
			export = 'itemcollection.use'
		}
	},
	
	['tintchecker'] = {
		label = 'Tint Checker',
		weight = 500,
		client = {
			export = 'policetools.tintchecker'
		},
	},
	["mdt"] = {
		label = "MDT",
		weight = 800,
		client = {
			export = "ND_MDT.useTablet"
		}
	},

	["cashbox"] = {
		label = "Cash Box",
		weight = 10000,
		stack = false,
		consume = 0,
		client = {
			export = 'bobcat.cashbox',
			add = function(total)
				TriggerEvent('bobcat:cashboxAdd')
			end,
			remove = function(total)
				TriggerEvent('bobcat:cashboxRemove')
			end,
		}
	},
	
	["cryptostick"] = {
		label = "Crypto Stick",
		weight = 50,
		stack = false,
	},
	
	["phone_dongle"] = {
		label = "Phone Dongle",
		weight = 50,
		stack = false,
	},
	
	["powerbank"] = {
		label = "Power Bank",
		weight = 50,
		stack = false,
	},
	
	['phone'] = {
		label = 'Classic Phone',
		weight = 150,
		stack = false,
		consume = 0,
		client = {
			export = "qs-smartphone-pro.UsePhoneItem",
			add = function(total)
				TriggerServerEvent('phone:itemAdd')
			end,
	
			remove = function(total)
				TriggerServerEvent('phone:itemDelete')
			end
		}
	},
	
	['black_phone'] = {
		label = 'Black Phone',
		weight = 150,
		stack = false,
		consume = 0,
		client = {
			export = "qs-smartphone-pro.UsePhoneItem",
			add = function(total)
				TriggerServerEvent('phone:itemAdd')
			end,
	
			remove = function(total)
				TriggerServerEvent('phone:itemDelete')
			end
		}
	},
	
	['yellow_phone'] = {
		label = 'Yellow Phone',
		weight = 150,
		stack = false,
		consume = 0,
		client = {
			export = "qs-smartphone-pro.UsePhoneItem",
			add = function(total)
				TriggerServerEvent('phone:itemAdd')
			end,
	
			remove = function(total)
				TriggerServerEvent('phone:itemDelete')
			end
		}
	},
	
	['red_phone'] = {
		label = 'Red Phone',
		weight = 150,
		stack = false,
		consume = 0,
		client = {
			export = "qs-smartphone-pro.UsePhoneItem",
			add = function(total)
				TriggerServerEvent('phone:itemAdd')
			end,
	
			remove = function(total)
				TriggerServerEvent('phone:itemDelete')
			end
		}
	},
	
	['green_phone'] = {
		label = 'Green Phone',
		weight = 150,
		stack = false,
		consume = 0,
		client = {
			export = "qs-smartphone-pro.UsePhoneItem",
			add = function(total)
				TriggerServerEvent('phone:itemAdd')
			end,
	
			remove = function(total)
				TriggerServerEvent('phone:itemDelete')
			end
		}
	},
	
	['white_phone'] = {
		label = 'White Phone',
		weight = 150,
		stack = false,
		consume = 0,
		client = {
			export = "qs-smartphone-pro.UsePhoneItem",
			add = function(total)
				TriggerServerEvent('phone:itemAdd')
			end,
	
			remove = function(total)
				TriggerServerEvent('phone:itemDelete')
			end
		}
	},
	
	["smokebomb"] = {
		label = "Smokebomb",
		weight = 0,
		stack = false,
		close = false,
		description = "uh oh",
		client = {
			image = "WEAPON_GRENADE.png",
		}
	},

	["paleto_key"] = {
		label = "Paleto Key",
		weight = 0,
		stack = false,
		close = false,
		description = "A key for Paleto Bank",
		client = {
			image = "paleto_key.png",
		}
	},
	["paletocardone"] = {
		label = "Paleto Card A",
		weight = 0,
		stack = false,
		close = false,
		description = "A security card for Paleto Bank",
		client = {
			image = "paletocardone.png",
		}
	},

	["paletocardtwo"] = {
		label = "Paleto Card B",
		weight = 0,
		stack = false,
		close = false,
		description = "A security card for Paleto Bank",
		client = {
			image = "paletocardtwo.png",
		}
	},

	["pliers"] = {
		label = "Pliers",
		weight = 125,
		stack = false,
		close = false,
		description = "A pair of pliers",
		client = {
			image = "pliers.png",
		}
	},


	["flight_device"] = {
		label = "Flapper Hero",
		weight = 125,
		stack = false,
		close = false,
		description = "?????????",
		client = {
			image = "flight_device.png",
		}
	},


	["bag"] = {
		label = "Duffel Bag",
		weight = 250,
		stack = false,
		close = false,
		description = "Duffel bag",
		client = {
			image = "bag.png",
		}
	},

	["hackcard"] = {
		label = "Hackcard",
		weight = 50,
		stack = false,
		close = false,
		description = "Hack card",
		client = {
			image = "hackcard.png",
		}
	},

	["decryptor"] = {
		label = "Decrypt-o-matic",
		weight = 300,
		stack = false,
		close = false,
		description = "Decrypt PIN based encryptions",
		client = {
			image = "decryptomatic.png",
		}
	},

	['themeparkpass'] = {
		label = 'Park Pass',
		weight = 250,
		stack = false,
		close = true,
		client = {
			export = 'salife_oxinv.themeparkpass'
		}
	},

	['banana'] = {
		label = 'Banana',
		weight = 250,
		stack = false,
		close = true,
		client = {
			event = 'rtx_wateractivities:Banana:SpawnBanana',
		}
	},
	['inflatable'] = {
		label = 'Inflatable',
		weight = 250,
		stack = false,
		close = true,
		client = {
			event = 'rtx_wateractivities:Inflatable:SpawnInflatable',
		}
	},
	['parasailing'] = {
		label = 'Parasailing',
		weight = 250,
		stack = false,
		close = true,
		client = {
			event = 'rtx_wateractivities:Parachute:SpawnParachute',
		}
	},
	['ski'] = {
		label = 'Ski',
		weight = 250,
		stack = false,
		close = true,
		client = {
			event = 'rtx_wateractivities:Ski:SpawnSki',
		}
	},
	['circle'] = {
		label = 'Circle',
		weight = 250,
		stack = false,
		close = true,
		client = {
			event = 'rtx_wateractivities:Circle:SpawnCircle',
		}
	},
	['bed1'] = {
		label = 'Bed1',
		weight = 250,
		stack = false,
		close = true,
		client = {
			event = 'rtx_wateractivities:Bed:SpawnBed',
		}
	},
	['bed2'] = {
		label = 'Bed2',
		weight = 250,
		stack = false,
		close = true,
		client = {
			event = 'rtx_wateractivities:Bed2:SpawnBed',
		}
	},
	['bed3'] = {
		label = 'Bed3',
		weight = 250,
		stack = false,
		close = true,
		client = {
			event = 'rtx_wateractivities:Bed3:SpawnBed',
		}
	},
	['bed4'] = {
		label = 'Bed4',
		weight = 250,
		stack = false,
		close = true,
		client = {
			event = 'rtx_wateractivities:Bed4:SpawnBed',
		}
	},

	['repairengineparts'] = {
		label = 'Repair Engine Parts',
		weight = 250,
		stack = false,
		close = true,
	},

	['street_tires'] = {
		label = 'Street Tires',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},
	['sports_tires'] = {
		label = 'Sports Tires',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},
	['racing_tires'] = {
		label = 'Racing Tires',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},
	['drag_tires'] = {
		label = 'Drag Tires',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['transmition_clutch'] = {
		label = 'OEM Transmission Clutch',
		weight = 100,
		stack = true,
		client = {

			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'

		}
	},

	['engine_flywheel'] = {
		label = 'OEM Flywheel',
		weight = 100,
		stack = true,
		client = {

			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'

		}
	},

	['engine_oil'] = {
		label = 'OEM Engine Oil',
		weight = 100,
		stack = true,
		client = {

			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'

		}
	},

	['engine_sparkplug'] = {
		label = 'Sparkplugs Kit',
		weight = 50,
		stack = true,
		client = {
			--status = { hunger = -10000, thirst = -10000, stress = -100000 },
			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'

		}
	},

	['engine_gasket'] = {
		label = 'OEM Head Gasket Kit',
		weight = 50,
		stack = true,
		client = {
			--status = { hunger = -10000, thirst = -10000, stress = -100000 },
			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'

		}
	},

	['engine_airfilter'] = {
		label = 'OEM Intake Air Filter',
		weight = 50,
		stack = true,
		client = {
			--status = { hunger = -20000, thirst = -30000, stress = -100000 },
			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'

		}
	},

	['engine_fuelinjector'] = {
		label = 'OEM Fuel Injectors',
		weight = 150,
		stack = true,
		client = {
			--status = { hunger = -20000, thirst = -30000, stress = -100000 },
			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'

		}
	},
	['engine_pistons'] = {
		label = 'OEM Pistons Kit',
		weight = 350,
		stack = true,
		client = {

			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'

		}
	},

	['engine_connectingrods'] = {
		label = 'OEM Connecting Rods Kit',
		weight = 350,
		stack = true,
		client = {

			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'

		}
	},

	['engine_valves'] = {
		label = 'OEM Head Valves Kit',
		weight = 350,
		stack = true,
		client = {

			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'

		}
	},

	['engine_block'] = {
		label = 'OEM Block',
		weight = 350,
		stack = true,
		client = {

			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'

		}
	},

	['engine_crankshaft'] = {
		label = 'OEM CrankShaft',
		weight = 350,
		stack = true,
		client = {

			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['engine_camshaft'] = {
		label = 'OEM Camshaft',
		weight = 350,
		stack = true,
		client = {

			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['ecu'] = {
		label = 'ecu',
		weight = 20,
		stack = true,
		close = true,
		description = nil,
		client = {

			anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['drift_tires'] = {
		label = 'Drift Tires',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},


	['lsdf'] = {
		label = 'Limited Slip Differential (Front)',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['lsdr'] = {
		label = 'Limited Slip Differential (Rear)',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['tcs'] = {
		label = 'Traction Control System (TCS)',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['esc'] = {
		label = 'Stability Control System (ESC)',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['closerationgears'] = {
		label = 'Close Ratio Gears',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['cvttranny'] = {
		label = 'CVT Transmission',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['abs'] = {
		label = 'Anti-lock braking System',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['axletorsionfront'] = {
		label = 'Axle Torsion (Front)',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['axletorsionrear'] = {
		label = 'Axle Torsion (Rear)',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['axlesolidfront'] = {
		label = 'Axle Solid (Front)',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['axlesolidrear'] = {
		label = 'Axle Solid (Rear)',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['kers'] = {
		label = 'Kinetic Energy Recovery System (KERS)',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['offroadtune1'] = {
		label = 'Offroad Tune 1',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['offroadtune2'] = {
		label = 'Offroad Tune 2',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['stanced'] = {
		label = 'Stanced Tune',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['frontwheeldrive'] = {
		label = 'Front Wheel Drivetrain',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['allwheeldrive'] = {
		label = 'All Wheel Drivetrain',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['rearwheeldrive'] = {
		label = 'Rear Wheel Drivetrain',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['oem_brakes'] = {
		label = 'OEM Brakes',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['oem_suspension'] = {
		label = 'OEM Suspension',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},

	['oem_gearbox'] = {
		label = 'OEM Gear Box',
		weight = 250,
		stack = true,
		close = true,
		client = {
			anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
			usetime = 5500,
			export = 'renzu_tuners.useItem'
		}
	},


	['steel'] = {
		label = 'Steel',
		weight = 150,
		stack = true,
		close = true,
		description = nil,
	},
	['polyester'] = {
		label = 'Polyester',
		weight = 20,
		stack = true,
		close = true,
		description = nil,
	},
	['methane'] = {
		label = 'Methane',
		weight = 20,
		stack = true,
		close = true,
		description = nil,
	},
	['chip'] = {
		label = 'Chip',
		weight = 20,
		stack = true,
		close = true,
		description = nil,
	},
	['board'] = {
		label = 'Board',
		weight = 20,
		stack = true,
		close = true,
		description = nil,
	},

	["toothbrush"] = {
		label = "Toothbrush",
		weight = 100,
		stack = false,
		description = "For all your... oral hygiene needs",
		client = {
			image = "toothbrush.png",
			export = "salife_oxinv.toothbrush",
		},
		buttons = {
			{
				label = 'Toss Brush',
				action = function(slot)
					exports['salife_oxinv']:toothbrushToss(slot)
				end
			},
		}
	},
	["asscase"] = {
		label = "Ass Case",
		weight = 100,
		stack = false,
		description = "Stow something",
		client = {
			image = "toothbrush.png",
			export = "salife_oxinv.asscase",
		},
	},
	["dice_b"] = {
		label = "Dice",
		weight = 400,
		stack = false,
		consume = 0.02,
		description = "For all your... board game needs",
		client = {
			image = "dice_b.png",
			export = "salife_oxinv.diceRoll2",
		},
		buttons = {
			{
				label = 'Roll 1',
				group = "More",
				action = function(slot)
					exports['salife_oxinv']:diceRoll1("", { name = "dice_b" })
				end
			},
			{
				label = 'Roll 3',
				group = "More",
				action = function(slot)
					exports['salife_oxinv']:diceRoll3("", { name = "dice_b" })
				end
			},
		}
	},
	["dice_r"] = {
		label = "Dice",
		weight = 400,
		stack = false,
		consume = 0.02,
		description = "For all your... board game needs",
		client = {
			image = "dice_r.png",
			export = "salife_oxinv.diceRoll2",
		},
		buttons = {
			{
				label = 'Roll 1',
				group = "More",
				action = function(slot)
					exports['salife_oxinv']:diceRoll1("", { name = "dice_r" })
				end
			},
			{
				label = 'Roll 3',
				group = "More",
				action = function(slot)
					exports['salife_oxinv']:diceRoll3("", { name = "dice_r" })
				end
			},
		}
	},
	["dice_g"] = {
		label = "Dice",
		weight = 400,
		stack = false,
		consume = 0.02,
		description = "For all your... board game needs",
		client = {
			image = "dice_g.png",
			export = "salife_oxinv.diceRoll2",
		},
		buttons = {
			{
				label = 'Roll 1',
				group = "More",
				action = function(slot)
					exports['salife_oxinv']:diceRoll1("", { name = "dice_g" })
				end
			},
			{
				label = 'Roll 3',
				group = "More",
				action = function(slot)
					exports['salife_oxinv']:diceRoll3("", { name = "dice_g" })
				end
			},
		}
	},
	["dice_y"] = {
		label = "Dice",
		weight = 400,
		stack = false,
		consume = 0.02,
		description = "For all your... board game needs",
		client = {
			image = "dice_y.png",
			export = "salife_oxinv.diceRoll2",
		},
		buttons = {
			{
				label = 'Roll 1',
				group = "More",
				action = function(slot)
					exports['salife_oxinv']:diceRoll1("", { name = "dice_y" })
				end
			},
			{
				label = 'Roll 3',
				group = "More",
				action = function(slot)
					exports['salife_oxinv']:diceRoll3("", { name = "dice_y" })
				end
			},
		}
	},
	["dice_w"] = {
		label = "Dice",
		weight = 400,
		stack = false,
		consume = 0.02,
		description = "For all your... board game needs",
		client = {
			image = "dice_w.png",
			export = "salife_oxinv.diceRoll2",
		},
		buttons = {
			{
				label = 'Roll 1',
				group = "More",
				action = function(slot)
					exports['salife_oxinv']:diceRoll1("", { name = "dice_w" })
				end
			},
			{
				label = 'Roll 3',
				group = "More",
				action = function(slot)
					exports['salife_oxinv']:diceRoll3("", { name = "dice_w" })
				end
			},
		}
	},
	['money'] = {
		label = 'Dollars',
		weight = 0.1,
		consume = false,
		client = {
			export = 'salife_oxinv.money'
		}
	},
	['moneybundle'] = {
		label = 'Bundled Cash',
		client = {
			image = 'black_money.png',
			export = 'salife_oxinv.moneybundle'
		},
		weight = 0.1,
	},

	['joint'] = {
		label = 'Joint',
		weight = 200.0,
		description = "",
		client = {
			export = 'salife_oxinv.joint',
		}
	},

	['syringe'] = {
		label = 'Syringe',
		weight = 200.0,
	},


	['acid'] = {
		label = 'Acid',
		weight = 200.0,
		description = "acidic",
		client = {
			export = 'salife_oxinv.acid'
		}
	},
	['methb'] = {
		label = 'Meth',
		weight = 200.0,
		description = "Some Meth.",
		client = {
			export = 'salife_oxinv.methb'
		}
	},
	['heroin'] = {
		label = 'Heroin',
		weight = 200.0,
		description = "Some Heroin.",
		client = {
			export = 'salife_oxinv.heroin'
		}
	},

	['vodka'] = {
		label = 'Vodka',
		weight = 100.0,
		description = "Clear distilled beverage.",
		client = {
			export = 'salife_oxinv.vodka',
		}
	},

	['cocktail'] = {
		label = 'Cocktail',
		weight = 100.0,
		description = "Mixed drink",
		client = {
			export = 'salife_oxinv.cocktail',
		}
	},

	['patriot'] = {
		label = 'Patriot Beer',
		weight = 100.0,
		description = "Patriot Brand Beer.",
		client = {
			export = 'salife_oxinv.patriot',
		}
	},

	['cig'] = {
		label = 'Cig',
		weight = 200.0,
		description = "",
		client = {
			export = 'salife_oxinv.cig',
		}
	},

	['waxkit'] = {
		label = 'Wax Kit',
		weight = 1000,
		description = "Wax Kit.",
		client = {
			export = 'salife_oxinv.waxkit'
		}
	},

	['bouquet'] = {
		label = 'Bouquet',
		description = 'Pretty Flowers',
		weight = 30.0,
		stack = false,
		degrade = (60 * 24) * 3,
		decay = true,
		close = true,
		consume = 0.05,
		allowArmed = false,
		client = {
			export = 'salife_oxinv.bouquet',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
			prop = {
				model = 'prop_snow_flower_02',
				pos = { x = -0.29, y = 0.40, z = -0.02, },
				rot = { x = -90.0, y = -90.0, z = 0.0 },
			}
		}
	},
	['scraper'] = {
		label = 'Scraper',
		weight = 1000,
		allowArmed = false,
		consume = 0.1,
		decay = true,
		client = {
			export = 'salife-garages.scraper',
		},
	},
	['vehspray'] = {
		label = 'Vehicle Spray',
		--description = 'Vehicle Mod',
		weight = 1000,
		allowArmed = false,
		consume = 1,
		client = {
			export = 'salife-garages.vehspray',
		},
	},
	['vehmod'] = {
		label = 'Vehicle Mod',
		--description = 'Vehicle Mod',
		weight = 1000,
		allowArmed = false,
		consume = 1,
		client = {
			export = 'salife-garages.vehmod',
		},
	},
	['stancer'] = {
		label = "Stancer",
		weight = 1000,
		stack = false,
		consume = 1,
		client = {
			export = 'salife_oxinv.stancer',
		},
	},

	['washer'] = {
		label = 'Washer',
		description = 'Place down anywhere and wash some money',
		weight = 10000.0,
		allowArmed = false,
		consume = 1,
		client = {
			export = 'velo_moneywash.washer',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	['generator'] = {
		label = 'Generator',
		description = 'Place down anywhere and make energy',
		weight = 5000.0,
		allowArmed = false,
		consume = 1,
		client = {
			export = 'velo_moneywash.generator',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	['capacitor'] = {
		label = 'Capacitor',
		description = 'Store your energy for later',
		weight = 5000.0,
		allowArmed = false,
		consume = 1,
		client = {
			image = "cpu_battery.png",
			export = 'velo_moneywash.capacitor',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	["pooltable"] = {
		label = 'Pool Table',
		weight = 10000.0,
		allowArmed = false,
		consume = 1,
		client = {
			export = 'velo_moneywash.pooltable',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	["poolcuerack"] = {
		label = 'Pool Cue Rack',
		weight = 5000.0,
		allowArmed = false,
		consume = 1,
		client = {
			export = 'velo_moneywash.poolcuerack',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	["pstash"] = {
		label = 'Stash',
		weight = 5000.0,
		allowArmed = false,
		consume = 1,
		client = {
			export = 'velo_moneywash.pstash',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	["trashcan"] = {
		label = 'Trash Can',
		weight = 5000.0,
		allowArmed = false,
		consume = 1,
		client = {
			export = 'velo_moneywash.trashcan',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	["scavitem"] = {
		label = 'scavitem',
		weight = 250.0,
		allowArmed = false,
		consume = 1,
		stack = true,
		client = {
			export = 'velo_moneywash.scavitem',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	["mailbox"] = {
		label = 'Mailbox',
		weight = 5000.0,
		allowArmed = false,
		consume = 1,
		client = {
			export = 'velo_moneywash.mailbox',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	["shower"] = {
		label = 'Shower',
		weight = 5000.0,
		allowArmed = false,
		consume = 1,
		client = {
			export = 'velo_moneywash.shower',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	["barrel"] = {
		label = 'Barrel',
		weight = 5000.0,
		allowArmed = false,
		consume = 1,
		client = {
			export = 'velo_moneywash.barrel',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	["masher"] = {
		label = 'Masher',
		weight = 5000.0,
		allowArmed = false,
		consume = 1,
		client = {
			export = 'velo_moneywash.masher',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	["corker"] = {
		label = 'Corker',
		weight = 5000.0,
		allowArmed = false,
		consume = 1,
		client = {
			export = 'velo_moneywash.corker',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	["furnace"] = {
		label = 'Furnace',
		weight = 5000.0,
		allowArmed = false,
		consume = 1,
		client = {
			export = 'velo_moneywash.furnace',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	["pshop"] = {
		label = 'Shop',
		weight = 5000.0,
		allowArmed = false,
		consume = 1,
		client = {
			export = 'velo_moneywash.pshop',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	["carradio"] = {
		label = 'Car Radio',
		weight = 500.0,
		allowArmed = false,
		consume = 0.005,
		image = 'carradio',
		client = {
			export = 'salife_oxinv.carradio',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	["boombox"] = {
		label = 'Boombox',
		weight = 5000.0,
		allowArmed = false,
		consume = 1,
		client = {
			export = 'velo_moneywash.boombox',
			anim = { dict = 'impexp_int-0', clip = 'mp_m_waremech_01_dual-0' },
		}
	},
	['boxofchocolates'] = {
		label = 'Box of Chocolates',
		weight = 100.0,
		stack = true,
		degrade = (60 * 24) * 1,
		close = true,
		consume = 0.17,
		allowArmed = false,
		client = {
			status = { hunger = 10 },
			anim = 'eating',
			prop = {
				model = `prop_choc_pq`,
				pos = { x = 0.02, y = 0.02, z = -0.02 },
				rot = { x = 0.0, y = 0.0, z = 0.0 },
			},
			usetime = 1200,
			notification = 'You ate a piece of Chocolate'
		}
	},
	['gum'] = {
		label = 'Gum',
		weight = 0.1,
		stack = true,
		close = true,
		consume = 1,
		client = {
			status = { hunger = 0.1 },
			anim = 'eating',
			usetime = 100,
			notification = 'You are chewing Gum'
		}
	},
	['icecream'] = {
		label = 'Ice Cream',
		weight = 100.0,
		stack = false,
		degrade = 15,
		close = true,
		consume = 1,
		allowArmed = false,
		client = {
			status = { hunger = 10 },
			export = 'salife_oxinv.icecream',
			anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
			prop = {
				model = 'bzzz_icecream_lemon',
				pos = { x = 0.14, y = 0.03, z = 0.01 },
				rot = { x = 85.0, y = 70.0, z = -203.0 },
			}
		}
	},
	['grilledchickensandwhich'] = {
		label = 'Grilled Chicken Sandwhich',
		weight = 220.0,
		stack = true,
		degrade = 60,
		close = true,
		consume = 1,
		allowArmed = false,
		client = {
			status = { hunger = 20 },
			export = 'salife_oxinv.grilledchickensandwhich',
			anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
			prop = {
				model = 'prop_cs_burger_01',
				pos = { x = 0.13, y = 0.05, z = 0.02 },
				rot = { x = -50.0, y = 16.0, z = 60.0 },
			}
		}
	},
	['candyapple'] = {
		label = 'Candy Apple',
		weight = 100.0,
		stack = true,
		degrade = 45,
		close = true,
		consume = 1,
		allowArmed = false,
		client = {
			status = { hunger = 5 },
			export = 'salife_oxinv.candyapple',
			anim = { dict = 'anim@heists@humane_labs@finale@keycards', clip = 'ped_a_enter_loop' },
			prop = {
				model = 'apple_1',
				pos = { x = 0.12, y = 0.15, z = 0.0 },
				rot = { x = -100.0, y = 0.0, z = -12.0 },
			}
		}
	},
	['croissant'] = {
		label = 'Croissant',
		weight = 50.0,
		stack = true,
		degrade = 30,
		close = true,
		consume = 1,
		allowArmed = false,
		client = {
			status = { hunger = 10 },
			export = 'salife_oxinv.criossant',
			anim = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
			prop = {
				model = 'bzzz_foodpack_croissant001',
				pos = { x = 0.0000, y = 0.0000, z = -0.0100 },
				rot = { x = 0.0000, y = 0.0000, z = 90.0000 },
			}
		}
	},
	['icebox'] = {
		label = 'Icebox',
		weight = 2000.0,
		stack = false,
	},
	['cardbinder'] = {
		label = 'Card Binder',
		description = 'Holds up to 400 cards',
		weight = 2000.0,
		stack = false,
	},
	['booster'] = {
		label = 'Booster Pack',
		description = 'Most Wanted booster pack for expanding your collection',
		weight = 5.0,
		stack = false,
		consume = 0.5,
		client = {
			usetime = 5000,

			anim = { dict = 'amb@lo_res_idles@', clip = 'world_human_lean_male_hands_together_lo_res_base' },
			prop = {
				model = 'vw_prop_vw_key_card_01a',
				pos = { x = 0.02, y = 0.02, z = -0.02 },
				rot = { x = 0.0, y = 0.0, z = 0.0 }
			},
			disable = {
				move = true,
				car = true,
				combat = true,
				mouse = false,
			},

			export = 'salife_tcg.booster',
		},
	},
	['card'] = {
		label = 'Card',
		weight = 5.0,
		stack = true,
		consume = 0,
		client = {
			usetime = 1000,
			disable = {
				move = false,
				car = false,
				combat = false,
				mouse = false,
			},
			export = 'salife_tcg.card',
		},
	},
	['funkobag'] = {
		label = 'Funko Bag',
		weight = 100,
		stack = false,
		consume = 0,
	},
	['funkobox'] = {
		label = 'Funko Pop Box',
		weight = 5.0,
		stack = true,
		consume = 1,
		client = {
			usetime = 1000,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			export = 'salife_tcg.funkobox',
		},
	},
	['funko'] = {
		label = 'Funko Pop',
		weight = 5.0,
		stack = true,
		consume = 0,
		client = {
			usetime = 1000,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			export = 'salife_tcg.funko',
		},
	},
	['rustyfishingrod'] = {
		label = 'Rusty Fishing Rod',
		weight = 200.0,
		stack = true,
		consume = 0.05,
		client = {
			export = 'salife-newfish.rustyfishingrod',
		}
	},
	['fishingrod'] = {
		label = 'Fishing Rod',
		weight = 200.0,
		stack = true,
		consume = 0.01,
		client = {
			export = 'salife-newfish.fishingrod',
		}
	},
	['fishingbait'] = {
		label = 'Fishing Bait',
		weight = 25.0,
		stack = true,
	},
	['fish'] = {
		label = 'Fish',
		weight = 1000.0,
		stack = false,
	},
	['vintagewine'] = {
		label = 'Vintage Wine',
		weight = 3000.0,
		stack = false,
	},
	['vr'] = {
		label = 'VR',
		weight = 250.0,
		stack = false,
		consume = false,
		client = {
			export = "salife_vr.vr",
		},
	},
	['vsal'] = {
		label = 'vSal',
		weight = 0.0,
		stack = true,
	},
	['vcraft'] = {
		label = 'Craft',
		weight = 0.0,
		stack = false,
		consume = false,
		client = {
			export = 'salife_vr_world.craft',
		},
	},
	['vshop'] = {
		label = 'Shop',
		weight = 0.0,
		stack = false,
		consume = false,
		client = {
			usetime = 5000,
			disable = {
				move = false,
				car = false,
				combat = false,
				mouse = false,
			},
			export = 'salife_vr_world.shop',
		},
	},
	['vcar'] = {
		label = 'Car',
		weight = 0.0,
		stack = false,
		consume = 0.05,
		allowArmed = false,

		client = {
			usetime = 5000,
			disable = {
				move = false,
				car = false,
				combat = false,
				mouse = false,
			},
			export = 'salife_vr_world.car',
		},
	},
	['diamondearrings'] = {
		label = 'Diamond Earrings',
		weight = 10.0,
		stack = true,
	},
	['goldearrings'] = {
		label = 'Golden Earrings',
		weight = 15.0,
		stack = true,
	},
	['earrings'] = {
		label = 'Earrings',
		weight = 6.0,
		stack = true,
	},
	['diamondtiara'] = {
		label = 'Diamond Tiara',
		weight = 140.0,
		stack = true,
	},
	['pendant'] = {
		label = 'Pendant',
		weight = 10.0,
		stack = true,
	},
	['cufflinks'] = {
		label = 'Cufflinks',
		weight = 9.0,
		stack = true,
	},
	['scanner'] = {
		label = 'Scanner',
		weight = 1000,
		stack = false,
	},
	['paper'] = {
		label = 'Paper',
		weight = 1,
		stack = true,
		client = {
			add = function(total)
				TriggerEvent('cashexchange:paycheckAdd')
			end,
			remove = function(total)
				TriggerEvent('cashexchange:paycheckRemove')
			end,
		}
	},
	['ticketbook'] = {
		label = 'Ticket Book',
		weight = 100,
		stack = false,
		client = {
			export = 'salife_oxinv.ticketbook',
		},
	},
	['ticket'] = {
		label = 'Ticket',
		weight = 5,
		stack = false,
		client = {
			export = 'salife_oxinv.ticket',
		}
	},
	['document'] = {
		label = 'Document',
		weight = 2,
		stack = true,
		consume = false,
		client = {
			export = 'salife_oxinv.document',
		},
		buttons = {
			{
				label = 'Print',
				action = function(slot)
					exports.salife_oxinv:documentPrint(slot)
				end
			},
		}
	},
	['rollingpaper'] = {
		label = 'Rolling Paper',
		weight = 200.0,
		description = "",
	},
	['tv'] = {
		label = 'TV',
		weight = 10000,
		stack = false,
	},
	['gameconsole'] = {
		label = 'Game Console',
		weight = 2000,
		stack = false,
	},
	['sharpie'] = {
		label = "Sharpie",
		weight = 100,
		stack = false,
		decay = true,
		consume = 0.25,
	},

	['emptytank'] = {
		label = "Empty Tank",
		weight = 5000,
		stack = true,
	},

	['seatbelt'] = {
		label = "Seat Belt",
		weight = 200,
		stack = true,
	},

	['scrapmetal'] = {
		label = "Scrap Metal",
		weight = 500,
		stack = true,
	},

	['setoftools'] = {
		label = "Empty Tank",
		weight = 1000,
		stack = true,
	},

	['cleaningrag'] = {
		label = "Clean Shop Rag",
		weight = 100,
		stack = true,
	},

	['toolbox'] = {
		label = "Tool Box",
		weight = 1250,
		stack = true,
	},

	['repairparts'] = {
		label = "Repair Parts",
		weight = 200,
		stack = true,
	},

	['outfit'] = {
		label = "Outfit",
		weight = 1000,
		stack = false,
		consume = 0,
		buttons = {
			{
				label = 'Overwrite',
				action = function(slot)
					lib.callback('salife_oxinv.outfit:overwrite', false, function()
					end, slot)
				end
			},
		},
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			disable = { move = true, car = true, combat = true },
			usetime = 10000,
			export = 'salife_oxinv.outfit',
			add = function(total)

			end,

			remove = function(total)
				--exports.salife_oxinv:clothingCheck()
			end,
		},
	},
	['milk'] = {
		label = 'Milk Carton',
		weight = 100.0,
		description = "It's a cardboard box filled with milk. Used for cooking.",
	},

	-- banana

	['espresso'] = {
		label = 'Espresso Beans',
		weight = 100.0,
		description = "It's a mylar bag filled with high quality beans. Used for cooking.",
	},

	['wchocolate'] = {
		label = 'White Chocolate',
		weight = 100.0,
		description = "A magic satchel of white chocolatey goodness.",
	},

	['cottoncandy'] = {
		label = 'Cotton Candy',
		weight = 100.0,
		description = "Give in to your inner child with a delicious stick of sugar.",
	},

	['smoothie'] = {
		label = 'Smoothie',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { thirst = 100, hunger = 100 },
			anim = 'sipshake',
			prop = 'mintmilkshake',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You drank a Smoothie',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['americano'] = {
		label = 'Americano',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { thirst = 100 },
			anim = 'junkdrink',
			prop = 'americano',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You drank an Americano',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['cappuccino'] = {
		label = 'Cappuccino',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { thirst = 100 },
			anim = 'bottlesip',
			prop = 'cappuccino',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You drank a Cappuccino',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['latte'] = {
		label = 'Latte',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { thirst = 100 },
			anim = 'frappe',
			prop = 'frappe2',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You drank a Latte',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['brevecoffee'] = {
		label = 'Breve Coffee',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { thirst = 100 },
			anim = 'bottlesip',
			prop = 'cappuccino',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You drank a Breve Coffee',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['mocha'] = {
		label = 'Mocha',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { thirst = 100 },
			anim = 'sipshake',
			prop = 'doublechocshake',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You drank a Mocha',
			export = 'salife_oxinv.EatBuffFood'
		}
	},


	['boba'] = {
		label = 'Boba Tea',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { thirst = 100 },
			anim = 'holdmilkdchoc',
			prop = 'doublechocshakehold',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You drank a Boba Tea',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['coldbrew'] = {
		label = 'Cold Brew',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { thirst = 100 },
			anim = 'junkdrink',
			prop = 'americano',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You drank a Cold Brew',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['pumpkinfrap'] = {
		label = 'Pumpkin Spice Frappuccino',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { thirst = 100 },
			anim = 'frappe',
			prop = 'frappe4',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You drank a Pumpkin Spice Frappucino',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['hotcoco'] = {
		label = 'Hot Chocolate',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { thirst = 100 },
			anim = 'holdcoffee',
			prop = 'xmascocoa',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You drank a Hot Chocolate',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['candycoffee'] = {
		label = 'Cotton Candy Coffee',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { thirst = 100 },
			anim = 'sipshake',
			prop = 'bubblegumshake',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You drank a Cotton Candy Coffee',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['cataroon'] = {
		label = 'Macaroon',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { hunger = 100 },
			anim = 'eating2',
			prop = 'macaroon',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You ate a macaroon',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['bentobox'] = {
		label = 'Bento Box',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { hunger = 100 },
			anim = 'eating2',
			prop = 'smores',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You ate an entire bento box.',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['hanamidango'] = {
		label = 'Cat Kebab',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { hunger = 100 },
			anim = 'eating2',
			prop = 'smores',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You ate an entire cat kebab.',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['catcake'] = {
		label = 'Coffee Cake',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { hunger = 100 },
			anim = 'eating2',
			prop = 'xmascc',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You ate an entire coffee cake.',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['chili'] = {
		label = 'Chili',
		weight = 100.0,
		description = "For use in cooking.",
	},

	['spice'] = {
		label = 'Spice',
		weight = 100.0,
		description = "Spices for use in cooking.",
	},

	['mayo'] = {
		label = 'Mayonnaise',
		weight = 100.0,
		description = "Condiment for use in cooking.",
	},

	['creamcheese'] = {
		label = 'Cream Cheese',
		weight = 100.0,
		degrage = (60 * 24) * 2,
		description = "Condiment for use in cooking.",
	},

	['spicymayo'] = {
		label = 'Spicy Mayo',
		weight = 100.0,
		description = "Condiment for use in cooking.",
	},

	['seaweed'] = {
		label = 'Seaweed',
		weight = 100.0,
		description = "Green leafy sea garbage.",
	},

	['steamedrice'] = {
		label = 'Rice',
		weight = 100.0,
		description = "Ingredient for use in cooking.",
	},

	['sushiroll'] = {
		label = 'Sushi Roll',
		weight = 100.0,
		description = "Ingredient for use in cooking.",
	},

	['eggs'] = {
		label = 'Eggs',
		weight = 1000.0,
		description = 'Bunch of eggs. Used for cooking.'
	},

	['meat'] = {
		label = 'Meat',
		weight = 1000.0,
		description = 'Mystery meat. Used for cooking.'
	},

	['crop_tomato'] = {
		label = 'Tomato',
		weight = 200.0,
		description = "crop",
	},
	['crop_orange'] = {
		label = 'Orange',
		weight = 200.0,
		description = "crop",
	},
	['crop_oak'] = {
		label = 'Oak Wood',
		weight = 1000.0,
		description = "crop",
	},
	['crop_tobacco'] = {
		label = 'Tobacco',
		weight = 200.0,
		description = "crop",
	},
	['crop_cotton'] = {
		label = 'Cotton',
		weight = 200.0,
		description = "crop",
	},
	['crop_blueberry'] = {
		label = 'Blueberry',
		weight = 200.0,
		description = "crop",
	},
	['crop_banana'] = {
		label = 'Banana',
		weight = 200.0,
		description = "crop",
	},
	['crop_lemon'] = {
		label = 'Lemon',
		weight = 200.0,
		description = "crop",
	},
	['crop_almond'] = {
		label = 'Almond',
		weight = 200.0,
		description = "crop",
	},
	['crop_sunflower'] = {
		label = 'Sunflower',
		weight = 200.0,
		description = "crop",
	},
	['crop_poppy'] = {
		label = 'Poppy',
		weight = 200.0,
		description = "crop",
	},
	['crop_orchid'] = {
		label = 'Orchid',
		weight = 200.0,
		description = "crop",
	},
	['crop_rose'] = {
		label = 'Rose',
		weight = 200.0,
		description = "crop",
	},
	['crop_cucumber'] = {
		label = 'Cucumber',
		weight = 200.0,
		description = "crop",
	},
	['crop_strawberry'] = {
		label = 'Strawberry',
		weight = 200.0,
		description = "crop",
	},
	['crop_corn'] = {
		label = 'Corn',
		weight = 200.0,
		description = "crop",
	},
	['crop_pumpkin'] = {
		label = 'Pumpkin',
		weight = 200.0,
		description = "crop",
	},
	['crop_aloe'] = {
		label = 'Aloe',
		weight = 200.0,
		description = "crop",
	},
	['crop_lettuce'] = {
		label = 'Lettuce',
		weight = 200.0,
		description = "crop",
	},
	['crop_potato'] = {
		label = 'Potato',
		weight = 200.0,
		description = "crop",
	},
	['crop_carrot'] = {
		label = 'Carrot',
		weight = 200.0,
		description = "crop",
	},
	['crop_wheat'] = {
		label = 'Wheat',
		weight = 200.0,
		description = "crop",
	},
	['crop_apple'] = {
		label = 'Apple',
		weight = 200.0,
		description = "crop",
	},
	['crop_rice'] = {
		label = 'Raw Rice',
		weight = 100.0,
		description = "crop",
	},
	['crop_avocado'] = {
		label = 'Avocado',
		weight = 100.0,
		description = "crop",
	},
	['crop_grapered'] = {
		label = 'Grape (Red)',
		weight = 100.0,
		description = "crop",
	},
	['crop_grapewhite'] = {
		label = 'Grape (White)',
		weight = 100.0,
		description = "crop",
	},

	['glassbottle'] = {
		label = 'Glass Bottle',
		weight = 500.0,
		description = "huh... nothing left",
	},

	['wine'] = {
		label = 'Wine',
		weight = 1000.0,
		client = {
			export = 'salife_oxinv.wine'
		}
	},

	['pizzaspice'] = {
		label = 'Pizza Spice',
		weight = 100.0,
		description = "Spices for use in cooking.",
	},

	['dough'] = {
		label = 'Dough',
		weight = 1000,
		stack = true,
		degrade = (60 * 24) * 7
	},

	['pizzasauce'] = {
		label = 'Pizza Sauce',
		weight = 500,
		stack = true,
		degrade = (60 * 24) * 2
	},

	['cheese'] = {
		label = 'Cheese',
		weight = 250,
		stack = true,
		degrade = (60 * 24) * 2
	},

	['rawwholepizza'] = {
		label = 'Raw Large Pizza',
		weight = 1500,
		stack = true,
		degrade = (60 * 24) * 2
	},


	['wholepizza'] = {
		label = 'Large Pizza',
		weight = 1000,
		stack = true,
		degrade = (60 * 24) * 2
	},


	['cola2'] = {
		label = 'XL Big Gulp',
		weight = 1000.0,
		description = "A giant liter of cola",
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { thirst = 100 },
			anim = 'sodacupsip',
			prop = 'ecolasodacup',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You drank a big gulp',
			export = 'salife_oxinv.EatBuffFood'
		}
	},


	['sushi'] = {
		label = 'Sushi',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { hunger = 100 },
			anim = 'eating2',
			prop = 'sushi',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You ate a sushi',
			export = 'salife_oxinv.EatBuffFood'
		}
	},


	['greentea'] = {
		label = 'Green Tea',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { thirst = 100 },
			anim = 'bottlesip',
			prop = 'edrinkbottle',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You drank a green tea',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['pizza'] = {
		label = 'Slice of Pizza',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { hunger = 100 },
			anim = 'eating',
			prop = 'pizzaslice',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You ate a slice of Pizza',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['miso'] = {
		label = 'Miso Soup',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		consume = 0,
		client = {
			export = 'salife_oxinv.miso'
		}
	},

	['bburger'] = {
		label = 'Bames Burger',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { hunger = 100 },
			anim = 'eating',
			prop = 'burger',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You ate food from Bacon Burger',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['pie'] = {
		label = 'Pie',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			status = { hunger = 100 },
			anim = 'eating',
			prop = 'burger',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You ate a Pie',
			export = 'salife_oxinv.EatBuffFood'
		}
	},

	['junk'] = {
		label = 'Junk Energy',
		description = 'A Can of Junk Energy juice.',
		weight = 440,
		degrade = (60 * 24) * 3,
		decay = true,
		allowArmed = false,
		client = {
			anim = 'junkdrink',
			prop = 'junkcan',
			cancel = true,
			disable = {
				move = false,
				car = false,
				combat = true,
				mouse = false,
			},
			usetime = 10000,
			notification = 'You drank a can of Junk Energy',
			export = 'salife_oxinv.EatBuffFood',
		}
	},

	['wiringkit'] = {
		label = "Wiring Kit",
		weight = 100,
		stack = true,
	},

	['fiberglass'] = {
		label = "Fiberglass",
		weight = 100,
		stack = true,
	},

	['encryptedusb'] = {
		label = "Encrypted USB",
		weight = 100,
		stack = false,
	},

	['thermite'] = {
		label = "Thermite",
		weight = 1250,
		stack = false,
	},


	['racingtablet'] = {
		label = 'Racing tablet',
		weight = 500,
		description = 'Seems like something to do with cars.',
		stack = false,
		client = {
			anim = { dict = 'amb@code_human_in_bus_passenger_idles@female@tablet@idle_a', clip = 'idle_a' },
			export = 'rahe-racing.racingtablet',
			prop = { model = `prop_cs_tablet`, pos = vec3(-0.05, 0.00, 0.00), rot = vec3(0.0, 0.0, 0.0) },
		}
	},

	['boostingtablet'] = {
		label = 'Tablet',
		weight = 0,
		description = "Seems like something's installed on this.",
		client = {
			anim = { dict = 'amb@code_human_in_bus_passenger_idles@female@tablet@idle_a', clip = 'idle_a' },
			export = 'rahe-boosting.boostingtablet',
			prop = { model = `prop_cs_tablet`, pos = vec3(-0.05, 0.00, 0.00), rot = vec3(0.0, 0.0, 0.0) },
		}
	},
	['hackingdevice'] = {
		label = 'Hacking device',
		weight = 100,
		description = 'Will allow you to bypass vehicle security systems.',
		client = {
			export = 'rahe-boosting.hackingdevice',
		}
	},
	['gpshackingdevice'] = {
		label = 'GPS hacking device',
		weight = 100,
		description = 'If you wish to disable vehicle GPS systems.',
		client = {
			export = 'rahe-boosting.gpshackingdevice',
		}
	},

	['seedpacket'] = {
		label = "Seed Packet",
		weight = 300,
		stack = true,
		consume = 0,
		client = {
			export = 'salife-farming99.seedpacket',
			usetime = 1000,
		},
		server = {
			--export = 'salife-farming99.seedpacket',
		}
	},

	['skeletonkey'] = {
		label = "Skeleton Key",
		weight = 1000,
		stack = true,
	},

	['weaponparts'] = {
		label = "Weapon Parts",
		weight = 1000,
		stack = true,
	},

	['carkey'] = {
		label = "Car Key",
		weight = 10,
		buttons = {
			{
				label = 'Clone Key',
				action = function(slot)
					lib.callback('salife_oxinv.carkey:clone', false, function()
					end, slot)
				end
			},
		}
	},

	['housekey'] = {
		label = "House Key",
		weight = 10,
		metadata = {
			image = 'carkey',
		}
	},

	['leasekey'] = {
		label = "Lease Car Key",
		weight = 10,
		degrade = (60 * 24) * 3,
		decay = true,
		metadata = {
			image = "carkey",
		},
		buttons = {
			{
				label = 'Clone Lease Key',
				action = function(slot)
					lib.callback('salife_oxinv.leasekey:clone', false, function()
					end, slot)
				end
			},
		}
	},

	['keyblank'] = {
		label = "Key Blank",
		weight = 12,
	},


	['rope'] = {
		label = "Rope",
		weight = 4000,
		consume = 1,
		client = {
			disable = { move = true, car = true, combat = true },
			export = 'salife_oxinv.rope',
			usetime = 2500,
		},
		server = {
			export = 'salife_oxinv.rope',
		},
	},

	['boundped'] = {
		label = "Roped Individual",
		weight = 15000,
		client = {
			export = 'salife_oxinv.boundped',
		},
	},

	['hedgeclippers'] = {
		label = "Hedge Clippers",
		weight = 3000,
		consume = false,
		client = {
			disable = { move = true, car = true, combat = true },
			export = 'salife_oxinv.hedgeclippers',
		},
	},


	['seed_indica'] = {
		label = 'Marijuana Seed Packet',
		weight = 1000,
		description = "Weed seeds?",
	},


	['pot'] = {
		label = 'Pot',
		weight = 3000,
		description = "Wonder what this for?",
		client = {
			cancel = true,
			usetime = 10000,
			disable = { move = true, car = true, combat = true },
			export = 'salife_newweed.pot',
		}
	},

	['fertilizer'] = {
		label = 'Fertilizer',
		weight = 1000,
		description = "Weed seed.",
	},

	['blueprint'] = {
		label = "Blueprint",
		weight = 2,
		degrade = (60 * 24) * 3,
		decay = true,
		metadata = {
			blank = true,
		},
		description = '### Blueprint Blank',
		consume = 0,
		client = {
			disable = { move = true, car = true, combat = true, mouse = false },
			add = function(total)
				exports.salife_oxinv:addBlueprint(total)
			end,
			remove = function(total)

			end,
			export = 'salife_oxinv.blueprint'
		},
		buttons = {
			{
				label = 'Craft',
				action = function(slot)
					exports.salife_oxinv:craft(slot)
				end
			},
			{
				label = 'Craft w/ Custom Image',
				action = function(slot)
					exports.salife_oxinv:craft(slot, true)
				end
			},
		}
	},

	['goldbar'] = {
		label = "Gold Bar",
		weight = 1000,
		description = 'Pure Gold',
		stack = true,
	},

	['goldnugget'] = {
		label = "Gold Nugget",
		weight = 1,
		description = 'Pure Gold',
		stack = false,
	},

	['clothingslot'] = {
		label = 'Clothing Slot',
		consume = false,
		weight = 0,
		stack = false,
	},

	['clothing'] = {
		label = 'Clothing',
		consume = 0.01,
		stack = false,
		client = {
			--[[anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			disable = { move = true, car = true, combat = true },
			usetime = 1000,]]
			export = 'salife_oxinv.clothing',
			add = function(total)

			end,

			remove = function(total)
				exports.salife_oxinv:clothingCheck()
			end,
		},

	},

	['policekey'] = {
		label = 'Police Keys',
		weight = 35.0,
		stack = false,
		client = {
			cancel = true,
			disable = { move = true, car = true, combat = true },
			usetime = 30000,
			export = 'salife_houserobbery.policekey'
		},
	},

	['c4'] = {
		label = 'C4',
		weight = 567.0,
		description = "Looks pretty fuckin sketchy",
		stack = false,
		client = {
			cancel = true,
			anim = { dict = "amb@world_human_bum_wash@male@low@idle_a", clip = "idle_a" },
			disable = { move = true, car = true, combat = true },
			usetime = 30000,
			export = 'salife_houserobbery.c4'
		},
	},

	['goldpan'] = {
		label = "Gold Pan",
		weight = 2500,
		description = 'Use this with ores at the gold panning spot in the river to look for gold',
		consume = 0.01,
		stack = false,
		client = {
			cancel = true,
			anim = { dict = "amb@world_human_bum_wash@male@low@idle_a", clip = "idle_a" },
			disable = { move = true, car = true, combat = true },
			usetime = 1000,
			export = 'salife_oxinv.goldpan'
		},
		server = {
			export = 'salife_oxinv.goldpan'
		},
		buttons = {
			{
				label = 'GPS to the River',
				action = function(slot)
					SetNewWaypoint(-1522.1010742188, 1496.9406738281);
				end
			}
		},
		crafting = {
			['ironore'] = 5,
			['aluminium'] = 5,
			['copperore'] = 3
		},
		blueprintcrafts = 5,
	},
	['harness'] = {
		label = "Harness",
		weight = 100,
		description = 'Gotta go fast',
		allowArmed = false,
		stack = false,
		consume = 0.01,
		client = {
			export = 'ps-hud.harness',
		},
	},
	['nos'] = {
		label = "NOS",
		weight = 3500,
		description = 'Gotta go fast',
		allowArmed = false,
		stack = false,
		consume = 0,
		metadata = {
			durability = 100
		},
	},
	['rustyshovel'] = {
		label = "Rusty Pickaxe",
		weight = 3500,
		consume = 0.05,
		allowArmed = false,
		stack = false,
	},
	['shovel'] = {
		label = "Shovel",
		weight = 3500,
		consume = 0.05,
		allowArmed = false,
		stack = false,
		decay = true
	},
	['rustypickaxe'] = {
		label = "Pickaxe (Rusty)",
		weight = 3500,
		description = 'Use this in the quarry to mine, right-click to learn more.',
		consume = 0,
		allowArmed = false,
		stack = false,
		metadata = { image = "pickaxe" },
		client = {
			cancel = false,
			anim = { dict = "amb@world_human_bum_wash@male@low@idle_a", clip = "idle_a" },
			disable = { move = true, car = true, combat = true },
			usetime = 15000,
			export = 'salife-mining2.rustypickaxe'
		},
		buttons = {
			{
				label = 'GPS to the Quarry',
				action = function(slot)
					SetNewWaypoint(2948.0703125, 2784.7912597656);
				end
			},
			{
				label = 'Better pickaxe?',
				action = function(slot)
					lib.defaultNotify({
						title = 'Crafting',
						description = 'Obtain a better pickaxe through crafting',
						status = 'success'
					})
				end
			}
		},
	},
	['pickaxe'] = {
		label = "Pickaxe",
		weight = 2500,
		description = 'Use this in the quarry to mine',
		consume = 0,
		allowArmed = false,
		stack = false,
		client = {
			cancel = false,
			anim = { dict = "amb@world_human_bum_wash@male@low@idle_a", clip = "idle_a" },
			disable = { move = true, car = true, combat = true },
			usetime = 5000,
			export = 'salife-mining2.pickaxe'
		},
		buttons = {
			{
				label = 'GPS to the Quarry',
				action = function(slot)
					SetNewWaypoint(2948.0703125, 2784.7912597656);
				end
			}
		},
	},

	['pickaxe2'] = {
		label = "Jackhammer",
		weight = 2500,
		description = 'Use this in the quarry to mine',
		consume = 0,
		allowArmed = false,
		stack = false,
		client = {
			cancel = false,
			anim = { dict = "amb@world_human_bum_wash@male@low@idle_a", clip = "idle_a" },
			disable = { move = true, car = true, combat = true },
			usetime = 500,
			export = 'salife-mining2.pickaxe2'
		},
		buttons = {
			{
				label = 'GPS to the Quarry',
				action = function(slot)
					SetNewWaypoint(2948.0703125, 2784.7912597656);
				end
			}
		},
	},


	['pickaxe3'] = {
		label = "Jackhammer T2",
		weight = 2500,
		description = 'Use this in the quarry to mine',
		consume = 0,
		allowArmed = false,
		stack = false,
		client = {
			image = "pickaxe2.png",
			cancel = false,
			anim = { dict = "amb@world_human_bum_wash@male@low@idle_a", clip = "idle_a" },
			disable = { move = true, car = true, combat = true },
			usetime = 500,
			export = 'salife-mining2.pickaxe3'
		},
		buttons = {
			{
				label = 'GPS to the Quarry',
				action = function(slot)
					SetNewWaypoint(2948.0703125, 2784.7912597656);
				end
			}
		},
	},

	['testburger'] = {
		label = 'Test Burger',
		weight = 220,
		degrade = 60,
		client = {
			image = 'burger_chicken.png',
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
					--print('You licked the burger')
				end
			},
			{
				label = 'Squeeze it',
				action = function(slot)
					--print('You squeezed the burger :(')
				end
			}
		}
	},

	['dmoney'] = {
		label = 'Dirty Dollars',
		weight = 1,
		decay = true,
		degrade = (60 * 24) * 5
	},

	['bmoney'] = {
		label = 'Bank Money',
		weight = 0.1,
	},

	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		consume = 1,
		client = {
			export = 'salife_oxinv.bandage',
		},
	},


	['burrito'] = {
		label = 'Burrito',
		degrade = (60 * 24) * 3,
		decay = true,
		weight = 100.0,
		description = "Flour tortilla wrapped around questionable looking meat, lettuce, and cheese.",
		client = {
			status = { hunger = 100 },
			anim = 'eating',
			prop = {
				model = `prop_taco_01`,
				pos = vec3(-0.0170, 0.0070, -0.0210),
				rot = vec3(107.9846, -105.0251, 55.7779)
			},
			usetime = 2500,
			notification = 'You ate a delicious burrito'
		},
	},

	['burger'] = {
		label = 'Burger',
		weight = 220,
		degrade = (60 * 24) * 3,
		decay = true,
		client = {
			status = { hunger = 100 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'You ate a delicious burger'
		},
	},

	['lunchable'] = {
		label = 'Lunchable',
		weight = 440,
		decay = true,
		degrade = (60 * 24) * 3,
		client = {
			status = { hunger = 40 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'You ate a Lunchable'
		}
	},

	['cheezit'] = {
		label = 'Cheeze It',
		weight = 440,
		decay = true,
		degrade = (60 * 24) * 3,
		client = {
			status = { hunger = 15 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'You ate some Cheez Itz'
		}
	},

	['pringles'] = {
		label = 'Pringles',
		weight = 440,
		decay = true,
		degrade = (60 * 24) * 3,
		client = {
			status = { hunger = 10 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'You ate some Pringles'
		}
	},

	['earthquakes'] = {
		label = 'EarthQuakes',
		weight = 150,
		decay = true,
		degrade = (60 * 24) * 3,
		client = {
			status = { hunger = 10 },
			anim = 'eating',
			prop = 'egobar',
			usetime = 1200,
			notification = 'You ate a EarthQuakes Bar'
		}
	},

	['meteorite'] = {
		label = 'Meteorite',
		weight = 150,
		degrade = (60 * 24) * 3,
		decay = true,
		client = {
			status = { hunger = 10 },
			anim = 'eating',
			prop = 'egobar',
			usetime = 1200,
			notification = 'You ate a Meteorite Bar'
		}
	},

	['egochaser'] = {
		label = 'Ego Chaser',
		weight = 150,
		degrade = (60 * 24) * 3,
		decay = true,
		client = {
			status = { hunger = 10 },
			anim = 'eating',
			prop = 'egobar',
			usetime = 1200,
			notification = 'You ate a Ego Chaser Bar'
		}
	},

	['zebrabar'] = {
		label = 'Zebrabar',
		weight = 150,
		degrade = (60 * 24) * 3,
		decay = true,
		client = {
			status = { hunger = 10 },
			anim = 'eating',
			prop = 'egobar',
			usetime = 1200,
			notification = 'You ate a Zebrabar'
		}
	},

	['p&q'] = {
		label = 'Ps & Qs Candy',
		weight = 100,
		degrade = (60 * 24) * 3,
		decay = true,
		client = {
			status = { hunger = 10 },
			anim = 'eating',
			prop = 'candy',
			usetime = 1200,
			notification = 'You ate Ps & Qs fruity candy'
		}
	},

	['phatbigcheese'] = {
		label = 'Phat Chips Big Cheese',
		weight = 100,
		degrade = 120,
		client = {
			status = { hunger = 10 },
			anim = 'eating',
			usetime = 1200,
			notification = 'You ate a bag of Phat Chips'
		}
	},

	['phatstickyribs'] = {
		label = 'Phat Chips Sticky Ribs',
		weight = 100,
		degrade = 120,
		client = {
			status = { hunger = 10 },
			anim = 'eating',
			usetime = 1200,
			notification = 'You ate a bag of Phat Chips'
		}
	},

	['phatsupersalt'] = {
		label = 'Phat Chips Supersalt',
		weight = 100,
		degrade = 120,
		client = {
			status = { hunger = 10 },
			anim = 'eating',
			usetime = 1200,
			notification = 'You ate a bag of Phat Chips'
		}
	},

	['phatcrinkle'] = {
		label = 'Phat Chips Crinkle',
		weight = 100,
		degrade = 120,
		client = {
			status = { hunger = 10 },
			anim = 'eating',
			usetime = 1200,
			notification = 'You ate a bag of Phat Chips'
		}
	},

	['noodleschicken'] = {
		label = 'Noodles Chicken',
		weight = 100,
		degrade = (60 * 24) * 3,
		decay = true,
		client = {
			status = { hunger = 10 },
			anim = 'eating',
			usetime = 1200,
			notification = 'You ate a thing of Noodles'
		}
	},

	['rustydonut'] = {
		label = 'Rusty Browns Donut',
		weight = 100,
		degrade = 30,
		client = {
			status = { hunger = 10 },
			anim = 'eating',
			usetime = 1200,
			notification = 'You ate a stale donut'
		}
	},

	['cola'] = {
		label = 'Cola',
		weight = 350,
		client = {
			status = { thirst = 20 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_can_01`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'You quenched your thirst with a sprunk'
		}
	},

	['caprisun'] = {
		label = 'caprisun',
		weight = 350,
		client = {
			status = { thirst = 20 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ecola_can`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'You drank a caprisun'
		}
	},

	['scratch_50a'] = {
		label = 'Mini Zillions Scratcher',
		weight = 20,
		description = "Tickets for cheapskates",
		client = {
			export = "salife_oxinv.scratch_50a",
			notification = 'Mini zillions!'
		}
	},

	['handcuff'] = {
		label = 'Hand Cuffs',
		weight = 250.0,
		description = "Police issued",
		consume = 0,
		client = {
			usetime = 500,
			disable = { move = true, car = true, combat = true },
			export = "salife_oxinv.handcuff"
		},
	},

	['cuffkey'] = {
		label = 'Cuff Keys',
		weight = 250.0,
		description = "Keys to some cuffs",
		consume = 0,
		client = {
			usetime = 1500,
			disable = { move = true, car = true, combat = true },
			export = "salife_oxinv.cuffkey"
		},
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

	['compactsaw'] = {
		label = 'Compact Saw',
		weight = 4000.0,
		description = "Used to salvage old stuff",
		allowArmed = false,
		consume = 0,
		stack = true,
	},

	['sparetire'] = {
		label = 'Spare Tire',
		weight = 1000,
		consume = 1,
		stack = true,
		allowArmed = false,
		close = true,
		client = {
			anim = { dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', clip = 'machinic_loop_mechandplayer' },
			prop = {
				model = `prop_wheel_tyre`,
				pos = vec3(-0.05, 0.16, 0.32),
				rot = vec3(-130.0, -55.0, 150.0)
			},
			disable = { move = true, car = true, combat = true },
			usetime = 30000,
			cancel = true,
			export = 'salife_oxinv.sparetire'
		},
	},

	['repairkit'] = {
		label = 'Repair Kit',
		weight = 3000,
		--degrade = 2880,
		consume = 1,
		allowArmed = false,
		client = {
			anim = { dict = 'mp_intro_seq@', clip = 'mp_mech_fix' },
			disable = { move = true, car = true, combat = true },
			usetime = 30000,
			cancel = true,
			export = 'salife_oxinv.repairkit'
		},
	},

	['advancedrepairkit'] = {
		label = 'Advanced Repair Kit',
		weight = 3500,
		--degrade = 3880,
		allowArmed = false,
		consume = 1,
		client = {
			anim = { dict = 'mp_intro_seq@', clip = 'mp_mech_fix' },
			disable = { move = true, car = true, combat = true },
			usetime = 60000,
			cancel = true,
			export = 'salife_oxinv.advancedrepairkit'
		},
	},

	['bwrapper'] = {
		label = 'Bandage Wrapper',
		weight = 1,
		stack = true,
	},

	['paperbag'] = {
		label = 'Paper Bag',
		weight = 1,
		stack = false,
		close = false,
		consume = 0
	},
	['largebag'] = {
		label = 'Large Duffle Bag',
		weight = 220,
		stack = false,
		consume = 0,
		client = {
			--[[add = function(total)
				if total > 0 then
					SetPedComponentVariation(cache.ped, 5, 82, 0, 0);
				end
			end,

			remove = function(total)
				if total < 1 then
					SetPedComponentVariation(cache.ped, 5, 0, 0, 0);
				end
			end]]
		}
	},

	['secureweaponscase'] = {
		label = 'Secure Weapons Case',
		weight = 1000,
		stack = false,
		consume = 0,
		client = {
			export = 'salife_oxinv.secureweaponscase'
		}
	},

	['clothingbag'] = {
		label = 'Clothing Bag',
		weight = 220,
		stack = false,
		consume = 0,
		metadata = {
			image = 'largebag'
		},
		client = {
			--[[add = function(total)
				if total > 0 then
					SetPedComponentVariation(cache.ped, 5, 82, 0, 0);
				end
			end,

			remove = function(total)
				if total < 1 then
					SetPedComponentVariation(cache.ped, 5, 0, 0, 0);
				end
			end]]
		}
	},

	['keychain'] = {
		label = 'Key Chain',
		weight = 1,
		stack = false,
	},

	['ammobox'] = {
		label = 'Ammo Box',
		weight = 510,
		stack = false,
		close = false,
		consume = 0
	},

	['identification'] = {
		label = 'Identification',
		consume = 0,
		client = {
			anim = { dict = 'mp_common', clip = 'givetake1_a' },
			usetime = 5000,
			export = 'salife_oxinv.identification'
		}
	},

	['votingpin'] = {
		label = 'Voted Pin',
		description = 'A pin that shows you voted in an election.',
		weight = 10,
		image = 'votepin_6_25_23'
	},

	['panties'] = {
		label = 'Dirty Panties',
		weight = 10,
		consume = 0,
		client = {
			status = { thirst = -1 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
			usetime = 2500,
		}
	},

	['lockpick'] = {
		label = 'Lockpick',
		weight = 160,
		consume = 0,
	},

	['advancedlockpick'] = {
		label = 'Advanced Lockpick',
		weight = 160,
		consume = 0,
		server = {
			export = "sf-houserobbery.useLockpick"
		}
	},

	["hr_toaster"] = {
		label = "Toaster",
		weight = 900,
		stack = true
	},
	["hr_toaster2"] = {
		label = "Toaster",
		weight = 900,
		stack = true
	},
	["hr_microwave"] = {
		label = "Microwave",
		weight = 1500,
		stack = true
	},
	["hr_microwave2"] = {
		label = "Microwave",
		weight = 1500,
		stack = true
	},
	["hr_boombox"] = {
		label = "Boombox",
		weight = 1000,
		stack = true
	},
	["hr_tv3"] = {
		label = "Old TV",
		weight = 3000,
		stack = true
	},
	["hr_flattv3"] = {
		label = "Flat TV",
		weight = 2000,
		stack = true
	},
	["hr_console"] = {
		label = "Game console",
		weight = 1200,
		stack = true
	},
	["hr_pan"] = {
		label = "Pan",
		weight = 400,
		stack = true
	},
	["hr_vinyl"] = {
		label = "Vinyl",
		weight = 50,
		stack = true
	},
	["hr_pendrive"] = {
		label = "Pendrive",
		image = "encryptedusb",
		weight = 50,
		stack = true
	},
	["hr_pliers"] = {
		label = "Pliers",
		weight = 250,
		stack = true
	},
	["hr_mixer"] = {
		label = "Mixer",
		weight = 450,
		stack = true
	},
	["hr_headphones"] = {
		label = "Headphones",
		weight = 300,
		stack = true
	},
	["hr_phone"] = {
		label = "Phone",
		weight = 100,
		stack = true
	},
	["hr_coffeemaker"] = {
		label = "Coffee Machine",
		weight = 100,
		stack = true
	},
	["hr_bigtv"] = {
		label = "Big TV",
		weight = 2000,
		stack = true
	},
	["hr_printer"] = {
		label = "Printer",
		weight = 500,
		stack = true
	},
	["hr_telescope"] = {
		label = "Telescope",
		weight = 100,
		stack = true
	},
	["hr_laptop"] = {
		label = "Laptop",
		weight = 100,
		stack = true
	},

	['policebadge'] = {
		label = 'Badge',
		weight = 500,
		stack = false,
		consume = 0,
		server = {
			export = "salife_oxinv.policebadge"
		}
	},

	--[[["usbchargingcable"] = {
		label = "USB Charging Cable",
		weight = 10,
		stack = false,
		consume = 0,
		metadata = {
			durability = 100,
		}
	},]]

	--[[["phone"] = {
		label = "Phone",
		weight = 190,
		stack = false,
		consume = 0,
		client = {
			export = "lb-phone.UsePhoneItem",
			remove = function()
				TriggerEvent("lb-phone:itemRemoved")
			end,
			add = function()
				TriggerEvent("lb-phone:itemAdded")
			end
		}
	},]]
	["megaphone"] = {
		label = "Megaphone",
		weight = 300,
		stack = false,
		consume = 0,
		client = {
			event = 'megaphone:Toggle'
		}
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

	['armour'] = {
		label = 'Concealed Kevlar Vest',
		weight = 10000,
		stack = false,
		consume = 1,
		client = {
			export = 'salife_oxinv.armour',
		}
	},


	['spikes'] = {
		label = 'Spike Strip',
		weight = 5000,
		stack = false,
		client = {
			export = 'salife_spikes.spikes'
		}
	},

	['taser_cartridge'] = {
        label = 'Taser cartridge',
        weight = 250,
        allowArmed = true,
		stack = false,
        client = {
            export = 'SmartTaser.OxUseTaserCart',
        },
	},

	['medkit'] = {
		label = 'Medical Kit',
		weight = 500.0,
		description = "Medical tools to be used by professionals only.",
		client = {
			export = "salife_oxinv.medkit"
		},
		server = {
			export = "salife_oxinv.medkit"
		}
	},


	['jewelry'] = {
		label = 'Jewelry',
		weight = 250,
		client = {
			export = 'salife_oxinv.jewelry'
		}
	},

	['morphine'] = {
		label = 'Morphine Injector',
		weight = 8,
	},

	['field_dressing'] = {
		label = 'Field Dressing',
		weight = 8,
	},

	['packing_bandage'] = {
		label = 'Packing Bandage',
		weight = 8,
	},

	['elastic_bandage'] = {
		label = 'Elastic Bandage',
		weight = 8,
	},

	['quickclot'] = {
		label = 'Field Dressing',
		weight = 250,
		client = {
			export = 'salife_oxinv.quickclot',
		},
	},

	['blood_100'] = {
		label = 'Blood (100ml)',
		weight = 8,
	},
	['blood_250'] = {
		label = 'Blood (250ml)',
		weight = 8,
	},
	['blood_500'] = {
		label = 'Blood (500ml)',
		weight = 8,
	},
	['blood_750'] = {
		label = 'Blood (750ml)',
		weight = 8,
	},
	['blood_1000'] = {
		label = 'Blood (1000ml)',
		weight = 8,
	},
	['epinephrine'] = {
		label = 'Epinephrine',
		weight = 8,
	},
	['emergency_revive_kit'] = {
		label = 'Revive Kit',
		weight = 8,
	},

	['defibrillator'] = {
		label = 'Defibrillator',
		weight = 8,
	},

	['surgical_kit'] = {
		label = 'Surgical Kit',
		weight = 8,
	},

	['tourniquet'] = {
		label = 'Tourniquet',
		weight = 8,
	},

	['ecg_monitor'] = {
		label = 'ECG Monitor',
		weight = 2500,
	},

	['propofol_100'] = {
		label = 'Propfol (100ml)',
		weight = 100,
	},

	['propofol_250'] = {
		label = 'Propfol (250ml)',
		weight = 250,
	},

	['bodybag'] = {
		label = 'Body Bag',
		weight = 250,
	},

	['vault_laptop'] = {
		label = 'Laptop',
		weight = 5000.0,
		description = "",
	},

	['laptopblueprint'] = {
		label = 'Laptop Blueprint',
		weight = 1000.0,
		description = "Maybe for making things",
	},

	['mastercard'] = {
		label = 'Fleeca Card',
		stack = false,
		weight = 10,
		client = {
			image = 'card_bank.png'
		}
	},
	['hard_drive'] = {
		label = 'Hard Drive',
		weight = 10.0,
		description = "Used to build computers",
	},
	['cpu_battery'] = {
		label = 'CPU Battery',
		weight = 10.0,
		description = "Used to build computers",
	},
	['wirestripper'] = {
		label = 'Wire Stripper',
		weight = 100.0,
		description = "Used to strip cables",
		metadata = {
			durability = 100,
		},
	},
	['screwdriver'] = {
		label = 'Screwdriver',
		weight = 100.0,
		description = "Screws screws.",
		metadata = {
			durability = 100,
		},
	},
	['electricalscrap'] = {
		label = 'Electronic Parts',
		weight = 10.0,
		description = "Used to build computers",
	},
	['cpu_processor'] = {
		label = 'CPU Processor',
		weight = 10.0,
		description = "Used to build computers",
	},
	['gfxcard'] = {
		label = 'Graphics Card',
		weight = 10.0,
		description = "Used to build computers",
	},
	['scrap'] = {
		label = 'Scrap',
		weight = 250.0,
		description = "Used to make stuff.",
	},
	['bluetooth'] = {
		label = 'Bluetooth Adapter',
		weight = 1000,
		description = "Bluetooth Adapter.",
	},
	['polyisobutylene'] = {
		label = 'Polyisobutylene',
		weight = 250.0,
		description = "organic polymers",
	},
	['mwater'] = {
		label = 'Mineral Water',
		weight = 500.0,
		description = "",
	},
	['carbinebarrel'] = {
		label = 'Carbine Barrel',
		weight = 2000,
		description = "Carbine Rifle Barrel",
	},
	['cherrypoppers'] = {
		label = 'Cherry Poppers Float',
		weight = 100.0,
		description = "The signature Cherry Poppers Float from Horny's.",
	},
	['invoice_cab'] = {
		label = 'Invoice (cab)',
		weight = 50.0,
		description = "Used to get paid to your account.",
	},
	['invoice_pi'] = {
		label = 'Invoice (pi)',
		weight = 50.0,
		description = "Used to get paid to your account.",
	},
	['ramen'] = {
		label = 'Ramen Noodle',
		weight = 10.0,
		description = "",
	},
	['bong'] = {
		label = 'Glass Bong',
		weight = 1000,
		description = "RooR Straight tube. Borosilicate Glass, Made in Germany",
	},
	['cocaineb'] = {
		label = 'Cocaine',
		weight = 200.0,
		description = "Some cocaine.",
		client = {
			export = 'salife_oxinv.cocaineb'
		}
	},
	['cocainebrick'] = {
		label = 'Cocaine Brick',
		weight = 1000.0,
		description = "Some cocaine.",
	},
	['fwater'] = {
		label = 'Fountain Water',
		weight = 100.0,
		description = "Fountain water.",
	},
	['donut'] = {
		label = 'Donut',
		weight = 100.0,
		description = "Every cops balanced breakfast.",
	},
	['ammonia'] = {
		label = 'Ammonia',
		weight = 2000,
		description = "Mix with bleach",
	},
	['SAlifechargerLB'] = {
		label = '2020 Charger AWD',
		weight = 10.0,
		description = "",
	},
	['braceletmold'] = {
		label = 'Bracelet Mold',
		weight = 500.0,
		description = "",
	},
	['paints'] = {
		label = 'Paints',
		weight = 1000.0,
		description = "Amazing automotive paint.",
	},
	['wings'] = {
		label = 'Wings',
		weight = 100.0,
		description = "Wings that look like they're dipped in sauce but are essentially tasteless.",
	},
	['akframe'] = {
		label = 'AR Frame',
		weight = 3000,
		description = "AR Frame",
	},
	['ring'] = {
		label = 'Rings',
		weight = 10.0,
		description = "Shiny.",
	},
	['smgreceiver'] = {
		label = 'SMG Receiver',
		weight = 2000,
		description = "Submachine Gun Receiver",
	},
	['wheelchair'] = {
		label = 'Electric Wheelchair',
		weight = 7000,
		description = "It's electric",
	},
	['Illegal Vehicle - 60 minutes'] = {
		label = 'IV60',
		weight = 0,
		description = "",
	},
	['cadetaward'] = {
		label = 'cadetaward',
		weight = 0.0,
		description = "",
	},
	['sbsmoothie'] = {
		label = 'Strawberry Banana Smoothie',
		weight = 100.0,
		description = "",
	},
	['kazoo'] = {
		label = 'Kazoo',
		weight = 0,
		description = "Kazooooooooooooooooooooo",
	},
	['wrapper'] = {
		label = 'Wrapper',
		weight = 50.0,
		description = "Nothing left...",
	},
	['perfume'] = {
		label = 'Perfume',
		weight = 500.0,
		description = "dog shit",
	},
	['engineswap_BIKEC_BIKEB'] = {
		label = 'Engine Swap (BIKEC to BIKEB)',
		weight = 10000,
		description = "swap your engines",
	},
	['voucher_cab'] = {
		label = 'Voucher (cab)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['pistolbarrel'] = {
		label = 'Pistol Barrel',
		weight = 2000,
		description = "A Pistol Barrel",
	},
	['voucher_saspcadet'] = {
		label = 'Voucher (saspcadet)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['invoice_hospital'] = {
		label = 'Invoice (hospital)',
		weight = 50.0,
		description = "Used to get paid to your account.",
	},
	['kerosene'] = {
		label = 'Kerosene',
		weight = 100.0,
		description = "Also known as paraffin, lamp oil, and coal oil, is a combustible hydrocarbon liquid.",
	},
	['voucher_8'] = {
		label = 'Voucher (8)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['voucher_vanillaunicorn'] = {
		label = 'Voucher (vanillaunicorn)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['trekkit'] = {
		label = 'Trek Kit',
		weight = 1000,
		description = "Trek Kit.",
	},
	['roach'] = {
		label = 'Roach',
		weight = 5.0,
		description = "The dank.",
	},
	['moz'] = {
		label = 'Mozzarella Sticks',
		weight = 100.0,
		description = "Deep fried cheese.",
	},
	['tendies'] = {
		label = 'Chicken Tendies',
		weight = 100.0,
		description = "Deep friend chicken.",
	},
	['lssdbadge_sergeant'] = {
		label = 'Badge: Sergeant',
		weight = 10.0,
		description = "",
	},
	['pistolmag'] = {
		label = 'Pistol Magazine',
		weight = 2000,
		description = "A Pistol Magazine",
	},
	['engineswap_B_A'] = {
		label = 'Engine Swap (B to A)',
		weight = 10000,
		description = "swap your engines",
	},
	['shake'] = {
		label = 'Jumbo Shake',
		weight = 100.0,
		description = "Extra Creamy Jumbo Shake.",
	},
	['ephedrine'] = {
		label = 'Ephedrine',
		weight = 50.0,
		description = "IT IS THE SYMPTOM",
	},
	['crustywallet'] = {
		label = 'Crusty Wallet',
		weight = 10.0,
		description = "",
	},
	['wallet'] = {
		label = 'Wallet',
		weight = 100.0,
		description = "",
	},
	['packofdice'] = {
		label = 'Pack of Dice',
		weight = 0,
		description = "5 Pack - White Dice.",
	},
	['copperring'] = {
		label = 'Copper Ring',
		weight = 100.0,
		description = "",
	},
	['mattcashgoldenticket'] = {
		label = 'Matt Cash Golden Ticket',
		weight = 10.0,
		description = "",
	},
	['ringmold'] = {
		label = 'Ring Mold',
		weight = 500.0,
		description = "",
	},
	['invoice_weazel'] = {
		label = 'Invoice (weazel)',
		weight = 50.0,
		description = "Used to get paid to your account.",
	},
	['monkfish'] = {
		label = 'Monkfish',
		weight = 500.0,
		description = "",
	},
	['SAlifeimpalaLB'] = {
		label = '2013 Impala',
		weight = 10.0,
		description = "",
	},
	['abottle'] = {
		label = 'Bottle (Alcoholic)',
		weight = 50.0,
		description = "used to be fun.",
	},
	['tayskeys'] = {
		label = 'Tay Car Keys',
		weight = 10.0,
		description = "",
	},
	['essentialoils'] = {
		label = 'Essential Oils',
		weight = 500.0,
		description = "dog shit",
	},
	['carcompzts'] = {
		label = 'Car Computer: ZTS',
		weight = 0,
		description = "will calculate shit",
	},
	['marathon'] = {
		label = 'Marathon Bar',
		weight = 500.0,
		description = "Very strong energy bar.",
	},
	['casings'] = {
		label = 'Shell Casings',
		weight = 50.0,
		description = "Casings to be filled with gunpowder and turned into live ammunition.",
	},
	['starterfluid'] = {
		label = 'Starter Fluid',
		weight = 100.0,
		description = "A volatile, flammable liquid which is used to aid the starting of internal combustion engines.",
	},
	['flower_pot'] = {
		label = 'Flower Pot',
		weight = 4000,
		description = "Flower Pot.",
	},
	['pistolframe'] = {
		label = 'Pistol Frame',
		weight = 2000,
		description = "A pIstol Frame",
	},
	['usedbottle'] = {
		label = 'Sunscreen (Used)',
		weight = 10.0,
		description = "",
	},
	['goldtooth'] = {
		label = 'Gold Tooth',
		weight = 10.0,
		description = "",
	},
	['microsmgframe'] = {
		label = 'MicroSMG Frame',
		weight = 2000,
		description = "A MicroSMG Frame",
	},
	['uccomet'] = {
		label = 'UC Comet',
		weight = 10.0,
		description = "",
	},
	['tobacco'] = {
		label = 'Tobacco',
		weight = 10.0,
		description = "",
	},
	['dmdnb'] = {
		label = 'DMDNB',
		weight = 250.0,
		description = "Volatile organic compound",
	},

	['tortas'] = {
		label = 'Torta',
		weight = 100.0,
		description =
		"A Mexican sandwich spread with butter and topped with refried beans, avocado, spicy peppers, and piled with questionable looking meat and cheese.",
	},
	['meat_pig'] = {
		label = 'Pig Meat',
		weight = 50.0,
		description = "",
	},
	['aluminium'] = {
		label = 'Aluminium',
		weight = 300.0,
		description = "a mineral",
	},
	['breadpiece'] = {
		label = 'Piece of bread',
		weight = 100.0,
		description = "Small chunk of bread, wonder when it went stale.",
	},
	['mexicancock'] = {
		label = 'Mexican Cock',
		weight = 100.0,
		description = "A Lucky Plucker specialty chicken taco.",
	},
	['invoice_weston'] = {
		label = 'Invoice (weston)',
		weight = 50.0,
		description = "Used to get paid to your account.",
	},
	['gunpowder'] = {
		label = 'Gunpowder',
		weight = 50.0,
		description = "A fine gray substance to be packed in a shell casing.",
	},
	['microsmgreceiver'] = {
		label = 'MicroSMG Receiver',
		weight = 2000,
		description = "A MicroSMG Receiver",
	},
	['SAlifef150LB'] = {
		label = '2018 F150',
		weight = 10.0,
		description = "",
	},
	['invoice_vanillaunicorn'] = {
		label = 'Invoice (vanillaunicorn)',
		weight = 50.0,
		description = "Used to get paid to your account.",
	},
	['lspdbadge_detective1'] = {
		label = 'Badge: Detective 1',
		weight = 10.0,
		description = "",
	},
	['crumb'] = {
		label = 'Crumbs',
		weight = 1.0,
		description = "crumbs.",
	},
	['invoice_lsc'] = {
		label = 'Invoice (lsc)',
		weight = 50.0,
		description = "Used to get paid to your account.",
	},
	['invoice_maze'] = {
		label = 'Invoice (maze)',
		weight = 50.0,
		description = "Used to get paid to your account.",
	},
	['meat_deer'] = {
		label = 'Deer Meat',
		weight = 50.0,
		description = "",
	},
	['commendation'] = {
		label = 'Commendation',
		weight = 0.0,
		description = "",
	},
	['breathalyzer'] = {
		label = 'Breathalyzer',
		weight = 1000,
		description = "Used to test individuals",
	},
	['weddingband'] = {
		label = 'Wedding Band',
		weight = 0,
		description = "You feel like you have a serious commitment.",
	},
	['hacking_laptop'] = {
		label = 'Laptop Computer',
		weight = 1500.0,
		description = "Connects to your handheld to increase capabilities",
	},
	['meat_dog'] = {
		label = 'Dog Meat',
		weight = 50.0,
		description = "",
	},
	['slimjimbroken'] = {
		label = 'Broken Slim Jim',
		weight = 0,
		description = "Used to unlock vehicles, sometimes.",
	},
	['scratch_50a_win_50'] = {
		label = 'Small Scratcher - $2500 Winner',
		weight = 0,
		description = "Turn in at city hall for your prize!",
	},
	['aluminiumnecklace'] = {
		label = 'Aluminium Necklace',
		weight = 100.0,
		description = "",
	},
	['SAlifefpiuems'] = {
		label = '2022 FPIU',
		weight = 10.0,
		description = "",
	},
	['bookofstamps'] = {
		label = 'Book of Stamps',
		weight = 0.1,
		description = "It's a stamp. It stamps. Used for currency in prison sometimes.",
	},
	['motherboard'] = {
		label = 'Motherboard',
		weight = 10.0,
		description = "Used to build computers",
	},
	['copperore'] = {
		label = 'Copper',
		weight = 300.0,
		description = "a mineral",
	},
	['truckinfo'] = {
		label = 'Bank Truck Schedule',
		weight = 100.0,
		description = "HMMMM...",
	},
	['moonshine'] = {
		label = 'Moonshine',
		weight = 500.0,
		description = "Very strong alcohol.",
	},
	['lockpickb'] = {
		label = 'Raking Set (Pin-Tumbler & Wafer)',
		weight = 2000,
		description = "Used to rake pin-tumbler locks",
	},
	['drillbit'] = {
		label = 'Drill Bit',
		weight = 200.0,
		description = "A drill bit used with the Power drill",
	},
	['ammunition'] = {
		label = 'rusty ammunition',
		weight = 0,
		description = "Bullets to be sold to Ammunition.",
	},
	['tea'] = {
		label = 'Tea',
		weight = 100.0,
		description = "A cup of tea from one of those crappy tea machines at a gas station.",
	},
	['invoice_8'] = {
		label = 'Invoice (8)',
		weight = 50.0,
		description = "Used to get paid to your account.",
	},
	['clatteom'] = {
		label = 'Caramel Latte w/ Oatmilk',
		weight = 100.0,
		description = "Standard cup o' joe.",
	},
	['carbomb'] = {
		label = 'Car Bomb',
		weight = 0,
		description = "tactically blow up a car",
	},
	['akreceiver'] = {
		label = 'AR Receiver',
		weight = 3000,
		description = "AR Receiver",
	},
	['vacuum'] = {
		label = 'Vacuum',
		weight = 500.0,
		description = "",
	},
	['inkingkit'] = {
		label = 'Dye Packs',
		weight = 0,
		description = "Secure that cash.",
	},
	['yeast'] = {
		label = 'Hydrated Yeast',
		weight = 100.0,
		description = "Hydrated Yeast used in the fermentation process",
	},
	['invoice_sasp'] = {
		label = 'Invoice (sasp)',
		weight = 50.0,
		description = "Used to get paid to your account.",
	},
	['tunacock'] = {
		label = 'Tuna Cock Sandwich',
		weight = 100.0,
		description = "A Lucky Plucker specialty chicken and tuna sandwich.",
	},
	['labtechcleaner'] = {
		label = 'LabTech Cleaner',
		weight = 500.0,
		description = "Specialized cleaner.",
	},
	['hacking_handheld'] = {
		label = 'Handheld Computer',
		weight = 1000,
		description = "A handheld computer with basic capabilities",
	},
	['manure'] = {
		label = 'Manure',
		weight = 50.0,
		description = "Manure",
	},
	['rileysbook'] = {
		label = 'Riley Freeman Skills for Dummies',
		weight = 10.0,
		description = "",
	},
	['coldmedicine'] = {
		label = 'Cold Medicine',
		weight = 150.0,
		description = "Symptoms BE-GONE",
	},
	['cartonofcigarettes'] = {
		label = 'Carton of Cigarettes',
		weight = 0,
		description = "200 Pack - Redwoods.",
		client = {
			export = 'salife-oxinv.cartonofcigarettes'
		}
	},
	['mdetector'] = {
		label = 'Metal Detector',
		weight = 1000,
		description = "Might be able to find something at the beach.",
	},
	['vape'] = {
		label = 'Vape',
		weight = 50.0,
		description = "Rip fat shit. #VapeNation",
	},
	['plateswapper'] = {
		label = 'Plate Swapper',
		weight = 0,
		description = "tactically swap a plate",
	},
	['invoice_dangles'] = {
		label = 'Invoice (dangles)',
		weight = 50.0,
		description = "Used to get paid to your account.",
	},
	['thermoplasticpolymer'] = {
		label = 'Thermoplastic Polymer',
		weight = 1000,
		description = "Plastic Polymer",
	},
	['carbineframe'] = {
		label = 'Carbine Frame',
		weight = 2000,
		description = "Carbine Rifle Frame",
	},
	['edetector'] = {
		label = 'Everything Detector',
		weight = 0,
		description = "Might be able to find something at the beach.",
	},
	['ramensoup'] = {
		label = 'Ramen Soup',
		weight = 200.0,
		description = "You made soup in a can, great job.",
	},
	['pretzels'] = {
		label = 'Pretzels',
		weight = 100.0,
		description = "Bag of Pretzels.",
	},
	['pills'] = {
		label = 'Pills',
		weight = 20.0,
		description = "Just pills.",
		client = {
			export = 'salife_oxinv.pills',
		},
	},
	['nudiemag'] = {
		label = 'Tig ol Bitties Magazine',
		weight = 500.0,
		description = "Some of the pages are stuck together",
	},
	['hornburger'] = {
		label = 'Hornburger',
		weight = 100.0,
		description = "The signature Hornburger from Horny's.",
	},
	['inkedmoney'] = {
		label = 'Inked Money',
		weight = 0,
		description = "",
	},
	['snicker'] = {
		label = 'Snickers Bar',
		weight = 1.0,
		description = "fart",
	},
	['usedcondom'] = {
		label = 'Used Condom',
		weight = 10.0,
		description = "",
	},
	['tension_wrencha'] = {
		label = 'Tension Set (Pin-Tumbler)',
		weight = 3000,
		description = "Used to temsion pin-tumbler locks",
	},
	['brainmatter'] = {
		label = 'Brain Matter',
		weight = 0,
		description = "",
	},
	['casinochip'] = {
		label = 'Casino Chips',
		weight = 0.01,
		description = "Good old fashioned casino chips.",
	},
	['dirtycasinochip'] = {
		label = 'Dirty Casino Chips',
		weight = 0.0125,
		description = "Something is off about these chips.",
	},
	['mechanicgoggles'] = {
		label = 'Vehicle Observer',
		weight = 1000.0,
		description = "",
	},
	['aluminiumring'] = {
		label = 'Aluminium Ring',
		weight = 100.0,
		description = "",
	},
	['limejuice'] = {
		label = 'Lime Juice',
		weight = 500.0,
		description = "I don't think you're supposed to drink this.",
	},
	['diamonds'] = {
		label = 'Diamonds',
		weight = 10.0,
		description = "Shiny.",
	},
	['chocolate'] = {
		label = 'Chocolate',
		weight = 200.0,
		description = "Dark-ass chocolate.",
	},
	['tots'] = {
		label = 'Tater Tots',
		weight = 100.0,
		description = "Aren't these things for kids?",
	},
	['invoice_ttowing'] = {
		label = 'Invoice (ttowing)',
		weight = 50.0,
		description = "Used to get paid to your account.",
	},
	['open_lock'] = {
		label = 'Training Lock (Open)',
		weight = 7000,
		description = "It's a lock for training that is unshackled up.",
	},
	['holywater'] = {
		label = 'Holy Water',
		weight = 500.0,
		description = "dog shit",
	},
	['cigarette'] = {
		label = 'Cigarette',
		weight = 5.0,
		description = "Smoke up.",
	},
	['training_locka'] = {
		label = 'Training Lock',
		weight = 7000,
		description = "It's a lock for training",
	},
	['millionburger'] = {
		label = 'The Million x Heartstopper',
		weight = 100.0,
		description = "This burger may kill you! We can't be held respondsible.",
	},
	['defeces'] = {
		label = 'Deer Feces',
		weight = 50.0,
		description = "",
	},
	['copperbracelet'] = {
		label = 'Copper Bracelet',
		weight = 100.0,
		description = "",
	},
	['molasses'] = {
		label = 'Molasses',
		weight = 500.0,
		description = "Delicious Molasses.",
	},
	['meat_rabbit'] = {
		label = 'Rabbit Meat',
		weight = 50.0,
		description = "",
	},
	['voucher_pi'] = {
		label = 'Voucher (pi)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['invoice_unicorn'] = {
		label = 'Invoice (unicorn)',
		weight = 50.0,
		description = "Used to get paid to your account.",
	},
	['microsmgbarrel'] = {
		label = 'MicroSMG Barrel',
		weight = 2000,
		description = "A MicroSMG Barrel",
	},
	['mobilewardrobe'] = {
		label = 'Clothing Bag',
		weight = 3000.0,
		description = "",
	},
	['goldore'] = {
		label = 'Gold',
		weight = 300.0,
		description = "a mineral",
	},
	['powerdrill'] = {
		label = 'Power Drill',
		weight = 1000,
		description = "Power Drill",
	},
	['acetone'] = {
		label = 'Acetone',
		weight = 2500.0,
		description = "",
	},
	['diethylhexyl'] = {
		label = 'Diethylhexyl',
		weight = 3000,
		description = "A plasticizer",
	},
	['chickenmeal'] = {
		label = '4-Piece Chicken Special',
		weight = 500.0,
		description = "Four pieces of chicken, fries, salad and roll.",
	},
	['safecracker'] = {
		label = 'SAFECRACKER!',
		weight = 10.0,
		description = "",
	},
	['reuben'] = {
		label = 'Reuben',
		weight = 100.0,
		description = "Stale bread with corned beef smacked in the middle.",
	},
	['buildersbook'] = {
		label = 'Builder Guide',
		weight = 100.0,
		description = "learn stuff",
	},
	['engineswap_AB_S'] = {
		label = 'Engine Swap (AB to S)',
		weight = 10000,
		description = "swap your engines",
	},
	['dirtydf'] = {
		label = 'Dirty Diaper',
		weight = 0,
		description = "The onion and shit scent TM.",
	},
	['bottledair'] = {
		label = 'Premium Bottled Air',
		weight = 500.0,
		description = "dog shit",
	},
	['breakfast'] = {
		label = 'Breakfast Special',
		weight = 500.0,
		description = "Three eggs, four slices of bacon, hasbrowns, toast and jelly.",
	},
	['engineswap_E_D'] = {
		label = 'Engine Swap (E to D)',
		weight = 10000,
		description = "swap your engines",
	},
	['crackers'] = {
		label = 'Crackers',
		weight = 100.0,
		description = "Package of crackers.",
	},
	['lspdbadge_officer1'] = {
		label = 'Badge: Officer 1',
		weight = 10.0,
		description = "",
	},
	['voucher_dcasino'] = {
		label = 'Voucher (dcasino)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['sunglasses'] = {
		label = 'Sunglasses',
		weight = 10.0,
		description = "",
	},
	['oxycontin'] = {
		label = 'Oxycontin',
		weight = 20.0,
		description = "Just pills.",
		client = {
			export = 'salife_oxinv.oxy',
		},
	},
	['pistolreceiver'] = {
		label = 'Pistol Magazine',
		weight = 2000,
		description = "A Pistol Magazine",
	},
	['meat_cat'] = {
		label = 'Cat Meat',
		weight = 50.0,
		description = "",
	},
	['weed'] = {
		label = 'Marijuana',
		weight = 200.0,
		description = "The dank.",
	},
	['treasurechest'] = {
		label = 'Treasure Chest',
		weight = 10.0,
		description = "",
	},
	['oil3'] = {
		label = 'Crude Oil (Premium)',
		weight = 2000,
		description = "A naturally occurring, unrefined petroleum product.",
	},
	['slimjim'] = {
		label = 'Slim Jim',
		weight = 1000.0,
		description = "Unlocks vehicles, sometimes.",
	},
	['chilidog'] = {
		label = 'Chili Dog',
		weight = 100.0,
		description = "Hotdog with chili on top.",
	},
	['dirty_mouthpiece'] = {
		label = 'Used Mouthpiece',
		weight = 10.0,
		description = "Used with a breathalyzer",
	},
	['lspdbadge_sergeant2'] = {
		label = 'Badge: Sergeant 2',
		weight = 10.0,
		description = "",
	},
	['turtle'] = {
		label = 'Turtle',
		weight = 500.0,
		description = "",
	},
	['oil4'] = {
		label = 'Crude Oil (Diesel)',
		weight = 2000,
		description = "A naturally occurring, unrefined petroleum product.",
	},
	['respect'] = {
		label = 'Respect',
		weight = 10.0,
		description = "",
	},
	['motelpass'] = {
		label = 'Motel Pass',
		weight = 0.0,
		description = "",
	},
	['sand'] = {
		label = 'Sand',
		weight = 500.0,
		description = "",
	},
	['oxytank'] = {
		label = 'Oxygen Tank',
		weight = 5000.0,
		description = "Might help you breathe.",
	},
	['crackcocaineb'] = {
		label = 'Crack Cocaine',
		weight = 200.0,
		description = "Some crack cocaine.",
		client = {
			export = 'salife_oxinv.crackcocaineb'
		}
	},
	['newcoin'] = {
		label = 'New Coin',
		weight = 10.0,
		description = "",
	},
	['andeepastasvouchers'] = {
		label = 'Andee Pasta Voucher Book',
		weight = 10.0,
		description = "",
	},
	['ucbuffalo'] = {
		label = 'UC Buffalo',
		weight = 10.0,
		description = "",
	},
	['anchovy'] = {
		label = 'Anchovy',
		weight = 500.0,
		description = "",
	},
	['voucher_ammunation'] = {
		label = 'Voucher (ammunation)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['tacos'] = {
		label = 'Taco',
		weight = 100.0,
		description = "Soft-shelled tortilla taco filled with questionable looking meat, lettuce, and cheese.",
	},
	['dentures'] = {
		label = 'Dentures',
		weight = 10.0,
		description = "",
	},
	['scratch_50a_win_100'] = {
		label = 'Small Scratcher - $5000 Winner',
		weight = 0,
		description = "Turn in at city hall for your prize!",
	},
	['skateboard'] = {
		label = 'Electric Skateboard',
		weight = 7000,
		description = "It's electric",
	},
	['smgbarrel'] = {
		label = 'SMG Barrel',
		weight = 2000,
		description = "Submachine Gun Barrel",
	},
	['methylamine'] = {
		label = 'Methylamine',
		weight = 50.0,
		description = "Just a standard chemical",
	},
	['SAlifetahoeLB'] = {
		label = '2019 Tahoe PPV',
		weight = 10.0,
		description = "",
	},
	['SAlifechargeroldLB2'] = {
		label = '2014 Charger AWD',
		weight = 10.0,
		description = "",
	},
	['modkit'] = {
		label = 'Mod Kit',
		weight = 5000.0,
		description = "",
		consume = 1,
		client = {
			export = 'velo_customs.modkit',
		}
	},
	['voucher_247'] = {
		label = 'Voucher (247)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['dfeces'] = {
		label = 'Dog Feces',
		weight = 50.0,
		description = "dog shit",
	},
	['pslimjim'] = {
		label = 'Slim Jim (Police)',
		weight = 1000.0,
		description = "Unlocks vehicles, sometimes.",
	},
	['shit'] = {
		label = 'Feces',
		weight = 1.0,
		description = "oh god.",
	},
	['rfeces'] = {
		label = 'Rat Feces',
		weight = 50.0,
		description = "dog shit",
	},
	['steakburrito'] = {
		label = 'Steak Burrito',
		weight = 100.0,
		description = "Steak Burrito with Salsa, Onion, Tamato, Rice, Cheese, Beans, and Lettuce.",
	},
	['workorder_aeautoexotic'] = {
		label = 'Work Order (AE)',
		weight = 50.0,
		description = "",
	},
	['cfeces'] = {
		label = 'Cat Feces',
		weight = 50.0,
		description = "dog shit",
	},
	['bfeces'] = {
		label = 'Bird Feces',
		weight = 50.0,
		description = "bird shit",
	},
	['bottle'] = {
		label = 'Empty Bottle',
		weight = 50.0,
		description = "huh... nothing left",
	},
	['akbarrel'] = {
		label = 'AR Barrel',
		weight = 3000,
		description = "AR Barrel",
	},
	['forgedsteel'] = {
		label = 'Steel',
		weight = 500.0,
		description = "A forged combination of Iron and Coal.",
	},
	['consignment'] = {
		label = 'Consignment',
		weight = 10.0,
		description = "",
	},
	['voucher_lsc'] = {
		label = 'Voucher (lsc)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['lssdbadge_deputy2'] = {
		label = 'Badge: Deputy 2',
		weight = 10.0,
		description = "",
	},
	['lspdbadge_officer2'] = {
		label = 'Badge: Officer 2',
		weight = 10.0,
		description = "",
	},
	['fcchips'] = {
		label = 'Casino Free Play',
		weight = 0.001,
		description = "",
	},
	['lspdbadge_officer3'] = {
		label = 'Badge: Officer 3',
		weight = 10.0,
		description = "",
	},
	['glassrod'] = {
		label = 'Glass Rod',
		weight = 100.0,
		description = "",
	},
	['lssdbadge_lieutenant'] = {
		label = 'Badge: Lieutenant',
		weight = 10.0,
		description = "",
	},
	['cbutt'] = {
		label = 'Cigarette Butt',
		weight = 5.0,
		description = "welp",
	},
	['ziptie'] = {
		label = 'Crusty Ziptie',
		weight = 0,
		description = "Ziptie, real handy",
	},
	['sterile_mouthpiece'] = {
		label = 'Sterile Mouthpiece',
		weight = 10.0,
		description = "Used with a breathalyzer",
	},
	['dietylamide'] = {
		label = 'Dietylamide',
		weight = 2000,
		description = "The derivative of a compound formed by adding an amide group with two ethyl substituents",
	},
	['mjpermit'] = {
		label = 'Medical Marijuana Permit',
		weight = 0,
		description = "Govt. Issued Medical Marijuana Permit.",
	},
	['ruby'] = {
		label = 'Rubies',
		weight = 0.2,
		description = "African Ruby",
	},
	['safetypin'] = {
		label = 'Safety Pin',
		weight = 500.0,
		description = "Used to pin stuff together",
	},
	['meat_bird'] = {
		label = 'Bird Meat',
		weight = 50.0,
		description = "",
	},
	['orangejuice'] = {
		label = 'Orange Juice',
		weight = 500.0,
		description = "75 percent Pulp Orange Juice.",
	},
	['credit'] = {
		label = 'Credit Card',
		weight = 250.0,
		description = "credit card",
	},
	['voucher_hangout'] = {
		label = 'Voucher (hangout)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['voucher_blackbird'] = {
		label = 'Voucher (blackbird)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['meat_rat'] = {
		label = 'Rat Meat',
		weight = 50.0,
		description = "",
	},
	['SAlifechargeroldestLB'] = {
		label = '2010 Charger',
		weight = 10.0,
		description = "",
	},
	['icetea'] = {
		label = 'Iced Tea',
		weight = 100.0,
		description = "Refreshing SAL Brand Iced Tea.",
	},
	['lobster'] = {
		label = 'Lobster',
		weight = 500.0,
		description = "",
	},
	['SAlifetahoeSLK'] = {
		label = '2019 Tahoe SLK',
		weight = 10.0,
		description = "",
	},
	['ptray'] = {
		label = 'Plastic Tray',
		weight = 90.0,
		description = "used to have something in it.",
	},
	['engineswap_D_C'] = {
		label = 'Engine Swap (D to C)',
		weight = 10000,
		description = "swap your engines",
	},
	['carbinereceiver'] = {
		label = 'Carbine Receiver',
		weight = 2000,
		description = "Carbine Rifle Receiver",
	},
	['vicodin'] = {
		label = 'Vicodin',
		weight = 20.0,
		description = "Just pills.",
		client = {
			export = 'salife_oxinv.vicodin',
		},
	},
	['voucher_augury'] = {
		label = 'Voucher (augury)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},

	['greatwhite'] = {
		label = 'Greatwhite',
		weight = 500.0,
		description = "",
	},
	['unidentifiedore'] = {
		label = "Unidentified Ore",
		weight = 500,
		description = 'Take this to the Forge at 9304 to prospect it into materials',
		consume = 1,
		client = {
			anim = { dict = "friends@laf@ig_5", clip = "nephew" },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		},
		server = {
			export = 'salife_oxinv.unidentifiedore'
		},
		buttons = {
			{
				label = 'GPS to the Forge',
				action = function(slot)
					SetNewWaypoint(1088.7164306641, -1993.5692138672);
				end
			}
		}
	},
	['stone'] = {
		label = 'Stone',
		weight = 300.0,
	},
	['clay'] = {
		label = 'Clay',
		weight = 325.0,
	},
	['ceramic'] = {
		label = 'Ceramic',
		weight = 500.0,
	},
	['graphitetools'] = {
		label = 'Graphite Tools',
		weight = 3000.0,
		description = "",
	},
	['uranium'] = {
		label = 'Uranium',
		weight = 300.0,
		description = "a mineral",
	},
	['chips'] = {
		label = 'Chips',
		weight = 100.0,
		description = "Bag of chips.",
	},
	['nachos'] = {
		label = 'Nachos',
		weight = 100.0,
		description = "Yellow chips with 'beef' and 'cheese' on the top.",
	},
	['SAlifef150extLB'] = {
		label = '2018 F150 Ext',
		weight = 10.0,
		description = "",
	},
	['SAlifeimpalaSLK'] = {
		label = '2013 Impala SLK',
		weight = 10.0,
		description = "",
	},
	['quesadillas'] = {
		label = 'Quesadilla',
		weight = 100.0,
		description = "A tortilla primarily filled with cheese, and some questionable meat, beans, and spices.",
	},
	['coal'] = {
		label = 'Coal',
		weight = 300.0,
		description = "a mineral",
	},
	['rubber'] = {
		label = 'Rubber',
		weight = 300.0,
		description = "a flexible material",
	},
	['wiring'] = {
		label = 'Wires',
		weight = 10.0,
		description = "Used to build computers",
	},
	['bagofmarbles'] = {
		label = 'Bag of Marbles',
		weight = 10.0,
		description = "",
	},
	['narcan'] = {
		label = 'Narcan',
		weight = 500.0,
		description = "fart",
	},
	['manta ray'] = {
		label = 'Manta ray',
		weight = 500.0,
		description = "",
	},
	['secphonecase'] = {
		label = 'Secure Phone Case',
		weight = 500.0,
		description = "Protect your phone information from being stolen",
	},
	['lssdbadge_deputy'] = {
		label = 'Badge: Deputy',
		weight = 10.0,
		description = "",
	},
	['bread'] = {
		label = 'Bread',
		weight = 500.0,
		description = "Bread, wonder when it went stale.",
	},
	['rdx'] = {
		label = 'RDX',
		weight = 2000,
		description =
		"It's white solid without smell or taste, widely used as an explosive also known as Cyclotrimethylene Trinitramine",
	},
	['ironore'] = {
		label = 'Iron',
		weight = 300.0,
		description = "a mineral",
	},
	['mixtape'] = {
		label = 'Mixtape',
		weight = 250.0,
		description = "A tape that someone has recorded onto.",
	},
	['cranberryjuice'] = {
		label = 'Cranberry Juice',
		weight = 500.0,
		description = "Juice for old people and those who need some extra help.",
	},
	['lssdbadge_corporal'] = {
		label = 'Badge: Corporal',
		weight = 10.0,
		description = "",
	},
	['diesel'] = {
		label = 'Diesel',
		weight = 800.0,
		description = "Liquid fuel commonly used in commerical grade vehicles.",
	},
	['fries'] = {
		label = 'Fries',
		weight = 100.0,
		description = "Fries that have been out for 2 minutes too long.  They're cold now.",
	},
	['SAlifetahoeLB2'] = {
		label = '2019 Tahoe SSV',
		weight = 10.0,
		description = "",
	},
	['microsmgmag'] = {
		label = 'MicroSMG Magazine',
		weight = 2000,
		description = "A MicroSMG Magazine",
	},
	['ducttape'] = {
		label = 'Duct Tape',
		weight = 1000,
		description = "Is scrim backed pressure sensitive tape, often coated with polyethylene",
	},
	['cmachine'] = {
		label = 'Counterfeit Machine',
		weight = 5000.0,
		description = "Looks pretty fuckin sketchy",
	},
	['bullets'] = {
		label = 'Bullet (Tip)',
		weight = 150.0,
		description = "The tip of the bullet to be paired with the casing.",
	},
	['SAlifecvpiLB'] = {
		label = '2011 CVPI',
		weight = 10.0,
		description = "",
	},
	['engineswap_ALL_DRIFTA'] = {
		label = 'Engine Swap (ALL to DRIFTA)',
		weight = 10000,
		description = "swap your engines",
	},
	['decoratorlicense'] = {
		label = 'License to Decorate',
		weight = 1.0,
		description = "",
	},
	['trophy'] = {
		label = 'Trophy',
		weight = 0,
		description = "Shiny.",
	},
	['akstock'] = {
		label = 'AR Stock',
		weight = 3000,
		description = "AR stock",
	},
	['lead'] = {
		label = 'Lead',
		weight = 300.0,
		description = "a mineral",
	},
	['receiverstamp'] = {
		label = 'Receiver Stamp',
		weight = 4000,
		description = "",
	},
	['sulfur'] = {
		label = 'Sulfur',
		weight = 300.0,
		description = "a mineral",
	},
	['rustyscissors'] = {
		label = 'Scissors',
		weight = 200.0,
		description = "Scissors, real handy",
	},
	['scratch_50a_win_25'] = {
		label = 'Small Scratcher - $1250 Winner',
		weight = 0,
		description = "Turn in at city hall for your prize!",
	},
	['fcola'] = {
		label = 'Fountain Cola',
		weight = 100.0,
		description = "Fountain off-brand cola product (still tastes okay I guess).",
	},
	['smgframe'] = {
		label = 'SMG Frame',
		weight = 2000,
		description = "Submachine Gun Frame",
	},
	['voucher_sasp'] = {
		label = 'Voucher (sasp)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['cocksteak'] = {
		label = 'Cock Steak Sandwich',
		weight = 100.0,
		description = "A Lucky Plucker specialty chicken and steak sandwich.",
	},
	['voucher_ponsonbys'] = {
		label = 'Voucher (ponsonbys)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['cpaper'] = {
		label = 'Sheet of Paper',
		weight = 1.0,
		description = "Just some paper...",
	},
	['SAlifechargeroldLB'] = {
		label = '2014 Charger RWD',
		weight = 10.0,
		description = "",
	},
	['necklace'] = {
		label = 'Necklaces',
		weight = 10.0,
		description = "Shiny.",
	},
	['gasoline'] = {
		label = 'Regular Grade Gasoline (87)',
		weight = 200.0,
		description = "Gasoline with an Octane Rating of 87, regular grade fuel.",
	},
	['screws'] = {
		label = 'Screws',
		weight = 100.0,
		description = "A type of fastener typically made of metal",
	},
	['cup'] = {
		label = 'Empty Cup',
		weight = 50.0,
		description = "huh... nothing left",
	},
	['carbinestock'] = {
		label = 'Carbine Stock',
		weight = 2000,
		description = "Carbine Rifle Stock",
	},
	['ink'] = {
		label = 'Ink',
		weight = 1.0,
		description = "Just some ink...",
	},
	['necklacemold'] = {
		label = 'Necklace Mold',
		weight = 500.0,
		description = "",
	},
	['aluminiumbracelet'] = {
		label = 'Aluminium Bracelet',
		weight = 100.0,
		description = "",
	},
	['trout'] = {
		label = 'Trout',
		weight = 500.0,
		description = "",
	},
	['engagementring'] = {
		label = 'Engagement Ring',
		weight = 0,
		description = "You might be making a good decision.",
	},
	['kebab'] = {
		label = 'Kebab',
		weight = 100.0,
		description = "Meat, Vegetables, and other substances on a stick.",
	},
	['pdonut'] = {
		label = 'Premium Donut',
		weight = 100.0,
		description = "Every cops balanced breakfast.",
	},
	['inkcutters'] = {
		label = 'Dye Pack Remover',
		weight = 1000.0,
		description = "Secure that cash.",
	},
	['pristinewallet'] = {
		label = 'Pristine Wallet',
		weight = 10.0,
		description = "",
	},
	['swordfish'] = {
		label = 'Swordfish',
		weight = 500.0,
		description = "",
	},
	['almond'] = {
		label = 'Almond',
		weight = 50.0,
		description = "",
	},
	['voucher_hospital'] = {
		label = 'Voucher (hospital)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['brooksf'] = {
		label = 'Brooks Fragrance',
		weight = 100.0,
		description = "The most interesting aroma of Brooks Fragrance.",
	},
	['keycard'] = {
		label = 'Key Card',
		weight = 100.0,
		description = "A Key Card (hmm).",
	},
	['engineswap_A_AB'] = {
		label = 'Engine Swap (A to AB)',
		weight = 10000,
		description = "swap your engines",
	},
	['sulfuric_acid'] = {
		label = 'Sulfuric Acid',
		weight = 1000,
		description = "Oil of Vitriol",
	},
	['lssdbadge_captain'] = {
		label = 'Badge: Captain',
		weight = 10.0,
		description = "",
	},
	['cstape'] = {
		label = 'CS Tape',
		weight = 1000,
		description = "",
	},
	['pbulletproof_vest'] = {
		label = 'Kevlar Vest (Police)',
		weight = 4000,
		description = "Bullet-proof to the max.",
	},
	['voucher_junkyard'] = {
		label = 'Voucher (junkyard)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['applechip'] = {
		label = 'Apple Chip',
		weight = 10.0,
		description = "A sliced and fried apple chip (thin).",
	},
	['voucher_unicorn'] = {
		label = 'Voucher (unicorn)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['shark'] = {
		label = 'Shark',
		weight = 500.0,
		description = "",
	},
	['nuts'] = {
		label = 'Bar Nuts',
		weight = 100.0,
		description = "Peanuts that are so bad they're typically free.",
	},
	['hotwirekit'] = {
		label = 'Hotwiring Kit',
		weight = 1000.0,
		stack = false,
	},
	['nitric_acid'] = {
		label = 'Nitric acid',
		weight = 1000,
		description = "A highly corrosive mineral acid",
	},
	['key'] = {
		label = 'key',
		weight = 10.0,
		description = "",
	},
	['marbles'] = {
		label = 'Glass Marbles',
		weight = 100.0,
		description = "",
	},
	['xanax'] = {
		label = 'Xanax',
		weight = 20.0,
		description = "Stress reducer",
		consume = 1,
		client = {
			export = 'salife_oxinv.xanax',
		},
	},
	['smgstock'] = {
		label = 'SMG Stock',
		weight = 2000,
		description = "Submachine Gun Stock",
	},
	['meat_mtln'] = {
		label = 'Mountain Lion Meat',
		weight = 50.0,
		description = "",
	},
	['bodyshot'] = {
		label = 'BodyShot Fragrance',
		weight = 100.0,
		description =
		"The wonderous and brilliant woody aroma of BodyShot by HeadShots, warmed and spiced with aromatic coriander and juniper berries with notes of citrus by BodyShot.",
	},
	['lemonade'] = {
		label = 'Lemonade',
		weight = 500.0,
		description = "Delicious Frozen Lemonade.",
	},
	['rfidwallet'] = {
		label = 'RFID Protection Wallet',
		weight = 250.0,
		description = "Protect your cards and identity",
	},
	['nitre'] = {
		label = 'Nitre',
		weight = 300.0,
		description = "a mineral",
	},
	['plant_nutrients'] = {
		label = 'Plant Nutrients',
		weight = 1000.0,
		description = "Food for plants.",
	},
	['saliva_tester'] = {
		label = 'Roadside Saliva Test Kit',
		weight = 100.0,
		description = "Used to test individuals",
	},
	['basketball'] = {
		label = 'Basketball',
		weight = 3000.0,
		description = "",
	},
	['antiagingcream'] = {
		label = 'Anti-Aging Cream',
		weight = 500.0,
		description = "",
	},
	['weightlosssupplement'] = {
		label = 'Weight Loss Supplement',
		weight = 500.0,
		description = "",
	},
	['smartwatch'] = {
		label = 'Smart Watch',
		weight = 0,
		description = "",
	},
	['packofcigarettes'] = {
		label = 'Pack of Cigarettes',
		weight = 0,
		description = "20 Pack - Redwoods.",
	},
	['alchemist'] = {
		label = 'AL-Chem',
		weight = 1.0,
		description = "acidic",
	},
	['gwaste'] = {
		label = 'Petroleum Byproduct',
		weight = 100.0,
		description = "A byproduct of the creation of gas.",
	},
	['grapes'] = {
		label = 'Grape',
		weight = 1000.0,
		description = "",
	},
	['carton'] = {
		label = 'Empty Carton',
		weight = 50.0,
		description = "huh... nothing left",
	},
	['hotdog'] = {
		label = 'Hotdog',
		weight = 100.0,
		description = "Hotdog with Ketchup and Mustard.",
	},
	['aluminiumcan'] = {
		label = 'Aluminium Can',
		weight = 150.0,
		description = "A forged Aluminium can.",
	},
	['crystalmethb'] = {
		label = 'Crystal Meth',
		weight = 200.0,
		description = "Some Crystal Meth.",
	},
	['shrimp'] = {
		label = 'Shrimp',
		weight = 500.0,
		description = "",
	},
	['isopropyl'] = {
		label = 'Isopropyl',
		weight = 2000,
		description = "",
	},
	['grapejuice'] = {
		label = 'Grape Juice',
		weight = 500.0,
		description = "Not Welches Grape Juice.",
	},
	['watch'] = {
		label = 'Watch',
		weight = 500.0,
		description = "Shiny.",
	},
	['gaspremium'] = {
		label = 'Premium-Grade Gasoline (91)',
		weight = 600.0,
		description = "Gasoline with an Octane Rating of 91, premium-grade fuel.",
	},
	['pseudophedrine'] = {
		label = 'Cough Syrup',
		weight = 50.0,
		description = "High quality pseudophedrine based cough medicine.",
	},
	['diamond'] = {
		label = 'Diamond',
		weight = 300.0,
		description = "a mineral",
	},
	['brokenfingernail'] = {
		label = 'Broken Fingernail',
		weight = 10.0,
		description = "",
	},
	['deer_antler'] = {
		label = 'Antlers',
		weight = 50.0,
		description = "",
	},
	['engineswap_C_B'] = {
		label = 'Engine Swap (C to B)',
		weight = 10000,
		description = "swap your engines",
	},
	['chaitea'] = {
		label = 'Chai Tea Latte',
		weight = 100.0,
		description = "Standard cup o' joe.",
	},
	['scanner_master'] = {
		label = 'Scanner Mk. X',
		weight = 1000,
		description = "Scans nearby items and ding ding bing cha-ching.",
	},
	['oldcoin'] = {
		label = 'Old Coin',
		weight = 10.0,
		description = "",
	},
	['appleslice'] = {
		label = 'Apple Slice',
		weight = 20.0,
		description = "A sliced apple (thicc).",
	},
	['scrap2'] = {
		label = 'Scuffed Scrap',
		weight = 250.0,
		description = "",
	},
	['cheesesteak'] = {
		label = 'Cheesesteak',
		weight = 100.0,
		description = "A pretty good looking ripoff of the Philly Cheesesteak.",
	},
	['voucher_federal'] = {
		label = 'Voucher (federal)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['debit'] = {
		label = 'Debit Card',
		weight = 0,
		description = "Debit Card.",
	},
	['fishing_rod'] = {
		label = 'Fishing Rod',
		weight = 1000,
		description = "",
	},
	['wire'] = {
		label = 'Wire',
		weight = 200.0,
		description = "A single, usually cylindrical, flexible strand or rod of metal",
	},
	['doubleburger'] = {
		label = 'The Heartstopper',
		weight = 100.0,
		description = "This burger may kill you! We can't be held respondsible.",
	},
	['dice'] = {
		label = 'Die',
		weight = 0,
		description = "Roll me.",
	},
	['morphinep'] = {
		label = 'Crushed Morphine',
		weight = 100.0,
		description = "Morphine pills that have been crushed into a fine powder.",
	},
	['searchwarrant'] = {
		label = 'Search Warrant',
		weight = 500.0,
		description = "",
	},
	['shakeweight'] = {
		label = 'Shake Weight',
		weight = 500.0,
		description = "dog shit",
	},
	['tunanocrust'] = {
		label = 'Tuna Sandwich (No Crust)',
		weight = 100.0,
		description = "no crust tuna.",
	},
	['springs'] = {
		label = 'Springs',
		weight = 100.0,
		description = "An elastic object that stores mechanical energy",
	},
	['emeraldore'] = {
		label = 'Emerald',
		weight = 300.0,
		description = "a mineral",
	},
	['coppernecklace'] = {
		label = 'Copper Necklace',
		weight = 100.0,
		description = "",
	},
	['mysterynote'] = {
		label = 'Mysterious Note',
		weight = 0,
		description = "weird...",
	},
	['spareparts'] = {
		label = 'Spare Parts',
		weight = 500.0,
		description = "",
	},
	['oilchange'] = {
		label = 'Oil Change Kit',
		weight = 1000,
		description = "Oil change me daddy",
	},
	['keycard_blue'] = {
		label = 'Keycard (BLUE)',
		weight = 0,
		description = "Swipe Left",
	},
	['mcd'] = {
		label = 'McDonalds Super Sized Meal',
		weight = 100.0,
		description = "Aren't these things for kids?",
	},
	['gasplus'] = {
		label = 'Mid-Grade Gasoline (89)',
		weight = 400.0,
		description = "Gasoline with an Octane Rating of 89, mid-grade fuel.",
	},
	['kvape'] = {
		label = 'Keenans Vape',
		weight = 50.0,
		description = "Rip fat Keenan shit. #VapeNation",
	},
	['ammonium_nitrate'] = {
		label = 'Ammonium nitrate',
		weight = 4000,
		description = "a chemical compound",
	},
	['weaponbarrel'] = {
		label = 'Weapon Barrel',
		weight = 2000,
		description = "A plain weapon barrel not rifiled to any specfic weapon",
	},
	['mackerel'] = {
		label = 'Mackerel',
		weight = 500.0,
		description = "",
	},
	['invoice_autoexotic'] = {
		label = 'Invoice (autoexotic)',
		weight = 50.0,
		description = "Used to get paid to your account.",
	},
	['permit'] = {
		label = 'Hunting/Fishing Permit',
		weight = 0,
		description = "A permit that allows the user to Hunt & Fish in the State of San Andreas.",
	},
	['sandwich'] = {
		label = 'Sandwich',
		weight = 100.0,
		description = "Cold cut sandwich on stale bread.",
	},
	['SAlifefpiuLB'] = {
		label = '2019 Explorer',
		weight = 10.0,
		description = "",
	},
	['SAlifecvpiSLK'] = {
		label = '2011 CVPI SLK',
		weight = 10.0,
		description = "",
	},
	['gasdrug'] = {
		label = 'Dockhash',
		weight = 100.0,
		description = "The dank.",
	},
	['rafeces'] = {
		label = 'Rabbit Feces',
		weight = 50.0,
		description = "dog shit",
	},
	['voucher_autoexotic'] = {
		label = 'Voucher (autoexotic)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['tostadas'] = {
		label = 'Tostada',
		weight = 100.0,
		description = "A flat tortialla with questionable meat, lettuce, and cheese on top.",
	},
	['emerald'] = {
		label = 'Emeralds',
		weight = 10.0,
		description = "Shiny.",
	},
	['lube'] = {
		label = 'Lube',
		weight = 1000.0,
		client = {
			export = 'salife_oxinv.lube'
		}
	},
	['deodorant'] = {
		label = 'Cheap Deodorant',
		weight = 1000.0,
		description = "Good old fashioned spice for your pits.",
		client = {
			export = 'salife_oxinv.deodorant'
		}
	},
	['pperfume'] = {
		label = 'Perfume',
		weight = 1000.0,
		client = {
			export = 'salife_oxinv.perfume'
		}
	},
	['shampoo'] = {
		label = 'Shampoo',
		weight = 1000.0,
		client = {
			export = 'salife_oxinv.shampoo'
		}
	},
	['cologne'] = {
		label = 'Fragrance',
		weight = 1000.0,
		description = "Great smelling for a greater you.",
		client = {
			export = 'salife_oxinv.cologne'
		}
	},
	['conditioner'] = {
		label = 'Conditioner',
		weight = 1000.0,
		client = {
			export = 'salife_oxinv.conditioner'
		}
	},
	['sturgeon'] = {
		label = 'Sturgeon',
		weight = 500.0,
		description = "",
	},
	['bakingsoda'] = {
		label = 'Baking Soda',
		weight = 50.0,
		description = "Arm & Hammer.",
	},
	['oil2'] = {
		label = 'Crude Oil (Mid)',
		weight = 2000,
		description = "A naturally occurring, unrefined petroleum product.",
	},
	['valium'] = {
		label = 'Valium',
		weight = 20.0,
		description = "Just pills.",
	},
	['bulletproof_vest'] = {
		label = 'Kevlar Vest',
		weight = 4000,
		description = "Bullet-proof to the max.",
	},
	['lockpicka'] = {
		label = 'Lockpick Set (Pin-Tumbler & Wafer)',
		weight = 2000,
		description = "Used to pick pin-tumbler locks",
	},
	['piss'] = {
		label = 'Urine',
		weight = 1.0,
		description = "oh god.",
	},
	['meat_cow'] = {
		label = 'Cow Meat',
		weight = 50.0,
		description = "",
	},
	['blindfold'] = {
		label = 'Brown Paper Bag',
		weight = 500.0,
		description = "Great for your lunch",
	},
	['oil'] = {
		label = 'Crude Oil',
		weight = 2000,
		description = "A naturally occurring, unrefined petroleum product.",
	},
	['voucher_saag'] = {
		label = 'Voucher (saag)',
		weight = 50.0,
		description = "Used to pay from your account.",
	},
	['garagepassb'] = {
		label = 'Garage Pass',
		weight = 500.0,
		description = "",
	},
	['weedb'] = {
		label = 'Marijuana',
		weight = 200.0,
		description = "The dank.",
	},
	['carcass_boar'] = {
		label = 'Boar Carcass',
		weight = 20000,
		stack = false,
		degrade = 5 * 60,
		client = {
			add = function()
				TriggerEvent('nfire_hunting:CarryCarcass')
			end,
			remove = function()
				TriggerEvent('nfire_hunting:CarryCarcass')
			end
		}
	},
	['carcass_hawk'] = {
		label = 'Hawk Carcass',
		weight = 3000,
		stack = false,
		degrade = 5 * 60,
		client = {
			add = function()
				TriggerEvent('nfire_hunting:CarryCarcass')
			end,
			remove = function()
				TriggerEvent('nfire_hunting:CarryCarcass')
			end
		}
	},
	['carcass_cormorant'] = {
		label = 'Cormorant Carcass',
		weight = 3000,
		stack = false,
		degrade = 5 * 60,
		client = {
			add = function()
				TriggerEvent('nfire_hunting:CarryCarcass')
			end,
			remove = function()
				TriggerEvent('nfire_hunting:CarryCarcass')
			end
		}
	},
	['carcass_coyote'] = {
		label = 'Coyote Carcass',
		weight = 3000,
		stack = false,
		degrade = 5 * 60,
		client = {
			add = function()
				TriggerEvent('nfire_hunting:CarryCarcass')
			end,
			remove = function()
				TriggerEvent('nfire_hunting:CarryCarcass')
			end
		}
	},
	['carcass_deer'] = {
		label = 'Deer Carcass',
		weight = 18000,
		stack = false,
		degrade = 5 * 60,
		client = {
			add = function()
				TriggerEvent('nfire_hunting:CarryCarcass')
			end,
			remove = function()
				TriggerEvent('nfire_hunting:CarryCarcass')
			end
		}
	},
	['carcass_mtlion'] = {
		label = 'Mountain Lion Carcass',
		weight = 16000,
		stack = false,
		degrade = 5 * 60,
		client = {
			add = function()
				TriggerEvent('nfire_hunting:CarryCarcass')
			end,
			remove = function()
				TriggerEvent('nfire_hunting:CarryCarcass')
			end
		}
	},
	['carcass_rabbit'] = {
		label = 'Rabbit Carcass',
		weight = 3000,
		stack = false,
		degrade = 5 * 60,
		client = {
			add = function()
				TriggerEvent('nfire_hunting:CarryCarcass')
			end,
			remove = function()
				TriggerEvent('nfire_hunting:CarryCarcass')
			end
		}
	},
}
