-- Chlorine, washed out of the gas a lava pool gives off.
--
-- Real volcanoes vent hydrogen chloride along with the steam and the
-- sulphur, and this island is one enormous vent. Scrubbing that gas is
-- the ordinary way to catch it, so the recipe belongs in a chemical
-- plant rather than on any of the mod's own machines.
--
-- Until now chlorine was a fluid with no source at all - it existed in
-- Factoriopedia, it had a barrel recipe, and nothing in the game could
-- produce a single unit of it. Argon was in the same state until the air
-- compressor learned to separate it; this is the last one.
--
-- 100 lava for 40 chlorine is deliberately generous, because chlorine has
-- exactly one use and the interesting number is not this ratio but the one
-- it produces downstream: 50 chlorine costs 125 lava and saves 250 on a
-- purification run. Making the gas dear here would only move the whole
-- chlorinated route below break-even and there would be no point to it.
return {
    type = "recipe",
    name = "volcanic-gas-scrubbing",
    category = "chemistry",
    subgroup = "fluid-recipes",
    order = "a[gas]-z[chlorine]",
    enabled = false,
    energy_required = 3,
    ingredients = {
        { type = "fluid", name = "lava", amount = 100 },
    },
    results = {
        { type = "fluid", name = "chlorine", amount = 40 },
    },
    -- One fluid into another: productivity would be free matter, and
    -- quality does nothing on a fluid-only recipe.
    allow_productivity = false,
    allow_quality = false,
    always_show_products = true,
    icons = {
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/chlorine.png",
            icon_size = 64,
        },
        {
            icon = "__space-age__/graphics/icons/fluid/lava.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    crafting_machine_tint = {
        primary = { r = 0.80, g = 1.00, b = 0.50, a = 1.0 },
        secondary = { r = 0.90, g = 1.00, b = 0.70, a = 1.0 },
    },
}
