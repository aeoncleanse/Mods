-----------------------------------------------------------------
-- File     :  /cdimage/units/BAB2306/BAB2306_script.lua
-- Author(s):  John Comes, David Tomandl, Jessica St. Croix
-- Summary  :  Aeon Light Artillery Installation Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit
local MiniPhasonLaser = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsWeapons.lua').MiniPhasonLaser

BAB2306 = Class(AStructureUnit) {
    Weapons = {
        MainGun = Class(MiniPhasonLaser){},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        AStructureUnit.OnStopBeingBuilt(self,builder,layer)
        if not self.SpinManip then
            self.SpinManip = CreateRotator(self, 'Rotator', 'y', nil, 50, 50, 50)
            self.Trash:Add(self.SpinManip)
        end

        if self.SpinManip then
            self.SpinManip:SetTargetSpeed(500)
        end
    end,

}

TypeClass = BAB2306
