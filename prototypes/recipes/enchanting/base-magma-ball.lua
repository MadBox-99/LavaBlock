return {
    type = "recipe",
    name = "base-magma-ball",
    category = "enchanting",
    enabled = false,
    ingredients = {
        { type = "fluid", name = "lava", amount = 1000 },
        { type = "item",  name = "coal", amount = 10 },
    },
    results = {
        { type = "item", name = "base-magma-ball", amount = 5 }
    },
    energy_required = 10,
    crafting_machine_tint = {
        primary = { r = 1.0, g = 0.5, b = 0.0, a = 1.0 },
        secondary = { r = 1.0, g = 0.3, b = 0.0, a = 1.0 },
    }
}
