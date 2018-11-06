--****************************************************************************
--**
--**  File     :  /cdimage/units/UAL0303/UAL0303_script.lua
--**  Author(s):  John Comes, David Tomandl
--**
--**  Summary  :  Aeon Siege Assault Bot Script
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local AWalkingLandUnit = import('/lua/aeonunits.lua').AWalkingLandUnit
local ADFReactonCannon = import('/lua/aeonweapons.lua').ADFReactonCannon
local EffectUtil = import('/lua/EffectUtilities.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')

EAL0301 = Class(AWalkingLandUnit) {
    Weapons = {
        FrontTurret01 = Class(ADFReactonCannon) {}
    },

    OnStopBeingBuilt = function(self,builder,layer)
        AWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:DisableUnitIntel('RadarStealth')
        self:DisableUnitIntel('RadarStealthField')
        if(not self.TeleAnimManip) then
            self.TeleAnimManip = CreateAnimator(self)
        end
    end,

    OnFailedTeleport = function(self)
        AWalkingLandUnit.OnFailedTeleport(self)
        self.TeleAnimManip:PlayAnim('/mods/BlackOpsFAF-EXUnits/units/EAL0301/EAL0301_TeleAnim.sca')
        self.TeleAnimManip:SetAnimationFraction(1)
        self.TeleAnimManip:SetRate(-0.25)
        self.Trash:Add(self.TeleAnimManip)
    end,

    PlayTeleportChargeEffects = function(self, location)
        self.TeleAnimManip:PlayAnim('/mods/BlackOpsFAF-EXUnits/units/EAL0301/EAL0301_TeleAnim.sca')
        self.TeleAnimManip:SetRate(0.25)
        self.Trash:Add(self.TeleAnimManip)
        AWalkingLandUnit.PlayTeleportChargeEffects(self, location)
    end,

    PlayTeleportInEffects = function(self)
        AWalkingLandUnit.PlayTeleportInEffects(self)
        self.TeleAnimManip:PlayAnim('/mods/BlackOpsFAF-EXUnits/units/EAL0301/EAL0301_TeleAnim.sca')
        self.TeleAnimManip:SetAnimationFraction(1)
        self.TeleAnimManip:SetRate(-0.25)
        self.Trash:Add(self.TeleAnimManip)
    end,

}

TypeClass = EAL0301