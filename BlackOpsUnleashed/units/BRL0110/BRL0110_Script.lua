#****************************************************************************
#**
#**  File     :  /cdimage/units/XRL0110/XRL0110_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Cybran Mobile Mortar Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CIFGrenadeWeapon = CybranWeaponsFile.CIFGrenadeWeapon
local CMobileKamikazeBombWeapon = import('/lua/cybranweapons.lua').CMobileKamikazeBombWeapon
local CDFLaserHeavyWeapon = CybranWeaponsFile.CDFLaserHeavyWeapon
local CAANanoDartWeapon = CybranWeaponsFile.CAANanoDartWeapon
local EffectUtils = import('/lua/effectutilities.lua')
local CDFParticleCannonWeapon = import('/lua/cybranweapons.lua').CDFParticleCannonWeapon
local Effects = import('/lua/effecttemplates.lua')


BRL0110 = Class(CWalkingLandUnit) {
    DestructionTicks = 400,

    Weapons = {
    	DummyWeapon = Class(CIFGrenadeWeapon) {},
        FlameGun = Class(CIFGrenadeWeapon) {},
        RPG = Class(CAANanoDartWeapon) {},
        LaserGun = Class(CDFParticleCannonWeapon) {},
        GatlingCannon = Class(CDFLaserHeavyWeapon) 
        {
            PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Gat_Muzzle', self.unit:GetArmy(), Effects.WeaponSteam01 )
                self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Gat_Exhaust', self.unit:GetArmy(), Effects.WeaponSteam01 )
                CDFLaserHeavyWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxRackSalvoChargeSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'Gat_Spinner', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(-700)
                end
                CDFLaserHeavyWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
           # PlayFxRackSalvoReloadSequence = function(self)
           #     if self.SpinManip then
           #         self.SpinManip:SetTargetSpeed(-200)
           #     end
           #     self.ExhaustEffects = EffectUtils.CreateBoneEffects( self.unit, 'Gat_Exhaust', self.unit:GetArmy(), Effects.WeaponSteam01 )
           #     CDFLaserHeavyWeapon.PlayFxRackSalvoChargeSequence(self)
           # end,
        },
        
        Suicide = Class(CMobileKamikazeBombWeapon) {        
			OnFire = function(self)			
				#disable death weapon
				self.unit:SetDeathWeaponEnabled(false)
				CMobileKamikazeBombWeapon.OnFire(self)
			end,
		},
		
    },
    
    OnStopBeingBuilt = function(self,builder,layer)
        self:ForkThread(self.WeaponSetup)
        # disables all the weapons first
        self:SetWeaponEnabledByLabel('FlameGun', false)
        self:SetWeaponEnabledByLabel('RPG', false)
        self:SetWeaponEnabledByLabel('GatlingCannon', false)
        self:SetWeaponEnabledByLabel('Suicide', false)
        self:SetWeaponEnabledByLabel('LaserGun', false)
		self.WeaponCheckFlame = false
		self.WeaponCheckRPG = false
		self.WeaponCheckGatling = false
		self.WeaponCheckSuicide = false
		self.WeaponCheckLaser = false
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
    end,
    
    WeaponCheckThread = function(self)
    LOG('*CHECK WEAPONS')	
		if self.WeaponCheckFlame then
			LOG(' flamer wep activated ')
			self:SetWeaponEnabledByLabel('FlameGun', true)
		else
			self:SetWeaponEnabledByLabel('FlameGun', false)
		end
		if self.WeaponCheckRPG then
			LOG(' rpg wep activated ')
			self:SetWeaponEnabledByLabel('RPG', true)
		else
			self:SetWeaponEnabledByLabel('RPG', false)
		end
		if self.WeaponCheckGatling then
		LOG(' gattling wep activated ')
			self:SetWeaponEnabledByLabel('GatlingCannon', true)
		else
			self:SetWeaponEnabledByLabel('GatlingCannon', false)
		end
		if self.WeaponCheckSuicide then
			LOG(' suicide wep activated ')
			self:SetWeaponEnabledByLabel('Suicide', true)
		else
			self:SetWeaponEnabledByLabel('Suicide', false)
		end
		if self.WeaponCheckLaser then
			LOG(' pulse laser wep activated ')
			self:SetWeaponEnabledByLabel('LaserGun', true)
		else
			self:SetWeaponEnabledByLabel('LaserGun', false)
		end
    end,
	
    OnTransportDetach = function(self, attachBone, unit)
        CWalkingLandUnit.OnTransportDetach(self, attachBone, unit)
        LOG('*DETACHING FROM TRANSPORT')	
        self:ForkThread(self.WeaponCheckThread)
    end,
	
	WeaponSetup = function(self)
    	if not self:IsDead() then
    		--Choose a weapon type randomly
	    	local WeaponType = Random(1,4)
			--Show all bones
			self:ShowBone('XRL0110', true)
        	--Create weapon/range handles
        	local dummywep = self:GetWeaponByLabel('DummyWeapon')
        	local maxradius, minradius
        	if WeaponType == 1 then
        		--Flamer
        		LOG("Mithy: Hydra - Flamer")
        		self:HideBone('RPG_Barrel01', true)
        		self:HideBone('RPG_Barrel02', true)
        		self:HideBone('RPG_Muzzle01', true)
        		self:HideBone('RPG_Muzzle02', true)
        		self:HideBone('Gat_Barrel01', true)
        		self:HideBone('Gat_Spinner', true)
        		self:HideBone('Gat_Muzzle', true)
        		self:HideBone('Gat_Exhaust', true)
        		self:HideBone('Suicide', true)
        		self:HideBone('Eye_Laser_Muzzle', true)
        		local wep = self:GetWeaponByLabel('FlameGun')
        		maxradius = wep:GetBlueprint().MaxRadius
        		minradius = wep:GetBlueprint().MinRadius or 0
				self.WeaponCheckFlame = true
				--Flamer speed & agility boost
				local flamerspeed = wep:GetBlueprint().FlamerSpeedMult or 1.2
            	self:SetSpeedMult(flamerspeed)
        		self:SetTurnMult(flamerspeed)
        	elseif WeaponType == 2 then
        		--RPG
        		LOG("Mithy: Hydra - RPG")
        		self:HideBone('Flamer', true)
        		self:HideBone('Flamer_Muzzle', true)
        		self:HideBone('Gat_Barrel01', true)
        		self:HideBone('Gat_Spinner', true)
        		self:HideBone('Gat_Muzzle', true)
        		self:HideBone('Gat_Exhaust', true)
        		self:HideBone('Suicide', true)
        		self:HideBone('Eye_Laser_Muzzle', true)
        		local wep = self:GetWeaponByLabel('RPG')
        		maxradius = wep:GetBlueprint().MaxRadius
        		minradius = wep:GetBlueprint().MinRadius or 0
				self.WeaponCheckRPG = true
        	elseif WeaponType == 3 then
        		--Gatling Pulse Cannon
        		LOG("Mithy: Hydra - Gatling Gun")
        		self:HideBone('Flamer', true)
        		self:HideBone('Flamer_Muzzle', true)
        		self:HideBone('RPG_Barrel01', true)
        		self:HideBone('RPG_Barrel02', true)
        		self:HideBone('RPG_Muzzle01', true)
        		self:HideBone('RPG_Muzzle02', true)
        		self:HideBone('Suicide', true)
        		self:HideBone('Eye_Laser_Muzzle', true)
        		local wep = self:GetWeaponByLabel('GatlingCannon')
        		maxradius = wep:GetBlueprint().MaxRadius
        		minradius = wep:GetBlueprint().MinRadius or 0
				self.WeaponCheckGatling = true
        	elseif WeaponType == 4 then
        		--Particle Laser
        		LOG("Mithy: Hydra - Particle Laser")
        		self:HideBone('RPG_Barrel01', true)
        		self:HideBone('RPG_Barrel02', true)
        		self:HideBone('RPG_Muzzle01', true)
        		self:HideBone('RPG_Muzzle02', true)
        		self:HideBone('Gat_Barrel01', true)
        		self:HideBone('Gat_Spinner', true)
        		self:HideBone('Gat_Muzzle', true)
        		self:HideBone('Gat_Exhaust', true)
        		self:HideBone('Flamer', true)
        		self:HideBone('Flamer_Muzzle', true)
        		self:HideBone('Suicide', true)
        		local wep = self:GetWeaponByLabel('LaserGun')
        		maxradius = wep:GetBlueprint().MaxRadius
        		minradius = wep:GetBlueprint().MinRadius or 0
				self.WeaponCheckLaser = true
        	end
        	LOG("Mithy: Hydra - maxradius: " .. repr(maxradius) .. ", minradius: " .. repr(minradius))
        	--Configure dummy weapon radius, enable main weapon
        	dummywep:ChangeMaxRadius(maxradius)
        	dummywep:ChangeMinRadius(minradius)
            self:WeaponCheckThread()
    	end
	end,
}

TypeClass = BRL0110

