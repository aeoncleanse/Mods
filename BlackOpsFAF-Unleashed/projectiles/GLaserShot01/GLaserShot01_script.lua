-- Aeon Artillery Projectile

local GLaserProjectile = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsProjectiles.lua').GLaserProjectile

GLaser01 = Class(GLaserProjectile) {
    OnImpact = function(self, TargetType, TargetEntity)
        self:CreateProjectile('/mods/BlackOpsFAF-Unleashed/effects/entities/GoldLaserBombEffectController01/GoldLaserBombEffectController01_proj.bp', 0, 0, 0, 0, 0, 0):SetCollision(false)
        GLaserProjectile.OnImpact(self, TargetType, TargetEntity)
    end,
}

TypeClass = GLaser01
