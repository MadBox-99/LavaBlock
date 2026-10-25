-- Two cells: two cathodes, a carbon for the graphite anode, a copper plate
-- for the anode's foil, a plastic bar for the separator film, and ten
-- electrolyte to fill the cans. Wound, filled, closed and formed on the
-- cell line.
return {
    type = "recipe",
    name = "lithium-ion-cell",
    categories = { "cell-assembling" },
    enabled = false,
    energy_required = 6,
    ingredients = {
        { type = "item",  name = "nmc-cathode",         amount = 2 },
        { type = "item",  name = "carbon",              amount = 1 },
        { type = "item",  name = "copper-plate",        amount = 1 },
        { type = "item",  name = "plastic-bar",         amount = 1 },
        { type = "fluid", name = "lithium-electrolyte", amount = 10 },
    },
    results = {
        { type = "item", name = "lithium-ion-cell", amount = 2 },
    },
    allow_productivity = true,
}
