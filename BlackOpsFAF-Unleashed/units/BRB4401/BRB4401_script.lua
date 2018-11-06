-----------------------------------------------------------------
-- File     :  /cdimage/units/URB4203/URB4203_script.lua
-- Author(s):  David Tomandl, Jessica St. Croix
-- Summary  :  Cybran Radar Jammer Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local CRadarJammerUnit = import('/lua/cybranunits.lua').CRadarJammerUnit

BRB4401 = Class(CRadarJammerUnit) {
    IntelEffects = {
        {
            Bones = {
                'Emitter',
            },
            Offset = {
                0,
                3,
                0,
            },
            Type = 'Jammer01',
        },
    },

    OnStopBeingBuilt = function(self,builder,layer)
        CRadarJammerUnit.OnStopBeingBuilt(self,builder,layer)
        self.AnimManip = CreateAnimator(self)
        self.Trash:Add(self.AnimManip)
        self.DelayedCloakThread = self:ForkThread(self.CloakDelayed)
    end,

    CloakDelayed = function(self)
        if not self.Dead then
            WaitSeconds(2)
            self.IntelDisables['RadarStealth']['ToggleBit5'] = true
            self.IntelDisables['CloakField']['ToggleBit3'] = true
            self:EnableUnitIntel('ToggleBit5', 'RadarStealth')
            self:EnableUnitIntel('ToggleBit3', 'CloakField')
        end
        KillThread(self.DelayedCloakThread)
        self.DelayedCloakThread = nil
    end,

}

TypeClass = BRB4401
