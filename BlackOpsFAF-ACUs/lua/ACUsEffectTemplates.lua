----------------------------------------------------------------------
-- File     :  /data/lua/EffectTemplates.lua
-- Author(s):  Gordon Duclos, Greg Kohne, Matt Vainio, Aaron Lundquist
-- Summary  :  Generic templates for commonly used effects
-- Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
----------------------------------------------------------------------

EmtBpPath = '/effects/emitters/'
EmtBpPathAlt = '/mods/BlackOpsFAF-ACUs/effects/emitters/'

OmegaOverChargeLandHit = {
    EmtBpPath .. 'seraphim_chronotron_cannon_overcharge_projectile_hit_01_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_overcharge_projectile_hit_02_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_overcharge_projectile_hit_03_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_overcharge_projectile_hit_04_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_projectile_hit_04_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_projectile_hit_05_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_projectile_hit_06_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_blast_projectile_hit_01_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_blast_projectile_hit_02_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_blast_projectile_hit_03_emit.bp',
}

OmegaOverChargeUnitHit = {
    EmtBpPath .. 'seraphim_chronotron_cannon_overcharge_projectile_hit_01_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_overcharge_projectile_hit_02_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_overcharge_projectile_hit_04_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_projectile_hit_05_emit.bp',
    EmtBpPath .. 'destruction_unit_hit_shrapnel_01_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_blast_projectile_hit_01_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_blast_projectile_hit_02_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_blast_projectile_hit_03_emit.bp',
}

OmegaOverChargeProjectileFxTrails = {
    EmtBpPathAlt .. 'omega_overcharge_projectile_fxtrail_01_emit.bp',
    EmtBpPathAlt .. 'omega_overcharge_projectile_fxtrail_02_emit.bp',
    EmtBpPathAlt .. 'omega_overcharge_projectile_fxtrail_03_emit.bp',
}

-- UEF ACU Anti Matter Cannon
ACUAntiMatterPoly = {
    EmtBpPathAlt .. 'amc_polytrail_01_emit.bp',
}

ACUAntiMatterFx = {
    EmtBpPathAlt .. 'amc_fxtrail_01_emit.bp',
    EmtBpPathAlt .. 'amc_fxtrail_02_emit.bp',
    EmtBpPathAlt .. 'amc_fxtrail_03_emit.bp',
    EmtBpPathAlt .. 'amc_fxtrail_04_emit.bp',
    EmtBpPathAlt .. 'amc_fxtrail_05_emit.bp',
}

FlameThrowerHitLand01 = {
    EmtBpPathAlt .. 'flamer_flash_emit.bp',
    EmtBpPathAlt .. 'flamer_thick_smoke_emit.bp',
    EmtBpPathAlt .. 'flamer_thin_smoke_emit.bp',
    EmtBpPathAlt .. 'flamer_01_emit.bp',
    EmtBpPathAlt .. 'flamer_02_emit.bp',
    EmtBpPathAlt .. 'flamer_03_emit.bp',
}

FlameThrowerHitWater01 = {
    EmtBpPathAlt .. 'flamer_waterflash_emit.bp',
    EmtBpPathAlt .. 'flamer_water_smoke_emit.bp',
    EmtBpPathAlt .. 'flamer_oilslick_emit.bp',
    EmtBpPathAlt .. 'flamer_lines_emit.bp',
    EmtBpPathAlt .. 'flamer_water_ripples_emit.bp',
    EmtBpPathAlt .. 'flamer_water_dots_emit.bp',
}

-- Lambda Effects
LambdaRedirector = {
    EmtBpPathAlt .. 'lambda_distortion_01.bp',
    EmtBpPathAlt .. 'lambda_redirect_bright_01.bp',
    EmtBpPathAlt .. 'lambda_redirect_bright_01.bp',
    EmtBpPathAlt .. 'lambda_redirect_bright_02.bp',
    EmtBpPathAlt .. 'lambda_redirect_bright_02.bp',
    EmtBpPathAlt .. 'lambda_redirect_bright_03.bp',
    EmtBpPathAlt .. 'lambda_distortion_01.bp',
}

