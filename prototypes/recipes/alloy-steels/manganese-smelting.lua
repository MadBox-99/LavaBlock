-- Slag reduced with coal in the arc furnace. Lava slag carries a few per
-- cent of manganese oxide, as steelmaking slag does, and under the arcs it
-- gives it up.
--
-- Five slag for ten molten manganese, a plate's worth: a thousand lava,
-- which is the price of a metal that is only a tenth of the steel it goes
-- into.
return {
    type = "recipe",
    name = "manganese-smelting",
    categories = { "arc-smelting" },
    enabled = false,
    energy_required = 4,
    ingredients = {
        { type = "item", name = "lava-slag", amount = 5 },
        { type = "item", name = "coal",      amount = 1 },
    },
    results = {
        { type = "fluid", name = "molten-manganese", amount = 10, fluidbox_index = 1 },
    },
    allow_productivity = true,
    icons = {
        { icon = "__LavaBlock-graphics__/graphics/icons/fluid/molten-manganese.png", icon_size = 64 },
        {
            icon = "__LavaBlock-graphics__/graphics/icons/parts/lava-slag.png",
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    subgroup = "fluid-recipes",
    order = "m[melt]-e[molten-manganese]",
}
