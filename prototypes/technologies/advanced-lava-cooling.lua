local advanced_lava_cooling = {
    type = "technology",
    name = "advanced-lava-cooling",
    icon = "__LavaBlock__/graphics/lava-cooling-tech-icon-small.png",
    icon_size = 128,
    effects =
    {
        {
            type = "unlock-recipe",
            recipe = "iron-smelting-cooling"
        },
        {
            type = "unlock-recipe",
            recipe = "copper-smelting-cooling"
        },
        {
            type = "unlock-recipe",
            recipe = "iron-smelting-cryo-cooling"
        },
        {
            type = "unlock-recipe",
            recipe = "copper-smelting-cryo-cooling"
        },
        {
            type = "unlock-recipe",
            recipe = "air-compressor"
        }
    },
    prerequisites = { "logistic-science-pack", "air-cooler" },
    unit =
    {
        count = 200,
        ingredients =
        {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 }
        },
        time = 20
    },
    order = "a-q-z"
}

return advanced_lava_cooling