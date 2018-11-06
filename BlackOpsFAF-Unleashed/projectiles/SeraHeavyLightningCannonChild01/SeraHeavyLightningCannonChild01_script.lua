-------------------------------------------------------------------------------------------------------------------
-- File     :  /data/projectiles/SeraHeavyLightningCannonChildProj01/SeraHeavyLightningCannonChildProj01_script.lua
-- Author(s):  Matt Vainio
-- Summary  :  Experimental Phason Projectile script, XSL0401
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
-- Aeon "Annihilator" BFG Projectile
-- Author Resin_Smoker
-- Projectile based off ideas and scripts from Seiya's lobber mod
-------------------------------------------------------------------------------------------------------------------

local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local EmitterProjectile = DefaultProjectileFile.EmitterProjectile
local SeraHeavyLightningCannonChildProjectile = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsProjectiles.lua').SeraHeavyLightningCannonChildProjectile
local EffectTemplate = import('/lua/EffectTemplates.lua')
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local utilities = import('/lua/utilities.lua')

SeraHeavyLightningCannonChild01 = Class(SeraHeavyLightningCannonChildProjectile) {
    AttackBeams = {'/mods/BlackOpsFAF-Unleashed/effects/emitters/seraphim_lightning_beam_02_emit.bp'},
    FxBeam = {'/mods/BlackOpsFAF-Unleashed/effects/emitters/seraphim_lightning_beam_02_emit.bp'},
    FxBeamScale = 0.01,
    OnCreate = function(self)
        SeraHeavyLightningCannonChildProjectile.OnCreate(self)
        self:ForkThread(self.BFG)
    end,

    BFG = function(self)
        -- Setup the FX bag
        local arcFXBag = {}
        local radius = 0.5
        local army = self:GetArmy()
        -- Small delay before BFG effect become active
        -- While projectile active and has available damage perform BFG area damage and effects
        while not self:BeenDestroyed() do
            local instigator = self:GetLauncher()
            if not instigator then
                break
            end
            local launcherPos = instigator:GetPosition()
            local projPos = self:GetPosition()
            local dist = 0
            if projPos[1] and projPos[3] and launcherPos[1] and launcherPos[3] then
                dist = VDist2(projPos[1], projPos[3], launcherPos[1], launcherPos[3])
            end
            local firer = self:GetLauncher()
            local brain = firer:GetAIBrain()
            local availableTargets = brain:GetUnitsAroundPoint(categories.ALLUNITS, self:GetPosition(), dist * 0.15, 'Enemy')
            if dist > 5 and availableTargets then
                if table.getn(availableTargets) > 4 then
                    for i = 0, (4 -1) do
                        local ranTarget =Random(1,table.getn(availableTargets))
                        local target = availableTargets[ranTarget]
                        -- Set the beam damage equal to a fraction of the projectiles avalible DMG pool
                        local beamDmgAmt = self.DamageData.DamageAmount * 0.025
                        -- Reduce the projectiles DamageAmount by what the beam amount did
                        self:PlaySound(self:GetBlueprint().Audio['Arc'])
                        for k, v in availableTargets do
                            Damage(self:GetLauncher(), target:GetPosition(), target, beamDmgAmt, 'Normal')
                            -- Attach beam to the target
                            for k, a in self.FxBeam do
                            local beam = AttachBeamEntityToEntity(self, -1, target, -1, self:GetArmy(), a)
                                table.insert(arcFXBag, beam)
                                self.Trash:Add(beam)
                            end
                        end
                    end
                elseif table.getn(availableTargets) <= 4 then
                    for i = 0, (4 -1) do
                        local ranTarget =Random(1,table.getn(availableTargets))
                        local target = availableTargets[ranTarget]
                        -- Set the beam damage equal to a fraction of the projectiles avalible DMG pool
                        local beamDmgAmt = self.DamageData.DamageAmount * 0.025
                        -- Reduce the projectiles DamageAmount by what the beam amount did
                        self:PlaySound(self:GetBlueprint().Audio['Arc'])
                        for k, v in availableTargets do
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
}

TypeClass = SeraHeavyLightningCannonChild01
