-----------------------------------------------------------------
-- File     :  /cdimage/units/XAB2308/XAB2308_script.lua
-- Author(s):  John Comes, David Tomandl
-- Summary  :  Aeon Tactical Missile Launcher Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit
local ACruiseMissileWeapon = import('/lua/aeonweapons.lua').ACruiseMissileWeapon

BAB2308 = Class(AStructureUnit) {
    Weapons = {
        CruiseMissile = Class(ACruiseMissileWeapon) {},
    },
}

TypeClass = BAB2308
