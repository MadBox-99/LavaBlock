-- Magnetite stirred into lubricant in a chemical plant. NASA first made it
-- by grinding magnetite in oil for weeks. A little magnetite in a lot of
-- oil, because a real ferrofluid is only a few percent iron oxide.
--
-- Only machines take it, a hundred at a time at most, so one plant on a
-- slow recipe is all a base needs.
return {
    type = "recipe",
    name = "ferrofluid",
    categories = { "chemistry" },
    enabled = false,
    energy_required = 5,
    ingredients = {
        { type = "item",  name = "magnetite", amount = 1 },
        { type = "fluid", name = "lubricant", amount = 50 },
    },
    results = {
        { type = "fluid", name = "ferrofluid", amount = 50 },
    },
    allow_productivity = true,
    subgroup = "lava-block-solutions",
    order = "p[ferrofluid]",
    crafting_machine_tint = {
        primary = { r = 0.05, g = 0.055, b = 0.07, a = 1.0 },
        secondary = { r = 0.30, g = 0.32, b = 0.38, a = 1.0 },
        tertiary = { r = 0.20, g = 0.20, b = 0.22, a = 1.0 },
        quaternary = { r = 0.12, g = 0.12, b = 0.14, a = 1.0 },
    },
}
