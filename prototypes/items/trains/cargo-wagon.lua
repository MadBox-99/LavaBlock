local recipe = {
    type = "recipe",
    name = "cargo-wagon",
    energy_required = 30,
    enabled = false,
    category = "crafting-with-fluid",
    ingredients =
    {
        { type = "item",  name = "pipe",            amount = 100 },  -- pneumatic brake system
        { type = "item",  name = "engine-unit",     amount = 4 },    -- axle bearings, bogie parts
        { type = "item",  name = "iron-gear-wheel", amount = 1000 }, -- iron gear wheel
        { type = "item",  name = "iron-chest",      amount = 10 },   -- internal stowage + fittings
        { type = "fluid", name = "lava",            amount = 50000 }
    },
    results = { { type = "item", name = "cargo-wagon", amount = 1 } }
}
data.raw["recipe"]["cargo-wagon"] = recipe
