-- Radon seeping out of uranium ore under water: the ore's radium decays
-- into it continuously, and water draws it off. Most of the ore comes
-- back; one in ten is spent.
--
-- Ten ore and 50 water for nine ore and 10 radon. The nine are ignored by
-- productivity, which multiplies the radon only - otherwise the tank would
-- make ore.
return {
    type = "recipe",
    name = "radon-emanation",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "item",  name = "uranium-ore", amount = 10 },
        { type = "fluid", name = "water",       amount = 50 },
    },
    results = {
        { type = "item",  name = "uranium-ore", amount = 9, ignored_by_productivity = 9 },
        { type = "fluid", name = "radon",       amount = 10 },
    },
    main_product = "radon",
    allow_productivity = false,
    auto_recycle = false,
    crafting_machine_tint = {
        primary = { r = 0.86, g = 0.47, b = 0.47, a = 1.0 },
        secondary = { r = 0.30, g = 0.90, b = 0.30, a = 1.0 },
    },
    subgroup = "lava-block-noble-gases",
    order = "a[gas]-z[argon]-d[radon]",
}
