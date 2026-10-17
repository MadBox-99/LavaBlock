-- Steel straight from the melt: oxygen through molten iron, and the steel
-- cast to plate, with no iron plate and no furnace in between.
--
-- After Oxygen processing, for the oxygen, and Advanced lava smelting,
-- because that is where molten iron comes from on the island. Both are
-- chemical science, and so is this.
return {
    type = "technology",
    name = "oxygen-steelmaking",
    icons = {
        {
            icon = "__base__/graphics/technology/steel-processing.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-steel.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "steel-converting" },
        { type = "unlock-recipe", recipe = "steel-casting" },
    },
    prerequisites = { "oxygen-processing", "advanced-lava-smelting" },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-b-i",
}
