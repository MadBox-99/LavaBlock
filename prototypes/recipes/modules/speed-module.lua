return {
    type = "recipe",
    name = "lava-speed-module",
    energy_required = 10,
    enabled = false,
    ingredients = {
        { type = "item",  name = "advanced-circuit", amount = 5 },
        { type = "item",  name = "electronic-circuit", amount = 5 },
        { type = "fluid", name = "lava", amount = 5000 }
    },
    results = {
        { type = "item", name = "speed-module", amount = 1 }
    },
    category = "crafting-with-fluid",
    allow_productivity = false
}
