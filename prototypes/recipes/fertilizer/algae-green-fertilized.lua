-- Green algae grown in water dosed with fertiliser: eight a craft where the
-- plain recipe gets five, for a fertiliser. The same trade as the
-- fertilised tree: more out of each tank, for nitrogen, phosphorus and
-- potash from elsewhere.
return {
    type = "recipe",
    name = "algae-green-fertilized",
    category = "algae-tank",
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "item",  name = "fertilizer", amount = 1 },
        { type = "fluid", name = "water",      amount = 100 },
        { type = "fluid", name = "lava",       amount = 100 },
    },
    results = {
        { type = "item", name = "algae-green", amount = 8 },
    },
    allow_productivity = true,
    auto_recycle = false,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/items/algae-green.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/fertilizer.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "raw-material",
    order = "a[algae]-a[algae-green]-b[fertilized]",
}
