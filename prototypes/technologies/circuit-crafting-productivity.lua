local circuit_crafting_productivity = {
    type = "technology",
    name = "circuit-crafting-productivity",
    localised_name = "Circuit Crafting Productivity",
    localised_description = "Improves the productivity of electronic circuit manufacturing processes.",
    icons = {
        {
            icon = "__base__/graphics/icons/electronic-circuit.png",
            icon_size = 64,
            scale = 1.5,
            shift = { -32, -32 }
        },
        {
            icon = "__base__/graphics/icons/advanced-circuit.png",
            icon_size = 64,
            scale = 1.5,
            shift = { 32, -32 }
        },
        {
            icon = "__base__/graphics/icons/processing-unit.png",
            icon_size = 64,
            scale = 1.5,
            shift = { 0, 32 }
        },
        {
            floating = true,
            icon = "__core__/graphics/icons/technology/constants/constant-recipe-productivity.png",
            icon_size = 128,
            scale = 0.5,
            shift = { 50, 50 }
        }
    },
    effects = {
        {
            change = 0.1,
            recipe = "electronic-circuit",
            type = "change-recipe-productivity"
        },
        {
            change = 0.1,
            recipe = "advanced-circuit",
            type = "change-recipe-productivity"
        },
        {
            change = 0.05,
            recipe = "processing-unit",
            type = "change-recipe-productivity"
        }
    },
    prerequisites = {
        "processing-unit",
        "production-science-pack"
    },
    max_level = "infinite",
    unit = {
        count_formula = "1.2^L*500",
        ingredients = {
            { "automation-science-pack",      1 },
            { "logistic-science-pack",        1 },
            { "chemical-science-pack",        1 },
            { "production-science-pack",      1 },
            { "electromagnetic-science-pack", 1 },
            { "circuit-science-pack",         2 }
        },
        time = 45
    },
    upgrade = true,
    order = "c-k-f-e[circuit-crafting-productivity]"
}
return circuit_crafting_productivity