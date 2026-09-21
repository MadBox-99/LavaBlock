-- Oxygen, and what it is for.
--
-- Its own line rather than a rider on the bio garden: electrolysis is a
-- chemical plant recipe and has nothing to do with growing things, so making
-- the garden a prerequisite for oxygen-lanced smelting would gate a furnace
-- upgrade behind a greenhouse for no reason.
return {
    type = "technology",
    name = "oxygen-processing",
    icons = {
        {
            icon = "__base__/graphics/technology/fluid-handling.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock__/graphics/icons/gas/oxygen.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "water-electrolysis" },
        { type = "unlock-recipe", recipe = "iron-smelting-oxygen" },
        { type = "unlock-recipe", recipe = "copper-smelting-oxygen" },
    },
    prerequisites = { "chemical-science-pack" },
    unit = {
        count = 200,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30
    },
    order = "a-b-g"
}
