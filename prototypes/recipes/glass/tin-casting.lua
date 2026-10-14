-- Molten tin poured into plate. Ten units a plate; the arithmetic against
-- the furnace is on cassiterite melting.
return {
    type = "recipe",
    name = "tin-casting",
    category = "crafting-with-fluid",
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "fluid", name = "molten-tin", amount = 10 },
    },
    results = {
        { type = "item", name = "tin-plate", amount = 1 },
    },
    allow_productivity = true,
    -- Tin plate keeps recycling into cassiterite.
    auto_recycle = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/tin-plate.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-tin.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "raw-material",
    order = "a[smelting]-d[tin-plate]-b[casting]",
}
