-- Ammonia taken up with phosphorus and potash into fertiliser granules in a
-- chemical plant. 20 ammonia, a phosphorus and a potash for four.
return {
    type = "recipe",
    name = "fertilizer",
    category = "chemistry",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item",  name = "phosphorus", amount = 1 },
        { type = "item",  name = "potash",     amount = 1 },
        { type = "fluid", name = "ammonia",    amount = 20 },
    },
    results = {
        { type = "item", name = "fertilizer", amount = 4 },
    },
    allow_productivity = true,
    crafting_machine_tint = {
        primary = { r = 0.60, g = 0.75, b = 0.40, a = 1.0 },
        secondary = { r = 0.90, g = 0.62, b = 0.60, a = 1.0 },
    },
}
