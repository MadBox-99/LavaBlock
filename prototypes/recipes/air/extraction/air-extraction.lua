local air_extraction = {
    type = "recipe",
    name = "air-extraction",
    energy_required = 4,
    enabled = false,
    -- Air is not free: compressing it costs steam, which ties the "everything
    -- comes from lava" premise back into this branch. Without an input this
    -- recipe created matter out of nothing and made the whole lava economy
    -- redundant once air-cooler was researched.
    ingredients = {
        { type = "fluid", name = "steam", amount = 100 }
    },
    results = {
        { type = "fluid", name = "compressed-air", amount = 500 }
    },
    icon = "__LavaBlock__/graphics/icons/gas/compressed-air.png",
    icon_size = 128,
    category = "gas",
    subgroup = "fluid-recipes"
}
return air_extraction