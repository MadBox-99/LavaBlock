-- Molten quartz poured into a lens mould. An assembler with a fluid input
-- does the casting, as it does for anything else the island pours.
return {
    type = "recipe",
    name = "quartz-lens",
    category = "crafting-with-fluid",
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "fluid", name = "molten-quartz", amount = 50 },
    },
    results = {
        { type = "item", name = "quartz-lens", amount = 1 },
    },
    allow_productivity = true,
}
