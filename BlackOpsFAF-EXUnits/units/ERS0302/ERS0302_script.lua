--****************************************************************************
--**
--**  File     :  /cdimage/units/URS0103/URS0103_script.lua
--**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
--**
--**  Summary  :  Cybran Frigate Script
--**
--**  Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local CSeaUnit = import('/lua/cybranunits.lua').CSeaUnit
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local WeaponsFile = import('/mods/BlackOpsFAF-EXUnits/lua/EXBlackOpsweapons.lua')
local CAAAutocannon = CybranWeaponsFile.CAAAutocannon
local CDFProtonCannonWeapon = CybranWeaponsFile.CDFProtonCannonWeapon
local CANNaniteTorpedoWeapon = import('/lua/cybranweapons.lua').CANNaniteTorpedoWeapon
local CIFSmartCharge = import('/lua/cybranweapons.lua').CIFSmartCharge
local CybranAriesBeam = WeaponsFile.CybranAriesBeam
local CAANanoDartWeapon = import('/lua/cybranweapons.lua').CAANanoDartWeapon
local HailfireLauncherWeapon = import('/mods/BlackOpsFAF-EXUnits/lua/EXBlackOpsweapons.lua').HailfireLauncherWeapon
local CAMZapperWeapon02 = CybranWeaponsFile.CAMZapperWeapon02
local EXEffectTemplate = import('/mods/BlackOpsFAF-EXUnits/lua/EXBlackOpsEffectTemplates.lua')

