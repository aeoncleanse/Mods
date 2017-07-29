-----------------------------------------------------------------
-- File     :  /cdimage/units/UAB2301/UAB2301_script.lua
-- Author(s):  Greg Kohne
-- Summary  :  Aeon Heavy Gun Tower Script
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SDFHeavyQuarnonCannon = SeraphimWeapons.SDFHeavyQuarnonCannon

BSB2306 = Class(SStructureUnit) {
    Weapons = {
        Turret = Class(SDFHeavyQuarnonCannon) {},
    },
}

TypeClass = BSB2306
