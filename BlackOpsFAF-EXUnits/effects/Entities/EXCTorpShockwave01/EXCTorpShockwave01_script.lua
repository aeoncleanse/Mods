local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

EXCTorpShockwave01 = Class(EmitterProjectile) {
    FxTrails = {'/effects/emitters/nuke_blanket_smoke_02_emit.bp',},
    FxTrailScale = 0.5,
    FxTrailOffset = 0,
}

TypeClass = EXCTorpShockwave01
