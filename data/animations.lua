return {
	anim = {
		['eating'] = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger_fp' },
		['eating2'] = { dict = 'mp_player_inteat@burger', clip = 'mp_player_int_eat_burger' },
		['sodacupsip'] = { dict = 'smo@milkshake_idle', clip = 'milkshake_idle_clip' },
		['bottlesip'] = { dict = 'mp_player_intdrink', clip = 'loop_bottle'},
		['junkdrink'] = { dict = 'amb@world_human_drinking@coffee@male@idle_a', clip = 'idle_c'},
		['frappe'] = { dict = 'amb@code_human_wander_drinking@female@base', clip = 'static' },
		['sipshake'] = { dict = 'smo@milkshake_idle', clip = 'milkshake_idle_clip'},
		['holdcoffee'] = { dict = 'amb@world_human_aa_coffee@base', clip = 'base' },
		['holdmilkdchoc'] = { dict = 'amb@code_human_wander_drinking@female@base', clip = 'static' }
	},
	prop = {
		['burger'] = { model = `prop_cs_burger_01`, pos = vec3(0.02, 0.02, -0.02), rot = vec3(0.0, 0.0, 0.0) },
		['ecolasodacup'] = { model = `prop_rpemotes_soda03`, pos = vec3(0.0470, 0.0040, -0.0600), rot = vec3(-88.0273, -25.0367, -27.3898), bone = 28422},
		['pizzaslice'] = { model = `knjgh_pizzaslice4`, pos = vec3(0.0500, -0.0200, -0.0200), rot = vec3(73.6928, -66.7427, 68.3677), bone = 60309},
		['croissant'] = { model = `bzzz_foodpack_croissant001`, pos = vec3(0.0, 0.0, -0.01), rot = vec3(0.0, 0.0, 90.0), bone = 60309},
		['edrinkbottle'] = { model = `prop_energy_drink`, pos = vec3(0.008, 0.001, 0.016), rot = vec3(3.569, 4.6611, -49.9065), bone = 60309},
		['junkcan'] = { model = `sf_p_sf_grass_gls_s_01a`, pos = vec3(0.0, 0.0, -0.14), rot = vec3(0.0, 0.0, 9.0), bone = 28422},
		['americano'] = { model = `p_amb_coffeecup_01`, pos = vec3(0.0,0.0,0.0), rot = vec3(0.0,0.0,0.0), bone = 28422},
		['cappuccino'] = { model = `bzzz_food_xmas_mug_b`, pos = vec3(0.09, -0.01, 0.08), rot = vec3(-44.0, 137.0, 0.0), bone = 18905},
		['frappe2'] = { model = `beanmachine_cup`, pos = vec3(0.0110, 0.0, 0.03), rot = vec3(0.0, 0.0, -140.0), bone = 28422},
		['frappe4'] = { model = `beanmachine_cup3`, pos = vec3(0.0, 0.0, -0.06), rot = vec3(0.0, 0.0, -178.0), bone = 28422},
		['doublechocshake'] = { model = `brum_cherryshake_doublechocolate`, pos = vec3(0.0850, 0.0670, -0.0350), rot = vec3(-115.0862, -165.7841, 24.1318), bone = 28422},
		['doublechocshakehold'] = { model = `brum_cherryshake_doublechocolate`, pos = vec3( 0.0030,
		0.0280,
		0.0800), rot = vec3( -180.0,
		-180.0,
		30.0), bone = 28422},
		['bubblegumshake'] = { model = `brum_cherryshake_bubblegum`, pos = vec3(0.003, 0.028, 0.08), rot = vec3(-180.0, -180.0, 30.0), bone = 28422},
		['mintmilkshake'] = { model = `brum_cherryshake_mint`, pos = vec3(0.0850, 0.0670, -0.0350), rot = vec3(-115.0862, -165.7841, 24.1318), bone = 28422 },
		['xmascocoa'] = { model = `pata_christmasfood1`, pos = vec3(0.01, -0.11, -0.13), rot = vec3(0.0, 0.0, 0.0), bone = 28422},
		['macaroon'] = { model = `bzzz_food_xmas_macaroon_a`, pos = vec3(0.15, 0.07, 0.00), rot = vec3(38.0, 7.0, 7.0), bone = 18905},
		['smores'] = { model = `bzzz_food_dessert_a`, pos = vec3(0.15, 0.03, 0.03), rot = vec3(-42.0, -36.0, 0.0), bone = 18905 },
		['xmascc'] = { model = `pata_christmasfood6`, pos = vec3(0.0100, 0.0200, -0.0100), rot = vec3(-170.1788, 87.6716, 30.0540), bone = 60309 }
	}
}