-- Molten nickel and molten chromium run together with cobalt, aluminium and
-- yttrium stirred in: a nickel superalloy, three parts nickel to one of
-- chromium with a few per cent of each of the rest, rounded to whole
-- plates. A hundred units, ten plates.
return {
    type = "recipe",
    name = "molten-superalloy",
    category = "arc-smelting",
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "item",  name = "cobalt-plate",    amount = 1 },
        { type = "item",  name = "aluminium-plate", amount = 1 },
        { type = "item",  name = "yttrium",         amount = 1 },
        { type = "fluid", name = "molten-nickel",   amount = 60 },
        { type = "fluid", name = "molten-chromium", amount = 20 },
    },
    results = {
        { type = "fluid", name = "molten-superalloy", amount = 100, fluidbox_index = 1 },
    },
    allow_productivity = true,
    subgroup = "fluid-recipes",
    order = "n[alloy]-i[molten-superalloy]",
}
