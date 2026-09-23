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
        },
        {
            -- The filter comes with the recipe that needs it. Splitting
            -- them across two technologies would leave a gap where you can
            -- research adsorption and own nothing able to run it.
            type = "unlock-recipe",
            recipe = "air-filter"
        },
        {
            type = "unlock-recipe",
            recipe = "air-electrostatic-adsorption"
        },
        {
            type = "unlock-recipe",
            recipe = "extract-copper-from-air"
        },
        {
            type = "unlock-recipe",
            recipe = "extract-iron-from-air"
        },
        {
            type = "unlock-recipe",
            recipe = "air-extraction"
        }
    },
    prerequisites = { "chemical-science-pack", "lava-science-pack" },
    unit = {
        count = 1000,
        ingredients = {
            { "lava-science-pack",     1 },
            { "chemical-science-pack", 2 }
        },
        time = 30
    },
}

return air_cooler_tech