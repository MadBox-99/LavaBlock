-- Mostly copper, because that is what a heat exchanger is made of and what
-- the water condenser was missing: built out of plates it cost no copper at
-- all, which said nothing about the job it does.
return {
    type = "recipe",
    name = "condenser-coil",
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "item", name = "copper-plate", amount = 4 },
        { type = "item", name = "pipe",         amount = 3 },
        { type = "item", name = "steel-plate",  amount = 1 },
    },
    results = { { type = "item", name = "condenser-coil", amount = 1 } },
}
