-----------------------------------------------------------------------------
--	File		:	/mods/Titan_Missiles/hook/units/UEL0303/UEL0303_script.lua
--	Author(s)	:	Resin Smoker
--	Summary 	:	UEF Siege Assault Bot Script (With Napalm Launcher Enhancement)
--	Copyright © 2015 Public frelease, All rights reserved.
-----------------------------------------------------------------------------

local TerranWeaponFile = import('/lua/terranweapons.lua')
local TWalkingLandUnit = import('/lua/terranunits.lua').TWalkingLandUnit
local TDFHeavyPlasmaCannonWeapon = TerranWeaponFile.TDFHeavyPlasmaCannonWeapon
local TIFFragLauncherWeapon = TerranWeaponFile.TDFFragmentationGrenadeLauncherWeapon

UEL0303 = Class(TWalkingLandUnit) {

	Weapons = {
		HeavyPlasma01 = Class(TDFHeavyPlasmaCannonWeapon) {
			DisabledFiringBones = {
				'Torso', 'ArmR_B02', 'Barrel_R', 'ArmR_B03', 'ArmR_B04',
				'ArmL_B02', 'Barrel_L', 'ArmL_B03', 'ArmL_B04',
			},
		},
		Missile_Pod = Class(TIFFragLauncherWeapon) {},
	},
}
TypeClass = UEL0303