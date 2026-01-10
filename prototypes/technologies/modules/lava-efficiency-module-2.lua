return {
    type = "technology",
    name = "lava-efficiency-module-2",
    icon = "__base__/graphics/technology/efficiency-module-2.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "lava-efficiency-module-2"
        }
    },
    prerequisites = { "lava-efficiency-module", "efficiency-module-2" },
    unit = {
        count = 750,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack", 1 },
            { "chemical-science-pack", 1 },
            { "lava-science-pack", 1 },
            { "space-science-pack", 1 }
        },
        time = 30
    },
    order = "i-b-a"
}
