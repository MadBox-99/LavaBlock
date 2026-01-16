local enchanted_science_pack_technology = {
    type = "technology",
    name = "enchanted-science-pack",
    icon = "__base__/graphics/technology/utility-science-pack.png",
    icon_size = 256,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "enchanted-science-pack"
        }
    },
    prerequisites = { "lava-science-pack", "chemical-science-pack" },
    unit = {
        count = 1000,
        ingredients = {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 },
            { "lava-science-pack",       3 }
        },
        time = 45
    },
    order = "c-b"
}
return enchanted_science_pack_technology
