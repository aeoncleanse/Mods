-----------------------------------------------------------------
-- File     :  /cdimage/units/UAB1106/UAB1106_script.lua
-- Author(s):  Jessica St. Croix, David Tomandl, John Comes
-- Summary  :  Aeon Mass Storage
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local AMassStorageUnit = import('/lua/aeonunits.lua').AMassStorageUnit

BAB1106 = Class(AMassStorageUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        AMassStorageUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateStorageManip(self, 'M_Storage_1', 'MASS', 0, 0, 0, 0, 0, .7))
        self.Trash:Add(CreateStorageManip(self, 'M_Storage_2', 'MASS', 0, 0, 0, 0, 0, .41))
        self.Trash:Add(CreateStorageManip(self, 'E_Storage', 'ENERGY', 0, 0, 0, 0, 0, .6))
        self.Trash:Add(CreateRotator(self, 'Rotator', 'y', nil, 0, 15, 80))
    end,
}

TypeClass = BAB1106
