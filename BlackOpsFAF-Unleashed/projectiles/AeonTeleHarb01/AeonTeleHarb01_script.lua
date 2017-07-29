-- Aeon Artillery Projectile

local MGHeadshotProjectile = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsProjectiles.lua').MGHeadshotProjectile

AeonTeleHarb01 = Class(MGHeadshotProjectile) {
    OnImpact = function(self, targetType, targetEntity)
        MGHeadshotProjectile.OnImpact(self, targetType, targetEntity)
        local myBlueprint = self:GetBlueprint()
        self:PlaySound(myBlueprint.Audio.CommanderArrival)
        self:CreateProjectile('/effects/entities/AeonUnitTeleporter01/AeonUnitTeleporter01_proj.bp', 0, 1, 0, nil, nil, nil):SetCollision(false)
    end,

}

TypeClass = AeonTeleHarb01
