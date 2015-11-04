local oldFactoryUnit = FactoryUnit
FactoryUnit = Class(oldFactoryUnit) {

    OnStartBuild = function(self, unitBeingBuilt, order )
        self:ChangeBlinkingLights('Yellow')
        StructureUnit.OnStartBuild(self, unitBeingBuilt, order )
        self.BuildingUnit = true
        if order ~= 'Upgrade' then
            ChangeState(self, self.BuildingState)
            self.BuildingUnit = false
        else
            self:RemoveCommandCap('RULEUCC_Guard')
        end
        
        self.FactoryBuildFailed = false
    end,
    
    OnStopBuild = function(self, unitBeingBuilt, order )
        StructureUnit.OnStopBuild(self, unitBeingBuilt, order )

        if not self.FactoryBuildFailed then
            if not EntityCategoryContains(categories.AIR, unitBeingBuilt) then
                self:RollOffUnit()
            end
            self:StopBuildFx()
            self:ForkThread(self.FinishBuildThread, unitBeingBuilt, order )
        end
       
        if order == 'Upgrade' then
            self:AddCommandCap('RULEUCC_Guard')
        end
        
        self.BuildingUnit = false
    end,

}

local oldAirFactoryUnit = AirFactoryUnit
AirFactoryUnit = Class(oldAirFactoryUnit) {

    OnStartBuild = function(self, unitBeingBuilt, order )
        self:ChangeBlinkingLights('Yellow')
        
        --Force T3 Air Factories To have equal Engineer BuildRate to Land
        if EntityCategoryContains(categories.ENGINEER, unitBeingBuilt) and EntityCategoryContains(categories.TECH3, self) then        
            self:SetBuildRate(90)                    
            self.BuildRateChanged = true
        end
        
        FactoryUnit.OnStartBuild(self, unitBeingBuilt, order )
    end,
    
    OnStopBuild = function(self, unitBeingBuilt, order )
        --Reset BuildRate
        if self.BuildRateChanged == true then
            self:SetBuildRate(self:GetBlueprint().Economy.BuildRate)
            self.BuildRateChanged = false
        end
        FactoryUnit.OnStopBuild(self, unitBeingBuilt, order )        
    end,   
}

local oldSeaFactoryUnit = SeaFactoryUnit
SeaFactoryUnit = Class(oldSeaFactoryUnit) {

    OnStartBuild = function(self, unitBeingBuilt, order )
        self:ChangeBlinkingLights('Yellow')
        
        --Force T2 and T3 Naval Factories To have equal Engineer BuildRates to Land        
        if EntityCategoryContains(categories.ENGINEER, unitBeingBuilt) and EntityCategoryContains(categories.TECH2, self) then        
            self:SetBuildRate(40)                    
            self.BuildRateChanged = true
        elseif EntityCategoryContains(categories.ENGINEER, unitBeingBuilt) and EntityCategoryContains(categories.TECH3, self) then    
            self:SetBuildRate(90)
            self.BuildRateChanged = true
        end               
        FactoryUnit.OnStartBuild(self, unitBeingBuilt, order )
    end,
    
    OnStopBuild = function(self, unitBeingBuilt, order )
        --Reset BuildRate
        if self.BuildRateChanged == true then
            self:SetBuildRate(self:GetBlueprint().Economy.BuildRate)
            self.BuildRateChanged = false
        end        
        FactoryUnit.OnStopBuild(self, unitBeingBuilt, order )
    end,    
    
    RolloffBody = function(self)
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        self:PlayFxRollOff()
        
        --Force the Factory to not wait until unit has left
        WaitSeconds(2.5)
        
        self.MoveCommand = nil
        self:PlayFxRollOffEnd()
        self:SetBusy(false)
        self:SetBlockCommandQueue(false)
        ChangeState(self, self.IdleState)
    end,

    -- Disable the default rocking behavior
    StartRocking = function(self)
    end,

    StopRocking = function(self)
    end,
}

local oldMobileUnit = MobileUnit
 MobileUnit = Class(oldMobileUnit) {
    OnPaused = function(self)
        self:SetBlockCommandQueue(true)
        Unit.OnPaused(self)
    end,

    OnUnpaused = function(self)
        self:SetBlockCommandQueue(false)
        Unit.OnUnpaused(self)
    end,
}