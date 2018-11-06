------------------------------------------------------------------------
-- File     :  /cdimage/units/XEL0308/XEL0308_script.lua
-- Author(s):  John Comes, David Tomandl, Jessica St. Croix, Matt Vainio
-- Summary  :  UEF Mongoose Gatling Bot
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
------------------------------------------------------------------------

local TWalkingLandUnit = import('/lua/terranunits.lua').TWalkingLandUnit
local TIFArtilleryWeapon = import('/lua/terranweapons.lua').TIFArtilleryWeapon
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon

BEL0308 = Class(TWalkingLandUnit)
{
    Weapons = {
        MainGun = Class(TIFArtilleryWeapon) {},
        GaussCannons = Class(TDFGaussCannonWeapon) {},
    },
}

TypeClass = BEL0308
