-- The magma reactor's fuel. What each part is for is on the item; what it
-- costs is the point of it. Four crystal-growing crafts and half a
-- magnetite craft a cell, at 90 cells an hour a reactor, is what stops
-- 1000 MW from being free on an island where lava is.
return {
    type = "recipe",
    name = "magma-cell",
    categories = { "crafting-with-fluid" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "magnetite",   amount = 1 },
        { type = "item",  name = "olivine",     amount = 2 },
        { type = "item",  name = "pyrite",      amount = 1 },
        { type = "fluid", name = "molten-iron", amount = 50 },
    },
    results = {
        { type = "item", name = "magma-cell", amount = 1 },
    },
    allow_productivity = true,
}
