-----------------------------------------------------------------
-- File     :  /cdimage/units/XSB1106/XSB1106_script.lua
-- Author(s):  Dru Staltman
-- Summary  :  Seraphim Mass Storage
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local SMassStorageUnit = import('/lua/seraphimunits.lua').SMassStorageUnit

XSB1306 = Class(SMassStorageUnit) {
    OnStopBeingBuilt = function(self, builder, layer)
        SMassStorageUnit.OnStopBeingBuilt(self, builder, layer)
        self.Trash:Add(CreateStorageManip(self, 'Mass', 'MASS', 0, 0, 0, 0, 0, .41))
        self.Trash:Add(CreateStorageManip(self, 'energy', 'ENERGY', 0, 0, 0, 0, 0, .6))
    end,
}

TypeClass = XSB1306
