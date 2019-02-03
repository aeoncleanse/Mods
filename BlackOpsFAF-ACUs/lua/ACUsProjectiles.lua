-----------------------------------------------------------------
-- File     : /cdimage/lua/BlackOpsprojectiles.lua
-- Author(s): Lt_Hawkeye
-- Summary  :
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local EmitterProjectile = DefaultProjectileFile.EmitterProjectile
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile
local MultiPolyTrailProjectile = DefaultProjectileFile.MultiPolyTrailProjectile
local MultiCompositeEmitterProjectile = DefaultProjectileFile.MultiCompositeEmitterProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ACUsEffectTemplate = import('/mods/BlackOpsFAF-ACUs/lua/ACUsEffectTemplates.lua')
local util = import('/lua/utilities.lua')

--  UEF ACU Antimatter Cannon
AntiMatterProjectile = Class(MultiCompositeEmitterProjectile) {
    FxTrails = ACUsEffectTemplate.AntiMatterFx,
    PolyTrail = ACUsEffectTemplate.AntiMatterPoly,

    -- Hit Effects
    FxImpactUnit = ACUsEffectTemplate.AntiMatterHit,
    FxImpactProp = ACUsEffectTemplate.AntiMatterHit,
    FxImpactLand = ACUsEffectTemplate.AntiMatterHit,
    FxImpactWater = ACUsEffectTemplate.AntiMatterHit,
    FxImpactShield = ACUsEffectTemplate.AntiMatterHit,
    FxImpactUnderWater = {},
    FxSplatScale = 4,
    FxLandHitScale = 0.5,
    FxPropHitScale = 0.5,
    FxUnitHitScale = 0.5,
    FxWaterHitScale = 0.5,
    FxShieldHitScale = 0.5,

    OnImpact = function(self, targetType, targetEntity)
        local army = self:GetArmy()
        if targetType == 'Terrain' then
            CreateDecal(self:GetPosition(), util.GetRandomFloat(0.0,6.28), 'nuke_scorch_001_normals', '', 'Alpha Normals', self.FxSplatScale, self.FxSplatScale, 150, 30, army)
            CreateDecal(self:GetPosition(), util.GetRandomFloat(0.0,6.28), 'nuke_scorch_002_albedo', '', 'Albedo', self.FxSplatScale * 2, self.FxSplatScale * 2, 150, 30, army)
        end

        local pos = self:GetPosition()
        DamageArea(self, pos, self.DamageData.DamageRadius, 1, 'Force', true)
        DamageArea(self, pos, self.DamageData.DamageRadius, 1, 'Force', true)

        EmitterProjectile.OnImpact(self, targetType, targetEntity)
    end,
}

--  UEF ACU Flame Thrower
NapalmProjectile = Class(EmitterProjectile) {
    FxTrails = {'/mods/BlackOpsFAF-ACUs/Effects/Emitters/NapalmTrailFX.bp',},
    FxTrailScale = 0.75,
    FxImpactTrajectoryAligned = false,

    -- Hit Effects
    FxImpactUnit = ACUsEffectTemplate.FlameThrowerHitLand,
    FxImpactProp = ACUsEffectTemplate.FlameThrowerHitLand,
    FxImpactLand = ACUsEffectTemplate.FlameThrowerHitLand,
    FxImpactWater = ACUsEffectTemplate.FlameThrowerHitWater,
    FxImpactShield = ACUsEffectTemplate.FlameThrowerHitLand,
    FxImpactUnderWater = {},

    FxLandHitScale = 0.7,
    FxPropHitScale = 0.7,
    FxUnitHitScale = 0.7,
    FxWaterHitScale = 0.7,
    FxShieldHitScale = 0.7,
}

--  UEF Gatling Projectile
HeavyPlasmaGatlingProjectile = Class(SinglePolyTrailProjectile) {
    FxImpactTrajectoryAligned = false,
    FxImpactUnit = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactProp = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactWater = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactLand = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactShield = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactUnderWater = {},
    FxTrails = EffectTemplate.THeavyPlasmaGatlingCannonFxTrails,
    PolyTrail = ACUsEffectTemplate.HeavyPlasmaGatlingTrail,
}

--  UEF ACU Cluster Missile Pack
ClusterMissileProjectileClass = Class(SinglePolyTrailProjectile) {
    DestroyOnImpact = false,
    FxTrails = ACUsEffectTemplate.ClusterMissileTrail,
    FxTrailOffset = -0.3,
    FxTrailScale = 1.5,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',

    FxImpactUnit = EffectTemplate.TMissileHit01,
    FxImpactLand = EffectTemplate.TMissileHit01,
    FxImpactProp = EffectTemplate.TMissileHit01,
    FxImpactUnderWater = {},
}

SmallYieldNukeProjectileClass = Class(EmitterProjectile) {
    DestroyOnImpact = false,
    FxTrails = {'/effects/emitters/mortar_munition_01_emit.bp',},
    FxTrailOffset = 0,
    FxTrailScale = 4.5,

    FxImpactUnit = EffectTemplate.TShipGaussCannonHitUnit02,
    FxImpactProp = EffectTemplate.TShipGaussCannonHit02,
    FxImpactLand = EffectTemplate.TShipGaussCannonHit02,
    FxImpactUnderWater = {},
}

