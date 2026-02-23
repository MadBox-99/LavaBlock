return {
    type = "technology",
    name = "pyroclast-assembly-1",
    icons = {
        {
            icon = "__base__/graphics/icons/iron-gear-wheel.png",
            icon_size = 64,
            tint = { r = 0.6, g = 0.8, b = 0.4, a = 1 },
            scale = 2,
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "assmat1" },
    },
    prerequisites = { "pyroclast-materials" },
    unit = {
        count = 300,
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
    order = "c-a-h[pyroclast-assembly-1]"
}
