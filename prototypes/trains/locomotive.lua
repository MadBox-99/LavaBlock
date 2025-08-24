local recipe = {
    type = "recipe",
    name = "locomotive",
    energy_required = 60,
    enabled = false,
    category = "crafting-with-fluid",
    ingredients =
    {
        { type = "item",  name = "electronic-circuit", amount = 10 },
        { type = "item",  name = "engine-unit",        amount = 20 },
        { type = "item",  name = "iron-gear-wheel",    amount = 1000 }, -- piece(s) / real-wagon: 10000
        { type = "fluid", name = "lava",               amount = 100000 }
    },
    results = {
        { type = "item", name = "locomotive", amount = 1 },
        { type = "item", name = "stone",      amount = 50 } } --slug --test-feature
}
data.raw["recipe"]["locomotive"] = recipe
