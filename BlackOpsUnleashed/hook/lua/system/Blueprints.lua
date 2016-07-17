do
    function ExtractCloakMeshBlueprint(bp)
        local meshid = bp.Display.MeshBlueprint
        if not meshid then return end

        local meshbp = original_blueprints.Mesh[meshid]
        if not meshbp then return end

        local shadernameE = 'ShieldCybran'
        local shadernameA = 'ShieldAeon'
        local shadernameC = 'ShieldCybran'
        local shadernameS = 'ShieldAeon'

        local cloakmeshbp = table.deepcopy(meshbp)
        if cloakmeshbp.LODs then
            for i,cat in bp.Categories do
            if cat == 'UEF' then
                for i,lod in cloakmeshbp.LODs do
                    lod.ShaderName = shadernameE
                end
            elseif cat == 'AEON' then
                for i,lod in cloakmeshbp.LODs do
                    lod.ShaderName = shadernameA
                end
            elseif cat == 'CYBRAN' then
                for i,lod in cloakmeshbp.LODs do
                    lod.ShaderName = shadernameC
                end
            elseif cat == 'SERAPHIM' then
                for i,lod in cloakmeshbp.LODs do
                    lod.ShaderName = shadernameS
                end
            end
            end
        end
        cloakmeshbp.BlueprintId = meshid .. '_cloak'
        bp.Display.CloakMeshBlueprint = cloakmeshbp.BlueprintId
        MeshBlueprint(cloakmeshbp)
    end

    function ExtractPhaseMeshBlueprint(bp)
        local meshid = bp.Display.MeshBlueprint
        if not meshid then return end

        local meshbp = original_blueprints.Mesh[meshid]
        if not meshbp then return end

        local shadernameP1 = 'ShieldUEF'
        local shadernameP2 = 'AlphaFade'
        local shadernameP12 = 'PhalanxEffect'
        local shadernameP22 = 'AlphaFade'

        local phase1meshbp = table.deepcopy(meshbp)
        if phase1meshbp.LODs then
            for i,cat in bp.Categories do
            if cat == 'UEF' then
                for i,lod in phase1meshbp.LODs do
                    lod.ShaderName = shadernameP1
                end
            elseif cat == 'AEON' then
                for i,lod in phase1meshbp.LODs do
                    lod.ShaderName = shadernameP1
                end
            elseif cat == 'CYBRAN' then
                for i,lod in phase1meshbp.LODs do
                    lod.ShaderName = shadernameP12
                end
            elseif cat == 'SERAPHIM' then
                for i,lod in phase1meshbp.LODs do
                    lod.ShaderName = shadernameP12
                end
            end
            end
        end
        local phase2meshbp = table.deepcopy(meshbp)
        if phase2meshbp.LODs then
            for i,cat in bp.Categories do
            if cat == 'UEF' then
                for i,lod in phase2meshbp.LODs do
                    lod.ShaderName = shadernameP2
                end
            elseif cat == 'AEON' then
                for i,lod in phase2meshbp.LODs do
                    lod.ShaderName = shadernameP2
                end
            elseif cat == 'CYBRAN' then
                for i,lod in phase2meshbp.LODs do
                    lod.ShaderName = shadernameP22
                end
            elseif cat == 'SERAPHIM' then
                for i,lod in phase2meshbp.LODs do
                    lod.ShaderName = shadernameP22
                end
            end
            end
        end
        phase1meshbp.BlueprintId = meshid .. '_phase1'
        phase2meshbp.BlueprintId = meshid .. '_phase2'
        bp.Display.Phase1MeshBlueprint = phase1meshbp.BlueprintId
        bp.Display.Phase2MeshBlueprint = phase2meshbp.BlueprintId
        MeshBlueprint(phase1meshbp)
        MeshBlueprint(phase2meshbp)
    end

    local OldModBlueprints = ModBlueprints
    function ModBlueprints(all_blueprints)
        OldModBlueprints(all_blueprints)
        for id,bp in all_blueprints.Unit do
            ExtractCloakMeshBlueprint(bp)
            ExtractPhaseMeshBlueprint(bp)
            if table.find(bp.Categories, 'SUBCOMMANDER') then
                table.insert(bp.Categories, 'ANTITELEPORT')
            end
            if bp.Weapon then
                for ik, wep in bp.Weapon do
                    if wep.RangeCategory == 'UWRC_AntiAir' then
                        if not wep.AntiSat == true then
                            wep.TargetRestrictDisallow = wep.TargetRestrictDisallow .. ', SATELLITE'
                        end
                    end
                end
            end
            if not bp.Categories or not bp.Display.Mesh.LODs then continue end
            CalculateNewLod(bp)
        end
    end
