local enchanter_recipe = {
    type = "recipe",
    name = "enchanter",
    enabled = false,
    ingredients = {
        { type = "item", name = "steel-plate",        amount = 100 },
        { type = "item", name = "iron-gear-wheel",    amount = 100 },
        { type = "item", name = "electronic-circuit", amount = 200 },
        { type = "item", name = "pipe",               amount = 50 },
    },
    results = {
        { type = "item", name = "enchanter", amount = 1 }
    },
    energy_required = 30,
}

return enchanter_recipe
