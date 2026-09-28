-- What a laser is made of: a ruby rod to lase, a diamond to carry the heat
-- off it, quartz lenses to focus it, and crystal circuit boards to drive it.
--
-- The first thing on the island built from the crystal line, and it is
-- priced like it: the diamond alone is twenty crystal-growing crafts on
-- average, and two boards are ten more. A player builds a handful of these,
-- not a row.
return {
    type = "recipe",
    name = "laser-cutter",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item", name = "crystal-circuit-board", amount = 2 },
        { type = "item", name = "ruby",                  amount = 2 },
        { type = "item", name = "diamond",               amount = 1 },
        { type = "item", name = "quartz-lens",           amount = 4 },
        { type = "item", name = "advanced-circuit",      amount = 10 },
        { type = "item", name = "steel-plate",           amount = 20 },
        { type = "item", name = "iron-gear-wheel",       amount = 10 },
    },
    results = {
        { type = "item", name = "laser-cutter", amount = 1 },
    },
}
