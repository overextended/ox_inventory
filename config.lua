Config = Config or {}

Config.ConvertToHSN = true		-- Enable this for player loadouts and accounts to get converted to HSN Inventory
-- This should be disabled if conversion does not need to occur! In the future I will add a command to convert all player data

Config.PlayerSlot = 51		  -- Slots in the player inventory
Config.EnableBlur = true		-- Blur the screen while accessing the inventory
Config.MaxWeight = 24000		-- Max weight as grams

Config.DurabilityDecreaseAmount = { ['WEAPON_PISTOL'] = 0.6, ['WEAPON_ADVANCEDRIFLE'] = 0.6, ['WEAPON_APPISTOL'] = 0.4, ['WEAPON_ASSAULTRIFLE'] = 0.8, ['WEAPON_ASSAULTRIFLE_MK2'] = 0.6, ['WEAPON_ASSAULTSMG'] = 0.6, ['WEAPON_BALL'] = 1.0, ['WEAPON_BAT'] = 1.0, ['WEAPON_BATTLEAXE'] = 5.0, ['WEAPON_BOTTLE'] = 5.0, ['WEAPON_BULLPUPRIFLE'] = 0.9, ['WEAPON_BULLPUPRIFLE_MK2'] = 0.7, ['WEAPON_CARBINERIFLE'] = 0.8, ['WEAPON_CARBINERIFLE_MK2'] = 0.7, ['WEAPON_COMBATPDW'] = 3.0, ['WEAPON_COMBATPISTOL'] = 0.5, ['WEAPON_COMPACTRIFLE'] = 0.7, ['WEAPON_CROWBAR'] = 1.0, ['WEAPON_DAGGER'] = 1.0, ['WEAPON_DOUBLEACTION'] = 0.8, ['WEAPON_FLAREGUN'] = 1.0, ['WEAPON_FLASHLIGHT'] = 1.0, ['WEAPON_GOLFCLUB'] = 1.0, ['WEAPON_GUSENBERG'] = 0.8, ['WEAPON_HAMMER'] = 1.0, ['WEAPON_HATCHET'] = 1.0, ['WEAPON_HEAVYPISTOL'] = 0.6, ['WEAPON_KNIFE'] = 1.0, ['WEAPON_KNUCKLE'] = 1.0, ['WEAPON_MACHETE'] = 1.0, ['WEAPON_MACHINEPISTOL'] = 0.7, ['WEAPON_MARKSMANPISTOL'] = 4.0, ['WEAPON_MICROSMG'] = 0.6, ['WEAPON_MINISMG'] = 0.6, ['WEAPON_MOLOTOV'] = 5.0, ['WEAPON_MUSKET'] = 1.0, ['WEAPON_NIGHTSTICK'] = 1.0, ['WEAPON_PISTOL50'] = 0.8, ['WEAPON_PISTOL_MK2'] = 0.5, ['WEAPON_PUMPSHOTGUN'] = 0.8, ['WEAPON_PUMPSHOTGUN_MK2'] = 0.7, ['WEAPON_REVOLVER'] = 0.8, ['WEAPON_REVOLVER_MK2'] = 0.7, ['WEAPON_SAWNOFFSHOTGUN'] = 0.9, ['WEAPON_SMG'] = 0.8, ['WEAPON_SMG_MK2'] = 0.7, ['WEAPON_SNSPISTOL'] = 0.7, ['WEAPON_SNSPISTOL_MK2'] = 0.6, ['WEAPON_SPECIALCARBINE'] = 0.8, ['WEAPON_SPECIALCARBINE_MK2'] = 0.7, ['WEAPON_STONE_HATCHET'] = 1.0, ['WEAPON_STUNGUN'] = 0.6, ['WEAPON_SWITCHBLADE'] = 1.0, ['WEAPON_VINTAGEPISTOL'] = 0.7, ['WEAPON_WRENCH'] = 1.0 }
Config.Accounts = {'money', 'black_money'}
Config.Throwable = {['WEAPON_GRENADE']=1, ['WEAPON_BZGAS']=1, ['WEAPON_MOLOTOV']=1, ['WEAPON_STICKYBOMB']=1, ['WEAPON_PROXMINE']=1, ['WEAPON_SNOWBALL']=1, ['WEAPON_PIPEBOMB']=1, ['WEAPON_BALL']=1, ['WEAPON_SMOKEGRENADE']=1, ['WEAPON_FLARE']=1 }

-- 1 = Vehicle storage located in bonnet		0 = Vehicle has no storage space
Config.VehicleStorage = {[`jester`]=1, [`adder`]=1, [`osiris`]=0, [`pfister811`]=0, [`penetrator`]=0, [`autarch`]=0, [`bullet`]=0, [`cheetah`]=0, [`cyclone`]=0, [`voltic`]=0, [`reaper`]=1, [`entityxf`]=0, [`t20`]=0, [`taipan`]=0, [`tezeract`]=0, [`torero`]=1, [`turismor`]=0, [`fmj`]=0, [`infernus `]=0, [`italigtb`]=1, [`italigtb2`]=1, [`nero2`]=0, [`vacca`]=1, [`vagner`]=0, [`visione`]=0, [`prototipo`]=0, [`zentorno`]=0}



