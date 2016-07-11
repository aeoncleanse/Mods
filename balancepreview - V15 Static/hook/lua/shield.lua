local oldShield = Shield
Shield = Class(oldShield) {

     ApplyDamage = function(self, instigator, amount, vector, dmgType, doOverspill)
         if self.Owner != instigator then
 
            if EntityCategoryContains(categories.COMMAND, self.Owner) then
                local aiBrain = self.Owner:GetAIBrain()
                if aiBrain then
                    aiBrain:OnPlayCommanderUnderAttackVO()
                end
            end
        
             local absorbed = self:OnGetDamageAbsorption(instigator, amount, dmgType)
 
             if self.PassOverkillDamage then
                 local overkill = self:GetOverkill(instigator,amount,dmgType)    
                 if self.Owner and IsUnit(self.Owner) and overkill > 0 then
                     self.Owner:DoTakeDamage(instigator, overkill, vector, dmgType)
                 end
             end
 
             self:AdjustHealth(instigator, -absorbed)
             self:UpdateShieldRatio(-1)
             ForkThread(self.CreateImpactEffect, self, vector)
             if self.RegenThread then
                 KillThread(self.RegenThread)
                 self.RegenThread = nil
             end
             if self:GetHealth() <= 0 then
                 ChangeState(self, self.DamageRechargeState)
             elseif self.OffHealth < 0 then
                 if self.RegenRate > 0 then
                     self.RegenThread = ForkThread(self.RegenStartThread, self)
                     self.Owner.Trash:Add(self.RegenThread)
                 end
             else
                 self:UpdateShieldRatio(0)
             end		
         end	
         -- Only do overspill on events where we have an instigator. 
         -- "Force" damage events from stratbombs are one example
         -- where we don't.
         if doOverspill and IsEntity(instigator) then
             Overspill.DoOverspill(self, instigator, amount, dmgType, self.SpillOverDmgMod)
         end
     end,

}