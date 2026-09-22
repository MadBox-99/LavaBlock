-- Steel for the frame, glass for the column itself and pipe for the
-- plumbing that has to reach every one. Raw glass rather than a glazed
-- panel: a panel is a flat wall with a frame round it, and this is a tube.
-- Unlocked by algae-cultivation, with the tank that is four of them.
return {
    type = "recipe",
    name = "culture-column",
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "item", name = "steel-plate", amount = 2 },
        { type = "item", name = "glass",       amount = 2 },
        { type = "item", name = "pipe",        amount = 5 },
    },
    results = { { type = "item", name = "culture-column", amount = 1 } },
}
