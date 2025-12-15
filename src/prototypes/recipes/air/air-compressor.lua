local air_compressor_recipe = {
    type = "recipe",
    name = "air-compressor",
    enabled = false,
    ingredients = {
        { type = "item", name = "iron-plate",      amount = 100 },
        { type = "item", name = "steel-plate",     amount = 50 },
        { type = "item", name = "iron-gear-wheel", amount = 20 },
        { type = "item", name = "pipe",            amount = 10 },
    },
    results = {
        { type = "item", name = "air-compressor", amount = 1 }
    },
    energy_required = 30,
}
data:extend({ air_compressor_recipe })