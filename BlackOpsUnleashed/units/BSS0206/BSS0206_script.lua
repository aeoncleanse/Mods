-----------------------------------------------------------------
-- File     :  /units/BSS0206/BSS0206_script.lua
-- Author(s):  Drew Staltman, Gordon Duclos, Aaron Lundquist
-- Summary  :  Seraphim Cruiser Script
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SSeaUnit = import('/lua/seraphimunits.lua').SSeaUnit
local SIFSuthanusArtilleryCannon = import('/lua/seraphimweapons.lua').SIFSuthanusMobileArtilleryCannon
local SAAOlarisCannonWeapon = SeraphimWeapons.SAAOlarisCannonWeapon

BSS0206 = Class(SSeaUnit) {
    Weapons = {
        FrontGun01 = Class(SIFSuthanusArtilleryCannon) {},
        FrontGun02 = Class(SIFSuthanusArtilleryCannon) {},
        AAGun = Class(SAAOlarisCannonWeapon) {},
    },
    BackWakeEffect = {},
}

TypeClass = BSS0206
