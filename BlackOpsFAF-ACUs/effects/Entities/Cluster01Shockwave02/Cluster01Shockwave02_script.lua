local EmitterProjectile = import('/lua/sim/defaultprojectiles.lua').EmitterProjectile

Cluster01Shockwave02 = Class(EmitterProjectile) {
    FxTrails = {'/effects/emitters/nuke_blanket_smoke_01_emit.bp', },
    FxTrailScale = 0.015625,
    FxTrailOffset = 0,
}

TypeClass = Cluster01Shockwave02
