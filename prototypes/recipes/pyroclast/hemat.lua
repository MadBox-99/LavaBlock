return {
    type = "recipe",
    name = "hemat",
    category = "chemistry",
    enabled = false,
    energy_required = 15,
    surface_conditions = {
        { property = "pressure", min = 6000, max = 6000 },
        { property = "gravity",  min = 60,   max = 60   },
    },
    ingredients = {
        { type = "item",  name = "emat", amount = 5 },
        { type = "item",  name = "rmat", amount = 5 },
        { type = "fluid", name = "lava", amount = 500 },
    },
    results = {
        { type = "item", name = "hemat", amount = 3 },
    },
    icons = {
        {
            icon = "__space-age__/graphics/icons/carbon.png",
            icon_size = 64,
            tint = { r = 0.7, g = 0.15, b = 0.15, a = 1 },
        },
        {
            icon = "__base__/graphics/icons/explosives.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
            tint = { r = 0.9, g = 0.4, b = 0.2, a = 1 },
        },
    },
    allow_productivity = true,
}
