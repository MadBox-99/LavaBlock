-- Molten lead with tin plate stirred in, two to three, near the eutectic:
-- it melts at under two hundred degrees, low enough to join a chip to a
-- board without cooking either. Twenty molten lead and three tin make
-- fifty units, five bars.
--
-- Quick, because an arc furnace is far more heat than solder needs.
return {
    type = "recipe",
    name = "molten-solder",
    categories = { "arc-smelting" },
    enabled = false,
    energy_required = 2,
    ingredients = {
        { type = "item",  name = "tin-plate",   amount = 3 },
        { type = "fluid", name = "molten-lead", amount = 20 },
    },
    results = {
        { type = "fluid", name = "molten-solder", amount = 50, fluidbox_index = 1 },
    },
    allow_productivity = true,
    subgroup = "lava-block-alloy-melts",
    order = "n[alloy]-f[molten-solder]",
}
