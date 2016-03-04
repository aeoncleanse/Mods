----------------------------------------------------------------------
-- File     :  /data/lua/EffectTemplates.lua
-- Author(s):  Gordon Duclos, Greg Kohne, Matt Vainio, Aaron Lundquist
-- Summary  :  Generic templates for commonly used effects
-- Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
----------------------------------------------------------------------

EmtBpPath = '/effects/emitters/'
EmitterTempEmtBpPath = '/effects/emitters/temp/'
EXBlackopsBpPath = '/mods/BlackOpsACUs/effects/emitters/'

-- Overrides the Unleashed one
ACUAntiMatter01 = {
    EXBlackopsBpPath .. 'examc_flash_01_emit.bp',
    EXBlackopsBpPath .. 'examc_hit_01_emit.bp',
    EXBlackopsBpPath .. 'examc_hit_02_emit.bp',
    EXBlackopsBpPath .. 'examc_hit_03_emit.bp',
    EXBlackopsBpPath .. 'examc_hit_04_emit.bp',
    EXBlackopsBpPath .. 'examc_hit_05_emit.bp',
    EXBlackopsBpPath .. 'examc_hit_07_emit.bp',
    EXBlackopsBpPath .. 'examc_hit_08_emit.bp',
    EXBlackopsBpPath .. 'examc_ring_01_emit.bp',
    EXBlackopsBpPath .. 'examc_ring_02_emit.bp',
    EXBlackopsBpPath .. 'examc_ring_03_emit.bp',
    EXBlackopsBpPath .. 'examc_ring_04_emit.bp',
    EXBlackopsBpPath .. 'examc_shoackwave_01_emit.bp',
}

-- UEF ACU Gattling Cannon
UEFACUHeavyPlasmaGatlingCannonMuzzleFlash = {
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_01_emit.bp',
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_02_emit.bp',
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_03_emit.bp',
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_05_emit.bp',
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_06_emit.bp',
}

-- Serephim Quantum Storm
SeraACUQuantumStormProjectileHit01 = {
    EXBlackopsBpPath .. 'seraphim_experimental_phasonproj_hit_01_emit.bp', -- small blue flash
    EXBlackopsBpPath .. 'seraphim_experimental_phasonproj_hit_02_emit.bp', -- flash
    EXBlackopsBpPath .. 'seraphim_experimental_phasonproj_hit_03_emit.bp', -- shockwave
    EXBlackopsBpPath .. 'seraphim_experimental_phasonproj_hit_04_emit.bp', -- dark glow
    EXBlackopsBpPath .. 'seraphim_experimental_phasonproj_hit_05_emit.bp', -- blue glow
    EXBlackopsBpPath .. 'seraphim_experimental_phasonproj_hit_06_emit.bp', -- blue shockwave
    EXBlackopsBpPath .. 'seraphim_experimental_phasonproj_hit_07_emit.bp', -- blue Spikes
    EXBlackopsBpPath .. 'seraphim_experimental_phasonproj_hit_08_emit.bp', -- dark mist
    EXBlackopsBpPath .. 'seraphim_experimental_phasonproj_hit_09_emit.bp', -- blue sparks
    EXBlackopsBpPath .. 'seraphim_experimental_phasonproj_hit_10_emit.bp', -- lightning
}

SeraACUQuantumStormProjectileHit02 = {
    EmtBpPath .. 'seraphim_experimental_phasonproj_hitunit_01_emit.bp',
    EmtBpPath .. 'seraphim_experimental_phasonproj_hitunit_08_emit.bp',
}
SeraACUQuantumStormProjectileHitUnit = table.concatenate(SeraACUQuantumStormProjectileHit01, SeraACUQuantumStormProjectileHit02)

-- Serephim Rapid Cannon
SeraACURapidCannonPoly = {
    EXBlackopsBpPath .. 'seraphim_aireau_autocannon_polytrail_01_emit.bp',
    EXBlackopsBpPath .. 'seraphim_aireau_autocannon_polytrail_02_emit.bp',
    EXBlackopsBpPath .. 'seraphim_aireau_autocannon_polytrail_03_emit.bp',
}

SeraACURapidCannonPoly02 = {
    EXBlackopsBpPath .. 'seraphim_aireau_autocannon_polytrail_04_emit.bp',
    EXBlackopsBpPath .. 'seraphim_aireau_autocannon_polytrail_05_emit.bp',
    EXBlackopsBpPath .. 'seraphim_aireau_autocannon_polytrail_06_emit.bp',
}

SeraACURapidCannonPoly03 = {
    EXBlackopsBpPath .. 'seraphim_aireau_autocannon_polytrail_07_emit.bp',
    EXBlackopsBpPath .. 'seraphim_aireau_autocannon_polytrail_08_emit.bp',
    EXBlackopsBpPath .. 'seraphim_aireau_autocannon_polytrail_09_emit.bp',
}

-- Cybran EMP Array
CybranACUEMPArrayHit01 = {
    EXBlackopsBpPath .. 'exemp_flash_01_emit.bp',
    EXBlackopsBpPath .. 'exemp_flash_02_emit.bp',
    EXBlackopsBpPath .. 'exemp_flash_03_emit.bp',
    EXBlackopsBpPath .. 'exemp_hit_01_emit.bp',
    EXBlackopsBpPath .. 'exemp_hit_02_emit.bp',
    EXBlackopsBpPath .. 'exemp_hit_03_emit.bp',
    EXBlackopsBpPath .. 'exemp_hit_04_emit.bp',
    EXBlackopsBpPath .. 'exemp_hit_05_emit.bp',
    EXBlackopsBpPath .. 'exemp_hit_06_emit.bp',
    EXBlackopsBpPath .. 'exemp_implosion_01_emit.bp',
    EXBlackopsBpPath .. 'exemp_shockwave_01_emit.bp',
    EXBlackopsBpPath .. 'exemp_shockwave_02_emit.bp',
    EXBlackopsBpPath .. 'exemp_shockwave_03_emit.bp',
    EXBlackopsBpPath .. 'exemp_shockwave_07_emit.bp',
}

CybranACUEMPArrayHit02 = {
    EXBlackopsBpPath .. 'exemp_shockwave_04_emit.bp',
    EXBlackopsBpPath .. 'exemp_shockwave_05_emit.bp',
}

-- UEF Gatling Projectiles
UEFHeavyPlasmaGatlingCannon03PolyTrail = EXBlackopsBpPath .. 'exgc_l1upgrade_polytrail_01_emit.bp'
UEFHeavyPlasmaGatlingCannon01PolyTrail = EXBlackopsBpPath .. 'exgc_l2upgrade_polytrail_01_emit.bp'
UEFHeavyPlasmaGatlingCannon02PolyTrail = EXBlackopsBpPath .. 'exgc_l3upgrade_polytrail_01_emit.bp'

-- UEF Cruise Missile 01
UEFCruiseMissile01Trails = {
    EmtBpPath .. 'missile_sam_munition_trail_01_emit.bp',
    EmtBpPath .. 'missile_munition_trail_02_emit.bp',
}

-- Sat Death
SatDeathSmoke = {EXBlackopsBpPath .. 'sat_death_smoke_emit.bp',}
SatDamageFire01 = {
    EmtBpPath .. 'destruction_damaged_fire_01_emit.bp',
    EmtBpPath .. 'destruction_damaged_fire_distort_01_emit.bp',
}

SatDeathEffectsPackage = table.concatenate(SatDeathSmoke, SatDamageFire01)
