#****************************************************************************
#**
#**  File     :  /cdimage/units/BEL0109/BEL0109_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Tank Hunter/PD tank, initial Tank mode
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local TIFArtilleryWeapon = import('/lua/terranweapons.lua').TIFArtilleryWeapon

BEL0109 = Class(TLandUnit) {
    Weapons = {
       MainGun = Class(TIFArtilleryWeapon) {

			PlayFxWeaponUnpackSequence = function(self)
				--Remove weapon toggle when unit begins unpacking
				self.unit:RemoveToggleCap('RULEUTC_WeaponToggle')
				TIFArtilleryWeapon.PlayFxWeaponUnpackSequence(self)
			end,
			
			PlayFxWeaponPackSequence = function(self)
				TIFArtilleryWeapon.PlayFxWeaponPackSequence(self)
				--Only reinstate after unit is fully finished repacking
				self.unit:AddToggleCap('RULEUTC_WeaponToggle')
			end,

		},
    },
        
    OnScriptBitSet = function(self, bit)
		TLandUnit.OnScriptBitSet(self, bit)
		if bit == 1 then 
			--Remove the toggle when pressed
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			--Spawn turret mode
			self:ForkThread(self.TurretSpawn)
		end
	end,
    
    TurretSpawn = function(self)
       ### Only spawns the Avenger "b" turret only if the Avenger "a" Structure is not dead
       if not self:IsDead() then

           ### Gets the current orientation of the Avenger "A" in the game world
           local myOrientation = self:GetOrientation()

           ### Gets the current position of the Avenger "A" in the game world
           local location = self:GetPosition()

           ### Gets the current health the Avenger "A"
           local health = self:GetHealth()
           local numkills = self:GetStat('KILLS', 0).Value

           ### Creates our Avenger "b" at the Avenger "a" location & direction
           local AvengerB = CreateUnit('bel0109b', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Land')

           ### Passes the health of the Unit "B" to unit "C" and passes vet
           AvengerB:SetHealth(self,health)
		   AvengerB:AddKills(numkills)

           ### Nil's local Avengera
           AvengerB = nil

           ###Avenger "A" removal scripts
           self:Destroy()
       end
   end,

    
}

TypeClass = BEL0109