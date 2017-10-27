-- Goliath Drone

local AirDroneUnit = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsunits.lua').AirDroneUnit
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher

BEA0005 = Class(AirDroneUnit) {

    Weapons = {
       Cannon01 = Class(TSAMLauncher) {},
       Cannon02 = Class(TSAMLauncher) {},
    },

    OnStopBeingBuilt = function(self, builder, layer)
        AirDroneUnit.OnStopBeingBuilt(self, builder, layer)
        self.EngineManipulators = {}
        -- Create the engine thrust manipulators
        self.EngineRotateBones = {'Engines1'}
        for key, value in self.EngineRotateBones do
            table.insert(self.EngineManipulators, CreateThrustController(self, "thruster", value))
        end
        -- Set up the thursting arcs for the engines
        for key,value in self.EngineManipulators do
            value:SetThrustingParam(-0.0, 0.0, -0.25, 0.25, -0.1, 0.1, 1.0, 0.25)
        end
        for k, v in self.EngineManipulators do
            self.Trash:Add(v)
        end
    end,

}

TypeClass = BEA0005
