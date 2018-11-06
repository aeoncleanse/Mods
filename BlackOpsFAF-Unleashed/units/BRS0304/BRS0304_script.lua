-----------------------------------------------------------------
-- File     :  /cdimage/units/BRS0304/BRS0304_script.lua
-- Author(s):  David Tomandl, Jessica St. Croix
-- Summary  :  Cybran Cruiser Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local CSeaUnit = import('/lua/cybranunits.lua').CSeaUnit
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local WeaponsFile = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsWeapons.lua')
local CDFProtonCannonWeapon = CybranWeaponsFile.CDFProtonCannonWeapon
local CAANanoDartWeapon = CybranWeaponsFile.CAANanoDartWeapon
local CAMZapperWeapon02 = CybranWeaponsFile.CAMZapperWeapon02
local CANNaniteTorpedoWeapon = CybranWeaponsFile.CANNaniteTorpedoWeapon
local CIFSmartCharge = CybranWeaponsFile.CIFSmartCharge
local MartyrHeavyMicrowaveLaserGenerator = WeaponsFile.MartyrHeavyMicrowaveLaserGenerator
local MissileRedirect = import('/lua/defaultantiprojectile.lua').MissileRedirect

BRS0304 = Class(CSeaUnit) {
    Weapons = {
        ParticleGun = Class(CDFProtonCannonWeapon) {},
        ParticleGun2 = Class(CDFProtonCannonWeapon) {},
        RightGun = Class(MartyrHeavyMicrowaveLaserGenerator) {},
        LeftGun = Class(MartyrHeavyMicrowaveLaserGenerator) {},
        AAGun = Class(CAANanoDartWeapon) {},
        GroundGun = Class(CAANanoDartWeapon) {},
        Zapper = Class(CAMZapperWeapon02) {},
        Torpedo = Class(CANNaniteTorpedoWeapon) {},
        AntiTorpedo = Class(CIFSmartCharge) {},
    },

    OnCreate = function(self)
        CSeaUnit.OnCreate(self)
        self:SetWeaponEnabledByLabel('GroundGun', false)
    end,

    OnScriptBitSet = function(self, bit)
        CSeaUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self:SetWeaponEnabledByLabel('GroundGun', true)
            self:SetWeaponEnabledByLabel('AAGun', false)
            self:GetWeaponManipulatorByLabel('GroundGun'):SetHeadingPitch(self:GetWeaponManipulatorByLabel('AAGun'):GetHeadingPitch())
        end
    end,

    OnScriptBitClear = function(self, bit)
        CSeaUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            self:SetWeaponEnabledByLabel('GroundGun', false)
            self:SetWeaponEnabledByLabel('AAGun', true)
            self:GetWeaponManipulatorByLabel('AAGun'):SetHeadingPitch(self:GetWeaponManipulatorByLabel('GroundGun'):GetHeadingPitch())
        end
    end,

    OnKilled = function(self, instigator, damagetype, overkillRatio)
        self.Trash:Destroy()
        self.Trash = TrashBag()
        CSeaUnit.OnKilled(self, instigator, damagetype, overkillRatio)
    end,
}

TypeClass = BRS0304
