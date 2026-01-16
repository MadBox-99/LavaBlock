return {
    -- Base Lava Centrifuge technology
    {
        type = "technology",
        name = "lava-centrifuge",
        icon = "__base__/graphics/technology/uranium-processing.png",
        icon_size = 256,
        effects = {
            { type = "unlock-recipe", recipe = "lava-centrifuge" },
            { type = "unlock-recipe", recipe = "lava-purification" },
            { type = "unlock-recipe", recipe = "concentrated-ore-extraction" },
        },
        prerequisites = { "lava-science-pack", "advanced-circuit" },
        unit = {
            count = 500,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "lava-science-pack",       2 },
            },
            time = 30
        },
        order = "e-p-b-c"
    },
    -- Rare Mineral Extraction technology
    {
        type = "technology",
        name = "rare-mineral-extraction",
        icon = "__base__/graphics/technology/kovarex-enrichment-process.png",
        icon_size = 256,
        effects = {
            { type = "unlock-recipe", recipe = "uranium-from-lava" },
        },
        prerequisites = { "lava-centrifuge", "uranium-processing" },
        unit = {
            count = 1000,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "lava-science-pack",       3 },
            },
            time = 45
        },
        order = "e-p-b-d"
    },
    -- Tungsten Processing from Lava (Space Age only)
    {
        type = "technology",
        name = "tungsten-from-lava",
        icon = "__space-age__/graphics/technology/tungsten-steel.png",
        icon_size = 256,
        effects = {
            { type = "unlock-recipe", recipe = "hot-tungsten-ore-from-lava" },
            { type = "unlock-recipe", recipe = "liquid-tungsten-from-hot-ore" },
            { type = "unlock-recipe", recipe = "tungsten-plate-from-lava" },
        },
        prerequisites = { "lava-centrifuge", "tungsten-steel" },
        unit = {
            count = 2000,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack",   1 },
                { "chemical-science-pack",   1 },
                { "production-science-pack", 1 },
                { "lava-science-pack",       3 },
            },
            time = 60
        },
        order = "e-p-b-e"
    },
}
