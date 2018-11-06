--****************************************************************************
--**
--**  File     :  /cdimage/units/UES0103/UES0103_script.lua
--**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
--**
--**  Summary  :  UEF Frigate Script
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local TSeaUnit = import('/lua/terranunits.lua').TSeaUnit
local Entity = import('/lua/sim/Entity.lua').Entity
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher
local TIFSmartCharge = import('/lua/terranweapons.lua').TIFSmartCharge
local TIFCruiseMissileLauncherSub = import('/lua/terranweapons.lua').TIFCruiseMissileLauncherSub
local TAMPhalanxWeapon = import('/lua/terranweapons.lua').TAMPhalanxWeapon
local TAAFlakArtilleryCannon = import('/lua/terranweapons.lua').TAAFlakArtilleryCannon

EES0302 = Class(TSeaUnit) {

    Weapons = {
        CruiseMissiles = Class(TIFCruiseMissileLauncherSub) {},
        HVMTurret = Class(TSAMLauncher) {},
        AntiTorpedo = Class(TIFSmartCharge) {},
        TMDFore = Class(TAMPhalanxWeapon) {},
        TMDAft = Class(TAMPhalanxWeapon) {},
        AAFlakFore = Class(TAAFlakArtilleryCannon) {},
        AAFlakAft = Class(TAAFlakArtilleryCannon) {},
    },

    OnCreate = function(self)
        TSeaUnit.OnCreate(self)
        self:SetWeaponEnabledByLabel('AAFlakFore', false)
        self:SetWeaponEnabledByLabel('AAFlakAft', false)
    end,

    OnScriptBitSet = function(self, bit)
        TSeaUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self:SetWeaponEnabledByLabel('AAFlakFore', true)
            self:SetWeaponEnabledByLabel('TMDFore', false)
            self:GetWeaponManipulatorByLabel('AAFlakFore'):SetHeadingPitch(self:GetWeaponManipulatorByLabel('TMDFore'):GetHeadingPitch())
            self:SetWeaponEnabledByLabel('AAFlakAft', true)
            self:SetWeaponEnabledByLabel('TMDAft', false)
            self:GetWeaponManipulatorByLabel('AAFlakAft'):SetHeadingPitch(self:GetWeaponManipulatorByLabel('TMDAft'):GetHeadingPitch())
        end
    end,

    OnScriptBitClear = function(self, bit)
        TSeaUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            self:SetWeaponEnabledByLabel('AAFlakFore', false)
            self:SetWeaponEnabledByLabel('TMDFore', true)
            self:GetWeaponManipulatorByLabel('TMDFore'):SetHeadingPitch(self:GetWeaponManipulatorByLabel('AAFlakFore'):GetHeadingPitch())
            self:SetWeaponEnabledByLabel('AAFlakAft', false)
            self:SetWeaponEnabledByLabel('TMDAft', true)
            self:GetWeaponManipulatorByLabel('TMDAft'):SetHeadingPitch(self:GetWeaponManipulatorByLabel('AAFlakAft'):GetHeadingPitch())
        end
    end,
}

TypeClass = EES0302