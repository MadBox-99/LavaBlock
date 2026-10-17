-- Purified lava spun hard in the lava centrifuge: monazite is twice as
-- dense as the melt around it and is thrown out to the wall, the way heavy
-- mineral sands are sorted out of a beach.
--
-- 1000 purified lava, two of the centrifuge's purification runs, for two
-- monazite.
return {
    type = "recipe",
    name = "monazite-separating",
    category = "lava-centrifuge",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "fluid", name = "purified-lava", amount = 1000 },
    },
    results = {
        { type = "item", name = "monazite", amount = 2 },
    },
    allow_productivity = true,
    crafting_machine_tint = {
        primary = { r = 0.70, g = 0.45, b = 0.20, a = 1.0 },
        secondary = { r = 0.80, g = 0.60, b = 0.30, a = 1.0 },
    },
    subgroup = "lava-centrifuge-recipes",
    order = "c[monazite]",
}
