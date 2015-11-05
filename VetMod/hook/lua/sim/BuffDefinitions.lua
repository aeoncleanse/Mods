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
            {4, 12, 24, 40, 60},
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
    ual0001 = 6,
    uel0001 = 6,
    url0001 = 6,
    xsl0001 = 6,
    
    ual0301 = 5,
    uel0301 = 5,
    url0301 = 5,
    xsl0301 = 5,
    
    xab1401 = 5,
    uaa0310 = 5,
    ual0401 = 5,
    uas0401 = 5,
    ueb2401 = 5,
    uel0401 = 5,
    ues0401 = 5,
    ura0401 = 5,
    url0402 = 5,
    xrl0403 = 5,
    xsb2401 = 5,
    xsa0402 = 5,
    xsl0401 = 5,
    
-- Now for the units which do need typing
-- COMBAT
    -- PD
    uab2101 = 1,
    ueb2101 = 1,
    urb2101 = 1,
    xsb2101 = 1,
    uab2301 = 1,
    ueb2301 = 1,
    urb2301 = 1,
    xsb2301 = 1,
    xeb2306 = 1,
    -- AA
    uab2104 = 1,
    ueb2104 = 1,
    urb2104 = 1,
    xsb2104 = 1,
    uab2204 = 1,
    ueb2204 = 1,
    urb2204 = 1,
    xsb2204 = 1,
    uab2304 = 1,
    ueb2304 = 1,
    urb2304 = 1,
    xsb2304 = 1,
    -- Torp
    uab2109 = 1,
    ueb2109 = 1,
    urb2109 = 1,
    xsb2109 = 1,
    uab2205 = 1,
    ueb2205 = 1,
    urb2205 = 1,
    xsb2205 = 1,
    xrb2308 = 1,
    -- Bomber
    uaa0103 = 1,
    uea0103 = 1,
    ura0103 = 1,
    xsa0103 = 1,
    -- Jester
    xra0105 = 1,
    -- Tanks
    ual0201 = 1,
    uel0201 = 1,
    url0107 = 1,
    xsl0201 = 1,
    ual0202 = 1,
    uel0202 = 1,
    url0202 = 1,
    xsl0202 = 1,
    ual0303 = 1,
    xel0305 = 1,
    xrl0305 = 1,
    xsl0303 = 1,
    -- T2 F/B
    dea0202 = 1,
    dra0202 = 1,
    xsa0202 = 1,
    -- T2 Gunship
    uaa0203 = 1,
    uea0203 = 1,
    ura0203 = 1,
    xsa0203 = 1,
    -- Strats
    uaa0304 = 1,
    uea0304 = 1,
    ura0304 = 1,
    xsa0304 = 1,
    -- T3 Gunship
    xaa0305 = 1,
    xra0305 = 1,
    uea0305 = 1,
    
-- RAIDER
    -- Hovertanks
    xal0203 = 2,
    uel0203 = 2,
    url0203 = 2,
    xsl0203 = 2,
    -- Intie
    uaa0102 = 2,
    uea0102 = 2,
    ura0102 = 2,
    xsa0102 = 2,
    xaa0202 = 2,
    uaa0303 = 2,
    uea0303 = 2,
    ura0303 = 2,
    xsa0303 = 2,
    -- Land Scout
    ual0101 = 2,
    uel0101 = 2,
    xsl0101 = 2,
    -- Mobile Arty
    ual0103 = 2,
    uel0103 = 2,
    url0103 = 2,
    xsl0103 = 2,
    ual0111 = 2,
    uel0111 = 2,
    url0111 = 2,
    xsl0111 = 2,
    ual0304 = 2,
    uel0304 = 2,
    url0304 = 2,
    xsl0304 = 2,
    xel0306 = 2,
    xal0305 = 2,
    xsl0305 = 2,
    dal0310 = 2,
    -- Raid Bots
    drl0204 = 2,
    del0204 = 2,
    -- LAB
    ual0106 = 2,
    uel0106 = 2,
    url0106 = 2,
    -- MAA
    ual0104 = 2,
    uel0104 = 2,
    url0104 = 2,
    xsl0104 = 2,
    ual0205 = 2,
    uel0205 = 2,
    url0205 = 2,
    xsl0205 = 2,
    drlk001 = 2,
    dslk004 = 2,
    dalk003 = 2,
    delk002 = 2,
    -- T2 Arty
    uab2303 = 2,
    ueb2303 = 2,
    urb2303 = 2,
    xsb2303 = 2,
    -- T3 Arty
    uab2302 = 2,
    ueb2302 = 2,
    urb2302 = 2,
    xsb2302 = 2,
    xab2307 = 2,
    -- Nukes
    uab2305 = 2,
    ueb2305 = 2,
    urb2305 = 2,
    xsb2305 = 2,
    -- TML
    uab2108 = 2,
    ueb2108 = 2,
    urb2108 = 2,
    xsb2108 = 2,
    -- Transports
    uaa0104 = 2,
    uea0104 = 2,
    ura0104 = 2,
    xsa0104 = 2,
    xea0306 = 2,
    -- Torp Bombers
    uaa0204 = 2,
    uea0204 = 2,
    ura0204 = 2,
    xsa0204 = 2,
    xaa0306 = 2,
    --T3 Bots
    UEL0303 = 2,
    URL0303 = 2,
    
-- SHIP
    uas0102 = 3,
    uas0103 = 3,
    ues0103 = 3,
    urs0103 = 3,
    xss0103 = 3,
    uas0201 = 3,
    ues0201 = 3,
    urs0201 = 3,
    xss0201 = 3,
    uas0202 = 3,
    ues0202 = 3,
    urs0202 = 3,
    xss0202 = 3,
    xes0102 = 3,
    uas0302 = 3,
    ues0302 = 3,
    urs0302 = 3,
    xss0302 = 3,
    uas0303 = 3,
    urs0303 = 3,
    xss0303 = 3,
    xas0306 = 3,
    xes0307 = 3,
-- SUB
    uas0203 = 4,
    ues0203 = 4,
    urs0203 = 4,
    xss0203 = 4,
    xas0204 = 4,
    xrs0204 = 4,
    xss0304 = 4,
    uas0304 = 4,
    ues0304 = 4,
    urs0304 = 4,
}
