return {
    type = "technology",
    name = "lava-flying-robot-frame",
    icon = "__base__/graphics/technology/robotics.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "lava-flying-robot-frame"
        }
    },
    prerequisites = { "lava-science-pack", "robotics" },
    unit = {
        count = 500,
        ingredients = {
            { "lava-science-pack", 1 }
        },
        time = 30
    },
    order = "i-d"
}
