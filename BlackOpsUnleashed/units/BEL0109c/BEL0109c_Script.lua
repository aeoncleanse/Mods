#****************************************************************************
#**
#**  File     :  /cdimage/units/XEL0109c/XEL0109c_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Heavy Artillery Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local TIFArtilleryWeapon = import('/lua/terranweapons.lua').TIFArtilleryWeapon

BEL0109c = Class(TLandUnit) {
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
	
	OnCreate = function(self)
		TLandUnit.OnCreate(self)
		--Remove toggle while unit is animating
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		if not self.AnimationManipulator then
			self.AnimationManipulator = CreateAnimator(self)
			self.Trash:Add(self.AnimationManipulator)
		end
		self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(1.5)
		--Wait for animation to finish before reinstating toggle
		self:ForkThread( function()
			WaitFor(self.AnimationManipulator)
			self:AddToggleCap('RULEUTC_WeaponToggle')
		end )
	end,
		
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

           ### Gets the current orientation of the Avenger "B" in the game world
           local myOrientation = self:GetOrientation()

           ### Gets the current position of the Avenger "C" in the game world
           local location = self:GetPosition()

           ### Gets the current health the Avenger "B"
           local health = self:GetHealth()
           local numkills = self:GetStat('KILLS', 0).Value

           ### Creates our Avenger "B" at the Avenger "V" location & direction
           local AvengerB = CreateUnit('bel0109b', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Land')

           ### Passes the health of the Unit "C" to unit "B"and passes vet
           AvengerB:SetHealth(self,health)
		   AvengerB:AddKills(numkills)

           ### Nil's local Avengera
           AvengerB = nil

           ###Avenger "C" removal scripts
           self:Destroy()
       end
   end,
    
}

TypeClass = BEL0109c