Config.ItemList = {
	['money'] = {},
	['black_money'] = {},
	['identification'] = {},

	['at_flashlight_pistol'] = { component = {`COMPONENT_AT_PI_FLSH`}, consume = 1, useTime = 2500 },
	['at_flashlight_rifle'] = { component = {`COMPONENT_AT_AR_FLSH`}, consume = 1, useTime = 2500 },
	['at_flashlight_shotgun'] = { component = {`COMPONENT_AT_AR_FLSH`}, consume = 1, useTime = 2500 },
	['at_flashlight_smg'] = { component = {`COMPONENT_AT_AR_FLSH`, `COMPONENT_AT_PI_FLSH`}, consume = 1, useTime = 2500 },
	['at_flashlight_sniper'] = { component = {`COMPONENT_AT_AR_FLSH`}, consume = 1, useTime = 2500 },
	['at_flashlight_mg'] = { component = {`COMPONENT_AT_AR_FLSH`}, consume = 1, useTime = 2500 },
	['at_clip_extended_pistol'] = { component = {`COMPONENT_PISTOL_CLIP_02`, `COMPONENT_PISTOL_MK2_CLIP_02`, `COMPONENT_SNSPISTOL_MK2_CLIP_02`, `COMPONENT_COMBATPISTOL_CLIP_02`, `COMPONENT_PISTOL50_CLIP_02`, `COMPONENT_HEAVYPISTOL_CLIP_02`, `COMPONENT_SNSPISTOL_CLIP_02`, `COMPONENT_VINTAGEPISTOL_CLIP_02`, `COMPONENT_MACHINEPISTOL_CLIP_02`}, consume = 1, useTime = 2500 },
	['at_clip_extended_smg'] = { component = {`COMPONENT_SMG_CLIP_02`, `COMPONENT_ASSAULTSMG_CLIP_02`, `COMPONENT_MICROSMG_CLIP_02`, `COMPONENT_MINISMG_CLIP_02`, `COMPONENT_COMBATPDW_CLIP_02`}, consume = 1, useTime = 2500 },
	['at_clip_extended_shotgun'] = { component = {`COMPONENT_HEAVYSHOTGUN_CLIP_02`}, consume = 1, useTime = 2500 },
	['at_clip_extended_rifle'] = { component = {`COMPONENT_ASSAULTRIFLE_CLIP_02`, `COMPONENT_CARBINERIFLE_CLIP_02`, `COMPONENT_ADVANCEDRIFLE_CLIP_02`, `COMPONENT_SPECIALCARBINE_CLIP_02`, `COMPONENT_BULLPUPRIFLE_CLIP_02`, `COMPONENT_COMPACTRIFLE_CLIP_02`, `COMPONENT_ASSAULTRIFLE_MK2_CLIP_02`, `COMPONENT_CARBINERIFLE_MK2_CLIP_02`, `COMPONENT_SPECIALCARBINE_MK2_CLIP_02`, `COMPONENT_BULLPUPRIFLE_MK2_CLIP_02`}, consume = 1, useTime = 2500 },
	['at_clip_extended_mg'] = { component = {`COMPONENT_MG_CLIP_02`, `COMPONENT_COMBATMG_CLIP_02`, `COMPONENT_GUSENBERG_CLIP_02`}, consume = 1, useTime = 2500 },
	['at_clip_extended_sniper'] = { component = {`COMPONENT_MARKSMANRIFLE_CLIP_02`, `COMPONENT_HEAVYSNIPER_MK2_CLIP_02`, `COMPONENT_MARKSMANRIFLE_MK2_CLIP_02`}, consume = 1, useTime = 2500 },
	['at_compensator_pistol'] = { component = {`COMPONENT_AT_PI_COMP_02`, `COMPONENT_AT_PI_COMP_03`, `COMPONENT_AT_PI_COMP`}, consume = 1, useTime = 2500 },
	['at_suppressor_pistol'] = { component = {`COMPONENT_AT_PI_SUPP_02`, `COMPONENT_AT_AR_SUPP_02`, `COMPONENT_AT_PI_SUPP`}, consume = 1, useTime = 2500 },
	['at_suppresor_rifle'] = { component = {`COMPONENT_AT_AR_SUPP_02`, `COMPONENT_AT_AR_SUPP`}, consume = 1, useTime = 2500 },
	['at_suppresor_shotgun'] = { component = {`COMPONENT_AT_SR_SUPP`, `COMPONENT_AT_AR_SUPP`, `COMPONENT_AT_AR_SUPP_02`, `COMPONENT_AT_SR_SUPP_03`}, consume = 1, useTime = 2500 },
	['at_suppresor_smg'] = { component = {`COMPONENT_AT_AR_SUPP_02`, `COMPONENT_AT_PI_SUPP`}, consume = 1, useTime = 2500 },
	['at_suppresor_sniper'] = { component = {`COMPONENT_AT_AR_SUPP`, `COMPONENT_AT_SR_SUPP_03`}, consume = 1, useTime = 2500 },
	['at_clip_drum_pistol'] = { component = {`COMPONENT_MACHINEPISTOL_CLIP_03`}, consume = 1, useTime = 2500 },
	['at_clip_drum_rifle'] = { component = {`COMPONENT_COMPACTRIFLE_CLIP_03`, `COMPONENT_CARBINERIFLE_CLIP_03`, `COMPONENT_SPECIALCARBINE_CLIP_03`}, consume = 1, useTime = 2500 },
	['at_clip_drum_shotgun'] = { component = {`COMPONENT_HEAVYSHOTGUN_CLIP_03`}, consume = 1, useTime = 2500 },
	['at_clip_drum_smg'] = { component = {`COMPONENT_SMG_CLIP_03`, `COMPONENT_COMBATPDW_CLIP_03`}, consume = 1, useTime = 2500 },
	['at_scope_smg'] = { component = {`COMPONENT_AT_SCOPE_MACRO_02`, `COMPONENT_AT_SCOPE_MACRO`, `COMPONENT_AT_SCOPE_SMALL`}, consume = 1, useTime = 2500 },
	['at_scope_rifle'] = { component = {`COMPONENT_AT_SCOPE_MACRO`, `COMPONENT_AT_SCOPE_MEDIUM`, `COMPONENT_AT_SCOPE_SMALL`, `COMPONENT_AT_SCOPE_SMALL_02`}, consume = 1, useTime = 2500 },
	['at_scope_mg'] = { component = {`COMPONENT_AT_SCOPE_SMALL_02`, `COMPONENT_AT_SCOPE_MEDIUM`, `COMPONENT_AT_SCOPE_MEDIUM_MK2`}, consume = 1, useTime = 2500 },
	['at_scope_small_mg'] = { component = {`COMPONENT_AT_SCOPE_SMALL_MK2`}, consume = 1, useTime = 2500 },
	['at_scope_sniper'] = { component = {`COMPONENT_AT_SCOPE_MAX`}, consume = 1, useTime = 2500 },
	['at_scope_large_sniper'] = { component = {`COMPONENT_AT_SCOPE_LARGE_MK2`}, consume = 1, useTime = 2500 },
	['at_scope_nightvision_sniper'] = { component = {`COMPONENT_AT_SCOPE_NV`}, consume = 1, useTime = 2500 },
	['at_scope_thermal_sniper'] = { component = {`COMPONENT_AT_SCOPE_THERMAL`}, consume = 1, useTime = 2500 },
	['at_scope_small_shotgun'] = { component = {`COMPONENT_AT_SCOPE_SMALL_MK2`}, consume = 1, useTime = 2500 },
	['at_scope_macro_shotgun'] = { component = {`COMPONENT_AT_SCOPE_MACRO_MK2`}, consume = 1, useTime = 2500 },
	['at_scope_small_rifle'] = { component = {`COMPONENT_AT_SCOPE_SMALL_MK2`}, consume = 1, useTime = 2500 },
	['at_scope_macro_rifle'] = { component = {`COMPONENT_AT_SCOPE_MACRO_02_MK2`, `COMPONENT_AT_SCOPE_MACRO_MK2`}, consume = 1, useTime = 2500 },
	['at_scope_medium_rifle'] = { component = {`COMPONENT_AT_SCOPE_MEDIUM_MK2`}, consume = 1, useTime = 2500 },
	['at_scope_small_pistol'] = { component = {`COMPONENT_AT_SCOPE_SMALL_MK2`}, consume = 1, useTime = 2500 },
	['at_scope_macro_pistol'] = { component = {`COMPONENT_AT_SCOPE_MACRO_MK2`}, consume = 1, useTime = 2500 },
	['at_scope_mounted_pistol'] = { component = {`COMPONENT_AT_PI_RAIL_02`}, consume = 1, useTime = 2500 },
	['at_grip_smg'] = { component = {`COMPONENT_AT_AR_AFGRIP`}, consume = 1, useTime = 2500 },
	['at_grip_rifle'] = { component = {`COMPONENT_AT_AR_AFGRIP`, `COMPONENT_AT_AR_AFGRIP_02`}, consume = 1, useTime = 2500 },
	['at_grip_shotgun'] = { component = {`COMPONENT_AT_AR_AFGRIP`, `COMPONENT_AT_AR_AFGRIP_02`}, consume = 1, useTime = 2500 },
	['at_grip_mg'] = { component = {`COMPONENT_AT_AR_AFGRIP`, `COMPONENT_AT_AR_AFGRIP_02`}, consume = 1, useTime = 2500 },
	['at_grip_sniper'] = { component = {`COMPONENT_AT_AR_AFGRIP`, `COMPONENT_AT_AR_AFGRIP_02`}, consume = 1, useTime = 2500 },
	['at_barrel_shotgun'] = { component = {`COMPONENT_AT_SC_BARREL_02`}, consume = 1, useTime = 2500 },
	['at_barrel_rifle'] = { component = {`COMPONENT_AT_SC_BARREL_02`, `COMPONENT_AT_CR_BARREL_02`, `COMPONENT_AT_SC_BARREL_02`, `COMPONENT_AT_BP_BARREL_02`}, consume = 1, useTime = 2500 },
	['at_barrel_mg'] = { component = {`COMPONENT_AT_MG_BARREL_02`}, consume = 1, useTime = 2500 },
	['at_barrel_heavy_sniper'] = { component = {`COMPONENT_AT_MRFL_BARREL_02`}, consume = 1, useTime = 2500 },
	['at_muzzle_bellend_sniper'] = { component = {`COMPONENT_AT_SR_BARREL_01`}, consume = 1, useTime = 2500 },
	['at_muzzle_shotgun'] = { component = {`COMPONENT_AT_MUZZLE_08`}, consume = 1, useTime = 2500 },
	['at_muzzle_flat_rifle'] = { component = {`COMPONENT_AT_MUZZLE_01`}, consume = 1, useTime = 2500 },
	['at_muzzle_tatical_rifle'] = { component = {`COMPONENT_AT_MUZZLE_02`}, consume = 1, useTime = 2500 },
	['at_muzzle_fat_rifle'] = { component = {`COMPONENT_AT_MUZZLE_03`}, consume = 1, useTime = 2500 },
	['at_muzzle_precision_rifle'] = { component = {`COMPONENT_AT_MUZZLE_04`}, consume = 1, useTime = 2500 },
	['at_muzzle_heavy_rifle'] = { component = {`COMPONENT_AT_MUZZLE_05`}, consume = 1, useTime = 2500 },
	['at_muzzle_slanted_rifle'] = { component = {`COMPONENT_AT_MUZZLE_06`}, consume = 1, useTime = 2500 },
	['at_muzzle_split_rifle'] = { component = {`COMPONENT_AT_MUZZLE_07`}, consume = 1, useTime = 2500 },	
	['at_skin_pistol_gold'] = { component = {`COMPONENT_PISTOL_VARMOD_LUXE`, `COMPONENT_PISTOL50_VARMOD_LUXE`, `COMPONENT_APPISTOL_VARMOD_LUXE`, `COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER`}, consume = 1, useTime = 2500 },
	['at_skin_pistol_camo'] = { component = {`COMPONENT_SNSPISTOL_MK2_CAMO`, `COMPONENT_REVOLVER_MK2_CAMO`, `COMPONENT_PISTOL_MK2_CAMO`}, consume = 1, useTime = 2500 },
	['at_skin_pistol_brushstroke'] = { component = {`COMPONENT_PISTOL_MK2_CAMO_02`, `COMPONENT_REVOLVER_MK2_CAMO_02`, `COMPONENT_SNSPISTOL_MK2_CAMO_02`}, consume = 1, useTime = 2500 },
	['at_skin_pistol_woodland'] = { component = {`COMPONENT_PISTOL_MK2_CAMO_03`, `COMPONENT_REVOLVER_MK2_CAMO_03`, `COMPONENT_SNSPISTOL_MK2_CAMO_03`}, consume = 1, useTime = 2500 },
	['at_skin_pistol_skull'] = { component = {`COMPONENT_PISTOL_MK2_CAMO_04`, `COMPONENT_REVOLVER_MK2_CAMO_04`, `COMPONENT_SNSPISTOL_MK2_CAMO_04`}, consume = 1, useTime = 2500 },
	['at_skin_pistol_sessanta'] = { component = {`COMPONENT_PISTOL_MK2_CAMO_05`, `COMPONENT_REVOLVER_MK2_CAMO_05`, `COMPONENT_SNSPISTOL_MK2_CAMO_05`}, consume = 1, useTime = 2500 },
	['at_skin_pistol_perseus'] = { component = {`COMPONENT_PISTOL_MK2_CAMO_06`, `COMPONENT_REVOLVER_MK2_CAMO_06`, `COMPONENT_SNSPISTOL_MK2_CAMO_06`}, consume = 1, useTime = 2500 },
	['at_skin_pistol_leopard'] = { component = {`COMPONENT_PISTOL_MK2_CAMO_07`, `COMPONENT_REVOLVER_MK2_CAMO_07`, `COMPONENT_SNSPISTOL_MK2_CAMO_07`}, consume = 1, useTime = 2500 },
	['at_skin_pistol_zebra'] = { component = {`COMPONENT_PISTOL_MK2_CAMO_08`, `COMPONENT_REVOLVER_MK2_CAMO_08`, `COMPONENT_SNSPISTOL_MK2_CAMO_08`}, consume = 1, useTime = 2500 },
	['at_skin_pistol_geometric'] = { component = {`COMPONENT_PISTOL_MK2_CAMO_09`, `COMPONENT_REVOLVER_MK2_CAMO_09`, `COMPONENT_SNSPISTOL_MK2_CAMO_09`}, consume = 1, useTime = 2500 },
	['at_skin_pistol_boom'] = { component = {`COMPONENT_PISTOL_MK2_CAMO_10`, `COMPONENT_REVOLVER_MK2_CAMO_10`, `COMPONENT_SNSPISTOL_MK2_CAMO_10`}, consume = 1, useTime = 2500 },
	['at_skin_pistol_patriotic'] = { component = {`COMPONENT_SNSPISTOL_MK2_CAMO_IND_01_SLIDE`, `COMPONENT_REVOLVER_MK2_CAMO_IND_01`, `COMPONENT_PISTOL_MK2_CAMO_IND_01`}, consume = 1, useTime = 2500 },
	['at_skin_rifle_gold'] = { component = {`COMPONENT_ASSAULTRIFLE_VARMOD_LUXE`, `COMPONENT_CARBINERIFLE_VARMOD_LUXE`, `COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE`, `COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER`, `COMPONENT_BULLPUPRIFLE_VARMOD_LOW`, `COMPONENT_MG_VARMOD_LOWRIDER`}, consume = 1, useTime = 2500 },
	['at_skin_rifle_camo'] = { component = {`COMPONENT_ASSAULTRIFLE_MK2_CAMO`, `COMPONENT_CARBINERIFLE_MK2_CAMO`, `COMPONENT_SPECIALCARBINE_MK2_CAMO`, `COMPONENT_BULLPUPRIFLE_MK2_CAMO`, `COMPONENT_BULLPUPRIFLE_VARMOD_LOW`, `COMPONENT_MG_VARMOD_LOWRIDER`}, consume = 1, useTime = 2500 },
	['at_skin_rifle_brushstroke'] = { component = {`COMPONENT_ASSAULTRIFLE_MK2_CAMO_02`, `COMPONENT_CARBINERIFLE_MK2_CAMO_02`, `COMPONENT_SPECIALCARBINE_MK2_CAMO_02`, `COMPONENT_BULLPUPRIFLE_MK2_CAMO_02`}, consume = 1, useTime = 2500 },
	['at_skin_rifle_woodland'] = { component = {`COMPONENT_ASSAULTRIFLE_MK2_CAMO_03`, `COMPONENT_CARBINERIFLE_MK2_CAMO_03`, `COMPONENT_SPECIALCARBINE_MK2_CAMO_03`, `COMPONENT_BULLPUPRIFLE_MK2_CAMO_03`}, consume = 1, useTime = 2500 },
	['at_skin_rifle_skull'] = { component = {`COMPONENT_ASSAULTRIFLE_MK2_CAMO_04`, `COMPONENT_CARBINERIFLE_MK2_CAMO_04`, `COMPONENT_SPECIALCARBINE_MK2_CAMO_04`, `COMPONENT_BULLPUPRIFLE_MK2_CAMO_04`}, consume = 1, useTime = 2500 },
	['at_skin_rifle_sessanta'] = { component = {`COMPONENT_ASSAULTRIFLE_MK2_CAMO_05`, `COMPONENT_CARBINERIFLE_MK2_CAMO_05`, `COMPONENT_SPECIALCARBINE_MK2_CAMO_05`, `COMPONENT_BULLPUPRIFLE_MK2_CAMO_05`}, consume = 1, useTime = 2500 },
	['at_skin_rifle_perseus'] = { component = {`COMPONENT_ASSAULTRIFLE_MK2_CAMO_06`, `COMPONENT_CARBINERIFLE_MK2_CAMO_06`, `COMPONENT_SPECIALCARBINE_MK2_CAMO_06`, `COMPONENT_BULLPUPRIFLE_MK2_CAMO_06`}, consume = 1, useTime = 2500 },
	['at_skin_rifle_leopard'] = { component = {`COMPONENT_ASSAULTRIFLE_MK2_CAMO_07`, `COMPONENT_CARBINERIFLE_MK2_CAMO_07`, `COMPONENT_SPECIALCARBINE_MK2_CAMO_07`, `COMPONENT_BULLPUPRIFLE_MK2_CAMO_07`}, consume = 1, useTime = 2500 },
	['at_skin_rifle_zebra'] = { component = {`COMPONENT_ASSAULTRIFLE_MK2_CAMO_08`, `COMPONENT_CARBINERIFLE_MK2_CAMO_08`, `COMPONENT_SPECIALCARBINE_MK2_CAMO_08`, `COMPONENT_BULLPUPRIFLE_MK2_CAMO_08`}, consume = 1, useTime = 2500 },
	['at_skin_rifle_geometric'] = { component = {`COMPONENT_ASSAULTRIFLE_MK2_CAMO_09`, `COMPONENT_CARBINERIFLE_MK2_CAMO_09`, `COMPONENT_SPECIALCARBINE_MK2_CAMO_09`, `COMPONENT_BULLPUPRIFLE_MK2_CAMO_09`}, consume = 1, useTime = 2500 },
	['at_skin_rifle_boom'] = { component = {`COMPONENT_ASSAULTRIFLE_MK2_CAMO_10`, `COMPONENT_CARBINERIFLE_MK2_CAMO_10`, `COMPONENT_SPECIALCARBINE_MK2_CAMO_10`, `COMPONENT_BULLPUPRIFLE_MK2_CAMO_10`}, consume = 1, useTime = 2500 },
	['at_skin_rifle_patriotic'] = { component = {`COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01`, `COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01`, `COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01`, `COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01`}, consume = 1, useTime = 2500 },
	['at_skin_shotgun_gold'] = { component = {`COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER`, `COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE`}, consume = 1, useTime = 2500 },
	['at_skin_shotgun_camo'] = { component = {`COMPONENT_PUMPSHOTGUN_MK2_CAMO`}, consume = 1, useTime = 2500 },
	['at_skin_shotgun_brushstroke'] = { component = {`COMPONENT_PUMPSHOTGUN_MK2_CAMO_02`}, consume = 1, useTime = 2500 },
	['at_skin_shotgun_woodland'] = { component = {`COMPONENT_PUMPSHOTGUN_MK2_CAMO_03`}, consume = 1, useTime = 2500 },
	['at_skin_shotgun_skull'] = { component = {`COMPONENT_PUMPSHOTGUN_MK2_CAMO_04`}, consume = 1, useTime = 2500 },
	['at_skin_shotgun_sessanta'] = { component = {`COMPONENT_PUMPSHOTGUN_MK2_CAMO_05`}, consume = 1, useTime = 2500 },
	['at_skin_shotgun_perseus'] = { component = {`COMPONENT_PUMPSHOTGUN_MK2_CAMO_06`}, consume = 1, useTime = 2500 },
	['at_skin_shotgun_leopard'] = { component = {`COMPONENT_PUMPSHOTGUN_MK2_CAMO_07`}, consume = 1, useTime = 2500 },
	['at_skin_shotgun_zebra'] = { component = {`COMPONENT_PUMPSHOTGUN_MK2_CAMO_08`}, consume = 1, useTime = 2500 },
	['at_skin_shotgun_geometric'] = { component = {`COMPONENT_PUMPSHOTGUN_MK2_CAMO_09`}, consume = 1, useTime = 2500 },
	['at_skin_shotgun_boom'] = { component = {`COMPONENT_PUMPSHOTGUN_MK2_CAMO_10`}, consume = 1, useTime = 2500 },
	['at_skin_shotgun_patriotic'] = { component = {`COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01`}, consume = 1, useTime = 2500 },
	['at_skin_mg_gold'] = { component = {`COMPONENT_MARKSMANRIFLE_VARMOD_LUXE`, `COMPONENT_SNIPERRIFLE_VARMOD_LUXE`}, consume = 1, useTime = 2500 },
	['at_skin_mg_camo'] = { component = {`COMPONENT_COMBATMG_MK2_CAMO`}, consume = 1, useTime = 2500 },
	['at_skin_mg_brushstroke'] = { component = {`COMPONENT_COMBATMG_MK2_CAMO_02`}, consume = 1, useTime = 2500 },
	['at_skin_mg_woodland'] = { component = {`COMPONENT_COMBATMG_MK2_CAMO_03`}, consume = 1, useTime = 2500 },
	['at_skin_mg_skull'] = { component = {`COMPONENT_COMBATMG_MK2_CAMO_04`}, consume = 1, useTime = 2500 },
	['at_skin_mg_sessanta'] = { component = {`COMPONENT_COMBATMG_MK2_CAMO_05`}, consume = 1, useTime = 2500 },
	['at_skin_mg_perseus'] = { component = {`COMPONENT_COMBATMG_MK2_CAMO_06`}, consume = 1, useTime = 2500 },
	['at_skin_mg_leopard'] = { component = {`COMPONENT_COMBATMG_MK2_CAMO_07`}, consume = 1, useTime = 2500 },
	['at_skin_mg_zebra'] = { component = {`COMPONENT_COMBATMG_MK2_CAMO_08`}, consume = 1, useTime = 2500 },
	['at_skin_mg_geometric'] = { component = {`COMPONENT_COMBATMG_MK2_CAMO_09`}, consume = 1, useTime = 2500 },
	['at_skin_mg_boom'] = { component = {`COMPONENT_COMBATMG_MK2_CAMO_10`}, consume = 1, useTime = 2500 },
	['at_skin_mg_patriotic'] = { component = {`COMPONENT_COMBATMG_MK2_CAMO_IND_01`}, consume = 1, useTime = 2500 },
	['at_skin_sniper_camo'] = { component = {`COMPONENT_HEAVYSNIPER_MK2_CAMO`, `COMPONENT_MARKSMANRIFLE_MK2_CAMO`}, consume = 1, useTime = 2500 },
	['at_skin_sniper_brushstroke'] = { component = {`COMPONENT_HEAVYSNIPER_MK2_CAMO_02`, `COMPONENT_MARKSMANRIFLE_MK2_CAMO_02`}, consume = 1, useTime = 2500 },
	['at_skin_sniper_woodland'] = { component = {`COMPONENT_HEAVYSNIPER_MK2_CAMO_03`, `COMPONENT_MARKSMANRIFLE_MK2_CAMO_03`}, consume = 1, useTime = 2500 },
	['at_skin_sniper_skull'] = { component = {`COMPONENT_HEAVYSNIPER_MK2_CAMO_04`, `COMPONENT_MARKSMANRIFLE_MK2_CAMO_04`}, consume = 1, useTime = 2500 },
	['at_skin_sniper_sessanta'] = { component = {`COMPONENT_HEAVYSNIPER_MK2_CAMO_05`, `COMPONENT_MARKSMANRIFLE_MK2_CAMO_05`}, consume = 1, useTime = 2500 },
	['at_skin_sniper_perseus'] = { component = {`COMPONENT_HEAVYSNIPER_MK2_CAMO_06`, `COMPONENT_MARKSMANRIFLE_MK2_CAMO_06`}, consume = 1, useTime = 2500 },
	['at_skin_sniper_leopard'] = { component = {`COMPONENT_HEAVYSNIPER_MK2_CAMO_07`, `COMPONENT_MARKSMANRIFLE_MK2_CAMO_07`}, consume = 1, useTime = 2500 },
	['at_skin_sniper_zebra'] = { component = {`COMPONENT_HEAVYSNIPER_MK2_CAMO_08`, `COMPONENT_MARKSMANRIFLE_MK2_CAMO_08`}, consume = 1, useTime = 2500 },
	['at_skin_sniper_geometric'] = { component = {`COMPONENT_HEAVYSNIPER_MK2_CAMO_09`, `COMPONENT_MARKSMANRIFLE_MK2_CAMO_09`}, consume = 1, useTime = 2500 },
	['at_skin_sniper_boom'] = { component = {`COMPONENT_HEAVYSNIPER_MK2_CAMO_10`, `COMPONENT_MARKSMANRIFLE_MK2_CAMO_10`}, consume = 1, useTime = 2500 },
	['at_skin_sniper_patriotic'] = { component = {`COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01`, `COMPONENT_MARKSMANRIFLE_MK2_CAMO_IND_01`}, consume = 1, useTime = 2500 },
	['at_skin_sniper_gold'] = { component = {`COMPONENT_MARKSMANRIFLE_VARMOD_LUXE`}, consume = 1, useTime = 2500 },

	['burger'] = {
		thirst = 0,
		hunger = 200000,
		animDict = "mp_player_inteat@burger",
		anim = "mp_player_int_eat_burger_fp",
		model = "prop_cs_burger_01",
		coords = { x = 0.02, y = 0.022, z = -0.02 },
		rotation = { x = 0.0, y = 5.0, z = 0.0 },
		useTime = 2500,
		consume = 1,
	},

	['water'] = {
		thirst = 200000,
		hunger = 0,
		animDict = "mp_player_intdrink",
		anim = "loop_bottle",
		model = "prop_ld_flow_bottle",
		coords = { x = 0.03, y = 0.0, z = 0.02 },
		rotation = { x = 0.0, y = -13.5, z = -1.5 },
		useTime = 2500,
		consume = 1,
	},

	['cola'] = {
		thirst = 200000,
		hunger = 0,
		animDict = "mp_player_intdrink",
		anim = "loop_bottle",
		model = "prop_ecola_can",
		coords = { x = 0.01, y = 0.0, z = 0.06 },
		rotation = { x = 5.0, y = -1.5, z = -180.5 },
		useTime = 2500,
		consume = 1,
	},

	['bandage'] = {
		animDict = "missheistdockssetup1clipboard@idle_a",
		anim = "idle_a",
		flags = 49,
		model = "prop_rolled_sock_02",
		coords = { x = -0.14, y = 0.02, z = -0.08 },
		rotation = { x = -50.0, y = -50.0, z = 0.0 },
		useTime = 2500,
		consume = 1,
	},

	['lockpick'] = {
		disableMove = true,
		animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
		anim = "machinic_loop_mechandplayer",
		useTime = 2000,
		consume = 0   
	},

}

