-- overwrite the original function. Destructive hook !
local LetterArray = { ["Aeon"] = "ua", ["UEF"] = "ue", ["Cybran"] = "ur", ["Seraphim"] = "xs" }
local BOLetterArray = { ["Aeon"] = "ba", ["UEF"] = "be", ["Cybran"] = "br", ["Seraphim"] = "bs" }

Callbacks.CapMex = function(data, units)
    local units = EntityCategoryFilterDown(categories.ENGINEER, SecureUnits(units))
    if not units[1] then return end
    local mex = GetEntityById(data.target)
    if not mex or not EntityCategoryContains(categories.MASSEXTRACTION * categories.STRUCTURE, mex) then return end
    local pos = mex:GetPosition()
    local msid

    for _, u in units do
        local FactionName = u:GetBlueprint().General.FactionName
        if u:CanBuild(BOLetterArray[FactionName]..'b1106') then
            msid = BOLetterArray[FactionName]..'b1106'
        else
            msid = LetterArray[FactionName]..'b1106'
        end
        IssueBuildMobile({u}, Vector(pos.x, pos.y, pos.z-2), msid, {})
        IssueBuildMobile({u}, Vector(pos.x+2, pos.y, pos.z), msid, {})
        IssueBuildMobile({u}, Vector(pos.x, pos.y, pos.z+2), msid, {})
        IssueBuildMobile({u}, Vector(pos.x-2, pos.y, pos.z), msid, {})
    end
end
