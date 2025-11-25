local air_extraction = {
    type = "recipe",
    name = "air-extraction",
    energy_required = 4,
    enabled = true,
    ingredients = {
        { type = "fluid", name = "compressed-air", amount = 500 }
    },
    results = {
        { type = "fluid", name = "air", amount = 100 }
    },
    icon = "__base__/graphics/icons/coal.png",
    icon_size = 64,
    category = "chemistry",
    subgroup = "fluid-recipes"
}
return air_extraction