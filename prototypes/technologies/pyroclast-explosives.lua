return {
    type = "technology",
    name = "pyroclast-explosives",
    icons = {
        {
            icon = "__base__/graphics/icons/explosives.png",
            icon_size = 64,
            tint = { r = 0.9, g = 0.4, b = 0.2, a = 1 },
            scale = 2,
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "emat" },
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
    order = "c-a-e[pyroclast-explosives]"
}
