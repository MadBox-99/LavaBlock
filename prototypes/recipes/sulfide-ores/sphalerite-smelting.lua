-- Sphalerite smelted down to molten zinc in the arc furnace, a coal to
-- reduce it. Zinc boils at 907 degrees, so the furnace runs it cool and
-- taps it at 430.
--
-- Four sphalerite for forty molten zinc, four plates' worth.
return {
    type = "recipe",
    name = "sphalerite-smelting",
    category = "arc-smelting",
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item", name = "sphalerite", amount = 4 },
        { type = "item", name = "coal",       amount = 1 },
    },
    results = {
        { type = "fluid", name = "molten-zinc", amount = 40, fluidbox_index = 1 },
    },
    allow_productivity = true,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-zinc.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/sphalerite.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "fluid-recipes",
    order = "m[melt]-b[molten-zinc]",
}
