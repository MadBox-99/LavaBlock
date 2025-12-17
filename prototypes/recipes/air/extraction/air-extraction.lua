local air_extraction = {
    type = "recipe",
    name = "air-extraction",
    energy_required = 4,
    enabled = false,
    ingredients = {},
    results = {
        { type = "fluid", name = "compressed-air", amount = 100 }
    },
    icon = "__LavaBlock__/graphics/icons/gas/compressed-air.png",
    icon_size = 128,
    category = "gas",
    subgroup = "fluid-recipes"
}
return air_extraction