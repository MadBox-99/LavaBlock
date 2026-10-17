-- Molten aluminium with a copper plate and a magnesium plate stirred in -
-- rounded up from the real four per cent of copper and one of magnesium so
-- that each is a whole plate. A hundred units, ten plates.
return {
    type = "recipe",
    name = "molten-duralumin",
    categories = { "arc-smelting" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item",  name = "copper-plate",     amount = 1 },
        { type = "item",  name = "magnesium-plate",  amount = 1 },
        { type = "fluid", name = "molten-aluminium", amount = 80 },
    },
    results = {
        { type = "fluid", name = "molten-duralumin", amount = 100, fluidbox_index = 1 },
    },
    allow_productivity = true,
    subgroup = "fluid-recipes",
    order = "n[alloy]-g[molten-duralumin]",
}
