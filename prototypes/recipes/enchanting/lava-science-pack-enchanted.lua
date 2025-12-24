return {
    type = "recipe",
    name = "lava-science-pack-enchanted",
    category = "enchanting",
    allow_productivity = true,
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.8, g = 0.0, b = 1.0, a = 1.0 },
        secondary = { r = 1.0, g = 0.2, b = 1.0, a = 1.0 },
    },
    energy_required = 10,
    ingredients = {
        { type = "fluid", name = "enchanted-lava", amount = 100 },
        { type = "item",  name = "iron-gear-wheel", amount = 5 },
    },
    results = {
        { type = "item", name = "lava-science-pack", amount = 10 }
    },
}
