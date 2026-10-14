-- Neon out of air, on the air compressor, beside argon extraction and for
-- the same reason: pulling one gas out of a mixture is separation.
--
-- 1000 air for 5 neon, six seconds: an eighth of what argon extraction
-- gets from the same air. Real air holds five hundred times less neon than
-- argon, and played straight one laser source would take a quarter of a
-- million air. An eighth keeps it the worst trade on the air line without
-- making it a joke - a source takes 20 neon, 4000 air.
return {
    type = "recipe",
    name = "neon-extraction",
    category = "gas-mix",
    enabled = false,
    energy_required = 6,
    ingredients = {
        { type = "fluid", name = "air", amount = 1000 },
    },
    results = {
        { type = "fluid", name = "neon", amount = 5 },
    },
    allow_productivity = true,
    allow_quality = false,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/neon.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/air.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "fluid-recipes",
    order = "a[gas]-z[argon]-b[neon-extraction]",
}
