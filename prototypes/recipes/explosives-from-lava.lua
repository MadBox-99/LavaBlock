return {
    type = "recipe",
    name = "explosives-from-lava",
    category = "chemistry",
    enabled = false,
    energy_required = 4,
    -- The vanilla recipe with lava in place of the water: the point is not
    -- needing water on Vulcanus. It took twice the sulfur and coal before,
    -- which made it worse than vanilla in everything but that.
    ingredients = {
        { type = "item", name = "sulfur", amount = 1 },
        { type = "item", name = "coal", amount = 1 },
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
