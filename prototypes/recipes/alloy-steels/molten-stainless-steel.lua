-- Steel remelted under the arcs with molten chromium and nickel run in
-- straight from their own taps: 18/8 stainless, eighteen per cent chromium
-- and eight nickel, rounded here to whole plates - seven steel, two of
-- chromium and one of nickel make a hundred units, ten plates.
--
-- The two alloying metals go in as melts because that is how they come out
-- of the furnace; casting them only to melt them again would be work for
-- nothing.
return {
    type = "recipe",
    name = "molten-stainless-steel",
    categories = { "arc-smelting" },
    enabled = false,
    energy_required = 8,
    ingredients = {
        { type = "item",  name = "steel-plate",     amount = 7 },
        { type = "fluid", name = "molten-chromium", amount = 20 },
        { type = "fluid", name = "molten-nickel",   amount = 10 },
    },
    results = {
        { type = "fluid", name = "molten-stainless-steel", amount = 100, fluidbox_index = 1 },
    },
    allow_productivity = true,
    subgroup = "fluid-recipes",
    order = "n[alloy]-a[molten-stainless-steel]",
}
