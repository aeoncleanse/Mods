-----------------------------------------------------------------
-- File     :  /cdimage/units/XRB4309/XRB4309_script.lua
-- Author(s):  David Tomandl, Greg Kohne
-- Summary  :  Cybran Shield Generator lvl 5 Script
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit
local Shield = import('/lua/shield.lua').Shield

BRB4209 = Class(CStructureUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        CStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetScriptBit('RULEUTC_ShieldToggle', true)
        self:DisableUnitIntel('unitScript', 'CloakField') -- Used to show anti-tele range
        self.antiteleportEmitterTable = {}
        self:ForkThread(self.ResourceThread)
    end,

    OnScriptBitSet = function(self, bit)
           CStructureUnit.OnScriptBitSet(self, bit)
           if bit == 0 then
               self:ForkThread(self.antiteleportEmitter)
            self:SetMaintenanceConsumptionActive()
        end
    end,

    OnScriptBitClear = function(self, bit)
        CStructureUnit.OnScriptBitClear(self, bit)
        if bit == 0 then
            self:ForkThread(self.KillantiteleportEmitter)
            self:SetMaintenanceConsumptionInactive()
        end
    end,

    antiteleportEmitter = function(self)
        if not self.Dead then
            WaitSeconds(0.5)
            if not self.Dead then
                -- Gets the platforms current orientation
                local platOrient = self:GetOrientation()

                -- Gets the current position of the platform in the game world
                local location = self:GetPosition('Shaft')

                -- Creates our antiteleportEmitter over the platform with a ranomly generated Orientation
                local antiteleportEmitter = CreateUnit('brb0007', self:GetArmy(), location[1], location[2], location[3], platOrient[1], platOrient[2], platOrient[3], platOrient[4], 'Land')

                -- Adds the newly created antiteleportEmitter to the parent platforms antiteleportEmitter table
                table.insert (self.antiteleportEmitterTable, antiteleportEmitter)

                antiteleportEmitter:AttachTo(self, 'Shaft')

                -- Sets the platform unit as the antiteleportEmitter parent
                antiteleportEmitter:SetParent(self, 'brb4209')
                antiteleportEmitter:SetCreator(self)
                self.Trash:Add(antiteleportEmitter)
            end
        end
    end,

    KillantiteleportEmitter = function(self, instigator, type, overkillRatio)
        -- Small bit of table manipulation to sort thru all of the avalible rebulder bots and remove them after the platform is dead
        if table.getn({self.antiteleportEmitterTable}) > 0 then
            for k, v in self.antiteleportEmitterTable do
                IssueClearCommands({self.antiteleportEmitterTable[k]})
                IssueKillSelf({self.antiteleportEmitterTable[k]})
            end
        end
    end,

    ResourceThread = function(self)
        if not self.Dead then
            local energy = self:GetAIBrain():GetEconomyStored('Energy')

            -- Check to see if the player has enough mass / energy
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

            -- Check to see if the player has enough mass / energy
            if  energy >= 3000 then
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

TypeClass = BRB4209
