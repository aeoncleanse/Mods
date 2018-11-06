local UEFClusterCruise01Projectile = import('/mods/BlackOpsFAF-EXUnits/lua/EXBlackOpsprojectiles.lua').UEFClusterCruise01Projectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local SingleBeamProjectile = import('/lua/sim/defaultprojectiles.lua').SingleBeamProjectile

UEFClusterCruise01 = Class(UEFClusterCruise01Projectile) {

    FxImpactUnit = EffectTemplate.TMissileHit01,
    FxImpactLand = EffectTemplate.TMissileHit01,
    FxImpactProp = EffectTemplate.TMissileHit01,
    FxAirUnitHitScale = 1,
    FxLandHitScale = 1,
    FxNoneHitScale = 1,
    FxPropHitScale = 1,
    FxProjectileHitScale = 1,
    FxProjectileUnderWaterHitScale = 1,
    FxShieldHitScale = 01,
    FxUnderWaterHitScale = 1,
    FxUnitHitScale = 1,
    FxWaterHitScale = 1,
    FxOnKilledScale = 1,

    OnCreate = function(self)
        UEFClusterCruise01Projectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 1.2)
        self:ForkThread(self.CruiseMissileThread)
    end,

    CruiseMissileThread = function(self)
        self:SetTurnRate(180)
        WaitSeconds(2)
        self:SetTurnRate(180)
        WaitSeconds(1)
        self:SetTurnRate(360)
    end,

    --OnImpact = function(self, targetType, targetEntity)
    --    local army = self:GetArmy()
     --   CreateLightParticle(self, -1, army, 3, 4, 'glow_03', 'ramp_fire_01')
     --   SingleBeamProjectile.OnImpact(self, targetType, targetEntity)
    --end,

    OnExitWater = function(self)
        UEFClusterCruise01Projectile.OnExitWater(self)
        self:SetDestroyOnWater(true)
    end,

}
TypeClass = UEFClusterCruise01