end

-- LODoptions: Changing this in multiplayer will desync the game! Default is 2
-- 0 diabled
-- 1 low / Units will be hide by size if zoomed out. Using High and Low resolution textures and models
-- 2 high / Units hide by size and ony use highres textures and models.
-- 3 full / Units will never hide, and only use highres textures and models.
local LODoptions = 2

function CalculateNewLod(uBP)
    if LODoptions == 0 then return end
    -- count how many LOD entries exist (max 2)
    local LODsCount = table.getn(uBP.Display.Mesh.LODs)
    -- if we don't have LOD settings, return
    if LODsCount <= 0 then return end
    -- If we use only higrestextures we move LODCutoff from LOD-2 to LOD-1 and delete the 2nd LOD entry
    if LODoptions == 2 or LODoptions == 3 then
        LODsCount = 1 
        -- do we have LODCutoff in 2nd LOD array ? 
        if uBP.Display.Mesh.LODs[2].LODCutoff then
            -- copy LODCutoff from lowres to highres LOD
            uBP.Display.Mesh.LODs[1].LODCutoff = uBP.Display.Mesh.LODs[2].LODCutoff
        end
        -- delete the 2nd LOD entry
        uBP.Display.Mesh.LODs[2] = nil
    end
    -- if we dont hide units while zooming out, we set a fixed LODCutoff and return
    if LODoptions == 3 then
        uBP.Display.Mesh.LODs[1].LODCutoff = 1000
        return
    end
    -- copy categories into local variable for faster access
    local Categories = {}
    for _, cat in uBP.Categories do
        Categories[cat] = true
    end
    -- loop over LOD's array
    for lodNum, lod in uBP.Display.Mesh.LODs do
        -- we only check the last LOD entry inside the LOD array, and only if we have SelectionSizeX + Z
        if lodNum ~= LODsCount or not uBP.SelectionSizeX or not uBP.SelectionSizeZ then continue end
        -- calculate unit/building surface by SelectionSize or HitBoxSize, whatever is bigger
        local SelectionSize = uBP.SelectionSizeX * uBP.SelectionSizeZ
        local HitBoxSize = uBP.SizeX / 1.4  * uBP.SizeZ / 1.4
        if SelectionSize > HitBoxSize then
            UnitLodSize = SelectionSize
        else
            UnitLodSize = HitBoxSize
        end
        -- make Experimental bigger, if it's not already as big as an factory. So we see experimentals a bit longer if zoomed out
        if (Categories.EXPERIMENTAL or uBP.StrategicIconName == 'icon_experimental_generic') and UnitLodSize < 5.5 then -- Experimentals smaller then factories
            UnitLodSize = UnitLodSize * 1.8
        end
        -- mq use 125 as offset, so we start hiding units after strategic icons are shown.
        local mq = math.floor(UnitLodSize *35)+125 -- to compare: LandFactoryLODsize x*y = 10,56.
        -- dont hide units until we display the strategic icon
        if mq < 130 then
            mq = 130
        end
        -- stop displaying land units at LOD 600 (LANDFactory has ~ 500)
        if mq > 600 and not Categories.AIR and not Categories.EXPERIMENTAL then
            mq = 600
        end
        -- stop displaying air units a little bit later then land units
        if mq > 700 and Categories.AIR and not Categories.EXPERIMENTAL then
            mq = 700
        end
        -- stop displaying all units over LOD 1000. (almost zoomed out max)
        if mq > 1000 then
            mq = 1000
        end
        -- display strategic icons from LOD 130 on, so they will hide smaller units.
        uBP.Display.Mesh.IconFadeInZoom = 130
        -- Set the new LODCutoff inside blueprint LOD-1 or LOD-2
        uBP.Display.Mesh.LODs[lodNum].LODCutoff = mq
        -- if we have 2 LOD settings (hig and low res), set LODCutoff from LOD-1(HighresLOD) to 1/2 of LOD-2 (mq).
        if lodNum == 2 then
            local HighresLOD = mq/2
            -- dont hide units until we display the strategic icon
            if HighresLOD < 130 then
                HighresLOD = 130
            end
            -- Set the new LODCutoff inside blueprint LOD-1
            uBP.Display.Mesh.LODs[1].LODCutoff = HighresLOD
        end
    end
end
