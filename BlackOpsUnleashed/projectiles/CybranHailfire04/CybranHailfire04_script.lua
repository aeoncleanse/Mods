--
-- Cybran Anti Air Projectile
--

local CybranHailfire04Projectile = import('/mods/BlackOpsUnleashed/lua/BlackOpsprojectiles.lua').CybranHailfire04Projectile
local Explosion = import('/lua/defaultexplosions.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

CAANanoDart02 = Class(CybranHailfire04Projectile) {

   OnCreate = function(self)
        CybranHailfire04Projectile.OnCreate(self)
        for k, v in self.FxTrails do
            CreateEmitterOnEntity(self,self:GetArmy(),v )
        end
        --self.MoveThread = self:ForkThread(self.MovementThread)
   end,
   
}

TypeClass = CAANanoDart02
