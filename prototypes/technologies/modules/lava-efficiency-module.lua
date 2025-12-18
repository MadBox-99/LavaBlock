return {
    type = "technology",
    name = "lava-efficiency-module",
    icon = "__base__/graphics/technology/efficiency-module-1.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "lava-efficiency-module"
        }
    },
    prerequisites = { "lava-modules" },
    unit = {
        count = 500,
        ingredients = {
            { "lava-science-pack", 1 }
        },
        time = 30
    },
    order = "i-b"
}
