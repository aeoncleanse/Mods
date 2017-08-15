-----------------------------------------------------------------
-- File     :  /lua/editor/UnitCountBuildConditions.lua
-- Author(s): Dru Staltman, John Comes
-- Summary  : Generic AI Platoon Build Conditions
--            Build conditions always return true or false
-- Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------

local AIUtils = import('/lua/ai/aiutilities.lua')

function CanUpgrade(aiBrain, upgrade)
    local units = aiBrain:GetListOfUnits(categories.COMMAND, false)
    for _, v in units do
        local bp = v:GetBlueprint()

        if bp == nil then
            return false
        end

        local enh = bp.Enhancements[upgrade]
        local econ = AIUtils.AIGetEconomyNumbers(aiBrain)
        if enh == nil then
            return false
        elseif (econ.MassTrend * 2 > enh.BuildCostMass / enh.BuildTime
                and econ.EnergyTrend * 2 > enh.BuildCostEnergy / enh.BuildTime) then
            return true
        elseif (econ.MassStorage >= enh.BuildCostMass / 1.5
                and econ.EnergyStorage >= enh.BuildCostEnergy / 1.5) then
            return true
        elseif aiBrain:GetCurrentUnits(categories.TECH2) > 20 or aiBrain:GetCurrentUnits(categories.TECH3) > 10 then
            return true
        end
    end
    return false
end
