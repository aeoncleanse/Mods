#
# Aeon Serpentine Missile
#
local MIRVChild01Projectile = import('/lua/BlackOpsprojectiles.lua').MIRVChild01Projectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

MIRVChild01 = Class(MIRVChild01Projectile) {
    OnCreate = function(self)
        MIRVChild01Projectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2)
    end,
	OnImpact = function(self, TargetType, targetEntity)
        local rotation = RandomFloat(0,2*math.pi)
        #local size = RandomFloat(13,5)
        
        CreateDecal(self:GetPosition(), rotation, 'scorch_004_albedo', '', 'Albedo', 13, 13, 300, 15, self:GetArmy())
 
        MIRVChild01Projectile.OnImpact( self, TargetType, targetEntity )
    end,	
}

TypeClass = MIRVChild01