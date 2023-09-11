return {
	General = {
		name = '商店',
		blip = {
			id = 59, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'burger', price = 10 },
			{ name = 'water', price = 10 },
			{ name = 'cola', price = 10 },
			{ name = 'beer', price = 10 },
		}, locations = {
			vec3(25.7, -1347.3, 29.49),
			vec3(-3038.71, 585.9, 7.9),
			vec3(-3241.47, 1001.14, 12.83),
			vec3(1728.66, 6414.16, 35.03),
			vec3(1697.99, 4924.4, 42.06),
			vec3(1961.48, 3739.96, 32.34),
			vec3(547.79, 2671.79, 42.15),
			vec3(2679.25, 3280.12, 55.24),
			vec3(2557.94, 382.05, 108.62),
			vec3(373.55, 325.56, 103.56),
		},
	},

	Liquor = {
		name = '酒水店',
		blip = {
			id = 93, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'water', price = 10 },
			{ name = 'cola', price = 10 },
			{ name = 'beer', price = 10 },
			{ name = 'burger', price = 15 },
		}, locations = {
			vec3(1135.808, -982.281, 46.415),
			vec3(-1222.915, -906.983, 12.326),
			vec3(-1487.553, -379.107, 40.163),
			vec3(-2968.243, 390.910, 15.043),
			vec3(1166.024, 2708.930, 38.157),
			vec3(1392.562, 3604.684, 34.980),
			vec3(-1393.409, -606.624, 30.319)
		},
	},

	YouTool = {
		name = '五金商店',
		blip = {
			id = 402, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'lockpick', price = 10 }
		}, locations = {
			vec3(2748.0, 3473.0, 55.67),
			vec3(342.99, -1298.26, 32.51)
		},
	},

	Ammunation = {
		name = '武装国度',
		blip = {
			id = 110, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'ammo-9', price = 5, },
			{ name = 'WEAPON_KNIFE', price = 200 },
			{ name = 'WEAPON_BAT', price = 100 },
			{ name = 'WEAPON_PISTOL', price = 1000, metadata = { registered = true }, license = 'weapon' }
		}, locations = {
			vec3(-662.180, -934.961, 21.829),
			vec3(810.25, -2157.60, 29.62),
			vec3(1693.44, 3760.16, 34.71),
			vec3(-330.24, 6083.88, 31.45),
			vec3(252.63, -50.00, 69.94),
			vec3(22.56, -1109.89, 29.80),
			vec3(2567.69, 294.38, 108.73),
			vec3(-1117.58, 2698.61, 18.55),
			vec3(842.44, -1033.42, 28.19)
		},
	},

	PoliceArmoury = {
		name = '军械库',
		groups = shared.police,
		blip = {
			id = 110, colour = 84, scale = 0.8
		}, inventory = {
			{ name = 'ammo-9', price = 5, },
			{ name = 'ammo-rifle', price = 5, },
			{ name = 'WEAPON_FLASHLIGHT', price = 200 },
			{ name = 'WEAPON_NIGHTSTICK', price = 100 },
			{ name = 'WEAPON_PISTOL', price = 500, metadata = { registered = true, serial = 'POL' }, license = 'weapon' },
			{ name = 'WEAPON_CARBINERIFLE', price = 1000, metadata = { registered = true, serial = 'POL' }, license = 'weapon', grade = 3 },
			{ name = 'WEAPON_STUNGUN', price = 500, metadata = { registered = true, serial = 'POL'} }
		}, locations = {
			vec3(451.51, -979.44, 30.68)
		},
	},

	Medicine = {
		name = '药房',
		groups = {
			['ambulance'] = 0
		},
		blip = {
			id = 403, colour = 69, scale = 0.8
		}, inventory = {
			{ name = 'medikit', price = 26 },
			{ name = 'bandage', price = 5 }
		}, locations = {
			vec3(306.3687, -601.5139, 43.28406)
		},
	},

	BlackMarketArms = {
		name = '军火黑市',
		inventory = {
			{ name = 'WEAPON_DAGGER', price = 5000, metadata = { registered = false	}, currency = 'black_money' },
			{ name = 'WEAPON_CERAMICPISTOL', price = 50000, metadata = { registered = false }, currency = 'black_money' },
			{ name = 'at_suppressor_light', price = 50000, currency = 'black_money' },
			{ name = 'ammo-rifle', price = 1000, currency = 'black_money' },
			{ name = 'ammo-rifle2', price = 1000, currency = 'black_money' }
		}, locations = {
			vec3(309.09, -913.75, 56.46)
		},
	},

	--[[ 小摊/售货机 ]]
	hotdog_stand = {
		name = '热狗摊',
		inventory = {
			{ name = 'hotdog', price = 10 },
		},
		model = {
			`prop_hotdogstand_01`,
		}
	},
	burger_stand = {
		name = '汉堡摊',
		inventory = {
			{ name = 'burger', price = 10 },
		},
		model = {
			`prop_burgerstand_01`,
		}
	},
	gumball = {
		name = '零食贩卖机',
		inventory = {
			{ name = 'candy', price = 10 },
		},
		model = {
			`prop_gumball_01`, `prop_gumball_02`, `prop_gumball_03`,
		}
	},
	snack_machine = {
		name = '零食贩卖机',
		inventory = {
			{ name = 'egobar', price = 10 },
			{ name = 'candy', price = 10 },
			{ name = 'donut', price = 10 },
		},
		model = {
			`prop_vend_snak_01`, `prop_vend_snak_01_tu`,
		}
	},
	drink_machine = {
		name = '饮料贩卖机',
		inventory = {
			{ name = 'water', price = 10 },
			{ name = 'water2', price = 10 },
			{ name = 'coffee', price = 10 },
		},
		model = {
			`prop_vend_fridge01`,
		}
	},
	coffe_machine = { -- 咖啡
		name = '饮料贩卖机',
		inventory = {
			{ name = 'coffee', price = 10 },
		},
		model = {
			`prop_vend_coffe_01`,
		}
	},
	water_machine = { -- 水
		name = '饮料贩卖机',
		inventory = {
			{ name = 'water', price = 10 },
			{ name = 'water2', price = 10 },
		},
		model = {
			`prop_vend_water_01`,
		}
	},
	--[[ cola_machine = { -- 可乐
		name = '饮料贩卖机',
		inventory = {
			{ name = 'coke_1', price = 10 },
			{ name = 'pepsi_1', price = 10 },
			{ name = 'pepsi_2', price = 10 },
		},
		model = {
			`prop_vend_soda_01`, `ch_chint10_vending_smallroom_01`
		}
	},
	soda_machine = { -- 汽水
		name = '饮料贩卖机',
		inventory = {
			{ name = '7up_1', price = 10 },
			{ name = '7up_2', price = 10 },
			{ name = 'flemon', price = 10 },
			{ name = 'forange', price = 10 },
		},
		model = {
			`prop_vend_soda_02`, `v_68_broeknvend`,
		}
	}, ]]
	energy_machine = { -- 能量饮料
		name = '饮料贩卖机',
		inventory = {
			{ name = 'water2', price = 10 },
		},
		model = {
			`sf_prop_sf_vend_drink_01a`,
		}
	},
}
