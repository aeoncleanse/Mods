-----------------------------------------------------------------
-- File     :  /cdimage/units/UEL0202/UEL0202_script.lua
-- Author(s):  John Comes, David Tomandl, Jessica St. Croix
-- Summary  :  UEF Heavy Tank Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local RailGunWeapon01 = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsWeapons.lua').RailGunWeapon01
local TIFCruiseMissileUnpackingLauncher = import('/lua/terranweapons.lua').TIFCruiseMissileUnpackingLauncher
local JuggLaserweapon = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsWeapons.lua').JuggLaserweapon
local JuggPlasmaGatlingCannonWeapon = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsWeapons.lua').JuggPlasmaGatlingCannonWeapon
local utilities = import('/lua/Utilities.lua')
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')

BEL0307 = Class(TLandUnit) {
    Weapons = {
        MainTurret = Class(RailGunWeapon01) {},
        RightMissileRack = Class(TIFCruiseMissileUnpackingLauncher) {},
        LeftMissileRack = Class(TIFCruiseMissileUnpackingLauncher) {},
        LeftLaser = Class(JuggLaserweapon) {},
        RightLaser = Class(JuggLaserweapon) {},
        GattlerTurret = Class(JuggPlasmaGatlingCannonWeapon) {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gat_Muzzle_01', self.unit:GetArmy(), Effects.WeaponSteam01)
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gat_Muzzle_02', self.unit:GetArmy(), Effects.WeaponSteam01)
                JuggPlasmaGatlingCannonWeapon.PlayFxWeaponPackSequence(self)
            end,

            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then
                    self.SpinManip = CreateRotator(self.unit, 'Left_Gat_Rotator', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end

                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                if not self.SpinManip2 then
                    self.SpinManip2 = CreateRotator(self.unit, 'Right_Gat_Rotator', 'z', nil, -270, 180, -60)
                    self.unit.Trash:Add(self.SpinManip2)
                end

                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(-500)
                end
                JuggPlasmaGatlingCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,

            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(-200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gat_Muzzle_01', self.unit:GetArmy(), Effects.WeaponSteam01)
                self.ExhaustEffects = EffectUtils.CreateBoneEffects(self.unit, 'Gat_Muzzle_02', self.unit:GetArmy(), Effects.WeaponSteam01)
                JuggPlasmaGatlingCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        }
    },

    OnStopBeingBuilt = function(self,builder,layer)
        TLandUnit.OnStopBeingBuilt(self,builder,layer)

        local layer = self:GetCurrentLayer()
        -- If created with F2 on land, then play the transform anim.
        if(layer == 'Land') then
            self:CreateUnitAmbientEffect(layer)
        elseif (layer == 'Seabed') then
            self:CreateUnitAmbientEffect(layer)
        end
        self.WeaponsEnabled = true
    end,

    OnLayerChange = function(self, new, old)
        TLandUnit.OnLayerChange(self, new, old)
        if self.WeaponsEnabled then
            if(new == 'Land') then
                self:CreateUnitAmbientEffect(new)
            elseif (new == 'Seabed') then
                self:CreateUnitAmbientEffect(new)
            end
        end
    end,

    AmbientExhaustBones = {
        'Exhaust_1',
        'Exhaust_2',
        'Exhaust_3',
        'Exhaust_4',
    },

    AmbientLandExhaustEffects = {
        '/effects/emitters/dirty_exhaust_smoke_02_emit.bp',
        '/effects/emitters/dirty_exhaust_sparks_02_emit.bp',
    },

    AmbientSeabedExhaustEffects = {
        '/effects/emitters/underwater_vent_bubbles_02_emit.bp',
    },

    CreateUnitAmbientEffect = function(self, layer)
        if(self.AmbientEffectThread ~= nil) then
           self.AmbientEffectThread:Destroy()
        end
        if self.AmbientExhaustEffectsBag then
            EffectUtils.CleanupEffectBag(self,'AmbientExhaustEffectsBag')
        end

        self.AmbientEffectThread = nil
        self.AmbientExhaustEffectsBag = {}
        if layer == 'Land' then
            self.AmbientEffectThread = self:ForkThread(self.UnitLandAmbientEffectThread)
        elseif layer == 'Seabed' then
            local army = self:GetArmy()
            for kE, vE in self.AmbientSeabedExhaustEffects do
                for kB, vB in self.AmbientExhaustBones do
                    table.insert(self.AmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE):ScaleEmitter(1))
                end
            end
        end
    end,

    UnitLandAmbientEffectThread = function(self)
        while not self.Dead do
            local army = self:GetArmy()

            for kE, vE in self.AmbientLandExhaustEffects do
                for kB, vB in self.AmbientExhaustBones do
                    table.insert(self.AmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE):ScaleEmitter(0.5))
                end
            end

            WaitSeconds(2)
            EffectUtils.CleanupEffectBag(self,'AmbientExhaustEffectsBag')

            WaitSeconds(utilities.GetRandomFloat(1,7))
        end
    end,

    CreateDamageEffects = function(self, bone, army)
        for k, v in Effects.DamageFireSmoke01 do
            CreateAttachedEmitter(self, bone, army, v):ScaleEmitter(1.5)
        end
    end,
}

TypeClass = BEL0307
