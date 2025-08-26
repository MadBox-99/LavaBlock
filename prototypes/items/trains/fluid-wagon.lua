local recipe = {
    type = "recipe",
    name = "fluid-wagon",
    energy_required = 30,
    enabled = false,
    category = "crafting-with-fluid",
    ingredients =
    {
        { type = "item",  name = "storage-tank",       amount = 3 },
        { type = "item",  name = "pipe",               amount = 500 },  -- piece(s) / real-wagon: 1000-2000
        { type = "item",  name = "electronic-circuit", amount = 10 },
        { type = "item",  name = "solar-panel",        amount = 1 },    -- piece(s) / real-wagon: 4000-8000
        { type = "item",  name = "iron-gear-wheel",    amount = 1000 }, -- piece(s) / real-wagon: 3000-6000
        { type = "fluid", name = "lava",               amount = 50000 }
    },
    results = { { type = "item", name = "fluid-wagon", amount = 1 } }
}
data.raw["recipe"]["fluid-wagon"] = recipe
