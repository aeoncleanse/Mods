local EffectTemplate = import('/lua/EffectTemplates.lua')
local CollisionBeam = import('/lua/sim/CollisionBeam.lua').CollisionBeam

-- Base class that defines supreme commander specific defaults
HawkCollisionBeam = Class(CollisionBeam) {
    FxImpactUnit = EffectTemplate.DefaultProjectileLandUnitImpact,
    FxImpactLand = {},
    FxImpactWater = EffectTemplate.DefaultProjectileWaterImpact,
    FxImpactUnderWater = EffectTemplate.DefaultProjectileUnderWaterImpact,
    FxImpactAirUnit = EffectTemplate.DefaultProjectileAirUnitImpact,
    FxImpactProp = {},
    FxImpactShield = {},
    FxImpactNone = {},
}

PDLaser = Class(CollisionBeam) {
    FxBeamStartPoint = EffectTemplate.TDFHiroGeneratorMuzzle01,
    FxBeam = EffectTemplate.TDFHiroGeneratorBeam,
    FxBeamEndPoint = EffectTemplate.TDFHiroGeneratorHitLand,
    FxBeamStartPointScale = 0.75,
    FxBeamEndPointScale = 0.75,
}

CEMPArrayBeam = Class(HawkCollisionBeam) {
    FxBeam = {'/mods/BlackOpsFAF-ACUs/effects/emitters/cemparraybeam01_emit.bp'},
    FxBeamEndPoint = {},
    FxBeamStartPoint = {},
    FxBeamStartPointScale = 0.05,
    FxBeamEndPointScale = 0.05,
}

CEMPArrayBeam02 = Class(HawkCollisionBeam) {
    FxBeam = {'/mods/BlackOpsFAF-ACUs/effects/emitters/cemparraybeam02_emit.bp'},
    FxBeamEndPoint = EffectTemplate.CMicrowaveLaserEndPoint01,
    FxBeamStartPoint = EffectTemplate.CMicrowaveLaserMuzzle01,
    FxBeamStartPointScale = 0.05,
    FxBeamEndPointScale = 0.05,
}

PhasonLaser = Class(HawkCollisionBeam) {
    FxBeamStartPoint = EffectTemplate.APhasonLaserMuzzle01,
    FxBeam = {'/mods/BlackOpsFAF-ACUs/effects/emitters/phason_beam_01_emit.bp'},
    FxBeamEndPoint = EffectTemplate.APhasonLaserImpact01,
    FxBeamStartPointScale = 0.25,
    FxBeamEndPointScale = 0.5,
}
