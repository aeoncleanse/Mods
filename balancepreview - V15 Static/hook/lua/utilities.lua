-- Added to FAF so we can exclude allied units
function GetTrueEnemiesInSphere(unit, position, radius)
    local x1 = position.x - radius
    local y1 = position.y - radius
    local z1 = position.z - radius
    local x2 = position.x + radius
    local y2 = position.y + radius
    local z2 = position.z + radius
    local UnitsinRec = GetUnitsInRect( Rect(x1, z1, x2, z2) )
    --Check for empty rectangle
    if not UnitsinRec then
        return UnitsinRec
    end
    local RadEntities = {}
    for k, v in UnitsinRec do
        local dist = VDist3(position, v:GetPosition())
        if unit:GetArmy() != v:GetArmy() and dist <= radius and IsAlly(unit:GetArmy(), v:GetArmy()) == false then
            table.insert(RadEntities, v)
        end
    end
    return RadEntities
end
