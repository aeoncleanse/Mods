-----------------------------------------------------------------
-- File     : /cdimage/lua/BlackOpsprojectiles.lua
-- Author(s): Lt_Hawkeye
-- Summary  :
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local Projectile = import('/lua/sim/projectile.lua').Projectile
local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local EmitterProjectile = DefaultProjectileFile.EmitterProjectile
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile
local MultiPolyTrailProjectile = DefaultProjectileFile.MultiPolyTrailProjectile
local MultiCompositeEmitterProjectile = DefaultProjectileFile.MultiCompositeEmitterProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local util = import('/lua/utilities.lua')
local ACUsEffectTemplate = import('/mods/BlackOpsFAF-ACUs/lua/ACUsEffectTemplates.lua')

NullShell = Class(Projectile) {}

EmitterProjectile = Class(Projectile) {
    FxTrails = {'/effects/emitters/missile_munition_trail_01_emit.bp',},
    FxTrailScale = 1,
    FxTrailOffset = 0,

    OnCreate = function(self)
        Projectile.OnCreate(self)

        local army = self:GetArmy()
        for _, i in self.FxTrails do
            CreateEmitterOnEntity(self, army, i):ScaleEmitter(self.FxTrailScale):OffsetEmitter(0, 0, self.FxTrailOffset)
        end
    end,
}

SinglePolyTrailProjectile = Class(EmitterProjectile) {
    PolyTrail = '/effects/emitters/test_missile_trail_emit.bp',
    PolyTrailOffset = 0,
    FxTrails = {},

    OnCreate = function(self)
        EmitterProjectile.OnCreate(self)
        if self.PolyTrail ~= '' then
            CreateTrail(self, -1, self:GetArmy(), self.PolyTrail):OffsetEmitter(0, 0, self.PolyTrailOffset)
        end
    end,
}

MultiPolyTrailProjectile = Class(EmitterProjectile) {
    PolyTrailOffset = {0},
    FxTrails = {},
    RandomPolyTrails = 0, -- Count of how many are selected randomly for PolyTrail table

    OnCreate = function(self)
        EmitterProjectile.OnCreate(self)
        if self.PolyTrails then
            local NumPolyTrails = table.getn(self.PolyTrails)
            local army = self:GetArmy()

            if self.RandomPolyTrails ~= 0 then
                local index = nil
                for i = 1, self.RandomPolyTrails do
                    index = math.floor(Random(1, NumPolyTrails))
                    CreateTrail(self, -1, army, self.PolyTrails[index]):OffsetEmitter(0, 0, self.PolyTrailOffset[index])
                end
            else
                for i = 1, NumPolyTrails do
                    CreateTrail(self, -1, army, self.PolyTrails[i]):OffsetEmitter(0, 0, self.PolyTrailOffset[i])
                end
            end
        end
    end,
}

-- Composite emitter projectiles - Multipurpose projectiles
-- That combine beams, polytrails, and normal emitters

-- Heavyweight version allowing multiple beams, polytrails, and standard emitters
MultiCompositeEmitterProjectile = Class(MultiPolyTrailProjectile) {
    Beams = {'/effects/emitters/default_beam_01_emit.bp',},
    PolyTrailOffset = {0},
    RandomPolyTrails = 0, -- Count of how many are selected randomly for PolyTrail table
    FxTrails = {},

    OnCreate = function(self)
        MultiPolyTrailProjectile.OnCreate(self)
        local beam = nil
        local army = self:GetArmy()
        for _, v in self.Beams do
            CreateBeamEmitterOnEntity(self, -1, army, v)
        end
    end,
}

