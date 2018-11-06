-------------------------------------------------------------------
-- File     :  /data/projectiles/XCannon0105/XCannon0105_script.lua
-- Author(s):  Gordon Duclos, Matt Vainio
-- Summary  :  Cybran Proton Artillery projectile script, XRL0403
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
-------------------------------------------------------------------

local XCannonProjectile = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsProjectiles.lua').XCannonProjectile

XCannon01 = Class(XCannonProjectile) {
    OnImpact = function(self, TargetType, TargetEntity)
        self:ShakeCamera(15, 0.25, 0, 0.2)
        XCannonProjectile.OnImpact (self, TargetType, TargetEntity)
    end,

    OnImpactDestroy = function(self, targetType, targetEntity)
        if targetEntity and not IsUnit(targetEntity) then
            XCannonProjectile.OnImpactDestroy(self, targetType, targetEntity)
            return
        end

        if self.counter then
            if self.counter >= 5 then
                XCannonProjectile.OnImpactDestroy(self, targetType, targetEntity)
                return
            else
                self.counter = self.counter + 1
            end
        else
            self.counter = 1
        end

        if targetEntity then
            self.lastimpact = targetEntity:GetEntityId()
        end
    end,
}

TypeClass = XCannon01
