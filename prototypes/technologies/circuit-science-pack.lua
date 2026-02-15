local circuit_science_pack_technology = {
    type = "technology",
    name = "circuit-science-pack",
    localised_name = "Circuit Science Pack",
    localised_description = "Unlock the Circuit Science Pack for advanced electronics research.",
    icons = {
        {
            icon = "__base__/graphics/icons/production-science-pack.png",
            icon_size = 64,
            tint = { r = 0.2, g = 0.8, b = 0.3, a = 1 } -- Green tint for circuits
        }
    },
    effects = {
        {
            type = "unlock-recipe",
            recipe = "circuit-science-pack"
        }
    },
    prerequisites = {
        "processing-unit",
        "production-science-pack"
    },
    unit = {
        count = 300,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "production-science-pack", 1 }
        },
        time = 30
    },
    order = "c-a-d[circuit-science-pack]"
}
return circuit_science_pack_technology