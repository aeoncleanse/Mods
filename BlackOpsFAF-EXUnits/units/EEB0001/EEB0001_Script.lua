--****************************************************************************
--**
--**  File     :  /cdimage/units/XSB0001/XSB0001_script.lua
--**  Author(s):  John Comes, David Tomandl
--**
--**  Summary  :  UEF Wall Piece Script
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local SeraLambdaField = import('/mods/BlackOpsFAF-Unleashed/lua/BlackOpsdefaultantiprojectile.lua').SeraLambdaFieldDestroyer
local TerranWeaponFile = import('/lua/terranweapons.lua')
local DeathNukeWeapon = import('/lua/sim/defaultweapons.lua').DeathNukeWeapon


EEB0001 = Class(SStructureUnit) {

    Weapons = {
        DeathWeapon = Class(DeathNukeWeapon) {},
    },

    Parent = nil,

    SetParent = function(self, parent, droneName)
        self.Parent = parent
        self.Drone = droneName
    end,

    OnCreate = function(self, builder, layer)
        SStructureUnit.OnCreate(self, builder, layer)
        self:ForkThread(self.CoreEffectsCreation)
        self.UnitComplete = true
    end,

    CoreEffectsCreation = function(self)
        self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), '/mods/BlackOpsFAF-EXUnits/effects/emitters/exstar_01_emit.bp')
        self.Effect1:ScaleEmitter(0.15)
        WaitSeconds(2)
        self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), '/mods/BlackOpsFAF-EXUnits/effects/emitters/exstar_02_emit.bp')
        self.Effect2:ScaleEmitter(3.6)
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        ------ Notifies parent of drone death and clears the offending drone from the parents table
        if not self.Parent.Dead then
            self.Parent:NotifyOfDroneDeath(self.Drone)
            table.removeByValue(self.Parent.StellarCoreTable, self)
            self.Parent = nil
        end

        ------ Final command to finish off the fighters death event
        SStructureUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
}


TypeClass = EEB0001

