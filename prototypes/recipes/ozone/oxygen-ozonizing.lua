-- Oxygen run through a silent electric discharge in a chemical plant:
-- three molecules of oxygen become two of ozone. Every ozone generator
-- works so.
--
-- 30 oxygen for 20 ozone, the real three to two. No productivity: one gas
-- into another.
return {
    type = "recipe",
    name = "oxygen-ozonizing",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "fluid", name = "oxygen", amount = 30 },
    },
    results = {
        { type = "fluid", name = "ozone", amount = 20 },
    },
    allow_productivity = false,
    crafting_machine_tint = {
        primary = { r = 0.55, g = 0.70, b = 0.95, a = 1.0 },
        secondary = { r = 0.80, g = 0.88, b = 1.00, a = 1.0 },
    },
    subgroup = "fluid-recipes",
    order = "a[gas]-y[ozone]",
}
