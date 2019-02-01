-----------------------------------------------------------------
-- File     :  /cdimage/units/XRA0409/XRA0409_script.lua
-- Author(s):  John Comes, David Tomandl
-- Summary  :  Cybran T2 Air Transport Script
-- Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local AirTransport = import('/lua/defaultunits.lua').AirTransport
local explosion = import('/lua/defaultexplosions.lua')
local weaponfile2 = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsWeapons.lua')
local MartyrHeavyMicrowaveLaserGenerator = weaponfile2.MartyrHeavyMicrowaveLaserGenerator
local CIFMissileStrategicWeapon = import('/lua/cybranweapons.lua').CIFMissileStrategicWeapon
local RedHeavyTurboLaserWeapon = weaponfile2.RedHeavyTurboLaserWeapon
local util = import('/lua/utilities.lua')
local fxutil = import('/lua/effectutilities.lua')

BRA0409 = Class(AirTransport) {
    DestroyNoFallRandomChance = 1.1,
    Weapons = {
        AA01 = Class(MartyrHeavyMicrowaveLaserGenerator) {},
        AA02 = Class(MartyrHeavyMicrowaveLaserGenerator) {},
        AA03 = Class(MartyrHeavyMicrowaveLaserGenerator) {},
        AA04 = Class(MartyrHeavyMicrowaveLaserGenerator) {},
        AA05 = Class(MartyrHeavyMicrowaveLaserGenerator) {},
        AA06 = Class(MartyrHeavyMicrowaveLaserGenerator) {},
        RocketPod01 = Class(RedHeavyTurboLaserWeapon) {},
        RocketPod02 = Class(RedHeavyTurboLaserWeapon) {},
        RocketPod03 = Class(RedHeavyTurboLaserWeapon) {},
        RocketPod04 = Class(RedHeavyTurboLaserWeapon) {},
        MainGun = Class(CIFMissileStrategicWeapon) {},
    },

    AirDestructionEffectBones = {'Engine_01', 'Engine_02', 'Engine_03', 'Engine_04', 'Engine_05', 'Main_Gun_Turret', 'L_Barrel_01', 'R_Barrel_01',
                                  'L_Back_Barrel_01', 'R_Back_Turret_01', 'Main_Gun_Muzzle','R_Turret_01', 'R_U_Muzzle_01',
                                  'Door_Right', 'Door_Left', 'Right_wing','Left_wing',
                                  'R_Pivot01', 'L_pivot_01', 'L_Back_Turret_01','R_B_AA_Muzzle_01',
                                  'R_Back_Barrel_01', 'Attachpoint01', 'Attachpoint02','Attachpoint03',
                                  'Attachpoint04', 'Attachpoint05', 'Attachpoint06', 'Attachpoint07',
                                  'Attachpoint08', 'Attachpoint09', 'Attachpoint10', 'Attachpoint11',
                                  'Attachpoint12', 'Attachpoint13', 'Attachpoint14', 'Attachpoint15',
                                  'Attachpoint16', 'Attachpoint17',
                                  'Attachpoint18', 'Attachpoint19', 'Attachpoint20'},

    BeamExhaustIdle = '/effects/emitters/missile_exhaust_fire_beam_05_emit.bp',
    BeamExhaustCruise = '/effects/emitters/missile_exhaust_fire_beam_04_emit.bp',

    MovementAmbientExhaustBones = {
        'Engine_01',
        'Engine_02',
        'Engine_03',
    },

    MovementAmbientExhaustBones2 = {
        'Engine_04',
        'Engine_05',
    },

    -- When one of our attached units gets killed, detach it
    OnAttachedKilled = function(self, attached)
        attached:DetachFrom()
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self:TransportDetachAllUnits(true)
        AirTransport.OnKilled(self, instigator, type, overkillRatio)
    end,

    OnTransportAttach = function(self, attachBone, unit)
        AirTransport.OnTransportAttach(self, attachBone, unit)
        unit:SetCanTakeDamage(false)
    end,

    OnTransportDetach = function(self, attachBone, unit)
        unit:SetCanTakeDamage(true)
        AirTransport.OnTransportDetach(self, attachBone, unit)
    end,

    -- Override air destruction effects so we can do something custom here
    CreateUnitAirDestructionEffects = function(self, scale)
        self:ForkThread(self.AirDestructionEffectsThread, self)
    end,

    AirDestructionEffectsThread = function(self)
        local numExplosions = math.floor(table.getn(self.AirDestructionEffectBones) * 3)
        for i = 0, numExplosions do
            explosion.CreateDefaultHitExplosionAtBone(self, self.AirDestructionEffectBones[util.GetRandomInt(3, numExplosions)], 4)
            WaitSeconds(util.GetRandomFloat(0.5, 1.9))
        end
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        AirTransport.OnStopBeingBuilt(self,builder,layer)

        self.AnimManip = CreateAnimator(self)
        self.Trash:Add(self.AnimManip)

        self:SetMaintenanceConsumptionInactive()
        self:SetScriptBit('RULEUTC_IntelToggle', true)
    end,

    OnMotionHorzEventChange = function(self, new, old)
        AirTransport.OnMotionHorzEventChange(self, new, old)
        if self.ThrustExhaustTT1 == nil then
            if self.MovementAmbientExhaustEffectsBag then
                fxutil.CleanupEffectBag(self,'MovementAmbientExhaustEffectsBag')
            else
                self.MovementAmbientExhaustEffectsBag = {}
            end
            self.ThrustExhaustTT1 = self:ForkThread(self.MovementAmbientExhaustThread)
        end

        -- We've changed flight speed too soon to open
        if self.OpenThread then
            KillThread(self.OpenThread)
            self.OpenThread = nil
        end

        if new == 'TopSpeed' then
            -- Only open after 2 seconds of top-speed flight
            self.OpenThread = self:ForkThread(self.OpenAnimation)
        elseif new == 'Stopping' then
            -- Only close if opened
            if self.open then
                self.CloseThread = self:ForkThread(self.CloseAnimation)
            end
        elseif new == 'Stopped' and self.ThrustExhaustTT1 ~= nil then
            KillThread(self.ThrustExhaustTT1)
            fxutil.CleanupEffectBag(self,'MovementAmbientExhaustEffectsBag')
            self.ThrustExhaustTT1 = nil
        end
    end,

    OpenAnimation = function(self)
        WaitSeconds(1.5)
        self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen, false):SetRate(2)
        self.open = true
    end,

    CloseAnimation = function(self)
        WaitSeconds(1.5)
        self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationClose, false):SetRate(2)
        self.open = false
    end,

    MovementAmbientExhaustThread = function(self)
        while not self.Dead do
            local ExhaustEffects = {
                '/effects/emitters/dirty_exhaust_smoke_01_emit.bp',
                '/effects/emitters/dirty_exhaust_sparks_01_emit.bp',
            }
            local ExhaustBeamLarge = '/mods/BlackOpsFAF-Unleashed/effects/emitters/missile_exhaust_fire_beam_10_emit.bp'
            local ExhaustBeamSmall = '/effects/emitters/missile_exhaust_fire_beam_03_emit.bp'
            local army = self:GetArmy()

            for kE, vE in ExhaustEffects do
                for kB, vB in self.MovementAmbientExhaustBones do
                    table.insert(self.MovementAmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE):ScaleEmitter(2))
                    table.insert(self.MovementAmbientExhaustEffectsBag, CreateBeamEmitterOnEntity(self, vB, army, ExhaustBeamLarge))
                end
                for kB, vB in self.MovementAmbientExhaustBones2 do
                    table.insert(self.MovementAmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE):ScaleEmitter(1))
                    table.insert(self.MovementAmbientExhaustEffectsBag, CreateBeamEmitterOnEntity(self, vB, army, ExhaustBeamSmall))
                end
            end

            WaitSeconds(5)
            fxutil.CleanupEffectBag(self,'MovementAmbientExhaustEffectsBag')
        end
    end,
}

TypeClass = BRA0409
