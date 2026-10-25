-- Green algae grown in water dosed with fertiliser: twelve a craft where
-- the plain recipe gets five, for a fertiliser. The same trade as the
-- fertilised tree: more out of each tank, for nitrogen, phosphorus and
-- potash from elsewhere.
--
-- Not eight. Plain algae are water, lava and five seconds of a tank, and a
-- fertiliser - a quarter of a phosphorus behind it - cost more than the
-- three extra algae were worth, so the fertilised tank made dearer algae
-- than the plain one. Twelve makes each alga about a tenth cheaper.
return {
    type = "recipe",
    name = "algae-green-fertilized",
    categories = { "algae-tank" },
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "item",  name = "fertilizer", amount = 1 },
        { type = "fluid", name = "water",      amount = 100 },
        { type = "fluid", name = "lava",       amount = 100 },
    },
    results = {
        { type = "item", name = "algae-green", amount = 12 },
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
