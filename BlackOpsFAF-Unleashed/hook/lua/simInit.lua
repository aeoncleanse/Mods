
local OLDSetupSession = SetupSession
function SetupSession()
    OLDSetupSession()
    import('/mods/BlackOpsFAF-Unleashed/lua/AI/AIBuilders/HydroCarbonUpgrade.lua')
end
