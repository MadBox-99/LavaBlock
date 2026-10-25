-- The eddy current separator, the scrap it sorts, and the arc furnace
-- recipe that smelts the e-waste out of it. Fulgora's machine.
--
-- Electromagnetic science, because the separator is built of holmium on
-- Fulgora. Rare earth processing for the rotor's neodymium magnets, Alloy
-- steels for the stainless frame, Arc smelting for the furnace the e-waste
-- goes into, and Precious metals for the anode slime refining that turns
-- what comes out of it into silver, gold and platinum. Every metal the
-- separator throws already has a use by the time a player reaches Fulgora:
-- the thruster's superalloy takes the aluminium, batteries and solder the
-- lead, and brass, which cases every cannon shell, the zinc.
return {
    type = "technology",
    name = "eddy-current-separation",
    icon = "__LavaBlock-graphics__/graphics/technology/eddy-current-separation.png",
    icon_size = 256,
    effects = {
        { type = "unlock-recipe", recipe = "eddy-current-separator" },
        { type = "unlock-recipe", recipe = "scrap-separating" },
        { type = "unlock-recipe", recipe = "e-waste-smelting" },
    },
    prerequisites = {
        "electromagnetic-science-pack", "rare-earth-processing", "alloy-steels",
        "arc-smelting", "precious-metals",
    },
    unit = {
        count = 500,
        ingredients = {
            { "automation-science-pack",      1 },
            { "logistic-science-pack",        1 },
            { "chemical-science-pack",        1 },
            { "lava-science-pack",            1 },
            { "space-science-pack",           1 },
            { "electromagnetic-science-pack", 1 },
        },
        time = 60
    },
    order = "a-v-b",
}
