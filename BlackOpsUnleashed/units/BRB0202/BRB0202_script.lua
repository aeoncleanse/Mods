#****************************************************************************
#**
#**  File     :  /cdimage/units/URB0202/URB0202_script.lua
#**  Author(s):  David Tomandl
#**
#**  Summary  :  Cybran Tier 2 Air Unit Factory Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CAirFactoryUnit = import('/lua/cybranunits.lua').CAirFactoryUnit

BRB0202 = Class(CAirFactoryUnit) {
    --PlatformBone = 'B01',
    --UpgradeRevealArm1 = 'Arm03',
    --UpgradeRevealArm2 = 'Arm06',
    --UpgradeBuilderArm1 = 'Arm03_B02',
    --UpgradeBuilderArm2 = 'Arm04_B02',
	
	OnStopBeingBuilt = function(self)
       if not self:IsDead() then

           ### Gets the current orientation of the Factory "A" in the game world
           local myOrientation = self:GetOrientation()

           ### Gets the current position of the Factory "A" in the game world
           local location = self:GetPosition()

           ### Gets the current health the Factory "A"
           local health = self:GetHealth()

           ### Creates our Factory "B" at the Factory "A" location & direction
           local FactoryB = CreateUnit('urb0202', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Land')

           ### Passes the health of the Unit "A" to unit "B" and passes vet
           FactoryB:SetHealth(self,health)

           ### Nil's local FactoryA
           FactoryB = nil

           ###Factory "A" removal scripts
           self:Destroy()
       end
    end,

}
TypeClass = BRB0202