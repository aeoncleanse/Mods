-----------------------------------------------------------------
-- File     :  /cdimage/units/BAB4309/BAB4309_script.lua
-- Author(s):  John Comes, Dave Tomandl, Jessica St. Croix
-- Summary  :  Aeon Power Generator Script
-- Copyright © 1205 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit

BAB4309 = Class(AStructureUnit) {

    AntiTeleportEffects = {
        '/effects/emitters/aeon_gate_02_emit.bp',
        '/effects/emitters/aeon_gate_03_emit.bp',
    },

    AmbientEffects = {
        '/effects/emitters/aeon_shield_generator_t3_04_emit.bp',
    },

    OnStopBeingBuilt = function(self,builder,layer)
        AStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetScriptBit('RULEUTC_ShieldToggle', true)
        self:DisableUnitIntel('unitScript', 'CloakField') -- Used to show anti-tele range
        self.AntiTeleportEffectsBag = {}
        self.AmbientEffectsBag = {}
        self.antiteleportEmitterTable = {}
        self:ForkThread(self.ResourceThread)

        self.Trash:Add(CreateRotator(self, 'Sphere', 'x', nil, 0, 15, 80 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere', 'y', nil, 0, 15, 80 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere', 'z', nil, 0, 15, 80 + Random(0, 20)))

        self.Trash:Add(CreateRotator(self, 'Sphere01', 'x', nil, 0, 40, 120 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere01', 'y', nil, 0, 40, 120 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere01', 'z', nil, 0, 40, 120 + Random(0, 20)))

        self.Trash:Add(CreateRotator(self, 'Sphere02', 'x', nil, 0, 40, 120 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere02', 'y', nil, 0, 40, 120 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere02', 'z', nil, 0, 40, 120 + Random(0, 20)))

        self.Trash:Add(CreateRotator(self, 'Sphere03', 'x', nil, 0, 40, 120 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere03', 'y', nil, 0, 40, 120 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere03', 'z', nil, 0, 40, 120 + Random(0, 20)))

        self.Trash:Add(CreateRotator(self, 'Sphere04', 'x', nil, 0, 40, 120 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere04', 'y', nil, 0, 40, 120 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere04', 'z', nil, 0, 40, 120 + Random(0, 20)))

        self.Trash:Add(CreateRotator(self, 'Sphere05', 'x', nil, 0, 40, 120 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere05', 'y', nil, 0, 40, 120 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere05', 'z', nil, 0, 40, 120 + Random(0, 20)))

        self.Trash:Add(CreateRotator(self, 'Sphere06', 'x', nil, 0, 40, 120 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere06', 'y', nil, 0, 40, 120 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere06', 'z', nil, 0, 40, 120 + Random(0, 20)))

        self.Trash:Add(CreateRotator(self, 'Sphere07', 'x', nil, 0, 40, 120 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere07', 'y', nil, 0, 40, 120 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere07', 'z', nil, 0, 40, 120 + Random(0, 20)))

        self.Trash:Add(CreateRotator(self, 'Sphere08', 'x', nil, 0, 40, 120 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere08', 'y', nil, 0, 40, 120 + Random(0, 20)))
        self.Trash:Add(CreateRotator(self, 'Sphere08', 'z', nil, 0, 40, 120 + Random(0, 20)))
    end,

    OnScriptBitSet = function(self, bit)
        AStructureUnit.OnScriptBitSet(self, bit)
        if bit == 0 then
            self:ForkThread(self.antiteleportEmitter)
            self:ForkThread(self.AntiteleportEffects)
            self:SetMaintenanceConsumptionActive()

        end
    end,

    AntiteleportEffects = function(self)
        if self.AntiTeleportEffectsBag then
            for k, v in self.AntiTeleportEffectsBag do
                v:Destroy()
            end
            self.AntiTeleportEffectsBag = {}
        end
        for k, v in self.AntiTeleportEffects do
            table.insert(self.AntiTeleportEffectsBag, CreateAttachedEmitter(self, 'Effect01', self:GetArmy(), v):ScaleEmitter(0.3))
            table.insert(self.AntiTeleportEffectsBag, CreateAttachedEmitter(self, 'Effect02', self:GetArmy(), v):ScaleEmitter(0.3))
            table.insert(self.AntiTeleportEffectsBag, CreateAttachedEmitter(self, 'Effect03', self:GetArmy(), v):ScaleEmitter(0.3))
            table.insert(self.AntiTeleportEffectsBag, CreateAttachedEmitter(self, 'Effect04', self:GetArmy(), v):ScaleEmitter(0.3))
            table.insert(self.AntiTeleportEffectsBag, CreateAttachedEmitter(self, 'Effect05', self:GetArmy(), v):ScaleEmitter(0.3))
            table.insert(self.AntiTeleportEffectsBag, CreateAttachedEmitter(self, 'Effect06', self:GetArmy(), v):ScaleEmitter(0.3))
            table.insert(self.AntiTeleportEffectsBag, CreateAttachedEmitter(self, 'Effect07', self:GetArmy(), v):ScaleEmitter(0.3))
            table.insert(self.AntiTeleportEffectsBag, CreateAttachedEmitter(self, 'Effect08', self:GetArmy(), v):ScaleEmitter(0.3))
        end
        if self.AmbientEffectsBag then
            for k, v in self.AmbientEffectsBag do
                v:Destroy()
            end
            self.AmbientEffectsBag = {}
        end
        for k, v in self.AmbientEffects do
            table.insert(self.AmbientEffectsBag, CreateAttachedEmitter(self, 'XAB4309', self:GetArmy(), v):ScaleEmitter(0.4))
        end
    end,

    OnScriptBitClear = function(self, bit)
        AStructureUnit.OnScriptBitClear(self, bit)
        if bit == 0 then
            self:ForkThread(self.KillantiteleportEmitter)
            self:SetMaintenanceConsumptionInactive()
            if self.AntiTeleportEffectsBag then
                for k, v in self.AntiTeleportEffectsBag do
                    v:Destroy()
                end
                self.AntiTeleportEffectsBag = {}
            end
            if self.AmbientEffectsBag then
                for k, v in self.AmbientEffectsBag do
                    v:Destroy()
                end
                self.AmbientEffectsBag = {}
            end
        end
    end,

    antiteleportEmitter = function(self)
        -- Are we dead yet, if not then wait 0.5 second
        if not self.Dead then
            WaitSeconds(0.5)
            -- Are we dead yet, if not spawn antiteleportEmitter
            if not self.Dead then

                -- Gets the platforms current orientation
                local platOrient = self:GetOrientation()

                -- Gets the current position of the platform in the game world
                local location = self:GetPosition('XAB4309')

                -- Creates our antiteleportEmitter over the platform with a ranomly generated Orientation
                local antiteleportEmitter = CreateUnit('bab0003', self:GetArmy(), location[1], location[2], location[3], platOrient[1], platOrient[2], platOrient[3], platOrient[4], 'Land')

                -- Adds the newly created antiteleportEmitter to the parent platforms antiteleportEmitter table
                table.insert (self.antiteleportEmitterTable, antiteleportEmitter)

                -- Sets the platform unit as the antiteleportEmitter parent
                antiteleportEmitter:SetParent(self, 'bab4309')
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

TypeClass = BAB4309