LambdaDestroyer = {
    EmtBpPathAlt .. 'lambda_distortion_01.bp',
    EmtBpPathAlt .. 'lambda_destroy_dark_01.bp',
    EmtBpPathAlt .. 'lambda_destroy_dark_02.bp',
    EmtBpPathAlt .. 'lambda_destroy_dark_03b.bp',
    EmtBpPathAlt .. 'lambda_destroy_dark_04.bp',
    EmtBpPathAlt .. 'lambda_destroy_bright_01.bp',
    EmtBpPathAlt .. 'lambda_destroy_bright_01.bp',
    EmtBpPathAlt .. 'lambda_distortion_01.bp',
}

ACUAntiMatterMuzzle = {
    EmtBpPathAlt .. 'amc_muzzle_flash_01_emit.bp',
    EmtBpPathAlt .. 'amc_muzzle_flash_02_emit.bp',
    EmtBpPathAlt .. 'amc_muzzle_flash_03_emit.bp',
    EmtBpPathAlt .. 'amc_muzzle_flash_04_emit.bp',
    EmtBpPathAlt .. 'amc_muzzle_flash_05_emit.bp',
    EmtBpPathAlt .. 'amc_muzzle_flash_06_emit.bp',
    EmtBpPathAlt .. 'amc_muzzle_flash_07_emit.bp',
}

-- Overrides the Unleashed one
ACUAntiMatter01 = {
    EmtBpPathAlt .. 'amc_flash_01_emit.bp',
    EmtBpPathAlt .. 'amc_hit_01_emit.bp',
    EmtBpPathAlt .. 'amc_hit_02_emit.bp',
    EmtBpPathAlt .. 'amc_hit_03_emit.bp',
    EmtBpPathAlt .. 'amc_hit_04_emit.bp',
    EmtBpPathAlt .. 'amc_hit_05_emit.bp',
    EmtBpPathAlt .. 'amc_hit_07_emit.bp',
    EmtBpPathAlt .. 'amc_hit_08_emit.bp',
    EmtBpPathAlt .. 'amc_ring_01_emit.bp',
    EmtBpPathAlt .. 'amc_ring_02_emit.bp',
    EmtBpPathAlt .. 'amc_ring_03_emit.bp',
    EmtBpPathAlt .. 'amc_ring_04_emit.bp',
    EmtBpPathAlt .. 'amc_shoackwave_01_emit.bp',
}

-- UEF ACU Gatling Cannon
UEFACUHeavyPlasmaGatlingCannonMuzzleFlash = {
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_01_emit.bp',
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_02_emit.bp',
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_03_emit.bp',
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_05_emit.bp',
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_06_emit.bp',
}

-- Serephim Quantum Storm
SeraACUQuantumStormProjectileHit01 = {
    EmtBpPathAlt .. 'seraphim_experimental_phasonproj_hit_01_emit.bp', -- small blue flash
    EmtBpPathAlt .. 'seraphim_experimental_phasonproj_hit_02_emit.bp', -- flash
    EmtBpPathAlt .. 'seraphim_experimental_phasonproj_hit_03_emit.bp', -- shockwave
    EmtBpPathAlt .. 'seraphim_experimental_phasonproj_hit_04_emit.bp', -- dark glow
    EmtBpPathAlt .. 'seraphim_experimental_phasonproj_hit_05_emit.bp', -- blue glow
    EmtBpPathAlt .. 'seraphim_experimental_phasonproj_hit_06_emit.bp', -- blue shockwave
    EmtBpPathAlt .. 'seraphim_experimental_phasonproj_hit_07_emit.bp', -- blue Spikes
    EmtBpPathAlt .. 'seraphim_experimental_phasonproj_hit_08_emit.bp', -- dark mist
    EmtBpPathAlt .. 'seraphim_experimental_phasonproj_hit_09_emit.bp', -- blue sparks
    EmtBpPathAlt .. 'seraphim_experimental_phasonproj_hit_10_emit.bp', -- lightning
}