Config.PoliceEvidence = vector3(474.2242, -990.7516, 26.2638) -- /evidence # while near this point

Config.Stashes = {
	--{ coords = vector3(474.2242, -990.7516, 26.2638), slots = 71, name = 'Police Evidence', job = 'police' }, using command instead
	{ coords = vector3(301.4374, -599.2748, 43.2821), slots = 71, name = 'Hospital Cloakroom', job = 'ambulance'  }
}


Config.Shops = {
	{ -- 24/7
		coords = vector3(-531.14, -1221.33, 18.48),
		blip = {
			id = 52,
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Xero Gas', 
		inventory = {
			{
				name = 'burger',
				price = 10,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
			{
				name = 'bandage',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(2557.458,  382.282, 108.622),
		blip = {
			id = 52,
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = '24/7', 
		inventory = {
			{
				name = 'burger',
				price = 10,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
			{
				name = 'bandage',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(-3038.939, 585.954, 7.908),
		blip = {
			id = 52,
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = '24/7', 
		inventory = {
			{
				name = 'burger',
				price = 10,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
			{
				name = 'bandage',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(-3241.927, 1001.462, 12.830),
		blip = {
			id = 52,
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = '24/7', 
		inventory = {
			{
				name = 'burger',
				price = 10,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
			{
				name = 'bandage',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(547.431, 2671.710, 42.156),
		blip = {
			id = 52,
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = '24/7', 
		inventory = {
			{
				name = 'burger',
				price = 10,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
			{
				name = 'bandage',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(1961.464, 3740.672, 32.343),
		blip = {
			id = 52,
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = '24/7', 
		inventory = {
			{
				name = 'burger',
				price = 10,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
			{
				name = 'bandage',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(2678.916, 3280.671, 55.241),
		blip = {
			id = 52,
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = '24/7', 
		inventory = {
			{
				name = 'burger',
				price = 10,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
			{
				name = 'bandage',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(1729.216, 6414.131, 35.037),
		blip = {
			id = 52,
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = '24/7', 
		inventory = {
			{
				name = 'burger',
				price = 10,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
			{
				name = 'bandage',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(-48.519, -1757.514, 29.421),
		blip = {
			id = 52,
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Davis LTD', 
		inventory = {
			{
				name = 'burger',
				price = 10,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
			{
				name = 'bandage',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(1163.373, -323.801, 69.205),
		blip = {
			id = 52,
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Mirror Park LTD', 
		inventory = {
			{
				name = 'burger',
				price = 10,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
			{
				name = 'bandage',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(-707.501, -914.260, 19.215),
		blip = {
			id = 52,
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Little Seoul LTD', 
		inventory = {
			{
				name = 'burger',
				price = 10,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
			{
				name = 'bandage',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(-1820.523, 792.518, 138.118),
		blip = {
			id = 52,
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Richman Glen LTD', 
		inventory = {
			{
				name = 'burger',
				price = 10,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
			{
				name = 'bandage',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(1698.388, 4924.404, 42.063),
		blip = {
			id = 52,
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Grapeseed LTD', 
		inventory = {
			{
				name = 'burger',
				price = 10,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
			{
				name = 'bandage',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(25.723, -1346.966, 29.497),
		blip = {
			id = 52,
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = '24/7', 
		inventory = {
			{
				name = 'burger',
				price = 10,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
			{
				name = 'bandage',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(373.875, 325.896, 103.566),
		blip = {
			id = 52,
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = '24/7', 
		inventory = {
			{
				name = 'burger',
				price = 10,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
			{
				name = 'bandage',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(-2544.092, 2316.184, 33.2),
		blip = {
			id = 52,
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Lago Zancudo RON', 
		inventory = {
			{
				name = 'burger',
				price = 10,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
			{
				name = 'bandage',
				price = 10,
				count = 200
			},
		},
	},
	--LIQUOR
	{
		coords = vector3(1135.808, -982.281, 46.415),
		blip = {
			id = 93,
			name = "Robs Liquor",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Robs Liquor', 
		inventory = {
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(-1222.915, -906.983,  12.326),
		blip = {
			id = 93,
			name = "Robs Liquor",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Robs Liquor', 
		inventory = {
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(-1487.553, -379.107,  40.163),
		blip = {
			id = 93,
			name = "Robs Liquor",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Robs Liquor', 
		inventory = {
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(-2968.243, 390.910, 15.043),
		blip = {
			id = 93,
			name = "Robs Liquor",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Robs Liquor', 
		inventory = {
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(1166.024, 2708.930, 38.157),
		blip = {
			id = 93,
			name = "Robs Liquor",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Robs Liquor', 
		inventory = {
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(1392.562, 3604.684, 34.980),
		blip = {
			id = 93,
			name = "Robs Liquor",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Robs Liquor', 
		inventory = {
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
		},
	},
	{
		coords = vector3(-1393.409, -606.624, 30.319),
		blip = {
			id = 93,
			name = "Robs Liquor",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Robs Liquor', 
		inventory = {
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'cola',
				price = 10,
				count = 200
			},
		},
	},-- YouTOOL
	{
		coords = vector3(2748.0, 3473.0, 55.67),
		blip = {
			id = 402,
			name = "YouTool",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'YouTool', 
		inventory = {
			{
				name = 'lockpick',
				price = 200,
				count = 200,
			},
			{
				name = 'WEAPON_PETROLCAN',
				price = 100,
				count = 1,
				metadata = {}
			},
		},
	},
	{
		coords = vector3(342.99, -1298.26, 32.51),
		blip = {
			id = 402,
			name = "YouTool",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'YouTool', 
		inventory = {
			{
				name = 'lockpick',
				price = 200,
				count = 200,
			},
			{
				name = 'WEAPON_PETROLCAN',
				price = 100,
				count = 1,
				metadata = {}
			},
		},
	},
	-- Police
	{
		job = 'police',
		coords = vector3(452.40, -980.04, 30.68), -- vector3(487.235, -997.108, 30.69) for gabz
		name = 'Police Armoury',
		blip = {
			id = 110,
			name = 'Police Armoury',
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		inventory = {
			{
				name = 'keys',
				price = 15,
				count = 200,
				metadata = { type = 'lspd' }
			},
			{
				name = 'identification',
				price = 15,
				count = 200,
			},
			{
				name = 'burger',
				price = 15,
				count = 200
			},
			{
				name = 'water',
				price = 10,
				count = 200
			},
			{
				name = 'ammo-9',
				price = 250,
				count = 200
			},
			{
				name = 'ammo-50',
				price = 250,
				count = 200
			},
			{
				name = 'ammo-shotgun',
				price = 15,
				count = 200
			},
			{
				name = 'ammo-rifle',
				price = 15,
				count = 200
			},
			{
				name = 'WEAPON_STUNGUN',
				price = 150,
				count = 1,
				metadata = {
					weaponlicense = 'POL',
					weapontint = 5
				},
			},
			{
				name = 'WEAPON_COMBATPISTOL',
				price = 250,
				count = 1,
				metadata = {
					weaponlicense = 'POL',
					components = { 'flashlight' },
					weapontint = 5
				},
			},
			{
				name = 'WEAPON_PISTOL50',
				price = 400,
				count = 1,
				metadata = {
					weaponlicense = 'POL',
					components = { 'flashlight' },
					weapontint = 5
				},
			},
			{
				name = 'WEAPON_PUMPSHOTGUN',
				price = 500,
				count = 1,
				metadata = {
					weaponlicense = 'POL',
					components = { 'flashlight' },
					weapontint = 5
				},
			},
			{
				name = 'WEAPON_CARBINERIFLE',
				price = 500,
				count = 1,
				metadata = {
					weaponlicense = 'POL',
					components = { 'flashlight' },
					weapontint = 5
				},
			},
			{
				name = 'WEAPON_NIGHTSTICK',
				price = 50,
				count = 1,
				metadata = {
					weaponlicense = 'POL',
					weapontint = 5
				},
			},
			{
				name = 'WEAPON_KNIFE',
				price = 20,
				count = 1,
				metadata = {
					weaponlicense = 'POL',
					components = { 'flashlight' },
					weapontint = 5
				},
			},
			{
				name = 'WEAPON_FLASHLIGHT',
				price = 15,
				count = 1,
				metadata = {
					weaponlicense = 'POL',
					weapontint = 5
				},
			},
		},
	},--WeaponShop
	{
		coords = vector3(-662.180, -934.961, 21.829),
		blip = {
			id = 110,
			name = "Ammunation",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Ammunation', 
		license = 'weapon', 
		inventory = {
			{
				name = 'ammo-9',
				price = 250,
				count = 10
			},
			{
				name = 'WEAPON_KNIFE',
				price = 200,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_BAT',
				price = 100,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_FLASHLIGHT',
				price = 75,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_STUNGUN',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
			{
				name = 'WEAPON_PISTOL',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
		},
	},
	{
		coords = vector3(810.25, -2157.60, 29.62),
		blip = {
			id = 110,
			name = "Ammunation",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Ammunation', 
		license = 'weapon', 
		inventory = {
			{
				name = 'ammo-9',
				price = 250,
				count = 10
			},
			{
				name = 'WEAPON_KNIFE',
				price = 200,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_BAT',
				price = 100,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_FLASHLIGHT',
				price = 75,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_STUNGUN',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
			{
				name = 'WEAPON_PISTOL',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
		},
	},
	{
		coords = vector3(1693.44, 3760.16, 34.71),
		blip = {
			id = 110,
			name = "Ammunation",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Ammunation', 
		license = 'weapon', 
		inventory = {
			{
				name = 'ammo-9',
				price = 250,
				count = 10
			},
			{
				name = 'WEAPON_KNIFE',
				price = 200,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_BAT',
				price = 100,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_FLASHLIGHT',
				price = 75,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_STUNGUN',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
			{
				name = 'WEAPON_PISTOL',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
		},
	},
	{
		coords = vector3(-330.24, 6083.88, 31.45),
		blip = {
			id = 110,
			name = "Ammunation",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Ammunation', 
		license = 'weapon', 
		inventory = {
			{
				name = 'ammo-9',
				price = 250,
				count = 10
			},
			{
				name = 'WEAPON_KNIFE',
				price = 200,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_BAT',
				price = 100,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_FLASHLIGHT',
				price = 75,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_STUNGUN',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
			{
				name = 'WEAPON_PISTOL',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
		},
	},
	{
		coords = vector3(252.63, -50.00, 69.94),
		blip = {
			id = 110,
			name = "Ammunation",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Ammunation', 
		license = 'weapon', 
		inventory = {
			{
				name = 'ammo-9',
				price = 250,
				count = 10
			},
			{
				name = 'WEAPON_KNIFE',
				price = 200,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_BAT',
				price = 100,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_FLASHLIGHT',
				price = 75,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_STUNGUN',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
			{
				name = 'WEAPON_PISTOL',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
		},
	},
	{
		coords = vector3(22.56, -1109.89, 29.80),
		blip = {
			id = 110,
			name = "Ammunation",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Ammunation', 
		license = 'weapon', 
		inventory = {
			{
				name = 'ammo-9',
				price = 250,
				count = 10
			},
			{
				name = 'WEAPON_KNIFE',
				price = 200,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_BAT',
				price = 100,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_FLASHLIGHT',
				price = 75,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_STUNGUN',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
			{
				name = 'WEAPON_PISTOL',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
		},
	},
	{
		coords = vector3(2567.69, 294.38, 108.73),
		blip = {
			id = 110,
			name = "Ammunation",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Ammunation', 
		license = 'weapon', 
		inventory = {
			{
				name = 'ammo-9',
				price = 250,
				count = 10
			},
			{
				name = 'WEAPON_KNIFE',
				price = 200,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_BAT',
				price = 100,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_FLASHLIGHT',
				price = 75,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_STUNGUN',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
			{
				name = 'WEAPON_PISTOL',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
		},
	},
	{
		coords = vector3(-1117.58, 2698.61, 18.55),
		blip = {
			id = 110,
			name = "Ammunation",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Ammunation', 
		license = 'weapon', 
		inventory = {
			{
				name = 'ammo-9',
				price = 250,
				count = 10
			},
			{
				name = 'WEAPON_KNIFE',
				price = 200,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_BAT',
				price = 100,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_FLASHLIGHT',
				price = 75,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_STUNGUN',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
			{
				name = 'WEAPON_PISTOL',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
		},
	},
	{
		coords = vector3(842.44, -1033.42, 28.19),
		blip = {
			id = 110,
			name = "Ammunation",
			color = 5,
			scale = 0.6,
		},
		text = 'E - Open Shop',
		name = 'Ammunation', 
		license = 'weapon', 
		inventory = {
			{
				name = 'ammo-9',
				price = 250,
				count = 10
			},
			{
				name = 'WEAPON_KNIFE',
				price = 200,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_BAT',
				price = 100,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_FLASHLIGHT',
				price = 75,
				count = 1,
				metadata = {}
			},
			{
				name = 'WEAPON_STUNGUN',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
			{
				name = 'WEAPON_PISTOL',
				price = 1000,
				count = 1,
				metadata = { registered = 'setname' },
			},
		},
	},
}


Config.Ammos = {
	['ammo-38'] = { -- .38 long colt
		`WEAPON_DOUBLEACTION`
	},

	['ammo-44'] = { -- .44 magnum
		`WEAPON_REVOLVER`,
		`WEAPON_REVOLVER_MK2`
	},

	['ammo-45'] = { -- 45 acp
		`WEAPON_GUSENBERG`,
		`WEAPON_HEAVYPISTOL`,
		`WEAPON_MICROSMG`,
		`WEAPON_SNSPISTOL`,
		`WEAPON_SNSPISTOL_MK2`
	},

	['ammo-9'] = { -- 9mm variants (parabellum, makarov, etc)
		`WEAPON_APPISTOL`,
		`WEAPON_COMBATPDW`,
		`WEAPON_COMBATPISTOL`,
		`WEAPON_MACHINEPISTOL`,
		`WEAPON_MINISMG`,
		`WEAPON_PISTOL`,
		`WEAPON_PISTOL_MK2`,
		`WEAPON_SMG`,
		`WEAPON_SMG_MK2`,
		`WEAPON_VINTAGEPISTOL`
	},

	['ammo-flare'] = {
		`WEAPON_FLAREGUN`
	},

	['ammo-musket'] = {
		`WEAPON_MUSKET`
	},

	['ammo-rifle'] = { -- 5.56
		`WEAPON_ADVANCEDRIFLE`,
		`WEAPON_ASSAULTSMG`,
		`WEAPON_BULLPUPRIFLE`,
		`WEAPON_BULLPUPRIFLE_MK2`,
		`WEAPON_CARBINERIFLE`,
		`WEAPON_CARBINERIFLE_MK2`,
		`WEAPON_COMBATMG`,
		`WEAPON_SPECIALCARBINE`,
		`WEAPON_SPECIALCARBINE_MK2`,
	},

	['ammo-rifle2'] = { -- 7.62 soviet
		`WEAPON_ASSAULTRIFLE`,
		`WEAPON_ASSAULTRIFLE_MK2`,
		`WEAPON_COMBATMG_MK2`,
		`WEAPON_COMPACTRIFLE`,
		`WEAPON_MG`,
	},

	['ammo-22'] = { -- .22 long rifle
		`WEAPON_MARKSMANPISTOL`
	},

	['ammo-50'] = { -- .50 action express
		`WEAPON_PISTOL50`
	},

	['ammo-sniper'] = { -- 7.62 NATO
		`WEAPON_MARKSMANRIFLE`,
		`WEAPON_MARKSMANRIFLE_MK2`,
		`WEAPON_SNIPERRIFLE`
	},

	['ammo-heavysniper'] = { -- .50 BMG
		`WEAPON_HEAVYSNIPER`,
		`WEAPON_HEAVYSNIPER_MK2`
	},

	['ammo-shotgun'] = { -- 12 gauge
		`WEAPON_ASSAULTSHOTGUN`,
		`WEAPON_BULLPUPSHOTGUN`,
		`WEAPON_DBSHOTGUN`,
		`WEAPON_HEAVYSHOTGUN`,
		`WEAPON_PUMPSHOTGUN`,
		`WEAPON_PUMPSHOTGUN_MK2`,
		`WEAPON_SAWNOFFSHOTGUN`,
		`WEAPON_SWEEPERSHOTGUN`
	},
}
