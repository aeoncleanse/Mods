#****************************************************************************
#**
#**  Author(s):  Exavier Macbeth
#**
#**  Summary  :  UEF Disruptor
#**
#****************************************************************************

local TMobileFactoryUnit = import('/lua/terranunits.lua').TMobileFactoryUnit
local WeaponsFile = import('/mods/BlackOpsEXUnits/lua/EXBlackOpsweapons.lua')
local SonicDisruptorWave = WeaponsFile.SonicDisruptorWave
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher

EEL0401 = Class(TMobileFactoryUnit) {
    Weapons = {
        EXDisruptorWave = Class(SonicDisruptorWave) {
            OnCreate = function(self)
                SonicDisruptorWave.OnCreate(self)
				self.Chargeupeffects = {}
            end,
			PlayFxRackSalvoChargeSequence = function(self)
				if self.Chargeupeffects then
					for k, v in self.Chargeupeffects do
						v:Destroy()
					end
					self.Chargeupeffects = {}
				end
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Emitter_Muzzle_01', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_01_emit.bp' ):ScaleEmitter(0.5) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Emitter_Muzzle_02', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_01_emit.bp' ):ScaleEmitter(0.5) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Emitter_Muzzle_01', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_04_emit.bp' ):ScaleEmitter(0.25) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Emitter_Muzzle_02', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_04_emit.bp' ):ScaleEmitter(0.25) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Emitter_Muzzle_01', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_hit_01_emit.bp' ):ScaleEmitter(0.25) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Emitter_Muzzle_02', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_hit_01_emit.bp' ):ScaleEmitter(0.25) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Wave_Muzzle_01', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_03_emit.bp' ):ScaleEmitter(0.5) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Wave_Muzzle_02', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_03_emit.bp' ):ScaleEmitter(0.5) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Wave_Muzzle_03', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_03_emit.bp' ):ScaleEmitter(0.5) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Wave_Muzzle_04', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_03_emit.bp' ):ScaleEmitter(0.5) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Wave_Muzzle_05', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_03_emit.bp' ):ScaleEmitter(0.5) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Wave_Muzzle_06', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_03_emit.bp' ):ScaleEmitter(0.5) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Wave_Muzzle_07', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_03_emit.bp' ):ScaleEmitter(0.5) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Wave_Muzzle_08', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_03_emit.bp' ):ScaleEmitter(0.5) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Wave_Muzzle_09', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_03_emit.bp' ):ScaleEmitter(0.5) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Wave_Muzzle_10', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_03_emit.bp' ):ScaleEmitter(0.5) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Wave_Muzzle_11', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_03_emit.bp' ):ScaleEmitter(0.5) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Wave_Muzzle_12', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_03_emit.bp' ):ScaleEmitter(0.5) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Wave_Muzzle_13', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_03_emit.bp' ):ScaleEmitter(0.5) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Wave_Muzzle_14', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_03_emit.bp' ):ScaleEmitter(0.5) )
				table.insert( self.Chargeupeffects, CreateAttachedEmitter( self.unit, 'Wave_Muzzle_15', self.unit:GetArmy(), '/mods/BlackOpsEXUnits/effects/emitters/exsonicdisruptor_muzzle_03_emit.bp' ):ScaleEmitter(0.5) )

                SonicDisruptorWave.PlayFxRackSalvoChargeSequence(self)
            end,
            PlayFxRackSalvoReloadSequence = function(self)
				if self.Chargeupeffects then
					for k, v in self.Chargeupeffects do
						v:Destroy()
					end
					self.Chargeupeffects = {}
				end
                SonicDisruptorWave.PlayFxRackSalvoChargeSequence(self)
            end,
		},
        HVMTurret = Class(TSAMLauncher) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        TMobileFactoryUnit.OnStopBeingBuilt(self,builder,layer)
        # If created with F2 on Water, then play the transform anim.
        if(self:GetCurrentLayer() == 'Water') then
            self.AT1 = self:ForkThread(self.TransformThread, true)
        end
    end,

    OnMotionHorzEventChange = function(self, new, old)
        TMobileFactoryUnit.OnMotionHorzEventChange(self, new, old)
        if self:IsDead() then return end
        if( not self.IsWaiting ) then
            if( self.Walking ) then
                if( old == 'Stopped' ) then
                    if( self.SwitchAnims ) then
                        self.SwitchAnims = false
                        self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationWalk, true):SetRate(self:GetBlueprint().Display.AnimationWalkRate or 1.1)
                    else
                        self.AnimManip:SetRate(2.8)
                    end
                elseif( new == 'Stopped' ) then
                    self.AnimManip:SetRate(0)
                end
            end
        end
    end,

    OnLayerChange = function(self, new, old)
        TMobileFactoryUnit.OnLayerChange(self, new, old)
        if( old != 'None' ) then
            if( self.AT1 ) then
                self.AT1:Destroy()
                self.AT1 = nil
            end
            local myBlueprint = self:GetBlueprint()
            if( new == 'Water' ) then
                self.AT1 = self:ForkThread(self.TransformThread, true)
            elseif( new == 'Land' ) then
                self.AT1 = self:ForkThread(self.TransformThread, false)
            end
        end
    end,

    TransformThread = function(self, Water)
        if( not self.AnimManip ) then
            self.AnimManip = CreateAnimator(self)
        end
        local bp = self:GetBlueprint()
        local scale = bp.Display.UniformScale or 1

        if( Water ) then
            # Change movement speed to the multiplier in blueprint
            --self:SetSpeedMult(bp.Physics.LandSpeedMultiplier)
            self:SetImmobile(true)
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTransform)
            self.AnimManip:SetRate(0.5)
            self.IsWaiting = true
            WaitFor(self.AnimManip)
            --self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0,(bp.CollisionOffsetY + (bp.SizeY*1.0)) or 0,bp.CollisionOffsetZ or 0, bp.SizeX * scale, bp.SizeY * scale, bp.SizeZ * scale )
            self.IsWaiting = false
            self:SetImmobile(false)
            self.SwitchAnims = true
            self.Walking = true
            self.Trash:Add(self.AnimManip)
        else
            self:SetImmobile(true)
            # Revert speed to maximum speed
            --self:SetSpeedMult(1)
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTransform)
            self.AnimManip:SetAnimationFraction(1)
            self.AnimManip:SetRate(-0.5)
            self.IsWaiting = true
            WaitFor(self.AnimManip)
            --self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0,(bp.CollisionOffsetY + (bp.SizeY * 0.5)) or 0,bp.CollisionOffsetZ or 0, bp.SizeX * scale, bp.SizeY * scale, bp.SizeZ * scale )
            self.IsWaiting = false
            self.AnimManip:Destroy()
            self.AnimManip = nil
            self:SetImmobile(false)
            self.Walking = false
        end
    end,
}

TypeClass = EEL0401