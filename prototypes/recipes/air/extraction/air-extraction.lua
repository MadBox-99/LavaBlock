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
    -- The product with its input in the corner, the way every base-game
    -- fluid recipe is drawn.
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/air.png",
            icon_size = 64,
        },
        {
            icon = "__base__/graphics/icons/fluid/steam.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    categories = { "gas" },
    subgroup = "fluid-recipes"
}
return air_extraction