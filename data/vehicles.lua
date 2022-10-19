return {
    -- 0	vehicle has no storage
    -- 1	vehicle has no trunk storage
    -- 2	vehicle has no glovebox storage
    -- 3	vehicle has trunk in the hood
    Storage = {
        [`jester`] = 3,
        [`adder`] = 3,
        [`osiris`] = 1,
        [`pfister811`] = 1,
        [`penetrator`] = 1,
        [`autarch`] = 1,
        [`bullet`] = 1,
        [`cheetah`] = 1,
        [`cyclone`] = 1,
        [`voltic`] = 1,
        [`reaper`] = 3,
        [`entityxf`] = 1,
        [`t20`] = 1,
        [`taipan`] = 1,
        [`tezeract`] = 1,
        [`torero`] = 3,
        [`turismor`] = 1,
        [`fmj`] = 1,
        [`infernus`] = 1,
        [`italigtb`] = 3,
        [`italigtb2`] = 3,
        [`nero2`] = 1,
        [`vacca`] = 3,
        [`vagner`] = 1,
        [`visione`] = 1,
        [`prototipo`] = 1,
        [`zentorno`] = 1,
        [`trophytruck`] = 0,
        [`trophytruck2`] = 0,
    },

    -- slots, maxWeight; default weight is 8000 per slot
    glovebox = {
        [0] = { 5, 10000 }, -- Compact
        [1] = { 5, 10000 }, -- Sedan
        [2] = { 5, 10000 }, -- SUV
        [3] = { 5, 10000 }, -- Coupe
        [4] = { 5, 10000 }, -- Muscle
        [5] = { 5, 10000 }, -- Sports Classic
        [6] = { 5, 10000 }, -- Sports
        [7] = { 5, 10000 }, -- Super
        -- [8] = { 3, 5000 }, -- Motorcycle
        [9] = { 5, 10000 }, -- Offroad
        [10] = { 5, 10000 }, -- Industrial
        [11] = { 5, 10000 }, -- Utility
        [12] = { 5, 10000 }, -- Van
        [14] = { 31, 248000 }, -- Boat
        [15] = { 31, 248000 }, -- Helicopter
        [16] = { 51, 408000 }, -- Plane
        [17] = { 5, 10000 }, -- Service
        [18] = { 5, 10000 }, -- Emergency
        [19] = { 5, 10000 }, -- Military
        [20] = { 5, 10000 }, -- Commercial (trucks)
        models = {
            [`xa21`] = { 11, 88000 }
        }
    },

    trunk = {
        [0] = { 10, 75000 }, -- Compact
        [1] = { 15, 75000 }, -- Sedan
        [2] = { 25, 150000 }, -- SUV
        [3] = { 12, 75000 }, -- Coupe
        [4] = { 12, 75000 }, -- Muscle
        [5] = { 12, 75000 }, -- Sports Classic
        [6] = { 10, 50000 }, -- Sports
        [7] = { 5, 10000 }, -- Super
        [8] = { 3, 5000 }, -- Motorcycle
        [9] = { 15, 100000 }, -- Offroad
        [10] = { 75, 750000 }, -- Industrial
        [11] = { 30, 500000 }, -- Utility
        [12] = { 25, 150000 }, -- Van
        -- [14] -- Boat
        -- [15] -- Helicopter
        -- [16] -- Plane
        [17] = { 20, 100000 }, -- Service
        [18] = { 20, 100000 }, -- Emergency
        [19] = { 75, 750000 }, -- Military
        [20] = { 100, 1000000 }, -- Commercial
        models = {
            [`xa21`] = { 11, 10000 }
        },
        boneIndex = {
            [`pounder`] = 'wheel_rr'
        }
    }
}
