return {
    type = "technology",
    name = "lava-efficiency-module-3",
    icon = "__base__/graphics/technology/efficiency-module-3.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "lava-efficiency-module-3"
        }
    },
    prerequisites = { "lava-efficiency-module-2", "efficiency-module-3" },
    unit = {
        count = 1000,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack", 1 },
            { "chemical-science-pack", 1 },
            { "lava-science-pack", 1 },
            { "space-science-pack", 1 }
        },
        time = 60
    },
    order = "i-b-b"
}
