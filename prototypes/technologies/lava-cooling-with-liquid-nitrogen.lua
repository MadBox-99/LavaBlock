local lava_cooling_with_liquid_nitrogen = {
    type = "technology",
    name = "cryogenic-cooling",
    icon = "__LavaBlock__/graphics/icons/entity/geo-thermal-turbine.png",
    icon_size = 64,
    effects =
    {
        {
            type = "unlock-recipe",
            recipe = "lava-cooling-with-liquid-nitrogen"
        }
    },
    prerequisites = { "advanced-lava-cooling" },
    unit =
    {
        count = 500,
        ingredients =
        {
            { "chemical-science-pack", 1 }
        },
        time = 30
    },
    order = "a-q-z"
}
data:extend({ lava_cooling_with_liquid_nitrogen })