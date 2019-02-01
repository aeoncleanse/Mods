-----------------------------------------------------------------
-- File     :  /units/XSL0310/XSL0310_script.lua
-- Summary  :  Seraphim Heavy Bot Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local SWalkingLandUnit = import('/lua/seraphimunits.lua').SWalkingLandUnit
local SDFThauCannon = import('/lua/seraphimweapons.lua').SDFThauCannon
local SAMElectrumMissileDefense = import('/lua/seraphimweapons.lua').SAMElectrumMissileDefense

BSL0310 = Class(SWalkingLandUnit) {
    Weapons = {
        MainGun = Class(SDFThauCannon) {},
        AntiMissile = Class(SAMElectrumMissileDefense) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        SWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        self.lambdaEmitterTable = {}
        self:SetScriptBit('RULEUTC_ShieldToggle', true)
        self:ForkThread(self.ResourceThread)
    end,

    OnScriptBitSet = function(self, bit)
        SWalkingLandUnit.OnScriptBitSet(self, bit)
        local army =  self:GetArmy()
        if bit == 0 then
        self:SetMaintenanceConsumptionActive()
        self:ForkThread(self.LambdaEmitter)
        end
    end,

    OnScriptBitClear = function(self, bit)
        SWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 0 then
        self:ForkThread(self.KillLambdaEmitter)
        self:SetMaintenanceConsumptionInactive()
        end
    end,

    LambdaEmitter = function(self)
        -- Are we dead yet, if not then wait 0.5 second
        if not self.Dead then
            WaitSeconds(0.5)
            -- Are we dead yet, if not spawn lambdaEmitter
            if not self.Dead then

                -- Gets the platforms current orientation
                local platOrient = self:GetOrientation()

                -- Gets the current position of the platform in the game world
                local location = self:GetPosition('Torso')

                -- Creates our lambdaEmitter over the platform with a randomly generated Orientation
                local lambdaEmitter = CreateUnit('bsb0005', self:GetArmy(), location[1], location[2], location[3], platOrient[1], platOrient[2], platOrient[3], platOrient[4], 'Land')

                -- Adds the newly created lambdaEmitter to the parent platforms lambdaEmitter table
                table.insert (self.lambdaEmitterTable, lambdaEmitter)

                lambdaEmitter:AttachTo(self, 'Torso')

                -- Sets the platform unit as the lambdaEmitter parent
                lambdaEmitter:SetParent(self, 'bsl0310')
                lambdaEmitter:SetCreator(self)
                self.Trash:Add(lambdaEmitter)
            end
        end
    end,

    KillLambdaEmitter = function(self, instigator, type, overkillRatio)
        -- Small bit of table manipulation to sort thru all of the avalible rebulder bots and remove them after the platform is dead
        if table.getn({self.lambdaEmitterTable}) > 0 then
            for k, v in self.lambdaEmitterTable do
                IssueClearCommands({self.lambdaEmitterTable[k]})
                IssueKillSelf({self.lambdaEmitterTable[k]})
            end
        end
    end,
    ResourceThread = function(self)
        if not self.Dead then
            local energy = self:GetAIBrain():GetEconomyStored('Energy')
            if  energy <= 10 then
                self:SetScriptBit('RULEUTC_ShieldToggle', false)
                self:ForkThread(self.ResourceThread2)
            else
                self:ForkThread(self.EconomyWaitUnit)
            end
        end
    end,

    EconomyWaitUnit = function(self)
        if not self.Dead then
        WaitSeconds(2)
            if not self.Dead then
                self:ForkThread(self.ResourceThread)
            end
        end
    end,

    ResourceThread2 = function(self)
        if not self.Dead then
            local energy = self:GetAIBrain():GetEconomyStored('Energy')
            if  energy > 300 then
                self:SetScriptBit('RULEUTC_ShieldToggle', true)
                self:ForkThread(self.ResourceThread)
            else
                self:ForkThread(self.EconomyWaitUnit2)
            end
        end
    end,

    EconomyWaitUnit2 = function(self)
        if not self.Dead then
        WaitSeconds(2)
            if not self.Dead then
                self:ForkThread(self.ResourceThread2)
            end
        end
    end,
}

TypeClass = BSL0310
