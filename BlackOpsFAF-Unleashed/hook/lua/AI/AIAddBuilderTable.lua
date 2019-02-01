
local OLDAddGlobalBaseTemplate = AddGlobalBaseTemplate
function AddGlobalBaseTemplate(aiBrain, locationType, baseBuilderName)
    SPEW('BlackOpsFAF-Unleashed: Injecting BuilderGroup "BO-HydroCarbonUpgrade"')
    AddGlobalBuilderGroup(aiBrain, locationType, 'BO-HydroCarbonUpgrade')
    OLDAddGlobalBaseTemplate(aiBrain, locationType, baseBuilderName)
end
