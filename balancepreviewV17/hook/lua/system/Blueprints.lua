-- Mod unit blueprints before allowing mods to modify it aswell, to pass the most correct unit blueprint to mods
function PreModBlueprints(all_bps)

    -- Brute51: Modified code for ship wrecks and added code for SCU presets.
    -- removed the pairs() function call in the for loops for better efficiency and because it is not necessary.

    local cats = {}

    for _, bp in all_bps.Unit do

        -- skip units without categories
        if not bp.Categories then
            continue
        end

        -- adding or deleting categories on the fly
        if bp.DelCategories then
            for k, v in bp.DelCategories do
                table.removeByValue( bp.Categories, v )
            end
            bp.DelCategories = nil
        end
        if bp.AddCategories then
            for k, v in bp.AddCategories do
                table.insert( bp.Categories, v )
            end
            bp.AddCategories = nil
        end

        -- find out what categories the unit has and allow easy reference
        cats = {}
        for k, cat in bp.Categories do
            cats[cat] = true
        end

        if cats.NAVAL and not bp.Wreckage then
            -- Add naval wreckage
            --LOG("Adding wreckage information to ", bp.Description)
            bp.Wreckage = {
                Blueprint = '/props/DefaultWreckage/DefaultWreckage_prop.bp',
                EnergyMult = 0,
                HealthMult = 0.9,
                MassMult = 0.9,
                ReclaimTimeMultiplier = 1,
                WreckageLayers = {
                    Air = false,
                    Land = false,
                    Seabed = true,
                    Sub = true,
                    Water = true,
                },
            }
        end
        
        -- make it possible to pause all mobile units, stopping in this case means pause at next order in command queue
        if cats.MOBILE then
            bp.General.CommandCaps.RULEUCC_Pause = true
        end

        -- fixes move-attack range issues
        -- Most Air units have the GSR defined already, this is just making certain they don't get included
        if cats.MOBILE and (cats.LAND or cats.NAVAL) and (cats.DIRECTFIRE or cats.INDIRECTFIRE or cats.ENGINEER) and not (bp.AI and bp.AI.GuardScanRadius) then
            local br = nil

            if(cats.ENGINEER) then
                br = 20
            elseif(cats.SCOUT) then
                br = 10
            elseif bp.Weapon then
                local range = 0
                local tracking = 1.05

                for i, w in bp.Weapon do
                    local ignore = w.CountedProjectile or w.RangeCategory == 'UWRC_AntiAir' or w.WeaponCategory == 'Defense'
                    if not ignore then
                        if w.MaxRadius then
                            range = math.max(w.MaxRadius, range)
                        end
                        if w.TrackingRadius then
                            tracking = math.max(w.TrackingRadius, tracking)
                        end
                    end
                end

                br = (range * tracking)
            end

            if(br) then
                if not bp.AI then bp.AI = {} end
                bp.AI.GuardScanRadius = br
            end
        end

        BlueprintLoaderUpdateProgress()
    end
end
