return {
    type = "recipe",
    name = "rmat",
    category = "chemistry",
    enabled = false,
    energy_required = 12,
    surface_conditions = {
        { property = "pressure", min = 6000, max = 6000 },
        { property = "gravity",  min = 60,   max = 60   },
    },
    ingredients = {
        { type = "item",  name = "cmat",               amount = 5 },
        { type = "item",  name = "copper-plate",        amount = 5 },
        { type = "item",  name = "electronic-circuit",  amount = 3 },
        { type = "fluid", name = "lava",                amount = 300 },
    },
    results = {
        { type = "item", name = "rmat", amount = 5 },
    },
    icons = {
        {
            icon = "__base__/graphics/icons/copper-plate.png",
            icon_size = 64,
            tint = { r = 0.3, g = 0.4, b = 0.7, a = 1 },
        },
        {
            icon = "__base__/graphics/icons/steel-plate.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
            tint = { r = 0.35, g = 0.4, b = 0.3, a = 1 },
        },
    },
    allow_productivity = true,
}
