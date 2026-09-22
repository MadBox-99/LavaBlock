-- Iron only, and no circuits. The burner crusher is meant to be buildable
-- before the factory has a steel furnace, because stone is what expands the
-- island and that starts on day one - so the part it is built out of cannot
-- ask for anything the player does not have yet.
--
-- Plain crafting, so it can be made by hand and in any assembler. A part
-- that needs its own machine to make is a gate, not a step.
return {
    type = "recipe",
    name = "crusher-roll",
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "item", name = "iron-plate",      amount = 6 },
        { type = "item", name = "iron-gear-wheel", amount = 4 },
    },
    results = { { type = "item", name = "crusher-roll", amount = 1 } },
}
