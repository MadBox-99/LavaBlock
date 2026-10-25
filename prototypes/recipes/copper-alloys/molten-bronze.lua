-- Molten copper with a tin plate stirred in, nine to one: bronze, the
-- oldest alloy there is. Tin goes in as plate because molten tin only
-- comes much later, with float glass.
return {
    type = "recipe",
    name = "molten-bronze",
    categories = { "arc-smelting" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item",  name = "tin-plate",     amount = 1 },
        { type = "fluid", name = "molten-copper", amount = 90 },
    },
    results = {
        { type = "fluid", name = "molten-bronze", amount = 100, fluidbox_index = 1 },
    },
    allow_productivity = true,
    subgroup = "lava-block-alloy-melts",
    order = "n[alloy]-e[molten-bronze]",
}
