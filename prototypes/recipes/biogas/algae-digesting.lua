-- Green algae digested to methane. They break down faster than straw, as
-- they ferment faster: fifteen seconds against twenty, from four algae
-- where straw takes ten - the same pairing the fermentation recipes make,
-- and close enough in lava that which one a base runs is down to what it
-- already grows.
return {
    type = "recipe",
    name = "algae-digesting",
    categories = { "biomass-fermenting" },
    enabled = false,
    energy_required = 15,
    ingredients = {
        { type = "item",  name = "algae-green", amount = 4 },
        { type = "fluid", name = "water",       amount = 50 },
    },
    results = {
        { type = "fluid", name = "methane", amount = 50 },
    },
    allow_productivity = true,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/methane.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/items/algae-green.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "fluid-recipes",
    order = "b[ethanol]-g[algae-digesting]",
    crafting_machine_tint = {
        primary = { r = 0.40, g = 0.66, b = 0.26, a = 1.0 },
        secondary = { r = 0.96, g = 0.59, b = 0.20, a = 1.0 },
    },
}
