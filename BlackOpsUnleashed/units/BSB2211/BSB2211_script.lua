-----------------------------------------------------------------
-- File     :  /cdimage/units/XSB2210/XSB2210_script.lua 
-- Author(s):  John Comes, David Tomandl
-- Summary  :  UEF Wall Piece Script
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local SeraMineExplosion = import('/mods/BlackOpsUnleashed/lua/BlackOpsWeapons.lua').SeraMineExplosion
local SeraMineDeathExplosion = import('/mods/BlackOpsUnleashed/lua/BlackOpsWeapons.lua').SeraMineDeathExplosion

BSB2211 = Class(TStructureUnit) {
    Weapons = {
        DeathWeapon = Class(SeraMineDeathExplosion) {},
        Suicide = Class(SeraMineExplosion) {        
            OnFire = function(self)
                self.unit:SetDeathWeaponEnabled(false)
                SeraMineExplosion.OnFire(self)
            end,
        },
    },
    
    OnCreate = function(self,builder,layer)
        TStructureUnit.OnCreate(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
        self:ForkThread(self.LifeThread)
    end,
    
    LifeThread = function(self)
        WaitSeconds(300)
        self:Destroy()
    end,
}

TypeClass = BSB2211
