local lava_cooling_with_liquid_nitrogen = {
    type = "technology",
    name = "lava-cooling-with-liquid-nitrogen",
    icon = "__LavaBlock__/graphics/technologies/lava-cooling-with-liquid-nitrogen.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "lava-cooling-with-liquid-nitrogen"
        }
    },
    prerequisites = { "advanced-lava-cooling" },
    unit =
    {
        count = 1000,
        ingredients =
        {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       1 }
        },
        time = 30
    },
    order = "a-q-z"
}

return lava_cooling_with_liquid_nitrogen