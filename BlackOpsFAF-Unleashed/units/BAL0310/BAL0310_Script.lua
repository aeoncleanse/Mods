-----------------------------------------------------------------
-- File     :  /cdimage/units/XAL0310/XAL0310_script.lua
-- Author(s):  John Comes, David Tomandl
-- Summary  :  Aeon Heavy Mobile Artillery Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local AHoverLandUnit = import('/lua/aeonunits.lua').AHoverLandUnit
local ADFDisruptorWeapon = import('/lua/aeonweapons.lua').ADFDisruptorWeapon
local ADFCannonQuantumWeapon = import('/lua/aeonweapons.lua').ADFCannonQuantumWeapon

BAL0310 = Class(AHoverLandUnit) {
    Weapons = {
        MainGun = Class(ADFDisruptorWeapon) {},
        SideGuns = Class(ADFCannonQuantumWeapon) {},
    },

}

TypeClass = BAL0310