-- Cybran EMP Projectile
EMPProjectile = Class(MultiCompositeEmitterProjectile) {
    FxImpactUnit = ACUsEffectTemplate.EMPArrayHit,
    FxImpactProp = ACUsEffectTemplate.EMPArrayHit,
    FxImpactLand = ACUsEffectTemplate.EMPArrayHit,
    FxImpactWater = ACUsEffectTemplate.EMPArrayHit,
    FxImpactShield = ACUsEffectTemplate.EMPArrayHit,
    FxImpactUnderWater = {},

    FxSplatScale = 4,
    FxLandHitScale = 0.5,
    FxPropHitScale = 0.5,
    FxUnitHitScale = 0.5,
    FxWaterHitScale = 0.5,
    FxShieldHitScale = 0.5,

    BlanketSides = 6,
    ProjScale = 0.25,

    OnImpact = function(self, targetType, targetEntity)
        local blanketAngle = (2 * math.pi) / self.BlanketSides
        local blanketVelocity = 6.25

        for i = 0, self.BlanketSides - 1 do
            local blanketX = math.sin(i * blanketAngle)
            local blanketZ = math.cos(i * blanketAngle)
            self:CreateProjectile('/effects/entities/EffectProtonAmbient01/EffectProtonAmbient01_proj.bp', blanketX, self.ProjScale, blanketZ, blanketX, 0, blanketZ)
                :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
        end

        MultiCompositeEmitterProjectile.OnImpact(self, targetType, targetEntity)
    end,
}

EMPProjectile02 = Class(EMPProjectile) {
    FxSplatScale = 6,
    FxLandHitScale = 0.75,
    FxPropHitScale = 0.75,
    FxUnitHitScale = 0.75,
    FxWaterHitScale = 0.75,
    FxShieldHitScale = 0.75,

    BlanketSides = 9,
    ProjScale = 0.25,
}

EMPProjectile03 = Class(EMPProjectile) {
    FxSplatScale = 8,
    FxLandHitScale = 0.75,
    FxPropHitScale = 0.75,
    FxUnitHitScale = 0.75,
    FxWaterHitScale = 0.75,
    FxShieldHitScale = 0.75,

    BlanketSides = 12,
    ProjScale = 0.5,
}

-- Serephim Overcharge Projectile
OmegaOverchargeProjectile = Class(MultiPolyTrailProjectile) {
    FxImpactTrajectoryAligned = false,
    FxImpactLand = ACUsEffectTemplate.OmegaOverchargeLandHit,
    FxImpactNone = ACUsEffectTemplate.OmegaOverchargeLandHit,
    FxImpactProp = ACUsEffectTemplate.OmegaOverchargeLandHit,
    FxImpactUnit = ACUsEffectTemplate.OmegaOverchargeUnitHit,
    FxImpactShield = ACUsEffectTemplate.OmegaOverchargeLandHit,
    FxLandHitScale = 4,
    FxPropHitScale = 4,
    FxUnitHitScale = 4,
    FxNoneHitScale = 4,
    FxShieldHitScale = 4,
    FxTrails = ACUsEffectTemplate.OmegaOverchargeProjectileFxTrails,
    PolyTrails = ACUsEffectTemplate.OmegaOverchargeProjectileFxTrails,
    PolyTrailOffset = {0,0,0},
}

--  Serephim Quantum Storm
QuantumStormProjectile = Class(EmitterProjectile) {
    FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.SDFExperimentalPhasonProjFXTrails01,
    FxImpactUnit = ACUsEffectTemplate.QuantumStormProjectileHitUnit,
    FxImpactProp = ACUsEffectTemplate.QuantumStormProjectileHit,
    FxImpactLand = ACUsEffectTemplate.QuantumStormProjectileHit,
    FxImpactWater = ACUsEffectTemplate.QuantumStormProjectileHit,
    FxImpactShield = ACUsEffectTemplate.QuantumStormProjectileHit,

    FxLandHitScale = 0.5,
    FxPropHitScale = 0.5,
    FxUnitHitScale = 0.5,
    FxWaterHitScale = 0.5,
    FxShieldHitScale = 0.5,
}

--  Serephim Rapid Cannon
RapidCannonProjectile = Class(MultiPolyTrailProjectile) {
    FxImpactNone = EffectTemplate.SDFAireauWeaponHit01,
    FxImpactUnit = EffectTemplate.SDFAireauWeaponHitUnit,
    FxImpactProp = EffectTemplate.SDFAireauWeaponHit01,
    FxImpactLand = EffectTemplate.SDFAireauWeaponHit01,
    FxImpactWater= EffectTemplate.SDFAireauWeaponHit01,
    FxImpactShield = EffectTemplate.SDFAireauWeaponHit01,
    RandomPolyTrails = 1,

    PolyTrails = ACUsEffectTemplate.RapidCannonPoly,
    PolyTrailOffset = {0,0,0},

    FxLandHitScale = 0.7,
    FxPropHitScale = 0.7,
    FxUnitHitScale = 0.7,
    FxWaterHitScale = 0.7,
    FxShieldHitScale = 0.7,
}
