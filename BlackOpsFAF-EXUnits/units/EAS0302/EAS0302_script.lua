--****************************************************************************
--**
--**  File     :  /cdimage/units/UAS0103/UAS0103_script.lua
--**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
--**
--**  Summary  :  Aeon Frigate Script: UAS0103
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local ASeaUnit = import('/lua/aeonunits.lua').ASeaUnit
local AeonWeapons = import('/lua/aeonweapons.lua')
local ADFCannonQuantumWeapon = AeonWeapons.ADFCannonQuantumWeapon
local AIFQuasarAntiTorpedoWeapon = AeonWeapons.AIFQuasarAntiTorpedoWeapon
local AANChronoTorpedoWeapon = AeonWeapons.AANChronoTorpedoWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local AAMWillOWisp = AeonWeapons.AAMWillOWisp
local AAASonicPulseBatteryWeapon = import('/lua/aeonweapons.lua').AAASonicPulseBatteryWeapon

EAS0302 = Class(ASeaUnit) {

    Weapons = {
        TopTurret = Class(ADFCannonQuantumWeapon) {},
        FrontTurret = Class(ADFCannonQuantumWeapon) {},
        AntiMissile = Class(AAMWillOWisp) {},
        AAGun01 = Class(AAASonicPulseBatteryWeapon) {
            FxMuzzleScale = 2.25,
        },
        AAGun02 = Class(AAASonicPulseBatteryWeapon) {
            FxMuzzleScale = 2.25,
        },
        MainTorpedo = Class(AANChronoTorpedoWeapon) {},
        MassTorpedo01 = Class(AANChronoTorpedoWeapon) {},
        MassTorpedo02 = Class(AANChronoTorpedoWeapon) {},
        AntiTorpedo01 = Class(AIFQuasarAntiTorpedoWeapon) {},
        AntiTorpedo02 = Class(AIFQuasarAntiTorpedoWeapon) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        ASeaUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetWeaponEnabledByLabel('MassTorpedo01', false)
        self:SetWeaponEnabledByLabel('MassTorpedo02', false)
    end,

    OnScriptBitSet = function(self, bit)
        ASeaUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self:SetWeaponEnabledByLabel('MassTorpedo01', true)
            self:SetWeaponEnabledByLabel('AntiTorpedo01', false)
            --self:GetWeaponManipulatorByLabel('AAFlakFore'):SetHeadingPitch(self:GetWeaponManipulatorByLabel('TMDFore'):GetHeadingPitch())
            self:SetWeaponEnabledByLabel('MassTorpedo02', true)
            self:SetWeaponEnabledByLabel('AntiTorpedo02', false)
            --self:GetWeaponManipulatorByLabel('AAFlakFore'):SetHeadingPitch(self:GetWeaponManipulatorByLabel('TMDFore'):GetHeadingPitch())
         end
    end,

    OnScriptBitClear = function(self, bit)
        ASeaUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            self:SetWeaponEnabledByLabel('MassTorpedo01', false)
            self:SetWeaponEnabledByLabel('AntiTorpedo01', true)
            --self:GetWeaponManipulatorByLabel('TMDFore'):SetHeadingPitch(self:GetWeaponManipulatorByLabel('AAFlakFore'):GetHeadingPitch())
            self:SetWeaponEnabledByLabel('MassTorpedo02', false)
            self:SetWeaponEnabledByLabel('AntiTorpedo02', true)
            --self:GetWeaponManipulatorByLabel('TMDFore'):SetHeadingPitch(self:GetWeaponManipulatorByLabel('AAFlakFore'):GetHeadingPitch())
        end
    end,

}

TypeClass = EAS0302
