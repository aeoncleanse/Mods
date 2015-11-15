#****************************************************************************
#**
#**  File     :  /cdimage/units/XEL0109b/XEL0109b_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Tank Hunter/PD tank, PD mode
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/terranunits.lua').TLandUnit
local TIFArtilleryWeapon = import('/lua/terranweapons.lua').TIFArtilleryWeapon

BEL0109b = Class(TLandUnit) {
    Weapons = {
		MainGun = Class(TIFArtilleryWeapon) {},
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
			--Spawn tank mode
			self:ForkThread(self.TankSpawn)
		end
	end,
    
    TankSpawn = function(self)
       ### Only spawns the Avenger "C" turret only if the Avenger "B" Structure is not dead
       if not self:IsDead() then

           ### Gets the current orientation of the Avenger "B" in the game world
           local myOrientation = self:GetOrientation()

           ### Gets the current position of the Avenger "B" in the game world
           local location = self:GetPosition()

           ### Gets the current health the Avenger "B"
           local health = self:GetHealth()
           local numkills = self:GetStat('KILLS', 0).Value

           ### Creates our Avenger "C" at the Avenger "B" location & direction
           local AvengerC = CreateUnit('bel0109c', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Land')

           ### Passes the health of the Unit "B" to unit "C"and passes vet
           AvengerC:SetHealth(self,health)
		   AvengerC:AddKills(numkills)

           ### Nil's local AvengerB
           AvengerC = nil
           

           ###Avenger "B" removal scripts
           self:Destroy()
       end
   end,

    
}

TypeClass = BEL0109b