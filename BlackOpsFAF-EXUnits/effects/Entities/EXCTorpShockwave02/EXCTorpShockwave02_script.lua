--
-- script for projectile BoneAttached
--
local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

EXCTorpShockwave02 = Class(EmitterProjectile) {
    FxTrails = {'/mods/BlackOpsFAF-EXUnits/effects/emitters/exconcussiontorp_shockwave_03_emit.bp',},
    FxTrailScale = 0.1,-- Exavier Modified Scale
    FxTrailOffset = 0,
}

TypeClass = EXCTorpShockwave02