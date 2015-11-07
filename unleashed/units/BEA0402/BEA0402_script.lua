#****************************************************************************
#**
#**  File     :  /cdimage/units/BEA0402/BEA0402_script.lua
#**  Author(s):  John Comes, David Tomandl, Gordon Duclos
#**
#**  Summary  :  UEF Mobile Factory Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

# This unit needs to not be allowed to build while underwater
# Additionally, if it goes underwater while building it needs to cancel the
#   current order

local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local TAAFlakArtilleryCannon = WeaponsFile.TAAFlakArtilleryCannon
local RailGunWeapon02 = import('/lua/BlackOpsweapons.lua').RailGunWeapon02
local CitadelHVMWeapon = import('/lua/BlackOpsweapons.lua').CitadelHVMWeapon
local CitadelPlasmaGatlingCannonWeapon = import('/lua/BlackOpsweapons.lua').CitadelPlasmaGatlingCannonWeapon


local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local util = import('/lua/utilities.lua')

BEA0402 = Class(TAirUnit) {
    Weapons = {
		MainTurret01 = Class(RailGunWeapon02) {},
		MainTurret02 = Class(RailGunWeapon02) {},
        HVMTurret01 = Class(CitadelHVMWeapon) {},
        HVMTurret02 = Class(CitadelHVMWeapon) {},
        HVMTurret03 = Class(CitadelHVMWeapon) {},
        HVMTurret04 = Class(CitadelHVMWeapon) {},
        AAAFlak01 = Class(TAAFlakArtilleryCannon) {},
        AAAFlak02 = Class(TAAFlakArtilleryCannon) {},
        AAAFlak03 = Class(TAAFlakArtilleryCannon) {},
        AAAFlak04 = Class(TAAFlakArtilleryCannon) {},
        GattlerTurret01 = Class(CitadelPlasmaGatlingCannonWeapon) 
        {       
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
				if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Gat_Muzzle_2', self.unit:GetArmy(), Effects.WeaponSteam01 )
                CitadelPlasmaGatlingCannonWeapon.PlayFxWeaponPackSequence(self)
            end,

        
            PlayFxWeaponUnpackSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'Gat_Rotator_2', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                CitadelPlasmaGatlingCannonWeapon.PlayFxWeaponUnpackSequence(self)
            end,
            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
				if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(-200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Gat_Muzzle_2', self.unit:GetArmy(), Effects.WeaponSteam01 )
                CitadelPlasmaGatlingCannonWeapon.PlayFxRackSalvoReloadSequence(self)
            end,    
        },
		GattlerTurret02 = Class(CitadelPlasmaGatlingCannonWeapon) 
        {       
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
				if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Gat_Muzzle_1', self.unit:GetArmy(), Effects.WeaponSteam01 )
                CitadelPlasmaGatlingCannonWeapon.PlayFxWeaponPackSequence(self)
            end,

        
            PlayFxWeaponUnpackSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'Gat_Rotator_1', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(500)
                end
                CitadelPlasmaGatlingCannonWeapon.PlayFxWeaponUnpackSequence(self)
            end,
            
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
				if self.SpinManip2 then
                    self.SpinManip2:SetTargetSpeed(-200)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Gat_Muzzle_1', self.unit:GetArmy(), Effects.WeaponSteam01 )
                CitadelPlasmaGatlingCannonWeapon.PlayFxRackSalvoReloadSequence(self)
            end,    
        },
    },
    DestroyNoFallRandomChance = 1.1,

    FxDamageScale = 2.5,
    
    OnStopBeingBuilt = function(self,builder,layer)
		self.AirPadTable = {}
		--self:ForkThread(self.AirPad)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
    end,
    
    --[[
    AirPad = function(self)
		### Are we dead yet, if not then wait 0.5 second
		if not self:IsDead() then
			WaitSeconds(0.5)
			### Are we dead yet, if not spawn AirPad
			if not self:IsDead() then
				self:HideBone('AirPad01', true)
				self:HideBone('AirPad02', true)
				self:HideBone('AirPad03', true)
				self:HideBone('AirPad04', true)
				self:HideBone('AirPad05', true)
				self:HideBone('AirPad06', true)
				self:HideBone('AirPad07', true)
				self:HideBone('AirPad08', true)

				### Gets the platforms current orientation
				local platOrient = self:GetOrientation()
            
				### Gets the current position of the platform in the game world
				local location01 = self:GetPosition('Pad01')
				local location02 = self:GetPosition('Pad02')
				local location03 = self:GetPosition('Pad03')
				local location04 = self:GetPosition('Pad04')
				local location05 = self:GetPosition('Pad05')
				local location06 = self:GetPosition('Pad06')
				local location07 = self:GetPosition('Pad07')
				local location08 = self:GetPosition('Pad08')

				### Creates our AirPad over the platform with a ranomly generated Orientation
				local AirPad01 = CreateUnit('beb0001', self:GetArmy(), location01[1], location01[2], location01[3], platOrient[1], platOrient[2], platOrient[3], platOrient[4], 'Air') 
				local AirPad02 = CreateUnit('beb0001', self:GetArmy(), location02[1], location02[2], location02[3], platOrient[1], platOrient[2], platOrient[3], platOrient[4], 'Air') 
				local AirPad03 = CreateUnit('beb0001', self:GetArmy(), location03[1], location03[2], location03[3], platOrient[1], platOrient[2], platOrient[3], platOrient[4], 'Air')
				local AirPad04 = CreateUnit('beb0001', self:GetArmy(), location04[1], location04[2], location04[3], platOrient[1], platOrient[2], platOrient[3], platOrient[4], 'Air')
				local AirPad05 = CreateUnit('beb0001', self:GetArmy(), location05[1], location05[2], location05[3], platOrient[1], platOrient[2], platOrient[3], platOrient[4], 'Air')
				local AirPad06 = CreateUnit('beb0001', self:GetArmy(), location06[1], location06[2], location06[3], platOrient[1], platOrient[2], platOrient[3], platOrient[4], 'Air')
				local AirPad07 = CreateUnit('beb0001', self:GetArmy(), location07[1], location07[2], location07[3], platOrient[1], platOrient[2], platOrient[3], platOrient[4], 'Air')
				local AirPad08 = CreateUnit('beb0001', self:GetArmy(), location08[1], location08[2], location08[3], platOrient[1], platOrient[2], platOrient[3], platOrient[4], 'Air')
            
				### Adds the newly created AirPad to the parent platforms AirPad table
				table.insert (self.AirPadTable, AirPad01)
				table.insert (self.AirPadTable, AirPad02)
				table.insert (self.AirPadTable, AirPad03)
				table.insert (self.AirPadTable, AirPad04)
				table.insert (self.AirPadTable, AirPad05)
				table.insert (self.AirPadTable, AirPad06)
				table.insert (self.AirPadTable, AirPad07)
				table.insert (self.AirPadTable, AirPad08)
            
				### Sets the platform unit as the AirPad parent
				AirPad01:SetParent(self, 'bea0402')
				AirPad01:SetCreator(self)  
				
				AirPad02:SetParent(self, 'bea0402')
				AirPad02:SetCreator(self)  
			
				AirPad03:SetParent(self, 'bea0402')
				AirPad03:SetCreator(self)  
			
				AirPad04:SetParent(self, 'bea0402')
				AirPad04:SetCreator(self)  
			
				AirPad05:SetParent(self, 'bea0402')
				AirPad05:SetCreator(self)  
			
				AirPad06:SetParent(self, 'bea0402')
				AirPad06:SetCreator(self)  
			
				AirPad07:SetParent(self, 'bea0402')
				AirPad07:SetCreator(self)  
			
				AirPad08:SetParent(self, 'bea0402')
				AirPad08:SetCreator(self)  
			
			
				AirPad01:AttachTo(self, 'Pad01') 
				AirPad02:AttachTo(self, 'Pad02') 
				AirPad03:AttachTo(self, 'Pad03') 
				AirPad04:AttachTo(self, 'Pad04') 
				AirPad05:AttachTo(self, 'Pad05') 
				AirPad06:AttachTo(self, 'Pad06') 
				AirPad07:AttachTo(self, 'Pad07') 
				AirPad08:AttachTo(self, 'Pad08') 
			
				###AirPad clean up scripts
				self.Trash:Add(AirPad01)
				self.Trash:Add(AirPad02)
				self.Trash:Add(AirPad03)
				self.Trash:Add(AirPad04)
				self.Trash:Add(AirPad05)
				self.Trash:Add(AirPad06)
				self.Trash:Add(AirPad07)
				self.Trash:Add(AirPad08)
			end
		end 
	end,

	--Cleans up threads and drones on death
	OnKilled = function(self, instigator, type, overkillRatio)
		--self:ShowBone('AirPad01', true)
		---self:ShowBone('AirPad02', true)
		--self:ShowBone('AirPad03', true)
		--self:ShowBone('AirPad04', true)
		--self:ShowBone('AirPad05', true)
		--self:ShowBone('AirPad06', true)
		--self:ShowBone('AirPad07', true)
		--self:ShowBone('AirPad08', true)
		--if table.getn({self.AirPadTable}) > 0 then
        --for k, v in self.AirPadTable do 
        --    IssueClearCommands({self.AirPadTable[k]}) 
        ---    IssueKillSelf({self.AirPadTable[k]})
        --end
    end
        TAirUnit.OnKilled(self, instigator, type, overkillRatio)
	end,
]]--
    
}

TypeClass = BEA0402