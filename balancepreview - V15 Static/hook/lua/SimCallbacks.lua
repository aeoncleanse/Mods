local reclaimGround = import('/mods/balancepreview/modules/reclaimground.lua').ReclaimGroundSim

Callbacks.ReclaimGround = function(data)
    local ids = data.Units
    local units = {}

    for _,id in ids do
        local unit = GetEntityById(id)
        if(OkayToMessWithArmy(unit:GetArmy())) then
            table.insert(units, unit)
        end
    end

    local location = Vector(data.Location[1], data.Location[2], data.Location[3])
    reclaimGround(units, location, data.Move == true)
end
