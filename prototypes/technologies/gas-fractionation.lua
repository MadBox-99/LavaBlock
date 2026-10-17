-- Petroleum gas distilled into propane and ethane.
--
-- Blue science, after Advanced oil processing, which hands over the gas in
-- quantity. Lubricant waits on it for the propane it is refined with; the
-- ethane is cracked into ethylene once Bio-plastics hands over a use for
-- it.
return {
    type = "technology",
    name = "gas-fractionation",
    icons = {
        {
            icon = "__base__/graphics/technology/advanced-oil-processing.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/propane.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "petroleum-gas-fractionation" },
    },
    prerequisites = { "advanced-oil-processing" },
    unit = {
        count = 100,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
        },
        time = 30,
    },
    order = "a-a-r",
}
