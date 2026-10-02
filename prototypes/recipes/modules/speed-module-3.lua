return {
    type = "recipe",
    name = "lava-speed-module-3",
    energy_required = 30,
    enabled = false,
    ingredients = {
        { type = "item",  name = "processing-unit",  amount = 20 },
        { type = "item",  name = "speed-module-2",   amount = 16 },
        { type = "item",  name = "tungsten-carbide", amount = 4 },
        { type = "fluid", name = "lava",             amount = 40000 }
    },
    results = {
        { type = "item", name = "speed-module-3", amount = 4 }
    },
    category = "crafting-with-fluid",
    allow_productivity = false,
    -- Recycling keeps returning the vanilla recipe's ingredients. Without
    -- this the recycler is built from this recipe instead, and hands back
    -- no advanced circuits at all.
    auto_recycle = false
}