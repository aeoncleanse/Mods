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
		end
	end
end

do
    local oldModBlueprints = ModBlueprints
    function ModBlueprints(all_bps)
	    oldModBlueprints(all_bps)
        for id, bp in all_bps.Unit do
            if bp.Weapon then
                for ik, wep in bp.Weapon do
					if wep.RangeCategory == 'UWRC_AntiAir' then
						if not wep.AntiSat == true then
							wep.TargetRestrictDisallow = wep.TargetRestrictDisallow .. ', SATELLITE'
							--LOG('*ADDING RESTRICTION : ' .. bp.BlueprintId .. " : " .. wep.DisplayName)
						end
					end
				end
			end
		end
    end
end

