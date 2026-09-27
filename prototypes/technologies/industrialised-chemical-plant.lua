-- Unlocks the Industrialised Chemical Plant. Until now nothing in the mod
-- unlocked this recipe, so the entity was unreachable in a normal playthrough.
--
-- It used to need `biochamber` as well, because the recipe consumed one - which
-- put a lava-island building behind Gleba. The recipe takes a plain chemical
-- plant now, and that is unlocked long before this by calcite processing.
local industrialised_chemical_plant_tech = {
    type = "technology",
    name = "industrialised-chemical-plant",
    icon = "__base__/graphics/technology/advanced-material-processing-2.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "industrialised-chemical-plant" },
    },
    prerequisites = { "advanced-lava-cooling" },
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
