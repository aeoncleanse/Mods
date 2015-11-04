------------------------------------------------------------------------------
--	File		:	/lua/lightning_weapons.lua
--	Author(s)	:	Resin Smoker
--	Summary 	:	Definition of Chainlightning weapons
--	Copyright © 2015 Public Release, All rights reserved.
------------------------------------------------------------------------------

-- Local Weapon Files --
local DefaultBeamWeapon = import('/lua/sim/defaultweapons.lua').DefaultBeamWeapon
local Custom_BeamFile = import('/mods/balancepreview/lua/defaultcollisionbeams.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')

LightningWeapon = Class(DefaultBeamWeapon) {
	BeamType = Custom_BeamFile.Chain_LightningBeam,
	FxMuzzleFlash = {},
	FxChargeMuzzleFlash = {},
	FxUpackingChargeEffects = EffectTemplate.CMicrowaveLaserCharge01,
	FxUpackingChargeEffectScale = 0.75,
}