return {
    type = "recipe",
    name = "low-density-structure-enchanted",
    category = "enchanting",
    allow_productivity = true,
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.8, g = 0.0, b = 1.0, a = 1.0 },
        secondary = { r = 1.0, g = 0.2, b = 1.0, a = 1.0 },
    },
    energy_required = 15,
    ingredients = {
        { type = "fluid", name = "enchanted-lava", amount = 200 },
        { type = "item",  name = "copper-plate",   amount = 10 },
        { type = "item",  name = "steel-plate",    amount = 5 },
        { type = "item",  name = "plastic-bar",    amount = 25 },
    },
    results = {
        { type = "item", name = "low-density-structure", amount = 5 }
    },
}