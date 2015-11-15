local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

EffectEMPAmbient01 = Class(EmitterProjectile) {
    FxTrails = {'/effects/emitters/emp_bomb_hit_03_emit.bp',},
    FxTrailScale = 2,
}

TypeClass = EffectEMPAmbient01