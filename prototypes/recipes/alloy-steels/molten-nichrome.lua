-- Molten nickel and molten chromium run together four to one, straight
-- from their taps. Fifty units in, fifty out.
return {
    type = "recipe",
    name = "molten-nichrome",
    categories = { "arc-smelting" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "fluid", name = "molten-nickel",   amount = 40 },
        { type = "fluid", name = "molten-chromium", amount = 10 },
    },
    results = {
        { type = "fluid", name = "molten-nichrome", amount = 50, fluidbox_index = 1 },
    },
    allow_productivity = true,
    subgroup = "fluid-recipes",
    order = "n[alloy]-c[molten-nichrome]",
}
