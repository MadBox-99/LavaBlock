-- Steel for the frame and pipe for the plumbing that has to reach every
-- column. Unlocked by algae-cultivation, with the tank that is four of them.
return {
    type = "recipe",
    name = "culture-column",
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "item", name = "steel-plate", amount = 3 },
        { type = "item", name = "pipe",        amount = 5 },
    },
    results = { { type = "item", name = "culture-column", amount = 1 } },
}
