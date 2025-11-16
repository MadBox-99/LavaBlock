local air_cooler_recipe = {
    type = "recipe",
    name = "air-cooler",
    enabled = false,
    ingredients = {
        { type = "item", name = "iron-plate", amount = 1 }
    },
    results = {
        { type = "item", name = "air-cooler", amount = 1 }
    },
    energy_required = 1,
}

return air_cooler_recipe
