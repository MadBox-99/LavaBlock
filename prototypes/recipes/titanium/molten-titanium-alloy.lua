-- Molten titanium with an aluminium plate and a vanadium plate stirred in:
-- Ti-6Al-4V, rounded up from six per cent and four so that each is a whole
-- plate. Eighty units of titanium make a hundred of alloy, ten plates.
return {
    type = "recipe",
    name = "molten-titanium-alloy",
    categories = { "arc-smelting" },
    enabled = false,
    energy_required = 6,
    ingredients = {
        { type = "item",  name = "aluminium-plate", amount = 1 },
        { type = "item",  name = "vanadium-plate",  amount = 1 },
        { type = "fluid", name = "molten-titanium", amount = 80 },
    },
    results = {
        { type = "fluid", name = "molten-titanium-alloy", amount = 100, fluidbox_index = 1 },
    },
    allow_productivity = true,
    subgroup = "fluid-recipes",
    order = "n[alloy]-h[molten-titanium-alloy]",
}
