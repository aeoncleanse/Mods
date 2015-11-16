#****************************************************************************
#**
#**  Author(s):  Mikko Tyster
#**
#**  Summary  :  Aeon T3 Anti-Air
#**
#**  Copyright © 2008 Blade Braver!
#****************************************************************************

local AWalkingLandUnit = import('/lua/aeonunits.lua').AWalkingLandUnit
local AAAZealotMissileWeapon = import('/lua/aeonweapons.lua').AAAZealotMissileWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')

BALK003 = Class(AWalkingLandUnit) {    
    Weapons = {
		Missile = Class(AAAZealotMissileWeapon) {},
    },
    
}

TypeClass = BALK003