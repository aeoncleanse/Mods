-----------------------------------------------------------------
-- File     :  /cdimage/units/XSC9002/XSC9002_script.lua
-- Author   :  Greg Kohne
-- Summary  :  Jamming Crystal
--
-- Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local SLandUnit = import('/lua/seraphimunits.lua').SLandUnit

BEL9010 = Class(SLandUnit) {
    OnCreate = function(self, builder, layer)
        SLandUnit.OnCreate(self)
    end,
}

TypeClass = BEL9010
