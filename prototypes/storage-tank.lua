local recipe = {
    type = "recipe",
    name = "storage-tank",
    energy_required = 30,
    enabled = false,
    category = "crafting-with-fluid",
    ingredients =
    {
        { type = "item",  name = "iron-plate", amount = 50 }, -- pneumatic brake system
        { type = "fluid", name = "lava",       amount = 50000 }
    },
    results = { { type = "item", name = "storage-tank", amount = 1 } }
}
data.raw["recipe"]["storage-tank"] = recipe
