-----------------------------------------------------------------
-- File     :  /cdimage/units/BAB2404/BAB2404_script.lua
-- Author(s):  David Tomandl
-- Summary  :  Aeon Land Factory Tier 3 Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local ALandFactoryUnit = import('/lua/aeonunits.lua').ALandFactoryUnit

BAB2404 = Class(ALandFactoryUnit) {
    DeathThreadDestructionWaitTime = 8,
    BuildingEffect01 = {
        '/effects/emitters/light_blue_blinking_01_emit.bp',
    },

    BuildingEffect02 = {
        '/effects/emitters/light_red_03_emit.bp',
    },

    OnStopBeingBuilt = function(self,builder,layer)
        ALandFactoryUnit.OnStopBeingBuilt(self,builder,layer)
        self.BuildingEffect01Bag = {}
        self.BuildingEffect02Bag = {}
        local mul = 1
        local sx = 1 or 1
        local sz = 1 or 1
        local sy = 1 or sx + sz

        for i = 1, 16 do
            local fxname
            if i < 10 then
                fxname = 'Light0' .. i
            else
                fxname = 'Light' .. i
            end
            local fx = CreateAttachedEmitter(self, fxname, self:GetArmy(), '/effects/emitters/light_yellow_02_emit.bp'):OffsetEmitter(0, 0, 0.01):ScaleEmitter(3)
            self.Trash:Add(fx)
        end
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        ALandFactoryUnit.OnStartBuild(self, unitBeingBuilt, order)
        local drone = unitBeingBuilt
        self.PetDrone = drone
        self.PetDrone.Parent = self

        -- Drone clean up scripts
        if self.BuildingEffect01Bag then
            for k, v in self.BuildingEffect01Bag do
                v:Destroy()
            end
            self.BuildingEffect01Bag = {}
        end
        for k, v in self.BuildingEffect01 do
            table.insert(self.BuildingEffect01Bag, CreateAttachedEmitter(self, 'BlinkyLight01', self:GetArmy(), v):OffsetEmitter(0, 0, 0.01):ScaleEmitter(1.00))
            table.insert(self.BuildingEffect01Bag, CreateAttachedEmitter(self, 'BlinkyLight02', self:GetArmy(), v):OffsetEmitter(0, 0, 0.01):ScaleEmitter(1.00))
            table.insert(self.BuildingEffect01Bag, CreateAttachedEmitter(self, 'BlinkyLight03', self:GetArmy(), v):OffsetEmitter(0, 0, 0.01):ScaleEmitter(1.00))
            table.insert(self.BuildingEffect01Bag, CreateAttachedEmitter(self, 'BlinkyLight04', self:GetArmy(), v):OffsetEmitter(0, 0, 0.01):ScaleEmitter(1.00))
            table.insert(self.BuildingEffect01Bag, CreateAttachedEmitter(self, 'BlinkyLight05', self:GetArmy(), v):OffsetEmitter(0, 0, 0.01):ScaleEmitter(1.00))
            table.insert(self.BuildingEffect01Bag, CreateAttachedEmitter(self, 'BlinkyLight06', self:GetArmy(), v):OffsetEmitter(0, 0, 0.01):ScaleEmitter(1.00))
            table.insert(self.BuildingEffect01Bag, CreateAttachedEmitter(self, 'BlinkyLight07', self:GetArmy(), v):OffsetEmitter(0, 0, 0.01):ScaleEmitter(1.00))
            table.insert(self.BuildingEffect01Bag, CreateAttachedEmitter(self, 'BlinkyLight08', self:GetArmy(), v):OffsetEmitter(0, 0, 0.01):ScaleEmitter(1.00))
        end
        if self.BuildingEffect02Bag then
            for k, v in self.BuildingEffect02Bag do
                v:Destroy()
            end
            self.BuildingEffect02Bag = {}
        end
        for k, v in self.BuildingEffect02 do
            table.insert(self.BuildingEffect02Bag, CreateAttachedEmitter(self, 'BlinkyLight09', self:GetArmy(), v):OffsetEmitter(0, 0, 0.01):ScaleEmitter(1.00))
            table.insert(self.BuildingEffect02Bag, CreateAttachedEmitter(self, 'BlinkyLight10', self:GetArmy(), v):OffsetEmitter(0, 0, 0.01):ScaleEmitter(1.00))
            table.insert(self.BuildingEffect02Bag, CreateAttachedEmitter(self, 'BlinkyLight11', self:GetArmy(), v):OffsetEmitter(0, 0, 0.01):ScaleEmitter(1.00))
            table.insert(self.BuildingEffect02Bag, CreateAttachedEmitter(self, 'BlinkyLight12', self:GetArmy(), v):OffsetEmitter(0, 0, 0.01):ScaleEmitter(1.00))
            table.insert(self.BuildingEffect02Bag, CreateAttachedEmitter(self, 'BlinkyLight13', self:GetArmy(), v):OffsetEmitter(0, 0, 0.01):ScaleEmitter(1.00))
            table.insert(self.BuildingEffect02Bag, CreateAttachedEmitter(self, 'BlinkyLight14', self:GetArmy(), v):OffsetEmitter(0, 0, 0.01):ScaleEmitter(1.00))
            table.insert(self.BuildingEffect02Bag, CreateAttachedEmitter(self, 'BlinkyLight15', self:GetArmy(), v):OffsetEmitter(0, 0, 0.01):ScaleEmitter(1.00))
            table.insert(self.BuildingEffect02Bag, CreateAttachedEmitter(self, 'BlinkyLight16', self:GetArmy(), v):OffsetEmitter(0, 0, 0.01):ScaleEmitter(1.00))
        end
    end,

    OnStopBuild = function(self, unitBeingBuilt, order)
        ALandFactoryUnit.OnStopBuild(self, unitBeingBuilt, order)
        if self.BuildingEffect01Bag then
            for k, v in self.BuildingEffect01Bag do
                v:Destroy()
            end
            self.BuildingEffect01Bag = {}
        end
        if self.BuildingEffect02Bag then
            for k, v in self.BuildingEffect02Bag do
                v:Destroy()
            end
            self.BuildingEffect02Bag = {}
        end
    end,

    FinishBuildThread = function(self, unitBeingBuilt, order)
        ALandFactoryUnit.FinishBuildThread(self, unitBeingBuilt, order)
        self:PlayUnitSound('LaunchSat')
        self:AddBuildRestriction(categories.BUILTBYARTEMIS)
    end,


    NotifyOfDroneDeath = function(self)
        -- Remove build restriction if sat has been lost
        self.PetDrone = nil
        if self and not self.Dead then
            self:RemoveBuildRestriction(categories.BUILTBYARTEMIS)
        end
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        if self.PetDrone then
            self.PetDrone:Kill(self, 'Normal', 0)
            self.PetDrone = nil
        end
        ALandFactoryUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
}

TypeClass = BAB2404
