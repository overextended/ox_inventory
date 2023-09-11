return {
    ---------------------------------------
    --      ____  ____  _____   ____ __  --
    --     / __ \/ __ \/  _/ | / / //_/  --
    --    / / / / /_/ // //  |/ / ,<     --
    --   / /_/ / _, _// // /|  / /| |    --
    --  /_____/_/ |_/___/_/ |_/_/ |_|    --
    --                饮品               --
    ---------------------------------------
    ['water'] = {
		label = '矿泉水',
		weight = 500,
		description = '待我喝完矿泉水,激活金刚不绣嘴',
		-- description = '普通的水,没什么特别的',
		client = {
			status = { thirst = 200000 },
			anim = 'drinking',
			prop = { model = `vw_prop_casino_water_bottle_01a`, pos = vec3(0.0080, 0.0, -0.0500), rot = vec3(0.0, 0.0, -40.0000) },
			usetime = 5000,
			cancel = true,
		}
	},
	
	['water2'] = {
		label = '高级矿泉水',
		weight = 1000,
		description = '水中贵族,小味真不错',
		client = {
			status = { thirst = 500000 },
			anim = 'drinking',
			prop = { model = `prop_ld_flow_bottle`, bone = 18905, pos = vec3(0.12, 0.008, 0.03), rot = vec3(240.0, -60.0, 0.0) },
			usetime = 5000,
			cancel = true,
		}
	},
	
	['beer'] = {
		label = '啤酒',
		weight = 600,
		description = '泡沫淋漓、开怀畅饮，这可不是普通的饮料!',
		client = {
			status = { thirst = 200000, drunk = 100000 },
			anim = 'drinking',
			prop = { model = `prop_amb_beer_bottle`, pos = vec3(0.0080, 0.0, 0.0000), rot = vec3(0.0, 0.0, 0.0000) },
			usetime = 5000,
			cancel = true,
		}
	},
	
	['coffee'] = {
		label = '咖啡',
		weight = 120,
		description = '酱香拿铁,没有拿铁',
		client = {
			status = { thirst = 200000, hunger = -15000 },
			anim = { dict = 'amb@world_human_drinking@coffee@male@idle_a', clip = 'idle_c' },
			prop = { model = `p_amb_coffeecup_01`, bone = 28422, pos = vec3(0.0, 0.0, 0.0), rot = vec3(0.0, 0.0, 0.0) },
			usetime = 12000,
			cancel = true,
		}
	},
	
    -----------------------------------
    --      __________  ____  ____   --
    --     / ____/ __ \/ __ \/ __ \  --
    --    / /_  / / / / / / / / / /  --
    --   / __/ / /_/ / /_/ / /_/ /   --
    --  /_/    \____/\____/_____/    --
    --              食物             --
    -----------------------------------
	['burger'] = {
		label = '速食汉堡',
		weight = 220,
		description = '芝士汉堡味道醇厚,来上一口延年益寿',
		client = {
			status = { hunger = 200000, thirst = -10000 },
			anim = 'eating',
			prop = { model = `prop_cs_burger_01`, bone = 18905, pos = vec3(0.13, 0.05, 0.02), rot = vec3(-50.0, 16.0, 60.0) },
			usetime = 2500,
			cancel = true,
		},

	},
	
	['hotdog'] = {
		label = '热狗',
		weight = 80,
		description = '什么火腿腊肠',
		client = {
			status = { hunger = 200000, thirst = -50000 },
			anim = 'eating',
			prop = { model = `prop_cs_hotdog_02`, pos = vec3(-0.0300, 0.0100, -0.0100), rot = vec3(95.1071, 94.7001, -66.9179) },
			usetime = 2500,
			cancel = true,
		}
	},

    ['sandwich'] = {
		label = '三明治',
		weight = 80,
		description = '冒险路上的美味零嘴',
		client = {
			status = { hunger = 100000 },
			anim = 'eating',
			prop = { model = `prop_sandwich_01`, bone = 18905, pos = vec3(0.13, 0.05, 0.02), rot = vec3(-50.0, 16.0, 60.0) },
			usetime = 2500,
			cancel = true,
		}
	},
	
	['taco'] = {
		label = '墨西哥玉米卷',
		weight = 80,
		description = '只要内心能足够敞亮,无论吃啥都是那鱼子酱',
		client = {
			status = { hunger = 100000, thirst = -10000 },
			anim = 'eating',
			prop = { model = `prop_taco_01`, pos = vec3(-0.0170, 0.0070, -0.0210), rot = vec3(107.9846, -105.0251, 55.7779) },
			usetime = 2500,
			cancel = true,
		}
	},
	
	['egobar'] = {
		label = '能量棒',
		weight = 80,
		description = '横扫饥饿,做回自己',
		client = {
			status = { hunger = 400000, thirst = -35000 },
			anim = 'eating',
			prop = { model = `prop_choc_ego`, pos = vec3(0.0, 0.0, 0.0), rot = vec3(0.0, 0.0, 0.0) },
			usetime = 2500,
			cancel = true,
		}
	},

	['candy'] = {
		label = '糖果',
		weight = 220,
		description = '小朋友和小仙女都喜欢',
		client = {
			status = { hunger = 10000, thirst = -10000 },
			anim = 'eating4',
			prop = { model = `prop_candy_pqs`, pos = vec3(-0.0300, 0.0180, 0.0), rot = vec3(180.0, 180.0, -88.099) },
			usetime = 2500,
			cancel = true,
		},
	},

	['beans'] = {
		label = '豆子',
		weight = 2200,
		description = '真的能吃吗?',
		client = {
			status = { hunger = 300000, thirst = -10000 },
			anim = 'eating3',
			prop = {
				{ model = `h4_prop_h4_caviar_tin_01a`, pos = vec3(0.0, 0.0300, 0.0100), rot = vec3(0.0, 0.0, 0.0) },
				{ model = `h4_prop_h4_caviar_spoon_01a`, bone = 28422, pos = vec3(0.0, 0.0, 0.0), rot = vec3(0.0, 0.0, 0.0) }
			},
			usetime = 2500,
			cancel = true,
		},
	},

	
}
