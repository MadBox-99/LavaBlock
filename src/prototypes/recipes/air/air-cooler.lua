local air_cooler_recipe = {
    type = "recipe",
    name = "air-cooler",
    enabled = false,
    ingredients = {
        { type = "item", name = "iron-plate",      amount = 1000 },
        { type = "item", name = "steel-plate",     amount = 500 },
        { type = "item", name = "iron-gear-wheel", amount = 200 },
        { type = "item", name = "pipe",            amount = 100 },
    },
    results = {
        { type = "item", name = "air-cooler", amount = 1 }
    },
    energy_required = 30,
}

return air_cooler_recipe
