--****************************************************************************
--**
--**  File     :  /cdimage/units/DRL0204/DRL0204_script.lua
--**  Author(s):  Dru Staltman, Eric Williamson, Gordon Duclos
--**
--**  Summary  :  Cybran Rocket Bot Script
--**
--**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit
local CybranWeaponsFile = import('/mods/BlackOpsFAF-EXUnits/lua/EXBlackOpsweapons.lua')
local CybranShadowSplitterBeam = CybranWeaponsFile.CybranShadowSplitterBeam
local EffectUtil = import('/lua/EffectUtilities.lua')

ERL0301 = Class(CWalkingLandUnit) {
    Weapons = {
        MainGun = Class(CybranShadowSplitterBeam) {
            OnWeaponFired = function(self)
                if self.unit:IsIntelEnabled('Cloak') then
                    self:ForkThread(self.DecloakForTimeout)
                end
            end,

            DecloakForTimeout = function(self)
                self.unit:DisableUnitIntel('Cloak')
                WaitSeconds(self.unit:GetBlueprint().Intel.RecloakAfterFiringDelay or 10)
                self.unit:EnableUnitIntel('Cloak')
            end,
        },
    },

    OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        --self:SetConsumptionPerSecondEnergy(0)
        --self:EnableUnitIntel('Cloak')
        --self:EnableUnitIntel('RadarStealth')
        --self:SetMaintenanceConsumptionInactive()
        self.IntelEffectsBag = {}
        --self:ForkThread(self.OnScriptBitClear)
    end,

    OnScriptBitSet = function(self, bit)
        if bit == 8 then -- cloak toggle
            self:StopUnitAmbientSound('ActiveLoop')
            self:SetMaintenanceConsumptionInactive()
            self:DisableUnitIntel('Cloak')
            self:DisableUnitIntel('RadarStealth')
        end
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 8 then -- cloak toggle
            self:PlayUnitAmbientSound('ActiveLoop')
            self:SetMaintenanceConsumptionActive()
            self:EnableUnitIntel('Cloak')
            self:EnableUnitIntel('RadarStealth')
        end
    end,

    IntelEffects = {
        Cloak = {
            {
                Bones = {
                    'ERL302',
                },
                Scale = 2.0,
                Type = 'Cloak01',
            },
        },
        Field = {
            {
                Bones = {
                    'ERL302',
                },
                Scale = 1.6,
                Type = 'Cloak01',
            },
        },
    },

    OnIntelEnabled = function(self)
        CWalkingLandUnit.OnIntelEnabled(self)
        if self:IsIntelEnabled('Cloak') then
            self:SetMaintenanceConsumptionActive()
            if not self.IntelEffectsBag then
                self.IntelEffectsBag = {}
                self.CreateTerrainTypeEffects(self, self.IntelEffects.Cloak, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag)
            end
        end
    end,

    OnIntelDisabled = function(self)
        CWalkingLandUnit.OnIntelDisabled(self)
        if self.IntelEffectsBag then
            EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
            self.IntelEffectsBag = nil
        end
        if not self:IsIntelEnabled('Cloak') then
            self:SetMaintenanceConsumptionInactive()
        end
    end,

}
TypeClass = ERL0301
