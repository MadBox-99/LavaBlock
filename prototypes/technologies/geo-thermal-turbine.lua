local geo_thermal_turbine = {
    type = "technology",
    name = "geo-thermal-turbine",
    icon = "__LavaBlock__/graphics/icons/entity/geo-thermal-turbine.png",
    icon_size = 64,
    effects =
    {
        {
            type = "unlock-recipe",
            recipe = "geo-thermal-turbine"
        }
    },
    prerequisites = { "advanced-lava-cooling" },
    unit =
    {
        count = 2000,
        ingredients =
        {
            { "automation-science-pack", 1 },
            { "logistic-science-pack",   1 },
            { "chemical-science-pack",   1 }
        },
        time = 30
    },
    order = "a-q-z"
}

return geo_thermal_turbine