function FakeGateInUnit(unit, callbackFunction)
    if EntityCategoryContains(categories.COMMAND, unit) then
        unit:HideBone(0, true)
        unit:SetUnSelectable(true)
        unit:SetBusy(true)
        unit:PlayUnitSound('CommanderArrival')
        unit:CreateProjectile('/effects/entities/UnitTeleport03/UnitTeleport03_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
        WaitSeconds(0.75)

        unit:DoWarpInEffects(true)
        unit:SetUnSelectable(false)
        unit:SetBusy(false)

        local totalBones = unit:GetBoneCount() - 1
        local army = unit:GetArmy()
        for _, v in import('/lua/EffectTemplates.lua').UnitTeleportSteam01 do
            for bone = 1, totalBones do
                CreateAttachedEmitter(unit, bone, army, v)
            end
        end

        WaitSeconds(2)
        unit:SetMesh(unit:GetBlueprint().Display.MeshBlueprint, true)
    else
        LOG('Non commander unit sent to FakeGateInUnit function')
        unit:PlayTeleportChargeEffects(unit:GetPosition(), unit:GetOrientation())
        unit:PlayUnitSound('GateCharge')
        WaitSeconds(2)
        unit:CleanupTeleportChargeEffects()
    end

    if callbackFunction then
        callbackFunction()
    end
end
