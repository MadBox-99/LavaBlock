-- Brine boiled down on the crystal hearth until the borax comes out of it.
-- Geothermal brine carries far more boron than sea water does, which is
-- why boron was first worked at volcanic springs.
--
-- 100 brine for two borax: a leaching plant's whole output every five
-- seconds feeds one hearth, and two borax are two boron.
return {
    type = "recipe",
    name = "borax-crystallizing",
    categories = { "lava-crystallizing" },
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "fluid", name = "brine", amount = 100 },
    },
    results = {
        { type = "item", name = "borax", amount = 2 },
    },
    crafting_machine_tint = {
        primary = { r = 0.90, g = 0.90, b = 0.86, a = 1.0 },
        secondary = { r = 0.58, g = 0.76, b = 0.84, a = 1.0 },
    },
    allow_productivity = true,
    subgroup = "lava-block-crystals",
    order = "0[growing]-k[borax]",
}
