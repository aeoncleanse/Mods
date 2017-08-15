-- Yenzotha Drone

local AirDroneUnit = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsunits.lua').AirDroneUnit
local YenzothaExperimentalLaser02 = import ('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsWeapons.lua').YenzothaExperimentalLaser02

BSA0004 = Class(AirDroneUnit) {

    Weapons = {
        EyeWeapon01 = Class(YenzothaExperimentalLaser02) {},
    },

    ContrailEffects = {'/effects/emitters/contrail_ser_polytrail_01_emit.bp'}

}

TypeClass = BSA0004
