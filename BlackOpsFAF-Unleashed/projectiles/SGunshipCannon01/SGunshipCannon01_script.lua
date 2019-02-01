-------------------------------------------------------------------------
-- File     :  /data/projectiles/SDFTauCannon01/SDFTauCannon01_script.lua
-- Author(s):  Gordon Duclos
-- Summary  :  Tau Cannon Projectile script, XSL0303
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
-------------------------------------------------------------------------

local ShieldTauCannonProjectile = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsProjectiles.lua').ShieldTauCannonProjectile

STauCannon = Class(ShieldTauCannonProjectile) {
    OnImpact = function(self, TargetType, TargetEntity)
        ShieldTauCannonProjectile.OnImpact(self, TargetType, TargetEntity)
        if TargetType == 'Shield' then
            if self.Data and TargetEntity:GetHealth() > 0 and self.Data > TargetEntity:GetHealth() then
                Damage(self, {0,0,0}, TargetEntity, TargetEntity:GetHealth(), 'Normal')
            else
                Damage(self, {0,0,0}, TargetEntity, self.Data, 'Normal')
            end
        end
    end,
}

TypeClass = STauCannon
