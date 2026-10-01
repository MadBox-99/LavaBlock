-- Green algae into wash. Algae have no lignin to break open, which is the
-- whole case for algae biofuel, so they ferment faster than either plant:
-- fifteen seconds against twenty, off four algae where wood takes five logs.
--
-- Four green algae cost about 310 lava by the arithmetic in
-- algae-processing.lua, against about 290 for the ten straw of the other
-- recipe - close enough that which one a base runs is decided by which
-- building it already has, not by the numbers.
return {
    type = "recipe",
    name = "algae-fermentation",
    categories = { "biomass-fermenting" },
    subgroup = "fluid-recipes",
    order = "b[ethanol]-c[algae-fermentation]",
    enabled = false,
    energy_required = 15,
    ingredients = {
        { type = "item",  name = "algae-green", amount = 4 },
        { type = "fluid", name = "water",       amount = 100 },
    },
    results = {
        { type = "fluid", name = "fermented-wash", amount = 100 },
    },
    allow_productivity = true,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/fermented-wash.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/items/algae-green.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    crafting_machine_tint = {
        primary = { r = 0.40, g = 0.66, b = 0.26, a = 1.0 },
        secondary = { r = 0.70, g = 0.84, b = 0.46, a = 1.0 },
    },
}
