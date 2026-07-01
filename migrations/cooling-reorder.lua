-- The basic water-based cooling recipes (iron/copper-smelting-cooling) moved from
-- the "advanced-lava-cooling" technology to "advanced-lava-smelting" so that the
-- smelting tech is no longer inert. Re-enable them for any force that has already
-- researched either technology, otherwise Factorio would re-lock them on upgrade.
for _, force in pairs(game.forces) do
    local techs = force.technologies
    local smelting = techs["advanced-lava-smelting"]
    local cooling = techs["advanced-lava-cooling"]
    if (smelting and smelting.researched) or (cooling and cooling.researched) then
        for _, recipe_name in pairs({ "iron-smelting-cooling", "copper-smelting-cooling" }) do
            local recipe = force.recipes[recipe_name]
            if recipe then
                recipe.enabled = true
            end
        end
    end
end
