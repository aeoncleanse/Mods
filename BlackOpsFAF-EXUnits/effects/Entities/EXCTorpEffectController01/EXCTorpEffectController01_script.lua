#****************************************************************************
#**
#**  File     :  /mods/BlackopsACUs/effects/Entities/EXBillyEffectController01/EXBillyEffectController01_script.lua
#**  Author(s):  Gordon Duclos
#**
#**  Summary  :  Nuclear explosion script
#**
#**  Copyright © 2005,2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local NullShell = import('/lua/sim/defaultprojectiles.lua').NullShell
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

EXCTorpEffectController01 = Class(NullShell) {
    NukeOuterRingDamage = 0,
    NukeOuterRingRadius = 0,
    NukeOuterRingTicks = 0,
    NukeOuterRingTotalTime = 0,

    NukeInnerRingDamage = 0,
    NukeInnerRingRadius = 0,
    NukeInnerRingTicks = 0,
    NukeInnerRingTotalTime = 0,
   
    
    # NOTE: This script has been modified to REQUIRE that data is passed in!  The nuke won't explode until this happens!
    #OnCreate = function(self)

    PassData = function(self, Data)
        if Data.NukeOuterRingDamage then self.NukeOuterRingDamage = Data.NukeOuterRingDamage end
        if Data.NukeOuterRingRadius then self.NukeOuterRingRadius = Data.NukeOuterRingRadius end
        if Data.NukeOuterRingTicks then self.NukeOuterRingTicks = Data.NukeOuterRingTicks end
        if Data.NukeOuterRingTotalTime then self.NukeOuterRingTotalTime = Data.NukeOuterRingTotalTime end
        if Data.NukeInnerRingDamage then self.NukeInnerRingDamage = Data.NukeInnerRingDamage end
        if Data.NukeInnerRingRadius then self.NukeInnerRingRadius = Data.NukeInnerRingRadius end
        if Data.NukeInnerRingTicks then self.NukeInnerRingTicks = Data.NukeInnerRingTicks end
        if Data.NukeInnerRingTotalTime then self.NukeInnerRingTotalTime = Data.NukeInnerRingTotalTime end
  
        self:CreateNuclearExplosion()
    end,

    CreateNuclearExplosion = function(self)
        local myBlueprint = self:GetBlueprint()
    
    # Create Damage Threads
        self:ForkThread(self.InnerRingDamage)
        self:ForkThread(self.OuterRingDamage)

    # Create thread that spawns and controls effects
        self:ForkThread(self.EffectThread)
    end,    

    OuterRingDamage = function(self)
        local myPos = self:GetPosition()
        if self.NukeOuterRingTotalTime == 0 then
            DamageArea(self:GetLauncher(), myPos, self.NukeOuterRingRadius, self.NukeOuterRingDamage, 'Normal', true, true)
        else
            local ringWidth = ( self.NukeOuterRingRadius / self.NukeOuterRingTicks )
            local tickLength = ( self.NukeOuterRingTotalTime / self.NukeOuterRingTicks )
            # Since we're not allowed to have an inner radius of 0 in the DamageRing function,
            # I'm manually executing the first tick of damage with a DamageArea function.
            DamageArea(self:GetLauncher(), myPos, ringWidth, self.NukeOuterRingDamage, 'Normal', true, true)
            WaitSeconds(tickLength)
            for i = 2, self.NukeOuterRingTicks do
                #print('Damage Ring: MaxRadius:' .. 2*i)
                DamageRing(self:GetLauncher(), myPos, ringWidth * (i - 1), ringWidth * i, self.NukeOuterRingDamage, 'Normal', true, true)
                WaitSeconds(tickLength)
            end
        end
    end,

    InnerRingDamage = function(self)
        local myPos = self:GetPosition()
        if self.NukeInnerRingTotalTime == 0 then
            DamageArea(self:GetLauncher(), myPos, self.NukeInnerRingRadius, self.NukeInnerRingDamage, 'Normal', true, true)
        else
            local ringWidth = ( self.NukeInnerRingRadius / self.NukeInnerRingTicks )
            local tickLength = ( self.NukeInnerRingTotalTime / self.NukeInnerRingTicks )
            # Since we're not allowed to have an inner radius of 0 in the DamageRing function,
            # I'm manually executing the first tick of damage with a DamageArea function.
            DamageArea(self:GetLauncher(), myPos, ringWidth, self.NukeInnerRingDamage, 'Normal', true, true)
            WaitSeconds(tickLength)
            for i = 2, self.NukeInnerRingTicks do
                #LOG('Damage Ring: MaxRadius:' .. ringWidth * i)
                DamageRing(self:GetLauncher(), myPos, ringWidth * (i - 1), ringWidth * i, self.NukeInnerRingDamage, 'Normal', true, true)
                WaitSeconds(tickLength)
            end
        end
    end,

    EffectThread = function(self)
        local army = self:GetArmy()
        local position = self:GetPosition()

		CreateEmitterAtEntity(self, army, '/mods/BlackOpsFAF-EXUnits/effects/emitters/exconcussiontorp_shockwave_01_emit.bp' ):ScaleEmitter(0.05)
		
        CreateEmitterAtEntity(self, army, '/effects/emitters/destruction_underwater_explosion_splash_02_emit.bp' ):ScaleEmitter(2.5)--:OffsetEmitter(0, 2, 0)
        CreateEmitterAtEntity(self, army, '/effects/emitters/destruction_underwater_explosion_splash_02_emit.bp' ):ScaleEmitter(1.5)--:OffsetEmitter(0, 2, 0)

        CreateEmitterAtEntity(self, army, '/effects/emitters/destruction_water_splash_plume_01_emit.bp' ):ScaleEmitter(0.75)
        CreateEmitterAtEntity(self, army, '/effects/emitters/destruction_water_splash_plume_01_emit.bp' ):ScaleEmitter(0.5):OffsetEmitter(0.25, 0, 0)
        CreateEmitterAtEntity(self, army, '/effects/emitters/destruction_water_splash_plume_01_emit.bp' ):ScaleEmitter(0.5):OffsetEmitter(-0.25, 0, 0)
        CreateEmitterAtEntity(self, army, '/effects/emitters/destruction_water_splash_plume_01_emit.bp' ):ScaleEmitter(0.5):OffsetEmitter(0, 0, 0.25)
        CreateEmitterAtEntity(self, army, '/effects/emitters/destruction_water_splash_plume_01_emit.bp' ):ScaleEmitter(0.5):OffsetEmitter(0, 0, -0.25)
        CreateEmitterAtEntity(self, army, '/effects/emitters/destruction_water_splash_plume_01_emit.bp' ):ScaleEmitter(0.5):OffsetEmitter(0.25, 0, 0.25)
        CreateEmitterAtEntity(self, army, '/effects/emitters/destruction_water_splash_plume_01_emit.bp' ):ScaleEmitter(0.5):OffsetEmitter(-0.25, 0, -0.25)
        CreateEmitterAtEntity(self, army, '/effects/emitters/destruction_water_splash_plume_01_emit.bp' ):ScaleEmitter(0.5):OffsetEmitter(-0.25, 0, 0.25)
        CreateEmitterAtEntity(self, army, '/effects/emitters/destruction_water_splash_plume_01_emit.bp' ):ScaleEmitter(0.5):OffsetEmitter(0.25, 0, -0.25)
		
        CreateEmitterAtEntity(self, army, '/effects/emitters/destruction_water_sinking_ripples_01_emit.bp' ):ScaleEmitter(0.6)--:OffsetEmitter(0, 2, 0)

        CreateLightParticle(self, -1, army, 3, 10, 'glow_02', 'ramp_nuke_02')-- Exavier Modified 4th 5th Value
    end,  
    
}

TypeClass = EXCTorpEffectController01

