local air_extraction = {
    type = "recipe",
    name = "air-collection",
    energy_required = 4,
    enabled = true,
    ingredients = {},
    results = {
        { type = "fluid", name = "air", amount = 100 }
    },
    icon = "__base__/graphics/icons/coal.png",
    icon_size = 64,
    category = "gas",
    subgroup = "fluid-recipes"
}
return air_extraction