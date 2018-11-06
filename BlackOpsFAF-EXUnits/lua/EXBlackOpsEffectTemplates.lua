--****************************************************************************
--**
--**  File     :  /data/lua/EffectTemplates.lua
--**  Author(s):  Gordon Duclos, Greg Kohne, Matt Vainio, Aaron Lundquist
--**
--**  Summary  :  Generic templates for commonly used effects
--**
--**  Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
EmtBpPath = '/effects/emitters/'
EmitterTempEmtBpPath = '/effects/emitters/temp/'
EXBlackopsBpPath = '/mods/BlackOpsFAF-EXUnits/effects/emitters/'

-------------------------------
--   UEF Sonic Disruptor Wave
-------------------------------
SonicDisruptorWaveMuzzle =
{
    EXBlackopsBpPath .. 'exsonicdisruptor_muzzle_01_emit.bp',
    EXBlackopsBpPath .. 'exsonicdisruptor_muzzle_02_emit.bp',
    EXBlackopsBpPath .. 'exsonicdisruptor_muzzle_03_emit.bp',
    EXBlackopsBpPath .. 'exsonicdisruptor_muzzle_04_emit.bp',
}

SonicDisruptorWaveHit = {
    EmtBpPath .. 'microwave_laser_end_03_emit.bp',
}

SonicDisruptorWaveBeam01 = {
    EXBlackopsBpPath .. 'exsonicdisruptor_beam_01_emit.bp',
}

--------------------------------------------------------------------------
--  UEF ACU Gattling Cannon
--------------------------------------------------------------------------
UEFACUHeavyPlasmaGatlingCannonMuzzleFlash = {
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_01_emit.bp',
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_02_emit.bp',
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_03_emit.bp',
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_05_emit.bp',
    EmtBpPath .. 'heavy_plasma_gatling_cannon_laser_muzzle_flash_06_emit.bp',
}

-------------------------------
--   UEF Hyper Velocity Missile
-------------------------------
UEFHVM01Trails = {
    EmtBpPath .. 'missile_sam_munition_trail_01_emit.bp',
    --EmtBpPath .. 'missile_sam_munition_trail_01_emit.bp',
    EmtBpPath .. 'nuke_munition_launch_trail_04_emit.bp',
    --EmtBpPath .. 'nuke_munition_launch_trail_06_emit.bp',
    EmtBpPath .. 'missile_munition_trail_01_emit.bp',
    EmtBpPath .. 'missile_munition_trail_02_emit.bp',
    --EmtBpPath .. 'missile_smoke_exhaust_02_emit.bp',
}

-------------------------------
--   UEF Cruise Missile 01
-------------------------------
UEFCruiseMissile01Trails = {
    EmtBpPath .. 'missile_sam_munition_trail_01_emit.bp',
    --EmtBpPath .. 'missile_sam_munition_trail_01_emit.bp',
    --EmtBpPath .. 'nuke_munition_launch_trail_04_emit.bp',
    --EmtBpPath .. 'nuke_munition_launch_trail_06_emit.bp',
    --EmtBpPath .. 'missile_munition_trail_01_emit.bp',
    EmtBpPath .. 'missile_munition_trail_02_emit.bp',
    --EmtBpPath .. 'missile_smoke_exhaust_02_emit.bp',
}

-------------------------------
--   Cybran Hailfire Projectiles
-------------------------------
CybranHailfire01Hit01 = {
    EmtBpPath .. 'neutron_cluster_bomb_hit_01_emit.bp',
    EmtBpPath .. 'neutron_cluster_bomb_hit_02_emit.bp',
    EmtBpPath .. 'cybran_empgrenade_hit_01_emit.bp',
    EmtBpPath .. 'cybran_empgrenade_hit_02_emit.bp',
    EmtBpPath .. 'cybran_empgrenade_hit_03_emit.bp',
}
CybranHailfire01FXTrails = {
    --EmtBpPath .. 'missile_sam_munition_trail_01_emit.bp',
    --EmtBpPath .. 'missile_sam_munition_trail_01_emit.bp',
    --EmtBpPath .. 'nuke_munition_launch_trail_04_emit.bp',
    --EmtBpPath .. 'nuke_munition_launch_trail_06_emit.bp',
    --EmtBpPath .. 'missile_munition_trail_01_emit.bp',
    --EmtBpPath .. 'missile_munition_trail_02_emit.bp',
    --EmtBpPath .. 'missile_smoke_exhaust_02_emit.bp',
    EXBlackopsBpPath .. 'exhailfire_exhaust_01_emit.bp',
    EXBlackopsBpPath .. 'exhailfire_exhaust_02_emit.bp',
}
CybranHailfire02FXTrails = {
    EmtBpPath .. 'missile_sam_munition_trail_01_emit.bp',
    --EmtBpPath .. 'missile_sam_munition_trail_01_emit.bp',
    --EmtBpPath .. 'nuke_munition_launch_trail_04_emit.bp',
    --EmtBpPath .. 'nuke_munition_launch_trail_06_emit.bp',
    --EmtBpPath .. 'missile_munition_trail_01_emit.bp',
    --EmtBpPath .. 'missile_munition_trail_02_emit.bp',
    --EmtBpPath .. 'missile_smoke_exhaust_02_emit.bp',
}
CybranHailfire01HitUnit01 = CybranHailfire01Hit01
CybranHailfire01HitLand01 = CybranHailfire01Hit01
CybranHailfire01HitWater01 = CybranHailfire01Hit01
HailfireLauncherExhaust = {
    --EmtBpPath .. 'terran_cruise_missile_launch_01_emit.bp',
    --EXBlackopsBpPath .. 'terran_cruise_missile_launch_02_emit.bp',
    EmtBpPath .. 'cannon_muzzle_flash_04_emit.bp',
    EmtBpPath .. 'cannon_muzzle_smoke_11_emit.bp',
    --EmtBpPath .. 'terran_sam_launch_smoke_emit.bp',
    EXBlackopsBpPath .. 'terran_sam_launch_smoke2_emit.bp',
}

