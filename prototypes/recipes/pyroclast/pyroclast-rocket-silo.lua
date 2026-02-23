return {
    type = "recipe",
    name = "pyroclast-rocket-silo",
    category = "crafting-with-fluid",
    enabled = false,
    energy_required = 30,
    surface_conditions = {
        { property = "pressure", min = 6000, max = 6000 },
        { property = "gravity",  min = 60,   max = 60   },
    },
    ingredients = {
        { type = "item",  name = "rocket-silo",       amount = 1 },
        { type = "item",  name = "assmat4",            amount = 20 },
        { type = "item",  name = "hemat",              amount = 10 },
        { type = "item",  name = "processing-unit",    amount = 100 },
        { type = "fluid", name = "lava",               amount = 5000 },
    },
    results = {
        { type = "item", name = "pyroclast-rocket-silo", amount = 1 },
    },
    icons = {
        {
            icon = "__base__/graphics/icons/rocket-silo.png",
            icon_size = 64,
            tint = { r = 0.9, g = 0.5, b = 0.2, a = 1 },
        },
        {
            icon = "__base__/graphics/icons/iron-gear-wheel.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
            tint = { r = 0.9, g = 0.7, b = 0.2, a = 1 },
        },
    },
    allow_productivity = false,
}
