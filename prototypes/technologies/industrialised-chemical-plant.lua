-- Unlocks the Industrialised Chemical Plant. Until now nothing in the mod
-- unlocked this recipe, so the entity was unreachable in a normal playthrough.
--
-- `biochamber` is a prerequisite because the recipe consumes one; without it the
-- technology would be researchable long before the ingredient is obtainable.
local industrialised_chemical_plant_tech = {
    type = "technology",
    name = "industrialised-chemical-plant",
    icon = "__base__/graphics/technology/advanced-material-processing-2.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "industrialised-chemical-plant" },
    },
    prerequisites = { "advanced-lava-cooling", "biochamber" },
    unit = {
        count = 300,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       2 },
        },
        time = 30
    },
    order = "a-q-z-a"
}

return industrialised_chemical_plant_tech
