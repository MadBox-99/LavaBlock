-- Hydrofluoric acid scrubbed out of volcanic gas, uranium fluorinated with
-- it to a gas, and the gas enriched in the lava centrifuge: 43% more U-235
-- an ore than the vanilla centrifuge gets.
--
-- After Volcanic gas processing, for the gas the acid comes from, Uranium
-- processing, which hands over the isotopes and what they are used for,
-- and the Lava centrifuge, which does the spinning. The centrifuge brings
-- the lava pack with it.
return {
    type = "technology",
    name = "uranium-hexafluoride",
    icons = {
        {
            icon = "__base__/graphics/technology/uranium-processing.png",
            icon_size = 256,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/uranium-hexafluoride.png",
            icon_size = 64,
            scale = 1.0,
            shift = { 48, 48 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "fluoride-scrubbing" },
        { type = "unlock-recipe", recipe = "uranium-fluorination" },
        { type = "unlock-recipe", recipe = "uranium-hexafluoride-centrifuging" },
    },
    prerequisites = { "volcanic-gas-processing", "uranium-processing", "lava-centrifuge" },
    unit = {
        count = 400,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       1 },
        },
        time = 30,
    },
    order = "e-p-b-c-b",
}
