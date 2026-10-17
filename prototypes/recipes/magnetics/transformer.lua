-- Two coils slid onto a stack of steel laminations, tanked and filled with
-- oil. The coils come off the winder; the core, the tank and the oil are
-- assembly, so this runs in an assembling machine with a fluid input.
return {
    type = "recipe",
    name = "transformer",
    categories = { "crafting-with-fluid" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "magnetic-coil", amount = 2 },
        { type = "item",  name = "steel-plate",   amount = 5 },
        { type = "fluid", name = "lubricant",     amount = 50 },
    },
    results = {
        { type = "item", name = "transformer", amount = 1 },
    },
    allow_productivity = true,
}
