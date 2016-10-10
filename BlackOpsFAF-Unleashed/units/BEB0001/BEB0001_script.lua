-----------------------------------------------------------------
-- File     :  /cdimage/units/UEB5202/UEB5202_script.lua
-- Author(s):  John Comes, David Tomandl
-- Summary  :  UEF Air Staging Platform
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local TAirStagingPlatformUnit = import('/lua/terranunits.lua').TAirStagingPlatformUnit

BEB0001 = Class(TAirStagingPlatformUnit) {
    -- Sets up parent call backs between drone and parent
    Parent = nil,

    SetParent = function(self, parent, droneName)
        self.Parent = parent
        self.Drone = droneName
    end,

    OnDamage = function()
    end,
}

TypeClass = BEB0001
