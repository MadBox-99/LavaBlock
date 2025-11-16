local lava_cooling = {
    type = "recipe",
    name = "lava-cooling",
    energy_required = 5,
    enabled = true,
    ingredients = {
        { type = "fluid", name = "lava", amount = 100 }
    },
    results = {
        { type = "fluid", name = "steam", amount = 70, temperature = 165 }
    },
    icon = "__LavaBlock__/graphics/icons/lava-cooling.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
}
return lava_cooling
