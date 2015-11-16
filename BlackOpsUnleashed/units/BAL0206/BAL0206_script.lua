-----------------------------------------------------------------
-- File     :  /cdimage/units/XAL0206/XAL0206_script.lua
-- Author(s):  John Comes, David Tomandl, Jessica St. Croix
-- Summary  :  Aeon Mobile Anti-Air Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local AHoverLandUnit = import('/lua/aeonunits.lua').AHoverLandUnit
local ADFReactonCannon = import('/lua/aeonweapons.lua').ADFReactonCannon

BAL0206 = Class(AHoverLandUnit) {

    Weapons = {
        AAGun = Class(ADFReactonCannon) {},
    },
}

TypeClass = BAL0206
