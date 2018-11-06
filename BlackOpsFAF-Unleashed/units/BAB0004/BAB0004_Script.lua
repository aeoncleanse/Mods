-----------------------------------------------------------------
-- File     :  /cdimage/units/XSB0003/XSB0003_script.lua
-- Author(s):  John Comes, David Tomandl
-- Summary  :  UEF Wall Piece Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit

BAB0003 = Class(SStructureUnit) {
    -- Sets up parent call backs between drone and parent
    Parent = nil,

    SetParent = function(self, parent, droneName)
        self.Parent = parent
        self.Drone = droneName
    end,

    OnCreate = function(self, builder, layer)
        SStructureUnit.OnCreate(self, builder, layer)
    end,

    -- Make this unit invulnerable
    OnDamage = function()
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        SStructureUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    DeathThread = function(self)
        self:Destroy()
    end,
}

TypeClass = BAB0003
