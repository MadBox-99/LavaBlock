return {
    type = "recipe",
    name = "bmat",
    category = "chemistry",
    enabled = false,
    energy_required = 5,
    surface_conditions = {
        { property = "pressure", min = 6000, max = 6000 },
        { property = "gravity",  min = 60,   max = 60   }
    },
    ingredients = {
        { type = "item",  name = "iron-plate", amount = 5 },
        { type = "item",  name = "stone",      amount = 5 },
        { type = "fluid", name = "lava",       amount = 200 },
    },
    results = {
        { type = "item", name = "bmat", amount = 10 },
    },
    icons = {
        {
            icon = "__base__/graphics/icons/iron-plate.png",
            icon_size = 64,
            tint = { r = 0.5, g = 0.55, b = 0.3, a = 1 }
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
