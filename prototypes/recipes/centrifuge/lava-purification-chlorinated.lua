-- Purification with a chlorine feed: the same centrifuge, less thrown away.
--
-- The plain recipe next door discards half the melt, because the iron and
-- sulphur it is trying to lose leave as part of the fraction it spins off.
-- Chlorine takes them out chemically instead: they leave as volatile
-- chlorides and the melt they were suspended in stays. That is how metals
-- are actually refined, and it is the reason the yield goes up rather than
-- the speed.
--
-- 1000 lava and 50 chlorine for 750 purified. Counted back to raw lava the
-- chlorine costs 125, so 1125 in for 750 out against 1000 in for 500: two
-- lava per purified becomes one and a half, a quarter less.
--
-- A quarter is worth a technology here for the same reason oxygen smelting
-- is worth one. Lava has never been scarce on this island; what is scarce
-- is the plumbing that moves it, and every recipe that asks for less of it
-- per craft is a row of pumps you do not have to build.
--
-- Slower than the plain pass on purpose, at 14 seconds against 10. Without
-- that the recipe would be strictly better in every dimension and there
-- would be no reason to keep a plain centrifuge running anywhere.
return {
    type = "recipe",
    name = "lava-purification-chlorinated",
    category = "lava-centrifuge",
    subgroup = "lava-centrifuge-recipes",
    order = "a[lava]-b[extraction]-b",
    enabled = false,
    energy_required = 14,
    ingredients = {
        { type = "fluid", name = "lava",     amount = 1000 },
        { type = "fluid", name = "chlorine", amount = 50 },
    },
    results = {
        { type = "fluid", name = "purified-lava", amount = 750 }
    },
    icons = {
        {
            icon = "__LavaBlock__/graphics/icons/fluid/purified-lava.png",
            icon_size = 64,
        },
        {
            icon = "__LavaBlock__/graphics/icons/gas/chlorine.png",
            icon_size = 64,
            scale = 0.25,
            shift = { 8, -8 },
        },
    },
    crafting_machine_tint = {
        primary = { r = 0.80, g = 1.00, b = 0.50, a = 1.0 },
        secondary = { r = 1.00, g = 0.60, b = 0.00, a = 1.0 },
    },
    -- Productivity, like the plain pass it sits next to. Denying it here
    -- would not make the recipe purer, it would make it pointless: a
    -- fully-beaconed plain centrifuge already turns 1000 lava into 750
    -- purified, which is exactly what this recipe does unmoduled.
    allow_productivity = true,
}
