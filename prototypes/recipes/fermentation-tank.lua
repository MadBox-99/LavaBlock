-- A closed steel vessel with an agitator and a cooling jacket. Steel because
-- a ferment is mildly acidic and eats plain iron, and circuits because the
-- jacket has to hold the brew at the temperature the yeast works at.
return {
    type = "recipe",
    name = "fermentation-tank",
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "item", name = "steel-plate",        amount = 20 },
        { type = "item", name = "pipe",               amount = 20 },
        { type = "item", name = "iron-gear-wheel",    amount = 10 },
        { type = "item", name = "electronic-circuit", amount = 5 },
    },
    results = {
        { type = "item", name = "fermentation-tank", amount = 1 }
    },
}
