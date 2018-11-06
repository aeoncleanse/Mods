-----------------------------------------------------------------
-- File     :  /cdimage/units/BAL0401/BAL0401_script.lua
-- Author(s):  John Comes, David Tomandl, Jessica St. Croix
-- Summary  :  Aeon Long Range Artillery Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local AWalkingLandUnit = import('/lua/aeonunits.lua').AWalkingLandUnit
local WeaponsFile = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsWeapons.lua')
local GoldenLaserGenerator = WeaponsFile.GoldenLaserGenerator
local cWeapons = import('/lua/cybranweapons.lua')
local CDFLaserHeavyWeapon = cWeapons.CDFLaserHeavyWeapon
local explosion = import('/lua/defaultexplosions.lua')
local BlackOpsEffectTemplate = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsEffectTemplates.lua')

BAL0401 = Class(AWalkingLandUnit) {
    ChargeEffects01 = {
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/g_laser_flash_01_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/g_laser_muzzle_01_emit.bp',
    },

    ChargeEffects02 = {
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/g_laser_charge_01_emit.bp',
    },

    ChargeEffects03 = {
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/g_laser_flash_01_emit.bp',
        '/mods/BlackOpsFAF-Unleashed/effects/emitters/g_laser_muzzle_01_emit.bp',
    },

    Weapons = {
        BoomWeapon = Class(CDFLaserHeavyWeapon){
            PlayFxWeaponPackSequence = function(self)
                self.unit:SetWeaponEnabledByLabel('DefenseGun01', false)
                if self.SpinManip1 then
                    self.SpinManip1:SetTargetSpeed(0)
                end

                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(0)
                end

                if self.SpinManip3 then
                    self.SpinManip3:SetTargetSpeed(0)
                end
                CDFLaserHeavyWeapon.PlayFxWeaponPackSequence(self)
            end,

            PlayFxWeaponUnpackSequence = function(self)
                self.unit:SetWeaponEnabledByLabel('DefenseGun01', true)
                if not self.SpinManip1 then
                    self.SpinManip1 = CreateRotator(self.unit, 'Spinner_1', 'y', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip1)
                end
                if self.SpinManip1 then
                    self.SpinManip1:SetTargetSpeed(200)
                end

                if not self.SpinManip2 then
                    self.SpinManip2 = CreateRotator(self.unit, 'Spinner_2', 'y', nil, -270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip2)
                end
                if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(-200)
                end

                if not self.SpinManip3 then
                    self.SpinManip3 = CreateRotator(self.unit, 'Spinner_3', 'y', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip3)
                end
                if self.SpinManip3 then
                    self.SpinManip3:SetTargetSpeed(300)
                end
                CDFLaserHeavyWeapon.PlayFxWeaponUnpackSequence(self)
            end,

            CreateProjectileForWeapon = function(self, bone)
                local bp = self:GetBlueprint()
                local numProjectiles = 8
                local rangeNum = 5
                for i = 0, (numProjectiles -1) do
                    WaitTicks(Random(5,10))
                    local pos = self:GetCurrentTargetPos()
                    ranX = Random(-8,8)
                    ranZ = Random(-8,8)
                    pos.y = pos.y + 200 or 200
                    pos.x = pos.x + ranX
                    pos.z = pos.z + ranZ
                    local proj = CDFLaserHeavyWeapon.CreateProjectileForWeapon(self, bone)
                    Warp(proj,pos)
                    rangeNum = (rangeNum - 1)
                    self.unit:PlayUnitSound('WarpingProjectile')
                    CreateLightParticle(self.unit, 'Bombard', self.unit:GetArmy(), 5, 2, 'beam_white_01', 'ramp_white_07')
                    CreateAttachedEmitter(self.unit, 'Bombard', self.unit:GetArmy(), '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp'):ScaleEmitter(0.08)
                end
            end,
        },
         DefenseGun01 = Class(GoldenLaserGenerator) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        AWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateRotator(self, 'Spinner_Ball', 'x', nil, 0, 100, 200))
        self.Trash:Add(CreateRotator(self, 'Spinner_Ball', 'y', nil, 0, 100, 200))
        self.Trash:Add(CreateRotator(self, 'Spinner_Ball', 'z', nil, 0, 100, 200))
        self.MaelstromEffects01 = {}
        if self.MaelstromEffects01 then
                for k, v in self.MaelstromEffects01 do
                    v:Destroy()
                end
            self.MaelstromEffects01 = {}
        end
        table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Spinner_Rack', self:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/inqu_glow_effect03.bp'):ScaleEmitter(0.7):OffsetEmitter(0, -2.1, 0))
        table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Spinner_Rack', self:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/inqu_glow_effect01.bp'):ScaleEmitter(3):OffsetEmitter(0, 0, 0))
        table.insert(self.MaelstromEffects01, CreateAttachedEmitter(self, 'Spinner_Rack', self:GetArmy(), '/mods/BlackOpsFAF-Unleashed/effects/emitters/inqu_glow_effect02.bp'):ScaleEmitter(3):OffsetEmitter(0, 0, 0))
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        local wep = self:GetWeaponByLabel('DefenseGun01')
        local bp = wep:GetBlueprint()
        if bp.Audio.BeamStop then
            wep:PlaySound(bp.Audio.BeamStop)
        end
        if bp.Audio.BeamLoop and wep.Beams[1].Beam then
            wep.Beams[1].Beam:SetAmbientSound(nil, nil)
        end
        for k, v in wep.Beams do
            v.Beam:Disable()
        end
        AWalkingLandUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    DeathThread = function(self, overkillRatio , instigator)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Spinner_Ball', 5.0)
        explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), {self:GetUnitSizes()})
        WaitSeconds(2)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Leg_A_3', 1.0)
        WaitSeconds(0.1)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Spinner_1', 1.0)
        WaitSeconds(0.1)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Leg_D_2', 1.0)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Spinner_3', 1.0)
        WaitSeconds(0.3)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Leg_B_1', 1.0)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Leg_B_2', 1.0)

        WaitSeconds(1.5)
        explosion.CreateDefaultHitExplosionAtBone(self, 'Body', 5.0)

        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end

        self:CreateProjectileAtBone('/mods/BlackOpsFAF-Unleashed/effects/entities/InqDeathEffectController01/InqDeathEffectController01_proj.bp', 'Body'):SetCollision(false)

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

TypeClass = BAL0401
