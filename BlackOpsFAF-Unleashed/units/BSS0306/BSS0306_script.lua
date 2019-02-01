--****************************************************************************
--**
-- File     :  /cdimage/units/BSS0306/BSS0306_script.lua
--**
-- Summary  :  Seraphim Frigate Script: BSS0306
--**
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local SSeaUnit = import('/lua/seraphimunits.lua').SSeaUnit
local SWeapon = import('/lua/seraphimweapons.lua')
local SDFUnstablePhasonBeam = import('/lua/seraphimweapons.lua').SDFUnstablePhasonBeam
local EffectTemplate = import('/lua/kirveseffects.lua')
local SIFSuthanusArtilleryCannon = import('/lua/seraphimweapons.lua').SIFSuthanusMobileArtilleryCannon

BSS0306 = Class(SSeaUnit) {
    Weapons = {
        MainGun01 = Class(SWeapon.SDFShriekerCannon){},
        MainGun02 = Class(SWeapon.SDFShriekerCannon){},
        MainGun03 = Class(SWeapon.SDFShriekerCannon){},
        LazorTurret01 = Class(SWeapon.SDFUltraChromaticBeamGenerator) {},
        LazorTurret02 = Class(SWeapon.SDFUltraChromaticBeamGenerator) {},
        BombardTurret = Class(SIFSuthanusArtilleryCannon) {},
        FrontAAGun = Class(SWeapon.SAALosaareAutoCannonWeapon) {},
        BackAAGun = Class(SWeapon.SAALosaareAutoCannonWeapon) {},
        PhasonBeam1 = Class(SDFUnstablePhasonBeam) {
        FxMuzzleFlash = {'/Effects/Emitters/seraphim_experimental_phasonproj_muzzle_flash_01_emit.bp','/Effects/Emitters/seraphim_experimental_phasonproj_muzzle_flash_02_emit.bp','/Effects/Emitters/seraphim_experimental_phasonproj_muzzle_flash_03_emit.bp','/Effects/Emitters/seraphim_experimental_phasonproj_muzzle_flash_04_emit.bp','/Effects/Emitters/seraphim_experimental_phasonproj_muzzle_flash_05_emit.bp','/Effects/Emitters/seraphim_experimental_phasonproj_muzzle_flash_06_emit.bp','/mods/BlackOpsFAF-Unleashed/Effects/Emitters/seraphim_electricity_emit.bp'},
        },

        PhasonBeam2 = Class(SDFUnstablePhasonBeam) {
        FxMuzzleFlash = {'/Effects/Emitters/seraphim_experimental_phasonproj_muzzle_flash_01_emit.bp','/Effects/Emitters/seraphim_experimental_phasonproj_muzzle_flash_02_emit.bp','/Effects/Emitters/seraphim_experimental_phasonproj_muzzle_flash_03_emit.bp','/Effects/Emitters/seraphim_experimental_phasonproj_muzzle_flash_04_emit.bp','/Effects/Emitters/seraphim_experimental_phasonproj_muzzle_flash_05_emit.bp','/Effects/Emitters/seraphim_experimental_phasonproj_muzzle_flash_06_emit.bp','/mods/BlackOpsFAF-Unleashed/Effects/Emitters/seraphim_electricity_emit.bp'},
        },
    },


    OnStopBeingBuilt = function(self,builder,layer)
        SSeaUnit.OnStopBeingBuilt(self,builder,layer)
        IssueDive({self})
        self.Trash:Add(CreateRotator(self, 'Orb_Spinner', 'y', nil, 90, 0, 0))
        CreateAttachedEmitter(self, 'Orb', self:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/orbeffect_01.bp'):ScaleEmitter(2)
    end,

    OnKilled = function(self, instigator, damagetype, overkillRatio)
        self.Trash:Destroy()
        self.Trash = TrashBag()
        SSeaUnit.OnKilled(self, instigator, damagetype, overkillRatio)
    end,
}
TypeClass = BSS0306
