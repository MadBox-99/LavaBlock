return {
    type = "technology",
    name = "lava-modules",
    icon = "__base__/graphics/technology/module.png",
    icon_size = 256,
    effects = {},
    prerequisites = { "lava-science-pack", "modules" },
    unit = {
        count = 1000,
        ingredients = {
            { "lava-science-pack", 1 }
        },
        time = 30
    },
    order = "i-a"
}
