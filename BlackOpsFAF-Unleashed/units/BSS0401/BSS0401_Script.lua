-----------------------------------------------------------------
-- File     :  /cdimage/units/BSS0401/BSS0401_script.lua
-- Author(s):  Jessica St. Croix, Gordon Duclos, Aaron Lundquist
-- Summary  :  Seraphim Battleship Script
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local SSeaUnit = import('/lua/seraphimunits.lua').SSeaUnit
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SDFHeavyQuarnonCannon = SeraphimWeapons.SDFHeavyQuarnonCannon
local SAMElectrumMissileDefense = SeraphimWeapons.SAMElectrumMissileDefense
local SAAOlarisCannonWeapon = SeraphimWeapons.SAAOlarisCannonWeapon
local SDFUltraChromaticBeamGenerator = SeraphimWeapons.SDFUltraChromaticBeamGenerator02
local SIFHuAntiNukeWeapon = import('/lua/seraphimweapons.lua').SIFHuAntiNukeWeapon
local SDFSinnuntheWeapon = SeraphimWeapons.SDFSinnuntheWeapon
local nukeFiredOnGotTarget = false

BSS0401 = Class(SSeaUnit) {
    FxDamageScale = 2,
    DestructionTicks = 400,

    Weapons = {
        FrontMainTurret01 = Class(SDFSinnuntheWeapon) {
                    PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                SDFSinnuntheWeapon.PlayFxWeaponPackSequence(self)
            end,

            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then
                    self.SpinManip = CreateRotator(self.unit, 'Main_Front_Turret_Spinner', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end

                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(900)
                end
                SDFSinnuntheWeapon.PlayFxRackSalvoChargeSequence(self)
            end,

            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(100)
                end
                SDFSinnuntheWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },

        BackMainTurret01 = Class(SDFSinnuntheWeapon) {
                    PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                SDFSinnuntheWeapon.PlayFxWeaponPackSequence(self)
            end,

            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then
                    self.SpinManip = CreateRotator(self.unit, 'Main_Back_Turret_Spinner', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end

                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(900)
                end
                SDFSinnuntheWeapon.PlayFxRackSalvoChargeSequence(self)
            end,

            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(100)
                end
                SDFSinnuntheWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },

        FrontTurret01 = Class(SDFHeavyQuarnonCannon) {},
        FrontTurret02 = Class(SDFHeavyQuarnonCannon) {},
        FrontTurret03 = Class(SDFHeavyQuarnonCannon) {},
        AntiMissileTactical = Class(SAMElectrumMissileDefense) {},
        AntiAirLeft01 = Class(SAAOlarisCannonWeapon) {},
        AntiAirLeft02 = Class(SAAOlarisCannonWeapon) {},
        LeftDeckTurret01 = Class(SDFUltraChromaticBeamGenerator) {},
        RightDeckTurret01 = Class(SDFUltraChromaticBeamGenerator) {},
        LeftDeckTurret02 = Class(SDFUltraChromaticBeamGenerator) {},
        RightDeckTurret02 = Class(SDFUltraChromaticBeamGenerator) {},
        AntiAirRight01 = Class(SAAOlarisCannonWeapon) {},
        AntiAirRight02 = Class(SAAOlarisCannonWeapon) {},
        MissileRack = Class(SIFHuAntiNukeWeapon) {
            IdleState = State(SIFHuAntiNukeWeapon.IdleState) {
                OnGotTarget = function(self)
                    local bp = self:GetBlueprint()
                    if (bp.WeaponUnpackLockMotion ~= true or (bp.WeaponUnpackLocksMotion == true and not self.unit:IsUnitState('Moving'))) then
                        if (bp.CountedProjectile == false) or self:CanFire() then
                             nukeFiredOnGotTarget = true
                        end
                    end
                    SIFHuAntiNukeWeapon.IdleState.OnGotTarget(self)
                end,

                OnFire = function(self)
                    if not nukeFiredOnGotTarget then
                        SIFHuAntiNukeWeapon.IdleState.OnFire(self)
                    end
                    nukeFiredOnGotTarget = false

                    self:ForkThread(function()
                        self.unit:SetBusy(true)
                        WaitSeconds(1/self.unit:GetBlueprint().Weapon[1].RateOfFire + .2)
                        self.unit:SetBusy(false)
                    end)
                end,
            },
        },
    },

    OnStopBeingBuilt = function(self, builder, layer)
        self:HideBone('Pod04', true)
        self:HideBone('Pod05', true)
        self:HideBone('Pod06', true)
        SSeaUnit.OnStopBeingBuilt(self, builder, layer)
    end,

    OnKilled = function(self, instigator, damagetype, overkillRatio)
        self.Trash:Destroy()
        self.Trash = TrashBag()
        SSeaUnit.OnKilled(self, instigator, damagetype, overkillRatio)
    end,
}

TypeClass = BSS0401
