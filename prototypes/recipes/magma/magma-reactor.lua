-- The reactor is where the crystal line's rarest things go. Magnetite for
-- the containment coils, olivine for the refractory lining, diamond for the
-- sight glasses and crystal circuit boards to run it: the hundred olivine
-- alone is two hundred crystal-growing crafts.
--
-- One for every four turbines, so a player builds a few of these, ever.
return {
    type = "recipe",
    name = "magma-reactor",
    enabled = false,
    energy_required = 60,
    ingredients = {
        { type = "item", name = "magnetite",             amount = 50 },
        { type = "item", name = "olivine",               amount = 100 },
        { type = "item", name = "diamond",               amount = 5 },
        { type = "item", name = "crystal-circuit-board", amount = 20 },
        { type = "item", name = "processing-unit",       amount = 100 },
        { type = "item", name = "refined-concrete",      amount = 200 },
        { type = "item", name = "steel-plate",           amount = 200 },
    },
    results = {
        { type = "item", name = "magma-reactor", amount = 1 },
    },
}
