-----------------------------------------------------------------
-- File     :  /cdimage/units/UAB0301/UAB0301_script.lua
-- Author(s):  David Tomandl
-- Summary  :  Aeon Land Factory Tier 3 Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local SLandFactoryUnit = import('/lua/seraphimunits.lua').SLandFactoryUnit

BSB0301 = Class(SLandFactoryUnit) {
    OnStopBeingBuilt = function(self)
        if not self:IsDead() then

            -- Gets the current orientation of the Factory "A" in the game world
            local myOrientation = self:GetOrientation()

            -- Gets the current position of the Factory "A" in the game world
            local location = self:GetPosition()

            -- Gets the current health the Factory "A"
            local health = self:GetHealth()

            -- Creates our Factory "B" at the Factory "A" location & direction
            local FactoryB = CreateUnit('xsb0303', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Water')

            -- Passes the health of the Unit "A" to unit "B" and passes vet
            FactoryB:SetHealth(self,health)

            -- Nil's local FactoryA
            FactoryB = nil

            --Factory "A" removal scripts
            self:Destroy()
        end
    end,
}

TypeClass = BSB0301
