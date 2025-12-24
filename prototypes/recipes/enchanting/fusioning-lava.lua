return {
    type = "recipe",
    name = "fusioning-lava",
    category = "enchanting",
    enabled = false,
    ingredients = {
        { type = "fluid", name = "lava",            amount = 500 },
        { type = "item",  name = "base-magma-ball", amount = 5 },
    },
    results = {
        { type = "fluid", name = "fusioning-lava", amount = 500 }
    },
    energy_required = 15,
    crafting_machine_tint = {
        primary = { r = 1.0, g = 0.4, b = 0.0, a = 1.0 },
        secondary = { r = 1.0, g = 0.6, b = 0.2, a = 1.0 },
    }
}
