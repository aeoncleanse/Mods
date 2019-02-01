TargetingLaserBO = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.TargetingCollisionBeamBO,
    FxMuzzleFlash = {'/effects/emitters/particle_cannon_muzzle_01_emit.bp'},

    FxBeamEndPointScale = 0.01,
}

DummyBO = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.TargetingCollisionBeamBO,

    FxBeamEndPointScale = 0.01,
}
