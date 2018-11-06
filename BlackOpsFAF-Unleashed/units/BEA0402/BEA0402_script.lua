-----------------------------------------------------------------
-- File     :  /cdimage/units/BEA0402/BEA0402_script.lua
-- Author(s):  John Comes, David Tomandl, Gordon Duclos
-- Summary  :  UEF Mobile Factory Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local TAAFlakArtilleryCannon = WeaponsFile.TAAFlakArtilleryCannon
local RailGunWeapon02 = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsWeapons.lua').RailGunWeapon02
local CitadelHVMWeapon = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsWeapons.lua').CitadelHVMWeapon
local CitadelPlasmaGatlingCannonWeapon = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsWeapons.lua').CitadelPlasmaGatlingCannonWeapon
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')

BEA0402 = Class(TAirUnit) {
    Weapons = {
        MainTurret01 = Class(RailGunWeapon02) {},
        MainTurret02 = Class(RailGunWeapon02) {},
        HVMTurret01 = Class(CitadelHVMWeapon) {},
        HVMTurret02 = Class(CitadelHVMWeapon) {},
        HVMTurret03 = Class(CitadelHVMWeapon) {},
        HVMTurret04 = Class(CitadelHVMWeapon) {},
        AAAFlak01 = Class(TAAFlakArtilleryCannon) {},
        AAAFlak02 = Class(TAAFlakArtilleryCannon) {},
        AAAFlak03 = Class(TAAFlakArtilleryCannon) {},
        AAAFlak04 = Class(TAAFlakArtilleryCannon) {},
        GattlerTurret01 = Class(CitadelPlasmaGatlingCannonWeapon) {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gat_Muzzle_2', self.unit:GetArmy(), Effects.WeaponSteam01)
                CitadelPlasmaGatlingCannonWeapon.PlayFxWeaponPackSequence(self)
            end,

            PlayFxWeaponUnpackSequence = function(self)
                if not self.SpinManip then
                    self.SpinManip = CreateRotator(self.unit, 'Gat_Rotator_2', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end

                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                CitadelPlasmaGatlingCannonWeapon.PlayFxWeaponUnpackSequence(self)
            end,

            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(-200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gat_Muzzle_2', self.unit:GetArmy(), Effects.WeaponSteam01)
                CitadelPlasmaGatlingCannonWeapon.PlayFxRackSalvoReloadSequence(self)
            end,
        },

        GattlerTurret02 = Class(CitadelPlasmaGatlingCannonWeapon) {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gat_Muzzle_1', self.unit:GetArmy(), Effects.WeaponSteam01)
                CitadelPlasmaGatlingCannonWeapon.PlayFxWeaponPackSequence(self)
            end,

            PlayFxWeaponUnpackSequence = function(self)
                if not self.SpinManip then
                    self.SpinManip = CreateRotator(self.unit, 'Gat_Rotator_1', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end

                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                CitadelPlasmaGatlingCannonWeapon.PlayFxWeaponUnpackSequence(self)
            end,

            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(-200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gat_Muzzle_1', self.unit:GetArmy(), Effects.WeaponSteam01)
                CitadelPlasmaGatlingCannonWeapon.PlayFxRackSalvoReloadSequence(self)
            end,
        },
    },

    DestroyNoFallRandomChance = 1.1,
    FxDamageScale = 2.5,

    OnStopBeingBuilt = function(self, builder, layer)
        self.AirPadTable = {}
        TAirUnit.OnStopBeingBuilt(self, builder, layer)
    end,
}

TypeClass = BEA0402
