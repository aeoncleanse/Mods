#****************************************************************************
#**
#**  File     :  /data/units/XRL0302/XRL0302_script.lua
#**  Author(s):  Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Cybran Mobile Bomb Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local CMobileKamikazeBombDeathWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombDeathWeapon


XRL0302 = Class(CWalkingLandUnit) {
    Weapons = {

        DeathWeapon = Class(CMobileKamikazeBombDeathWeapon) {},
        
        Suicide = Class(CMobileKamikazeBombWeapon) {   
			OnFire = function(self)		
				#disable death weapon
				self.unit:SetDeathWeaponEnabled(false)
				CMobileKamikazeBombWeapon.OnFire(self)
			end,
            
            OnGotTarget = function(self)
                CMobileKamikazeBombWeapon.OnGotTarget(self)
                ChangeState( self.unit, self.unit.VisibleState )
            end,
            
			OnLostTarget = function(self)
				CMobileKamikazeBombWeapon.OnLostTarget(self)
				if self.unit:IsIdleState() then
				    ChangeState( self.unit, self.unit.InvisState )
				end
			end,
        },
    },
    
    OnStopBeingBuilt = function(self, builder, layer)
        CWalkingLandUnit.OnStopBeingBuilt(self, builder, layer)
        
        --These start enabled, so before going to InvisState, disabled them.. they'll be reenabled shortly
		self:DisableUnitIntel('Cloak')
		self.Cloaked = false
        ChangeState( self, self.InvisState ) -- If spawned in we want the unit to be invis, normally the unit will immediately start moving
    end,
    
    InvisState = State() {
        Main = function(self)
            self.Cloaked = false
            local bp = self:GetBlueprint()
            if bp.Intel.StealthWaitTime then
                WaitSeconds( bp.Intel.StealthWaitTime )
            end
			self:EnableUnitIntel('Cloak')
			self.Cloaked = true
        end,
        
        OnMotionHorzEventChange = function(self, new, old)
            if new != 'Stopped' then
                ChangeState( self, self.VisibleState )
            end
            CWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
        end,
    },
    
    VisibleState = State() {
        Main = function(self)
            if self.Cloaked then
			    self:DisableUnitIntel('Cloak')
			end
        end,
        
        OnMotionHorzEventChange = function(self, new, old)
            if new == 'Stopped' then
                ChangeState( self, self.InvisState )
            end
            CWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
        end,
    },

	OnProductionPaused = function(self)
        local wep = self:GetWeapon(1)
        wep.OnFire(wep)
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
        CWalkingLandUnit.OnKilled(self, instigator, type, overkillRatio)
		if not instigator and self.DeathWeaponEnabled != false then
			self:GetWeaponByLabel('Suicide'):FireWeapon()
		end
    end,
	
}
TypeClass = XRL0302