return {
    type = "recipe",
    name = "explosives-from-lava",
    category = "chemistry",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item", name = "sulfur", amount = 2 },
        { type = "item", name = "coal", amount = 2 },
        { type = "fluid", name = "lava", amount = 100 },
    },
    results = {
        { type = "item", name = "explosives", amount = 2 },
    },
    surface_conditions = {
        {
            property = "pressure",
            min = 4000,
            max = 4000,
        },
    },
    allow_productivity = true,
    icons = {
        {
            icon = "__base__/graphics/icons/explosives.png",
            icon_size = 64,
        },
        {
            icon = "__space-age__/graphics/icons/fluid/lava.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
}
