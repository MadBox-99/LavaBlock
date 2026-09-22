-- Four columns and four lamps, which is exactly what the model stands: the
-- tank is its columns, and building it out of plates said nothing about it.
return {
    type = "recipe",
    name = "algae-tank",
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "item", name = "culture-column",     amount = 4 },
        { type = "item", name = "grow-lamp",          amount = 4 },
        { type = "item", name = "steel-plate",        amount = 20 },
        { type = "item", name = "electronic-circuit", amount = 15 },
        { type = "item", name = "pipe",               amount = 10 },
        { type = "item", name = "iron-gear-wheel",    amount = 15 },
    },
    results = {
        { type = "item", name = "algae-tank", amount = 1 }
    },
}
