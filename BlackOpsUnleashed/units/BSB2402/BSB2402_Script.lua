#****************************************************************************
#** 
#**  File     :  /cdimage/units/Effect01/Effect01_script.lua 
#** 
#** 
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local SLandFactoryUnit = import('/lua/seraphimunits.lua').SLandFactoryUnit

BSB2402 = Class(SLandFactoryUnit) {
	OnStopBeingBuilt = function(self,builder,layer)
		SLandFactoryUnit.OnStopBeingBuilt(self,builder,layer)
		local army = self:GetArmy()
		### Global Varibles###
    	self.Side = 0
    	self.DroneTable = {}
    	self.EffectsBag = {}
		#######CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_01_emit.bp'):OffsetEmitter(0.00, 0.00, 0.00)
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_01_emit.bp'):ScaleEmitter(0.7)	# glow
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_02_emit.bp'):ScaleEmitter(0.7)	# plasma pillar
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_03_emit.bp'):ScaleEmitter(0.7)	# darkening pillar
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_04_emit.bp'):ScaleEmitter(0.7)	# ring outward dust/motion
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_05_emit.bp'):ScaleEmitter(0.7)	# plasma pillar move
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_06_emit.bp'):ScaleEmitter(0.7)	# darkening pillar move
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_07_emit.bp'):ScaleEmitter(0.7)	# bright line at bottom / right side
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_08_emit.bp'):ScaleEmitter(0.7)	# bright line at bottom / left side
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_09_emit.bp'):ScaleEmitter(0.7)	# small flickery dots rising
        CreateAttachedEmitter(self,'Effect01',army, '/effects/emitters/seraphim_rift_arch_base_10_emit.bp'):ScaleEmitter(0.7)	# distortion
        CreateAttachedEmitter(self,'FX_07',army, '/effects/emitters/seraphim_rift_arch_top_01_emit.bp'):ScaleEmitter(0.7)		# top part glow
        CreateAttachedEmitter(self,'FX_07',army, '/effects/emitters/seraphim_rift_arch_top_02_emit.bp'):ScaleEmitter(0.7)		# top part plasma
        CreateAttachedEmitter(self,'FX_07',army, '/effects/emitters/seraphim_rift_arch_top_03_emit.bp'):ScaleEmitter(0.7)	# top part darkening
        CreateAttachedEmitter(self,'FX_01',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)	# line wall
        CreateAttachedEmitter(self,'FX_02',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)	# line wall
        CreateAttachedEmitter(self,'FX_03',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)	# line wall
        CreateAttachedEmitter(self,'FX_04',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)	# line wall
        CreateAttachedEmitter(self,'FX_05',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)	# line wall
        CreateAttachedEmitter(self,'FX_06',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)	# line wall
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_01_emit.bp'):ScaleEmitter(0.7)	# glow
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_02_emit.bp'):ScaleEmitter(0.7)	# plasma pillar
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_03_emit.bp'):ScaleEmitter(0.7)	# darkening pillar
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_04_emit.bp'):ScaleEmitter(0.7)	# ring outward dust/motion
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_05_emit.bp'):ScaleEmitter(0.7)	# plasma pillar move
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_06_emit.bp'):ScaleEmitter(0.7)	# darkening pillar move
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_07_emit.bp'):ScaleEmitter(0.7)	# bright line at bottom / right side
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_08_emit.bp'):ScaleEmitter(0.7)	# bright line at bottom / left side
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_09_emit.bp'):ScaleEmitter(0.7)	# small flickery dots rising
        CreateAttachedEmitter(self,'Effect03',army, '/effects/emitters/seraphim_rift_arch_base_10_emit.bp'):ScaleEmitter(0.7)	# distortion
        CreateAttachedEmitter(self,'FX_14',army, '/effects/emitters/seraphim_rift_arch_top_01_emit.bp'):ScaleEmitter(0.7)		# top part glow
        CreateAttachedEmitter(self,'FX_14',army, '/effects/emitters/seraphim_rift_arch_top_02_emit.bp'):ScaleEmitter(0.7)		# top part plasma
        CreateAttachedEmitter(self,'FX_14',army, '/effects/emitters/seraphim_rift_arch_top_03_emit.bp'):ScaleEmitter(0.7)		# top part darkening
        CreateAttachedEmitter(self,'FX_08',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)	# line wall
        CreateAttachedEmitter(self,'FX_09',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)	# line wall
        CreateAttachedEmitter(self,'FX_10',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)	# line wall
        CreateAttachedEmitter(self,'FX_11',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)	# line wall
        CreateAttachedEmitter(self,'FX_12',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)	# line wall
        CreateAttachedEmitter(self,'FX_13',army, '/effects/emitters/seraphim_rift_arch_edge_01_emit.bp'):ScaleEmitter(0.7)	# line wall
        
        
        #Start the spawn threads for the Elite units
        self:ForkThread(self.InitialSpawnFactory)
	end,          
	
		#Factory spawning thread******************************************
	InitialSpawnFactory = function(self)
    	### spawning a number of drones times equal to the number preset by numcreate
#    	LOG('*SPAWNING FIRST SET OF DRONES')
    	local numcreate = 2

    	### Randomly determines which launch bay will be the first to spawn a drone
    	self.Side = Random(1,2) 

    	### Short delay after the carrier has been built

    	### Are we dead yet, if not spawn drones
    	if not self:IsDead() then
        	for i = 0, (numcreate -1) do
            	if not self:IsDead() then 
                	self:ForkThread(self.SpawnFactory) 
                	### Short delay between spawns to spread them out
                	WaitSeconds(1)
            	end
        	end
    	end
	end,
SpawnFactory = function(self)
    ### Small respawn delay so the drones are not instantly respawned after death
    LOG('*spawn factory')
    ### Only respawns the drones if the parent unit is not dead
    if not self:IsDead() then 

        ### Sets up local Variables used and spawns a drone at the parents location 
        local myOrientation = self:GetOrientation()
      
        if self.Side == 1 then
            ### Gets the current position of the carrier launch bay in the game world
            local location = self:GetPosition('Factory05')

            ### Creates our drone in the left launch bay and directs the unit to face the same direction as its parent unit
            local drone = CreateUnit('bsb0002', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Land') 

            ### Adds the newly created drone to the parent carriers drone table
            table.insert (self.DroneTable, drone)

            ### Sets the Carrier unit as the drones parent
            drone:SetParent(self, 'bsb2402')
            drone:SetCreator(self)  
            

            ### Issues the guard command
            IssueClearCommands({drone})
            IssueFactoryAssist({drone}, self)

            ### Flips to the next spawn point
            self.Side = 2

            ###Drone clean up scripts
            self.Trash:Add(drone)

        elseif self.Side == 2 then
            ### Gets the current position of the carrier launch bay in the game world
            local location = self:GetPosition('Factory02')

            ### Creates our drone in the right launch bay and directs the unit to face the same direction as its parent unit
            local drone = CreateUnit('bsb0002', self:GetArmy(), location[1], location[2], location[3], myOrientation[1], myOrientation[2], myOrientation[3], myOrientation[4], 'Land') 

            ### Adds the newly created drone to the parent carriers drone table
            table.insert (self.DroneTable, drone)

            ### Sets the Carrier unit as the drones parent
            drone:SetParent(self, 'bsb2402')
            drone:SetCreator(self)

            ### Issues the guard command
            IssueClearCommands({drone})
            IssueFactoryAssist({drone}, self)

            ### Flips from the right to the left self.Side after a drone has been spawned
            self.Side = 1

            ###Drone clean up scripts
            self.Trash:Add(drone)
    	end
	end
end,



#End Factory Threads*********************************************************************************

OnKilled = function(self, instigator, type, overkillRatio)
        SLandFactoryUnit.OnKilled(self, instigator, type, overkillRatio)        
        if table.getn({self.DroneTable}) > 0 then
        	for k, v in self.DroneTable do 
            	IssueClearCommands({self.DroneTable[k]}) 
            	IssueKillSelf({self.DroneTable[k]})
        	end 
        end
    end,
}


TypeClass = BSB2402

