-- Ilmenite chlorinated with coal at red heat, the first half of the Kroll
-- and Hunter processes: chlorine takes the titanium off as tetrachloride
-- and the iron as ferric chloride, and the coal takes the oxygen.
--
-- Two ilmenite, a coal and 40 chlorine for 20 titanium tetrachloride and
-- 10 ferric chloride. The ferric chloride is not waste: it etches circuit
-- boards and precipitates magnetite.
--
-- No productivity: both products are fluids made out of a fluid, and the
-- ferric chloride goes back round towards brine and chlorine.
return {
    type = "recipe",
    name = "ilmenite-chlorination",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item",  name = "ilmenite", amount = 2 },
        { type = "item",  name = "coal",     amount = 1 },
        { type = "fluid", name = "chlorine", amount = 40 },
    },
    results = {
        { type = "fluid", name = "titanium-tetrachloride", amount = 20 },
        { type = "fluid", name = "ferric-chloride",        amount = 10 },
    },
    main_product = "titanium-tetrachloride",
    allow_productivity = false,
    crafting_machine_tint = {
        primary = { r = 0.86, g = 0.84, b = 0.62, a = 1.0 },
        secondary = { r = 0.80, g = 1.00, b = 0.50, a = 1.0 },
    },
    subgroup = "lava-block-metal-melts",
    order = "m[melt]-h[titanium-tetrachloride]",
}
