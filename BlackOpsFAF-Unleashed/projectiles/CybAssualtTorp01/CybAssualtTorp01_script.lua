-----------------------------------------------------------------------------
-- File     :  /data/projectiles/CANKrilTorpedo01/CANKrilTorpedo01_script.lua
-- Author(s):  Gordon Duclos, Matt Vainio
-- Summary  :  Kril Torpedo Projectile script, XRB2308
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------------------

local AssaultTorpedoSubProjectile = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsProjectiles.lua').AssaultTorpedoSubProjectile

CANKrilTorpedo01 = Class(AssaultTorpedoSubProjectile) {

    FxEnterWater = {'/effects/emitters/water_splash_ripples_ring_01_emit.bp',
                    '/effects/emitters/water_splash_plume_01_emit.bp',
                },
    TrailDelay = 2,

    OnEnterWater = function(self)
        AssaultTorpedoSubProjectile.OnEnterWater(self)
        local army = self:GetArmy()
        for i in self.FxEnterWater do
            CreateEmitterAtEntity(self,army,self.FxEnterWater[i])
        end
    end,
}

TypeClass = CANKrilTorpedo01
