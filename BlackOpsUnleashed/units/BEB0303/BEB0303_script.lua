-----------------------------------------------------------------
-- File     :  /cdimage/units/UEB0303/UEB0303_script.lua
-- Author(s):  David Tomandl
-- Summary  :  UEF Tier 3 Naval Factory Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local TSeaFactoryUnit = import('/lua/terranunits.lua').TSeaFactoryUnit

BEB0303 = Class(TSeaFactoryUnit) {    
    OnStopBeingBuilt = function(self)
        if not self:IsDead() then

            -- Gets the current orientation of the Factory "A" in the game world
            local myOrientation = self:GetOrientation()

            -- Gets the current position of the Factory "A" in the game world
            local location = self:GetPosition()

            -- Gets the current health the Factory "A"
            local health = self:GetHealth()

            -- Creates our Factory "B" at the Factory "A" location & direction
            local FactoryB = CreateUnit('ueb0303', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Water')

            -- Passes the health of the Unit "A" to unit "B" and passes vet
            FactoryB:SetHealth(self,health)

            -- Nil's local FactoryA
            FactoryB = nil

            -- Factory "A" removal scripts
            self:Destroy()
        end
    end,
}

TypeClass = BEB0303
