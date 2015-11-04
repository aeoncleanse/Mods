local spreadAttack = import('/lua/spreadattack.lua').MakeShadowCopyOrders

function OnCommandIssued(command)

    if not command.Clear then
		issuedOneCommand = true
	else
		EndCommandMode(true)
	end
	
	if command.CommandType == 'Attack' then
		if command.Clear then
			local cb = { Func = 'ClearTargets', Args = { } }
			SimCallback(cb, true)
		end

		local cb = { Func = 'AddTarget', Args = { target = command.Target.EntityId, position = command.Target.Position } } 
		SimCallback(cb, true)
	end
    
	if command.CommandType == 'BuildMobile' then
		AddCommandFeedbackBlip({
			Position = command.Target.Position, 
			BlueprintID = command.Blueprint,			
			TextureName = '/meshes/game/flag02d_albedo.dds',
			ShaderName = 'CommandFeedback',
			UniformScale = 1,
		}, 0.7)	
	else	
	
		if AddCommandFeedbackByType(command.Target.Position, command.CommandType) == false then	
			AddCommandFeedbackBlip({
				Position = command.Target.Position, 
				MeshName = '/meshes/game/flag02d_lod0.scm',
				TextureName = '/meshes/game/flag02d_albedo.dds',
				ShaderName = 'CommandFeedback',
				UniformScale = 0.5,
			}, 0.7)		
			
			AddCommandFeedbackBlip({
				Position = command.Target.Position, 
				MeshName = '/meshes/game/crosshair02d_lod0.scm',
				TextureName = '/meshes/game/crosshair02d_albedo.dds',
				ShaderName = 'CommandFeedback2',
				UniformScale = 0.5,
			}, 0.75)		
		end		
	end
	spreadAttack(command)
end
