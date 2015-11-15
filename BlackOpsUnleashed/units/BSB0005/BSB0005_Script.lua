--****************************************************************************
--** 
--**  File     :  /cdimage/units/XSB0005/XSB0005_script.lua 
--**  Author(s):  John Comes, David Tomandl 
--** 
--**  Summary  :  UEF Wall Piece Script 
--** 
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local SShieldLandUnit = import('/lua/seraphimunits.lua').SShieldLandUnit
local SeraLambdaFieldRedirector = import('/mods/BlackOpsUnleashed/lua/BlackOpsdefaultantiprojectile.lua').SeraLambdaFieldRedirector
local SeraLambdaFieldDestroyer = import('/mods/BlackOpsUnleashed/lua/BlackOpsdefaultantiprojectile.lua').SeraLambdaFieldDestroyer


BSB0005 = Class(SShieldLandUnit) {


------ File pathing and special paramiters called ------------------------------------------------------

------ Setsup parent call backs between drone and parent
Parent = nil,

SetParent = function(self, parent, droneName)
    self.Parent = parent
    self.Drone = droneName
end,

----------------------------------------------------------------------------------------------------------------------------------------------------
       OnCreate = function(self, builder, layer)
        SShieldLandUnit.OnCreate(self, builder, layer)
        local bp = self:GetBlueprint().Defense.SeraLambdaFieldRedirector01
        --local bp2 = self:GetBlueprint().Defense.SeraLambdaFieldRedirector02
        local bp3 = self:GetBlueprint().Defense.SeraLambdaFieldDestroyer01
        local SeraLambdaFieldRedirector01 = SeraLambdaFieldRedirector {
            Owner = self,
            Radius = bp.Radius,
            AttachBone = bp.AttachBone,
            RedirectRateOfFire = bp.RedirectRateOfFire
        }
        --local SeraLambdaFieldRedirector02 = SeraLambdaFieldRedirector {
        --    Owner = self,
        --    Radius = bp2.Radius,
        --    AttachBone = bp2.AttachBone,
        --    RedirectRateOfFire = bp2.RedirectRateOfFire
        --}
        local SeraLambdaFieldDestroyer01 = SeraLambdaFieldDestroyer {
            Owner = self,
            Radius = bp3.Radius,
            AttachBone = bp3.AttachBone,
            RedirectRateOfFire = bp3.RedirectRateOfFire
        }
        self.Trash:Add(SeraLambdaFieldRedirector01)
        --self.Trash:Add(SeraLambdaFieldRedirector02)
        self.Trash:Add(SeraLambdaFieldDestroyer01)
        self.UnitComplete = true
    end,
    --Make this unit invulnerable
    OnDamage = function()
    end,
    OnKilled = function(self, instigator, type, overkillRatio)
        SShieldLandUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
    DeathThread = function(self)
        self:Destroy()
    end,  
}


TypeClass = BSB0005

