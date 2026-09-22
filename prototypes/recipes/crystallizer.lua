-- Brick for the hearth, because the thing holds a pan of melt all day, and
-- pipe for the lava line that feeds it. No advanced circuits: this is an
-- early building, and it has to be buildable with what a player has before
-- the first glasshouse goes up.
return {
    type = "recipe",
    name = "crystallizer",
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "item", name = "steel-plate",        amount = 30 },
        { type = "item", name = "iron-gear-wheel",    amount = 20 },
        { type = "item", name = "electronic-circuit", amount = 20 },
        { type = "item", name = "pipe",               amount = 10 },
        { type = "item", name = "stone-brick",        amount = 30 },
    },
    results = {
        { type = "item", name = "crystallizer", amount = 1 }
    },
}
