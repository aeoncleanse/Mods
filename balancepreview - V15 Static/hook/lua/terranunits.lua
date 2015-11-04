TAirFactoryUnit = Class(AirFactoryUnit) {
    
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        WaitSeconds( 0.1 )
        for k, v in self:GetBlueprint().General.BuildBones.BuildEffectBones do
            self.BuildEffectsBag:Add( CreateAttachedEmitter( self, v, self:GetArmy(), '/effects/emitters/flashing_blue_glow_01_emit.bp' ) )         
            self.BuildEffectsBag:Add( self:ForkThread( EffectUtil.CreateDefaultBuildBeams, unitBeingBuilt, {v}, self.BuildEffectsBag ) )
        end
    end,
   
    FinishBuildThread = function(self, unitBeingBuilt, order )
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        local bp = self:GetBlueprint()
        local bpAnim = bp.Display.AnimationFinishBuildLand
        if bpAnim and EntityCategoryContains(categories.LAND, unitBeingBuilt) then
            if EntityCategoryContains(categories.TECH3, self) then
                self.RollOffAnim = CreateAnimator(self):PlayAnim(bpAnim):SetRate(5) --Increase the Rate further for T3            
            else
                self.RollOffAnim = CreateAnimator(self):PlayAnim(bpAnim):SetRate(3) --Increase the Rate
            end
            self.Trash:Add(self.RollOffAnim)
            WaitTicks(1)
            WaitFor(self.RollOffAnim)
        end
        if unitBeingBuilt and not unitBeingBuilt:IsDead() then
            unitBeingBuilt:DetachFrom(true)
        end
        self:DetachAll(bp.Display.BuildAttachBone or 0)
        self:DestroyBuildRotator()
        if order != 'Upgrade' then
            ChangeState(self, self.RollingOffState)
        else
            self:SetBusy(false)
            self:SetBlockCommandQueue(false)
        end
    end,
   
    PlayFxRollOffEnd = function(self)
        if self.RollOffAnim then        
            if EntityCategoryContains(categories.TECH3, self) then
                self.RollOffAnim:SetRate(-5) --Increase the Rate further for T3            
            else
                self.RollOffAnim:SetRate(-3) --Increase the Rate
            end        
            WaitFor(self.RollOffAnim)
            self.RollOffAnim:Destroy()
            self.RollOffAnim = nil
        end
    end,    

    RolloffBody = function(self)
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        self:PlayFxRollOff()
        
        --Wait until unit has left the factory
        if not EntityCategoryContains(categories.TECH3, self) then
            while not self.UnitBeingBuilt:IsDead() and self.MoveCommand and not IsCommandDone(self.MoveCommand) do
                WaitSeconds(0.1)                --Decrease the check interval (0.5)
            end
        else 
            WaitSeconds(1.6)                    --Force the platform up early for the T3 Factory (Creates visual clipping)
        end
        
        self.MoveCommand = nil
        self:PlayFxRollOffEnd()
        self:SetBusy(false)
        self:SetBlockCommandQueue(false)
        ChangeState(self, self.IdleState)
    end,   
   
    OnPaused = function(self)
        AirFactoryUnit.OnPaused(self)
        self:StopArmsMoving()
    end,
    
    OnUnpaused = function(self)
        AirFactoryUnit.OnUnpaused(self)
        if self:GetNumBuildOrders(categories.ALLUNITS) > 0 and not self:IsUnitState('Upgrading') then
            self:StartArmsMoving()
        end
    end,

    OnStartBuild = function(self, unitBeingBuilt, order )
        AirFactoryUnit.OnStartBuild(self, unitBeingBuilt, order )
        if order != 'Upgrade' then
            self:StartArmsMoving()
        end
    end,
   
    OnStopBuild = function(self, unitBuilding)
        AirFactoryUnit.OnStopBuild(self, unitBuilding)
        self:StopArmsMoving()
    end,

    OnFailedToBuild = function(self)
        AirFactoryUnit.OnFailedToBuild(self)
        self:StopArmsMoving()
    end,
   
    StartArmsMoving = function(self)
        self.ArmsThread = self:ForkThread(self.MovingArmsThread)
    end,

    MovingArmsThread = function(self)
    end,
    
    StopArmsMoving = function(self)
        if self.ArmsThread then
            KillThread(self.ArmsThread)
            self.ArmsThread = nil
        end
    end,
}
