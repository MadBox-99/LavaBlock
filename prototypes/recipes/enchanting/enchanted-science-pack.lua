return {
    type = "recipe",
    name = "enchanted-science-pack",
    category = "crafting-with-fluid",
    allow_productivity = true,
    enabled = false,
    energy_required = 30,
    ingredients = {
        { type = "fluid", name = "lava",                    amount = 5000 },
        { type = "item",  name = "automation-science-pack", amount = 5 },
        { type = "item",  name = "logistic-science-pack",   amount = 5 },
        { type = "item",  name = "chemical-science-pack",   amount = 5 },
        { type = "item",  name = "lava-science-pack",       amount = 10 },
    },
    results = {
        { type = "item", name = "enchanted-science-pack", amount = 5 }
    },
}
