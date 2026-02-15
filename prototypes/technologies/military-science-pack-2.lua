local military_science_pack_2_technology = {
    type = "technology",
    name = "military-science-pack-2",
    localised_description =
    "Unlock advanced military research capabilities using cutting-edge weaponry and defense systems.",
    icons = {
        {
            icon = "__base__/graphics/icons/military-science-pack.png",
            icon_size = 64,
            tint = { r = 0.4, g = 0.4, b = 0.4, a = 1 } -- Darkened tint
        }
    },
    effects = {
        {
            type = "unlock-recipe",
            recipe = "military-science-pack-2"
        }
    },
    prerequisites = {
        "military-science-pack",
        "railgun",
        "tesla-weapons",
        "artillery",
        "uranium-processing",
        "electromagnetic-plant"
    },
    unit = {
        count = 500,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "military-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "production-science-pack", 1 },
            { "utility-science-pack",    1 },
            { "space-science-pack",      1 }
        },
        time = 45
    },
    order = "e-a-c"
}
return military_science_pack_2_technology