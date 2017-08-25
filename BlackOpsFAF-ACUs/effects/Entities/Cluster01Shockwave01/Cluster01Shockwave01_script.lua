local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

Cluster01Shockwave01 = Class(EmitterProjectile) {
    FxTrails = {'/effects/emitters/nuke_blanket_smoke_02_emit.bp', },
    FxTrailScale = 0.03125,
    FxTrailOffset = 0,
}

TypeClass = Cluster01Shockwave01
