#****************************************************************************
#** 
#**  File     :  /cdimage/units/XSB0003/XSB0003_script.lua 
#**  Author(s):  John Comes, David Tomandl 
#** 
#**  Summary  :  UEF Wall Piece Script 
#** 
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SShieldLandUnit = import('/lua/seraphimunits.lua').SShieldLandUnit


BSB0003 = Class(SShieldLandUnit) {


### File pathing and special paramiters called ###########################

### Setsup parent call backs between drone and parent
Parent = nil,

SetParent = function(self, parent, droneName)
    self.Parent = parent
    self.Drone = droneName
end,

##########################################################################
ShieldEffects = {
       '/effects/emitters/op_seraphim_quantum_jammer_tower_emit.bp',
       #'/effects/emitters/jammer_ambient_01_emit.bp',
       #'/effects/emitters/op_seraphim_quantum_jammer_tower_wire_03_emit.bp',
       #'/effects/emitters/op_seraphim_quantum_jammer_tower_wire_04_emit.bp',
    },
	   OnCreate = function(self, builder, layer)
        SShieldLandUnit.OnCreate(self, builder, layer)
        #self.ShieldEffectsBag = {}
        #if self.ShieldEffectsBag then
        #    for k, v in self.ShieldEffectsBag do
        #        v:Destroy()
        #    end
		#    self.ShieldEffectsBag = {}
		#end
        #for k, v in self.ShieldEffects do
        #    table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ):ScaleEmitter(0.7) )
        #end
    end,
    --Make this unit invulnerable
    OnDamage = function()
    end,
    OnKilled = function(self, instigator, type, overkillRatio)
        SShieldLandUnit.OnKilled(self, instigator, type, overkillRatio)
       # if self.ShieldEffctsBag then
       #     for k,v in self.ShieldEffectsBag do
       #         v:Destroy()
       #     end
       # end
    end,  
    DeathThread = function(self)
        self:Destroy()
    end,
}


TypeClass = BSB0003

