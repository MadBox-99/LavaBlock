-- The good pass. Purified lava carries none of the iron and sulphur that
-- seed a hundred small grains in the raw melt, so the same hearth grows
-- fewer, larger crystals and throws almost nothing away: two and a half
-- times the yield off a third of the fluid.
--
-- That is a large jump, and it is meant to be - it is gated behind the
-- centrifuge, which is one of the most expensive buildings in the mod, and
-- purified lava is itself half of what went into making it. Counted back to
-- raw lava the recipe is 400 in for 5 out against 600 in for 2, so the real
-- gain is a little over three times, not seven.
return {
    type = "recipe",
    name = "silica-crystallizing-purified",
    category = "lava-crystallizing",
    subgroup = "raw-material",
    order = "b[silica-crystal]-b",
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "fluid", name = "purified-lava", amount = 200 },
    },
    results = {
        { type = "item", name = "silica-crystal", amount = 5 }
    },
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/silica-crystal.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/fluid/purified-lava.png",
            icon_size = 64,
            scale = 0.25,
            shift = { 8, -8 },
        },
    },
    crafting_machine_tint = {
        primary = { r = 0.62, g = 0.30, b = 0.95, a = 1.0 },
        secondary = { r = 1.00, g = 0.60, b = 0.00, a = 1.0 },
    },
    allow_productivity = true,
}
