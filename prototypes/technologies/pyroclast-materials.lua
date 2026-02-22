return {
    type = "technology",
    name = "pyroclast-materials",
    icons = {
        {
            icon = "__base__/graphics/icons/iron-plate.png",
            icon_size = 64,
            tint = { r = 0.5, g = 0.55, b = 0.3, a = 1 },
            scale = 2,
            shift = { -16, 0 },
        },
        {
            icon = "__base__/graphics/icons/steel-plate.png",
            icon_size = 64,
            tint = { r = 0.35, g = 0.4, b = 0.3, a = 1 },
            scale = 2,
            shift = { 16, 0 },
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "bmat" },
        { type = "unlock-recipe", recipe = "cmat" },
    },
    prerequisites = { "planet-discovery-pyroclast" },
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
    order = "c-a-d[pyroclast-materials]"
}