SeraACUQuantumStormProjectileHit02 = {
    EmtBpPath .. 'seraphim_experimental_phasonproj_hitunit_01_emit.bp',
    EmtBpPath .. 'seraphim_experimental_phasonproj_hitunit_08_emit.bp',
}
SeraACUQuantumStormProjectileHitUnit = table.concatenate(SeraACUQuantumStormProjectileHit01, SeraACUQuantumStormProjectileHit02)

-- Serephim Rapid Cannon
SeraACURapidCannonPoly = {
    EmtBpPathAlt .. 'seraphim_aireau_autocannon_polytrail_01_emit.bp',
    EmtBpPathAlt .. 'seraphim_aireau_autocannon_polytrail_02_emit.bp',
    EmtBpPathAlt .. 'seraphim_aireau_autocannon_polytrail_03_emit.bp',
}

SeraACURapidCannonPoly02 = {
    EmtBpPathAlt .. 'seraphim_aireau_autocannon_polytrail_04_emit.bp',
    EmtBpPathAlt .. 'seraphim_aireau_autocannon_polytrail_05_emit.bp',
    EmtBpPathAlt .. 'seraphim_aireau_autocannon_polytrail_06_emit.bp',
}

SeraACURapidCannonPoly03 = {
    EmtBpPathAlt .. 'seraphim_aireau_autocannon_polytrail_07_emit.bp',
    EmtBpPathAlt .. 'seraphim_aireau_autocannon_polytrail_08_emit.bp',
    EmtBpPathAlt .. 'seraphim_aireau_autocannon_polytrail_09_emit.bp',
}

-- Cybran EMP Array
CybranACUEMPArrayHit01 = {
    EmtBpPathAlt .. 'emp_flash_01_emit.bp',
    EmtBpPathAlt .. 'emp_flash_02_emit.bp',
    EmtBpPathAlt .. 'emp_flash_03_emit.bp',
    EmtBpPathAlt .. 'emp_hit_01_emit.bp',
    EmtBpPathAlt .. 'emp_hit_02_emit.bp',
    EmtBpPathAlt .. 'emp_hit_03_emit.bp',
    EmtBpPathAlt .. 'emp_hit_04_emit.bp',
    EmtBpPathAlt .. 'emp_hit_05_emit.bp',
    EmtBpPathAlt .. 'emp_hit_06_emit.bp',
    EmtBpPathAlt .. 'emp_implosion_01_emit.bp',
    EmtBpPathAlt .. 'emp_shockwave_01_emit.bp',
    EmtBpPathAlt .. 'emp_shockwave_02_emit.bp',
    EmtBpPathAlt .. 'emp_shockwave_03_emit.bp',
    EmtBpPathAlt .. 'emp_shockwave_07_emit.bp',
}

CybranACUEMPArrayHit02 = {
    EmtBpPathAlt .. 'emp_shockwave_04_emit.bp',
    EmtBpPathAlt .. 'emp_shockwave_05_emit.bp',
}

-- UEF Gatling Projectiles
UEFHeavyPlasmaGatlingCannon03PolyTrail = EmtBpPathAlt .. 'gc_l1upgrade_polytrail_01_emit.bp'
UEFHeavyPlasmaGatlingCannon01PolyTrail = EmtBpPathAlt .. 'gc_l2upgrade_polytrail_01_emit.bp'
UEFHeavyPlasmaGatlingCannon02PolyTrail = EmtBpPathAlt .. 'gc_l3upgrade_polytrail_01_emit.bp'

-- UEF Cruise Missile 01
UEFCruiseMissile01Trails = {
    EmtBpPath .. 'missile_sam_munition_trail_01_emit.bp',
    EmtBpPath .. 'missile_munition_trail_02_emit.bp',
}

-- Sat Death
SatDeathSmoke = {EmtBpPathAlt .. 'sat_death_smoke_emit.bp',}
SatDamageFire01 = {
    EmtBpPath .. 'destruction_damaged_fire_01_emit.bp',
    EmtBpPath .. 'destruction_damaged_fire_distort_01_emit.bp',
}

SatDeathEffectsPackage = table.concatenate(SatDeathSmoke, SatDamageFire01)
