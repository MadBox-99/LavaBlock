return {
    type = "technology",
    name = "lava-speed-module",
    icon = "__base__/graphics/technology/speed-module-1.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "lava-speed-module"
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
    order = "i-c"
}
