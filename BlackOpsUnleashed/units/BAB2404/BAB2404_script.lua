--****************************************************************************
--**
-- File     :  /cdimage/units/BAB2404/BAB2404_script.lua
-- Author(s):  David Tomandl
--**
-- Summary  :  Aeon Land Factory Tier 3 Script
--**
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

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
        --self.DroneTable = {}
        --LOG(repr(self.DroneTable))
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
    
    OnStartBuild = function(self, unitBeingBuilt, order )
        ALandFactoryUnit.OnStartBuild(self, unitBeingBuilt, order )
            --supposed to define drone variable as the unit currently being built and then add it to the DroneTable
            local drone = unitBeingBuilt
            self.PetDrone = drone
            --LOG(repr(self.DroneTable))
            drone:SetParent(self)
            
            ------Drone clean up scripts
            --self.Trash:Add(drone)
            if self.BuildingEffect01Bag then
                for k, v in self.BuildingEffect01Bag do
                    v:Destroy()
                end
                self.BuildingEffect01Bag = {}
            end
            for k, v in self.BuildingEffect01 do
                table.insert( self.BuildingEffect01Bag, CreateAttachedEmitter( self, 'BlinkyLight01', self:GetArmy(), v ):OffsetEmitter(0, 0, 0.01):ScaleEmitter( 1.00 ) )
                table.insert( self.BuildingEffect01Bag, CreateAttachedEmitter( self, 'BlinkyLight02', self:GetArmy(), v ):OffsetEmitter(0, 0, 0.01):ScaleEmitter( 1.00 ) )
                table.insert( self.BuildingEffect01Bag, CreateAttachedEmitter( self, 'BlinkyLight03', self:GetArmy(), v ):OffsetEmitter(0, 0, 0.01):ScaleEmitter( 1.00 ) )
                table.insert( self.BuildingEffect01Bag, CreateAttachedEmitter( self, 'BlinkyLight04', self:GetArmy(), v ):OffsetEmitter(0, 0, 0.01):ScaleEmitter( 1.00 ) )
                table.insert( self.BuildingEffect01Bag, CreateAttachedEmitter( self, 'BlinkyLight05', self:GetArmy(), v ):OffsetEmitter(0, 0, 0.01):ScaleEmitter( 1.00 ) )
                table.insert( self.BuildingEffect01Bag, CreateAttachedEmitter( self, 'BlinkyLight06', self:GetArmy(), v ):OffsetEmitter(0, 0, 0.01):ScaleEmitter( 1.00 ) )
                table.insert( self.BuildingEffect01Bag, CreateAttachedEmitter( self, 'BlinkyLight07', self:GetArmy(), v ):OffsetEmitter(0, 0, 0.01):ScaleEmitter( 1.00 ) )
                table.insert( self.BuildingEffect01Bag, CreateAttachedEmitter( self, 'BlinkyLight08', self:GetArmy(), v ):OffsetEmitter(0, 0, 0.01):ScaleEmitter( 1.00 ) )
            end
            if self.BuildingEffect02Bag then
                for k, v in self.BuildingEffect02Bag do
                    v:Destroy()
                end
                self.BuildingEffect02Bag = {}
            end
            for k, v in self.BuildingEffect02 do
                table.insert( self.BuildingEffect02Bag, CreateAttachedEmitter( self, 'BlinkyLight09', self:GetArmy(), v ):OffsetEmitter(0, 0, 0.01):ScaleEmitter( 1.00 ) )
                table.insert( self.BuildingEffect02Bag, CreateAttachedEmitter( self, 'BlinkyLight10', self:GetArmy(), v ):OffsetEmitter(0, 0, 0.01):ScaleEmitter( 1.00 ) )
                table.insert( self.BuildingEffect02Bag, CreateAttachedEmitter( self, 'BlinkyLight11', self:GetArmy(), v ):OffsetEmitter(0, 0, 0.01):ScaleEmitter( 1.00 ) )
                table.insert( self.BuildingEffect02Bag, CreateAttachedEmitter( self, 'BlinkyLight12', self:GetArmy(), v ):OffsetEmitter(0, 0, 0.01):ScaleEmitter( 1.00 ) )
                table.insert( self.BuildingEffect02Bag, CreateAttachedEmitter( self, 'BlinkyLight13', self:GetArmy(), v ):OffsetEmitter(0, 0, 0.01):ScaleEmitter( 1.00 ) )
                table.insert( self.BuildingEffect02Bag, CreateAttachedEmitter( self, 'BlinkyLight14', self:GetArmy(), v ):OffsetEmitter(0, 0, 0.01):ScaleEmitter( 1.00 ) )
                table.insert( self.BuildingEffect02Bag, CreateAttachedEmitter( self, 'BlinkyLight15', self:GetArmy(), v ):OffsetEmitter(0, 0, 0.01):ScaleEmitter( 1.00 ) )
                table.insert( self.BuildingEffect02Bag, CreateAttachedEmitter( self, 'BlinkyLight16', self:GetArmy(), v ):OffsetEmitter(0, 0, 0.01):ScaleEmitter( 1.00 ) )
            end
    end,
    
    OnStopBuild = function(self, unitBeingBuilt, order )
        ALandFactoryUnit.OnStopBuild(self, unitBeingBuilt, order )
        self.PetDrone = nil
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
    
    FinishBuildThread = function(self, unitBeingBuilt, order )
        ALandFactoryUnit.FinishBuildThread(self, unitBeingBuilt, order )
        LOG('*SAT FINISHED BUILDING RESTRICT BUILD QUEUE')
        --LOG(repr(self.DroneTable))
            self:PlayUnitSound('LaunchSat')
            self:AddBuildRestriction( categories.BUILTBYSTATION )
    end,
    
    
    NotifyOfDroneDeath = function(self)
        ------ remove build restriction if sat has been lost
            LOG('*sat HAS BEEN LOST LETS MAKE ANOTHER')
            self.PetDrone = nil
            self:RemoveBuildRestriction( categories.BUILTBYSTATION )
    end,
    
    OnKilled = function(self, instigator, type, overkillRatio)
        ALandFactoryUnit.OnKilled(self, instigator, type, overkillRatio)
        LOG('*STATION IS DEAD DESTROY ANY ACTIVE SATS')
        --LOG(repr(self.DroneTable))
        --
        if self.PetDrone then
    --      kill self, using normal damage, and no overkill.
            self.PetDrone:Kill(self, 'Normal', 0)
            self.PetDrone = nil
        end
    end,
    --[[
    OnCaptured = function(self, captor)
        if self and not self:IsDead() and self.Satellite and not self.Satellite:IsDead() and captor and not captor:IsDead() and self:GetAIBrain() ~= captor:GetAIBrain() then
            self:DoUnitCallbacks('OnCaptured', captor)
            local newUnitCallbacks = {}
            if self.EventCallbacks.OnCapturedNewUnit then
                newUnitCallbacks = self.EventCallbacks.OnCapturedNewUnit
            end
            local entId = self:GetEntityId()
            local unitEnh = SimUnitEnhancements[entId]
            local captorArmyIndex = captor:GetArmy()
            local captorBrain = false
            
            -- For campaigns:
            -- We need the brain to ignore army cap when transfering the unit
            -- do all necessary steps to set brain to ignore, then un-ignore if necessary the unit cap
            
            if ScenarioInfo.CampaignMode then
                captorBrain = captor:GetAIBrain()
                SetIgnoreArmyUnitCap(captorArmyIndex, true)
            end
            
            --Satellite stuff
            self.Satellite:DoUnitCallbacks('OnCaptured', captor)
            local newSatUnitCallbacks = {}
            if self.Satellite.EventCallbacks.OnCapturedNewUnit then
                newSatUnitCallbacks = self.Satellite.EventCallbacks.OnCapturedNewUnit
            end
            local satId = self:GetEntityId()
            local satEnh = SimUnitEnhancements[satId]
            local sat = ChangeUnitArmy(self.Satellite, captorArmyIndex)
            
            --Unit stuff
            local newUnit = ChangeUnitArmy(self, captorArmyIndex)
            if newUnit then
                newUnit.Satellite = sat
            end
                        
            if ScenarioInfo.CampaignMode and not captorBrain.IgnoreArmyCaps then
                SetIgnoreArmyUnitCap(captorArmyIndex, false)
            end
            
            if unitEnh then
                for k,v in unitEnh do
                    newUnit:CreateEnhancement(v)
                end
            end
            for k,cb in newUnitCallbacks do
                if cb then
                    cb(newUnit, captor)
                end
            end
            
            --Satellite stuff
            if satEnh then
                for k,v in satEnh do
                    sat:CreateEnhancement(v)
                end
            end
            for k,cb in newSatUnitCallbacks do
                if cb then
                    cb(sat, captor)
                end
            end
        end
    end,
    ]]--
}

TypeClass = BAB2404