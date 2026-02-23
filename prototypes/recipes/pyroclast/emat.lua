return {
    type = "recipe",
    name = "emat",
    category = "chemistry",
    enabled = false,
    energy_required = 10,
    surface_conditions = {
        { property = "pressure", min = 6000, max = 6000 },
        { property = "gravity",  min = 60,   max = 60   },
    },
    ingredients = {
        { type = "item",  name = "sulfur", amount = 3 },
        { type = "item",  name = "coal",   amount = 5 },
        { type = "fluid", name = "lava",   amount = 150 },
    },
    results = {
        { type = "item", name = "emat", amount = 5 },
    },
    icons = {
        {
            icon = "__base__/graphics/icons/explosives.png",
            icon_size = 64,
            tint = { r = 0.9, g = 0.4, b = 0.2, a = 1 },
        },
        {
            icon = "__space-age__/graphics/icons/fluid/lava.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    allow_productivity = true,
}
