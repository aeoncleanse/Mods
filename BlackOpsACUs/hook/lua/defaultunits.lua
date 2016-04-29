local oldACUUnit = ACUUnit

ACUUnit = Class(oldACUUnit) {
    BuildDisable = function(self)
        while self:IsUnitState('Building') or self:IsUnitState('Enhancing') or self:IsUnitState('Upgrading') or
                self:IsUnitState('Repairing') or self:IsUnitState('Reclaiming') do
            WaitSeconds(0.5)
        end

        for k, v in self.WeaponEnabled do
            if v then
                self:SetWeaponEnabledByLabel(k, true, true)
            end
        end
    end,
    
    -- Store weapon status on upgrade. Ignore default and OC, which are dealt with elsewhere
    SetWeaponEnabledByLabel = function(self, label, enable, lockOut)
        oldACUUnit.SetWeaponEnabledByLabel(self, label, enable)
        
        if label ~= self.rightGunLabel and label ~= 'OverCharge' and label ~= 'AutoOverCharge' and not lockOut then
            self.WeaponEnabled[label] = enable
        end
    end,

    OnStartBuild = function(self, unitBeingBuilt, order)
        oldACUUnit.OnStartBuild(self, unitBeingBuilt, order)

        -- Disable any active upgrade weapons
        local fork = false
        for k, v in self.WeaponEnabled do
            if v then
                self:SetWeaponEnabledByLabel(k, false, true)
                fork = true
            end
        end

        if fork then
            self:ForkThread(self.BuildDisable)
        end
    end,
}