-- Argon out of air, on the air compressor.
--
-- On that machine and not on the gas combiner, because pulling one gas out
-- of a mixture is separation and the combiner combines. The compressor
-- already extracts iron and copper from air, which is a far taller claim
-- than this one: argon really is about one per cent of the air, and the
-- yield here says so. Five hundred air for twenty argon is a deliberately
-- poor trade, and it is the whole reason argon feels like something you
-- run a dedicated line for.
--
-- Until now argon was a fluid with no source at all - it existed in
-- Factoriopedia, it had a barrel recipe, and nothing in the game could
-- produce a single unit of it.
return {
    type = "recipe",
    name = "argon-extraction",
    category = "gas-mix",
    subgroup = "fluid-recipes",
    order = "a[gas]-z[argon]",
    enabled = false,
    energy_required = 6,
    ingredients = {
        { type = "fluid", name = "air", amount = 500 },
    },
    results = {
        { type = "fluid", name = "argon", amount = 20 }
    },
    icon = "__LavaBlock__/graphics/icons/gas/argon.png",
    icon_size = 64,
    allow_productivity = true,
}
