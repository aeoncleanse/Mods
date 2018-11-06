
-- Platoon template for Hydrocarbon Power Plant upgrade.
-- called from AIBuilders

PlatoonTemplate {
    Name = 'T1PowerHydroUpgrade',
    Plan = 'UnitUpgradeAI',
    GlobalSquads = {
        {categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH1, 1, 1, 'support', 'None'},
    }
}
PlatoonTemplate {
    Name = 'T2PowerHydroUpgrade',
    Plan = 'UnitUpgradeAI',
    GlobalSquads = {
        {categories.HYDROCARBON * categories.ENERGYPRODUCTION * categories.TECH2, 1, 1, 'support', 'None'},
    }
}


-- StructureUpgradeTemplates for Hydrocarbon Power Plant upgrade.
-- called from platoon.lua -> UnitUpgradeAI()

-- earth structure upgrades
table.insert(StructureUpgradeTemplates[1], {'ueb1102', 'beb1202'}) -- Hydrocarbon Power Plant. Upgrade from TECH1 to TECH2
table.insert(StructureUpgradeTemplates[1], {'beb1202', 'beb1302'}) -- Hydrocarbon Power Plant. Upgrade from TECH2 to TECH3
-- alien structure upgrades
table.insert(StructureUpgradeTemplates[2], {'uab1102', 'bab1202'}) -- Hydrocarbon Power Plant. Upgrade from TECH1 to TECH2
table.insert(StructureUpgradeTemplates[2], {'bab1202', 'bab1302'}) -- Hydrocarbon Power Plant. Upgrade from TECH2 to TECH3
-- recycler structure upgrades
table.insert(StructureUpgradeTemplates[3], {'urb1102', 'brb1202'}) -- Hydrocarbon Power Plant. Upgrade from TECH1 to TECH2
table.insert(StructureUpgradeTemplates[3], {'brb1202', 'brb1302'}) -- Hydrocarbon Power Plant. Upgrade from TECH2 to TECH3
-- seraphim structure upgrades
table.insert(StructureUpgradeTemplates[4], {'xsb1102', 'bsb1202'}) -- Hydrocarbon Power Plant. Upgrade from TECH1 to TECH2
table.insert(StructureUpgradeTemplates[4], {'bsb1202', 'bsb1302'}) -- Hydrocarbon Power Plant. Upgrade from TECH2 to TECH3
