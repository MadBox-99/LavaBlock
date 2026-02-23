return {
    type = "technology",
    name = "pyroclast-assembly-4",
    icons = {
        {
            icon = "__base__/graphics/icons/iron-gear-wheel.png",
            icon_size = 64,
            tint = { r = 0.9, g = 0.7, b = 0.2, a = 1 },
            scale = 2,
        },
    },
    effects = {
        { type = "unlock-recipe", recipe = "assmat4" },
        { type = "unlock-recipe", recipe = "pyroclast-rocket-silo" },
    },
    prerequisites = { "pyroclast-assembly-3", "pyroclast-heavy-explosives" },
    unit = {
        count = 600,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "production-science-pack", 1 },
            { "lava-science-pack",       3 },
            { "pyroclast-science-pack",  1 },
        },
        time = 60
    },
    upgrade = true,
    order = "c-a-h[pyroclast-assembly-4]"
}
