return {
    type = "recipe",
    name = "cmat",
    category = "chemistry",
    enabled = false,
    energy_required = 8,
    surface_conditions = {
        { property = "pressure", min = 6000, max = 6000 },
        { property = "gravity",  min = 60,   max = 60   }
    },
    ingredients = {
        { type = "item", name = "bmat",        amount = 5 },
        { type = "item", name = "steel-plate",  amount = 3 },
        { type = "item", name = "stone-brick",  amount = 5 },
    },
    results = {
        { type = "item", name = "cmat", amount = 5 },
    },
    icons = {
        {
            icon = "__base__/graphics/icons/steel-plate.png",
            icon_size = 64,
            tint = { r = 0.35, g = 0.4, b = 0.3, a = 1 }
        },
        {
            icon = "__base__/graphics/icons/iron-plate.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
            tint = { r = 0.5, g = 0.55, b = 0.3, a = 1 }
        },
    },
    allow_productivity = true,
}
