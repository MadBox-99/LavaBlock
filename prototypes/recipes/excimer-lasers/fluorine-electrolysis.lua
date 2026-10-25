-- Hydrofluoric acid split by a current into fluorine and hydrogen, as
-- Moissan first freed fluorine in 1886 and as it is still made. Space
-- Age's fluorine, so it is the same gas Aquilo's vents give off.
--
-- 40 acid for 20 fluorine and 20 hydrogen. No productivity: a fluid split
-- into two.
return {
    type = "recipe",
    name = "fluorine-electrolysis",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "fluid", name = "hydrofluoric-acid", amount = 40 },
    },
    results = {
        { type = "fluid", name = "fluorine", amount = 20 },
        { type = "fluid", name = "hydrogen", amount = 20 },
    },
    main_product = "fluorine",
    allow_productivity = false,
    crafting_machine_tint = {
        primary = { r = 0.90, g = 0.92, b = 0.55, a = 1.0 },
        secondary = { r = 0.80, g = 0.90, b = 1.00, a = 1.0 },
    },
    subgroup = "lava-block-noble-gases",
    order = "a[gas]-z[argon]-g[fluorine]",
}
