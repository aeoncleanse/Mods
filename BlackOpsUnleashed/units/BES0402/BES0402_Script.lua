--****************************************************************************
--**
--**  File     :  /cdimage/units/XES0402/XES0402_script.lua
--**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
--**
--**  Summary  :  UEF Battleship Script
--**
--**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local TSeaUnit = import('/lua/terranunits.lua').TSeaUnit
local WeaponsFile = import('/lua/terranweapons.lua')
local WeaponsFile2 = import('/lua/BlackOpsweapons.lua')
local TAALinkedRailgun = WeaponsFile.TAALinkedRailgun
local TAMPhalanxWeapon = WeaponsFile.TAMPhalanxWeapon
local ZCannonWeapon = WeaponsFile2.ZCannonWeapon
local TDFShipGaussCannonWeapon = WeaponsFile.TDFShipGaussCannonWeapon
local TIFCruiseMissileLauncher = WeaponsFile.TIFCruiseMissileLauncher

local EffectUtils = import('/lua/effectutilities.lua')
local BlackOpsEffectTemplate = import('/lua/BlackOpsEffectTemplates.lua')

BES0402 = Class(TSeaUnit) {
    SteamEffects = BlackOpsEffectTemplate.WeaponSteam02,

    Weapons = {
        FrontAMCCannon01 = Class(ZCannonWeapon) {
            PlayFxRackSalvoReloadSequence = function(self)
                for i = 1, 40 do
                local fxname
                    if i < 10 then
                        fxname = 'AMC1Steam0' .. i
                    else
                        fxname = 'AMC1Steam' .. i
                    end
                    for k, v in self.unit.SteamEffects do
                        table.insert( self.unit.SteamEffectsBag, CreateAttachedEmitter( self.unit, fxname, self.unit:GetArmy(), v ))
                    end
                end
                ZCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
        FrontAMCCannon02 = Class(ZCannonWeapon) {
            PlayFxRackSalvoReloadSequence = function(self)
                for i = 1, 40 do
                local fxname
                    if i < 10 then
                        fxname = 'AMC2Steam0' .. i
                    else
                        fxname = 'AMC2Steam' .. i
                    end
                    for k, v in self.unit.SteamEffects do
                        table.insert( self.unit.SteamEffectsBag, CreateAttachedEmitter( self.unit, fxname, self.unit:GetArmy(), v ))
                    end
                end
                ZCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
        BackAMCCannon = Class(ZCannonWeapon) {
            PlayFxRackSalvoReloadSequence = function(self)
                for i = 1, 40 do
                local fxname
                    if i < 10 then
                        fxname = 'AMC3Steam0' .. i
                    else
                        fxname = 'AMC3Steam' .. i
                    end
                    for k, v in self.unit.SteamEffects do
                        table.insert( self.unit.SteamEffectsBag, CreateAttachedEmitter( self.unit, fxname, self.unit:GetArmy(), v ))
                    end
                end
                ZCannonWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
        },
        AAGunLeft01 = Class(TAALinkedRailgun) {},
        AAGunLeft02 = Class(TAALinkedRailgun) {},
        AAGunLeft03 = Class(TAALinkedRailgun) {},
        AAGunLeft04 = Class(TAALinkedRailgun) {},
        AAGunRight01 = Class(TAALinkedRailgun) {},
        AAGunRight02 = Class(TAALinkedRailgun) {},
        AAGunRight03 = Class(TAALinkedRailgun) {},
        AAGunRight04 = Class(TAALinkedRailgun) {},
        FrontDeckGun01 = Class(TDFShipGaussCannonWeapon) {},
        LeftDeckgun01 = Class(TDFShipGaussCannonWeapon) {},
        LeftDeckgun02 = Class(TDFShipGaussCannonWeapon) {},
        LeftDeckgun03 = Class(TDFShipGaussCannonWeapon) {},
        BackDeckgun = Class(TDFShipGaussCannonWeapon) {},
        RightDeckgun01 = Class(TDFShipGaussCannonWeapon) {},
        RightDeckgun02 = Class(TDFShipGaussCannonWeapon) {},
        RightDeckgun03 = Class(TDFShipGaussCannonWeapon) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        TSeaUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateRotator(self, 'Spinner01', 'y', nil, -45))
        self.Trash:Add(CreateRotator(self, 'Spinner02', 'y', nil, 90))
        self.SteamEffectsBag = {}
    end,
}

TypeClass = BES0402