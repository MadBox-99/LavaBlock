local advanced_lava_cooling = {
    type = "technology",
    name = "advanced-lava-cooling",
    -- The air compressor, the one building this hands over; the two cryo
    -- smelting recipes run in the air cooler, which has its own picture.
    icon = "__LavaBlock-graphics__/graphics/technology/advanced-lava-cooling.png",
    icon_size = 256,
    effects =
    {
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
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       1 }
        },
        time = 20
    },
    order = "a-q-z"
}

return advanced_lava_cooling