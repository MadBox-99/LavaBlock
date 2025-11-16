local advanced_lava_smelting = {
    type = "technology",
    name = "advanced-lava-smelting",
    icon = "__base__/graphics/technology/mining-productivity.png",
    icon_size = 256,
    effects =
    {
        {
            type = "unlock-recipe",
            recipe = "iron-smelting"
        },
        {
            type = "unlock-recipe",
            recipe = "copper-smelting"
        },
        {
            type = "unlock-recipe",
            recipe = "brick-smelting"
        }
    },
    prerequisites = { "chemical-science-pack" },
    unit =
    {
        count = 666,
        ingredients =
        {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 }
        },
        time = 66
    },
    upgrade = true,
    order = "t-q-a"
}
return advanced_lava_smelting
