-- Galena smelted down to molten lead in the arc furnace, with a coal to
-- take the sulfur's place and carry off the oxygen. Lead runs out of the
-- tap at 340 degrees, and is cast into plate or alloyed as it is.
--
-- Four galena for forty molten lead, which casts four plates: one plate a
-- galena, as the furnace gave before the melt came in.
return {
    type = "recipe",
    name = "galena-smelting",
    categories = { "arc-smelting" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item", name = "galena", amount = 4 },
        { type = "item", name = "coal",   amount = 1 },
    },
    results = {
        { type = "fluid", name = "molten-lead", amount = 40, fluidbox_index = 1 },
    },
    allow_productivity = true,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-lead.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/galena.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "lava-block-metal-melts",
    order = "m[melt]-a[molten-lead]",
}
