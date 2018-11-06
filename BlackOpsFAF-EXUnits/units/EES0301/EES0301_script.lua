--****************************************************************************
--**
--**  File     :  /cdimage/units/UES0304/UES0304_script.lua
--**  Author(s):  John Comes, David Tomandl
--**
--**  Summary  :  UEF Strategic Missile Submarine Script
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local TSubUnit = import('/lua/terranunits.lua').TSubUnit
local WeaponFile = import('/lua/terranweapons.lua')
local TIFCruiseMissileLauncherSub = WeaponFile.TIFCruiseMissileLauncherSub
local TIFStrategicMissileWeapon = WeaponFile.TIFStrategicMissileWeapon
local TANTorpedoAngler = import('/lua/terranweapons.lua').TANTorpedoAngler
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher
local TDFHeavyPlasmaCannonWeapon = import('/mods/BlackOpsFAF-EXUnits/lua/EXBlackOpsweapons.lua').UEFACUHeavyPlasmaGatlingCannonWeapon
local TIFCruiseMissileLauncher = WeaponFile.TIFCruiseMissileLauncher
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')

EES0301 = Class(TSubUnit) {
    DeathThreadDestructionWaitTime = 0,
    Weapons = {
        CruiseMissiles = Class(TIFCruiseMissileLauncherSub) {},
        AdvancedTorpedos = Class(TANTorpedoAngler) {},
        SAMLauncher = Class(TSAMLauncher) {},
        GatlingCannon = Class(TDFHeavyPlasmaCannonWeapon) {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gat_Turret', self.unit:GetArmy(), Effects.WeaponSteam01)
                TDFHeavyPlasmaCannonWeapon.PlayFxWeaponPackSequence(self)
            end,
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then
                    self.SpinManip = CreateRotator(self.unit, 'Gat_Barrel', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end

                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                TDFHeavyPlasmaCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gat_Turret', self.unit:GetArmy(), Effects.WeaponSteam01)
                TDFHeavyPlasmaCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
        TacticalNuke = Class(TIFCruiseMissileLauncher) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        TSubUnit.OnStopBeingBuilt(self,builder,layer)
        if layer == 'Water' then
            self:SetWeaponEnabledByLabel('GatlingCannon', true)
            self:SetWeaponEnabledByLabel('SAMLauncher', true)
            self:AddCommandCap('RULEUCC_Tactical')
        else
            self:SetWeaponEnabledByLabel('GatlingCannon', false)
            self:SetWeaponEnabledByLabel('SAMLauncher', false)
            self:RemoveCommandCap('RULEUCC_Tactical')
        end
    end,

    OnLayerChange = function(self, new, old)
        TSubUnit.OnLayerChange(self, new, old)
        if new == 'Water' then
            self:SetWeaponEnabledByLabel('GatlingCannon', true)
            self:SetWeaponEnabledByLabel('SAMLauncher', true)
            self:AddCommandCap('RULEUCC_Tactical')
        elseif new == 'Sub' then
            self:SetWeaponEnabledByLabel('GatlingCannon', false)
            self:SetWeaponEnabledByLabel('SAMLauncher', false)
            self:RemoveCommandCap('RULEUCC_Tactical')
        end
    end,
}

TypeClass = EES0301

