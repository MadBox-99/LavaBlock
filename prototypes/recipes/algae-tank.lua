-- Four columns and four lamps, which is exactly what the model stands: the
-- tank is its columns, and building it out of plates said nothing about it.
-- The eight panels are the armoured glass they stand behind; the plate
-- count drops by what the panels bring, so the tank costs the same steel.
return {
    type = "recipe",
    name = "algae-tank",
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "item", name = "culture-column",     amount = 4 },
        { type = "item", name = "grow-lamp",          amount = 4 },
        { type = "item", name = "glazed-panel",       amount = 8 },
        { type = "item", name = "steel-plate",        amount = 12 },
        { type = "item", name = "electronic-circuit", amount = 15 },
        { type = "item", name = "pipe",               amount = 10 },
        { type = "item", name = "iron-gear-wheel",    amount = 15 },
    },
    results = {
        { type = "item", name = "algae-tank", amount = 1 }
    },
}
