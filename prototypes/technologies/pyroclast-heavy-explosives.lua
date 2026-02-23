return {
    type = "technology",
    name = "pyroclast-heavy-explosives",
    icons = {
        {
            icon = "__base__/graphics/icons/steel-plate.png",
            icon_size = 64,
            tint = { r = 0.7, g = 0.15, b = 0.15, a = 1 },
            scale = 2,
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "hemat" },
    },
    prerequisites = { "pyroclast-explosives", "pyroclast-refined" },
    unit = {
        count = 500,
        ingredients = {
            { "automation-science-pack",  1 },
            { "logistic-science-pack",    1 },
            { "chemical-science-pack",    1 },
            { "production-science-pack",  1 },
            { "lava-science-pack",        3 },
            { "pyroclast-science-pack",   1 },
        },
        time = 45
    },
    order = "c-a-g[pyroclast-heavy-explosives]"
}
