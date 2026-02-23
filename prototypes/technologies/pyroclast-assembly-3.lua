return {
    type = "technology",
    name = "pyroclast-assembly-3",
    icons = {
        {
            icon = "__base__/graphics/icons/iron-gear-wheel.png",
            icon_size = 64,
            tint = { r = 0.6, g = 0.3, b = 0.8, a = 1 },
            scale = 2,
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "assmat3" },
    },
    prerequisites = { "pyroclast-assembly-2", "pyroclast-refined" },
    unit = {
        count = 500,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "production-science-pack", 1 },
            { "lava-science-pack",       3 },
            { "pyroclast-science-pack",  1 },
        },
        time = 45
    },
    upgrade = true,
    order = "c-a-h[pyroclast-assembly-3]"
}
