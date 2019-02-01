-----------------------------------------------------------------
-- File     :  /cdimage/units/XRL0110/XRL0110_script.lua
-- Author(s):  John Comes, David Tomandl
-- Summary  :  Cybran Mobile Mortar Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CIFGrenadeWeapon = CybranWeaponsFile.CIFGrenadeWeapon
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local CDFLaserHeavyWeapon = CybranWeaponsFile.CDFLaserHeavyWeapon
local CAANanoDartWeapon = CybranWeaponsFile.CAANanoDartWeapon
local EffectUtils = import('/lua/effectutilities.lua')
local CDFParticleCannonWeapon = import('/lua/cybranweapons.lua').CDFParticleCannonWeapon
local Effects = import('/lua/effecttemplates.lua')

BRL0110 = Class(CWalkingLandUnit) {
    DestructionTicks = 400,
    WeaponList = {'FlameGun', 'RPG', 'GatlingCannon', 'LaserGun'},

    Weapons = {
        DummyWeapon = Class(CIFGrenadeWeapon) {},
        FlameGun = Class(CIFGrenadeWeapon) {},
        RPG = Class(CAANanoDartWeapon) {},
        LaserGun = Class(CDFParticleCannonWeapon) {},
        GatlingCannon = Class(CDFLaserHeavyWeapon) {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gat_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01)
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gat_Exhaust', self.unit:GetArmy(), Effects.WeaponSteam01)
                CDFLaserHeavyWeapon.PlayFxWeaponPackSequence(self)
            end,

            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then
                    self.SpinManip = CreateRotator(self.unit, 'Gat_Spinner', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end

                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(-700)
                end
                CDFLaserHeavyWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
    },

    OnStopBeingBuilt = function(self,builder,layer)
        self:ForkThread(self.WeaponSetup)
        self:SetWeaponEnabledByLabel('FlameGun', false)
        self:SetWeaponEnabledByLabel('RPG', false)
        self:SetWeaponEnabledByLabel('GatlingCannon', false)
        self:SetWeaponEnabledByLabel('LaserGun', false)
        self:HideBone('Suicide', true)

        CWalkingLandUnit.OnStopBeingBuilt(self, builder, layer)
    end,

    WeaponCheckThread = function(self)
        for k, v in self.WeaponList do
            self:SetWeaponEnabledByLabel(self.WeaponList[k], k == self.WeaponCheck)
        end
    end,

    OnTransportDetach = function(self, attachBone, unit)
        CWalkingLandUnit.OnTransportDetach(self, attachBone, unit)
        self:ForkThread(self.WeaponCheckThread)
    end,

    WeaponSetup = function(self)
        if not self.Dead then
            self.WeaponCheck = Random(1, 4)
            self:ShowBone('XRL0110', true)
            local dummywep = self:GetWeaponByLabel('DummyWeapon')
            local maxradius, minradius

            local check = self.WeaponCheck
            if check == 1 then
                self:HideBone('RPG_Barrel01', true)
                self:HideBone('RPG_Barrel02', true)
                self:HideBone('RPG_Muzzle01', true)
                self:HideBone('RPG_Muzzle02', true)
                self:HideBone('Gat_Barrel01', true)
                self:HideBone('Gat_Spinner', true)
                self:HideBone('Gat_Muzzle', true)
                self:HideBone('Gat_Exhaust', true)
                self:HideBone('Eye_Laser_Muzzle', true)
                local wep = self:GetWeaponByLabel('FlameGun')
                maxradius = wep:GetBlueprint().MaxRadius
                minradius = wep:GetBlueprint().MinRadius or 0
            elseif check == 2 then
                self:HideBone('Flamer', true)
                self:HideBone('Flamer_Muzzle', true)
                self:HideBone('Gat_Barrel01', true)
                self:HideBone('Gat_Spinner', true)
                self:HideBone('Gat_Muzzle', true)
                self:HideBone('Gat_Exhaust', true)
                self:HideBone('Eye_Laser_Muzzle', true)
                local wep = self:GetWeaponByLabel('RPG')
                maxradius = wep:GetBlueprint().MaxRadius
                minradius = wep:GetBlueprint().MinRadius or 0
            elseif check == 3 then
                self:HideBone('Flamer', true)
                self:HideBone('Flamer_Muzzle', true)
                self:HideBone('RPG_Barrel01', true)
                self:HideBone('RPG_Barrel02', true)
                self:HideBone('RPG_Muzzle01', true)
                self:HideBone('RPG_Muzzle02', true)
                self:HideBone('Eye_Laser_Muzzle', true)
                local wep = self:GetWeaponByLabel('GatlingCannon')
                maxradius = wep:GetBlueprint().MaxRadius
                minradius = wep:GetBlueprint().MinRadius or 0
            elseif check == 4 then
                self:HideBone('RPG_Barrel01', true)
                self:HideBone('RPG_Barrel02', true)
                self:HideBone('RPG_Muzzle01', true)
                self:HideBone('RPG_Muzzle02', true)
                self:HideBone('Gat_Barrel01', true)
                self:HideBone('Gat_Spinner', true)
                self:HideBone('Gat_Muzzle', true)
                self:HideBone('Gat_Exhaust', true)
                self:HideBone('Flamer', true)
                self:HideBone('Flamer_Muzzle', true)
                local wep = self:GetWeaponByLabel('LaserGun')
                maxradius = wep:GetBlueprint().MaxRadius
                minradius = wep:GetBlueprint().MinRadius or 0
            end
            -- Configure dummy weapon radius, enable main weapon
            dummywep:ChangeMaxRadius(maxradius)
            dummywep:ChangeMinRadius(minradius)
            self:WeaponCheckThread()
        end
    end,
}

TypeClass = BRL0110
