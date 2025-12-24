return {
    type = "recipe",
    name = "enchanted-lava",
    category = "enchanting",
    enabled = false,
    ingredients = {
        { type = "fluid", name = "stronger-fusioning-lava", amount = 500 },
        { type = "item",  name = "base-magma-ball",         amount = 20 },
    },
    results = {
        { type = "fluid", name = "enchanted-lava", amount = 500 }
    },
    energy_required = 30,
    crafting_machine_tint = {
        primary = { r = 0.8, g = 0.0, b = 1.0, a = 1.0 },
        secondary = { r = 1.0, g = 0.2, b = 1.0, a = 1.0 },
    }
}
