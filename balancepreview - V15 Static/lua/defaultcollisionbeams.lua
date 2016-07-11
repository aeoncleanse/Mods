------------------------------------------------------------------------------
--	File		:	/lua/defaultcollisionbeams.lua
--	Author(s)	:	Resin Smoker
--	Copyright © 2015 Public Release, All rights reserved.
------------------------------------------------------------------------------

local CollisionBeam = import('/lua/sim/CollisionBeam.lua').CollisionBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Custom_Beam_EffectTemplate = import('/mods/balancepreview/lua/effecttemplates.lua')
local utilities = import('/lua/utilities.lua')
EmtBpPath = '/effects/emitters/'

RefractorBeam = Class(CollisionBeam) {

	-- Default beam FX
	FxImpactUnit = EffectTemplate.DefaultProjectileLandUnitImpact,
	FxUnitHitScale = 0.3,
	FxImpactLand = EffectTemplate.DefaultProjectileLandImpact,
	FxLandHitScale = 0.3,
	FxImpactWater = EffectTemplate.DefaultProjectileWaterImpact,
	FxImpactUnderWater = EffectTemplate.DefaultProjectileUnderWaterImpact,
	FxImpactAirUnit = EffectTemplate.DefaultProjectileAirUnitImpact,
	FxImpactProp = {},
	FxImpactShield = {},
	FxImpactNone = {},

	OnImpact = function(self, impactType, targetEntity)
		-- Triggers Scorch effect but only if a ScorchSize is defined
		if impactType == 'Terrain' and self.ScorchSize then
			if self.Scorching == nil then
				self.Scorching = self:ForkThread(self.ScorchThread)
			end
		elseif not impactType == 'Unit' and self.ScorchSize then
			KillThread(self.Scorching)
			self.Scorching = nil
		end
		CollisionBeam.OnImpact(self, impactType, targetEntity)
	end,

	DoDamage = function(self, instigator, damageData, targetEntity)
		-- Ensure we have valid data
		if self and damageData and targetEntity then            
		    -- Set the lifetime of the beam effects
		    local beamLifeTime
		    local wpBp = self.Weapon:GetBlueprint()
		    if wpBp.BeamLifetime ~= 0 then
			    beamLifeTime = wpBp.BeamLifetime
		    elseif wpBp.BeamCollisionDelay then
			    beamLifeTime = wpBp.BeamCollisionDelay
		    else
			    WARN("No beam lifetime parameters declared, killing beam")
                return
		    end
			-- Ensure we have an instigator of some type
			if not instigator then
                WARN("No instigator present? Killing beam")
				return
			end
            
			-- Jump beam to other targets only if ChainJumps and ChainRange are defined
			if self.MinChainJumps and self.MaxChainJumps and self.ChainRange then
            
                -- Randomise the arcing behaviour if necessary
                local actualJumps
                if self.MinChainJumps ~= self.MaxChainJumps then
                    actualJumps = math.random(self.MinChainJumps, self.MaxChainJumps)
                else 
                    actualJumps = self.MinChainJumps
                end
                
                if actualJumps == 0 then
                    CollisionBeam.DoDamage(self, instigator, damageData, targetEntity)
                else
                    -- Check for targets in range
                    local tPos = targetEntity:GetPosition()
                    local targetsInRange = {}
                    targetsInRange = utilities.GetEnemyUnitsInSphere(self, tPos, self.ChainRange)
                    table.removeByValue(targetsInRange, targetEntity)
                    
                    -- Sort available targets by desired pattern
                    local targsByHealth = {}
                    for k, v in targetsInRange do
                        if not v:BeenDestroyed() then
                            table.insert(targsByHealth, {health = v:GetHealth(), unit = v})
                        end
                    end
                    table.sort(targsByHealth, sort_by('health'))
                    
                    -- Check if targets available beyond the first
                    local numTargets = table.getsize(targsByHealth)
                    if numTargets == 0 then
                        CollisionBeam.DoDamage(self, instigator, damageData, targetEntity)
                    else
                        -- Randomly select jump targets
                        local army = self:GetArmy()
                        local actualTarg = {}
                        for c = 1, actualJumps do
                            table.insert(actualTarg, targsByHealth[c].unit)
                        end
                        
                        -- Manipulate the damage spread
                        local storedDamage = damageData.DamageAmount
                        local num = math.min(actualJumps, numTargets)
                        local chainDamage = (storedDamage * self.ChainDamageMult) / num
                        local boltDamage = storedDamage * self.BoltDamageMult
                        
                        -- Loop through available targets
                        while self and num > 0 do
                            -- Create beam and dmg FX
                            self:ForkThread(self.ChainBeamFX, targetEntity, actualTarg[num], army, beamLifeTime)
                            self:ForkThread(self.ChainDmgFX, targetEntity, army, self.FxBeamEndPointScale, beamLifeTime)
                            -- Apply chain damage
                            self:ForkThread(self.ChainDamage, instigator, actualTarg[num], chainDamage, damageData.DamageType)
                            num = num - 1
                        end
                        
                        -- Apply bolt damage
                        damageData.DamageAmount = boltDamage
                        CollisionBeam.DoDamage(self, instigator, damageData, targetEntity)
                        
                        -- Reset the damageData amount so that adjustments don't stack
                        damageData.DamageAmount = storedDamage
                    end
                end
		    else
                CollisionBeam.DoDamage(self, instigator, damageData, targetEntity)
            end
		end
	end,

	ChainBeamFX = function(self, target1, target2, army, duration)
		for f, g in self.FxBeam do
			if target1 and not target1:BeenDestroyed() and target2 and not target2:BeenDestroyed() then
			   local beam = AttachBeamEntityToEntity(target1, -1, target2, -1, army, g)
			   table.insert(self.BeamEffectsBag, beam)
			   self.Trash:Add(beam)
			   WaitSeconds(duration)
			   if self and beam then
				   beam:Destroy()
			   end
		   end
		end
	end,

	ChainDmgFX = function(self, target, army, scale, duration)
		for h, i in self.FxBeamEndPoint do
			if target and not target:BeenDestroyed() then
				local fx = CreateAttachedEmitter(target, -1, army, i ):ScaleEmitter(scale)
				table.insert(self.BeamEffectsBag, fx)
				self.Trash:Add(fx)
				WaitSeconds(duration)
				if self and fx then
					fx:Destroy()
				end
			end
		end
	end,

	ChainDamage = function(self, instigator, target, dmg, dmgtype)
		if target and not target:BeenDestroyed() then
			Damage(instigator, self:GetPosition(), target, dmg, dmgtype)
		end
	end,

	ScorchThread = function(self)
		local army = self:GetArmy()
		local CurrentPosition = self:GetPosition(1)
		local LastPosition = Vector(0,0,0)
		local skipCount = 1
		while true do
			if utilities.GetDistanceBetweenTwoVectors( CurrentPosition, LastPosition ) > 0.25 or skipCount > 100 then
				local size = utilities.GetRandomFloat( -self.ScorchSize , self.ScorchSize )
				CreateSplat( CurrentPosition, utilities.GetRandomFloat(0,2*math.pi), self.ScorchTexture, size, size, 25, 25, army )
				LastPosition = CurrentPosition
				skipCount = 1
			else
				skipCount = skipCount + self.ScorchSplatDropTime
			end
			WaitSeconds( self.ScorchSplatDropTime or 0.1 )
			CurrentPosition = self:GetPosition(1)
		end
	end,

	OnDisable = function( self )
		CollisionBeam.OnDisable(self)
		KillThread(self.Scorching)
		self.Scorching = nil
	end,
}

Chain_LightningBeam = Class(RefractorBeam) {
    MinChainJumps = 4,
	MaxChainJumps = 4,
	ChainRange = 10,
    BoltDamageMult = 1,
    ChainDamageMult = 0.125,
	FxBeamStartPoint = EffectTemplate.SExperimentalUnstablePhasonLaserMuzzle01,
	FxBeam = Custom_Beam_EffectTemplate.LightingStrikeBeam,
	FxBeamEndPoint = EffectTemplate.OthuyElectricityStrikeHit,
	FxBeamEndPointScale = 0.1,
	ScorchSize = 0.5,
	ScorchSplatDropTime = 0.1,
	ScorchTexture = 'czar_mark01_albedo',
	TerrainImpactType = 'LargeBeam01',
	TerrainImpactScale = 1,
}