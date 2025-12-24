return {
    type = "recipe",
    name = "stronger-fusioning-lava",
    category = "enchanting",
    enabled = false,
    ingredients = {
        { type = "fluid", name = "fusioning-lava",  amount = 500 },
        { type = "item",  name = "base-magma-ball", amount = 10 },
    },
    results = {
        { type = "fluid", name = "stronger-fusioning-lava", amount = 500 }
    },
    energy_required = 20,
    crafting_machine_tint = {
        primary = { r = 1.0, g = 0.2, b = 0.0, a = 1.0 },
        secondary = { r = 1.0, g = 0.4, b = 0.1, a = 1.0 },
    }
}
