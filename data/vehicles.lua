return {
	-- 0	vehicle has no storage
	-- 1	vehicle storage in the hood
	Storage = {
		[`jester`] = 1,
		[`adder`] = 1,
		[`osiris`] = 0,
		[`pfister811`] = 0,
		[`penetrator`] = 0,
		[`autarch`] = 0,
		[`bullet`] = 0,
		[`cheetah`] = 0,
		[`cyclone`] = 0,
		[`voltic`] = 0,
		[`reaper`] = 1,
		[`entityxf`] = 0,
		[`t20`] = 0,
		[`taipan`] = 0,
		[`tezeract`] = 0,
		[`torero`] = 1,
		[`turismor`] = 0,
		[`fmj`] = 0,
		[`infernus `] = 0,
		[`italigtb`] = 1,
		[`italigtb2`] = 1,
		[`nero2`] = 0,
		[`vacca`] = 1,
		[`vagner`] = 0,
		[`visione`] = 0,
		[`prototipo`] = 0,
		[`zentorno`] = 0
	},

	-- slots, maxWeight; default weight is 8000 per slot
	glovebox = {	
		[0] = {11, 88000},		-- Compact
		[1] = {11, 88000},		-- Sedan
		[2] = {11, 88000},		-- SUV
		[3] = {11, 88000},		-- Coupe
		[4] = {11, 88000},		-- Muscle
		[5] = {11, 88000},		-- Sports Classic
		[6] = {11, 88000},		-- Sports
		[7] = {11, 88000},		-- Super
		[8] = {5, 40000},		-- Motorcycle
		[9] = {11, 88000},		-- Offroad
		[10] = {11, 88000},		-- Industrial
		[11] = {11, 88000},		-- Utility
		[12] = {11, 88000},		-- Van
		[14] = {31, 248000},	-- Boat
		[15] = {31, 248000},	-- Helicopter
		[16] = {51, 408000},	-- Plane
		[17] = {11, 88000},		-- Service
		[18] = {11, 88000},		-- Emergency
		[19] = {11, 88000},		-- Military
		[20] = {11, 88000},		-- Commercial (trucks)
		['models'] = {
			[`xa21`] = {11, 88000}
		}
	},

	trunk = {
		[0] = {21, 168000},		-- Compact
		[1] = {41, 328000},		-- Sedan
		[2] = {51, 408000},		-- SUV
		[3] = {31, 248000},		-- Coupe
		[4] = {41, 328000},		-- Muscle
		[5] = {31, 248000},		-- Sports Classic
		[6] = {31, 248000},		-- Sports
		[7] = {21, 168000},		-- Super
		[8] = {5, 40000},		-- Motorcycle
		[9] = {51, 408000},		-- Offroad
		[10] = {51, 408000},	-- Industrial
		[11] = {41, 328000},	-- Utility
		[12] = {61, 488000},	-- Van
		-- [14] -- Boat
		-- [15] -- Helicopter
		-- [16] -- Plane
		[17] = {41, 328000},	-- Service
		[18] = {41, 328000},	-- Emergency
		[19] = {41, 328000},	-- Military
		[20] = {61, 488000},	-- Commercial
		['models'] = {
			[`xa21`] = {11, 10000}
		}
	}
}
