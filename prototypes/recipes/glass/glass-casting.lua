-- Molten glass rolled into sheet and cut. An assembler with a fluid input
-- does the pour, as it does the quartz lenses.
--
-- 25 a glass. The arithmetic against the furnace is on glass melting.
return {
    type = "recipe",
    name = "glass-casting",
    category = "crafting-with-fluid",
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "fluid", name = "molten-glass", amount = 25 },
    },
    results = {
        { type = "item", name = "glass", amount = 1 },
    },
    allow_productivity = true,
    -- Glass keeps recycling into silica crystal.
    auto_recycle = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/glass.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-glass.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "intermediate-product",
    order = "z[lavablock]-e[glass]-b[casting]",
}
