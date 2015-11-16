--------------------------------------------------------------------------
-- File     :  /cdimage/units/XSL0404/XSL0404_script.lua
-- Author(s):  Drew Staltman, Jessica St. Croix, Gordon Duclos, Greg Kohne
-- Summary  :  Seraphim Unidentified Residual Energy Signature Script
-- Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
--------------------------------------------------------------------------

local SEnergyBallUnit = import('/lua/seraphimunits.lua').SEnergyBallUnit
local SDFUnstablePhasonBeam = import('/lua/seraphimweapons.lua').SDFUnstablePhasonBeamBO
local EffectTemplate = import('/lua/EffectTemplates.lua')

BSL0404 = Class(SEnergyBallUnit) {
    Weapons = {
        PhasonBeam = Class(SDFUnstablePhasonBeam) {},
    },
    
    OnCreate = function(self)
        SEnergyBallUnit.OnCreate(self)
        for k, v in EffectTemplate.OthuyAmbientEmanation do
            CreateAttachedEmitter(self, 'Outer_Tentaclebase', self:GetArmy(), v):ScaleEmitter(0.5)
        end
        self:HideBone(0,true)
    end,
}

TypeClass = BSL0404