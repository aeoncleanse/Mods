#****************************************************************************
#**
#**  File     :  /data/projectiles/SeraHeavyLightningCannonChildProj01/SeraHeavyLightningCannonChildProj01_script.lua
#**  Author(s):  Matt Vainio
#**
#**  Summary  :  Experimental Phason Projectile script, XSL0401
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#
# Aeon "Annihilator" BFG Projectile
# Author Resin_Smoker
# Projectile based off ideas and scripts from Seiya's lobber mod
#

local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local EmitterProjectile = DefaultProjectileFile.EmitterProjectile
local SeraHeavyLightningCannonChildProjectile = import('/lua/BlackOpsprojectiles.lua').SeraHeavyLightningCannonChildProjectile
--SeraHeavyLightningCannonChild01 = Class(SeraHeavyLightningCannonChildProjectile) {}
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local utilities = import('/lua/utilities.lua')

SeraHeavyLightningCannonChild01 = Class(SeraHeavyLightningCannonChildProjectile) {
   
    #FxTrails = EffectTemplate.SDFExperimentalPhasonProjFXTrails01,
    #FxTrailScale = 1,
    #FxImpactUnit =  EffectTemplate.SDFExperimentalPhasonProjHit01,
    #FxUnitHitScale = 0.5,
    #FxImpactProp =  EffectTemplate.SDFExperimentalPhasonProjHit01,
    #FxLandHitScale = 0.5,
    #FxImpactLand =  EffectTemplate.SDFExperimentalPhasonProjHit01,
    #FxPropHitScale = 0.5,
    AttackBeams = {'/effects/emitters/seraphim_lightning_beam_02_emit.bp'},

	FxBeam = {'/effects/emitters/seraphim_lightning_beam_02_emit.bp'},
	FxBeamScale = 0.01,
    OnCreate = function(self)
		SeraHeavyLightningCannonChildProjectile.OnCreate(self)
        --self:ForkThread(self.BFGThread)
		self:ForkThread(self.BFG)
    end,
   --[[
    BFGThread = function(self)
        WaitTicks(2)
        local beams = {}
        local avalibleTargets = {}
        while true do
			local instigator = self:GetLauncher()
            local launcherPos = instigator:GetPosition()
            local projPos = self:GetPosition()
            local dist = VDist2(projPos[1], projPos[3], launcherPos[1], launcherPos[3]) 
            local avalibleTargets = utilities.GetEnemyUnitsInSphere(self, self:GetPosition(), dist * 0.25)
            if dist > 5 and avalibleTargets then
                if table.getn(avalibleTargets) > 4 then
                    for i = 0, (4 -1) do
                        local ranTarget =Random(1,table.getn(avalibleTargets))
                       local target = avalibleTargets[ranTarget]   
                        DamageArea(instigator,target:GetPosition(),0.01,self.DamageData.DamageAmount*0.1,self.DamageData.DamageType,self.DamageData.DamageFriendly)
                        for k, v in self.AttackBeams do
                            local beam = AttachBeamEntityToEntity(self, -1, target, -1, self:GetArmy(), v)
							table.insert(beams, beam)
                            self.Trash:Add(beam)
                        end
                    end
                elseif table.getn(avalibleTargets) <= 4 then
                    for k, v in avalibleTargets do
   
                        local target = v
                        DamageArea(instigator,target:GetPosition(),0.01,self.DamageData.DamageAmount*0.1,self.DamageData.DamageType,self.DamageData.DamageFriendly)
						for k, v in self.AttackBeams do
                            local beam = AttachBeamEntityToEntity(self, -1, target, -1, self:GetArmy(), v)
							table.insert(beams, beam)
                            self.Trash:Add(beam)
                        end
                    end
                end
           end
           WaitTicks(2)
           for k, v in beams do
               v:Destroy()
           end
        end
    end,
	]]--
	
	BFG = function(self)
        -- Setup the FX bag
        local arcFXBag = {}
        local radius = 0.5
        local army = self:GetArmy()       
        -- Small delay before BFG effect become active
        --WaitSeconds(1)        
        -- While projectile active and has avalible damage perform BFG area damage and effects
        while not self:BeenDestroyed() do--and self.DamageData.DamageAmount > 0 do        
            -- Search for all enemy units in range
            --local units = {}
			--units = utilities.GetEnemyUnitsInSphere(self, self:GetPosition(), radius) 
			--if table.getsize(units) > 0 then   
			local instigator = self:GetLauncher()
            local launcherPos = instigator:GetPosition()
            local projPos = self:GetPosition()
            local dist = VDist2(projPos[1], projPos[3], launcherPos[1], launcherPos[3]) 
            local avalibleTargets = utilities.GetEnemyUnitsInSphere(self, self:GetPosition(), dist * 0.15)
            if dist > 5 and avalibleTargets then
                if table.getn(avalibleTargets) > 4 then
                    for i = 0, (4 -1) do      
						local ranTarget =Random(1,table.getn(avalibleTargets))
						local target = avalibleTargets[ranTarget]   
						-- Set the beam damage equal to a fraction of the projectiles avalible DMG pool
						local beamDmgAmt = self.DamageData.DamageAmount * 0.025            
						-- Reduce the projectiles DamageAmount by what the beam amount did
						--self.DamageData.DamageAmount = self.DamageData.DamageAmount - beamDmgAmt                   
						self:PlaySound(self:GetBlueprint().Audio['Arc'])                                   
						for k, v in avalibleTargets do
							--local target = v                  
							Damage(self:GetLauncher(), target:GetPosition(), target, beamDmgAmt, 'Normal') 
							-- Attach beam to the target
							for k, a in self.FxBeam do
							local beam = AttachBeamEntityToEntity(self, -1, target, -1, self:GetArmy(), a)
								table.insert(arcFXBag, beam)
								self.Trash:Add(beam)
							end
						end 
					end
				elseif table.getn(avalibleTargets) <= 4 then
					for i = 0, (4 -1) do      
						local ranTarget =Random(1,table.getn(avalibleTargets))
						local target = avalibleTargets[ranTarget]   
						-- Set the beam damage equal to a fraction of the projectiles avalible DMG pool
						local beamDmgAmt = self.DamageData.DamageAmount * 0.025            
						-- Reduce the projectiles DamageAmount by what the beam amount did
						--self.DamageData.DamageAmount = self.DamageData.DamageAmount - beamDmgAmt                   
						self:PlaySound(self:GetBlueprint().Audio['Arc'])                                   
						for k, v in avalibleTargets do
							--local target = v                  
							Damage(self:GetLauncher(), target:GetPosition(), target, beamDmgAmt, 'Normal') 
							-- Attach beam to the target
							for k, a in self.FxBeam do
							local beam = AttachBeamEntityToEntity(self, -1, target, -1, self:GetArmy(), a)
								table.insert(arcFXBag, beam)
								self.Trash:Add(beam)
							end
						end 
					end
				end                                                                     
            end            
            -- Small delay so that the beam and FX are visable
            WaitTicks(2)            
            -- Remove all FX
            for k, v in arcFXBag do
                v:Destroy()
            end            
            arcFXBag = {}              
            -- Small delay to show the FX removal
            WaitTicks(Random(2,5))          
        end
    end,

    #OnImpact = function(self, TargetType, targetEntity)
    #    local rotation = RandomFloat(0,2*math.pi)       
    #    CreateDecal(self:GetPosition(), rotation, 'crater_radial01_normals', '', 'Alpha Normals', 5, 5, 300, 0, self:GetArmy())
    #    CreateDecal(self:GetPosition(), rotation, 'crater_radial01_albedo', '', 'Albedo', 6, 6, 300, 0, self:GetArmy())
    #    SeraHeavyLightningCannonChildProjectile.OnImpact( self, TargetType, targetEntity )
    #end,
}

TypeClass = SeraHeavyLightningCannonChild01