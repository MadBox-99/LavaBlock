-- Pipe and steel for the gas side, and glass for the sight window the
-- machine is read by. The only new machine so far that needs the glass
-- line to build rather than just to justify it.
return {
    type = "recipe",
    name = "gas-combiner",
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "item", name = "steel-plate",        amount = 35 },
        { type = "item", name = "glass",              amount = 8 },
        { type = "item", name = "pipe",               amount = 25 },
        { type = "item", name = "iron-gear-wheel",    amount = 20 },
        { type = "item", name = "advanced-circuit",   amount = 10 },
    },
    results = {
        { type = "item", name = "gas-combiner", amount = 1 }
    },
}
