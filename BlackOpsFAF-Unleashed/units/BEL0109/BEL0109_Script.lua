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
            WeaponPackingState = State (TIFArtilleryWeapon.WeaponPackingState) {
                Main = function(self)
                    if self.unit.DontMove then
                        ChangeState(self, self.WeaponUnpackingState)
                        return
                    end
                    TIFArtilleryWeapon.WeaponPackingState.Main(self)
                end,
            },
        },
    },

    OnScriptBitSet = function(self, bit)
        if bit == 7 then
            self:RemoveCommandCap('RULEUCC_Move')
            self.DontMove = true
            self.wep = self:GetWeaponByLabel('MainGun')
            ChangeState(self.wep, self.wep.WeaponUnpackingState)
        end
        TLandUnit.OnScriptBitSet(self, bit)
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 7 then
            self:AddCommandCap('RULEUCC_Move')
            IssueClearCommands({self})
            self.DontMove = nil
            self.wep = self:GetWeaponByLabel('MainGun')
            ChangeState(self.wep, self.wep.WeaponPackingState)
        end
        TLandUnit.OnScriptBitClear(self, bit)
    end,
}

TypeClass = BEL0109
