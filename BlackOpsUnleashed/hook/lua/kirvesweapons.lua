TargetingLaserBO = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.TargetingCollisionBeamBO,
    FxMuzzleFlash = {'/effects/emitters/particle_cannon_muzzle_01_emit.bp'},
    
    FxBeamEndPointScale = 0.01,
}

SDFUnstablePhasonBeamBO = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.UnstablePhasonLaserCollisionBeam3,
    FxMuzzleFlash = {},
    FxChargeMuzzleFlash = {},
    FxUpackingChargeEffects = OriginalEffectTemplate.CMicrowaveLaserCharge01,
    FxUpackingChargeEffectScale = 0.2,
}

DummyBO = Class(DefaultBeamWeapon) {
    BeamType = CollisionBeamFile.TargetingCollisionBeamBO,
    
    FxBeamEndPointScale = 0.01,
}
