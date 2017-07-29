-----------------------------------------------------------------
-- File     :  /cdimage/units/XEL0211/XEL0211_script.lua
-- Author(s):  John Comes, David Tomandl, Gordon Duclos
-- Summary  :  UEF Mobile Factory Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local TDFMachineGunWeapon = WeaponsFile.TDFMachineGunWeapon

BEL0211 = Class(TLandUnit) {
    Weapons = {
        LeftHeavyFlamer = Class(TDFMachineGunWeapon) {},
        RightHeavyFlamer = Class(TDFMachineGunWeapon) {},
    },
}

TypeClass = BEL0211
