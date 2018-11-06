-----------------------------------------------------------------
-- File     :  /cdimage/units/Effect01/Effect01_script.lua
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local SLandFactoryUnit = import('/lua/seraphimunits.lua').SLandFactoryUnit

BSB2402 = Class(SLandFactoryUnit) {
    OnStopBeingBuilt = function(self, builder, layer)
        SLandFactoryUnit.OnStopBeingBuilt(self, builder, layer)

        self.EffectsBag = {}
        local army = self:GetArmy()

        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_01_emit.bp'):ScaleEmitter(0.7)    -- glow
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_02_emit.bp'):ScaleEmitter(0.7)    -- plasma pillar
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_03_emit.bp'):ScaleEmitter(0.7)    -- darkening pillar
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_04_emit.bp'):ScaleEmitter(0.7)    -- ring outward dust/motion
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_05_emit.bp'):ScaleEmitter(0.7)    -- plasma pillar move
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_06_emit.bp'):ScaleEmitter(0.7)    -- darkening pillar move
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_07_emit.bp'):ScaleEmitter(0.7)    -- bright line at bottom / right side
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_08_emit.bp'):ScaleEmitter(0.7)    -- bright line at bottom / left side
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_09_emit.bp'):ScaleEmitter(0.7)    -- small flickery dots rising
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_10_emit.bp'):ScaleEmitter(0.7)    -- distortion
        CreateAttachedEmitter(self,'FX_07',army, '/effects/emitters/seraphim_rift_arch_top_01_emit.bp'):ScaleEmitter(0.7)        -- top part glow
        CreateAttachedEmitter(self,'FX_07',army, '/effects/emitters/seraphim_rift_arch_top_02_emit.bp'):ScaleEmitter(0.7)        -- top part plasma
        CreateAttachedEmitter(self,'FX_07',army, '/effects/emitters/seraphim_rift_arch_top_03_emit.bp'):ScaleEmitter(0.7)    -- top part darkening
        CreateAttachedEmitter(self,'FX_01',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)    -- line wall
        CreateAttachedEmitter(self,'FX_02',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)    -- line wall
        CreateAttachedEmitter(self,'FX_03',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)    -- line wall
        CreateAttachedEmitter(self,'FX_04',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)    -- line wall
        CreateAttachedEmitter(self,'FX_05',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)    -- line wall
        CreateAttachedEmitter(self,'FX_06',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)    -- line wall
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_01_emit.bp'):ScaleEmitter(0.7)    -- glow
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_02_emit.bp'):ScaleEmitter(0.7)    -- plasma pillar
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_03_emit.bp'):ScaleEmitter(0.7)    -- darkening pillar
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_04_emit.bp'):ScaleEmitter(0.7)    -- ring outward dust/motion
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_05_emit.bp'):ScaleEmitter(0.7)    -- plasma pillar move
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_06_emit.bp'):ScaleEmitter(0.7)    -- darkening pillar move
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_07_emit.bp'):ScaleEmitter(0.7)    -- bright line at bottom / right side
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_08_emit.bp'):ScaleEmitter(0.7)    -- bright line at bottom / left side
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_09_emit.bp'):ScaleEmitter(0.7)    -- small flickery dots rising
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_10_emit.bp'):ScaleEmitter(0.7)    -- distortion
        CreateAttachedEmitter(self,'FX_14',army, '/effects/emitters/seraphim_rift_arch_top_01_emit.bp'):ScaleEmitter(0.7)        -- top part glow
        CreateAttachedEmitter(self,'FX_14',army, '/effects/emitters/seraphim_rift_arch_top_02_emit.bp'):ScaleEmitter(0.7)        -- top part plasma
        CreateAttachedEmitter(self,'FX_14',army, '/effects/emitters/seraphim_rift_arch_top_03_emit.bp'):ScaleEmitter(0.7)        -- top part darkening
        CreateAttachedEmitter(self,'FX_08',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)    -- line wall
        CreateAttachedEmitter(self,'FX_09',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)    -- line wall
        CreateAttachedEmitter(self,'FX_10',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)    -- line wall
        CreateAttachedEmitter(self,'FX_11',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)    -- line wall
        CreateAttachedEmitter(self,'FX_12',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)    -- line wall
        CreateAttachedEmitter(self,'FX_13',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)    -- line wall

        -- Set up the two additional factory rolloff points
        self:SpawnFactory()
    end,

    OnStartBuild = function(self, built, order)
        SLandFactoryUnit.OnStartBuild(self, built, order)

        local bp = built:GetBlueprint()
        local massDrain = bp.Economy.BuildCostMass
        local energyDrain = bp.Economy.BuildCostEnergy

        -- Set resource drain to amounts derived from unit blueprints
        self:SetConsumptionPerSecondMass(massDrain / 100)
        self:SetConsumptionPerSecondEnergy(energyDrain * 3)
    end,

    OnStopBuild = function(self, built)
        SLandFactoryUnit.OnStopBuild(self, built)

        built:SetVeterancy(5)
    end,

    SpawnFactory = function(self)
        if not self.Dead then
            -- Get orientation of the factory gate
            local myOrientation = self:GetOrientation()

            -- Gets the current position of the carrier launch bays in the game world
            local leftDroneLocation = self:GetPosition('Factory05')
            local rightDroneLocation = self:GetPosition('Factory02')

            -- Creates our drone in the left launch bay and directs the unit to face the same direction as its parent unit
            self.leftDrone = CreateUnit('bsb0002', self:GetArmy(), leftDroneLocation[1], leftDroneLocation[2], leftDroneLocation[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Land')
            self.rightDrone = CreateUnit('bsb0002', self:GetArmy(), rightDroneLocation[1], rightDroneLocation[2], rightDroneLocation[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Land')

            self.leftDrone.Parent = self
            self.rightDrone.Parent = self

            -- Issues the guard command
            IssueClearCommands({self.leftDrone})
            IssueFactoryAssist({self.leftDrone}, self)
            IssueClearCommands({self.rightDrone})
            IssueFactoryAssist({self.rightDrone}, self)
        end
    end,

    OnFailedToBuild = function(self)
        IssueStop({self.leftDrone})
        IssueClearCommands({self.leftDrone})
        IssueFactoryAssist({self.leftDrone}, self)
        IssueStop({self.rightDrone})
        IssueClearCommands({self.rightDrone})
        IssueFactoryAssist({self.rightDrone}, self)

        SLandFactoryUnit.OnFailedToBuild(self)
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        -- Kill the expansion factory spawns
        if self.leftDrone and not self.leftDrone.Dead then
            IssueClearCommands({self.leftDrone})
            self.leftDrone:Kill()
        end
        if self.rightDrone and not self.rightDrone.Dead then
            IssueClearCommands({self.rightDrone})
            self.rightDrone:Kill()
        end

        SLandFactoryUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
}

TypeClass = BSB2402
