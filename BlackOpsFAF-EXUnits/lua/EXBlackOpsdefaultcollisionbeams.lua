--****************************************************************************
--**
--**  File     :  /lua/defaultcollisionbeams.lua
--**  Author(s):  Gordon Duclos
--**
--**  Summary  :  Default definitions collision beams
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local CollisionBeam = import('/lua/sim/CollisionBeam.lua').CollisionBeam
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Util = import('/lua/utilities.lua')
local EffectTemplate2 = import('/mods/BlackOpsFAF-EXUnits/lua/EXEffectTemplates.lua')
local EXEffectTemplate = import('/mods/BlackOpsFAF-EXUnits/lua/EXBlackOpsEffectTemplates.lua')

local EXCollisionBeam = import('/mods/BlackOpsFAF-EXUnits/lua/EXCollisionBeam.lua').CollisionBeam

-------------------------------
--   Base class that defines supreme commander specific defaults
-------------------------------
SCCollisionBeam = Class(CollisionBeam) {
    FxImpactUnit = EffectTemplate.DefaultProjectileLandUnitImpact,
    FxImpactLand = {},--EffectTemplate.DefaultProjectileLandImpact,
    FxImpactWater = EffectTemplate.DefaultProjectileWaterImpact,
    FxImpactUnderWater = EffectTemplate.DefaultProjectileUnderWaterImpact,
    FxImpactAirUnit = EffectTemplate.DefaultProjectileAirUnitImpact,
    FxImpactProp = {},
    FxImpactShield = {},
    FxImpactNone = {},
}

-------------------------------
--   UEF Sonic Disruptor Wave
-------------------------------
SonicDisruptorWaveCBeam = Class(EXCollisionBeam) {
    FxBeam = {},

    TerrainImpactType = 'LargeBeam02',

    FxBeamStartPoint = EXEffectTemplate.SonicDisruptorWaveMuzzle,
    FxBeam = EXEffectTemplate.SonicDisruptorWaveBeam01,
    FxBeamEndPoint = EXEffectTemplate.SonicDisruptorWaveHit,

    FxBeamStartPointScale = 0.5,
    FxBeamEndPointScale = 0.5,
    TerrainImpactScale = 0.2,

    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.25,

}

CybranBeamWeapons = Class(SCCollisionBeam) {

    TerrainImpactType = 'LargeBeam01',
    TerrainImpactScale = 1,
    FxBeamStartPoint = EffectTemplate.CMicrowaveLaserMuzzle01,
    FxBeam = {'/effects/emitters/microwave_laser_beam_01_emit.bp'},
    FxBeamEndPoint = EffectTemplate.CMicrowaveLaserEndPoint01,
    SplatTexture = 'czar_mark01_albedo',
    ScorchSplatDropTime = 0.25,

    OnImpact = function(self, impactType, targetEntity)
        if impactType == 'Terrain' then
            if self.Scorching == nil then
                self.Scorching = self:ForkThread(self.ScorchThread)
            end
        elseif not impactType == 'Unit' then
            KillThread(self.Scorching)
            self.Scorching = nil
        end
        CollisionBeam.OnImpact(self, impactType, targetEntity)
    end,

    OnDisable = function(self)
        CollisionBeam.OnDisable(self)
        KillThread(self.Scorching)
        self.Scorching = nil
    end,

    ScorchThread = function(self)
        local army = self:GetArmy()
        local size = 0.5 + (Random() * 1.5)
        local CurrentPosition = self:GetPosition(1)
        local LastPosition = Vector(0,0,0)
        local skipCount = 1
        while true do
            if Util.GetDistanceBetweenTwoVectors(CurrentPosition, LastPosition) > 0.25 or skipCount > 100 then
                CreateSplat(CurrentPosition, Util.GetRandomFloat(0,2*math.pi), self.SplatTexture, size, size, 100, 100, army)
                LastPosition = CurrentPosition
                skipCount = 1
            else
                skipCount = skipCount + self.ScorchSplatDropTime
            end

            WaitSeconds(self.ScorchSplatDropTime)
            size = 1.2 + (Random() * 1.5)
            CurrentPosition = self:GetPosition(1)
        end
    end,
}

CybranSSBeam = Class(CybranBeamWeapons) {
    TerrainImpactScale = 0.25,
    FxBeamStartPoint = EffectTemplate.CMicrowaveLaserMuzzle01,
    FxBeam = {'/mods/BlackOpsFAF-EXUnits/effects/emitters/exss_beam_01_emit.bp'},
    FxBeamEndPoint = EffectTemplate.CMicrowaveLaserEndPoint01,
    FxBeamStartPointScale = 0.5,
    FxBeamEndPointScale = 0.5,
}

CybranAriesBeam01 = Class(CybranBeamWeapons) {
    TerrainImpactScale = 0.5,
    FxBeamStartPoint = EffectTemplate.CMicrowaveLaserMuzzle01,
    FxBeam = {'/mods/BlackOpsFAF-EXUnits/effects/emitters/exaries_beam_01_emit.bp'},
    FxBeamEndPoint = EffectTemplate.CMicrowaveLaserEndPoint01,
    FxBeamStartPointScale = 0.75,
    FxBeamEndPointScale = 0.75,
}