ERS0302 = Class(CSeaUnit) {
    DestructionTicks = 200,

    Weapons = {
        MicrowaveCannon = Class(CybranAriesBeam) {},
        AAMissile = Class(CAANanoDartWeapon) {},
        HailfireRocket = Class(HailfireLauncherWeapon) {},
        TorpedoR = Class(CANNaniteTorpedoWeapon) {},
        TorpedoL = Class(CANNaniteTorpedoWeapon) {},
        Zapper01 = Class(CAMZapperWeapon02) {},
        Zapper02 = Class(CAMZapperWeapon02) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        CSeaUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetWeaponEnabledByLabel('HailfireRocket', false)
        if(self:GetCurrentLayer() == 'Land') then
            self.AT1 = self:ForkThread(self.TransformThread, true)
        end
        --self.Trash:Add(CreateRotator(self, 'Cybran_Radar', 'y', nil, 90, 0, 0))
        --self.Trash:Add(CreateRotator(self, 'Back_Radar', 'y', nil, -360, 0, 0))
        --self.Trash:Add(CreateRotator(self, 'Front_Radar', 'y', nil, -180, 0, 0))
    end,

    OnScriptBitSet = function(self, bit)
        CSeaUnit.OnScriptBitSet(self, bit)
        if bit == 1 then
            self:ForkThread(self.EXOnScriptBitSet)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CSeaUnit.OnScriptBitClear(self, bit)
        if bit == 1 then
            self:ForkThread(self.EXOnScriptBitClear)
        end
    end,

    EXOnScriptBitSet = function(self)
            if(not self.AnimManip2) then
                self.AnimManip2 = CreateAnimator(self)
            end
            self:SetWeaponEnabledByLabel('AAMissile', false)
            self.AnimManip2:PlayAnim(self:GetBlueprint().Display.AnimationHailfireDeploy)
            self.AnimManip2:SetRate(0.5)
            WaitFor(self.AnimManip2)
            self:SetWeaponEnabledByLabel('HailfireRocket', true)
            self:GetWeaponManipulatorByLabel('HailfireRocket'):SetHeadingPitch(self:GetWeaponManipulatorByLabel('AAMissile'):GetHeadingPitch())
            self.Trash:Add(self.AnimManip2)
    end,

    EXOnScriptBitClear = function(self)
            self:SetWeaponEnabledByLabel('HailfireRocket', false)
            self.AnimManip2:PlayAnim(self:GetBlueprint().Display.AnimationHailfireDeploy)
            self.AnimManip2:SetAnimationFraction(1)
            self.AnimManip2:SetRate(-0.5)
            WaitFor(self.AnimManip2)
            self:SetWeaponEnabledByLabel('AAMissile', true)
            self:GetWeaponManipulatorByLabel('AAMissile'):SetHeadingPitch(self:GetWeaponManipulatorByLabel('HailfireRocket'):GetHeadingPitch())
            --self.AnimManip2:Destroy()
    end,

    OnMotionHorzEventChange = function(self, new, old)
        CSeaUnit.OnMotionHorzEventChange(self, new, old)
        if self.Dead then return end
        if(not self.IsWaiting) then
            if(self.Walking) then
                if(old == 'Stopped') then
                    if(self.SwitchAnims) then
                        self.SwitchAnims = false
                        self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationWalk, true):SetRate(self:GetBlueprint().Display.AnimationWalkRate or 1.1)
                    else
                        self.AnimManip:SetRate(1.8)
                    end
                elseif(new == 'Stopped') then
                    self.AnimManip:SetRate(0)
                end
            end
        end
    end,

    OnLayerChange = function(self, new, old)
        CSeaUnit.OnLayerChange(self, new, old)
        if(old != 'None') then
            if(self.AT1) then
                self.AT1:Destroy()
                self.AT1 = nil
            end
            local myBlueprint = self:GetBlueprint()
            if(new == 'Land') then
                self.AT1 = self:ForkThread(self.TransformThread, true)
            elseif(new == 'Water') then
                self.AT1 = self:ForkThread(self.TransformThread, false)
            end
        end
    end,

    TransformThread = function(self, land)
        if(not self.AnimManip) then
            self.AnimManip = CreateAnimator(self)
        end
        local bp = self:GetBlueprint()
        local scale = bp.Display.UniformScale or 1

        if(land) then
            -- Change movement speed to the multiplier in blueprint
            self:SetSpeedMult(bp.Physics.LandSpeedMultiplier)
            self:SetImmobile(true)
            self:SetWeaponEnabledByLabel('TorpedoR', false)
            self:SetWeaponEnabledByLabel('TorpedoL', false)
            --self:SetWeaponEnabledByLabel('Zapper01', false)
            --self:SetWeaponEnabledByLabel('Zapper02', false)
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTransform)
            self.AnimManip:SetRate(0.62)
            self.IsWaiting = true
            WaitFor(self.AnimManip)
            self:SetCollisionShape('Box', bp.CollisionOffsetX or 0,(bp.CollisionOffsetY + (bp.SizeY*1.0)) or 0,bp.CollisionOffsetZ or 0, bp.SizeX * scale, bp.SizeY * scale, bp.SizeZ * scale)
            self.IsWaiting = false
            self:SetImmobile(false)
            self.SwitchAnims = true
            self.Walking = true
            self.Trash:Add(self.AnimManip)
        else
            self:SetImmobile(true)
            -- Revert speed to maximum speed
            self:SetSpeedMult(1)
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTransform)
            self.AnimManip:SetAnimationFraction(1)
            self.AnimManip:SetRate(-0.62)
            self.IsWaiting = true
            WaitFor(self.AnimManip)
            self:SetCollisionShape('Box', bp.CollisionOffsetX or 0,(bp.CollisionOffsetY + (bp.SizeY * 0.5)) or 0,bp.CollisionOffsetZ or 0, bp.SizeX * scale, bp.SizeY * scale, bp.SizeZ * scale)
            self.IsWaiting = false
            self.AnimManip:Destroy()
            self.AnimManip = nil
            self:SetImmobile(false)
            self.Walking = false
            self:SetWeaponEnabledByLabel('TorpedoR', true)
            self:SetWeaponEnabledByLabel('TorpedoL', true)
            --self:SetWeaponEnabledByLabel('Zapper01', true)
            --self:SetWeaponEnabledByLabel('Zapper02', true)
        end
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self.Trash:Destroy()
        self.Trash = TrashBag()
        if(self:GetCurrentLayer() != 'Water') then
            self:GetBlueprint().Display.AnimationDeath = self:GetBlueprint().Display.LandAnimationDeath
        else
            self:GetBlueprint().Display.AnimationDeath = self:GetBlueprint().Display.WaterAnimationDeath
        end
        CSeaUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    DeathThread = function(self, overkillRatio)
        if (self:GetCurrentLayer() != 'Water') then
            self:PlayUnitSound('Destroyed')
            local army = self:GetArmy()
            if self.PlayDestructionEffects then
                self:CreateDestructionEffects(self, overkillRatio)
            end

            -- Create Initial explosion effects
            if(self.ShowUnitDestructionDebris and overkillRatio) then
                if overkillRatio <= 1 then
                    self.CreateUnitDestructionDebris(self, true, true, false)
                elseif overkillRatio <= 2 then
                    self.CreateUnitDestructionDebris(self, true, true, false)
                elseif overkillRatio <= 3 then
                    self.CreateUnitDestructionDebris(self, true, true, true)
                else --VAPORIZED
                    self.CreateUnitDestructionDebris(self, true, true, true)
                end
            end

            WaitSeconds(2)
            if self.PlayDestructionEffects then
                self:CreateDestructionEffects(self, overkillRatio)
            end
            WaitSeconds(1)
            if self.PlayDestructionEffects then
                self:CreateDestructionEffects(self, overkillRatio)
            end
            self:CreateWreckage(0.1)
            self:Destroy()
        else
            CSeaUnit.DeathThread(self, overkillRatio)
        end
    end,

}

TypeClass = ERS0302
