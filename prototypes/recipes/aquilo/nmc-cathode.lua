-- The cathode, coated and calendered on the cell line: a lithium plate and
-- one each of nickel, manganese and cobalt for the NMC 111 oxide, on an
-- aluminium plate rolled out to foil. Four cathodes, two cells' worth.
return {
    type = "recipe",
    name = "nmc-cathode",
    categories = { "cell-assembling" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item", name = "lithium-plate",   amount = 1 },
        { type = "item", name = "nickel-plate",    amount = 1 },
        { type = "item", name = "manganese-plate", amount = 1 },
        { type = "item", name = "cobalt-plate",    amount = 1 },
        { type = "item", name = "aluminium-plate", amount = 1 },
    },
    results = {
        { type = "item", name = "nmc-cathode", amount = 4 },
    },
    allow_productivity = true,
}
