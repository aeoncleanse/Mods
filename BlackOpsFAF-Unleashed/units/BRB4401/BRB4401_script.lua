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
    end,    
}

TypeClass = BRB4401
