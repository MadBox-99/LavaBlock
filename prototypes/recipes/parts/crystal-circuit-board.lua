-- A sapphire for the board, a ruby at its heart, two pyrite for contacts,
-- and ordinary circuits and wire for the rest.
--
-- One of each corundum per board because the hearth grows them at the same
-- rate; two pyrite because it grows more than twice as many of those. What
-- is left over - the olivine, and the odd pyrite - goes to the crusher.
-- Diamonds are worth keeping: the laser cutter takes one each.
return {
    type = "recipe",
    name = "crystal-circuit-board",
    category = "electronics",
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "item", name = "sapphire",           amount = 1 },
        { type = "item", name = "ruby",               amount = 1 },
        { type = "item", name = "pyrite",             amount = 2 },
        { type = "item", name = "electronic-circuit", amount = 3 },
        { type = "item", name = "copper-cable",       amount = 4 },
    },
    results = {
        { type = "item", name = "crystal-circuit-board", amount = 1 },
    },
}
