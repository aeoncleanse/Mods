-----------------------------------------------------------------
-- File     :  /cdimage/units/BEL0109/BEL0109_script.lua
-- Author(s):  John Comes, David Tomandl, Jessica St. Croix
-- Summary  :  UEF Tank Hunter/PD tank, initial Tank mode
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local TIFArtilleryWeapon = import('/lua/terranweapons.lua').TIFArtilleryWeapon

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
                    self.unit:SetBusy(true)

                    local bp = self:GetBlueprint()
                    WaitSeconds(self:GetBlueprint().WeaponRepackTimeout)

                    self:AimManipulatorSetEnabled(false)
                    if not self.unit.locked then
                        self:PlayFxWeaponPackSequence()
                        if bp.WeaponUnpackLocksMotion then
                            self.unit:SetImmobile(false)
                        end
                    end
                    ChangeState(self, self.IdleState)
                end,
            },
        },
    },

    OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
        if bit == 7 then
            if not self.deployed then
                local wep = self:GetWeaponByLabel('MainGun')
                wep:ForkThread(wep.PlayFxWeaponUnpackSequence)
            end
            self.locked = true
            self:SetImmobile(true)
        end
    end,
    
    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
        if bit == 7 then
            if not self:IsUnitState('Attacking') then
                self:SetImmobile(false)
            end
            self.locked = false
        end
    end,
}

TypeClass = BEL0109
