-- Building the three roll crushers. The burner is deliberately cheap and
-- circuit-free: it is meant to be available before the factory has much of
-- anything, because stone is what expands the island. The other two are
-- upgrades in the literal sense - each is built out of the one below it.
--
-- The rolls themselves are a part now, so the machine is two crafts deep
-- rather than one, and the thing the crusher is actually made of has a name.
local RECIPES = {
    {
        type = "recipe",
        name = "burner-roll-crusher",
        enabled = false,
        energy_required = 5,
        ingredients = {
            { type = "item", name = "crusher-roll",    amount = 2 },
            { type = "item", name = "iron-plate",      amount = 12 },
            { type = "item", name = "iron-gear-wheel", amount = 10 },
            { type = "item", name = "stone-brick",     amount = 15 },
        },
        results = { { type = "item", name = "burner-roll-crusher", amount = 1 } },
    },
    {
        type = "recipe",
        name = "roll-crusher",
        enabled = false,
        energy_required = 8,
        ingredients = {
            { type = "item", name = "burner-roll-crusher", amount = 1 },
            { type = "item", name = "steel-plate",         amount = 20 },
            { type = "item", name = "electronic-circuit",  amount = 10 },
        },
        results = { { type = "item", name = "roll-crusher", amount = 1 } },
    },
    {
        type = "recipe",
        name = "industrial-roll-crusher",
        enabled = false,
        energy_required = 12,
        ingredients = {
            { type = "item", name = "roll-crusher",     amount = 1 },
            -- A fresh pair of rolls. The industrial machine runs the same
            -- two drums nearly twice as fast, and the electric one's are
            -- worn by the time you get here.
            { type = "item", name = "crusher-roll",     amount = 2 },
            { type = "item", name = "steel-plate",      amount = 30 },
            { type = "item", name = "advanced-circuit", amount = 10 },
            { type = "item", name = "iron-gear-wheel",  amount = 20 },
        },
        results = { { type = "item", name = "industrial-roll-crusher", amount = 1 } },
    },
}
return RECIPES
