-- One landfill, fifty stone: the same stone the ten landfills were when a
-- landfill took five. Landfill is back at vanilla's price so that it is not
-- ten times cheaper off the island.
return {
    type = "recipe",
    name = "foundation-platform-nauvis",
    energy_required = 10,
    enabled = true,
    categories = { "crafting-with-fluid" },
    ingredients =
    {
        { type = "item",  name = "landfill",            amount = 1 },
        { type = "item",  name = "calcite",             amount = 100 },
        { type = "item",  name = "iron-plate",          amount = 100 },
        { type = "item",  name = "copper-plate",        amount = 100 },
        { type = "item",  name = "stone-brick",         amount = 100 },
        { type = "item",  name = "stone",               amount = 200 },
        { type = "item",  name = "foundation-catalyst", amount = 1 },
        { type = "fluid", name = "lava",                amount = 20000 }
    },
    results = { { type = "item", name = "foundation", amount = 1 } },
    surface_conditions = {
        { property = "pressure", min = 1000, max = 1000 },
        { property = "gravity",  min = 10,   max = 10 }
    },
}