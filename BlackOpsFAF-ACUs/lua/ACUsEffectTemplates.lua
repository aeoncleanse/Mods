----------------------------------------------------------------------
-- File     :  /data/lua/EffectTemplates.lua
-- Author(s):  Gordon Duclos, Greg Kohne, Matt Vainio, Aaron Lundquist
-- Summary  :  Generic templates for commonly used effects
-- Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
----------------------------------------------------------------------

EmtBpPath = '/effects/emitters/'
EmtBpPathAlt = '/mods/BlackOpsFAF-ACUs/effects/emitters/'

-- UEF ACU Anti Matter Cannon
AntiMatterHit = { -- Overrides the Unleashed one
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
    EmtBpPathAlt .. 'amc_shockwave_01_emit.bp',
}

AntiMatterPoly = {
    EmtBpPathAlt .. 'amc_polytrail_01_emit.bp',
}

AntiMatterFx = {
    EmtBpPathAlt .. 'amc_fxtrail_01_emit.bp',
    EmtBpPathAlt .. 'amc_fxtrail_02_emit.bp',
    EmtBpPathAlt .. 'amc_fxtrail_03_emit.bp',
    EmtBpPathAlt .. 'amc_fxtrail_04_emit.bp',
    EmtBpPathAlt .. 'amc_fxtrail_05_emit.bp',
}

AntiMatterMuzzle = {
    EmtBpPathAlt .. 'amc_muzzle_flash_01_emit.bp',
    EmtBpPathAlt .. 'amc_muzzle_flash_02_emit.bp',
    EmtBpPathAlt .. 'amc_muzzle_flash_03_emit.bp',
    EmtBpPathAlt .. 'amc_muzzle_flash_04_emit.bp',
    EmtBpPathAlt .. 'amc_muzzle_flash_05_emit.bp',
    EmtBpPathAlt .. 'amc_muzzle_flash_06_emit.bp',
    EmtBpPathAlt .. 'amc_muzzle_flash_07_emit.bp',
}

-- UEF ACU Flamethrower
FlameThrowerHitLand = {
    EmtBpPathAlt .. 'flamer_flash_emit.bp',
    EmtBpPathAlt .. 'flamer_thick_smoke_emit.bp',
    EmtBpPathAlt .. 'flamer_thin_smoke_emit.bp',
    EmtBpPathAlt .. 'flamer_01_emit.bp',
    EmtBpPathAlt .. 'flamer_02_emit.bp',
    EmtBpPathAlt .. 'flamer_03_emit.bp',
}

FlameThrowerHitWater = {
    EmtBpPathAlt .. 'flamer_waterflash_emit.bp',
    EmtBpPathAlt .. 'flamer_water_smoke_emit.bp',
    EmtBpPathAlt .. 'flamer_oilslick_emit.bp',
    EmtBpPathAlt .. 'flamer_lines_emit.bp',
    EmtBpPathAlt .. 'flamer_water_ripples_emit.bp',
    EmtBpPathAlt .. 'flamer_water_dots_emit.bp',
}

-- UEF ACU Gatling Cannon
HeavyPlasmaGatlingMuzzleFlash = {
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_01_emit.bp',
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_02_emit.bp',
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_03_emit.bp',
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_05_emit.bp',
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_06_emit.bp',
}

HeavyPlasmaGatlingTrail = EmtBpPathAlt .. 'gc_upgrade_polytrail_emit.bp'

-- UEF Cluster Missile
ClusterMissileTrail = {
    EmtBpPath .. 'missile_sam_munition_trail_01_emit.bp',
    EmtBpPath .. 'missile_munition_trail_02_emit.bp',
}

-- Satellite Death
SatDeathSmoke = {
    EmtBpPathAlt .. 'sat_death_smoke_emit.bp'
}

SatDamageFire = {
    EmtBpPath .. 'destruction_damaged_fire_01_emit.bp',
    EmtBpPath .. 'destruction_damaged_fire_distort_01_emit.bp',
}

SatDeathEffectsPackage = table.concatenate(SatDeathSmoke, SatDamageFire)

-- Cybran EMP Array
EMPArrayHit = {
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

-- Seraphim Lambda FX
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

-- Seraphim Omega Overcharge
OmegaOverchargeLandHit = {
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

OmegaOverchargeUnitHit = {
    EmtBpPath .. 'seraphim_chronotron_cannon_overcharge_projectile_hit_01_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_overcharge_projectile_hit_02_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_overcharge_projectile_hit_04_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_projectile_hit_05_emit.bp',
    EmtBpPath .. 'destruction_unit_hit_shrapnel_01_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_blast_projectile_hit_01_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_blast_projectile_hit_02_emit.bp',
    EmtBpPath .. 'seraphim_chronotron_cannon_blast_projectile_hit_03_emit.bp',
}

OmegaOverchargeProjectileFxTrails = {
    EmtBpPathAlt .. 'omega_overcharge_projectile_fxtrail_01_emit.bp',
    EmtBpPathAlt .. 'omega_overcharge_projectile_fxtrail_02_emit.bp',
    EmtBpPathAlt .. 'omega_overcharge_projectile_fxtrail_03_emit.bp',
}

-- Serephim Quantum Storm
QuantumStormProjectileHit = {
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

QuantumStormProjectileHit02 = {
    EmtBpPath .. 'seraphim_experimental_phasonproj_hitunit_01_emit.bp',
    EmtBpPath .. 'seraphim_experimental_phasonproj_hitunit_08_emit.bp',
}

QuantumStormProjectileHitUnit = table.concatenate(QuantumStormProjectileHit, QuantumStormProjectileHit02)

-- Serephim Rapid Cannon
RapidCannonPoly = {
    EmtBpPathAlt .. 'seraphim_aireau_autocannon_polytrail_01_emit.bp',
    EmtBpPathAlt .. 'seraphim_aireau_autocannon_polytrail_02_emit.bp',
    EmtBpPathAlt .. 'seraphim_aireau_autocannon_polytrail_03_emit.bp',
}
