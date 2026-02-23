return {
    type = "recipe",
    name = "assmat2",
    category = "chemistry",
    enabled = false,
    energy_required = 12,
    surface_conditions = {
        { property = "pressure", min = 6000, max = 6000 },
        { property = "gravity",  min = 60,   max = 60   },
    },
    ingredients = {
        { type = "item",  name = "assmat1", amount = 5 },
        { type = "item",  name = "cmat",    amount = 5 },
        { type = "fluid", name = "lava",    amount = 200 },
    },
    results = {
        { type = "item", name = "assmat2", amount = 5 },
    },
    icons = {
        {
            icon = "__base__/graphics/icons/iron-gear-wheel.png",
            icon_size = 64,
            tint = { r = 0.4, g = 0.6, b = 0.8, a = 1 },
        },
        {
            icon = "__base__/graphics/icons/iron-gear-wheel.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
            tint = { r = 0.6, g = 0.8, b = 0.4, a = 1 },
        },
    },
    allow_productivity = true,
}
