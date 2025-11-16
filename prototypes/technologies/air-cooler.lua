local air_cooler_tech = {
    type = "technology",
    name = "air-cooler",
    icon = "__base__/graphics/icons/chemical-plant.png",
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
    prerequisites = { "automation-science-pack" },
    unit = {
        count = 50,
        ingredients = {
            { "automation-science-pack", 1 }
        },
        time = 30
    },
}

return air_cooler_tech
