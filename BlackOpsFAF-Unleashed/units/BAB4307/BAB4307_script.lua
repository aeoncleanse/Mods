-----------------------------------------------------------------
-- File     :  /cdimage/units/UAB2304/UAB2304_script.lua
-- Author(s):  John Comes, David Tomandl
-- Summary  :  Aeon Advanced Anti-Air System Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit
local AAATemporalFizzWeapon = import('/lua/aeonweapons.lua').AAATemporalFizzWeapon

BAB2304 = Class(AStructureUnit) {
    Weapons = {
        AntiMissile = Class(AAATemporalFizzWeapon) {},
    },
}

TypeClass = BAB2304
