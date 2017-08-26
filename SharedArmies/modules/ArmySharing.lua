--******************************************************************************
--* File:    ArmySharing.lua
--* Author:  MrNukealizer
--* Summary: Contains sim code to manage what armies each player can control
--*          Requires a patched exe that changes the effect of ArmyGetHandicap()
--******************************************************************************


TransferEverything = import('/lua/SimUtils.lua').TransferEverything

InitialFocusArmy = GetFocusArmy()
ControlMap = {ByArmy = {}, ByPlayer = {}}
local CommandSources = {}
local NameLookup = {}

--=============[ Initialization ]=============--

-- ScenarioInfo.ArmySetup isn't necessarily in the right order so we do this intermediate step
local armies = {}
for _, army in ScenarioInfo.ArmySetup do
    armies[army.ArmyIndex] = army.Human
    NameLookup[army.PlayerName] = army.ArmyIndex
end

local humans = 1
for index, isHuman in armies do
    if isHuman then
        ControlMap.ByArmy[index] = {[index] = true}
        ControlMap.ByPlayer[index] = {[index] = true}
        CommandSources[index] = humans
        humans = humans + 1
    end
end

--=============[ Utility ]=============--
local function CheckArguments(player, army)
    if type(player) == 'string' then player = NameLookup[player] end
    if type(army) == 'string' then army = NameLookup[army] end

    if not player or not CommandSources[player] or not army or not ControlMap.ByArmy[army] then
        return false, false
    end

    return player, army
end

--=============[ Public Functions ]=============--
-- Grant or revoke a player's ability to control an army
function ToggleArmyControl(player, army, allowControl)
    player, army = CheckArguments(player, army)

    if not player then
        return false
    end

    if allowControl then
        allowControl = true
    else
        allowControl = nil
    end

    if allowControl == ControlMap.ByArmy[army][player] then
        return true
    end

    LOG("Calling ArmyGetHandicap("..tostring(army - 1)..", "..tostring(CommandSources[player] - 1)..", "..tostring(allowControl)..")")
    -- In the patched exe ArmyGetHandicap changes an army's authorized command sources
    if not pcall(ArmyGetHandicap, army - 1, CommandSources[player] - 1, allowControl) then
        error('ArmyGetHandicap(' .. tostring(army - 1) .. ', ' .. tostring(CommandSources[player] - 1) .. ', ' .. tostring(allowControl)
            .. ') threw an error. Are you sure this is the patched exe?')
    end

    ControlMap.ByArmy[army][player] = allowControl
    ControlMap.ByPlayer[player][army] = allowControl
    return true
end

-- Allow a player to control a new army and switch their focus to it, optionally revoking control of all other armies
function ChangePlayerFocus(player, army, exclusive)
    player, army = CheckArguments(player, army)

    if not ToggleArmyControl(player, army, true) then
        return false
    end

    if exclusive then
        for id in ControlMap.ByPlayer[player] do
            if id ~= army then
                ToggleArmyControl(player, id, false)
            end
        end
    end

    LOG("ChangePlayerFocus(), InitialFocusArmy: "..InitialFocusArmy..", player: "..player)
    if InitialFocusArmy == player then
        ForkThread(function()
            while GetFocusArmy() ~= army do -- The engine ignores attempts to change focus until the change in command sources propagates through lag.
                WaitTicks(1)
                LOG("Changing focus to "..army)
                SimConExecute('SetFocusArmy ' .. army - 1)
            end
        end)
    end
    return true
end

-- Set a player's exclusive focus to a new army then transfer all units and resources from their old army
function MovePlayerToArmy(player, army)
    LOG("MovePlayerToArmy("..repr(player)..", "..repr(army)..")")
    player, army = CheckArguments(player, army)

    -- There are a lot of ways this can go wrong so we won't do anything if the player doesn't control exactly 1 army to transfer stuff from
    if not player or ControlMap.ByPlayer[player][army] or table.getsize(ControlMap.ByPlayer[player]) ~= 1 then
        return false
    end

    local oldArmy
    for index in ControlMap.ByPlayer[player] do
        oldArmy = index
        break
    end

     -- We don't want to go transferring everything from the old army if other players control it
    if table.getsize(ControlMap.ByArmy[oldArmy]) ~= 1 then
        return false
    end

    if not ChangePlayerFocus(player, army, true) then
        return false
    end

    return TransferEverything(army, oldArmy)
end

-- Make all players on each team share the first army on that team
function CombineTeams()
    local teams = {}
    for _, army in ScenarioInfo.ArmySetup do
        if army.Human and army.Team > 1 then -- Team 1 means no team
            if not teams[army.Team] then
                teams[army.Team] = {}
            end
            teams[army.Team][army.ArmyIndex] = true
        end
    end

    LOG("CombineTeams(), teams: "..repr(teams))

    local result = true
    for _, team in teams do
        local leader
        for player in team do
            if not leader then
                leader = player
            else
                result = result and MovePlayerToArmy(player, leader)
            end
        end
    end

    return result
end
