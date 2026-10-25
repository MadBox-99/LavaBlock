-- The cell assembly line, the electrolyte and cathode it fills and coats,
-- the cells it makes, and the accumulator and robot frame built on them.
-- Aquilo's machine.
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
        { type = "unlock-recipe", recipe = "accumulator-from-lithium-ion-cells" },
        { type = "unlock-recipe", recipe = "flying-robot-frame-from-lithium-ion-cells" },
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
