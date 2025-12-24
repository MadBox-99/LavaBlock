local enchanter_tech = {
    type = "technology",
    name = "enchanter",
    icon = "__base__/graphics/technology/uranium-processing.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "enchanter"
        },
        {
            type = "unlock-recipe",
            recipe = "base-magma-ball"
        },
        {
            type = "unlock-recipe",
            recipe = "fusioning-lava"
        },
        {
            type = "unlock-recipe",
            recipe = "stronger-fusioning-lava"
        },
        {
            type = "unlock-recipe",
            recipe = "enchanted-lava"
        },
        {
            type = "unlock-recipe",
            recipe = "lava-science-pack-enchanted"
        },
        {
            type = "unlock-recipe",
            recipe = "low-density-structure-enchanted"
        }
    },
    prerequisites = { "advanced-circuit", "lava-science-pack" },
    unit = {
        count = 500,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "lava-science-pack",       2 }
        },
        time = 30
    },
}

return enchanter_tech
