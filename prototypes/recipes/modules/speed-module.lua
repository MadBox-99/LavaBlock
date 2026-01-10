return {
    type = "recipe",
    name = "lava-speed-module",
    energy_required = 10,
    enabled = false,
    ingredients = {
        { type = "item",  name = "advanced-circuit", amount = 10 },
        { type = "item",  name = "electronic-circuit", amount = 10 },
        { type = "fluid", name = "lava", amount = 10000 }
    },
    results = {
        { type = "item", name = "speed-module", amount = 2 }
    },
    category = "crafting-with-fluid",
    allow_productivity = false
}
