-- Hook in for mod

-- Table of multipliers used by the mass-driven veterancy system
-- Subsection key:
--      1 = COMBAT
--      2 = RAIDER
--      3 = SHIP
--      4 = SUB
MultsTable = {
    VETERANCYREGEN = {
        TECH1 = {
            {1, 3, 6, 10, 15},
            2,
            {2, 6, 12, 20, 30},
            4,
        },
        TECH2 = {
            {2, 6, 12, 20, 30},
            4,
            {3, 9, 18, 30, 45},
            6,
        },
        TECH3 = {
            {3, 9, 18, 30, 45},
            6,
            {12, 36, 72, 120, 180},
            12,
        },
        EXPERIMENTAL = {12, 36, 72, 120, 180},
        COMMAND = 5,
        SUBCOMMANDER = {4, 12, 24, 40, 60},
    },
    VETERANCYMAXHEALTH = {
        TECH1 = 1.2,
        TECH2 = 1.2,
        TECH3 = 1.2,
        EXPERIMENTAL = 1.2,
        COMMAND = 1.2,
        SUBCOMMANDER = 1.2,
    },
}

-- This substitutes for the fact we don't have a blueprint filler. Yes, I know it's a mess.
TypeTable = {
-- This first section, the unit's don't have a type, but are here to register they need veterancy
-- tracking in OnStopBeingBuilt
    UAL0001,
    UEL0001,
    URL0001,
    XSL0001,
    
    UAL0301,
    UEL0301,
    URL0301,
    XSL0301,
    
    XAB1401,
    UAA0310,
    UAL0401,
    UAS0401,
    UEB2401,
    UEL0401,
    UES0401,
    URA0401,
    URL0402,
    XRL0403,
    XSB2401,
    XSA0402,
    XSL0401,
    
-- Now for the units which do need typing
-- COMBAT
    -- PD
    UAB2101 = 1
    UEB2101 = 1
    URB2101 = 1
    XSB2101 = 1
    UAB2301
    UEB2301
    URB2301
    XSB2301
    -- AA
    UAB2104 = 1
    UEB2104 = 1
    URB2104 = 1
    XSB2104 = 1
    UAB2204
    UEB2204
    URB2204
    XSB2204
    -- Torp
    UAB2109 = 1
    UEB2109 = 1
    URB2109 = 1
    XSB2109 = 1
    UAB2205
    UEB2205
    URB2205
    XSB2205
    -- Bomber
    UAA0103 = 1
    UEA0103 = 1
    URA0103 = 1
    XSA0103 = 1
    -- Jester
    XRA0105 = 1
    -- Tanks
    UAL0201 = 1
    UEL0201 = 1
    URL0107 = 1
    XSL0201 = 1
    -- T2 F/B
    XAA0202
    DEA0202
    DRA0202
    XSA0202
    -- T2 Gunship
    UAA0203
    UEA0203
    URA0203
    XSA0203
    -- ASF
    UAA0303
    UEA0303
    URA0303
    XSA0303
    -- Strats
    UAA0304
    UEA0304
    URA0304
    XSA0304
    -- T3 Gunship
    XAA0305
    XRA0305
    UEA0305
    
-- RAIDER
    -- Intie
    UAA0102 = 2
    UEA0102 = 2
    URA0102 = 2
    XSA0102 = 2
    -- Scout
    UAL0101 = 2
    UEL0101 = 2
    XSL0101 = 2
    -- Arty
    UAL0103 = 2
    UEL0103 = 2
    URL0103 = 2
    XSL0103 = 2
    -- LAB
    UAL0106 = 2
    UEL0106 = 2
    URL0106 = 2
    -- MAA
    UAL0104 = 2
    UEL0104 = 2
    URL0104 = 2
    XSL0104 = 2
    -- T2 Arty
    UAB2303
    UEB2303
    URB2303
    XSB2303
    -- TML
    UAB2108
    UEB2108
    URB2108
    XSB2108
    -- T2 Transports
    UAA0104
    UEA0104
    URA0104
    XSA0104
    -- Torp Bombers
    UAA0204
    UEA0204
    URA0204
    XSA0204
    XAA0306
    
    
    
    -- Cont
    XEA0306
    
-- SHIP
    UAS0102 = 3
    UAS0103 = 3
    UES0103 = 3
    URS0103 = 3
    XSS0103 = 3
    
-- SUB
    UAS0203 = 4
    UES0203 = 4
    URS0203 = 4
    XSS0203 = 4
}