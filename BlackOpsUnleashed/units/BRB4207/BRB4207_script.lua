--****************************************************************************
-- File     :  /cdimage/units/URB4207/URB4207_script.lua
-- Author(s):  David Tomandl, Greg Kohne
-- Summary  :  Cybran Shield Generator lvl 5 Script
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.**************************************************************************

local CShieldStructureUnit = import('/lua/cybranunits.lua').CShieldStructureUnit
local Shield = import('/lua/shield.lua').Shield

BRB4207 = Class(CShieldStructureUnit) {
    
    ShieldEffects = {
                    '/effects/emitters/cybran_shield_05_generator_01_emit.bp',
                    '/effects/emitters/cybran_shield_05_generator_02_emit.bp',
                    '/effects/emitters/cybran_shield_05_generator_03_emit.bp',
                    '/effects/emitters/cybran_shield_05_generator_04_emit.bp',
                    },
    
    OnStopBeingBuilt = function(self,builder,layer)
        CShieldStructureUnit.OnStopBeingBuilt(self,builder,layer)
        if not self:IsDead() then

           ------ Gets the current orientation of the shieldGen "B" in the game world
           local myOrientation = self:GetOrientation()

           ------ Gets the current position of the shieldGen "B" in the game world
           local location = self:GetPosition()

           ------ Gets the current health the shieldGen "B"
           local health = self:GetHealth()

           ------ Creates our shieldGen "C" at the shieldGen "B" location & direction
           local shieldGenC = CreateUnit('urb4207', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Land')

           ------ Passes the health of the Unit "B" to unit "C"
           shieldGenC:SetHealth(self,health)

           ------ Nil's local shieldGenB
           shieldGenC = nil

           ------shieldGen "B" removal scripts
           self:Destroy()
       end
    end,
    
}

TypeClass = BRB4207