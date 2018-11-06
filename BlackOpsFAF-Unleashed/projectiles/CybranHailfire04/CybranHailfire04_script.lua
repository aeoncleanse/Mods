-- Cybran Anti Air Projectile

local CybranHailfire04Projectile = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsProjectiles.lua').CybranHailfire04Projectile

CAANanoDart02 = Class(CybranHailfire04Projectile) {
   OnCreate = function(self)
        CybranHailfire04Projectile.OnCreate(self)
        for k, v in self.FxTrails do
            CreateEmitterOnEntity(self,self:GetArmy(),v)
        end
   end,

}

TypeClass = CAANanoDart02
