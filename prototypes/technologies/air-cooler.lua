local air_cooler_tech = {
    type = "technology",
    name = "air-cooler",
    icon = "__LavaBlock__/graphics/air_cooler_tech.png",
    icon_size = 64,
    effects = {
        {
            type = "unlock-recipe",
            recipe = "air-cooler"
        },
        {
            type = "unlock-recipe",
            recipe = "liquid-nitrogen-production"
        }
    },
    prerequisites = { "chemical-science-pack" },
    unit = {
        count = 3000,
        ingredients = {
            { "chemical-science-pack", 1 }
        },
        time = 30
    },
}

return air_cooler_tech
