-----------------------------------------------------------------
-- File     :  /cdimage/units/BEL0109/BEL0109_script.lua
-- Author(s):  John Comes, David Tomandl, Jessica St. Croix
-- Summary  :  UEF Tank Hunter/PD tank, initial Tank mode
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local TIFArtilleryWeapon = import('/lua/terranweapons.lua').TIFArtilleryWeapon
local Weapon = import('/lua/sim/Weapon.lua').Weapon

BEL0109 = Class(TLandUnit) {
    Weapons = {
       MainGun = Class(TIFArtilleryWeapon) {
            PlayFxWeaponUnpackSequence = function(self)
                -- Remove weapon toggle when unit begins unpacking
                self.unit.deployed = true

                TIFArtilleryWeapon.PlayFxWeaponUnpackSequence(self)
            end,

            PlayFxWeaponPackSequence = function(self)
                TIFArtilleryWeapon.PlayFxWeaponPackSequence(self)

                -- Only reinstate after unit is fully finished repacking
                self.unit.deployed = false
            end,

            WeaponPackingState = State(TIFArtilleryWeapon.WeaponPackingState) {
                Main = function(self)
                    -- Don't pack if in the lock state
                    if self.unit.locked then
                        ChangeState(self, self.IdleState)
                        return
                    end

                    self.unit:SetBusy(true)

                    self:AimManipulatorSetEnabled(false)
                    self:PlayFxWeaponPackSequence()

                    self.unit:SetImmobile(false)

                    ChangeState(self, self.IdleState)
                end,
            },
        },
    },

    OnScriptBitSet = function(self, bit)
        if bit == 7 then
            self:EnableSpecialToggle()

            -- Only unpack and stop if not already
            if not self.deployed then
                local wep = self:GetWeaponByLabel('MainGun')
                ChangeState(wep, wep.WeaponUnpackingState)

                IssueStop({self})
                IssueClearCommands({self})
            end

            -- Set the lock tag. Motion will lock when the weapon unpacks
            self.locked = true
        else
            TLandUnit.OnScriptBitSet(self, bit)
        end
    end,
    
    OnScriptBitClear = function(self, bit)
        if bit == 7 then
            self:DisableSpecialToggle()

            -- Only pack up if the unit isn't firing at something
            if not self:IsUnitState('Attacking') then
                local wep = self:GetWeaponByLabel('MainGun')
                ChangeState(wep, wep.WeaponPackingState)
            end

            -- Turn off the lock. Motion will be enabled when the weapon packs up
            self.locked = false
        else
            TLandUnit.OnScriptBitClear(self, bit)
        end
    end,
}

TypeClass = BEL0109
