-----------------------------------------------------------------
-- File     :  /cdimage/units/URB2303/URB2303_script.lua
-- Author(s):  John Comes, David Tomandl, Jessica St. Croix
-- Summary  :  Cybran Light Artillery Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit
local CybranWeaponsFile = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsWeapons.lua')
local HailfireLauncherWeapon = CybranWeaponsFile.HailfireLauncherWeapon

-- Weapon bones for recoil effects
local muzzleBones = {'Muzzle_1', 'Muzzle_2', 'Muzzle_3', 'Muzzle_4', 'Muzzle_5', 'Muzzle_6'}
local recoilgroup1 = {'Recoil_1', 'Recoil_2', 'Recoil_3', 'Recoil_4', 'Recoil_5', 'Recoil_6'}

BRB2303 = Class(CStructureUnit) {
    Weapons = {
        MainGun = Class(HailfireLauncherWeapon) {

        OnCreate = function(self)
                HailfireLauncherWeapon.OnCreate(self)
                self.CurrentBarrel = 1
                self.CurrentGoal = 60
            end,

            PlayRackRecoil = function(self, rackList)
                -- Reset the recoil table
                local recoilTbl = {}

                -- Select the barrel to recoil
                recoilTbl.MuzzleBones = muzzleBones[self.CurrentBarrel]
                recoilTbl.RackBone = recoilgroup1[self.CurrentBarrel]
                table.insert(rackList, recoilTbl)

                HailfireLauncherWeapon.PlayRackRecoil(self, rackList)
                if not self.SpinManip then
                    -- Create the cannon rotator
                    self.SpinManip = CreateRotator(self.unit, 'Rotator', 'z', self.CurrentGoal, 200, 200, 200)
                    self.unit.Trash:Add(self.SpinManip)
                else
                    -- Spin to the next barrel
                    self.SpinManip:SetGoal(self.CurrentGoal)
                    self.SpinManip:SetAccel(200)
                    self.SpinManip:SetTargetSpeed(200)
                end

                -- Increment to the next barrel and goal
                self.CurrentBarrel = self.CurrentBarrel + 1
                self.CurrentGoal = self.CurrentGoal + 60
                if self.CurrentBarrel > 6 then
                    self.CurrentBarrel = 1
                    self.CurrentGoal = 60
                end
            end,

            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                HailfireLauncherWeapon.PlayFxWeaponPackSequence(self)
            end,
        },
    },
}

TypeClass = BRB2303
