CAirFactoryUnit = Class(AirFactoryUnit) {

    CreateBuildEffects = function( self, unitBeingBuilt, order )
        if not unitBeingBuilt then return end
        WaitSeconds( 0.1 )
        EffectUtil.CreateCybranFactoryBuildEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones, self.BuildEffectsBag )
    end,
    
    FinishBuildThread = function(self, unitBeingBuilt, order )
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        local bp = self:GetBlueprint()
        local bpAnim = bp.Display.AnimationFinishBuildLand
        if bpAnim and EntityCategoryContains(categories.LAND, unitBeingBuilt) then
            if EntityCategoryContains(categories.TECH2, self) or EntityCategoryContains(categories.TECH3, self) then
                self.RollOffAnim = CreateAnimator(self):PlayAnim(bpAnim):SetRate(6) --Increase the Rate further for T2 and T3
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
            if EntityCategoryContains(categories.TECH2, self) or EntityCategoryContains(categories.TECH3, self) then
                self.RollOffAnim:SetRate(-6)    --Increase the Rate further for T2            
            else
                self.RollOffAnim:SetRate(-3)    --Increase the Rate        
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
        
        --Force the Factory to not wait until unit has left
        WaitSeconds(1.2)
        
        self.MoveCommand = nil
        self:PlayFxRollOffEnd()
        self:SetBusy(false)
        self:SetBlockCommandQueue(false)
        ChangeState(self, self.IdleState)
    end,
    
    StartBuildFx = function(self, unitBeingBuilt)
        if not unitBeingBuilt then return end
        
        # Start build process
        if not self.BuildAnimManip then
            self.BuildAnimManip = CreateAnimator(self)
            self.BuildAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationBuild, true):SetRate(0)
            self.Trash:Add(self.BuildAnimManip)
        end
        self.BuildAnimManip:SetRate(1)
    end,
    
    StopBuildFx = function(self)
        if self.BuildAnimManip then
            self.BuildAnimManip:SetRate(0)
        end
    end,
    
    OnPaused = function(self)
        AirFactoryUnit.OnPaused(self)
        self:StopBuildFx()
    end,

    OnUnpaused = function(self)
        AirFactoryUnit.OnUnpaused(self)
        if self:IsUnitState('Building') then
            self:StartBuildFx(self:GetFocusUnit())
        end
    end,
}   
