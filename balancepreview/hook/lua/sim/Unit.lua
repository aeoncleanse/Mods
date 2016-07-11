local oldUnit = Unit
Unit = Class(oldUnit) {

    OnDamage = function(self, instigator, amount, vector, damageType)
 
        -- Revoke transport protection for shielded transports when impacted by nuclear weaponry
        if EntityCategoryContains(categories.NUKE, instigator) and self.transportProtected == true then
            self.MyShield:RevokeTransportProtection()
        end
 
        if self.CanTakeDamage then
            self:DoOnDamagedCallbacks(instigator)
 
            -- Pass damage to an active personal shield, as personal shields no longer have collisions
            if self:GetShieldType() == 'Personal' and self:ShieldIsOn() then
                self.MyShield:ApplyDamage(instigator, amount, vector, damageType)
            else
                if damageType ~= 'AntiShield' then
                    self:DoTakeDamage(instigator, amount, vector, damageType)
                end
            end
        end
    end,

    OnLayerChange = function(self, new, old)
        for i = 1, self:GetWeaponCount() do
            self:GetWeapon(i):SetValidTargetsForCurrentLayer(new)
        end

        if old == 'Seabed' and new == 'Land' then
            self:EnableIntel('Vision')
            self:DisableIntel('WaterVision')
        elseif old == 'Land' and new == 'Seabed' then
            self:EnableIntel('WaterVision')
        end

        if( new == 'Land' ) then
            self:PlayUnitSound('TransitionLand')
            self:PlayUnitAmbientSound('AmbientMoveLand')
        elseif(( new == 'Water' ) or ( new == 'Seabed' )) then
            self:PlayUnitSound('TransitionWater')
            self:PlayUnitAmbientSound('AmbientMoveWater')
        elseif ( new == 'Sub' ) then
            self:PlayUnitAmbientSound('AmbientMoveSub')
        end

        local bpTable = self:GetBlueprint().Display.MovementEffects
        if not self.Footfalls and bpTable[new].Footfall then
            self.Footfalls = self:CreateFootFallManipulators( bpTable[new].Footfall )
        end
        
        -- Force hover units to slow down
        if EntityCategoryContains(categories.HOVER, self) and not EntityCategoryContains(categories.ENGINEER, self) then
            WARN("Default speed is...")
            LOG(self:GetBlueprint().Physics.MaxSpeed)
            if old == 'Land' and new == 'Water' then
                self:SetSpeedMult(0.9)
                WARN("In water, speed mult set, velocity now...")
                LOG(self:GetVelocity())
                LOG(repr(self:GetVelocity()))
            elseif old == 'Water' and new == 'Land' then
                self:SetSpeedMult(1)
            end
        end                
        
        self:CreateLayerChangeEffects( new, old )
    end,

    AddBuff = function(self, buffTable, PosEntity)
        local bt = buffTable.BuffType
        if not bt then
            error('*ERROR: Tried to add a unit buff in unit.lua but got no buff table.  Wierd.', 1)
            return
        end

        --When adding debuffs we have to make sure that we check for permissions
        local allow = categories.ALLUNITS
        if buffTable.TargetAllow then
            allow = ParseEntityCategory(buffTable.TargetAllow)
        end
        local disallow
        if buffTable.TargetDisallow then
            disallow = ParseEntityCategory(buffTable.TargetDisallow)
        end

        if bt == 'STUN' then
            if buffTable.Radius and buffTable.Radius > 0 then
                --If the radius is bigger than 0 then we will use the unit as the center of the stun blast
                --and collect all targets from that point
                local targets = {}
                if PosEntity then
                    targets = utilities.GetEnemyUnitsInSphere(self, PosEntity, buffTable.Radius)
                else
                    targets = utilities.GetEnemyUnitsInSphere(self, self:GetPosition(), buffTable.Radius)
                end
                if not targets then
                    return
                end
                for k, v in targets do
                    if EntityCategoryContains(allow, v) and (not disallow or not EntityCategoryContains(disallow, v)) then
                        v:SetStunned(buffTable.Duration or 1)
                    end
                end
            else
                --The buff will be applied to the unit only
                if EntityCategoryContains(allow, self) and (not disallow or not EntityCategoryContains(disallow, self)) then
                    self:SetStunned(buffTable.Duration or 1)
                end
            end
            
        -- This buff allows Aeon's Chrono ACU upgrade to not stun allied units
        elseif bt == 'CHRONOSTUN' then
            if not buffTable.Radius and not buffTable.Radius > 0 then
                return
            end
            
            -- GetTrueEnemiesInSphere is a new utility which excludes allied units
            local targets = utilities.GetTrueEnemiesInSphere(self, self:GetPosition(), buffTable.Radius)
            
            if not targets then
                return
            end
            
            for k, v in targets do
                if EntityCategoryContains(allow, v) and (not disallow or not EntityCategoryContains(disallow, v)) then
                    v:SetStunned(buffTable.Duration or 1)
                end
            end
        elseif bt == 'MAXHEALTH' then
            self:SetMaxHealth(self:GetMaxHealth() + (buffTable.Value or 0))
        elseif bt == 'HEALTH' then
            self:SetHealth(self, self:GetHealth() + (buffTable.Value or 0))
        elseif bt == 'SPEEDMULT' then
            self:SetSpeedMult(buffTable.Value or 0)
        elseif bt == 'MAXFUEL' then
            self:SetFuelUseTime(buffTable.Value or 0)
        elseif bt == 'FUELRATIO' then
            self:SetFuelRatio(buffTable.Value or 0)
        elseif bt == 'HEALTHREGENRATE' then
            self:SetRegenRate(buffTable.Value or 0)
        end
    end,
    
    SetVeteranLevel = function(self, level)
        local old = self.VeteranLevel
        self.VeteranLevel = level

        --Apply default veterancy buffs
        local buffTypes = { 'Regen', 'Health', }
        local notUsingMaxHealth = self:GetBlueprint().MaxHealthNotAffectHealth
        if notUsingMaxHealth then
            buffTypes = { 'Regen', 'MaxHealth', }
        end

        if EntityCategoryContains(categories.EXPERIMENTAL, self) then
            buffTypes = {'MaxHealthExp', 'ExpRegen', 'ExpRegenBoost'}
        end

        for k,bType in buffTypes do
            if bType == 'ExpRegenBoost' then
                Buff.ApplyBuff( self, 'Veterancy' .. bType)
            else
                Buff.ApplyBuff( self, 'Veterancy' .. bType .. level )
            end
        end

        --Get any overriding buffs if they exist
        local bp = self:GetBlueprint().Buffs
        --Check for unit buffs
        if bp and not EntityCategoryContains(categories.EXPERIMENTAL, self) then
            for bType,bData in bp do
                for lName,lValue in bData do
                    if lName == 'Level'..level then
                        --Generate a buff based on the data passed in
                        local buffName = self:CreateVeterancyBuff( lName, lValue, bType )
                        if buffName then
                            Buff.ApplyBuff( self, buffName )
                        end
                    end
                end
            end
        end
        self:GetAIBrain():OnBrainUnitVeterancyLevel(self, level)
        self:DoUnitCallbacks('OnVeteran')
    end,    
}
