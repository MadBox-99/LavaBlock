-- Compressed air liquefied with liquid nitrogen and distilled in the
-- refinery's column: krypton and xenon boil last and collect at the
-- bottom, the nitrogen comes off the top. It is where all the world's
-- krypton and xenon come from, as a by-product of air separation.
--
-- 1000 compressed air and 50 liquid nitrogen for 10 krypton, 2 xenon and
-- 500 nitrogen every ten seconds. The nitrogen is five sixths of what the
-- air filter would sieve out of the same air, so the column is never only
-- for the rare gases. The xenon is a fifth of the krypton - richer than
-- the air's one in thirteen, because a game has to give some.
return {
    type = "recipe",
    name = "rare-gas-fractionation",
    categories = { "oil-processing" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "fluid", name = "compressed-air",  amount = 1000 },
        { type = "fluid", name = "liquid-nitrogen", amount = 50 },
    },
    results = {
        { type = "fluid", name = "krypton",  amount = 10 },
        { type = "fluid", name = "xenon",    amount = 2 },
        { type = "fluid", name = "nitrogen", amount = 500 },
    },
    -- Gases out of air: productivity would be free gas.
    allow_productivity = false,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/gas/xenon.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/gas/krypton.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "lava-block-noble-gases",
    order = "a[gas]-z[argon]-c[rare-gas-fractionation]",
}
