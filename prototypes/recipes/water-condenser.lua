-- Four coils: two stacked in each of the two cooling columns on the model.
-- The coils carry the copper, which is what the condenser is really made of
-- and what a wall of plates never said.
return {
    type = "recipe",
    name = "water-condenser",
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "item", name = "condenser-coil",     amount = 4 },
        { type = "item", name = "steel-plate",        amount = 30 },
        { type = "item", name = "iron-gear-wheel",    amount = 25 },
        { type = "item", name = "electronic-circuit", amount = 35 },
        { type = "item", name = "pipe",               amount = 15 },
    },
    results = {
        { type = "item", name = "water-condenser", amount = 1 }
    },
}
