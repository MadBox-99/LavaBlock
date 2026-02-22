local pyroclast_science_pack_technology = {
    type = "technology",
    name = "pyroclast-science-pack",
    icons = {
        {
            icon = "__base__/graphics/icons/production-science-pack.png",
            icon_size = 64,
            tint = { r = 0.7, g = 0.15, b = 0.05, a = 1 } -- deep volcanic red
        }
    },
    effects = {
        { type = "unlock-recipe", recipe = "obsidian-extraction" },
        { type = "unlock-recipe", recipe = "pyroclast-science-pack" }
    },
    prerequisites = { "military-science-pack-2", "enchanted-science-pack", "planet-discovery-pyroclast" },
    unit = {
        count = 500,
        ingredients = {
            { "automation-science-pack",  1 },
            { "logistic-science-pack",    1 },
            { "chemical-science-pack",    1 },
            { "production-science-pack",  1 },
            { "utility-science-pack",     1 },
            { "lava-science-pack",        5 },
            { "enchanted-science-pack",   3 },
        },
        time = 60
    },
    order = "c-a-e[pyroclast-science-pack]"
}
return pyroclast_science_pack_technology
