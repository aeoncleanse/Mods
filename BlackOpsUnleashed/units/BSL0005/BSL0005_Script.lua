-----------------------------------------------------------------
-- File     :  /cdimage/units/XSL0005/XSL0005_script.lua
-- Author(s):  Dru Staltman, Aaron Lundquist
-- Summary  :  Seraphim Siege Tank Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local SLandUnit = import('/lua/seraphimunits.lua').SLandUnit
local WeaponsFile = import('/lua/seraphimweapons.lua')
local SDFThauCannon = WeaponsFile.SDFThauCannon
local SDFAireauBolter = WeaponsFile.SDFAireauBolterWeapon
local SANUallCavitationTorpedo = WeaponsFile.SANUallCavitationTorpedo
local EffectUtil = import('/lua/EffectUtilities.lua')

BSL0005 = Class(SLandUnit) {
    Weapons = {
        MainTurret = Class(SDFThauCannon) {},
        Torpedo01 = Class(SANUallCavitationTorpedo) {},
        LeftTurret = Class(SDFAireauBolter) {},
        RightTurret = Class(SDFAireauBolter) {},
    },
    
    -- Sets up parent call backs between drone and parent
    Parent = nil,

    SetParent = function(self, parent, droneName)
        self.Parent = parent
        self.Drone = droneName
    end,

    -- Thrust and exhaust effect pathing
    ExhaustLaunch01 = '/effects/emitters/seraphim_inaino_launch_01_emit.bp',
    ExhaustLaunch02 = '/effects/emitters/seraphim_inaino_launch_02_emit.bp',
    ExhaustLaunch03 = '/effects/emitters/seraphim_inaino_launch_03_emit.bp',
    ExhaustLaunch04 = '/effects/emitters/seraphim_inaino_launch_04_emit.bp',
    ExhaustLaunch05 = '/effects/emitters/seraphim_inaino_launch_05_emit.bp',

----------------------------------------------------

    OnStopBeingBuilt = function(self, builder, layer)
    SLandUnit.OnStopBeingBuilt(self,builder,layer)
        if not self:IsDead() then
            -- Start of launch special effects
            self:ForkThread(self.LaunchEffects)
            self:SetMaintenanceConsumptionActive()
            self:ForkThread(self.ResourceThread)
            self:SetVeterancy(5)

            -- Global Varibles
            self.LaunchExhaustEffectsBag = {}
            self.DeathExhaustEffectsBag = {}
        end
    end,

    LaunchEffects = function(self)
        if not self:IsDead() then
            -- Launch Sound effect
            self:PlayUnitSound('Launch')

            -- Attaches effects to drone during launch
            table.insert(self.LaunchExhaustEffectsBag, CreateAttachedEmitter(self, 'XSL0303', self:GetArmy(), self.ExhaustLaunch01))
            table.insert(self.LaunchExhaustEffectsBag, CreateAttachedEmitter(self, 'XSL0303', self:GetArmy(), self.ExhaustLaunch02))
            table.insert(self.LaunchExhaustEffectsBag, CreateAttachedEmitter(self, 'XSL0303', self:GetArmy(), self.ExhaustLaunch03))
            table.insert(self.LaunchExhaustEffectsBag, CreateAttachedEmitter(self, 'XSL0303', self:GetArmy(), self.ExhaustLaunch04))
            table.insert(self.LaunchExhaustEffectsBag, CreateAttachedEmitter(self, 'XSL0303', self:GetArmy(), self.ExhaustLaunch05))

            -- Duration of launch
            WaitSeconds(1)

            -- Launch effect clean up
            if not self:IsDead() then
                EffectUtil.CleanupEffectBag(self,'LaunchExhaustEffectsBag')
            end
        end
    end,
    
    OnKilled = function(self, instigator, type, overkillRatio)
        -- Disables weapons
        self:SetWeaponEnabledByLabel('MainTurret', false)
        self:SetWeaponEnabledByLabel('Torpedo01', false)
        self:SetWeaponEnabledByLabel('LeftTurret', false)
        self:SetWeaponEnabledByLabel('RightTurret', false)

        -- Clears the current drone commands if any 
        IssueClearCommands(self)

        -- Notifies parent of drone death and clears the offending drone from the parents table
        self:ForkThread(self.DeathEffects)

        -- Final command to finish off the drones death event
        SLandUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
    
    DeathEffects = function(self)
        if self:IsDead() then
            -- Launch Sound effect
            self:PlayUnitSound('Launch')

            -- Attaches effects to drone during launch
            table.insert(self.DeathExhaustEffectsBag, CreateAttachedEmitter(self, 'AttachPoint', self:GetArmy(), self.ExhaustLaunch01))
            table.insert(self.DeathExhaustEffectsBag, CreateAttachedEmitter(self, 'AttachPoint', self:GetArmy(), self.ExhaustLaunch02))
            table.insert(self.DeathExhaustEffectsBag, CreateAttachedEmitter(self, 'AttachPoint', self:GetArmy(), self.ExhaustLaunch03))
            table.insert(self.DeathExhaustEffectsBag, CreateAttachedEmitter(self, 'AttachPoint', self:GetArmy(), self.ExhaustLaunch04))
            table.insert(self.DeathExhaustEffectsBag, CreateAttachedEmitter(self, 'AttachPoint', self:GetArmy(), self.ExhaustLaunch05))

            -- Duration of Death
            WaitSeconds(1)

            -- Launch effect clean up
            if not self:IsDead() then
                EffectUtil.CleanupEffectBag(self,'DeathExhaustEffectsBag')
            end
        end
    end,
        ResourceThread = function(self)
        if not self:IsDead() then
            local energy = self:GetAIBrain():GetEconomyStored('Energy')

            -- Check to see if the player has enough mass / energy
            if  energy <= 10 then
                self:ForkThread(self.KillFactory)
            else
                self:ForkThread(self.EconomyWaitUnit)
            end
        end    
    end,

    EconomyWaitUnit = function(self)
        if not self:IsDead() then
        WaitSeconds(4)
            if not self:IsDead() then
                self:ForkThread(self.ResourceThread)
            end
        end
    end,
    
    KillFactory = function(self)
        self:Kill()
    end,
}

TypeClass = BSL0005
