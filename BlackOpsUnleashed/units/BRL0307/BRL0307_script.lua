-----------------------------------------------------------------
-- File     :  /cdimage/units/XRL0307/XRL0307_script.lua
-- Author(s):  John Comes, David Tomandl, Jessica St. Croix
-- Summary  :  Cybran Mobile Missile Launcher Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit
local CIFMissileLoaTacticalWeapon = import('/lua/cybranweapons.lua').CIFMissileLoaTacticalWeapon

BRL0307 = Class(CWalkingLandUnit) {
    Weapons = {
        MissileRack = Class(CIFMissileLoaTacticalWeapon) {},
    },
}

TypeClass = BRL0307
