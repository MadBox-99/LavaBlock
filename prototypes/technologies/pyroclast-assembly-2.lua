return {
    type = "technology",
    name = "pyroclast-assembly-2",
    icons = {
        {
            icon = "__base__/graphics/icons/iron-gear-wheel.png",
            icon_size = 64,
            tint = { r = 0.4, g = 0.6, b = 0.8, a = 1 },
            scale = 2,
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "assmat2" },
    },
    prerequisites = { "pyroclast-assembly-1" },
    unit = {
        count = 400,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "production-science-pack", 1 },
            { "lava-science-pack",       3 },
        },
        time = 30
    },
    upgrade = true,
    order = "c-a-h[pyroclast-assembly-2]"
}
