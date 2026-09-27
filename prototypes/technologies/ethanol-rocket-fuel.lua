-- Alcohol and oxygen, the way the first liquid rockets flew. After the
-- vanilla rocket fuel research, so it arrives as a second recipe for a thing
-- the player already knows, and after oxygen processing, which is where the
-- oxidiser comes from.
return {
    type = "technology",
    name = "ethanol-rocket-fuel",
    icons = {
        {
            icon = "__base__/graphics/technology/rocket-fuel.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/ethanol.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "fuel-plant" },
        { type = "unlock-recipe", recipe = "ethanol-rocket-fuel" },
    },
    prerequisites = { "bio-ethanol", "rocket-fuel", "oxygen-processing" },
    unit = {
        count = 300,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30
    },
    order = "a-b-j"
}
