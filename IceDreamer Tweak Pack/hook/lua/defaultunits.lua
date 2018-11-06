------------------------------------------------------------------------------------------
--    File     :  /mods/hover_bomber_fix/hook/lua/defaultunits.lua
--    Author(s):  Resin_Smoker
--    Summary  :  Prevents bomber from firing if they're not moving at least cruising speed
--    Copyright © 2014 All rights reserved.
------------------------------------------------------------------------------------------

do

--> Triggers all logs to report if flag set true, otherwise use the local flags within each function for specific outputs
local masterDebug = false

------------------------------------------------------------------------------------------
-- Air Units
------------------------------------------------------------------------------------------

local oldAirUnit = AirUnit
AirUnit = Class( oldAirUnit ) {

    OnStopBeingBuilt = function( self, builder, layer )
        --> Run old OnStopBeingBuilt first
        oldAirUnit.OnStopBeingBuilt( self, builder, layer )
        --> Get units BP
        local bp = self:GetBlueprint()
        local myDebug = false
        if myDebug and masterDebug then
            LOG('*** hover_bomber_fix defaultunits.lua, OnStopBeingBuilt ***')
            LOG('    Unit ID: ', self:GetEntityId() )
            LOG('    Game time is: ', GetGameTimeSeconds() )
            LOG('    Name: ', bp.General.UnitName )
            LOG('*************************************')
        end
        --> Ensure that unit is winged, has the category "Bomber" and is not the Mercy suicide missile
        if bp.Air.Winged and EntityCategoryContains(categories.BOMBER, self) and bp.General.UnitName != '<LOC daa0206_name>Mercy' then
            if myDebug and masterDebug then
                LOG('    Airunit is a BOMBER')
                LOG('    ')
            end
            --> Setup global flags
            self.IsBomber = true
            self.MyWepEnabled = true
        else
            if myDebug and masterDebug then
                LOG('    Airunit is NOT a bomber')
                LOG('    ')
            end
        end
    end,

    OnMotionHorzEventChange = function(self, new, old)
        local myDebug = false
        --> Run old OnMotionHorzEventChange first
        oldAirUnit.OnMotionHorzEventChange(self, new, old)
        --> Does unit still exist
        if self and not self:IsDead() then
            --> Is unit a bomber, is motion type different from last one reported
            if self.IsBomber and new != old then
                --> Did our bomber start moving again and are the weapons disabled
                if ( new == 'Cruise' or new == 'TopSpeed' ) and ( old == 'Stopping' or old == 'Stopped' ) and not self.MyWepEnabled and not self.WeaponReactivationFork then
                    --> Kick off delay fork
                    self.WeaponReactivationFork = ForkThread(self.WeaponReactivationDelay, self, new, old)
                --> Did our bomber stop moving again and are the weapons enabled
                elseif ( old == 'Cruise' or old == 'TopSpeed' ) and ( new == 'Stopping' or new == 'Stopped' ) and self.MyWepEnabled then
                    --> Kill fork if active
                    if self.WeaponReactivationFork then
                        if myDebug and masterDebug then
                            print('    Killing WeaponReactivationFork', '    Game time is: ', GetGameTimeSeconds() )
                        end
                        KillThread(self.WeaponReactivationFork)
                        --> Clear off the global so the event can be used again
                        self.WeaponReactivationFork = nil
                    end
                    --> Set flag to false
                    self.MyWepEnabled = false
                    --> Loop though all weapons
                    for i = 1, self:GetWeaponCount() do
                        local wep = self:GetWeapon(i)
                        local wepBP = wep:GetBlueprint()
                        --> Only disable if weapon is not anti-air
                        if wepBP.WeaponCategory != 'Anti Air' and wepBP.RangeCategory != 'UWRC_AntiAir' then
                            wep:SetEnabled(false)
                            if myDebug and masterDebug then
                                print('    Bomber is: ', new, ' from:', old,' DISABLING weapons', '    Game time is: ', GetGameTimeSeconds() )
                            end
                        end
                    end
                end
            end
        end
    end,

    WeaponReactivationDelay = function( self, new, old )
        local myDebug = false
        local ran = Random(1, 2)
        local delay = 5
        if myDebug and masterDebug then
            print('WeaponReactivationDelay in Ticks = ', ran + delay,'    Game time is: ', GetGameTimeSeconds() )
        end
        --> Time delay in "ticks" before weapons are set active again. 10 ticks = 1 second. Please do not use setting lower than 5 ticks to help keep the game sync'd during multiplayer
        --> Remember the default ping for all players is at least 500ms or 0.5 seconds or 5 ticks.
        WaitTicks(ran + delay)
        if myDebug and masterDebug then
            print('    Delay complete...','    Game time is: ', GetGameTimeSeconds() )
        end
        --> Does unit still exist
        if self and not self:IsDead() then
            --> Set flag to true
            self.MyWepEnabled = true
            --> Loop though all weapons
            for i = 1, self:GetWeaponCount() do
                local wep = self:GetWeapon(i)
                local wepBP = wep:GetBlueprint()
                --> Only enable if weapon is not anti-air
                if wepBP.WeaponCategory != 'Anti Air' and wepBP.RangeCategory != 'UWRC_AntiAir' then
                    wep:SetEnabled(true)
                    if myDebug and masterDebug then
                        print('    Bomber is: ', new, ' from:', old,' ENABLING weapons','    Game time is: ', GetGameTimeSeconds() )
                    end
                end
            end
        end
    end,

}
end