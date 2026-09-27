-- Dearer than the tank it is fed by: one column takes the wash of four
-- tanks, and it is a tower of trays with a reboiler, a condenser and a pump
-- where the tank is one vessel. The brick is the plinth it stands on.
return {
    type = "recipe",
    name = "distillation-column",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item", name = "steel-plate",        amount = 40 },
        { type = "item", name = "pipe",               amount = 30 },
        { type = "item", name = "iron-gear-wheel",    amount = 10 },
        { type = "item", name = "electronic-circuit", amount = 10 },
        { type = "item", name = "stone-brick",        amount = 20 },
    },
    results = {
        { type = "item", name = "distillation-column", amount = 1 }
    },
}
