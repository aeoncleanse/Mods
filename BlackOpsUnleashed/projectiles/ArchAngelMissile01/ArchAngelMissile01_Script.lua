--****************************************************************************
--**
-- File     :  /data/projectiles/AIFGuidedMissile02/AIFGuidedMissile02_script.lua
-- Author(s):  Gordon Duclos
--**
-- Summary  :  Aeon Guided Split Missile, DAA0206
--**
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local AGuidedMissileProjectile = import('/lua/aeonprojectiles.lua').AGuidedMissileProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local BlackOpsEffectTemplate = import('/mods/BlackOpsUnleashed/lua/BlackOpsEffectTemplates.lua')

AIFGuidedMissile02 = Class(AGuidedMissileProjectile) {
    --FxTrailScale = 0.5,
    --[[
    FxImpactUnit = BlackOpsEffectTemplate.ArchAngelMissileHit,
    FxImpactProp = BlackOpsEffectTemplate.ArchAngelMissileHit,
    FxImpactNone = BlackOpsEffectTemplate.ArchAngelMissileHit,
    FxImpactLand = BlackOpsEffectTemplate.ArchAngelMissileHit,
    
    OnImpact = function(self, targetType, targetEntity)
        AGuidedMissileProjectile.OnImpact(self, targetType, targetEntity)
        local position = self:GetPosition()
        local spiritUnit1 = CreateUnitHPR('BAB0005', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)

        
        -- Create effects for spawning of energy being
        for k, v in EffectTemplate.SerRiftIn_Small do
            CreateAttachedEmitter(spiritUnit1, -1, self:GetArmy(), v ):ScaleEmitter(1)
        end    
    end,
    ]]--
    
}
TypeClass = AIFGuidedMissile02

