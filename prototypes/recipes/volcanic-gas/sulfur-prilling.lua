-- Liquid sulfur dropped down a tower and caught as pellets at the bottom.
-- An assembler with a fluid input stands in for the tower, as it does for
-- every other pour on the island.
--
-- Ten units a sulfur, the unit the Claus process counts in. One assembling
-- machine 2 prills 0.75 sulfur a second, and a refinery of volcanic gas
-- makes 0.45, so one machine serves a refinery with room to spare.
return {
    type = "recipe",
    name = "sulfur-prilling",
    categories = { "crafting-with-fluid" },
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = "fluid", name = "molten-sulfur", amount = 10 },
    },
    results = {
        { type = "item", name = "sulfur", amount = 1 },
    },
    -- Nothing turns sulfur back into molten sulfur, so there is no loop to
    -- farm.
    allow_productivity = true,
    auto_recycle = false,
    icons = {
        {
            icon = "__base__/graphics/icons/sulfur.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-sulfur.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "fluid-recipes",
    order = "c[volcanic-gas]-d[sulfur-prilling]",
}