--  UEF ACU Flame Thrower
FlameThrowerProjectile01 = Class(EmitterProjectile) {
    FxTrails = {'/mods/BlackOpsFAF-ACUs/Effects/Emitters/NapalmTrailFX.bp',},
    FxTrailScale = 0.75,
    FxImpactTrajectoryAligned = false,

    -- Hit Effects
    FxImpactUnit = ACUsEffectTemplate.FlameThrowerHitLand01,
    FxImpactProp = ACUsEffectTemplate.FlameThrowerHitLand01,
    FxImpactLand = ACUsEffectTemplate.FlameThrowerHitLand01,
    FxImpactWater = ACUsEffectTemplate.FlameThrowerHitWater01,
    FxImpactShield = ACUsEffectTemplate.FlameThrowerHitLand01,
    FxImpactUnderWater = {},

    FxLandHitScale = 0.7,
    FxPropHitScale = 0.7,
    FxUnitHitScale = 0.7,
    FxWaterHitScale = 0.7,
    FxShieldHitScale = 0.7,
}

--  UEF ACU Antimatter Cannon
UEFACUAntiMatterProjectile01 = Class(MultiCompositeEmitterProjectile) {
    FxTrails = ACUsEffectTemplate.ACUAntiMatterFx,
    PolyTrail = ACUsEffectTemplate.ACUAntiMatterPoly,

    -- Hit Effects
    FxImpactUnit = ACUsEffectTemplate.ACUAntiMatter01,
    FxImpactProp = ACUsEffectTemplate.ACUAntiMatter01,
    FxImpactLand = ACUsEffectTemplate.ACUAntiMatter01,
    FxImpactWater = ACUsEffectTemplate.ACUAntiMatter01,
    FxImpactShield = ACUsEffectTemplate.ACUAntiMatter01,
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

UEFACUAntiMatterProjectile02 = Class(MultiCompositeEmitterProjectile) {
    FxTrails = ACUsEffectTemplate.ACUAntiMatterFx,
    PolyTrail = ACUsEffectTemplate.ACUAntiMatterPoly,

    -- Hit Effects
    FxImpactUnit = ACUsEffectTemplate.ACUAntiMatter01,
    FxImpactProp = ACUsEffectTemplate.ACUAntiMatter01,
    FxImpactLand = ACUsEffectTemplate.ACUAntiMatter01,
    FxImpactWater = ACUsEffectTemplate.ACUAntiMatter01,
    FxImpactShield = ACUsEffectTemplate.ACUAntiMatter01,
    FxImpactUnderWater = {},
    FxSplatScale = 5.5,

    FxLandHitScale = 0.7,
    FxPropHitScale = 0.7,
    FxUnitHitScale = 0.7,
    FxWaterHitScale = 0.7,
    FxShieldHitScale = 0.7,

    OnImpact = function(self, targetType, targetEntity)
        local army = self:GetArmy()
        if targetType == 'Terrain' then
            CreateDecal(self:GetPosition(), util.GetRandomFloat(0.0,6.28), 'nuke_scorch_001_normals', '', 'Alpha Normals', self.FxSplatScale, self.FxSplatScale, 150, 30, army)
            CreateDecal(self:GetPosition(), util.GetRandomFloat(0.0,6.28), 'nuke_scorch_002_albedo', '', 'Albedo', self.FxSplatScale * 2, self.FxSplatScale * 2, 150, 30, army)
            self:ShakeCamera(20, 1, 0, 1)
        end

        local pos = self:GetPosition()
        DamageArea(self, pos, self.DamageData.DamageRadius, 1, 'Force', true)
        DamageArea(self, pos, self.DamageData.DamageRadius, 1, 'Force', true)
        EmitterProjectile.OnImpact(self, targetType, targetEntity)
    end,
}

UEFACUAntiMatterProjectile03 = Class(MultiCompositeEmitterProjectile) {
    FxTrails = ACUsEffectTemplate.ACUAntiMatterFx,
    PolyTrail = ACUsEffectTemplate.ACUAntiMatterPoly,

    -- Hit Effects
    FxImpactUnit = ACUsEffectTemplate.ACUAntiMatter01,
    FxImpactProp = ACUsEffectTemplate.ACUAntiMatter01,
    FxImpactLand = ACUsEffectTemplate.ACUAntiMatter01,
    FxImpactWater = ACUsEffectTemplate.ACUAntiMatter01,
    FxImpactShield = ACUsEffectTemplate.ACUAntiMatter01,
    FxImpactUnderWater = {},
    FxSplatScale = 8,

    FxLandHitScale = 1,
    FxPropHitScale = 1,
    FxUnitHitScale = 1,
    FxWaterHitScale = 1,
    FxShieldHitScale = 1,

    OnImpact = function(self, targetType, targetEntity)
        local army = self:GetArmy()
        if targetType == 'Terrain' then
            CreateDecal(self:GetPosition(), util.GetRandomFloat(0.0,6.28), 'nuke_scorch_001_normals', '', 'Alpha Normals', self.FxSplatScale, self.FxSplatScale, 150, 30, army)
            CreateDecal(self:GetPosition(), util.GetRandomFloat(0.0,6.28), 'nuke_scorch_002_albedo', '', 'Albedo', self.FxSplatScale * 2, self.FxSplatScale * 2, 150, 30, army)
            self:ShakeCamera(20, 1, 0, 1)
        end

        local pos = self:GetPosition()
        DamageArea(self, pos, self.DamageData.DamageRadius, 1, 'Force', true)
        DamageArea(self, pos, self.DamageData.DamageRadius, 1, 'Force', true)
        EmitterProjectile.OnImpact(self, targetType, targetEntity)
    end,
}

--  UEF ACU Cluster Missle Pack
UEFACUClusterMIssileProjectile = Class(SinglePolyTrailProjectile) {
    DestroyOnImpact = false,
    FxTrails = ACUsEffectTemplate.UEFCruiseMissile01Trails,
    FxTrailOffset = -0.3,
    FxTrailScale = 1.5,
    BeamName = '/effects/emitters/missile_munition_exhaust_beam_01_emit.bp',

    FxImpactUnit = EffectTemplate.TMissileHit01,
    FxImpactLand = EffectTemplate.TMissileHit01,
    FxImpactProp = EffectTemplate.TMissileHit01,
    FxImpactUnderWater = {},
}

UEFACUClusterMIssileProjectile02 = Class(EmitterProjectile) {
    DestroyOnImpact = false,
    FxTrails = {'/effects/emitters/mortar_munition_01_emit.bp',},
    FxTrailOffset = 0,
    FxTrailScale = 4.5,

    FxImpactUnit = EffectTemplate.TShipGaussCannonHitUnit02,
    FxImpactProp = EffectTemplate.TShipGaussCannonHit02,
    FxImpactLand = EffectTemplate.TShipGaussCannonHit02,
    FxImpactUnderWater = {},
}

--  Serephim Quantum Storm
SeraACUQuantumStormProjectile01 = Class(EmitterProjectile) {
    FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.SDFExperimentalPhasonProjFXTrails01,
    FxImpactUnit = ACUsEffectTemplate.SeraACUQuantumStormProjectileHitUnit,
    FxImpactProp = ACUsEffectTemplate.SeraACUQuantumStormProjectileHit01,
    FxImpactLand = ACUsEffectTemplate.SeraACUQuantumStormProjectileHit01,
    FxImpactWater = ACUsEffectTemplate.SeraACUQuantumStormProjectileHit01,
    FxImpactShield = ACUsEffectTemplate.SeraACUQuantumStormProjectileHit01,

    FxLandHitScale = 0.5,
    FxPropHitScale = 0.5,
    FxUnitHitScale = 0.5,
    FxWaterHitScale = 0.5,
    FxShieldHitScale = 0.5,
}

SeraACUQuantumStormProjectile02 = Class(EmitterProjectile) {
    FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.SDFExperimentalPhasonProjFXTrails01,
    FxImpactUnit = ACUsEffectTemplate.SeraACUQuantumStormProjectileHitUnit,
    FxImpactProp = ACUsEffectTemplate.SeraACUQuantumStormProjectileHit01,
    FxImpactLand = ACUsEffectTemplate.SeraACUQuantumStormProjectileHit01,
    FxImpactWater = ACUsEffectTemplate.SeraACUQuantumStormProjectileHit01,
    FxImpactShield = ACUsEffectTemplate.SeraACUQuantumStormProjectileHit01,

    FxLandHitScale = 0.7,
    FxPropHitScale = 0.7,
    FxUnitHitScale = 0.7,
    FxWaterHitScale = 0.7,
    FxShieldHitScale = 0.7,
}

SeraACUQuantumStormProjectile03 = Class(EmitterProjectile) {
    FxImpactTrajectoryAligned = false,
    FxTrails = EffectTemplate.SDFExperimentalPhasonProjFXTrails01,
    FxImpactUnit = ACUsEffectTemplate.SeraACUQuantumStormProjectileHitUnit,
    FxImpactProp = ACUsEffectTemplate.SeraACUQuantumStormProjectileHit01,
    FxImpactLand = ACUsEffectTemplate.SeraACUQuantumStormProjectileHit01,
    FxImpactWater = ACUsEffectTemplate.SeraACUQuantumStormProjectileHit01,
    FxImpactShield = ACUsEffectTemplate.SeraACUQuantumStormProjectileHit01,

    FxLandHitScale = 0.7,
    FxPropHitScale = 0.7,
    FxUnitHitScale = 0.7,
    FxWaterHitScale = 0.7,
    FxShieldHitScale = 0.7,
}

--  Serephim Rapid Cannon
SeraRapidCannon01Projectile = Class(MultiPolyTrailProjectile) {
    FxImpactNone = EffectTemplate.SDFAireauWeaponHit01,
    FxImpactUnit = EffectTemplate.SDFAireauWeaponHitUnit,
    FxImpactProp = EffectTemplate.SDFAireauWeaponHit01,
    FxImpactLand = EffectTemplate.SDFAireauWeaponHit01,
    FxImpactWater= EffectTemplate.SDFAireauWeaponHit01,
    FxImpactShield = EffectTemplate.SDFAireauWeaponHit01,
    RandomPolyTrails = 1,

    PolyTrails = ACUsEffectTemplate.SeraACURapidCannonPoly,
    PolyTrailOffset = {0,0,0},

    FxLandHitScale = 0.7,
    FxPropHitScale = 0.7,
    FxUnitHitScale = 0.7,
    FxWaterHitScale = 0.7,
    FxShieldHitScale = 0.7,
}

--  Serephim Rapid Cannon V2
SeraRapidCannon01Projectile02 = Class(MultiPolyTrailProjectile) {
    FxImpactNone = EffectTemplate.SDFAireauWeaponHit01,
    FxImpactUnit = EffectTemplate.SDFAireauWeaponHitUnit,
    FxImpactProp = EffectTemplate.SDFAireauWeaponHit01,
    FxImpactLand = EffectTemplate.SDFAireauWeaponHit01,
    FxImpactWater= EffectTemplate.SDFAireauWeaponHit01,
    FxImpactShield = EffectTemplate.SDFAireauWeaponHit01,
    RandomPolyTrails = 1,

    PolyTrails = ACUsEffectTemplate.SeraACURapidCannonPoly02,
    PolyTrailOffset = {0,0,0},

    FxLandHitScale = 0.7,
    FxPropHitScale = 0.7,
    FxUnitHitScale = 0.7,
    FxWaterHitScale = 0.7,
    FxShieldHitScale = 0.7,
}

--  Serephim Rapid Cannon V3
SeraRapidCannon01Projectile03 = Class(MultiPolyTrailProjectile) {
    FxImpactNone = EffectTemplate.SDFAireauWeaponHit01,
    FxImpactUnit = EffectTemplate.SDFAireauWeaponHitUnit,
    FxImpactProp = EffectTemplate.SDFAireauWeaponHit01,
    FxImpactLand = EffectTemplate.SDFAireauWeaponHit01,
    FxImpactWater= EffectTemplate.SDFAireauWeaponHit01,
    FxImpactShield = EffectTemplate.SDFAireauWeaponHit01,
    RandomPolyTrails = 1,

    PolyTrails = ACUsEffectTemplate.SeraACURapidCannonPoly03,
    PolyTrailOffset = {0,0,0},

    FxLandHitScale = 0.7,
    FxPropHitScale = 0.7,
    FxUnitHitScale = 0.7,
    FxWaterHitScale = 0.7,
    FxShieldHitScale = 0.7,
}

InvisoProjectile01 = Class(MultiCompositeEmitterProjectile) {
    FxImpactUnit = ACUsEffectTemplate.CybranACUEMPArrayHit01,
    FxImpactProp = ACUsEffectTemplate.CybranACUEMPArrayHit01,
    FxImpactLand = ACUsEffectTemplate.CybranACUEMPArrayHit01,
    FxImpactWater = ACUsEffectTemplate.CybranACUEMPArrayHit01,
    FxImpactShield = ACUsEffectTemplate.CybranACUEMPArrayHit01,
    FxImpactUnderWater = {},
    FxSplatScale = 4,

    FxLandHitScale = 0.5,
    FxPropHitScale = 0.5,
    FxUnitHitScale = 0.5,
    FxWaterHitScale = 0.5,
    FxShieldHitScale = 0.5,

    OnImpact = function(self, targetType, targetEntity)
        local army = self:GetArmy()

        local blanketSides = 6
        local blanketAngle = (2 * math.pi) / blanketSides
        local blanketStrength = 0.75
        local blanketVelocity = 6.25

        for i = 0, blanketSides - 1 do
            local blanketX = math.sin(i * blanketAngle)
            local blanketZ = math.cos(i * blanketAngle)
            self:CreateProjectile('/effects/entities/EffectProtonAmbient01/EffectProtonAmbient01_proj.bp', blanketX, 0.25, blanketZ, blanketX, 0, blanketZ)
                :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
        end

        MultiCompositeEmitterProjectile.OnImpact(self, targetType, targetEntity)
    end,
}

InvisoProjectile02 = Class(MultiCompositeEmitterProjectile) {
    FxImpactUnit = ACUsEffectTemplate.CybranACUEMPArrayHit01,
    FxImpactProp = ACUsEffectTemplate.CybranACUEMPArrayHit01,
    FxImpactLand = ACUsEffectTemplate.CybranACUEMPArrayHit01,
    FxImpactWater = ACUsEffectTemplate.CybranACUEMPArrayHit01,
    FxImpactShield = ACUsEffectTemplate.CybranACUEMPArrayHit01,
    FxImpactUnderWater = {},
    FxSplatScale = 6,

    FxLandHitScale = 0.75,
    FxPropHitScale = 0.75,
    FxUnitHitScale = 0.75,
    FxWaterHitScale = 0.75,
    FxShieldHitScale = 0.75,

    OnImpact = function(self, targetType, targetEntity)
        local army = self:GetArmy()

        local blanketSides = 9
        local blanketAngle = (2 * math.pi) / blanketSides
        local blanketStrength = 0.75
        local blanketVelocity = 6.25

        for i = 0, blanketSides - 1 do
            local blanketX = math.sin(i * blanketAngle)
            local blanketZ = math.cos(i * blanketAngle)
            self:CreateProjectile('/effects/entities/EffectProtonAmbient01/EffectProtonAmbient01_proj.bp', blanketX, 0.25, blanketZ, blanketX, 0, blanketZ)
                :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
        end

        MultiCompositeEmitterProjectile.OnImpact(self, targetType, targetEntity)
    end,
}

InvisoProjectile03 = Class(MultiCompositeEmitterProjectile) {
    FxImpactUnit = ACUsEffectTemplate.CybranACUEMPArrayHit01,
    FxImpactProp = ACUsEffectTemplate.CybranACUEMPArrayHit01,
    FxImpactLand = ACUsEffectTemplate.CybranACUEMPArrayHit01,
    FxImpactWater = ACUsEffectTemplate.CybranACUEMPArrayHit01,
    FxImpactShield = ACUsEffectTemplate.CybranACUEMPArrayHit01,
    FxImpactUnderWater = {},
    FxSplatScale = 8,

    FxLandHitScale = 0.75,
    FxPropHitScale = 0.75,
    FxUnitHitScale = 0.75,
    FxWaterHitScale = 0.75,
    FxShieldHitScale = 0.75,

    OnImpact = function(self, targetType, targetEntity)
        local army = self:GetArmy()

        local blanketSides = 12
        local blanketAngle = (2 * math.pi) / blanketSides
        local blanketStrength = 0.75
        local blanketVelocity = 6.25

        for i = 0, blanketSides - 1 do
            local blanketX = math.sin(i * blanketAngle)
            local blanketZ = math.cos(i * blanketAngle)
            self:CreateProjectile('/effects/entities/EffectProtonAmbient01/EffectProtonAmbient01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
                :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
        end

        MultiCompositeEmitterProjectile.OnImpact(self, targetType, targetEntity)
    end,
}

-- Serephim Overcharge Projectile
SOmegaCannonOverCharge = Class(MultiPolyTrailProjectile) {
    FxImpactTrajectoryAligned = false,
    FxImpactLand = ACUsEffectTemplate.OmegaOverChargeLandHit,
    FxImpactNone = ACUsEffectTemplate.OmegaOverChargeLandHit,
    FxImpactProp = ACUsEffectTemplate.OmegaOverChargeLandHit,
    FxImpactUnit = ACUsEffectTemplate.OmegaOverChargeUnitHit,
    FxImpactShield = ACUsEffectTemplate.OmegaOverChargeLandHit,
    FxLandHitScale = 4,
    FxPropHitScale = 4,
    FxUnitHitScale = 4,
    FxNoneHitScale = 4,
    FxShieldHitScale = 4,
    FxTrails = ACUsEffectTemplate.OmegaOverChargeProjectileFxTrails,
    PolyTrails = ACUsEffectTemplate.OmegaOverChargeProjectileFxTrails,
    PolyTrailOffset = {0,0,0},
}

--  UEF Gatling Projectile V3
UEFHeavyPlasmaGatlingCannon03 = Class(SinglePolyTrailProjectile) {
    FxImpactTrajectoryAligned = false,
    FxImpactUnit = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactProp = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactWater = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactLand = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactShield = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactUnderWater = {},
    FxTrails = EffectTemplate.THeavyPlasmaGatlingCannonFxTrails,
    PolyTrail = ACUsEffectTemplate.UEFHeavyPlasmaGatlingCannon03PolyTrail,
}

--  UEF Gatling Projectile V2
UEFHeavyPlasmaGatlingCannon01 = Class(SinglePolyTrailProjectile) {
    FxImpactTrajectoryAligned = false,
    FxImpactUnit = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactProp = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactWater = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactLand = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactShield = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactUnderWater = {},
    FxTrails = EffectTemplate.THeavyPlasmaGatlingCannonFxTrails,
    PolyTrail = ACUsEffectTemplate.UEFHeavyPlasmaGatlingCannon01PolyTrail,
}

--  UEF Gatling Projectile V3
UEFHeavyPlasmaGatlingCannon02 = Class(SinglePolyTrailProjectile) {
    FxImpactTrajectoryAligned = false,
    FxImpactUnit = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactProp = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactWater = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactLand = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactShield = EffectTemplate.THeavyPlasmaGatlingCannonHit,
    FxImpactUnderWater = {},
    FxTrails = EffectTemplate.THeavyPlasmaGatlingCannonFxTrails,
    PolyTrail = ACUsEffectTemplate.UEFHeavyPlasmaGatlingCannon02PolyTrail,
}
