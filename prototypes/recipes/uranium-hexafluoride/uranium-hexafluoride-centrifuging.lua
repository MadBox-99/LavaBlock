-- The gas centrifuge: uranium hexafluoride spun so fast that the heavier
-- uranium-238 molecules crowd to the wall and the lighter 235 can be drawn
-- off the middle. Every modern enrichment plant runs on it. The lava
-- centrifuge is the island's centrifuge with a fluid inlet.
--
-- 50 gas, ten ore's worth, gives a U-235 one run in a hundred, where the
-- vanilla centrifuge gives one in about 140 from the same ten ore - 43%
-- more U-235 an ore. The price is the hydrofluoric acid, four degassing
-- crafts of volcanic gas a run, and it does not replace the Kovarex
-- process, which is still the way to U-235 in bulk.
return {
    type = "recipe",
    name = "uranium-hexafluoride-centrifuging",
    category = "lava-centrifuge",
    enabled = false,
    energy_required = 12,
    ingredients = {
        { type = "fluid", name = "uranium-hexafluoride", amount = 50 },
    },
    results = {
        { type = "item", name = "uranium-235", amount = 1, probability = 0.01 },
        { type = "item", name = "uranium-238", amount = 1, probability = 0.99 },
    },
    allow_productivity = true,
    -- The uranium isotopes keep recycling the way they did.
    auto_recycle = false,
    icons = {
        {
            icon = "__base__/graphics/icons/uranium-235.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/uranium-hexafluoride.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "uranium-processing",
    order = "a[uranium-processing]-b[uranium-hexafluoride-centrifuging]",
    crafting_machine_tint = {
        primary = { r = 0.0, g = 1.0, b = 0.0, a = 1.0 },
        secondary = { r = 0.16, g = 0.90, b = 0.47, a = 1.0 },
    },
}
