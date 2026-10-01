-- Grass Cultivation: straw for the adobe mix.
--
-- No seed, unlike tree cultivation. Grass is cut, not felled, and grows back
-- from the root, so a bed that has been planted once keeps coming; asking for
-- a seed per harvest would model a crop that has to be resown every time.
-- Water and the Arboretum's power are the whole cost.
--
-- Ten straw every ten seconds keeps one Pug Mill running on the straw recipe
-- (one straw a batch, a batch every four seconds) with a little over. That is
-- the rate it is set against; a grass bed that needs a second glasshouse per
-- mill would make the reinforced recipe not worth building.
return {
    type = "recipe",
    name = "grass-cultivation",
    categories = { "arboretum" },
    subgroup = "raw-material",
    order = "a[wood]-c[grass-cultivation]",
    enabled = false,
    energy_required = 10,
    ingredients = {
        { type = "fluid", name = "water", amount = 100 },
    },
    results = {
        { type = "item", name = "straw", amount = 10 },
    },
    allow_productivity = true,
    crafting_machine_tint = {
        primary = { r = 0.45, g = 0.70, b = 0.22, a = 1.0 },
        secondary = { r = 0.80, g = 0.68, b = 0.30, a = 1.0 },
    },
}
