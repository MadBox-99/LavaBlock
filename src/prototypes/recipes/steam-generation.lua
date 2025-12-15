local steam_generation = {
    type = "recipe",
    name = "steam-generation",
    energy_required = 1,
    enabled = true,
    ingredients = {
        { type = "fluid", name = "lava", amount = 5000 },
        { type = "item",  name = "wood", amount = 1 },
        { type = "item",  name = "coal", amount = 5 }

    },
    results = {
        { type = "fluid", name = "steam", amount = 5000, temperature = 165 }
    },
    icon = "__base__/graphics/icons/fluid/steam.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes",
}
return steam_generation
