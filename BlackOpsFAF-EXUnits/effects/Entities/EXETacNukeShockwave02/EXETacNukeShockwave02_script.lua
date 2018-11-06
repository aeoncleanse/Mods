--
-- script for projectile BoneAttached
--
local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

EXETacNukeShockwave02 = Class(EmitterProjectile) {
    FxTrails = {'/effects/emitters/nuke_blanket_smoke_01_emit.bp',},
    FxTrailScale = 0.2,-- Exavier Modified Scale
    FxTrailOffset = 0,
}

TypeClass = EXETacNukeShockwave02