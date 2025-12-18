return {
    type = "recipe",
    name = "lava-flying-robot-frame",
    energy_required = 10,
    enabled = false,
    ingredients = {
        { type = "item",  name = "electric-engine-unit", amount = 1 },
        { type = "item",  name = "battery",              amount = 2 },
        { type = "item",  name = "electronic-circuit",   amount = 3 },
        { type = "fluid", name = "lava",                 amount = 5000 }
    },
    results = {
        { type = "item", name = "flying-robot-frame", amount = 1 }
    },
    category = "crafting-with-fluid",
    allow_productivity = true
}
