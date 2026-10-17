-- Krypton and xenon distilled out of liquid air.
--
-- The lava pack's era, after Advanced lava cooling, which hands over the
-- compressed air and the liquid nitrogen, and Oil processing for the
-- refinery the column is. EUV lithography waits on it: the ruby in every
-- laser source is pumped by a xenon flash tube.
return {
    type = "technology",
    name = "noble-gases",
    icons = {
        {
            icon = "__base__/graphics/technology/oil-processing.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/xenon.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "rare-gas-fractionation" },
    },
    prerequisites = { "advanced-lava-cooling", "oil-processing" },
    unit = {
        count = 250,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       1 },
        },
        time = 30,
    },
    order = "a-a-o",
}
