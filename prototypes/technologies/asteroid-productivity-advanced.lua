local asteroid_productivity_advanced = {
    type = "technology",
    name = "asteroid-productivity-advanced",
    localised_name = "Asteroid Productivity (Advanced)",
    localised_description = "Increases productivity of advanced asteroid crushing operations.",
    icons = {
        {
            icon = "__space-age__/graphics/technology/asteroid-productivity.png",
            icon_size = 256,
            tint = { r = 0.8, g = 0.8, b = 1.0, a = 1 } -- Blue tint for advanced
        },
        {
            floating = true,
            icon = "__core__/graphics/icons/technology/constants/constant-mining-productivity.png",
            icon_size = 128,
            scale = 0.5,
            shift = { 50, 50 }
        }
    },
    effects = {
        {
            change = 0.1,
            recipe = "advanced-carbonic-asteroid-crushing",
            type = "change-recipe-productivity"
        },
        {
            change = 0.1,
            recipe = "advanced-oxide-asteroid-crushing",
            type = "change-recipe-productivity"
        },
        {
            change = 0.1,
            recipe = "advanced-metallic-asteroid-crushing",
            type = "change-recipe-productivity"
        }
    },
    prerequisites = { "advanced-asteroid-processing", "military-science-pack-2" },
    max_level = "infinite",
    unit = {
        count_formula = "1.5^L*1000",
        ingredients = {
            { "automation-science-pack",   1 },
            { "logistic-science-pack",     1 },
            { "chemical-science-pack",     1 },
            { "production-science-pack",   1 },
            { "utility-science-pack",      1 },
            { "space-science-pack",        1 },
            { "agricultural-science-pack", 1 },
            { "lava-science-pack",         1 },
            { "military-science-pack-2",   1 }
        },
        time = 60
    },
    upgrade = true,
    order = "e-p-a-b[asteroid-productivity-advanced]"
}
return asteroid_productivity_advanced