return {
    type = "recipe",
    name = "enchanted-science-pack",
    category = "enchanting",
    allow_productivity = true,
    enabled = false,
    crafting_machine_tint = {
        primary = { r = 0.8, g = 0.0, b = 1.0, a = 1.0 },
        secondary = { r = 1.0, g = 0.2, b = 1.0, a = 1.0 },
    },
    energy_required = 30,
    ingredients = {
        { type = "fluid", name = "enchanted-lava",        amount = 500 },
        { type = "item",  name = "enchanted-locomotive",  amount = 1 },
        { type = "item",  name = "enchanted-cargo-wagon", amount = 1 },
        { type = "item",  name = "enchanted-fluid-wagon", amount = 1 },
        { type = "item",  name = "lava-science-pack",     amount = 10 },
    },
    results = {
        { type = "item", name = "enchanted-science-pack", amount = 5 }
    },
}
