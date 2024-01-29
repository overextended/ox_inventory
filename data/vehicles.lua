return {
    -- 0    vehicle has no storage
    -- 1    vehicle has no trunk storage
    -- 2    vehicle has no glovebox storage
    -- 3    vehicle has trunk in the hood
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
        [`rmodr8alpil`] = 3,
        [`rmodr8c`] = 3,
        [`rmodspeed`] = 3,
        [`rmodr8v10`] = 3,
        [`rmodatlantic`] = 3,
        [`rmodporsche918`] = 3,
        [`rmod918spyder`] = 3,
        [`rmodchiron300`] = 3,
        [`rmodbugatti`] = 3,
        [`rmodlfa`] = 3,
        [`rmodlp670`] = 3,
        [`rmodf40`] = 3,
        [`rmodsennagtr`] = 3,
        [`rmodsianr`] = 3,
        [`rmodjesko`] = 3,
        [`rmod911gtrsr`] = 3,
        [`rmodamgone`] = 3,
        [`rmodgemera`] = 3,
        [`rmodlaferrari`] = 3,
        [`rmodtaycan`] = 3,
        [`mansc8`] = 3,
        [`pgt322`] = 3,
        [`hurady`] = 3,
        [`rmodc63amg`] = 3,
    },

    -- slots, maxWeight; default weight is 8000 per slot
    glovebox = {
        [0] = {4, 30000},        -- Compact
        [1] = {4, 30000},        -- Sedan
        [2] = {4, 30000},        -- SUV
        [3] = {4, 30000},        -- Coupe
        [4] = {4, 30000},        -- Muscle
        [5] = {4, 30000},        -- Sports Classic
        [6] = {4, 30000},        -- Sports
        [7] = {1, 30000},        -- Super
        [8] = {1, 10000},        -- Motorcycle
        [9] = {5, 30000},        -- Offroad
        [10] = {5, 30000},        -- Industrial
        [11] = {5, 30000},        -- Utility
        [12] = {5, 30000},        -- Van
        [14] = {4, 30000},    -- Boat
        [15] = {12, 80000},    -- Helicopter
        [16] = {51, 408000},    -- Plane
        [17] = {5, 30000},        -- Service
        [18] = {4, 30000},        -- Emergency
        [19] = {5, 30000},        -- Military
        [20] = {5, 30000},        -- Commercial (trucks)
        models = {
            [`xa21`] = {11, 30000},
            [`nspeedo`] = {10, 30000},
        }
    },

    trunk = {
        [0] = {10, 40000},        -- Compact
        [1] = {15, 60000},        -- Sedan
        [2] = {20, 65000},        -- SUV
        [3] = {10, 60000},        -- Coupe
        [4] = {10, 50000},        -- Muscle
        [5] = {10, 45000},        -- Sports Classic
        [6] = {10, 50000},        -- Sports
        [7] = {6, 35000},        -- Super
        [8] = {5, 20000},        -- Motorcycle
        [9] = {15, 65000},        -- Offroad
        [10] = {20, 200000},    -- Industrial
        [11] = {40, 200000},    -- Utility
        [12] = {25, 100000},    -- Van
        -- [14] -- Boat
        -- [15] -- Helicopter
        -- [16] -- Plane
        [17] = {15, 70000},    -- Service
        [18] = {15, 70000},    -- Emergency
        [19] = {15, 70000},    -- Military
        [20] = {40, 150000},    -- Commercial
        models = {
            [`xa21`] = {11, 10000},
            [`nspeedo`] = {30, 100000},
            [`nmule`] = {45, 200000},
            [`f450rw`] = {30, 100000},
            [`outlaw`] = {5, 30000},
        },
        boneIndex = {
            [`pounder`] = 'wheel_rr',
            [`rubble`] = 'wheel_rr',
            [`tiptruck`] = 'wheel_rr',
            [`tiptruck2`] = 'wheel_rr',
            [`mixer`] = 'wheel_rr',
            [`mixer2`] = 'wheel_rr',
            [`judge`] = 'wheel_rr',
            [`22b`] = 'wheel_rr',
            [`outlaw`] = 'wheel_rr'
        }
    }
}