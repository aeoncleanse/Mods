-----------------------------------------------------------------
-- File     :  /cdimage/units/UAS0302/UAS0302_script.lua
-- Author(s):  John Comes, David Tomandl, Jessica St. Croix
-- Summary  :  Aeon Battleship Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local AHoverLandUnit = import('/lua/aeonunits.lua').AHoverLandUnit
local AeonWep = import('/lua/aeonweapons.lua')
local ADFDisruptorWeapon = AeonWep.ADFDisruptorWeapon
local AIFMissileTacticalSerpentineWeapon = AeonWep.AIFMissileTacticalSerpentineWeapon
local AAMWillOWisp = AeonWep.AAMWillOWisp
local explosion = import('/lua/defaultexplosions.lua')
local Weapon = import('/lua/sim/Weapon.lua').Weapon

local GenesisMaelstromWeapon = Class(Weapon) {
    OnFire = function(self)
        local blueprint = self:GetBlueprint()
        DamageArea(self.unit, self.unit:GetPosition(), blueprint.DamageRadius,
            blueprint.Damage, blueprint.DamageType, blueprint.DamageFriendly)
    end,
}

BAL0402 = Class(AHoverLandUnit) {
    FxDamageScale = 2,
    DestructionTicks = 400,

    Weapons = {
        MissileRack = Class(AIFMissileTacticalSerpentineWeapon) {
            OnWeaponFired = function(self)
                self.unit.weaponCounter = self.unit.weaponCounter + 1
                local wepCount = self.unit.weaponCounter
                if wepCount == 3 then
                    ForkThread(self.ReloadThread, self)
                    self.unit.weaponCounter = 0
                end
                AIFMissileTacticalSerpentineWeapon.OnWeaponFired(self)
            end,

            ReloadThread = function(self)
                self.unit:SetWeaponEnabledByLabel('MissileRack', false)
                WaitSeconds(12.5)
                if not self.unit.Dead then
                    self.unit:SetWeaponEnabledByLabel('MissileRack', true)
                end
            end,
        },

        MainGun = Class(ADFDisruptorWeapon) {},

        LeftTurret = Class(AeonWep.ADFCannonOblivionWeapon) {
            FxMuzzleFlash = {
                '/effects/emitters/oblivion_cannon_flash_04_emit.bp',
                '/effects/emitters/oblivion_cannon_flash_05_emit.bp',
                '/effects/emitters/oblivion_cannon_flash_06_emit.bp',
            },
        },

        RightTurret = Class(AeonWep.ADFCannonOblivionWeapon) {
            FxMuzzleFlash = {
                '/effects/emitters/oblivion_cannon_flash_04_emit.bp',
                '/effects/emitters/oblivion_cannon_flash_05_emit.bp',
                '/effects/emitters/oblivion_cannon_flash_06_emit.bp',
            },
        },

        AntiMissile1 = Class(AAMWillOWisp) {},
        GenesisMaelstrom01 = Class(GenesisMaelstromWeapon) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        self.MaelstromEffects01 = {}
        self.weaponCounter = 0
        if self.MaelstromEffects01 then
                for k, v in self.MaelstromEffects01 do
                    v:Destroy()
                end
            self.MaelstromEffects01 = {}
        end
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Maelstrom', self:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/genmaelstrom_aura_01_emit.bp'):ScaleEmitter(1):OffsetEmitter(0, -2, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Maelstrom', self:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/genmaelstrom_aura_02_emit.bp'):ScaleEmitter(1):OffsetEmitter(0, -2.75, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Effect01', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Effect01', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Effect01', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Effect02', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Effect02', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Effect02', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Effect03', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Effect03', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Effect03', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Effect04', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_02_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Effect04', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_03_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
            table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Effect04', self:GetArmy(), '/effects/emitters/seraphim_being_built_ambient_04_emit.bp'):ScaleEmitter(0.35):OffsetEmitter(0, -0.05, 0))
        AHoverLandUnit.OnStopBeingBuilt(self, builder, layer)
    end,

    DeathThread = function(self, overkillRatio, instigator)
        explosion.CreateDefaultHitExplosionAtBone(self, 'BAL0402', 4.0)
        explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), {self:GetUnitSizes()})
        WaitSeconds(0.8)
        explosion.CreateDefaultHitExplosionAtBone(self, 'TMD_Muzzle', 3.0)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Right_Barrel', 1.0)
        WaitSeconds(0.1)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Wraith_Left_Recoil_01', 4.0)
        WaitSeconds(0.1)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Wraith_Right_Recoil_02', 1.0)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Missile_Muzzle_6', 3.0)
        WaitSeconds(0.3)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Wraith_Turret_Barrel', 1.0)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Left_Barrel', 5.0)

        WaitSeconds(0.5)
        explosion.CreateDefaultHitExplosionAtBone(self, 'BAL0402', 5.0)

        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end

        local bp = self:GetBlueprint()
        for i, numWeapons in bp.Weapon do
            if(bp.Weapon[i].Label == 'CollossusDeath') then
                DamageArea(self, self:GetPosition(), bp.Weapon[i].DamageRadius, bp.Weapon[i].Damage, bp.Weapon[i].DamageType, bp.Weapon[i].DamageFriendly)
                break
            end
        end

        self:DestroyAllDamageEffects()
        self:CreateWreckage(overkillRatio)

        -- CURRENTLY DISABLED UNTIL DESTRUCTION
        -- Create destruction debris out of the mesh, currently these projectiles look like crap,
        -- since projectile rotation and terrain collision doesn't work that great. These are left in
        -- hopes that this will look better in the future.. =)
        if(self.ShowUnitDestructionDebris and overkillRatio) then
            if overkillRatio <= 1 then
                self.CreateUnitDestructionDebris(self, true, true, false)
            elseif overkillRatio <= 2 then
                self.CreateUnitDestructionDebris(self, true, true, false)
            elseif overkillRatio <= 3 then
                self.CreateUnitDestructionDebris(self, true, true, true)
            else
                self.CreateUnitDestructionDebris(self, true, true, true)
            end
        end

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
}

TypeClass = BAL0402
