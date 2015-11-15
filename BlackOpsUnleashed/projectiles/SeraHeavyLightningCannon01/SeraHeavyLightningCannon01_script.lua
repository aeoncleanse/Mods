--****************************************************************************
--**
-- File     :  /data/projectiles/SDFHeavyQuarnonCannon01/SDFHeavyQuarnonCannon01_script.lua
-- Author(s):  Gordon Duclos
--**
-- Summary  :  Heavy Quarnon Cannon Projectile script, XSS0302
--**
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local EffectTemplate = import('/lua/EffectTemplates.lua')
local SHeavyQuarnonCannon = import('/lua/seraphimprojectiles.lua').SHeavyQuarnonCannon
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

SDFHeavyQuarnonCannon01 = Class(SHeavyQuarnonCannon) {


    OnImpact = function(self, TargetType, TargetEntity) 
            --if TargetType == 'Shield' then
            --    if self.Data > TargetEntity:GetHealth() then
            --        Damage(self, {0,0,0}, TargetEntity, TargetEntity:GetHealth(), 'Normal')
            --    else
            --        Damage(self, {0,0,0}, TargetEntity, self.Data, 'Normal')
            --    end
            --end                
        
        local FxFragEffect = EffectTemplate.SThunderStormCannonProjectileSplitFx 
       -- local ChildProjectileBP = '/projectiles/SeraHeavyLightningCannonChild01/SeraHeavyLightningCannonChild01_proj.bp'  
              
        nukeProjectile = self:CreateProjectile('/projectiles/SeraHeavyLightningCannonChild01/SeraHeavyLightningCannonChild01_proj.bp', 0, 0, 0, nil, nil, nil)--:SetCollision(false)
        local pos = self:GetPosition()
        pos[2] = pos[2] + 4
        Warp( nukeProjectile, pos)
        nukeProjectile:PassDamageData(self.DamageData) 
        ------ Split effects
        for k, v in FxFragEffect do
            CreateEmitterAtEntity( self, self:GetArmy(), v )
        end
        
        --[[
        local vx, vy, vz = self:GetVelocity()
        local velocity = 4
    
        -- One initial projectile following same directional path as the original
        --self:CreateChildProjectile(ChildProjectileBP):SetVelocity(vx, vy, vz):SetVelocity(velocity):PassDamageData(self.DamageData)
           
        -- Create several other projectiles in a dispersal pattern
        local numProjectiles = 1
        
        local angle = (2*math.pi) / numProjectiles
        local angleInitial = RandomFloat( 0, angle )
        
        -- Randomization of the spread
        local angleVariation = angle * 0.8 -- Adjusts angle variance spread
        local spreadMul = 0.15 -- Adjusts the width of the dispersal        
        
        --vy= -0.8
        
        local xVec = 0
        local yVec = vy
        local zVec = 0
     

        -- Launch projectiles at semi-random angles away from split location
        for i = 0, (numProjectiles -1) do
            xVec = vx + (math.sin(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul
            zVec = vz + (math.cos(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul 
            local proj = self:CreateChildProjectile(ChildProjectileBP)
            proj:SetVelocity(xVec,yVec,zVec)
            proj:SetVelocity(velocity)
            proj:PassDamageData(self.DamageData)                        
        end
        ]]--
        self:Destroy()
        
    end,
}
TypeClass = SDFHeavyQuarnonCannon01