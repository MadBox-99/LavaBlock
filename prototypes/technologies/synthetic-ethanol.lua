-- Ethanol from petroleum gas. Its own small research rather than a rider on
-- oil processing, so that it sits after the fermentation line and reads as
-- the second way to the same fluid - and behind oil processing, because
-- until then there is no gas to hydrate.
--
-- The Fuel Plant comes with this and with ethanol rocket fuel, whichever is
-- researched first; both of its recipes need it.
return {
    type = "technology",
    name = "synthetic-ethanol",
    icons = {
        {
            icon = "__base__/graphics/technology/oil-processing.png",
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
        { type = "unlock-recipe", recipe = "ethanol-synthesis" },
    },
    prerequisites = { "bio-ethanol", "oil-processing" },
    unit = {
        count = 100,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
        },
        time = 30
    },
    order = "a-b-i"
}
