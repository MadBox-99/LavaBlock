return {
    type = "technology",
    name = "pyroclast-refined",
    icons = {
        {
            icon = "__base__/graphics/icons/copper-plate.png",
            icon_size = 64,
            tint = { r = 0.3, g = 0.4, b = 0.7, a = 1 },
            scale = 2,
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "rmat" },
    },
    prerequisites = { "pyroclast-materials" },
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
    order = "c-a-f[pyroclast-refined]"
}
