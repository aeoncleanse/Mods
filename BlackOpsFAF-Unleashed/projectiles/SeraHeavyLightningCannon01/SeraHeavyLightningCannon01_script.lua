-------------------------------------------------------------------------------------------
-- File     :  /data/projectiles/SDFHeavyQuarnonCannon01/SDFHeavyQuarnonCannon01_script.lua
-- Author(s):  Gordon Duclos
-- Summary  :  Heavy Quarnon Cannon Projectile script, XSS0302
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
-------------------------------------------------------------------------------------------

local EffectTemplate = import('/lua/EffectTemplates.lua')
local SHeavyQuarnonCannon = import('/lua/seraphimprojectiles.lua').SHeavyQuarnonCannon

SDFHeavyQuarnonCannon01 = Class(SHeavyQuarnonCannon) {
    OnImpact = function(self, TargetType, TargetEntity)
        SHeavyQuarnonCannon.OnImpact(self, TargetType, TargetEntity)
        local FxFragEffect = EffectTemplate.SThunderStormCannonProjectileSplitFx
        nukeProjectile = self:CreateProjectile('/mods/BlackOpsFAF-Unleashed/projectiles/SeraHeavyLightningCannonChild01/SeraHeavyLightningCannonChild01_proj.bp', 0, 0, 0, nil, nil, nil)
        local pos = self:GetPosition()
        pos[2] = pos[2] + 4
        Warp(nukeProjectile, pos)
        nukeProjectile:PassDamageData(self.DamageData)

        for k, v in FxFragEffect do
            CreateEmitterAtEntity(self, self:GetArmy(), v)
        end

        self:Destroy()
    end,
}

TypeClass = SDFHeavyQuarnonCannon01
