-- The cell assembly line, the electrolyte and cathode it fills and coats,
-- and the cells it makes. Aquilo's machine. The cells go into the MK3
-- personal battery and the portable fusion reactor; not into accumulators
-- or robot frames, which Fulgora's science and every robot need long
-- before Aquilo (see recipes/accumulator.lua).
--
-- Cryogenic science, because the line is built on Aquilo of its lithium,
-- and the electrolyte is made in the cryogenic plant. Superalloys for the
-- cobalt and the aluminium, Alloy steels for the nickel and the manganese,
-- Rare earth processing for the phosphorus.
return {
    type = "technology",
    name = "lithium-ion-cells",
    icon = "__LavaBlock-graphics__/graphics/technology/lithium-ion-cells.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "cell-assembly-line" },
        { type = "unlock-recipe", recipe = "lithium-electrolyte" },
        { type = "unlock-recipe", recipe = "nmc-cathode" },
        { type = "unlock-recipe", recipe = "lithium-ion-cell" },
    },
    prerequisites = {
        "cryogenic-science-pack", "superalloys", "alloy-steels",
        "rare-earth-processing",
    },
    unit = {
        count = 1000,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       1 },
            { "space-science-pack",      1 },
            { "cryogenic-science-pack",  1 },
        },
        time = 60
    },
    order = "a-v-d",
}
