-----------------------------------------------------------------
-- File     :  /cdimage/units/URB4207/URB4207_script.lua
-- Author(s):  David Tomandl, Greg Kohne
-- Summary  :  Cybran Shield Generator lvl 5 Script
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local CShieldStructureUnit = import('/lua/cybranunits.lua').CShieldStructureUnit
local Shield = import('/lua/shield.lua').Shield

BRB4207 = Class(CShieldStructureUnit) {

    ShieldEffects = {
                    '/effects/emitters/cybran_shield_05_generator_01_emit.bp',
                    '/effects/emitters/cybran_shield_05_generator_02_emit.bp',
                    '/effects/emitters/cybran_shield_05_generator_03_emit.bp',
                    '/effects/emitters/cybran_shield_05_generator_04_emit.bp',
    },

    OnStopBeingBuilt = function(self)
        if not self.Dead then

            -- Gets the current orientation of the Factory "A" in the game world
            local myOrientation = self:GetOrientation()

            -- Gets the current position of the Factory "A" in the game world
            local location = self:GetPosition()

            -- Gets the current health the Factory "A"
            local health = self:GetHealth()

            -- Creates our Factory "B" at the Factory "A" location & direction
            local FactoryB = CreateUnit('urb4207', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Land')

            -- Passes the health of the Unit "A" to unit "B" and passes vet
            FactoryB:SetHealth(self,health)

            -- Nil's local FactoryA
            FactoryB = nil

            --Factory "A" removal scripts
            self:Destroy()
        end
    end,
}

TypeClass = BRB4207
